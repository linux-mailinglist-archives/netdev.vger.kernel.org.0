Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095CF50B2EF
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237544AbiDVIet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445065AbiDVIed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:34:33 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A255A52E58
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 01:31:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnJ8+gqRLlmyS51E5dGY68WpJd7/ErGeFClwkLWKIuc5/T7IN68cSqY3S5OzAcwwIZ9jLM4kALN0Wsq1ZWEd6biXIug3L6X6fnjdhYz7j4JmQgUFPj+2O4KD3vCV41Ggmk26keCmHWVQRNPSqDOaGIXDgsVKQ/w9cVL0c31T7o0Ux/Tadt/rk2EUvrXKjf9LK9EaNnLh5nAb6/r3DKUD3fnWqfP1mIwVDEge3pk3ghISbrJZCqGIThBFtQSY604+JZBtFLAg2cvzshjUwNVMRaA0npVjuikDRdvMyYHaPs/LXox0QyCAm/zF2Pekq+3aH6or167s6t/Z49quMH/AXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lmSgSNU0AOeSiE7+j4ut120m4g2q6CS4LZTUEI7Qc58=;
 b=NYXwQvIlARTtWjFnJ1zypQU4ZkJrrU0FATY9Vi2N45hqvcr/d5h2tbUmZ3E+hlCxJscoyUFeDSAbgOdfmrh++S6LnVviCfaViXHUPmkCIyJvjv5dBQdeji741MqRPDA/0dUoBVIcwwPlJO18o5Iq3IIJZilm0TLt0sMicemeN2OBzWscG+fanlrR7h91czM2BW2fgtrBTpzALWsQ4gGGVbe0QiD84CRC/5G4Yn4JnInk2eD91zyRDNL3ZCxl6pMBPQIEkiF+HmVyxqr4+BMEdq1Es94osGNRGGsojahQmblh5VbYtk9VGYpX2VO72fa9e4J9NWfdtiKfLo5ZU2q4PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmSgSNU0AOeSiE7+j4ut120m4g2q6CS4LZTUEI7Qc58=;
 b=MBG2f06VThxtr4hLdqauMF5GlBZUa5v+3bGH/pdkkNWRRbZTXNfNIhGcepWgnIgHURG2ktgEVrIFCJtNJ3+EZGfU/YrXOqEew4iRF8nljpQJ4zni0xDlm7yF+Le9gKWiSYxouReZobxGm6GqQI8/OOqKcmHErYr4kTwLuQbNlNC0ID6ujrhVJF7lZMOmhtzvggAGPFbRSxGLPAecVDSUa62j4ShcrCNpbe5iKTlQdQ700soz+ne6ymh8hQOFOUBEtGvTJoIHYchooQd/GeILXeL5vt1ogVMCjjGdYwABk3AXf/gKMEYJaQlLsLcaRbjMAzYO977XkzyA7x5sWk772g==
Received: from DS7PR05CA0071.namprd05.prod.outlook.com (2603:10b6:8:57::14) by
 DS7PR12MB5936.namprd12.prod.outlook.com (2603:10b6:8:7f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5164.20; Fri, 22 Apr 2022 08:31:39 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::b2) by DS7PR05CA0071.outlook.office365.com
 (2603:10b6:8:57::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6 via Frontend
 Transport; Fri, 22 Apr 2022 08:31:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 08:31:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 08:31:37 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 01:31:35 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 05/11] ipstats: Add a shell of "show" command
