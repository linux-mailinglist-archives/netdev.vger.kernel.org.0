Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E989733D1B2
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 11:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhCPKVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 06:21:32 -0400
Received: from mail-bn7nam10on2056.outbound.protection.outlook.com ([40.107.92.56]:28897
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236475AbhCPKVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 06:21:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPomFAAJ9uxSNdrmEDQsuuRGyv6vYw5bADXCtms+qU1p4lNBYs+VPcKD6sV2REiCC0S68FCuCqKW/egy+Lr75/W4B8Fxl7os7MHfI+mB6EKTrltd0ZqT2SwOsNF3gm8lmzBWF2TITLhILnAbMWv7AkoWX+6o90prHsTQzUyIYG1/SbB+YbFx+8x6AMMym1pzIcFa8r8E9PXD44A7f5wOLmXRY7FPtfVkVO8Xb0HzHdh1yKKuXyQ638RT8KPkj9WnjrkKSpReTa5Bnhx6yjlQWJLp3tAP+UCOtLP9Dtf3eMJpUJ+mSv7ZgliJ8oO8xGEcVVPbDP96aZLPe5Tkn726lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PhAeooF7UHYWwgYCsdXUTXGDkxdhUyTUFaLzbVrx+I=;
 b=h72Cjh0EIDnT76/uiA1+54EL5/Mxix9A1y9G7rpDWZrOHzjewZy6vB0/4bQL60NBDzR/V7OcdAHCbB31aPGbFM+VYWrdwcX8kx/wUKW0spj5l7hOLut/jLm7xA0YtBxUwDNDxe65+t/aD+R6MTKt1TXIsKFf6paHnupB8rJ51rw9o+UGJtNVRQC7sgnyc3M6Qrt6ztih+bG4j4eHgedBytS0bvMqzrwUNQ2NPi8tkglrwn4r8Vg21T8yd79Z3vUrdqvIEC9lxP9YWreQ61ntHNw0vSawTl+X+PcAXo5uNUHRbBYqoxOOaO0QeiAOVaot7fEEEGd+aSPQZRCcfRV8Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PhAeooF7UHYWwgYCsdXUTXGDkxdhUyTUFaLzbVrx+I=;
 b=Xe8eaUJRJu+yQrNvvTfi7bntQO0xROKocx3XaZ2uBz03DmcK4A393h2Rg5mZqwj9OThxLQBLxRCZLjRXaIwl84GRGknXS/C5WnJIIvXP4WtKk0JfSom4DVJiRQSJwFZOtcwhAdZ75RPZWDrnjF8iGxkEmOeiB2T1qTJbXjJYWga2vKTytwZjWys2exqLZlFOUzQrYmoNChJPzLaMN5ko7+wPOsYagQYTuZbFuvYO+YbUKH13/yEriBMMberK6R2HUXQT5PAslvheL2dmDQOFvFz8wxsxA8gBQJ6QS4PoAYK/MxeIT2S2GxzPCoDlOOFnRh5tWH9Jd9aIJjnvhi0FNA==
Received: from BN9PR03CA0192.namprd03.prod.outlook.com (2603:10b6:408:f9::17)
 by BN7PR12MB2707.namprd12.prod.outlook.com (2603:10b6:408:2f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 10:21:13 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::c4) by BN9PR03CA0192.outlook.office365.com
 (2603:10b6:408:f9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Tue, 16 Mar 2021 10:21:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 10:21:13 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar
 2021 10:21:06 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v3 3/6] nexthop: Extract a helper to parse a NH ID
Date:   Tue, 16 Mar 2021 11:20:13 +0100
Message-ID: <1a961d43333b47ed18c9ccbec84c838e47eb3067.1615889875.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615889875.git.petrm@nvidia.com>
References: <cover.1615889875.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bf2d3a2-a3e8-4bba-faa1-08d8e8653a37
X-MS-TrafficTypeDiagnostic: BN7PR12MB2707:
X-Microsoft-Antispam-PRVS: <BN7PR12MB27078839AEF065515C28BEE2D66B9@BN7PR12MB2707.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cCUpiZeu5WTrYSFJR67vA2Ru7peAERlpzVavSCsPq0qzBRipmj2HxKtTHcOJpmqVQhdOmYRwLSRKrHRS7gXfIWktmQZHmixVfkWBHf5nRpF51xokFg66zM2kQ0mRS0wXe+/6R8QDtH/+gC8a9osC9OfPe0cH4TyYFGc+kGz3PhbVaHvJbDPvXlOGT7FRDqAyKt7uQq7QdR6r86Yp37Jdoy/fQKiYa1AIY4zrtBK8e9FnqUG9eaLmqoGlXIay+C7Cg7GKCebeGRw1bK6aXwQ8TkZb7EvBGk0sfzgCGUzTjFXCXN2QpKceC8dno3HYkpCTnnLugyDPKK5d/gPnyk3OhVwDn067bsjJowRZKDqiZz4eGG98yFV6KJxT8K933PWzcFySqRedvMxuS0gjHeaOHiDg353wJQZQdrHoYTdXl2i1HMjjZ74UWAZzfNgpCaxfQGHWL7GNOjCDaCtxU4f4OmTGtQ9HijXgsDogRFqVg1oEa7UR3gB74tb+J11iysjS0rpwxtynLio+//iEuxZbrFGw1FMEyyiQUrts2jHqcCmMPLjXa2nag4S68CJVYmuT3gI6scEfv/FVKkancoJL7E4kRfe2Ml916W4RFqiNuXU7ibvqL93pD4E642woOcDMJA8tLrDo5uXAuO14p+bYEvuoote0LmcCZmkEXlL619myc6UzegCz2Q3UTSLTsf6o
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(46966006)(36840700001)(478600001)(8936002)(2906002)(8676002)(2616005)(356005)(6666004)(70206006)(110136005)(36906005)(7636003)(4326008)(36756003)(70586007)(316002)(5660300002)(36860700001)(16526019)(107886003)(82740400003)(47076005)(34020700004)(186003)(336012)(54906003)(82310400003)(86362001)(26005)(83380400001)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 10:21:13.7444
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf2d3a2-a3e8-4bba-faa1-08d8e8653a37
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2707
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NH ID extraction is a common operation, and will become more common still
with the resilient NH groups support. Add a helper that does what it
usually done and returns the parsed NH ID.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 ip/ipnexthop.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 20cde586596b..126b0b17cab4 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -327,6 +327,15 @@ static int add_nh_group_attr(struct nlmsghdr *n, int maxlen, char *argv)
 	return addattr_l(n, maxlen, NHA_GROUP, grps, count * sizeof(*grps));
 }
 
