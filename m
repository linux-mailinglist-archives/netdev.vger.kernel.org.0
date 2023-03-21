Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F5B6C322F
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCUNC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjCUNC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:02:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB724D42C
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:02:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBK8ZOZhb3QQTQRQHODcnAhY41lf/JRevm5yD1JKxuwZCZCBzxu+O91t0aH6Nnhz9aEdbGK26GgWCAWbcAsqWyOb0GZG5ExuNagkRwGkGAVIdGYgb+2VZ7TQvyJ0TfLd2ilpfI7Z9KDwg9+JjQzrfvPQc4GOKQeZdiX1C2oCxeo0DZrIkKKsJV60embSjOSeGbHjsct1Jerr8ZwkcTwwWeZdE4OKUmcyqRFC6OiYrB9SM+1n115pnoxOOTI39Nzlq1V3DsViByXebj/luRIzYiviho7doZqzCxBQbEyk7CG7s4CyaN6CDiMDGrdUc2I0xGg1GoCy8OI2B+G/RyxM/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/kICGqAsTOuEXgGzGOyPnSwmr7ktAWnnJL4WAdyNwRw=;
 b=elqtKZv+84xOT7Mp1JUS2tQkpmH3JR4FLuMVhMfi8ezl4u++Tk8F3mZiIT1MHFOjr7+cxmNXeYLHviyql6u8FmWpIV3aqaEUX9FcmxF93lFtBYq/mxmmlddIbbCcga3O+BAAY/SQjc1D+Oxzp7PX4swPXgEVdr9ME3wUYTitStv7c+1/andvQMamguP5VO4nA2TfvXFqOl6vxNMBLMOo/09IztFObFhlcJj1vxXBd174eq9o7RrpCPH9DS0JIXxAfmq+GkbbxCLpejyAcvz4xGLqt8de2xbNV8mFB2kR2FAYEmZL1B9L+Gt3OLGTfB/VUyBJaVcFVnl0ZwSGNeJmlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kICGqAsTOuEXgGzGOyPnSwmr7ktAWnnJL4WAdyNwRw=;
 b=os1oqf+4WZY/OYMfvginzvyrQeoDKC/ZCLgOiZXCpBJWIcGsL2QxCgLRbeUGFQxXprYuAl4M3/VNjlyBMSh3Yj6YjyXQ+hXOZQPW7QyTBiz8Nd4Lebd5pLpADQXcvPRX7Uk5iLKDuPOXUzUf6PV+JeN8zO8exMxAPMlMLNxs6ZVM02AyThS1rHVPMj/JzWee9Oc5QXdqpBQja+Dd5tpgZcjsU7dm1wjwlA8DUe6i/Du46Nioa8CwXZkZQc6PyiBxcVx9OQ9V7kCQfojNTq0H2ftm+xgaaU6VSNoEGt3JfnbsW7yHpXTVYdksORn3kzh9AfN99Gmm5Tx4JOam9K0fjw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW3PR12MB4395.namprd12.prod.outlook.com (2603:10b6:303:5c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 13:02:22 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 13:02:22 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 2/7] bridge: mdb: Add underlay destination IP support
