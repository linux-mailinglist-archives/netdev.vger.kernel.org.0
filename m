Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF8F51FF26
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236846AbiEIOFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236824AbiEIOFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:05:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84766F68A2
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:01:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efRfBxJItIaMS6xjZuwPpd1adksgLcAhVsuug84/34j9WmtSsp2hxLQw5pFpRLMgA1eNlHxNvolxuwbOs8oJt8wc1encyPFfDIfvIAuec13S3EOCtSS5Qiv+P60BPh+VXWV4460DK3WB2HHN5ssNhL5CbCHCS48tAxBWVyhmxz8FfN2KNUjqm1+GhnLU/l+V5LY3C2dpRfbUzrxMFprmWZAGUHYSwndf/QeS5W6lQGUhnce7x9ligFZPSPLaC0pcL3PrQKMmQviCtVQnJYYfpp6WRQhSw0JEy3rWn3pFx7O6goWk3S9D4RAIkC2iAm7/U38JsyNHxZ9DlCHHGkZpHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PexPSRjSIn6wPPlriQ+Kf46mjdzWglUeVcCh6j04L5Q=;
 b=Nm0l5T7cSLn84Hy+xsTP+DNLTy0tFFuvug3i2SAOvanw11mcCo046CFn3x3v13rlv8kQDdvKBUdGTkrHOHfagrw/nrIPkdHyJimFZFLRubIkUeGSB1u5VKA0URpc3jN/7SVVAv2Z1jyHhTjE8Tk4e7+5Qwyj9/j3jGq/Q95L7pnhS1DYTOQMZb1BtMlmpla1QvRae0P6aeggE9MvaDRN2qcLB1OR5W7KiUrojx2yZNpc0Ehl3vRwBMdCoS4PBIyjsiVlX/gkJjz5/U1Gs6Od/No+3MjKhYFzcy5DEtGJZYO07JnaZ078hj1BI6ZVL1TVCI3tfFIM5aRU1g3Xu6wwTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PexPSRjSIn6wPPlriQ+Kf46mjdzWglUeVcCh6j04L5Q=;
 b=PDigMFBk2GmRWovuQJXR1bAffH1T4G24J5eja5mpGwgMiGVpzdGczON1MuS62sRcIQnjjkBi89ZbqfGGjPQX2yf+P2JoDteRygpzNqWq5qxSCWldDeC8q4omWoBGMN1UD8MvDfpP6VU81mxzg7jHHzc7mPPZ+05A+dLEL5VhUxD9C/RlZjSnwaCnGuXFcnBtyEssmBWbPmMPNsREmzZ2+g2Yb2Q0W3955jrbB+YomzTnjR/spkzLvW8H1b6r/l7lnqn7n4AxpRd+1H5F1hR43NalpqLeGyETZLTwx1QuTlbp421RryMOgSi4lH4KNlqXosGAf9xnVEcU/cSZC61nsw==
Received: from DS7PR05CA0063.namprd05.prod.outlook.com (2603:10b6:8:57::19) by
 SA1PR12MB5615.namprd12.prod.outlook.com (2603:10b6:806:229::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Mon, 9 May
 2022 14:01:35 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::45) by DS7PR05CA0063.outlook.office365.com
 (2603:10b6:8:57::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13 via Frontend
 Transport; Mon, 9 May 2022 14:01:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 14:01:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 9 May
 2022 14:01:17 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 07:01:15 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 06/10] ipstats: Add groups "xstats", "xstats_slave"
