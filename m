Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A376C50B2F4
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445523AbiDVIeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445525AbiDVIee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:34:34 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD4752E61
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 01:31:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZldIJTUFlRTw47yYNy2RFOwIsQvDDTZIxP0CjQn4jEipmbDcGwEX4A9d3cVNfHC6R8N/qCP4pWxpXnJ5jINx7aiTCGSiRDAlnIG/PoaNU2xcrWVgoxfaNbrWbinsvAglBTzQmYCGJsc9++lQjzaCTN+BwDnb+QxWM4g3Rfk31mBSELJw7oTTvDmBn6b1p1hEFURGaT8FF7hJBa2sjLm4x7aFGQjP1weIFOmiXpvwpZV+C7zZDMhqU+oARA4T1RFwFaLa+IkUPCBpljTXU42jPanATMCZZYc8irE91Kfqp23AalVto5orJjzAL/sNwg7ZbwoVMhE2+vg4OIB4MOnSeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hG/iXGJPwzzHjv31xsOV4/MlTwtccaeBl4hnu+by9a8=;
 b=RDDFbNUhCVShT/hgz77DEvIBIiWXt1XDc4HaAVlr3SRsXFZcEREaSMt+uaTTBOdc2wTndmrq1r2uTzj2FsP77A15i1aFquCrchEP3Jj2XmfT72Y4vzC34CZwe7AThPMamVP9JgelgJN7+EG0Fsix+qCJGLKvvokgxqQLbQSi1vFakDOnASJU6Hafx+1PBE9WVIU7t+OjSW0GjjtHV+L+CUV+ibUReJDirsPbzk9OQv2aUtthok040iWdKy3dk3Edo411IQrjDYNvCJVjn4VYAVzxRaZa/9Aa6ck8IQBofkxc6aIpgy1/Rb44W5etZArD37hklcTwPTcliWy944VmXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hG/iXGJPwzzHjv31xsOV4/MlTwtccaeBl4hnu+by9a8=;
 b=JK/h//s6wiaUQc1H45c6X+yLCHfJdjp2hlc9ZQv/qeGuq+oUq9t8yPhVm14c+KJRvewJOw4kpok82KBFh9FTk0kW+Tzk/ujA4en/BsVZxrVNHzyYuB5yVpp7eJ7RpAlnbtZdEXtDzU0NKc1w9JOAcFTHJ3Uw9DZ8cKC4SdnnxO/tv0XrqrVVV3mJOIj8U5ciS+pTJ5T+mphwxodduMHStHHzAFWZta0i2js/UC+H06UMSu1Jn3LIye/dqnzH3SoxKM1Qvg81IZyxubbhu8Pm/6vDZCujyuRuhfXrmcJKzf2Zih3q39vuVz4X6jCr3uyTSOtGsTSVFzvk8uIKCck+mw==
Received: from BN9PR03CA0698.namprd03.prod.outlook.com (2603:10b6:408:ef::13)
 by BN8PR12MB3073.namprd12.prod.outlook.com (2603:10b6:408:66::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 22 Apr
 2022 08:31:39 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::a8) by BN9PR03CA0698.outlook.office365.com
 (2603:10b6:408:ef::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Fri, 22 Apr 2022 08:31:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 08:31:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 08:31:39 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 01:31:37 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 06/11] ipstats: Add a group "link"
Date:   Fri, 22 Apr 2022 10:30:55 +0200
Message-ID: <c361fce0960093e31aabbc0b45bb0c870896339e.1650615982.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: d9f50801-4886-417c-dbf8-08da243a85c5
X-MS-TrafficTypeDiagnostic: BN8PR12MB3073:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3073A167C633A63EA1573BACD6F79@BN8PR12MB3073.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dncu4OFil33DDjzpvQBFNSL7hrQBvTCscQXlMXlqFwLsLY1+WEdq5L8tE7lqIDfGo4MTZRxwQuDNZoVtk0yEyPYe+DKKJ23SSRNSYVrgI+cgCENoOPMCOmhs4kMmDM3m9iiDWM9kZZAMj6gp0pvyY/963jC+WCCoUgfOKgycePTF4qrlM+DepHZdJMjDjf9G1qRlDj84zrDgSL5Dz0fjElyRpAMPeBWlC2k24gL5TmweQWeWqdcNlBdMxaOtYX3Dps0mo55+N4KMcZ96CM6q9I4QtpOt5IOs0U5ApV7Tdh79euS1KmkjCHYJbQSNS5U66cSjnngieuMpkzRK8wA+6KTjk+s6HQzC4cxCisKQhekq18i9yH6a3Gg8jzMqoMtOdFRJ+F8YDMUWrd2XwDkszTfEe2HX+6h4bw31igH7qT0hcUEkNDwGaC7busqKQFPAORaP3KKU6Mj5pbAtXSkq4QJHTCc4YEl+2erArRIsV5GaUarEDYIcDRJX8dsEKaAxtopUi1jFXKNLax+pf4x5Ma7zI2YVlk3Ms1rUOxYctvsa/45keXZUx/gmCZhhuRruN14Q6e6H+6F+alnCqvMSfMmpwXKgx0f879695x3rf/v3nPdFaVao64GaFvcMgShSf+xjAFeVWeBpSIwplhBxDVDSyT86l6Wr7eKrKEDF5DOY4Wwl5Tfxt5LJeiObp3a7CowB3nKt4zY3sxaY5PYJ6A==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(82310400005)(36756003)(5660300002)(81166007)(40460700003)(36860700001)(2906002)(107886003)(426003)(6916009)(316002)(47076005)(356005)(16526019)(86362001)(54906003)(26005)(336012)(70586007)(8676002)(4326008)(83380400001)(186003)(2616005)(70206006)(6666004)(508600001)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 08:31:39.5511
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9f50801-4886-417c-dbf8-08da243a85c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3073
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the "link" top-level group for showing IFLA_STATS_LINK_64 statistics.
For example:

 # ip stats show dev swp1 group link
 4178: swp1: group link
     RX:  bytes packets errors dropped  missed   mcast
          47048     354      0       0       0      64
     TX:  bytes packets errors dropped carrier collsns
          47474     355      0       0       0       0

 # ip -j stats show dev swp1 group link | jq
 [
   {
     "ifindex": 4178,
     "ifname": "swp1",
     "group": "link",
     "stats64": {
       "rx": {
         "bytes": 47048,
         "packets": 354,
         "errors": 0,
         "dropped": 0,
         "over_errors": 0,
         "multicast": 64
       },
       "tx": {
         "bytes": 47474,
         "packets": 355,
         "errors": 0,
         "dropped": 0,
         "carrier_errors": 0,
         "collisions": 0
       }
     }
   }
 ]

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ipstats.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/ip/ipstats.c b/ip/ipstats.c
index 79f7b1ff..e4f97ddd 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -12,6 +12,15 @@ struct ipstats_stat_dump_filters {
 	__u32 mask[IFLA_STATS_MAX + 1];
 };
 
