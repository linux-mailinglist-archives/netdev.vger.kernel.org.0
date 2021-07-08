Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208083BF670
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhGHHuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:50:22 -0400
Received: from mail-co1nam11on2059.outbound.protection.outlook.com ([40.107.220.59]:24467
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229851AbhGHHuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 03:50:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dovtxZXUt9qOlt0/HFmnW+R6dqK2VDx/dxdcIuCMxCo5cpilpEqyFPJnNa3gK66MG2YjVcq8Q4m/JQHwBESmpzYciEB5Zw/onbaGq52ev+ngIHrao6nTIqY16Tu7+BnE1fIIQenEoYhxi137qpRQbywufWA/7ERDCXvRmvkgZTEXQsQxnf1IvpBZ8UbAofOAycgFBAhgIQAskUG4MEMqbg3O96QwEMKDkLfARTSI2vzY3SivqKQUDPjfu5ltSydCeNkw31aYE7DGZrp6zou+4jc/d/oZhEGlov9/fxfeCeocZJd2CMI+N6h/N4btPTo2q/PtKB+AQmegqWDWF5qHcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xo7dISqNlE/ZZrtPeTcq67VeLOWWkfXFNUN5wu5qlNU=;
 b=lfX00hxjm2tbcNEaqWnW5JI/jhvC6tsLKDdY5xnEOltHPPA6N9kPZFpzEkz4uHmywXz0ng2jd7SrcTKkvak7tRO4pBLq8OhjRujz4OVluXsTl+mHfxjx1NylRVSn2/kzPAIz/qbKLM0mLBZKT/z9LPUVMgGN5MzH8hOPONlgNTLzddGVPYx3YDEvBmdKaTS/q4BMkJt9vgQDbgUKWARTdMWGglgGnRdSS+gxaTswG544MjrDf/tLZqzMPriHIpC000zLNBPRMBiSsYRqLwNUF5oyo0iEcyE++FcFpnPMyLuDcW7UyHIqMlrzC5NrlxFpPmUgAPC0Xy4cvb+4mszqrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xo7dISqNlE/ZZrtPeTcq67VeLOWWkfXFNUN5wu5qlNU=;
 b=hRnIsQEdHjOVmxpr/KKKhbUPlv1TsgY1rpSHKmBkypbO/D3VKamLmxGDonsxS8kSa2YkZV660JwIKmlEnv446ap1vQ7BChgE3i5J21PeL6IvXUijI9cBz/eXLjVQq6tXcj2ACnFmk/THwXlJSX+4GwPpEmELtLv2LCTRnJC9wN3oejWJahOS8BfpDAi/f1enBB3l1W5DbAb0pmNqgWp1UTJcRTSGmHpprIGvQyhXLtkPNf1/EnR1SV4ZSihq2kml+rc30yePz7qjO+3aHxI0rC2w0Yj3r+35t6hobMmMSj8J5kGvzYNvUsY/zst3GP4AlVzJSzCymbrR6PjrEliITA==
Received: from MWHPR07CA0009.namprd07.prod.outlook.com (2603:10b6:300:116::19)
 by BL0PR12MB4675.namprd12.prod.outlook.com (2603:10b6:207:35::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.27; Thu, 8 Jul
 2021 07:47:38 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:116:cafe::29) by MWHPR07CA0009.outlook.office365.com
 (2603:10b6:300:116::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend
 Transport; Thu, 8 Jul 2021 07:47:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Thu, 8 Jul 2021 07:47:37 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Jul
 2021 00:47:36 -0700
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Jul 2021 07:47:34 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Paul Blakey <paulb@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>
Subject: [PATCH iproute2] police: Small corrections for the output
Date:   Thu, 8 Jul 2021 10:47:28 +0300
Message-ID: <20210708074728.3686717-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2561638-fcbd-487d-000d-08d941e4a7cc
X-MS-TrafficTypeDiagnostic: BL0PR12MB4675:
X-Microsoft-Antispam-PRVS: <BL0PR12MB467579E0E0821C55D99C0825B8199@BL0PR12MB4675.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:177;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S/2mKdknmX/2o5jkt+7z7OEVWpc148CkSlm35XNnZOePj5nOW46eyfGKctaa94nlPTA7bNhO4Wxdh97Iq8j/xqlLFx6EoOlF+iH7aFVDDvf7uKTSyxmKUyIuVatXgdxpGD5jtVIbpzsm6arYkEflDa85pwqw/kw82iK9gOciT9ij+LvjJ13JIw6UbjvqH5BJ3SKWRsiXmmjNNFwEGz4+Pv5L52x0GF82Tf1QOE9NkcXN1aBCI6EaQlDxwfXpo/EwtGdqvUKcjLGqCKl2prWdaeYZ0VA9JGUVPJAy0Zj/CjQY8fURkL7t2qGjbNawK6UEd368DGThEuvIItOn+lcxquOFtbfITHHIIR4p04yyShRIcCv0zfGbjhZXMjXE6uvWT8e3BYCy5zjI2jJfhr+NlFAbpKWgMoiAK7pY3vED7o8ooqI9KcNggFpTxUCMBT6tYnG1giKh3XKbdfmzSmW9HL8j1bbp0iApkeDIFqaK0hn1ap/zK4UcPsnlDl41tG51x4t4621Ps68ALYuA0IeAeiKD+4f1xBVOGxnPSRFHkhhnSS5wGJHqw6+fhWxMB9+XpFEw50i6jYrLNhoH2fFMbQ9oVFErdJl38al7A2z+gfJI3MpVSv/BX9YJ0uJDmgNxFn8Lx85Enq1JsaSO83NyudjTX9yDvP4sUMRv2uuteej7xZFMst0YkPPJPi/yRfZAcsb1XKl4FNsaOris7UYZcw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(36840700001)(46966006)(83380400001)(6916009)(4326008)(26005)(356005)(54906003)(1076003)(36860700001)(336012)(5660300002)(6666004)(86362001)(8936002)(7636003)(47076005)(316002)(70206006)(36756003)(70586007)(478600001)(8676002)(2616005)(82740400003)(426003)(82310400003)(186003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 07:47:37.2019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2561638-fcbd-487d-000d-08d941e4a7cc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4675
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Start a newline right before printing the index.
Print overhead with print_size().

Fixes: 0d5cf51e0d6c ("police: Add support for json output")
Signed-off-by: Roi Dayan <roid@nvidia.com>
---
 tc/m_police.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tc/m_police.c b/tc/m_police.c
index 2594c08979e0..a17ab64b1ce5 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -301,7 +301,8 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
 		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
 
-	print_uint(PRINT_ANY, "index", "\t index %u ", p->index);
+	print_nl();
+	print_uint(PRINT_ANY, "index", "\tindex %u ", p->index);
 	tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
 	buffer = tc_calc_xmitsize(rate64, p->burst);
 	print_size(PRINT_FP, NULL, "burst %s ", buffer);
@@ -342,7 +343,7 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 		print_string(PRINT_FP, NULL, " ", NULL);
 	}
 
-	print_uint(PRINT_ANY, "overhead", "overhead %u ", p->rate.overhead);
+	print_size(PRINT_ANY, "overhead", "overhead %s ", p->rate.overhead);
 	linklayer = (p->rate.linklayer & TC_LINKLAYER_MASK);
 	if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
 		print_string(PRINT_ANY, "linklayer", "linklayer %s ",
-- 
2.8.0

