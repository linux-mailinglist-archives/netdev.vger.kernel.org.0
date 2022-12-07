Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A1E64555D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 09:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiLGIWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 03:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiLGIWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 03:22:40 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D050C2DDF
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 00:22:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgdjOtpySfcHiMdv3H3LEN5FxE8T0nl5p+Ttwn1vZiZl1sRatq6tQiYqTpHRlDQqUSs9j9qqSqSrKNo2SE7QfHL/iaFvmRmoP5aiqLiaZo3Hsd1Zp1zFrzSsL8aj8gWONXHZAF1q4e1yM5vTd3rPTAb5GL52WBRv1HmrtObKqK+tyjb2OUtJLePYGbe+/s7loH9GVEv8NsQDPyzzGgYtntM1srngiMaO/2/LsKvpZ2lW5pBlCWIMgkKcH4/atP/QbU9TnSwYDtZfZpVQhFHYHp3+kr19k1dVfCwZFx8xN+3hkiGgtPRkNVDip7b6RcZ66jK2x38wA79dGVpIHUnU1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91aWAFM34usa7EyDIRc45iUAk+bCWuNwDgpyupOam0Q=;
 b=aK749B9U3eTkA8atjzqJZJLzGaDntBI7Wbub9AcWdMVpyM6zZSGv5d3gOiKsAd3AvcsER1Yo1n/k2McuujsSG5NuJtPtX1ynSfDQKXvMZAJGzpeYDTJTvgAR6KfqdiOzG130asXU4I89X806eRXXmXpwoIFpCtfZ9QK/2sRST0n9jjem4Tb2icU4ythnQbEsy6QlhF5a57ilq1mL/Rw90fd0RMtUqqkd+TUtdabvRwZHTccozKhLB1X2gSat1oBq9zU5R6OnEmmLSCZVzsZ45WIQ6N7z1+QcTAGVbrhPrKaKHD+O1KYv169E5va4hJyH/mFAqyU9hAPspJGgsLiqbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91aWAFM34usa7EyDIRc45iUAk+bCWuNwDgpyupOam0Q=;
 b=cSoWgzPr2DgqaTFRR+glyJYtkTKBkjvO2dpctSv4N0T7J4dQ3ytwFOlZ/B+BFOYjuv5lrqD1itlrhHLnHWjjd2DWNVD3JI6pbuccJ9IoxVUuD519QbMS1mTPQDPVTVyp09QIqhZSPyUXaHV9ZqFAV3JfKe1G81uVPIjnclKYv9Y7iNf57I84STh/RelQV0wnFm34fVAMGFCCRZ2aBgG4R2yFDBZTEN6679uEgpeHcWtu2SC3/VLn4UuQ8gs7lEJm3a85OJ0q7QU4p++xqtNNSjNB42LITRelYLT42Bxym44NtQNDpu0RQF26aDnrngCx/jNMrDGtHgMxAk/NN4N4ZQ==
Received: from DM6PR21CA0006.namprd21.prod.outlook.com (2603:10b6:5:174::16)
 by CH3PR12MB8281.namprd12.prod.outlook.com (2603:10b6:610:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 08:22:37 +0000
Received: from DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::50) by DM6PR21CA0006.outlook.office365.com
 (2603:10b6:5:174::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.4 via Frontend
 Transport; Wed, 7 Dec 2022 08:22:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT098.mail.protection.outlook.com (10.13.173.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.15 via Frontend Transport; Wed, 7 Dec 2022 08:22:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 00:22:20 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 00:22:20 -0800
Received: from dev-r-vrt-138.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Wed, 7 Dec 2022 00:22:18 -0800
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2 1/1] tc: ct: Fix invalid pointer dereference
Date:   Wed, 7 Dec 2022 10:22:13 +0200
Message-ID: <20221207082213.707577-1-roid@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT098:EE_|CH3PR12MB8281:EE_
X-MS-Office365-Filtering-Correlation-Id: 77347c76-31ab-430e-f598-08dad82c32ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kb5gm/S6oebuXsqOdbAHUKM4q1hKa/IpZyapAuKqdo1hTAPf/Wv2FIbkYH4hrVL9hIoGUXd6XitxlrXXVwRcvPYbgogygbnHdy8d0HH9fJpUVWu3vQTrynNG8EzGC6yPPIgIORZM7TrJUR1PYudH2p2Tuv829RnuZZphGWq9b8CQT+tbHGDPh2ifqLVwm99hQs6sTlavqMgZdH3I4CJg0V2ylkhXFH0gwJQDVAXqObtbI6wUfaO6KlWPkPvedr6iTjT+Oz5rzxxNhKCw42lm14X1jWEgvV/w8CrnmrdtSTcb0EGlXaVQAP0ZfGCMmNHzAePElcpSIDFnRSYFee+L0ruoP/gxR5BCInFv9cRrSY1nYTcRDI7uM3+oByk+n7Xyw3V9FGTuywQMIel+NiF39GGju194WxycSgMHHQ73idXOxICEcebB0bv63vcxeIfI9eQncYiAgFENsd0yA+q7QgLj9ohdSFsPZlMODpvhC7oJaavLZ3cNedyqSwODRVWvsvOytWuwiKROzn+E3fQiGsu92Zdk8PMIIh1E64ZOyxi4ZoRyLJi9l75L/A/TorAd+w0E2DTeDC2jDs5aETfZSL6LG36Jrpwl6uoi6UruAX58Aqc95OBzsfA/NJhgwaGSbXdDYm4Gj9/QOYwfqSKyTYNi/kwpr//9gS8r6N+FffKw54F/a7Tp11CMfy7i3erTBeeYxK4TtG/eAtcQQxRWkg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(376002)(396003)(451199015)(36840700001)(40470700004)(46966006)(36860700001)(83380400001)(356005)(7636003)(40460700003)(8936002)(86362001)(5660300002)(2906002)(4744005)(4326008)(41300700001)(478600001)(186003)(40480700001)(82310400005)(26005)(336012)(1076003)(426003)(6666004)(47076005)(2616005)(8676002)(6916009)(54906003)(70206006)(70586007)(316002)(82740400003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 08:22:36.9309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77347c76-31ab-430e-f598-08dad82c32ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8281
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using macro NEXT_ARG_FWD does not validate argc.
Use macro NEXT_ARG which validates argc while parsing args
in the same loop iteration.

Fixes: c8a494314c40 ("tc: Introduce tc ct action")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 tc/m_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/m_ct.c b/tc/m_ct.c
index a02bf0cc1655..54d64867abcb 100644
--- a/tc/m_ct.c
+++ b/tc/m_ct.c
@@ -243,7 +243,7 @@ parse_ct(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 				return -1;
 			}
 
-			NEXT_ARG_FWD();
+			NEXT_ARG();
 			if (matches(*argv, "port") != 0)
 				continue;
 
-- 
2.38.0

