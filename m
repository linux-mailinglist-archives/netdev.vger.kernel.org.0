Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1BD33F0BC
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhCQMzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:55:32 -0400
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:39998
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230157AbhCQMzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 08:55:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXoodWPnypo0ABzE8mfGcDrmf0TcfOCKLtSNKP0Ycg41lpFRuMoki8mtQrXbHMm0yJG0eTfJRhJ7YBmr4zzo75Qh7J/185A6O9R11BnRFdkPnUA+kDl4yehQqnPozJO7W2OkTRvvBxzH7BSN59LlHv/eoq85J3gTobb+MhSp0jQhM+ckAKEUnxC7vBZCCCLhXqvX1W9/NR3JxMm0dQwm3DfNgGRzGlk9QC1U3mW7ONkid+kFLeh/BbCz4UBjitv9x0u+z9ded+c0+iutE7vQi9bD+vB+PihaKlP8pgDEmdLM2Rz2r8T0lTRu2PehVCJ8Ozq6A4hiZnkHD/tgxRUMAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PhAeooF7UHYWwgYCsdXUTXGDkxdhUyTUFaLzbVrx+I=;
 b=V7CKBeak/felcmBBFlvODBcaI1imOJ6e6Y/t6IMqHFJZkP5zLU4kxeN0O+JCmc5TQLkgG8tZhSzgjLvVBUZ/t3DCybTWImGTLwUqsuTGHuvmVZfWKDJpVUc4bayQcJV54y+LInrgfFwVXlfGH+OfwHzLHGPmuyGtscKiD5bKax0aAdWKmm8qbGq1Teo6HwuvMKAzFvj60LjoO2Gq33Tq4jNtAEcex0e8KWy/F6VnbCdh7VzWIzZ+cNFyZc35E3JLw3Uq2AemFL82juYxd3tiUGdc77HUo5bRURfBGpVURMKeKnYKEYrFyBWtbMPP3IMC5+2YiiW97OlVcZKfBUhRhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PhAeooF7UHYWwgYCsdXUTXGDkxdhUyTUFaLzbVrx+I=;
 b=IRiKiPbm0dH7qdS/XgQ6sNrjtgRYXbRoP1RKgzODBP3fq6lxVuBUFAkbhHnsMQ34F7MmBH9gJTSykRrRVzdFIKg6mb3zX78J/cXHFsWGTjmEQov0INJwXfBr1MytOuPNLHtinZkK6t/3PLqcrzN4VcYdloHPrAnY7BEXBN7f4cKvY06nrCGPxVOyE24vcpqIVnOgREEBm9UEZ/LAvGrfHUmqtbJakXHN3nozdMckuRx7qHWHtmSjtillI6sHkns0yGzKQjZC1DVmHHkbS8vZSh00znt0riaP8QEHY6bZqrpnDXRiZO+3mKn19wUOluKbUshzRUUv2gozq3zryD/h9Q==
Received: from DM6PR12CA0014.namprd12.prod.outlook.com (2603:10b6:5:1c0::27)
 by CH2PR12MB4150.namprd12.prod.outlook.com (2603:10b6:610:a6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 12:55:11 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::61) by DM6PR12CA0014.outlook.office365.com
 (2603:10b6:5:1c0::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Wed, 17 Mar 2021 12:55:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 12:55:10 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Mar
 2021 12:55:07 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v4 3/6] nexthop: Extract a helper to parse a NH ID
Date:   Wed, 17 Mar 2021 13:54:32 +0100
Message-ID: <fff2c9c55bc094791f11fd6ca9346e9bfd7e9110.1615985531.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615985531.git.petrm@nvidia.com>
References: <cover.1615985531.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8725f4a-b339-4b58-1efc-08d8e943e645
X-MS-TrafficTypeDiagnostic: CH2PR12MB4150:
X-Microsoft-Antispam-PRVS: <CH2PR12MB41507FB879BD797C9A6EC322D66A9@CH2PR12MB4150.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lu8sWpqPO3qXn9u2My+1iEY+XHw3noe5GRr5PDfHkyXPPQMUeNvBY9Khmeu8pmmnvuyxBj/50JwOlQ/UoPUv5VrqjiJwywASoYPyZ/c6GpmIVBmf2zVVcuK79XdIraIP2bF8GpfpGmuP96PKYPM61CBGnNz1ud7NuRiO+9Sf+wjTWlTQxO6ssw9EIsynM3ua6YppDAtEl0wFwuRl/TzUz2iqJU2UE9SYnp8CLA8mZzoKP/X2bal8U/Cx+LQd3i6sTAXOyN+NU6mjmoAVeleh97usSjz2YfAzVbX+p0TAi6fcE6xfizOqKoabqIqVCjJO5YlV/ypZjpKubsg8RYXi1JLZnUHO6Y0Jq8DzRLrnV9BAeim5LFDe8orA9PqD6miuXS3abTOV5ZLyRmIoUPgvD5YTCUAslqk/ettksFb/Ez4dDrFquwB5rSGpP2xkUnNIzUN6Cqg+t3QqWx7DpXPcvasaYjQdq80tPyZ13DQTcnerTfjbNRRujf2ZbV8DpX7OTo7ZfDyj0aZMemuiEhs5rDJ6MDcICht3t3gF+9fYp5Zbe+9Yl+1DET3iVdLFi8rcRT11+WE2QcSKScOxAIViRUfJsnCnvWS7OTG9d//x0HnRA84WZppufWLP4hnvoCm8kINWbwLIz8M7bRTLbTG+DaTniapGHKfjvF04gLFa2t+EYVdQ5qb7r1CipVwdnvMC
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(36840700001)(46966006)(356005)(83380400001)(16526019)(47076005)(110136005)(7636003)(426003)(316002)(6666004)(336012)(82310400003)(36756003)(34020700004)(4326008)(82740400003)(8936002)(478600001)(2906002)(54906003)(36906005)(8676002)(5660300002)(186003)(86362001)(70586007)(70206006)(107886003)(2616005)(26005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 12:55:10.7216
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8725f4a-b339-4b58-1efc-08d8e943e645
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4150
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

