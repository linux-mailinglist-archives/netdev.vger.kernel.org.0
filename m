Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D28F2CFE41
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgLETVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:21:48 -0500
Received: from mail-am6eur05on2114.outbound.protection.outlook.com ([40.107.22.114]:33377
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727233AbgLETUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:20:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsiBcEYWd7OCrnmZlbSYBUpDXSlKMyDIjloBy2uW6pOwNgbMtkvqablPY3I+1cUY7bCawyz9Wbmj5j5AzW1Wps8Im9Q0YDKqte2gwcDVQzP0X+A8uq+y7Ui+0l4tlLKcICmMBo/QzjVXqDyHBU/YX7izK5oYJ7aYjVfEMiVoR1coemXNz7XUB3aEOgs6pL6/Jq5cDVKaXPIYsA/d//GD+latj5IrM0GT3tdjoaGc6mLY7S3DdEvHsAiHJfImgdBDxXFp1W0NkMncjs8F1H8zISl8OBXxGyzr3Dxo08iJYhTJYpC8eA43gdHB/aGFL/itlXyQF0VH2FBYFR7ygVFE0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0K9ynC7FpPW3bXeUagPupFZFJ+6QApjQ6dO9f3UY+c8=;
 b=e/kRJDMzBSLDAx3dArgjw0epCQr8x/VgdY9JXL/iohr9lUkwIyasK9U6mjZFIDGxySg+WZFEbvjNUmNafbN6SiEB8G6vzCTT6BGg/7lzxppKvEOO5guYH0TqxVGlw65WJsDU/9QtBL+QzYkAedlQuUEMTOv6+P2p8sOSGM8HM9/VPPbrBmpXS5AoBSEdEfU8S/yDluZtQKRJxu5b7np1GVFvq3K+6jWWLEfYRbTNfQOslpQ0g43rc99/4OUsl4oWVmopKTQ20uNP3x0zetyrvfRq7zFnLnMcimouRzWQ0GjsdO3fHoDtsyuIUM4A8falh9e91TNMUP+iQxtVQe2dqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0K9ynC7FpPW3bXeUagPupFZFJ+6QApjQ6dO9f3UY+c8=;
 b=LmEA9knqDB5v6KtrJj5WzPNBFydCwFgAwEA57p0k1VAthx7Sd1h9mb8VCBR12CQ9XLOdm2XoEtB/KJ484B/Gz65KflUjyGbENsQrjiK+Ac2Y4OQO8ewL4w28jEmtaxjtQyYmP5iMl4DuaYpTDv0Vk28luPnoHny7oQUctGEolk4=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:28 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:28 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/20] ethernet: ucc_geth: constify ugeth_primary_info
Date:   Sat,  5 Dec 2020 20:17:36 +0100
Message-Id: <20201205191744.7847-14-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c96650d8-5fbd-4f8f-f63c-08d899528b8a
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB13635182B288C61A718E8D9693F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x2XV+HXFsl3gwwtIMr49e22q72ItTHKjKG+XjPR5+3S/pMFwAB1cjJdG0VefcBg8qMxGT1YmBWn47Un0uAY3sJ7tOSKtExbz/0kMX7Jd4taTkelQEqoNTv/qTsw1Q4eAUYsgI0aNt8LdJ63dHysv5+HIlWo1o8pmGToPCBalnhHEhtQSjmNgOU2gNXJo709el7QxMlttS/LeDvJX25e7B4bNnJ5O6z+hIMzXlMBJSJnoc5aKvdXwr9ckXkaez56RXI6AP5WjfzHE179rjyfH2ArKDS8dcugIyov1vCuG6MgPeNXhXNAfTRhuG6G8WC3XoO422+tldQO+PBSFybHkBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(4744005)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lY+XTcjuBM76HJO91MK6EOs+yk9T+kzvrE/pNbwdJwoAXQppk+JulH7KH2xP?=
 =?us-ascii?Q?hMs0uFrZorKp0Z1R9b+n9SOCuGnRWIeDE3vWbcK8ajjxAvOZpH2cDEj2yh1t?=
 =?us-ascii?Q?WMM4HoGe78KhcaKKMELP+owt6LegGbK85uWOgENCtZ3Ortj8Z6ELxnc1OzMV?=
 =?us-ascii?Q?joJYFWDLg3CcC3mNgEQV/AB692glIEdRRYt77lPVhbnUVWkV9aqtFodyBbC8?=
 =?us-ascii?Q?Zgijqh6B0qIL7w4+ArQ0kmWlX5dtlTafjE4fFynWf4Q53ozczE4JuHhpjNjg?=
 =?us-ascii?Q?TUhKmNOySHA62yhdVTrUcWewiI0cgEu0QQFl3zfqhyzRoe8OyQEsFL6CeLvj?=
 =?us-ascii?Q?+8RSv7Vc2nlFw3UDPrzehJVkXGFeJSpC3GEUhNA0sHpJkv+xxtx5oJG6REkL?=
 =?us-ascii?Q?opt1KBx+Omb3Ri7NxzaC9zOL/Y0dR8KUbaahKgbjAnj/GFMkO0agQdxAPR5C?=
 =?us-ascii?Q?eC9CFRp1+92+xUyD+PFFtRfSWWs7ptm+1gxICLqC4zvyvaCqr6O4HK2DB0kk?=
 =?us-ascii?Q?cErCEt7muR0g4PAi8XdbAH3NWZYzLUnnZmdxLyLuEjBCdiWzGI94RuSoexF5?=
 =?us-ascii?Q?ZwAX+QfaFH7fcBeiC5pjKBvIQIKW1KARFgPxLRbPoJ6ipRYNnGLCSs05g5yQ?=
 =?us-ascii?Q?6F7fKDTsx/DtFm7y2Fex7uy7fUbn4briRqzs/WKAMODNEAXzzNkatMCmNddT?=
 =?us-ascii?Q?FPIrIJUeOp+fv0fyouyCDMH7Bq2TNZjH9sdaMJsxpfIgUIZboxUkVK8Na2X4?=
 =?us-ascii?Q?QqpEHeatH3kqkFBvgWOkrGFar506WLnEBCg1xihWmDqSr69YBWBVbd0wKkqH?=
 =?us-ascii?Q?lhMsBEHJNxd9xeN2x/zRK9FQ1lDz2JVBDZaFV3iumfqBhxCJcWrJHG/B7kAR?=
 =?us-ascii?Q?h3NFcmZDpy3QIr0mr1WKdRMWq0sMGf0IIBOpJRutcBhjIKf1vHD7A9tcjM5w?=
 =?us-ascii?Q?4/vb/hGOor699/3dIy0kN6CZVH7F1EzwVFhwJzvFgpz52MNXyK280Iuh9lrv?=
 =?us-ascii?Q?vK9Q?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: c96650d8-5fbd-4f8f-f63c-08d899528b8a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:28.1752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mS/40pqb/q/ijE4bvbXlVqY4K/iOg6r76W0JJTEboH+OKorUZRlNQCMro3ZsP7TUNdAn1SrKa1AqLA+QUttl3ksi035qMwqQea/TWYRoq4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 700eafef4921..a06744d8b4af 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -70,7 +70,7 @@ static struct {
 module_param_named(debug, debug.msg_enable, int, 0);
 MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., 0xffff=all)");
 
-static struct ucc_geth_info ugeth_primary_info = {
+static const struct ucc_geth_info ugeth_primary_info = {
 	.uf_info = {
 		    .bd_mem_part = MEM_PART_SYSTEM,
 		    .rtsm = UCC_FAST_SEND_IDLES_BETWEEN_FRAMES,
-- 
2.23.0

