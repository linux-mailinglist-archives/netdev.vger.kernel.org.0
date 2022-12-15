Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DF064E009
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiLORyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiLORym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:54:42 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2071.outbound.protection.outlook.com [40.107.212.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7A126546
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:54:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c51/WEX0yryaXKviC3TlU42z50z3B4tG4rnxlgyrlAybYwJVCu8IVZB/OTSbzEPBWL//7sWollQlo3/85QOnK2aSGHdgDXI6QpiCCUFtxKjvjkYW3FqvXkmyOqvTpfE5rjMh3r5qr+w4aUM50fP+yowts5zmvoZhZV/g/20+ViDlnWt3tNky1theHJQ9bUdEeUZ+/aCUKFkJUJ5xRlHVZhn72xDtvF0gjUTfJIMuPuP/w0eINliophFUo3OhvvMQJyOxe9jQpiZ/OVWcFuzdLIIzC22OS6MYSFpGGdZYatmlAjm0kq/twCNmjy1gqvBeZZeisX7FDg6c52aeXsXwQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gzFNmb3V1wjawnwGt5yQ8wI+uYXBAmrPQK5AiIPACo=;
 b=OS5I0+ooeKlPeXrMEzv/uiaQHJGDn0sH0e3kHugIpxqOWL1WwEDSoAPK41HtyZolSUGFqDKDfX9up4uWAFW105sQ6Znzi9gnRatZPaYLlj/bZrNKxwcFthCc8N80Y7WRx611JIFnkmfnmw3KMgVI2cKhKQfPLpncfqBAe4K6NBdfEzwmn6dkkfhCffkC/oR5wl7LKqSb2XRzc6gkxakfrbplMZyZaCmur+/p024aCUa6Wn6F1XhNWiPrPwNX3KVBIosecpbbzCgA+0mikaJ2iZz4UwGpMEZJz93gAjqnkgQSvtqP4Y4Nd2zT2iHmHujpTIlLiaHJO/chO0yohngi8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gzFNmb3V1wjawnwGt5yQ8wI+uYXBAmrPQK5AiIPACo=;
 b=tFw/0LgsMBWcwCV5WtF2acWnwfDYnjyqm9DU8b0zi9EaUGYQ5PubS3PnpOCLASzsbfPHyyFPJFCZo3Wm7nxoyzrkJeHd5oydwLzER+8Z25CFoQjxqqo5lwkmtzqI+6OTPm+E9dvYq79jQjc6dJNZn2r34VuQbV913ab8YtKZrwXmKv2/iBFckhENVOE3lzXpSLwTrkmM+zoik1AfoA39WwD+p4Ic++pszQEnlzvxDd48gY00Bg/rGcYqGl7tSaUQ0JFo4ecOJZBMqlcglxOYAA5WkOsK78K/JLP4QWtEpc6lN5wVsxbf4Rcg8wC+tiB8WRD5ehv5ljRpQm+Rs6Ujcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH8PR12MB6796.namprd12.prod.outlook.com (2603:10b6:510:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 17:54:39 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:54:39 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 2/6] bridge: mdb: Split source parsing to a separate function
Date:   Thu, 15 Dec 2022 19:52:26 +0200
Message-Id: <20221215175230.1907938-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221215175230.1907938-1-idosch@nvidia.com>
References: <20221215175230.1907938-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0137.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH8PR12MB6796:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e1ed1ac-0029-49ce-10bf-08dadec56f97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iPSF9n2a0+si18+X/6LTP6xjQgS3q9VkqEmGQrmvgyiF+sLm6V8xotsuHHGbXbOe1UMDKSTFlk4sY5QfP1brOogEiYsW08QA0Pg31anojauw/U9TxxAq491TSs35Rhu6t8ZaY6uYrhUTlPU7KbiNKlKhz8wVIYWa+szVNOX6+73RSJc6i43W3JgRJRQ8plLDbP3GV++boGMxYRIDMk5oRmCMSHm4zOe8XwGw9Unexm4CpRJPv5MEjBLaDkdWxhqelj5Ae38IFqgLX8//7RoGZ7rg6UR2HvZKWUGwWgm1APgJzM2XBHHDLF5K5kfuWpUl5wUay7ZFdEkF7kKHn+WjcQknVQFuAWrV+9a60p79No6WoAWPGEh5BRR61WtlTs6Ec4A/CayXoUVHr31FxKzr5KV15lbZAmwIvXK8P1YXBKchsQIJIwctHX9pg0CcnCCRbOJMaivJGnzJvD4Y+uN/oRbISc9FQV6FUMNQjoKrT20TOUkPiKXMCjmKWDdbB1nHYZNdPhge7SVHLYfpYYhHbYyMDYtv5Cz4ZCywE11QCirG48i05JdYsMCoo0gXSMaP4qOCUEHTMuCkbbI/xGDWs8L7+bf1fEKyI17VDRcJnNKEX0if/33czMUuLs6Fbpt/eMxhoQz4+ibkYCdChikR+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(83380400001)(8936002)(86362001)(8676002)(38100700002)(5660300002)(2906002)(66946007)(66476007)(4326008)(66556008)(41300700001)(6512007)(26005)(6506007)(107886003)(6666004)(186003)(2616005)(1076003)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FP4NM69YAI5txog0xIZkvOFIvs1nW4mji7mI8t2MCTA6N5P8AamVRDO5lxLj?=
 =?us-ascii?Q?K2GCQVzb2HUCwuVh4sznGDyl/hc4EhXZy1LIzWKYzvcR1jwbgCh6382xFYpr?=
 =?us-ascii?Q?B+2H3NwAs9oB5U+ymWg7k5onGbRShf29bLvSoLvcepFbzWkE4aVoMTwSn0AJ?=
 =?us-ascii?Q?f0oYd2bt1wzs0kwfJd3u4c2HEzCGXh8hU6eDs6bnSdO1JVwJzAAMa8OxKeqN?=
 =?us-ascii?Q?lX6YT6kFnppbMmuuZbBFkxYnA9CCB8582QaTvFPj/cHsfeOhgaT3X99Rz5D0?=
 =?us-ascii?Q?9NcSxuSf/WPF/RU9yxoIr/du6yayMBKMHPz+D5HtV7BaDepyP9E4S1CUUutU?=
 =?us-ascii?Q?sOmF3rTO6qQOTb9i/CxLQ8OGFPUplWFuSMZhLUiq7U5cA5uQQNVXbXQyiFN9?=
 =?us-ascii?Q?EgIw94NoIN2UOhGkU+VPIUSQQJVtfY2lzFXYfUQBB365oiqkmEIGLfGRbxsT?=
 =?us-ascii?Q?ZC44Tzs6H4/hLldOUbtuoktgga/OqdjsigxiHBacM0FMj+sOVgEZ656JVyDj?=
 =?us-ascii?Q?6yzHyJWJfA1dTDn4AgbdeCGxadLK9WqzzdBqIQZcYSBBDQhsVEbfBotKULTu?=
 =?us-ascii?Q?RJFajhjqyUxnseq5sK/NRxhRBUUPZk6Qa5AUNSNlNWPaRwOlBJfyqhyhdh91?=
 =?us-ascii?Q?SRONn58APxDrMR6OnxYZFapQjnzZbIQSKDmLjH9/6Ngkat0Ubw2/cNeYgxBq?=
 =?us-ascii?Q?NgYSej5y31bhZPJ46YLVpco2d4bHQJWxOXkeZCO4O+e0IMFF6ihlc5fW1FHA?=
 =?us-ascii?Q?D+KkMpKADxF41GtFpYKDvDbvPVwH7j0l1q7g+a4UDNkQh0jD6J/Ws0r6Dwg6?=
 =?us-ascii?Q?ZZ1+18OOJQHVEcVSqO8UAzIPuQHm3eJ0PUwjobzFUWV1Z1/4qEWCY+ON87Um?=
 =?us-ascii?Q?4ays3P/eWayuA8F5RBN33IzA0aOC7rfOqdOFl3Yb0RC/M7xvNHc2Tbiwbimv?=
 =?us-ascii?Q?7OkSiUlVJVxWPDOw6bs/6KmcQ6hCtJzpug81tjq88zsyeLRdPcGylEsvNeHD?=
 =?us-ascii?Q?fIA3v9ZDaixUqlkI7ZaMxMb8O8Oty3CSXW/MbihGGR/YnBjdgWHBbXGzLs1B?=
 =?us-ascii?Q?maeGo6ZuYQYzXHiCJeE95sjmxanaQm/VLlYmINocJObRPsq2B1aeZVBJrtyF?=
 =?us-ascii?Q?XA8SPjdI3vxxxa8KxrmMGh5H9f9NOXj5+7TVnQngblbnEQkSbnbOm3x7Cvfw?=
 =?us-ascii?Q?xPWpmPtQGDekgSTHArSiRg1mIPA/KX4hF/0VhcNK4WXsuACzMCz0ZfE1Aieq?=
 =?us-ascii?Q?GghfkET2uMx9yb+TTNjt7ZDmk6F1gW5hz1P14fHf/jMFx8TuhjAsOzGs9c0g?=
 =?us-ascii?Q?5DrpoKcENnmoDtARL3c9ahhE9qaFRYqazUHrVb6lR1teFADG4bshTdTwo0S/?=
 =?us-ascii?Q?qBfSVIK09KIvEK4PEYrCSvIpLYCHsjekFuyEFE4xtaO0eVmcpATz6NfvSTEp?=
 =?us-ascii?Q?k82mxbeqmBCTZbbqqv9R/1Ao5uLchgrBzHoT65dxJFfUN46phlpNDF7mf8/1?=
 =?us-ascii?Q?dCkgGjwe3h0UdtNKYdUZ82nSAFZzEyeLiJ2hICw8XWzqW0lrW4frRyfxHvpi?=
 =?us-ascii?Q?KRDcl1wBp6rcOE5sj6j7xnoWeZjLfXIwTnzY18z9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e1ed1ac-0029-49ce-10bf-08dadec56f97
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 17:54:38.9222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4yVR4ch9qCKZZrq7VPCYdjRn8ym97oBm5mcHoBaYMcVvI1nxkGNXbXm70ck13K4nH+VGdW9Oal2SXfCokOX2dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6796
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the only attribute inside the 'MDBA_SET_ENTRY_ATTRS' nest is
'MDBE_ATTR_SOURCE', but subsequent patches are going to add more
attributes to the nest.

Prepare for the addition of these attributes by splitting the parsing of
individual attributes inside the nest to separate functions.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/mdb.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 4ae91f15dac8..64db2ee03c42 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -474,6 +474,25 @@ static int mdb_parse_grp(const char *grp, struct br_mdb_entry *e)
 	return -1;
 }
 
