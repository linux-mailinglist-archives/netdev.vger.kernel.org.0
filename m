Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D048E33BD8C
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237296AbhCOOhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:37:02 -0400
Received: from mail-mw2nam10on2041.outbound.protection.outlook.com ([40.107.94.41]:51873
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236622AbhCOOgB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 10:36:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BvXzhdBLwSyrxmzAyidsKKpVxZgVDI5Uwp8retppp5yUtgQMkvyN1wJT6y0JwG9CjtgHzVSHrCOVS6yrRlrYd6LhyJh7YZ4+Tfb7Tb9xdWnsgjNejuOQtxmnJR8rYyX4tOnjipJ4GWiycffeuxt/du9+KgMRNJ/EoIb0zH+H39k8Bi29lQPaYJhwl/xck7k4t7QH1+kuOcqSKuMJQ0tCfi3/b9Fjnr7/8JE8h+ZBXJw3X38gAG5/BtjDuI3nsiv0RdkzZwc7tOq6Fv/8VhBhnjbf4lytKex6XOKUV/3WYJoCS7HbGyVcZk2OyRPuWNSeaXAjP/mwjhYS6yqPir3/wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PhAeooF7UHYWwgYCsdXUTXGDkxdhUyTUFaLzbVrx+I=;
 b=cjiBqiGeGd89i07tGn+VoHz5I3vsgwej1ig+GPIq0dq+N2mg+B8GV2emqNeTpwsz4o7shNsrkLdmejodIZPTshRdFo/lxegeX10VfST/BFi0q3egSTVne7NAL6GgTJCbV5fxyayjNZ9NA4+lLKpp8SldR68mBnmw3GFsuVNQV3tPlF4eTjqJzEpbSCnnRy21BqmZtv3vreBhxjFvbLDCD2H1Kvt3b9beDZMo4whZijZWwXUKWpaULPEbDz2eDsgS1usBldxbGJjRMuOEKgFPRBX4Zi4nLQSBc5hml13CxO74GH9/SdUeazYrNrRQMwvNr09Z3QyC6HX+Jrl7gJekrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PhAeooF7UHYWwgYCsdXUTXGDkxdhUyTUFaLzbVrx+I=;
 b=BoSQ9KZCY3MbTW5t0mOibLKm3fmUkuWJhbjWzUMftjS+2Rs+Tmxh0OjYT/M5JH8nKJH2vjVT2mP0g8wWCjkTw63sIKVGJASC7EnkzkQKQW78tJDRmnpazLI5fVYTOrBGY0VeqONDuCO/qIPSEq+qpUEBmZsRxckfJEB9t9wF3WODdA1Npk5Xb9cpw46IzrW4UyUpAczqhyS8l5Ve2reRnICDN269kG1UriB937/10pzzz7YlD0W0w2x/aKaYuLmJaljKBRuoEFBRobpjVkQAGRL1v2V5s3u8uC69YlihALL1x8+qwuIY1T2n8d7dxHSgkQaera4Sxko4/7mmNMRGTg==
Received: from DM6PR08CA0033.namprd08.prod.outlook.com (2603:10b6:5:80::46) by
 BN6PR12MB1651.namprd12.prod.outlook.com (2603:10b6:405:4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Mon, 15 Mar 2021 14:35:58 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::3f) by DM6PR08CA0033.outlook.office365.com
 (2603:10b6:5:80::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Mon, 15 Mar 2021 14:35:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 14:35:57 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 14:35:54 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v2 3/6] nexthop: Extract a helper to parse a NH ID
Date:   Mon, 15 Mar 2021 15:34:32 +0100
Message-ID: <1a961d43333b47ed18c9ccbec84c838e47eb3067.1615818031.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615818031.git.petrm@nvidia.com>
References: <cover.1615818031.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 405bd703-ac74-4680-aec6-08d8e7bfa5bd
X-MS-TrafficTypeDiagnostic: BN6PR12MB1651:
X-Microsoft-Antispam-PRVS: <BN6PR12MB16518B5034DF6BBCE0F7E657D66C9@BN6PR12MB1651.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lHXuGnfPHdRdpRCku6ikvXzsYM2cvEjDVRaP23KlnHEVQhc4BCEeIinVFL7sxkn7g4GJ2gHrXuubtPSHCvANYqMM5jMKp9fQV6z2n695ut6gkbvtrxBZRwTKmeq/iFvLJhJz/m2YHbSZ5+44ICgy0fXbukrNupdX4x6vzIdqOkaeDEFumcFWDKCcd805M895yVHdWe4O92kFD0bQATqsgkeo0T9GpAsDMJl3/ujUpZiESgNmqP+bYMHtd5lRiy4J0tgJ8lKLZcsy7O2m8cDWz7iqAvrba6OjUydr/XjuMCvgrNg4/ge1oPdSimSVnC8S9mXSD4PiwKklxc9d9cMI6qdqbtkSwxYmjVkFaXFWQHfm972apWmLxJ3ZnaTEbwqNjVk5rPOvc3xckXUha9mudJECurWj5X+TovRowKW3WM24/oaWERzchewC4GIL4mP9p4ms34cuOtTdOs+O3i6F2r5Uy83eLWiKBHYzhr4tud+wNtWSJYDTQdWiDJx3co3jgTRB0IeLw4kXy1S64OslgLvW5AlluKwJCvFCVbVEf/UR97l2HAbICUWHh1uqdvu8sZDFgwZiektRfd8Y1SHjnbBWU8VlrM9UmDovv/hhrQBEm6QKrcuNe/zmOUH87Oc64SrbPZYnRiITCM6w6H7L9S8/fkakcms/Z4/PKeJqScm6c8mYYOkAn4JwHTzsXepQ
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(136003)(36840700001)(46966006)(2616005)(110136005)(54906003)(316002)(6666004)(478600001)(2906002)(83380400001)(5660300002)(36906005)(86362001)(8676002)(82740400003)(8936002)(70586007)(4326008)(26005)(47076005)(16526019)(7636003)(36860700001)(186003)(36756003)(336012)(82310400003)(34020700004)(426003)(70206006)(356005)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 14:35:57.6667
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 405bd703-ac74-4680-aec6-08d8e7bfa5bd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1651
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

