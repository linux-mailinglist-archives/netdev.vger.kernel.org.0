Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD63948A4BD
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346102AbiAKBJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:09:47 -0500
Received: from mail-eopbgr50135.outbound.protection.outlook.com ([40.107.5.135]:34464
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243225AbiAKBJr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 20:09:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdP1yC4INGQuylY4tand0mM6t5EjjXA0V0Sq9sky5jXanLOgXLo5py3GcYJzm77JEwU0QzOss+TyOhEJDB9dMDYZWhhN4XNunvgrzRFqAgFuBdjN+Yv5Sl07uPMsBHnGWP5wyfiB78WiaTUAsg7jQea00Va7tCITe8oMtF7BNsftxT41DdKDp2ROdelqa0yMgV9aNkjaZE2XbIwbhf9Ln7ZYOwid2XW0+PAiQVQDKHGqCqwTU6g5jG4VVAdl1jWz6hYSfWb+cPIyCmtrSw4BsWbgDxmhmGNjU39Y2LEiA8MiB53ENIFrFNmgfQDtglIBci2vA9Hm3RK+mM0sDPCnig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSqfBd9mT6xWxEabtd47iPDmGo7OmqydV7/LQmdp92U=;
 b=SddB9kKe6plxok3zh02kIQJHj4nIhaNEVxW9zPkuYHXSYtlbz9REUajZCmxOmAFtFd86XTkJmBCSzCWifLzuEZ7gbNaMkTG7Xsi/5Jn4Q5i9SD//2fDTye1UZribpln2CjglCOIGAKGIgsCQxO9zkkIIE5+iQAQYLevlGbOA/4qIkjpzonD+wLZXu9N6Eh5SRBmHMBbcZ9G9HvKOjufAI7V/ChxMJ2irQaiqNSJVlhMng1lTwX0PlL8D/dYydovHhYZaq2dIGUA+O7q9tyoi7cNVieqNwuquSajjrHw6b4X5Ozn7cMgw08zXufRh4Qr2nBJVnY0JFBr+yn6YbdvzVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSqfBd9mT6xWxEabtd47iPDmGo7OmqydV7/LQmdp92U=;
 b=rfPb5Lw8G7clOsRrlePt+KKzDWwYaNDXqu4NYv3YrBdEC0WCyLpRqyu+8BHG41I6uWEBYljg/Z9sGGgJZIUIwxDgPJXuH4SLJapkwa64UITFLN1zT/4S37vWKA6x8lu9DKGHAAK1K/4nm6u68LoELZ5cC3uSbv2vjoBgQITHogk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM0P190MB0753.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 01:09:43 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 01:09:43 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        idosch@idosch.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: marvell: prestera: Cleanup router struct
Date:   Tue, 11 Jan 2022 03:08:26 +0200
Message-Id: <20220111010826.3779-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0047.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::18) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 517b96aa-fcb4-4fe2-0d28-08d9d49f0d06
X-MS-TrafficTypeDiagnostic: AM0P190MB0753:EE_
X-Microsoft-Antispam-PRVS: <AM0P190MB0753E9C57F6EA2391BDC558E93519@AM0P190MB0753.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tXiCKl2Ob4KPgVWLnyYGZS0yQIVkul8ICa0J21ls80nOZEShF9WbfjhUZ/DTV6LCUCmqVTugvxNjbb05YXDdO61GQHC5/NybEbr8GslmqA/q8ekUeP+mJ4i9A9QmXsLDTgJBwwo4cxvh30YM7rF/xZf+FoLHHh/dYSEbEZqOadosfVC2bqW23jGdVenjjmVA2qjIQ2N43PP8Ofog6etkyDsnb2lmf5Z7kdUdL+xBCLje+AWa8yl1SdGAZexHGWkB4OlZGE7/qA8wILGwCo2d6F8j5rFvl1jqIyb+F6NlIF4EnM4jJvZZ+bHwzw6sneTdA9lhPBOfqb1sKB9sHez082VILQWMkgQRGyfXpDjgwIQbkCVeYy4cDcXNiAOdM5BFN7BsnsNk6TOVjLRQDqXUb8lYmfi9CEy9GIBqTF14PAdAssh8+SARrha1b+684fiLBLOw/3MA6+rjCmTou86bdwdYSuSxZss1mmb1uyG01aMW0Y2rIRhKI4pl5kDlTelEW5boN48pqSvjO3TE99f6yHl9dP6nztBIMcgqKVJSmlXHsPmAdJrtGtAACeFM/rOfsEy6gbsNV32I7hr2jKWZoXzT0FZlBwrV0oTF+i7pb2v+7Qb8b+FHpfrl785r3j0U4rKa5w1kOj67GHKp/jhk00Ou8tqkOwV7MASdoR5Gdrz9vleP3a5PhPvPwtjy1f92HuhwaphUHu2+I6BW41AOgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(136003)(376002)(39830400003)(1076003)(83380400001)(4744005)(6486002)(54906003)(66574015)(36756003)(52116002)(66946007)(8676002)(86362001)(316002)(8936002)(6506007)(66476007)(66556008)(6666004)(6512007)(4326008)(2616005)(38100700002)(5660300002)(2906002)(38350700002)(26005)(508600001)(44832011)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jiWr0nnkL8+JrRmqwBrA7ZGfsB+jwiM+8CTdHWPQ+J43Ku46L6djmAdwvwU4?=
 =?us-ascii?Q?+xDUGQP2jtU1q8xTzSSxJWy0lPed0bGN5r8nzGgmYRNgDELcWDwV17b+7xSo?=
 =?us-ascii?Q?UyRebTzi0uswS3+8fP8WzNoEQTJZzjEsoswfuCp80caz+WbRChnRyPzpzuSG?=
 =?us-ascii?Q?sziahNiBXhhgjtZ+W4HEZ2yoKDNaBG/iMCcIoxO7CrArQskKIGHPLWd2gy81?=
 =?us-ascii?Q?8vFSTqYYsm6UJIDLHPdQZKPJkhfVClyuj5U3Ue7Rb2xlnt4s8OlrAwZb+eB3?=
 =?us-ascii?Q?nox5I2oz5reVSJevpCstgc59sa6G+7d8CGWrdMFSjKFEq3kpoytP/2rGMIF1?=
 =?us-ascii?Q?rBGi9Z3PofcJRmrmzaHmE7qUIP3fS4qhK09nnOxLFqmc5CLtohGI+ptSqIxj?=
 =?us-ascii?Q?th7EVAt0r6DRzAx3739Soln8hh937YDByxeN4YagZPvW1F7xqTj9ShERy0Gs?=
 =?us-ascii?Q?ks6dpW97UwTr0ITUOiiPthUX4yL3RJkqTV93yiHGkMCNywIIC1y2wkLsvwBA?=
 =?us-ascii?Q?QNN3GL0f4a8z19Sssffo4KZO8s4ftp4VXweNSRyYMz+ULRzLyKl2B0nLlBcb?=
 =?us-ascii?Q?k9gzV26dKMS8D5KHcYptLWuOHvvtJUP1WMgmmRupAFDpzUoEIDHsFA64+5wK?=
 =?us-ascii?Q?Ts+QUmdTUw7zYpQGIxUn1MXfeTVbMYJo+jEeKQBsIpPcLyN6m5RoXDaP83+/?=
 =?us-ascii?Q?2JUt422eQNFB250+kDNBr3bt0m5r+vS7lpAQatCzDk7uwUV7v72S1LIEF/Sg?=
 =?us-ascii?Q?kbjE1FyaY5j6y8zn/iCEkduSpxKrnJaW0fBXrMs+Bpd50p6jxFs4pPYuGWgr?=
 =?us-ascii?Q?nmWiKl/yPvZLbQgNeku2D0jOhQaBxU3C3jK9TZ0WFMU/IEImTD5r0lANGVG4?=
 =?us-ascii?Q?pKEdkEN8NWsA2EBm2/sSKWW1Zl/75vAOaAZQzHrPnNDiXiaeYs+cbRMZ9fkN?=
 =?us-ascii?Q?JvWpxl+k66RffUklZ/XJLTSjFMhcLaLqae9jKMaWxJPWG0yQ/u3uhN0+wUTQ?=
 =?us-ascii?Q?IEEDSE/u2tGHbwFb0u56YODz2ZTzDEbmXHYzmYgT6BX1OEy1877Y6AC4JD1k?=
 =?us-ascii?Q?RCR+lrSJERjlmkrcdSDdhtrwiCpN6uLMPX8nX9jRhS67ds81gFRKyUkIbAEr?=
 =?us-ascii?Q?CFmac3QeBTb3o/Lk4ZMri7xLXxtyPrx11+rVBLrBpAjBxK7UJAlb/oOK5iIk?=
 =?us-ascii?Q?Hxooufltfy/nn2HztJSb0jbzqPhlJr9Wznagt1qUd5yL8ZLDe73C19OiiCyq?=
 =?us-ascii?Q?WOGzqzfaccjm0n68+9HSt/s7cZ7H4a0aGW2IWepnXgtUeXa+lTng8L7LKhDc?=
 =?us-ascii?Q?cCdKbGaXx/m1RKoIAaoXyvkyy2C6abscbgbjstspD2orytWkRP0OxaWRomX4?=
 =?us-ascii?Q?YdbxRtbhLayRMVrjszgl3oMfcKNbZ65oNR1+F6r0mf/h/aMMtC9A/lP6Hk0g?=
 =?us-ascii?Q?fASwfsrAsWwELSlvOdjigdgxx/6tuyUr86jviU6Aaanw05kfISvzVxA6yL9S?=
 =?us-ascii?Q?Zti+dzr7EyJxTs8VJlS0WYy88cSu98JM1tVZWxuY8HVTUXfOSM7SS0cOR4KK?=
 =?us-ascii?Q?3645wY8mqAcKI+GKUzL3yrXhnKrrGiR8ykdnMCN/kuBjqNUmF4nv2RafUjpP?=
 =?us-ascii?Q?fiIpSyVlaGLjqHkMnM/XUxDT6vKRGgYCbQxWPpmydF4EV3abJEA6rtq1HWKs?=
 =?us-ascii?Q?+IT/Og=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 517b96aa-fcb4-4fe2-0d28-08d9d49f0d06
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 01:09:43.4587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jk3KXpbAKewNijhWONswW+H0LsgEnrIrxTlqIBkRa5DAYueosC3eb/v0Hj4n/P2VKMMJyc+/RhC1rwNC7SKebL3FVrus6IkhvY3du+GhJ7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0753
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Field "aborted" was added in
69204174cc5c ("net: marvell: prestera: Add prestera router infra").
It will not be used. So remove.

Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index a0a5a8e6bd8c..2fd9ef2fe5d6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -283,7 +283,6 @@ struct prestera_router {
 	struct list_head rif_entry_list;
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inetaddr_valid_nb;
-	bool aborted;
 };
 
 struct prestera_rxtx_params {
-- 
2.17.1