+static int mdb_parse_src(struct nlmsghdr *n, int maxlen, const char *src)
+{
+	struct in6_addr src_ip6;
+	__be32 src_ip4;
+
+	if (inet_pton(AF_INET, src, &src_ip4)) {
+		addattr32(n, maxlen, MDBE_ATTR_SOURCE, src_ip4);
+		return 0;
+	}
+
+	if (inet_pton(AF_INET6, src, &src_ip6)) {
+		addattr_l(n, maxlen, MDBE_ATTR_SOURCE, &src_ip6,
+			  sizeof(src_ip6));
+		return 0;
+	}
+
+	return -1;
+}
+
 static int mdb_modify(int cmd, int flags, int argc, char **argv)
 {
 	struct {
@@ -543,19 +562,14 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 	if (set_attrs) {
 		struct rtattr *nest = addattr_nest(&req.n, sizeof(req),
 						   MDBA_SET_ENTRY_ATTRS);
-		struct in6_addr src_ip6;
-		__be32 src_ip4;
 
 		nest->rta_type |= NLA_F_NESTED;
-		if (!inet_pton(AF_INET, src, &src_ip4)) {
-			if (!inet_pton(AF_INET6, src, &src_ip6)) {
-				fprintf(stderr, "Invalid source address \"%s\"\n", src);
-				return -1;
-			}
-			addattr_l(&req.n, sizeof(req), MDBE_ATTR_SOURCE, &src_ip6, sizeof(src_ip6));
-		} else {
-			addattr32(&req.n, sizeof(req), MDBE_ATTR_SOURCE, src_ip4);
+
+		if (src && mdb_parse_src(&req.n, sizeof(req), src)) {
+			fprintf(stderr, "Invalid source address \"%s\"\n", src);
+			return -1;
 		}
+
 		addattr_nest_end(&req.n, nest);
 	}
 
-- 
2.37.3