Date:   Tue, 21 Mar 2023 15:01:22 +0200
Message-Id: <20230321130127.264822-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230321130127.264822-1-idosch@nvidia.com>
References: <20230321130127.264822-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0067.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::35) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW3PR12MB4395:EE_
X-MS-Office365-Filtering-Correlation-Id: fd82fe90-bedf-4205-95b7-08db2a0c828b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xABKy35vvqPA8x0lqSiT+pzX9iJ/79DJXtNylPBWx9ommhih2V5TuBBJaCo/680Hwdy/gHNwsTM4oeArdJYgSoyGfvlrAGuzL6uncs7Bf0nQgN8/FCFTpNNjLCIc4dy00oO6C7EmsZarJIj4WCpo9yc9ERa0UJ3t4s+olhcijr8IQXVPnCq2IoDW6hp42I4mGE/yJ0XVmzY33LAHrgt8VKFF9GXxesUew7zcFthRv/lYMJqv5oU5/sA0V2IPVPTpKe2sARyZuRDaqbcOJuhgaM/EYAg3iYSpYS0Wkd/CcGLtj8Ay9i0CB2z/ykZodnlWKMxWuVevofW6UvXQRoFdd/OOUmgnAnrzYccgCmS3EHDMeekl7tLsumr9Xd+uxpDh7PBBjl6Je1r2NHt9ZiXsZEPG9w2AA1OtePpGQB3bXRPr1guvE+ZqMyuu2PJKQZES/K20o+pEZpaH1UT3N4tb1yk45MrwkDGdichL+HHTwA3fp3sTQC1StpepPqmxaLiz6iRej3vKrp/t3uweUaTq+6gIiHyx7sKUCh4hmuWdV8uZ48nVirMbJV00mOuAoiuubUu1v35tPwza67znAj619ZhifMXo7mt8try03EYxQWshndI6i3xTXEK0wQC36V9nV/jgIhaTFIARqMtAptWkXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199018)(2616005)(6486002)(478600001)(6506007)(83380400001)(66574015)(107886003)(316002)(66556008)(66946007)(66476007)(8676002)(6916009)(1076003)(186003)(26005)(6512007)(4326008)(41300700001)(5660300002)(8936002)(38100700002)(2906002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pK5F8W+NMyXvVV6N4Fyr2Tx6/wtI7c9qtSc8GkymTNfkaxWLMgbPqL4fZMx8?=
 =?us-ascii?Q?r/to+KY/NMNzNJn9/Ts4KrFzZlgxI3AJOu3ZIzVsKuC6Eco/MxJSXFGidMCl?=
 =?us-ascii?Q?5K6bLiGaZVSFjCHmTdNTK7xsl9+fTjVt2q9vgisuJZSCCFAC0pBAwbWefgff?=
 =?us-ascii?Q?sv7tHzadvL2xnX1Bz5VBwvC4vKyxt8qKj9awApyAojEQPHc/N2GPJXge/ahx?=
 =?us-ascii?Q?DhURpf1rm9E8WsuRZ3U9kVZzZxMEYTPOr2PAuKkhjfd5a6oF6v5j9ReZJ+w5?=
 =?us-ascii?Q?bUZ78iNZNrxfE4x2lqElmqYNnLXLwvz91OnwE2ilPMMIQ4yHZTcTJccfvz2k?=
 =?us-ascii?Q?kniZ10oqqDybLujH+IfNhXBHpw4jzKyjKUw92Z4CSUwOpEV2LoeMv6GCt00B?=
 =?us-ascii?Q?zwxrk78NRzc+ej8paCCOWOU4obkwE8XERCuHelJJzWFP55kZRH82XB92g2pI?=
 =?us-ascii?Q?7Eh5S5vv20/pYMiprzR6UfqoZkTbeMTGRNc0KH6I3dXRyeCtLBsgH/pT2XXa?=
 =?us-ascii?Q?v6PHsmBOBo6RSmKPdGFbAMnCsX92UomxLBnhGhPn4P12sK2S9q4forS8yjsy?=
 =?us-ascii?Q?Se/ZElFMYO8lHkq8uohMwex2PqKye2GsRVMjC7ZNqP75Dzz6TRklVvOmBZua?=
 =?us-ascii?Q?zeiAiKX3g2y7ZLOvojmjaKmttPtLFu49IbdWSDUPcTCHm8tBoOrSsUjH1hsk?=
 =?us-ascii?Q?x8NzQUcuw8QqXRRDjd2k/B0BHd5CuG0Gux51a3XSSTyjPRJ8VR7qQ/1uXw53?=
 =?us-ascii?Q?aNuIYV96DITlAy51g7jC41dAJx8zkXs8Wbe25OYyTxXDfE3LDtMtH2kSPyA7?=
 =?us-ascii?Q?sKpxwUMWvWaI3IiAJNki99iVawiVcHqMQ4wqxPQYejXkSkgm78/UKCPS8CDT?=
 =?us-ascii?Q?wXI3RDDH4kIHfGVgmlEJ7pI6T8UZMt/19qa4KK56lTWV9/j55muhEbJX6aBH?=
 =?us-ascii?Q?2GeM+/OK6wBf+rXJeg8Alka2EqMNj+oBYzYUmLQySDYUFxuWmgnJYzM6aVyd?=
 =?us-ascii?Q?hmKwDDiv+q3WEXeEU2E7VshMhlPdDoMK6XkG5+b5emz2sUHq6YVUKWb1eskM?=
 =?us-ascii?Q?p0sY2AJPRO5lNLFLMBa0E1FoeKhREmY51ctqltwHxL62c0Qe7qNZuI6bu7Zq?=
 =?us-ascii?Q?B2XA++Ehuo7Qz5YVUvVxN05KAjvTZVfon1OTyQVJCtOt6b9lNn30ULdU3RnA?=
 =?us-ascii?Q?RYVK/tG/5CTycbti3h6n9vROvLlJvGDH28BD3SoGI53qXX5LaDZ0KfNptjVA?=
 =?us-ascii?Q?qz7ZUm/uMbjq2PGwVft/ScX0aPNxWpjocu1/SYvo1j26k3ul8Bo4Pb/6lQwZ?=
 =?us-ascii?Q?OvDp+sY5BTMz6NABNEC6apwwY5Pv18gOAl1Lp1d/swYW8l1yoGMPY7vjBl5Y?=
 =?us-ascii?Q?/DaasP6LTLQNmOqWZ57nkJS/04hSpaOoZXyUFqIcEsLSgi1Y7+XZuncQbIdD?=
 =?us-ascii?Q?sDDX8XTt5k1sD86ZO2BO6TTmVgAT8gWe5P35uQMooiJA2pYvmc3Bv+Vbn38l?=
 =?us-ascii?Q?ACZfaHqtoQcsui/ZsuYdjbvEL0b5Rx/IKQ1YUZinZ1GmKFk4JNfW8jzUmK2K?=
 =?us-ascii?Q?bQOQ6j7iSOXzMiYz20DZrp0d8kDSJ8b7ZRzOeL1V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd82fe90-bedf-4205-95b7-08db2a0c828b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 13:02:22.3248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q63FoBiujYQhdC/7PZAg/MVg3TkQsL4gDl6HX1HE+KD1dIWHfI+fn9N9R8BZxd+c2GNUt80duBpLmc0wd+cAJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4395
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow user space to program and view VXLAN MDB entries. Specifically,
add support for the 'MDBE_ATTR_DST' and 'MDBA_MDB_EATTR_DST' attributes
in request and response messages, respectively.

The attributes encode the IP address of the destination VXLAN tunnel
endpoint where multicast receivers for the specified multicast flow
reside.

Multiple destinations can be added for each flow.

Example:

 # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 198.51.100.1
 # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 192.0.2.1

 $ bridge -d -s mdb show
 dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 192.0.2.1    0.00
 dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 198.51.100.1    0.00

 $ bridge -d -s -j -p mdb show
 [ {
         "mdb": [ {
                 "index": 15,
                 "dev": "vxlan0",
                 "port": "vxlan0",
                 "grp": "239.1.1.1",
                 "state": "permanent",
                 "filter_mode": "exclude",
                 "protocol": "static",
                 "flags": [ ],
                 "dst": "192.0.2.1",
                 "timer": "   0.00"
             },{
                 "index": 15,
                 "dev": "vxlan0",
                 "port": "vxlan0",
                 "grp": "239.1.1.1",
                 "state": "permanent",
                 "filter_mode": "exclude",
                 "protocol": "static",
                 "flags": [ ],
                 "dst": "198.51.100.1",
                 "timer": "   0.00"
             } ],
         "router": {}
     } ]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/mdb.c      | 51 +++++++++++++++++++++++++++++++++++++++++++++--
 man/man8/bridge.8 | 15 +++++++++++++-
 2 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 9b5503657178..137d509ce764 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -32,7 +32,7 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage: bridge mdb { add | del | replace } dev DEV port PORT grp GROUP [src SOURCE] [permanent | temp] [vid VID]\n"
-		"              [ filter_mode { include | exclude } ] [ source_list SOURCE_LIST ] [ proto PROTO ]\n"
+		"              [ filter_mode { include | exclude } ] [ source_list SOURCE_LIST ] [ proto PROTO ] [ dst IPADDR ]\n"
 		"       bridge mdb {show} [ dev DEV ] [ vid VID ]\n");
 	exit(-1);
 }