Date:   Fri, 22 Apr 2022 10:30:54 +0200
Message-ID: <23fce511c8d55a07204b22d59dd3ffabf3c0abe6.1650615982.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1650615982.git.petrm@nvidia.com>
References: <cover.1650615982.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76d2d49d-2748-46a7-3650-08da243a855f
X-MS-TrafficTypeDiagnostic: DS7PR12MB5936:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB5936616E02F6CC7E1266D1C6D6F79@DS7PR12MB5936.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qsDyboQqoFZA3TGxMp9rmWsBXWDek/3BwMd2ccd47OQy0xkdQre+USBjD1/D1X15jSG8L0HOi/jPd1dSUMGLTECEyXgDm2WxGb6f4fJcHioBOzL36xca7skR8z0aOf2/gFjzW5cLin9jMjFz3ksBSDbvrfCFrrWcZkb4+6s9sKDQK1LWuJvuxWAmdGdXG1FiZmc5MK+Sig3AY3+jqpuStBltmuuWq6ahhWwYWiMPS5fFzcXN7S2rcYdGR2v+YuRFJ5nkao1oyWD3gTIvrbxB/tA6dsQKg7berkC/3tU4yhVfihMHgBUdd75VRMvyO+3u1npCC3o3rMdwuu5oguglYCMX1mblEjK+7Wb+oP5tXfKDCNzZTNqZNjCtPsaYxq+KX7pKt5cWIf9r2/wxZZLp9HPABCY5tt/gHlXUvKtJP9U2YzM9Ml9GFJ2k6t1gvwAIkIo2Em4huO/9t3kopnVVi0Q1ZSYYDlNjkD8jmZ/voiUERiK9x24ASv2SRzMshnlUuppogL4n4NWO+COgKJCeWJOciZd9C9tnEFNsetYmw1w76RnIDLO0M2DdJ54NXmL84ufJ11z662pTopiLif6HZtCbFGq1Pn1BuIXAWFUlXdZqaqBNaRL+cr0iGOYtzh5bMkM2A/CsBjk5/0OVR8wNiZBjIk242zs4+nxg1sSWjigOkJSeBS2gIvw7j3dEdRFjY76Rnz+Yd/MrOfPS4TLbcQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(107886003)(54906003)(47076005)(2616005)(26005)(186003)(336012)(2906002)(86362001)(426003)(30864003)(16526019)(82310400005)(40460700003)(81166007)(8936002)(36756003)(356005)(70586007)(6666004)(508600001)(6916009)(83380400001)(5660300002)(4326008)(70206006)(36860700001)(8676002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 08:31:38.9409
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76d2d49d-2748-46a7-3650-08da243a855f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5936
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the scaffolding necessary for adding individual stats suites to show.

Expose some ipstats artifacts in ip_common.h. These will be used to support
"xstats" in a follow-up patchset.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ip_common.h |  26 +++
 ip/ipstats.c   | 614 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 638 insertions(+), 2 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index 53866d7a..8b0a6426 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -158,6 +158,32 @@ void xdp_dump(FILE *fp, struct rtattr *tb, bool link, bool details);
 __u32 ipvrf_get_table(const char *name);
 int name_is_vrf(const char *name);
 
+/* ipstats.c */
+enum ipstats_stat_desc_kind {
+	IPSTATS_STAT_DESC_KIND_LEAF,
+	IPSTATS_STAT_DESC_KIND_GROUP,
+};
+
+struct ipstats_stat_dump_filters;
+struct ipstats_stat_show_attrs;
+
+struct ipstats_stat_desc {
+	const char *name;
+	enum ipstats_stat_desc_kind kind;
+	union {
+		struct {
+			const struct ipstats_stat_desc **subs;
+			size_t nsubs;
+		};
+		struct {
+			void (*pack)(struct ipstats_stat_dump_filters *filters,
+				     const struct ipstats_stat_desc *desc);
+			int (*show)(struct ipstats_stat_show_attrs *attrs,
+				    const struct ipstats_stat_desc *desc);
+		};
+	};
+};
+
 #ifndef	INFINITY_LIFE_TIME
 #define     INFINITY_LIFE_TIME      0xFFFFFFFFU
 #endif
diff --git a/ip/ipstats.c b/ip/ipstats.c
index 1f5b3f77..79f7b1ff 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -1,19 +1,624 @@
 // SPDX-License-Identifier: GPL-2.0+
+#include <assert.h>
 #include <errno.h>
 
 #include "utils.h"
 #include "ip_common.h"
 
+struct ipstats_stat_dump_filters {
+	/* mask[0] filters outer attributes. Then individual nests have their
+	 * filtering mask at the index of the nested attribute.
+	 */
+	__u32 mask[IFLA_STATS_MAX + 1];
+};
+
+struct ipstats_stat_show_attrs {
+	struct if_stats_msg *ifsm;
+	int len;
+
+	/* tbs[0] contains top-level attribute table. Then individual nests have
+	 * their attribute tables at the index of the nested attribute.
+	 */
+	struct rtattr **tbs[IFLA_STATS_MAX + 1];
+};
+
+static const char *const ipstats_levels[] = {
+	"group",
+	"subgroup",
+};
+
+enum {
+	IPSTATS_LEVELS_COUNT = ARRAY_SIZE(ipstats_levels),
+};
+
+struct ipstats_sel {
+	const char *sel[IPSTATS_LEVELS_COUNT];
+};
+
+struct ipstats_stat_enabled_one {
+	const struct ipstats_stat_desc *desc;
+	struct ipstats_sel sel;
+};
+
+struct ipstats_stat_enabled {
+	struct ipstats_stat_enabled_one *enabled;
+	size_t nenabled;
+};
+
+static const unsigned int ipstats_stat_ifla_max[] = {
+	[0] = IFLA_STATS_MAX,
+	[IFLA_STATS_LINK_XSTATS] = LINK_XSTATS_TYPE_MAX,
+	[IFLA_STATS_LINK_XSTATS_SLAVE] = LINK_XSTATS_TYPE_MAX,
+	[IFLA_STATS_LINK_OFFLOAD_XSTATS] = IFLA_OFFLOAD_XSTATS_MAX,
+	[IFLA_STATS_AF_SPEC] = AF_MAX - 1,
+};
+
+static_assert(ARRAY_SIZE(ipstats_stat_ifla_max) == IFLA_STATS_MAX + 1,
+	      "An IFLA_STATS attribute is missing from the ifla_max table");
+
+static int
+ipstats_stat_show_attrs_alloc_tb(struct ipstats_stat_show_attrs *attrs,
+				 unsigned int group)
+{
+	unsigned int ifla_max;
+	int err;
+
+	assert(group < ARRAY_SIZE(ipstats_stat_ifla_max));
+	assert(group < ARRAY_SIZE(attrs->tbs));
+	ifla_max = ipstats_stat_ifla_max[group];
+	assert(ifla_max != 0);
+
+	if (attrs->tbs[group])
+		return 0;
+
+	attrs->tbs[group] = calloc(ifla_max + 1, sizeof(*attrs->tbs[group]));
+	if (attrs->tbs[group] == NULL)
+		return -ENOMEM;
+
+	if (group == 0)
+		err = parse_rtattr(attrs->tbs[group], ifla_max,
+				   IFLA_STATS_RTA(attrs->ifsm), attrs->len);
+	else
+		err = parse_rtattr_nested(attrs->tbs[group], ifla_max,
+					  attrs->tbs[0][group]);
+
+	if (err != 0) {
+		free(attrs->tbs[group]);
+		attrs->tbs[group] = NULL;
+	}
+	return err;
+}
+
+static void
+ipstats_stat_show_attrs_free(struct ipstats_stat_show_attrs *attrs)
+{
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(attrs->tbs); i++)
+		free(attrs->tbs[i]);
+}
+
+static const struct ipstats_stat_desc *ipstats_stat_desc_toplev_subs[] = {
+};
+
+static const struct ipstats_stat_desc ipstats_stat_desc_toplev_group = {
+	.name = "top-level",
+	.kind = IPSTATS_STAT_DESC_KIND_GROUP,
+	.subs = ipstats_stat_desc_toplev_subs,
+	.nsubs = ARRAY_SIZE(ipstats_stat_desc_toplev_subs),
+};
+
+static void ipstats_show_group(const struct ipstats_sel *sel)
+{
+	int i;
+
+	for (i = 0; i < IPSTATS_LEVELS_COUNT; i++) {
+		if (sel->sel[i] == NULL)
+			break;
+		print_string(PRINT_JSON, ipstats_levels[i], NULL, sel->sel[i]);
+		print_string(PRINT_FP, NULL, " %s ", ipstats_levels[i]);
+		print_string(PRINT_FP, NULL, "%s", sel->sel[i]);
+	}
+}
+
+static int
+ipstats_process_ifsm(struct nlmsghdr *answer,
+		     struct ipstats_stat_enabled *enabled)
+{
+	struct ipstats_stat_show_attrs show_attrs = {};
+	const char *dev;
+	int err = 0;
+	int i;
+
+	show_attrs.ifsm = NLMSG_DATA(answer);
+	show_attrs.len = (answer->nlmsg_len -
+			  NLMSG_LENGTH(sizeof(*show_attrs.ifsm)));
+	if (show_attrs.len < 0) {
+		fprintf(stderr, "BUG: wrong nlmsg len %d\n", show_attrs.len);
+		return -EINVAL;
+	}
+
+	err = ipstats_stat_show_attrs_alloc_tb(&show_attrs, 0);
+	if (err != 0) {
+		fprintf(stderr, "Error parsing netlink answer: %s\n",
+			strerror(err));
+		return err;
+	}
+
+	dev = ll_index_to_name(show_attrs.ifsm->ifindex);
+
+	for (i = 0; i < enabled->nenabled; i++) {
+		const struct ipstats_stat_desc *desc = enabled->enabled[i].desc;
+
+		open_json_object(NULL);
+		print_int(PRINT_ANY, "ifindex", "%d:",
+			  show_attrs.ifsm->ifindex);
+		print_color_string(PRINT_ANY, COLOR_IFNAME,
+				   "ifname", " %s:", dev);
+		ipstats_show_group(&enabled->enabled[i].sel);
+		err = desc->show(&show_attrs, desc);
+		if (err != 0)
+			goto out;
+		close_json_object();
+		print_nl();
+	}
+
+out:
+	ipstats_stat_show_attrs_free(&show_attrs);
+	return err;
+}
+
+static bool
+ipstats_req_should_filter_at(struct ipstats_stat_dump_filters *filters, int at)
+{
+	return filters->mask[at] != 0 &&
+	       filters->mask[at] != (1 << ipstats_stat_ifla_max[at]) - 1;
+}
+
+static int
+ipstats_req_add_filters(struct ipstats_req *req, void *data)
+{
+	struct ipstats_stat_dump_filters dump_filters = {};
+	struct ipstats_stat_enabled *enabled = data;
+	bool get_filters = false;
+	int i;
+
+	for (i = 0; i < enabled->nenabled; i++)
+		enabled->enabled[i].desc->pack(&dump_filters,
+					       enabled->enabled[i].desc);
+
+	for (i = 1; i < ARRAY_SIZE(dump_filters.mask); i++) {
+		if (ipstats_req_should_filter_at(&dump_filters, i)) {
+			get_filters = true;
+			break;
+		}
+	}
+
+	req->ifsm.filter_mask = dump_filters.mask[0];
+	if (get_filters) {
+		struct rtattr *nest;
+
+		nest = addattr_nest(&req->nlh, sizeof(*req),
+				    IFLA_STATS_GET_FILTERS | NLA_F_NESTED);
+
+		for (i = 1; i < ARRAY_SIZE(dump_filters.mask); i++) {
+			if (ipstats_req_should_filter_at(&dump_filters, i))
+				addattr32(&req->nlh, sizeof(*req), i,
+					  dump_filters.mask[i]);
+		}
+
+		addattr_nest_end(&req->nlh, nest);
+	}
+
+	return 0;
+}
+
+static int
+ipstats_show_one(int ifindex, struct ipstats_stat_enabled *enabled)
+{
+	struct ipstats_req req = {
+		.nlh.nlmsg_flags = NLM_F_REQUEST,
+		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct if_stats_msg)),
+		.nlh.nlmsg_type = RTM_GETSTATS,
+		.ifsm.family = PF_UNSPEC,
+		.ifsm.ifindex = ifindex,
+	};
+	struct nlmsghdr *answer;
+	int err = 0;
+
+	ipstats_req_add_filters(&req, enabled);
+	if (rtnl_talk(&rth, &req.nlh, &answer) < 0)
+		return -2;
+	err = ipstats_process_ifsm(answer, enabled);
+	free(answer);
+
+	return err;
+}
+
+static int ipstats_dump_one(struct nlmsghdr *n, void *arg)
+{
+	struct ipstats_stat_enabled *enabled = arg;
+	int rc;
+
+	rc = ipstats_process_ifsm(n, enabled);
+	if (rc)
+		return rc;
+
+	print_nl();
+	return 0;
+}
+
+static int ipstats_dump(struct ipstats_stat_enabled *enabled)
+{
+	int rc = 0;
+
+	if (rtnl_statsdump_req_filter(&rth, PF_UNSPEC, 0,
+				      ipstats_req_add_filters,
+				      enabled) < 0) {
+		perror("Cannot send dump request");
+		return -2;
+	}
+
+	if (rtnl_dump_filter(&rth, ipstats_dump_one, enabled) < 0) {
+		fprintf(stderr, "Dump terminated\n");
+		rc = -2;
+	}
+
+	fflush(stdout);
+	return rc;
+}
+
+static int
+ipstats_show_do(int ifindex, struct ipstats_stat_enabled *enabled)
+{
+	int rc;
+
+	new_json_obj(json);
+	if (ifindex)
+		rc = ipstats_show_one(ifindex, enabled);
+	else
+		rc = ipstats_dump(enabled);
+	delete_json_obj();
+
+	return rc;
+}
+
+static int ipstats_add_enabled(struct ipstats_stat_enabled_one ens[],
+			       size_t nens,
+			       struct ipstats_stat_enabled *enabled)
+{
+	struct ipstats_stat_enabled_one *new_en;
+
+	new_en = realloc(enabled->enabled,
+			 sizeof(*new_en) * (enabled->nenabled + nens));
+	if (new_en == NULL)
+		return -ENOMEM;
+
+	enabled->enabled = new_en;
+	while (nens-- > 0)
+		enabled->enabled[enabled->nenabled++] = *ens++;
+	return 0;
+}
+
+static void ipstats_select_push(struct ipstats_sel *sel, const char *name)
+{
+	int i;
+
+	for (i = 0; i < IPSTATS_LEVELS_COUNT; i++)
+		if (sel->sel[i] == NULL) {
+			sel->sel[i] = name;
+			return;
+		}
+
+	assert(false);
+}
+
+static int
+ipstats_enable_recursively(const struct ipstats_stat_desc *desc,
+			   struct ipstats_stat_enabled *enabled,
+			   const struct ipstats_sel *sel)
+{
+	bool found = false;
+	size_t i;
+	int err;
+
+	if (desc->kind == IPSTATS_STAT_DESC_KIND_LEAF) {
+		struct ipstats_stat_enabled_one en[] = {{
+			.desc = desc,
+			.sel = *sel,
+		}};
+
+		return ipstats_add_enabled(en, ARRAY_SIZE(en), enabled);
+	}
+
+	for (i = 0; i < desc->nsubs; i++) {
+		struct ipstats_sel subsel = *sel;
+
+		ipstats_select_push(&subsel, desc->subs[i]->name);
+		err = ipstats_enable_recursively(desc->subs[i], enabled,
+						 &subsel);
+		if (err == -ENOENT)
+			continue;
+		if (err != 0)
+			return err;
+		found = true;
+	}
+
+	return found ? 0 : -ENOENT;
+}
+
+static int ipstats_comp_enabled(const void *a, const void *b)
+{
+	const struct ipstats_stat_enabled_one *en_a = a;
+	const struct ipstats_stat_enabled_one *en_b = b;
+
+	if (en_a->desc < en_b->desc)
+		return -1;
+	if (en_a->desc > en_b->desc)
+		return 1;
+
+	return 0;
+}
+
+static void ipstats_enabled_free(struct ipstats_stat_enabled *enabled)
+{
+	free(enabled->enabled);
+}
+
+static const struct ipstats_stat_desc *
+ipstats_stat_desc_find(const struct ipstats_stat_desc *desc,
+		       const char *name)
+{
+	size_t i;
+
+	assert(desc->kind == IPSTATS_STAT_DESC_KIND_GROUP);
+	for (i = 0; i < desc->nsubs; i++) {
+		const struct ipstats_stat_desc *sub = desc->subs[i];
+
+		if (strcmp(sub->name, name) == 0)
+			return sub;
+	}
+
+	return NULL;
+}
+
+static const struct ipstats_stat_desc *
+ipstats_enable_find_stat_desc(struct ipstats_sel *sel)
+{
+	const struct ipstats_stat_desc *toplev = &ipstats_stat_desc_toplev_group;
+	const struct ipstats_stat_desc *desc = toplev;
+	int i;
+
+	for (i = 0; i < IPSTATS_LEVELS_COUNT; i++) {
+		const struct ipstats_stat_desc *next_desc;
+
+		if (sel->sel[i] == NULL)
+			break;
+		if (desc->kind == IPSTATS_STAT_DESC_KIND_LEAF) {
+			fprintf(stderr, "Error: %s %s requested inside leaf %s %s\n",
+				ipstats_levels[i], sel->sel[i],
+				ipstats_levels[i - 1], desc->name);
+			return NULL;
+		}
+
+		next_desc = ipstats_stat_desc_find(desc, sel->sel[i]);
+		if (next_desc == NULL) {
+			fprintf(stderr, "Error: no %s named %s found inside %s\n",
+				ipstats_levels[i], sel->sel[i], desc->name);
+			return NULL;
+		}
+
+		desc = next_desc;
+	}
+
+	return desc;
+}
+
+static int ipstats_enable(struct ipstats_sel *sel,
+			  struct ipstats_stat_enabled *enabled)
+{
+	struct ipstats_stat_enabled new_enabled = {};
+	const struct ipstats_stat_desc *desc;
+	size_t i, j;
+	int err = 0;
+
+	desc = ipstats_enable_find_stat_desc(sel);
+	if (desc == NULL)
+		return -EINVAL;
+
+	err = ipstats_enable_recursively(desc, &new_enabled, sel);
+	if (err != 0)
+		return err;
+
+	err = ipstats_add_enabled(new_enabled.enabled, new_enabled.nenabled,
+				  enabled);
+	if (err != 0)
+		goto out;
+
+	qsort(enabled->enabled, enabled->nenabled, sizeof(*enabled->enabled),
+	      ipstats_comp_enabled);
+
+	for (i = 1, j = 1; i < enabled->nenabled; i++) {
+		if (enabled->enabled[i].desc != enabled->enabled[j - 1].desc)
+			enabled->enabled[j++] = enabled->enabled[i];
+	}
+	enabled->nenabled = j;
+
+out:
+	ipstats_enabled_free(&new_enabled);
+	return err;
+}
+
+static int ipstats_enable_check(struct ipstats_sel *sel,
+				struct ipstats_stat_enabled *enabled)
+{
+	int err;
+	int i;
+
+	err = ipstats_enable(sel, enabled);
+	if (err == -ENOENT) {
+		fprintf(stderr, "The request for");
+		for (i = 0; i < IPSTATS_LEVELS_COUNT; i++)
+			if (sel->sel[i] != NULL)
+				fprintf(stderr, " %s %s",
+					ipstats_levels[i], sel->sel[i]);
+			else
+				break;
+		fprintf(stderr, " did not match any known stats.\n");
+	}
+
+	return err;
+}
+
 static int do_help(void)
 {
+	const struct ipstats_stat_desc *toplev = &ipstats_stat_desc_toplev_group;
+	int i;
+
 	fprintf(stderr,
 		"Usage: ip stats help\n"
+		"       ip stats show [ dev DEV ] [ group GROUP [ subgroup SUBGROUP ] ... ] ...\n"
 		"       ip stats set dev DEV l3_stats { on | off }\n"
 		);
 
+	for (i = 0; i < toplev->nsubs; i++) {
+		const struct ipstats_stat_desc *desc = toplev->subs[i];
+
+		if (i == 0)
+			fprintf(stderr, "GROUP := { %s", desc->name);
+		else
+			fprintf(stderr, " | %s", desc->name);
+	}
+	if (i > 0)
+		fprintf(stderr, " }\n");
+
+	for (i = 0; i < toplev->nsubs; i++) {
+		const struct ipstats_stat_desc *desc = toplev->subs[i];
+		bool opened = false;
+		size_t j;
+
+		if (desc->kind != IPSTATS_STAT_DESC_KIND_GROUP)
+			continue;
+
+		for (j = 0; j < desc->nsubs; j++) {
+			if (j == 0)
+				fprintf(stderr, "%s SUBGROUP := {", desc->name);
+			else
+				fprintf(stderr, " |");
+			fprintf(stderr, " %s", desc->subs[j]->name);
+			opened = true;
+
+			if (desc->subs[j]->kind != IPSTATS_STAT_DESC_KIND_GROUP)
+				continue;
+		}
+		if (opened)
+			fprintf(stderr, " }\n");
+	}
+
 	return 0;
 }
 