Date:   Mon, 9 May 2022 15:59:59 +0200
Message-ID: <f62a819164e55021afa293b3c4a457ff7ed57df1.1652104101.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1652104101.git.petrm@nvidia.com>
References: <cover.1652104101.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5cb4da1-da26-4485-f949-08da31c46db5
X-MS-TrafficTypeDiagnostic: SA1PR12MB5615:EE_
X-Microsoft-Antispam-PRVS: <SA1PR12MB56152991886EE7FF0C73E1F2D6C69@SA1PR12MB5615.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FVqxZpIauOsG8rvuDcl2yMkWe3QvOtLtSg/9S53sAJSNpDXpTCY/PSpMKTK3pW0KnrRx6IJ6EjkmxEJGsI+IsxQ4KGeGFAAvnZoMXK6F+6D4d799+fxff0OaPEQJBE2h3LmIh92NYNfx0QPX52/Qvv7XIB9FAP51aFdp1wWeeBYJWe76X6LCPRHTwMvagSG1okRoSp87xA7CRtTmj334cZ82AQeS5TNW0vyP14zQ1jTnyhfX6Objwb42wgYcJdftiuDVyGZtvo3Sqe7MhnAnzk18q6L3Y1YegqDo22TeP6YmKJGAKbOSvVFuDkuMs6U6kYEVPcb4+dfiyZQvirTVRjP7WDmKMooNxg6zow1TmDZdxisUB5vkViXL1+PNKM1takCSCz6wrPTyNA14/5UWIORbbRqKj+44tJRpIlSdLvVM82AEAnHPmDgvoojYI0hsjBZJU8C0Sn+WPUEn36udgYhjzeA1YjHyG1PHZ9i2QsskFDLPU32LDLhmtEFQ25aiWk6M33G7dWps8jID9hSSvCUAr50tGFZFG/LkQ7ZTLBz/sOmdmF8rcP3/4hlC5eYCm5MYlq8JXeX36bNe4u3ssDDWX2orMszU1oxpy+HHXgW6eUlFOZ8Y/BwcVp9Z/CIJmvqGYIIXfJIKB57ELOjBF6oSk0vSU315OwpFZ3mCCgML9UhpNrsMet5pyLlrGEMLXO1fguns8HcVRrNX6SMHiA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(6666004)(356005)(2616005)(47076005)(426003)(336012)(16526019)(107886003)(186003)(36756003)(70206006)(81166007)(8676002)(4326008)(70586007)(36860700001)(5660300002)(40460700003)(82310400005)(26005)(86362001)(316002)(54906003)(2906002)(8936002)(508600001)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:01:34.9090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5cb4da1-da26-4485-f949-08da31c46db5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5615
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTM_GETSTATS response attributes IFLA_STATS_LINK_XSTATS and
IFLA_STATS_LINK_XSTATS_SLAVE are used to carry statistics related to,
respectively, netdevices of a certain type, and netdevices enslaved to
netdevices of a certain type. Inside the nest is then link-type specific
attribute (e.g. LINK_XSTATS_TYPE_BRIDGE), and inside that nest further
attributes for individual type-specific statistical suites.

Under the "ip stats" model, that corresponds to groups "xstats" and
"xstats_slave", link-type specific subgroup, e.g. "bridge", and one or more
link-type specific suites, such as "stp".

Link-type specific stats are currently supported through struct link_util
and in particular the callbacks parse_ifla_xstats and print_ifla_xstats.

The role of parse_ifla_xstats is to establish which statistical suite to
display, and on which device. "ip stats" has framework for both of these
tasks, which obviates the need for custom parsing. Therefore the module
should instead provide a subgroup descriptor, which "ip stats" will then
use as any other.

The second link_util callback, print_ifla_xstats, is for response
dissection. In "ip stats" model, this belongs to leaf descriptors.

Eventually, the link-specific leaf descriptors will be similar to each
other: either master or slave top-level nest needs to be parsed, and
link-type attribute underneath that, and suite attribute underneath that.

To support this commonality, add struct ipstats_stat_desc_xstats to
describe the xstats suites. Further, expose ipstats_stat_desc_pack_xstats()
and ipstats_stat_desc_show_xstats(), which can be used at leaf descriptors
and do the appropriate thing according to the configuration in
ipstats_stat_desc_xstats.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ip_common.h | 14 ++++++++++++
 ip/ipstats.c   | 59 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index 63618f0f..8b7ec645 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -186,6 +186,20 @@ struct ipstats_stat_desc {
 	};
 };
 