+static void
+ipstats_stat_desc_enable_bit(struct ipstats_stat_dump_filters *filters,
+			     unsigned int group, unsigned int subgroup)
+{
+	filters->mask[0] |= IFLA_STATS_FILTER_BIT(group);
+	if (subgroup)
+		filters->mask[group] |= IFLA_STATS_FILTER_BIT(subgroup);
+}
+
 struct ipstats_stat_show_attrs {
 	struct if_stats_msg *ifsm;
 	int len;
@@ -89,6 +98,29 @@ ipstats_stat_show_attrs_alloc_tb(struct ipstats_stat_show_attrs *attrs,
 	return err;
 }
 
+static const struct rtattr *
+ipstats_stat_show_get_attr(struct ipstats_stat_show_attrs *attrs,
+			   int group, int subgroup, int *err)
+{
+	int tmp_err;
+
+	if (err == NULL)
+		err = &tmp_err;
+
+	*err = 0;
+	if (subgroup == 0)
+		return attrs->tbs[0][group];
+
+	if (attrs->tbs[0][group] == NULL)
+		return NULL;
+
+	*err = ipstats_stat_show_attrs_alloc_tb(attrs, group);
+	if (*err != 0)
+		return NULL;
+
+	return attrs->tbs[group][subgroup];
+}
+
 static void
 ipstats_stat_show_attrs_free(struct ipstats_stat_show_attrs *attrs)
 {
@@ -98,7 +130,65 @@ ipstats_stat_show_attrs_free(struct ipstats_stat_show_attrs *attrs)
 		free(attrs->tbs[i]);
 }
 
+#define IPSTATS_RTA_PAYLOAD(TYPE, AT)					\
+	({								\
+		const struct rtattr *__at = (AT);			\
+		TYPE *__ret = NULL;					\
+									\
+		if (__at != NULL &&					\
+		    __at->rta_len - RTA_LENGTH(0) >= sizeof(TYPE))	\
+			__ret = RTA_DATA(__at);				\
+		__ret;							\
+	})
+
+static int ipstats_show_64(struct ipstats_stat_show_attrs *attrs,
+			   unsigned int group, unsigned int subgroup)
+{
+	struct rtnl_link_stats64 *stats;
+	const struct rtattr *at;
+	int err;
+
+	at = ipstats_stat_show_get_attr(attrs, group, subgroup, &err);
+	if (at == NULL)
+		return err;
+
+	stats = IPSTATS_RTA_PAYLOAD(struct rtnl_link_stats64, at);
+	if (stats == NULL) {
+		fprintf(stderr, "Error: attribute payload too short");
+		return -EINVAL;
+	}
+
+	open_json_object("stats64");
+	print_stats64(stdout, stats, NULL, NULL);
+	close_json_object();
+	return 0;
+}
+
+static void
+ipstats_stat_desc_pack_link(struct ipstats_stat_dump_filters *filters,
+			    const struct ipstats_stat_desc *desc)
+{
+	ipstats_stat_desc_enable_bit(filters,
+				     IFLA_STATS_LINK_64, 0);
+}
+
+static int
+ipstats_stat_desc_show_link(struct ipstats_stat_show_attrs *attrs,
+			    const struct ipstats_stat_desc *desc)
+{
+	print_nl();
+	return ipstats_show_64(attrs, IFLA_STATS_LINK_64, 0);
+}
+
+static const struct ipstats_stat_desc ipstats_stat_desc_toplev_link = {
+	.name = "link",
+	.kind = IPSTATS_STAT_DESC_KIND_LEAF,
+	.pack = &ipstats_stat_desc_pack_link,
+	.show = &ipstats_stat_desc_show_link,
+};
+
 static const struct ipstats_stat_desc *ipstats_stat_desc_toplev_subs[] = {
+	&ipstats_stat_desc_toplev_link,
 };
 
 static const struct ipstats_stat_desc ipstats_stat_desc_toplev_group = {
-- 
2.31.1