+static int ipstats_select(struct ipstats_sel *old_sel,
+			  const char *new_sel, int level,
+			  struct ipstats_stat_enabled *enabled)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < level; i++) {
+		if (old_sel->sel[i] == NULL) {
+			fprintf(stderr, "Error: %s %s requested without selecting a %s first\n",
+				ipstats_levels[level], new_sel,
+				ipstats_levels[i]);
+			return -EINVAL;
+		}
+	}
+
+	for (i = level; i < IPSTATS_LEVELS_COUNT; i++) {
+		if (old_sel->sel[i] != NULL) {
+			err = ipstats_enable_check(old_sel, enabled);
+			if (err)
+				return err;
+			break;
+		}
+	}
+
+	old_sel->sel[level] = new_sel;
+	for (i = level + 1; i < IPSTATS_LEVELS_COUNT; i++)
+		old_sel->sel[i] = NULL;
+
+	return 0;
+}
+
+static int ipstats_show(int argc, char **argv)
+{
+	struct ipstats_stat_enabled enabled = {};
+	struct ipstats_sel sel = {};
+	const char *dev = NULL;
+	int ifindex;
+	int err;
+	int i;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "dev") == 0) {
+			NEXT_ARG();
+			if (dev != NULL)
+				duparg2("dev", *argv);
+			if (check_ifname(*argv))
+				invarg("\"dev\" not a valid ifname", *argv);
+			dev = *argv;
+		} else if (strcmp(*argv, "help") == 0) {
+			do_help();
+			return 0;
+		} else {
+			bool found_level = false;
+
+			for (i = 0; i < ARRAY_SIZE(ipstats_levels); i++) {
+				if (strcmp(*argv, ipstats_levels[i]) == 0) {
+					NEXT_ARG();
+					err = ipstats_select(&sel, *argv, i,
+							     &enabled);
+					if (err)
+						goto err;
+
+					found_level = true;
+				}
+			}
+
+			if (!found_level) {
+				fprintf(stderr, "What is \"%s\"?\n", *argv);
+				do_help();
+				err = -EINVAL;
+				goto err;
+			}
+		}
+
+		NEXT_ARG_FWD();
+	}
+
+	/* Push whatever was given. */
+	err = ipstats_enable_check(&sel, &enabled);
+	if (err)
+		goto err;
+
+	if (dev) {
+		ifindex = ll_name_to_index(dev);
+		if (!ifindex) {
+			err = nodev(dev);
+			goto err;
+		}
+	} else {
+		ifindex = 0;
+	}
+
+
+	err = ipstats_show_do(ifindex, &enabled);
+
+err:
+	ipstats_enabled_free(&enabled);
+	return err;
+}
+
 static int ipstats_set_do(int ifindex, int at, bool enable)
 {
 	struct ipstats_req req = {
@@ -92,11 +697,16 @@ int do_ipstats(int argc, char **argv)
 	int rc;
 
 	if (argc == 0) {
-		do_help();
-		rc = -1;
+		rc = ipstats_show(0, NULL);
 	} else if (strcmp(*argv, "help") == 0) {
 		do_help();
 		rc = 0;
+	} else if (strcmp(*argv, "show") == 0) {
+		/* Invoking "stats show" implies one -s. Passing -d adds one
+		 * more -s.
+		 */
+		show_stats += show_details + 1;
+		rc = ipstats_show(argc-1, argv+1);
 	} else if (strcmp(*argv, "set") == 0) {
 		rc = ipstats_set(argc-1, argv+1);
 	} else {
-- 
2.31.1

