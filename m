Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C3520CBA2
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 04:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgF2CC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 22:02:58 -0400
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:60993
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbgF2CC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jun 2020 22:02:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maJGTsTfIzF/Q9h+23lCIZiCR4OuhlTZ/NLXqNZ/fNvE9fZi/TJDo7B2FMPcHm8oDTiEFK5looaEmAkSA3Yx1g2cvQzdzd2K5WEZ8rrXtfLkICDPsbJkXU3lB72d6zOFa74haMR3t7vBEt8F8wPmtlfvr5tUHKNUJSN43T9EETsiOuCz/5/PLezMEw5wvScZ68NTOpJ47I8dPsxcu8LQImkO46TBFd7kB4EknDA+KxqXvmQysbmmvE5jrgIs8DtR3s0GEC4/5W6EP+B+WoMjbp90kzopiAVx14kE6cG/SJy34QsoijU7BTCUVbOu3fboEiF2arfW2737ygYQr1xYhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3jEr20mwdcV4t89uWUQHzQ9+TazWCvkuo4mo8Uaaeg=;
 b=VDQdN3mX5NLiB0JmsIbfxSDfoEF/6wo5uI80OBrzAVbQGO1ncxSaTcWx2dhOKdZpoNWQfzUahXMVOlripjShL8PuMn5VsbzaqmpDmY8p5Uh/QSDKCo/X2QnToLntRhUySgIteGW53fqryTb0VaBGbVIVGmWQCddzM45rZGEtbH5aM9fyDtrDoOp8rNX8pNTE7ADWW6PqAz3ZrRWlR45mnBXHooJIqDJMPVTIU5PaQf6lIHgJXo1D7TtSU6H0CVoMXR/OVBod8xUkw05uPLu/M7TL0c2Y2FY4U708JERZ268lxDSxQ8jwYUJoCjZ2TmzwPa2/aG22EJb+pbyMxfRK4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3jEr20mwdcV4t89uWUQHzQ9+TazWCvkuo4mo8Uaaeg=;
 b=SQOg2QEcCRnT/YHtbRj0Aj0cmCmpY2u8TsB3+9ik4zaiqlmIqpCk3gGPw71dpujU2WDO2BT9U9HGdJDggH+1Dqd00Zd8p+VqKMRYUu3Mo9GtvFLaR9oI6rAikwtphXylScqXviqoU3WjN0iQ+xWGCUlf/RaOn0HPz4Y8tL/VT1Y=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VI1PR04MB6030.eurprd04.prod.outlook.com (2603:10a6:803:f8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 02:02:53 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 02:02:53 +0000
From:   Po Liu <po.liu@nxp.com>
To:     dsahern@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, davem@davemloft.net, jhs@mojatatu.com,
        vlad@buslov.dev, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com
Subject: [v2,iproute2-next 2/2] action police: make 'mtu' could be set independently in police action
Date:   Mon, 29 Jun 2020 10:04:20 +0800
Message-Id: <20200629020420.30412-2-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200629020420.30412-1-po.liu@nxp.com>
References: <20200628014602.13002-1-po.liu@nxp.com>
 <20200629020420.30412-1-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0164.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::20) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tsn.ap.freescale.net (119.31.174.73) by SG2PR01CA0164.apcprd01.prod.exchangelabs.com (2603:1096:4:28::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Mon, 29 Jun 2020 02:02:49 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cd506474-2048-47cd-e2bf-08d81bd08875
X-MS-TrafficTypeDiagnostic: VI1PR04MB6030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6030BB4757AB9563C660B206926E0@VI1PR04MB6030.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 044968D9E1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RwuIDisFyYHFXK8QehrGOck5fXQYoc/2gOMsDVYDy7ftTOSaaU0m2y4jT/a1E9KuoRDe1sAKn5ASV2rtbLZ9KkrUJtxWL43ZSp34YtUxCmjHDm52v1jCaBINdGBHEwe+aldMqcB+dzsRMkbnQuHilKIf7cjHXYLRqzxzpftGFP4VGsGtLS17mouu6Q8/eH5Ug7TLM3ARzCH4K010q4vqjmx/zHkXc15ml/yQm+gCZkIZNnP6lYYEb8tly5Mz/lJP3j8i63HOOYbHTDItSgznmCI3HI/QPyCMgRV3QO3EQKhWZqtI6hn62On2qCtlH7aj0lQGklFlac9XGxbN0gweZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(1076003)(26005)(6486002)(16526019)(316002)(4744005)(5660300002)(8936002)(83380400001)(186003)(44832011)(956004)(8676002)(2616005)(2906002)(36756003)(66476007)(66946007)(66556008)(6506007)(4326008)(6666004)(6512007)(478600001)(86362001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LBwXkEO8vEB1tMo9bciU6BmGEaqVqdFXyf2n6PwX6u0qhR4ViEgrlzJ6QzDO6DG7OwYK/Andv6uoncv8LUCmcsKRMXGjDNG9wLXyDVT/R2mZypHEu1IXlMObHAuAJj86F5aLEKE+arNCBuSHhqNL9N3v/VYDewa6jk+KcNVuDhWutSfvzJ5KVQJ1S8ooC8o/TRPs/rhUMqDo1E3qF0vBvbTle7dxM6rjiuMZllZFwj/Adhjxj8bk/nCGyHFahZo4cFSQuXLaUm+dyvLloHuUngU9qOnli0Z9f/18TPBYxIWsLfEIcz62+RzaqLVglqRyZlq5RDuc7TODn3NNooUEeSAG4jBO5vzN2XFcbK3tp9Pk28VhN7AcbU/omXILosMfxMHfhbMfzjY5ol+DHHwGv2J9535dp1W9+yxnQCq/iAT6zl+QZn4QDzPQ25EI/I5XZ5Nv7JqcNdzXWj2Eadl4EiibktQ9NoB5ROfBOE98d+s=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd506474-2048-47cd-e2bf-08d81bd08875
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6496.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2020 02:02:53.3737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tP6LUuvPUjUPzNu6clG+fzpzFLARoq11xMYp4VD35socY93nlL56MFN01BOC4d5z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6030
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current police action must set 'rate' and 'burst'. 'mtu' parameter
set the max frame size and could be set alone without 'rate' and 'burst'
in some situation. Offloading to hardware for example, 'mtu' could limit
the flow max frame size.

Signed-off-by: Po Liu <po.liu@nxp.com>
---
v1->v2 changes:
- fix the print message style and add space acked by Stephen Hemminger <stephen@networkplumber.org>

 tc/m_police.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/m_police.c b/tc/m_police.c
index 7eb47f8e..83b25db4 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -161,8 +161,8 @@ action_ctrl_ok:
 		return -1;
 
 	/* Must at least do late binding, use TB or ewma policing */
-	if (!rate64 && !avrate && !p.index) {
-		fprintf(stderr, "'rate' or 'avrate' MUST be specified.\n");
+	if (!rate64 && !avrate && !p.index && !mtu) {
+		fprintf(stderr, "'rate' or 'avrate' or 'mtu' MUST be specified.\n");
 		return -1;
 	}
 
-- 
2.17.1