+struct ipstats_stat_desc_xstats {
+	const struct ipstats_stat_desc desc;
+	int xstats_at;
+	int link_type_at;
+	int inner_max;
+	int inner_at;
+	void (*show_cb)(const struct rtattr *at);
+};
+
+void ipstats_stat_desc_pack_xstats(struct ipstats_stat_dump_filters *filters,
+				   const struct ipstats_stat_desc *desc);
+int ipstats_stat_desc_show_xstats(struct ipstats_stat_show_attrs *attrs,
+				  const struct ipstats_stat_desc *desc);
+
 #ifndef	INFINITY_LIFE_TIME
 #define     INFINITY_LIFE_TIME      0xFFFFFFFFU
 #endif
diff --git a/ip/ipstats.c b/ip/ipstats.c
index 0e7f2b3c..0691a3f0 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -2,6 +2,7 @@
 #include <assert.h>
 #include <errno.h>
 
+#include "list.h"
 #include "utils.h"
 #include "ip_common.h"
 
@@ -567,6 +568,62 @@ static const struct ipstats_stat_desc ipstats_stat_desc_offload_group = {
 	.nsubs = ARRAY_SIZE(ipstats_stat_desc_offload_subs),
 };
 
+void ipstats_stat_desc_pack_xstats(struct ipstats_stat_dump_filters *filters,
+				   const struct ipstats_stat_desc *desc)
+{
+	struct ipstats_stat_desc_xstats *xdesc;
+
+	xdesc = container_of(desc, struct ipstats_stat_desc_xstats, desc);
+	ipstats_stat_desc_enable_bit(filters, xdesc->xstats_at, 0);
+}
+
+int ipstats_stat_desc_show_xstats(struct ipstats_stat_show_attrs *attrs,
+				  const struct ipstats_stat_desc *desc)
+{
+	struct ipstats_stat_desc_xstats *xdesc;
+	const struct rtattr *at;
+	struct rtattr **tb;
+	int err;
+
+	xdesc = container_of(desc, struct ipstats_stat_desc_xstats, desc);
+	at = ipstats_stat_show_get_attr(attrs,
+					xdesc->xstats_at,
+					xdesc->link_type_at, &err);
+	if (at == NULL)
+		return err;
+
+	tb = alloca(sizeof(*tb) * (xdesc->inner_max + 1));
+	err = parse_rtattr_nested(tb, xdesc->inner_max, at);
+	if (err != 0)
+		return err;
+
+	if (tb[xdesc->inner_at] != NULL) {
+		print_nl();
+		xdesc->show_cb(tb[xdesc->inner_at]);
+	}
+	return 0;
+}
+
+static const struct ipstats_stat_desc *ipstats_stat_desc_xstats_subs[] = {
+};
+
+static const struct ipstats_stat_desc ipstats_stat_desc_xstats_group = {
+	.name = "xstats",
+	.kind = IPSTATS_STAT_DESC_KIND_GROUP,
+	.subs = ipstats_stat_desc_xstats_subs,
+	.nsubs = ARRAY_SIZE(ipstats_stat_desc_xstats_subs),
+};
+
+static const struct ipstats_stat_desc *ipstats_stat_desc_xstats_slave_subs[] = {
+};
+
+static const struct ipstats_stat_desc ipstats_stat_desc_xstats_slave_group = {
+	.name = "xstats_slave",
+	.kind = IPSTATS_STAT_DESC_KIND_GROUP,
+	.subs = ipstats_stat_desc_xstats_slave_subs,
+	.nsubs = ARRAY_SIZE(ipstats_stat_desc_xstats_slave_subs),
+};
+
 static void
 ipstats_stat_desc_pack_link(struct ipstats_stat_dump_filters *filters,
 			    const struct ipstats_stat_desc *desc)
@@ -645,6 +702,8 @@ static const struct ipstats_stat_desc ipstats_stat_desc_afstats_group = {
 };
 static const struct ipstats_stat_desc *ipstats_stat_desc_toplev_subs[] = {
 	&ipstats_stat_desc_toplev_link,
+	&ipstats_stat_desc_xstats_group,
+	&ipstats_stat_desc_xstats_slave_group,
 	&ipstats_stat_desc_offload_group,
 	&ipstats_stat_desc_afstats_group,
 };
-- 
2.31.1

