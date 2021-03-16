Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7172433D1B7
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 11:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbhCPKV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 06:21:57 -0400
Received: from mail-dm3nam07on2089.outbound.protection.outlook.com ([40.107.95.89]:61473
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236631AbhCPKVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 06:21:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtC5C2aV9ebuvvqYkRH0016YZizHYzvD2EITvuaMU3xjQVTb0zetj4t9RbeJE6bJFsZeR6HYfHCJqE8beuc3O5/SkOESc3c/nlE3nT2COWQQUX3doa6vaLP+fGztOFWugOH9vIme1uNsgv8vIXfUW1ES/rt02cBL6mAVGuu6EB/MV6qBwLok7AGwGNuBkhaswXXHLu28HjJMKp/Er2C0DI3TOQte08NSx0t+Sw3QtDIkH919cFxlWdjiJEsh3kX8uqB8OQn+HZuMcnT/hDDfXuixg2cLBr/u50zcqBcO6J40slxONrZux7h1Pg7I/fUpupE9VpW7gPhl6T9g0FqW4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XumUI+ja+nEBsrt0qqJHPUnSTG9CpLjnoVMhB+IatzE=;
 b=bedbS1uJyRD2xMgXFdnr+MsxKV96wTiE+kxvZ3i8RpnzPmEDXhwbk600uD50Y7iK1AkdXarHfizFqTJQlpyDEAvr1PYNWqrGxIDC1OQf93rcmj4EVO5SQGJcHN1Cq5FqBROLxlbzeTl5kYhh8Iby637khlWsz7IxkgJKcV8ny4kWNDg8cQ6eEV2ps3GF/84FQPBGtYBuSlcDKHxwrTiXDwheNpGPa52USdoX/yrDjafVz7pf6HYY2+vHucrL/Z8IhhwH+Ulz7WJM7n8wcS///aW7c3XmkUAwKEtiSSuwFO3lV/grsPi3GGziNKy7DGS97yD6tzJQWQmziFzh0EwUBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XumUI+ja+nEBsrt0qqJHPUnSTG9CpLjnoVMhB+IatzE=;
 b=qiMeKVxHnfrWt9TUtHt5HjnEFbbP/AcGghayllmXPw8au936SkRrvVXuujCNDdUfqwQErTs6veBmN+Wlo1uCLXn/BLTGVOzfFaQV9EUmi/7VJ09hFz6v622loThLjwTu6kplij6jC+ozpsjY1yUKTUUGXKqXlFfjqEGNfIs++l9FTPcVaywlj/F+As+3Fa5rS9FgQll+fLmJpz7d8fBhI4GPXQX1mXu1BdN2TGbUINKKEx2mIOlTWJnnM1OQKtzYpCqZjWwkRJjyPz6MKSnEADQyc3h2E/IYi2OD3pMAHLJLwhIw6pJYfG39e7+4Tp38zq1W22CzGMFklE2s6h84/g==
Received: from BN6PR2001CA0006.namprd20.prod.outlook.com
 (2603:10b6:404:b4::16) by BN8PR12MB4771.namprd12.prod.outlook.com
 (2603:10b6:408:a5::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 10:21:20 +0000
Received: from BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::27) by BN6PR2001CA0006.outlook.office365.com
 (2603:10b6:404:b4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Tue, 16 Mar 2021 10:21:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT066.mail.protection.outlook.com (10.13.177.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 10:21:20 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar
 2021 10:21:14 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v3 6/6] nexthop: Add support for nexthop buckets
Date:   Tue, 16 Mar 2021 11:20:16 +0100
Message-ID: <3cba50e45bcfcf75a64ca1f75ec909c808ae27cf.1615889875.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 72c39b95-fa9c-480d-8481-08d8e8653e1e
X-MS-TrafficTypeDiagnostic: BN8PR12MB4771:
X-Microsoft-Antispam-PRVS: <BN8PR12MB47713E258779F3F20DB90B22D66B9@BN8PR12MB4771.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5xth20L9IUGI8O+9NpQtSccDVKk5zJiRoI04EWeqj0gOXkzNbFcwHfAzVyPgUAeBdrLwX9p6w4ZB0KjI2dnGL2iVEYNGS90NmQG/9QubSgrZeHXAMc09PQ6z7fc6RRk8xy+yxeMmXoAg3g8VZXneMnXbmUmgmzh4+sInIBcGYhgR9IJbpNY2vNm8RDfzT72SPYggMQi95tSZqJ80y1b7fb6n2ceT5tKvu8inJAbtOF0GLoJf+2sWC9T/QIxah0YelX7UKZYa58STrMwbMDYl29NWyhHnGJ3WhJhZ7bc4jb+FmVzoFPvYsmfwx8D0XAMtzjTCz7pl5asrNvLlPHoUtx8UIj0dfOp59hNt8gbJs408BXMGyqynNNUphz71ZZwFM16QX/Hv4q5NxIka1bQ0Duz915yrjzlC9d+IT1HY7trb9U6YQNxMISamS9KcHGT6RxEl3bEBFm5Zf73NHP5gmJjc33tfRk4EdUE8BV+HjGaZ9FWEBI3697N1xEPq8OLcXrJYoU3x1Vt7ESHHsSPiTmURNqQPZOx/toQmO1obOKYKLv8prqTL5aaCd+Ov85q1WlaEKFJ23XQpQNT3M1lpZjwaurH+wFEPxOXPeFfUGSx/yWaP249P/kCR/XgaV525FZ+AVXomGDROoZ+NnCjvfVLA2Nupsg+lnxceaBFz3JHQatz9ajqJqI9yGYOiVfnj
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(46966006)(36840700001)(316002)(110136005)(30864003)(82310400003)(36906005)(7636003)(26005)(34020700004)(36756003)(47076005)(70586007)(16526019)(2906002)(86362001)(2616005)(107886003)(5660300002)(54906003)(70206006)(186003)(4326008)(336012)(36860700001)(8676002)(426003)(83380400001)(82740400003)(356005)(8936002)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 10:21:20.2914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c39b95-fa9c-480d-8481-08d8e8653e1e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4771
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add ability to dump multiple nexthop buckets and get a specific one.
Example:

 # ip nexthop add id 10 group 1/2 type resilient buckets 8
 # ip nexthop
 id 1 via 192.0.2.2 dev dummy10 scope link
 id 2 via 192.0.2.19 dev dummy20 scope link
 id 10 group 1/2 type resilient buckets 8 idle_timer 120 unbalanced_timer 0 unbalanced_time 0
 # ip nexthop bucket
 id 10 index 0 idle_time 28.1 nhid 2
 id 10 index 1 idle_time 28.1 nhid 2
 id 10 index 2 idle_time 28.1 nhid 2
 id 10 index 3 idle_time 28.1 nhid 2
 id 10 index 4 idle_time 28.1 nhid 1
 id 10 index 5 idle_time 28.1 nhid 1
 id 10 index 6 idle_time 28.1 nhid 1
 id 10 index 7 idle_time 28.1 nhid 1
 # ip nexthop bucket show nhid 1
 id 10 index 4 idle_time 53.59 nhid 1
 id 10 index 5 idle_time 53.59 nhid 1
 id 10 index 6 idle_time 53.59 nhid 1
 id 10 index 7 idle_time 53.59 nhid 1
 # ip nexthop bucket get id 10 index 5
 id 10 index 5 idle_time 81 nhid 1
 # ip -j -p nexthop bucket get id 10 index 5
 [ {
         "id": 10,
         "bucket": {
             "index": 5,
             "idle_time": 104.89,
             "nhid": 1
         },
         "flags": [ ]
     } ]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 include/libnetlink.h  |   3 +
 ip/ip_common.h        |   1 +
 ip/ipmonitor.c        |   6 +
 ip/ipnexthop.c        | 254 ++++++++++++++++++++++++++++++++++++++++++
 lib/libnetlink.c      |  26 +++++
 man/man8/ip-nexthop.8 |  45 ++++++++
 6 files changed, 335 insertions(+)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index b9073a6a13ad..e8ed5d7fb495 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -97,6 +97,9 @@ int rtnl_dump_request_n(struct rtnl_handle *rth, struct nlmsghdr *n)
 int rtnl_nexthopdump_req(struct rtnl_handle *rth, int family,
 			 req_filter_fn_t filter_fn)
 	__attribute__((warn_unused_result));
+int rtnl_nexthop_bucket_dump_req(struct rtnl_handle *rth, int family,
+				 req_filter_fn_t filter_fn)
+	__attribute__((warn_unused_result));
 
 struct rtnl_ctrl_data {
 	int	nsid;
diff --git a/ip/ip_common.h b/ip/ip_common.h
index 9a31e837563f..55a5521c4275 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -53,6 +53,7 @@ int print_rule(struct nlmsghdr *n, void *arg);
 int print_netconf(struct rtnl_ctrl_data *ctrl,
 		  struct nlmsghdr *n, void *arg);
 int print_nexthop(struct nlmsghdr *n, void *arg);
+int print_nexthop_bucket(struct nlmsghdr *n, void *arg);
 void netns_map_init(void);
 void netns_nsid_socket_init(void);
 int print_nsid(struct nlmsghdr *n, void *arg);
diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index 99f5fda8ba1f..d7f31cf5d1b5 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -90,6 +90,12 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 		print_nexthop(n, arg);
 		return 0;
 
+	case RTM_NEWNEXTHOPBUCKET:
+	case RTM_DELNEXTHOPBUCKET:
+		print_headers(fp, "[NEXTHOPBUCKET]", ctrl);
+		print_nexthop_bucket(n, arg);
+		return 0;
+
 	case RTM_NEWLINK:
 	case RTM_DELLINK:
 		ll_remember_index(n, NULL);
diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 1d50bf7529c4..0263307c49df 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -21,6 +21,8 @@ static struct {
 	unsigned int master;
 	unsigned int proto;
 	unsigned int fdb;
+	unsigned int id;
+	unsigned int nhid;
 } filter;
 
 enum {
@@ -39,8 +41,11 @@ static void usage(void)
 		"Usage: ip nexthop { list | flush } [ protocol ID ] SELECTOR\n"
 		"       ip nexthop { add | replace } id ID NH [ protocol ID ]\n"
 		"       ip nexthop { get | del } id ID\n"
+		"       ip nexthop bucket list BUCKET_SELECTOR\n"
+		"       ip nexthop bucket get id ID index INDEX\n"
 		"SELECTOR := [ id ID ] [ dev DEV ] [ vrf NAME ] [ master DEV ]\n"
 		"            [ groups ] [ fdb ]\n"
+		"BUCKET_SELECTOR := SELECTOR | [ nhid ID ]\n"
 		"NH := { blackhole | [ via ADDRESS ] [ dev DEV ] [ onlink ]\n"
 		"        [ encap ENCAPTYPE ENCAPHDR ] |\n"
 		"        group GROUP [ fdb ] [ type TYPE [ TYPE_ARGS ] ] }\n"
@@ -85,6 +90,36 @@ static int nh_dump_filter(struct nlmsghdr *nlh, int reqlen)
 	return 0;
 }
 
+static int nh_dump_bucket_filter(struct nlmsghdr *nlh, int reqlen)
+{
+	struct rtattr *nest;
+	int err = 0;
+
+	err = nh_dump_filter(nlh, reqlen);
+	if (err)
+		return err;
+
+	if (filter.id) {
+		err = addattr32(nlh, reqlen, NHA_ID, filter.id);
+		if (err)
+			return err;
+	}
+
+	if (filter.nhid) {
+		nest = addattr_nest(nlh, reqlen, NHA_RES_BUCKET);
+		nest->rta_type |= NLA_F_NESTED;
+
+		err = addattr32(nlh, reqlen, NHA_RES_BUCKET_NH_ID,
+				filter.nhid);
+		if (err)
+			return err;
+
+		addattr_nest_end(nlh, nest);
+	}
+
+	return err;
+}
+
 static struct rtnl_handle rth_del = { .fd = -1 };
 
 static int delete_nexthop(__u32 id)
@@ -266,6 +301,33 @@ static void print_nh_res_group(FILE *fp, const struct rtattr *res_grp_attr)
 	close_json_object();
 }
 
+static void print_nh_res_bucket(FILE *fp, const struct rtattr *res_bucket_attr)
+{
+	struct rtattr *tb[NHA_RES_BUCKET_MAX + 1];
+
+	parse_rtattr_nested(tb, NHA_RES_BUCKET_MAX, res_bucket_attr);
+
+	open_json_object("bucket");
+
+	if (tb[NHA_RES_BUCKET_INDEX])
+		print_uint(PRINT_ANY, "index", "index %u ",
+			   rta_getattr_u16(tb[NHA_RES_BUCKET_INDEX]));
+
+	if (tb[NHA_RES_BUCKET_IDLE_TIME]) {
+		struct rtattr *rta = tb[NHA_RES_BUCKET_IDLE_TIME];
+		struct timeval tv;
+
+		__jiffies_to_tv(&tv, rta_getattr_u64(rta));
+		print_tv(PRINT_ANY, "idle_time", "idle_time %g ", &tv);
+	}
+
+	if (tb[NHA_RES_BUCKET_NH_ID])
+		print_uint(PRINT_ANY, "nhid", "nhid %u ",
+			   rta_getattr_u32(tb[NHA_RES_BUCKET_NH_ID]));
+
+	close_json_object();
+}
+
 int print_nexthop(struct nlmsghdr *n, void *arg)
 {
 	struct nhmsg *nhm = NLMSG_DATA(n);
@@ -346,6 +408,50 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
+int print_nexthop_bucket(struct nlmsghdr *n, void *arg)
+{
+	struct nhmsg *nhm = NLMSG_DATA(n);
+	struct rtattr *tb[NHA_MAX+1];
+	FILE *fp = (FILE *)arg;
+	int len;
+
+	if (n->nlmsg_type != RTM_DELNEXTHOPBUCKET &&
+	    n->nlmsg_type != RTM_NEWNEXTHOPBUCKET) {
+		fprintf(stderr, "Not a nexthop bucket: %08x %08x %08x\n",
+			n->nlmsg_len, n->nlmsg_type, n->nlmsg_flags);
+		return -1;
+	}
+
+	len = n->nlmsg_len - NLMSG_SPACE(sizeof(*nhm));
+	if (len < 0) {
+		close_json_object();
+		fprintf(stderr, "BUG: wrong nlmsg len %d\n", len);
+		return -1;
+	}
+
+	parse_rtattr_flags(tb, NHA_MAX, RTM_NHA(nhm), len, NLA_F_NESTED);
+
+	open_json_object(NULL);
+
+	if (n->nlmsg_type == RTM_DELNEXTHOP)
+		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
+
+	if (tb[NHA_ID])
+		print_uint(PRINT_ANY, "id", "id %u ",
+			   rta_getattr_u32(tb[NHA_ID]));
+
+	if (tb[NHA_RES_BUCKET])
+		print_nh_res_bucket(fp, tb[NHA_RES_BUCKET]);
+
+	print_rt_flags(fp, nhm->nh_flags);
+
+	print_string(PRINT_FP, NULL, "%s", "\n");
+	close_json_object();
+	fflush(fp);
+
+	return 0;
+}
+
 static int add_nh_group_attr(struct nlmsghdr *n, int maxlen, char *argv)
 {
 	struct nexthop_grp *grps;
@@ -721,6 +827,151 @@ static int ipnh_get(int argc, char **argv)
 	return ipnh_get_id(id);
 }
 
+static int ipnh_bucket_list(int argc, char **argv)
+{
+	while (argc > 0) {
+		if (!matches(*argv, "dev")) {
+			NEXT_ARG();
+			filter.ifindex = ll_name_to_index(*argv);
+			if (!filter.ifindex)
+				invarg("Device does not exist\n", *argv);
+		} else if (!matches(*argv, "master")) {
+			NEXT_ARG();
+			filter.master = ll_name_to_index(*argv);
+			if (!filter.master)
+				invarg("Device does not exist\n", *argv);
+		} else if (matches(*argv, "vrf") == 0) {
+			NEXT_ARG();
+			if (!name_is_vrf(*argv))
+				invarg("Invalid VRF\n", *argv);
+			filter.master = ll_name_to_index(*argv);
+			if (!filter.master)
+				invarg("VRF does not exist\n", *argv);
+		} else if (!strcmp(*argv, "id")) {
+			NEXT_ARG();
+			filter.id = ipnh_parse_id(*argv);
+		} else if (!strcmp(*argv, "nhid")) {
+			NEXT_ARG();
+			filter.nhid = ipnh_parse_id(*argv);
+		} else if (matches(*argv, "help") == 0) {
+			usage();
+		} else {
+			invarg("", *argv);
+		}
+		argc--; argv++;
+	}
+
+	if (rtnl_nexthop_bucket_dump_req(&rth, preferred_family,
+					 nh_dump_bucket_filter) < 0) {
+		perror("Cannot send dump request");
+		return -2;
+	}
+
+	new_json_obj(json);
+
+	if (rtnl_dump_filter(&rth, print_nexthop_bucket, stdout) < 0) {
+		fprintf(stderr, "Dump terminated\n");
+		return -2;
+	}
+
+	delete_json_obj();
+	fflush(stdout);
+
+	return 0;
+}
+
+static int ipnh_bucket_get_id(__u32 id, __u16 bucket_index)
+{
+	struct {
+		struct nlmsghdr	n;
+		struct nhmsg	nhm;
+		char		buf[1024];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct nhmsg)),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.n.nlmsg_type  = RTM_GETNEXTHOPBUCKET,
+		.nhm.nh_family = preferred_family,
+	};
+	struct nlmsghdr *answer;
+	struct rtattr *nest;
+
+	addattr32(&req.n, sizeof(req), NHA_ID, id);
+
+	nest = addattr_nest(&req.n, sizeof(req), NHA_RES_BUCKET);
+	nest->rta_type |= NLA_F_NESTED;
+
+	addattr16(&req.n, sizeof(req), NHA_RES_BUCKET_INDEX, bucket_index);
+
+	addattr_nest_end(&req.n, nest);
+
+	if (rtnl_talk(&rth, &req.n, &answer) < 0)
+		return -2;
+
+	new_json_obj(json);
+
+	if (print_nexthop_bucket(answer, (void *)stdout) < 0) {
+		free(answer);
+		return -1;
+	}
+
+	delete_json_obj();
+	fflush(stdout);
+
+	free(answer);
+
+	return 0;
+}
+
+static int ipnh_bucket_get(int argc, char **argv)
+{
+	bool bucket_valid = false;
+	__u16 bucket_index;
+	__u32 id = 0;
+
+	while (argc > 0) {
+		if (!strcmp(*argv, "id")) {
+			NEXT_ARG();
+			id = ipnh_parse_id(*argv);
+		} else if (!strcmp(*argv, "index")) {
+			NEXT_ARG();
+			if (get_u16(&bucket_index, *argv, 0))
+				invarg("invalid bucket index value", *argv);
+			bucket_valid = true;
+		} else  {
+			usage();
+		}
+		argc--; argv++;
+	}
+
+	if (!id || !bucket_valid) {
+		usage();
+		return -1;
+	}
+
+	return ipnh_bucket_get_id(id, bucket_index);
+}
+
+static int do_ipnh_bucket(int argc, char **argv)
+{
+	if (argc < 1)
+		return ipnh_bucket_list(0, NULL);
+
+	if (!matches(*argv, "list") ||
+	    !matches(*argv, "show") ||
+	    !matches(*argv, "lst"))
+		return ipnh_bucket_list(argc-1, argv+1);
+
+	if (!matches(*argv, "get"))
+		return ipnh_bucket_get(argc-1, argv+1);
+
+	if (!matches(*argv, "help"))
+		usage();
+
+	fprintf(stderr,
+		"Command \"%s\" is unknown, try \"ip nexthop help\".\n", *argv);
+	exit(-1);
+}
+
 int do_ipnh(int argc, char **argv)
 {
 	if (argc < 1)
@@ -746,6 +997,9 @@ int do_ipnh(int argc, char **argv)
 	if (!matches(*argv, "flush"))
 		return ipnh_list_flush(argc-1, argv+1, IPNH_FLUSH);
 
+	if (!matches(*argv, "bucket"))
+		return do_ipnh_bucket(argc-1, argv+1);
+
 	if (!matches(*argv, "help"))
 		usage();
 
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index c958aa57d0cd..6885087b34f9 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -282,6 +282,32 @@ int rtnl_nexthopdump_req(struct rtnl_handle *rth, int family,
 	return send(rth->fd, &req, sizeof(req), 0);
 }
 
+int rtnl_nexthop_bucket_dump_req(struct rtnl_handle *rth, int family,
+				 req_filter_fn_t filter_fn)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct nhmsg nhm;
+		char buf[128];
+	} req = {
+		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct nhmsg)),
+		.nlh.nlmsg_type = RTM_GETNEXTHOPBUCKET,
+		.nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
+		.nlh.nlmsg_seq = rth->dump = ++rth->seq,
+		.nhm.nh_family = family,
+	};
+
+	if (filter_fn) {
+		int err;
+
+		err = filter_fn(&req.nlh, sizeof(req));
+		if (err)
+			return err;
+	}
+
+	return send(rth->fd, &req, sizeof(req), 0);
+}
+
 int rtnl_addrdump_req(struct rtnl_handle *rth, int family,
 		      req_filter_fn_t filter_fn)
 {
diff --git a/man/man8/ip-nexthop.8 b/man/man8/ip-nexthop.8
index c1ac130c2a2f..f81a5910bf22 100644
--- a/man/man8/ip-nexthop.8
+++ b/man/man8/ip-nexthop.8
@@ -28,6 +28,14 @@ ip-nexthop \- nexthop object management
 .BR "ip nexthop" " { " get " | " del " } id "
 .I  ID
 
+.ti -8
+.BI "ip nexthop bucket list " BUCKET_SELECTOR
+
+.ti -8
+.BR "ip nexthop bucket get " id
+.I  ID
+.RI "index " INDEX
+
 .ti -8
 .IR SELECTOR " := "
 .RB "[ " id
@@ -41,6 +49,12 @@ ip-nexthop \- nexthop object management
 .BR  groups " ] [ "
 .BR  fdb " ]"
 
+.ti -8
+.IR BUCKET_SELECTOR " := "
+.IR SELECTOR
+.RB " | [ " nhid
+.IR ID " ]"
+
 .ti -8
 .IR NH " := { "
 .BR blackhole " | [ "
@@ -230,6 +244,37 @@ as show.
 ip nexthop get id ID
 get a single nexthop by id
 
+.TP
+ip nexthop bucket show
+show the contents of the nexthop bucket table or the nexthop buckets
+selected by some criteria.
+.RS
+.TP
+.BI id " ID "
+.in +0
+show the nexthop buckets that belong to a nexthop group with a given id
+.TP
+.BI nhid " ID "
+.in +0
+show the nexthop buckets that hold a nexthop with a given id
+.TP
+.BI dev " DEV "
+.in +0
+show the nexthop buckets using the given device
+.TP
+.BI vrf " NAME "
+.in +0
+show the nexthop buckets using devices associated with the vrf name
+.TP
+.BI master " DEV "
+.in +0
+show the nexthop buckets using devices enslaved to given master device
+.RE
+
+.TP
+ip nexthop bucket get id ID index INDEX
+get a single nexthop bucket by nexthop group id and bucket index
+
 .SH EXAMPLES
 .PP
 ip nexthop ls
-- 
2.26.2