@@ -146,6 +146,21 @@ static void print_src_entry(struct rtattr *src_attr, int af, const char *sep)
 	close_json_object();
 }
 
+static void print_dst(const struct rtattr *dst_attr)
+{
+	SPRINT_BUF(abuf);
+	int af = AF_INET;
+	const void *dst;
+
+	if (RTA_PAYLOAD(dst_attr) == sizeof(struct in6_addr))
+		af = AF_INET6;
+
+	dst = (const void *)RTA_DATA(dst_attr);
+	print_color_string(PRINT_ANY, ifa_family_color(af),
+			   "dst", " dst %s",
+			   inet_ntop(af, dst, abuf, sizeof(abuf)));
+}
+
 static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 			    struct nlmsghdr *n, struct rtattr **tb)
 {
@@ -240,6 +255,9 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 	if (e->vid)
 		print_uint(PRINT_ANY, "vid", " vid %u", e->vid);
 
+	if (tb[MDBA_MDB_EATTR_DST])
+		print_dst(tb[MDBA_MDB_EATTR_DST]);
+
 	if (show_stats && tb && tb[MDBA_MDB_EATTR_TIMER]) {
 		__u32 timer = rta_getattr_u32(tb[MDBA_MDB_EATTR_TIMER]);
 
@@ -570,6 +588,25 @@ static int mdb_parse_proto(struct nlmsghdr *n, int maxlen, const char *proto)
 	return 0;
 }
 
+static int mdb_parse_dst(struct nlmsghdr *n, int maxlen, const char *dst)
+{
+	struct in6_addr dst_ip6;
+	__be32 dst_ip4;
+
+	if (inet_pton(AF_INET, dst, &dst_ip4)) {
+		addattr32(n, maxlen, MDBE_ATTR_DST, dst_ip4);
+		return 0;
+	}
+
+	if (inet_pton(AF_INET6, dst, &dst_ip6)) {
+		addattr_l(n, maxlen, MDBE_ATTR_DST, &dst_ip6,
+			  sizeof(dst_ip6));
+		return 0;
+	}
+
+	return -1;
+}
+
 static int mdb_modify(int cmd, int flags, int argc, char **argv)
 {
 	struct {
@@ -583,7 +620,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 		.bpm.family = PF_BRIDGE,
 	};
 	char *d = NULL, *p = NULL, *grp = NULL, *src = NULL, *mode = NULL;
-	char *src_list = NULL, *proto = NULL;
+	char *src_list = NULL, *proto = NULL, *dst = NULL;
 	struct br_mdb_entry entry = {};
 	bool set_attrs = false;
 	short vid = 0;
@@ -622,6 +659,10 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			NEXT_ARG();
 			proto = *argv;
 			set_attrs = true;
+		} else if (strcmp(*argv, "dst") == 0) {
+			NEXT_ARG();
+			dst = *argv;
+			set_attrs = true;
 		} else {
 			if (matches(*argv, "help") == 0)
 				usage();
@@ -675,6 +716,12 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			return -1;
 		}
 
+		if (dst && mdb_parse_dst(&req.n, sizeof(req), dst)) {
+			fprintf(stderr, "Invalid underlay destination address \"%s\"\n",
+				dst);
+			return -1;
+		}
+
 		addattr_nest_end(&req.n, nest);
 	}
 
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index abc0417b2057..2f8500af1f02 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -145,7 +145,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B source_list
 .IR SOURCE_LIST " ] [ "
 .B proto
-.IR PROTO " ]
+.IR PROTO " ] [ "
+.B dst
+.IR IPADDR " ]
 
 .ti -8
 .BR "bridge mdb show" " [ "
@@ -969,6 +971,17 @@ then
 .B static
 is assumed.
 
+.in -8
+The next command line parameters apply only
+when the specified device
+.I DEV
+is of type VXLAN.
+
+.TP
+.BI dst " IPADDR"
+the IP address of the destination
+VXLAN tunnel endpoint where the multicast receivers reside.
+
 .in -8
 .SS bridge mdb delete - delete a multicast group database entry
 This command removes an existing mdb entry.
-- 
2.37.3

