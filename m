Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7943BF6A3
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhGHIAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 04:00:43 -0400
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:14080
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229868AbhGHIAm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 04:00:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zt4itYAxUaHC70dd1nA12Wx2zgtpK0yRz/72PgtRl3murNDYYa5ozk08g96zsSBqisPqFPEjGE/wx09sqAhDzriIu9myWp+eAq1dzJtsSbdD9mal/kpMJq9FZgyX8YrtBTcjDYYl6PtVIPKK+FUkzdbhBzOh8f5xgxtWRLpXr513C6k+IBSK0oTm/KXJga4w5p3LQsr02d9GPSqiqBXu+5d0EjsWNaloaZNuVbkyX/FWDI8/uDu1+t56azlkHIyEVpvQgEFEEwpU1VQT7odDVrmgs0dnw9+OXpELt9q4IBbFQFNcYstinuosZ3UFM/F452rUZ5uUlfAjOHu7fXmgKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHknNCEbz+O9qAl1ZLZzMsd9pNyBjH9qV4DwjKlQU4A=;
 b=cqxpt6tk82mSA80eou903VgjF/c8PMtww5/MxIGf8ai4+wGZ5oqYg1j2w1eO+5Hze80dP47qolT0Wt5NYjrtBmXYQFvFbJB/mN1tE6sMXVkSCndpWLQKi+9oWuVzG6Cu1pKpM2La4gb3S9eunSw0rNDPeUF8QE0krQa3d3vWGg9BXW6BvOtcE0aPT2t4fhMoiRmRjB2K5q3bc/HYQdQhEvkkospxrNorjRVUyfFkuvthrR6AnUiXBSeiUQ5xHbnU/W4cLmb8F5CtqeDepuASzIoBwxRcke2fcc98FKX8XPCIptxkXrcZ+eDrCmlHzq/tIpTFEqEMXotS0+7LBEO+Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHknNCEbz+O9qAl1ZLZzMsd9pNyBjH9qV4DwjKlQU4A=;
 b=j81ORWOTKX95fu2ZE2XO+V92Si4E6bCF8/1e5EPCW8arD0341o77fjvjeAFT+Gdd383d3lE6E7hhHyHosKt80WNw223zcrXD68WnpVOnskLza1XMm5fHWB6ZBsUqhrV84cxt0LwqA8OfohE2iZYn43Ax/sSVBusbf6uVgCUqfDdCRcc4fx9rprT9Kf1izz1kGE6kcTCAnJhxgGeZRsXMzlwqo8m25X/Qhn9d54LaT+hQGzuQqUNAWNdrsLLRbRM6k7keOagrvbD/vjmyJXHPWyrfTrrNFJOYQSaxtwNhiH3/2hv1KE+nWBeYNOwSn9bYL7x5Nv3XQgWoCwvz9Jt1fQ==
Received: from BN6PR19CA0053.namprd19.prod.outlook.com (2603:10b6:404:e3::15)
 by BN6PR1201MB0148.namprd12.prod.outlook.com (2603:10b6:405:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Thu, 8 Jul
 2021 07:58:00 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::e2) by BN6PR19CA0053.outlook.office365.com
 (2603:10b6:404:e3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Thu, 8 Jul 2021 07:58:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Thu, 8 Jul 2021 07:57:59 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Jul
 2021 07:57:59 +0000
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Jul 2021 07:57:56 +0000
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
Subject: [PATCH iproute2 v2] police: Small corrections for the output
Date:   Thu, 8 Jul 2021 10:57:51 +0300
Message-ID: <20210708075751.3687291-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a333bdc-d442-4a3c-c160-08d941e61af9
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0148:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0148BE27541D362F5EE4763BB8199@BN6PR1201MB0148.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:177;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TtKrX0f23WbY+rGsgpw544Xsw+AU4XBUl+XqaKqBemN5HTQqYD9KmCjNx8pz29i6Af4BKxjOxUCRDAwEXBJhMJiWt+f222w7HfJ4/YqEqW2gmkqo32WNNZNyVWOQOpslMHl0KmLrXlDU3MXbj+RYUtpfeazRf4r2G54896+9Njidgc7YPR+NWuPv+7w2O3Ts8WiMsRIJ67UluU41ja0lnqhiqpWwqg7zMhNOnszUIQmc8kyejT+La0x5Ea8AFDgFuXHBdIAqDkw1gFqQt0jlEr4K5goxjMvoLFSZ/gBdrMrkBfdQSLbSwvNZR87pNBAzuik/4QDVRZH54LIqeOtjYcq0Qz0tTM9Dl7YTgDpYyc68SBgiiWGFfS/2ByoKwyFKzRwgC24n9+pysjARJJzc6Ud3pNxXSZ6vMaqg/0uhMzykhUHJvKF+xiRx2rjK4ym1w3IBviygvH9cEygCsNDbVwWVqWhWeGGn36oKT4h0PW5eD2srMzlxUe398iuNYUUYkYl3WGn2zr+cSI2fEIC/KPGgYPZfJ047mguU6zO/ZgPms57CDbUu98dF/6K16DEjbNm4pjlg5gDiP6Gtonq3FhCgm0bcIlhwtFUdWKhxazpkgKrShO+pfzbqjz18TgC2qXFsXMqf1DmOvmIK6siGSVmp2zK9FhnJ03jJrnSPD1XCNiOW5thrfBiatPgKsaYTDLqyTU9I1KezC/WWBteSQw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(46966006)(36840700001)(6666004)(70586007)(186003)(36756003)(47076005)(26005)(82740400003)(426003)(2616005)(2906002)(356005)(7636003)(8676002)(4326008)(70206006)(336012)(83380400001)(8936002)(316002)(54906003)(6916009)(86362001)(36906005)(36860700001)(5660300002)(478600001)(82310400003)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 07:57:59.7946
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a333bdc-d442-4a3c-c160-08d941e61af9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0148
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Start a newline before printing the index and ref.
Print overhead with print_size().

Fixes: 0d5cf51e0d6c ("police: Add support for json output")
Signed-off-by: Roi Dayan <roid@nvidia.com>
---

Notes:
    v2:
    - add newline also before ref.

 tc/m_police.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tc/m_police.c b/tc/m_police.c
index 2594c08979e0..d37f69b73e71 100644
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
@@ -342,12 +343,13 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 		print_string(PRINT_FP, NULL, " ", NULL);
 	}
 
-	print_uint(PRINT_ANY, "overhead", "overhead %u ", p->rate.overhead);
+	print_size(PRINT_ANY, "overhead", "overhead %s ", p->rate.overhead);
 	linklayer = (p->rate.linklayer & TC_LINKLAYER_MASK);
 	if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
 		print_string(PRINT_ANY, "linklayer", "linklayer %s ",
 			     sprint_linklayer(linklayer, b2));
-	print_int(PRINT_ANY, "ref", "ref %d ", p->refcnt);
+	print_nl();
+	print_int(PRINT_ANY, "ref", "\tref %d ", p->refcnt);
 	print_int(PRINT_ANY, "bind", "bind %d ", p->bindcnt);
 	if (show_stats) {
 		if (tb[TCA_POLICE_TM]) {
-- 
2.8.0

