Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6533394A1
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhCLRYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:24:39 -0500
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:42465
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232602AbhCLRYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:24:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiUe54+AnBQW8l56f+FtklduLQTcYcQT/TWHImR3fbwYp1CaQJW+a5IHoD756a9W+vLaupIICWcCV8hWEXme7WM0+d1P6qvqGCvPpQg+EYPSvxiMGJ5qYiHsw7eDzW341CWHLD7pM+2xi+ljiWNXmr06S8TTd46rSTXacMX44lg4u6nwVSolZorvAD89aL32vJlPCO4SYKRCG9GQNfZWkWQdhV/stCrQBN2Y7USSzx9pZIBurslT4ZD0R18094K6K1p2MigV5HZQFhOb7znuOxGYpS/OU97H+HLUC1ywrXmSuT1BnDdOaKihihpmIJfU1QwcSL3DniKPaVW4Xgf9vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/TGUO8zWSRnFCZkQMCj+rqjIqTB4/qKKuGKifW4YoA=;
 b=LEbbGnlkkPtRdn14+t8jCXiKehY6D6Rd8tQ/IzbRJJI+GkHx9b5gk1/dURQdL32eW74WkePW/hRj3BtWzVBIb/DK3mUHW1VZGiiGnwrArPsZHDiDkv06cBbPKcZZhwSHwEGL8MzoEuI5ICMi5mw0I2GnLm97Aiduewozzl1I363c5H63EtsYGkJy/ZRiUxvkF2bG+1Ca6ZloTZ5R1Vp7b5rZhP1lQE5SMQepZtRwPcjPyTcgjQ7MPnBIPX2LBsyynB/ok1Ar/v/BSiVgHd+IbudoT8vzJDOFekVNlFKQK2v7028YD6Kgn1KYajWqX8RtRRUIupv9LTwMCWl+ZNtASw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/TGUO8zWSRnFCZkQMCj+rqjIqTB4/qKKuGKifW4YoA=;
 b=ueGGO2yuY/RA6Nmuur+qz+8bjcss5sR9BvpKmnFkU8zC2JE+MzkRypCT+AlzhohV9BvwWZT3hBXnvqSEKJaXLAG060hp7ugX6JEUayTQZps9UdV5NYiIAQaLMOKfgQHpbyf8bkDlMbBIsMe8Ok6RqQCn7bQLM8uoyiEL3AolbQnRxbvncvyl1h9YsfCQN11CiH3AWU9GKapxmQj1Z4avkrw0HVlDPPPRStBlI0ATm+lGIamGrjLS1XZMaF3M+MWNKeUZ/2turUfUc5zvits2tonL92T6GdPYm1kmuyIDFSPCFuB3NcxZjcDyp8ziAp2mKmVcTuktJfMwQ47L76QPxw==
Received: from MW3PR06CA0009.namprd06.prod.outlook.com (2603:10b6:303:2a::14)
 by DM6PR12MB4697.namprd12.prod.outlook.com (2603:10b6:5:32::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 17:24:14 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::a9) by MW3PR06CA0009.outlook.office365.com
 (2603:10b6:303:2a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26 via Frontend
 Transport; Fri, 12 Mar 2021 17:24:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 17:24:13 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 17:24:11 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <me@pmachata.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 3/6] nexthop: Extract a helper to parse a NH ID
Date:   Fri, 12 Mar 2021 18:23:06 +0100
Message-ID: <bb96f63c7dbbfe816113d33329c877287dd5b215.1615568866.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615568866.git.petrm@nvidia.com>
References: <cover.1615568866.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 052797c7-42fd-4bd4-5f84-08d8e57ba84b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4697:
X-Microsoft-Antispam-PRVS: <DM6PR12MB469709637B0078076895A893D66F9@DM6PR12MB4697.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jw5w90Hn6XYTe2N71uLVHeVSQcWlp6973A+ReMpHqTuyDpAx4NZ1VtAseoAv8SjLdS9BktyhzPCuFZyDeldCoSDdev9eB1DHaITVq2kidKg/2qW1aHnRXqUN3UME+5ZOuS7v5vVwrZ6o7OHej0oSYal4RJphFl4KIr8gLtggUXClrCP0odW1JMIxboe+widM65EzsqHmt32kDfLjxLgGnUYGrjj4z1xAu3l/GTvgyM70XnNKDClIqg2GTqMYDp9UkG+ITrxXAw6HUfS8lzjqSknylsQpohLURxfhXu3YFqH9hl60rdAPZ7uVR5Wb+MBRo4cAnqv6NBYkjijM8zru7p4C8XS7FBcW/o2BCCKEv/7FNWISFzA5AfK0ek06s1YBpZfw7iJaP1DL3yljygkIyim0N0iDJxQ2LAgw2Pwwoc7HwHVVHaL+QeFe6ydXxKsWw40VV81PcayftrPdw5NIFdyGnomjmbRA0rnE9vZIbsvYE8A5Qw4SAEFSa+H5hT+/IYgUIO2GjqCpT8ZMJ56U9MlfkuaO/wyC+XZv1w4Ux8aeONsOqQeGUCRYBoiUH2ZVK+eaJBwi8O2wnnbRsgOKD4pX5UJ1WPRTbSYOTaDCqIoOkjOSCp6bAkgScPoNIzBxzOUOKP1OqRg/vvuobeqSYkIwYHwjr2WML5Zq3Q/kO8IVKhQO2tVtLRrsoJPWVP9P
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(46966006)(36840700001)(36860700001)(86362001)(7636003)(36756003)(26005)(356005)(8676002)(83380400001)(2906002)(336012)(2616005)(36906005)(316002)(107886003)(82740400003)(82310400003)(4326008)(70206006)(110136005)(54906003)(70586007)(8936002)(478600001)(47076005)(34020700004)(16526019)(426003)(186003)(6666004)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 17:24:13.9155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 052797c7-42fd-4bd4-5f84-08d8e57ba84b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4697
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <me@pmachata.org>

From: Petr Machata <petrm@nvidia.com>

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