+static int ipnh_parse_id(const char *argv)
+{
+	__u32 id;
+
+	if (get_unsigned(&id, argv, 0))
+		invarg("invalid id value", argv);
+	return id;
+}
+
 static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 {
 	struct {
@@ -343,12 +352,9 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 
 	while (argc > 0) {
 		if (!strcmp(*argv, "id")) {
-			__u32 id;
-
 			NEXT_ARG();
-			if (get_unsigned(&id, *argv, 0))
-				invarg("invalid id value", *argv);
-			addattr32(&req.n, sizeof(req), NHA_ID, id);
+			addattr32(&req.n, sizeof(req), NHA_ID,
+				  ipnh_parse_id(*argv));
 		} else if (!strcmp(*argv, "dev")) {
 			int ifindex;
 
@@ -485,12 +491,8 @@ static int ipnh_list_flush(int argc, char **argv, int action)
 			if (!filter.master)
 				invarg("VRF does not exist\n", *argv);
 		} else if (!strcmp(*argv, "id")) {
-			__u32 id;
-
 			NEXT_ARG();
-			if (get_unsigned(&id, *argv, 0))
-				invarg("invalid id value", *argv);
-			return ipnh_get_id(id);
+			return ipnh_get_id(ipnh_parse_id(*argv));
 		} else if (!matches(*argv, "protocol")) {
 			__u32 proto;
 
@@ -536,8 +538,7 @@ static int ipnh_get(int argc, char **argv)
 	while (argc > 0) {
 		if (!strcmp(*argv, "id")) {
 			NEXT_ARG();
-			if (get_unsigned(&id, *argv, 0))
-				invarg("invalid id value", *argv);
+			id = ipnh_parse_id(*argv);
 		} else  {
 			usage();
 		}
-- 
2.26.2

