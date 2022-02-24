Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F494C2D2D
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbiBXNfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbiBXNfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:35:14 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFB4178688
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:34:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eg8lf2qG0x2+j7kGa2Ooy6aBC4BouKze3+gjp+SObOeeZUAvJuovlA+S1Hb2H8M9sfnDql1BhsuPM9JlvEQFTHWH3CYZVcgAAPo2Up5A++ICMwuoIeASq1MKnZmdBtjoJNVHNtBcFQZFoV9HfyDefVVZ0Ck/FoJ8oIZkTVaNU9DBWu0+w6ZLNuXQZaMjC6i9+PMFetid4PEGnSiKPI5ALfiFCybhQtR/wLujFSdq86Of1hpRM2GC+awpp9iDMXwirZxGl1/dW162IhaQ49OUGqAShM8eoiA2rXJBkji/oax1A0qMH/6E4bmgkpi6iezGflEanzFGMI3W565KJ8+d+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HAV0Sjmcd4zbz7mcI2rRw5Za0gX9CO9tI58mKhmdKfk=;
 b=WrfSy2t2kZIxi1oI89fO2vncqtaGsUtLmeIr3h8wSxW2cOIK/4q/MtRhGpeZKikHIhPvLc+5razQ6xTS0iD8yhk9G/wJgdobpfJKB6vb8al+J+RSEvL8ARnguYfLDjOcKJMrEB0CVqvU05KfRaVN1F9IjHCBV/Ti7gi3/OG4/hWcGPC3KoZs36rEHTJ13vDpGcPOULVyPpHNiRgS0a0Sav/EpcluepCsGXfdDytiTZAxrpsVmEaqmrhQHKOChGhciOEDHOuufON4YD55rCx3H+arY13Aq45l6v2+fOch13WnFgXohTVL4DBYcIu3oqsz7R6zWxzXz0GLII/E1ZDxXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAV0Sjmcd4zbz7mcI2rRw5Za0gX9CO9tI58mKhmdKfk=;
 b=MY9KsxLHYL752CDDBjvuqACq7JXiX+wEjK7ylUiW7NrhagXmdiFqO4PHSbQuV8SR1uVTVsEK6qMAvJuYK54hxB4gTdxeD4V9xqYQj2D+Ir9PjiikvFVXacikqAqxGjoWKNHjCx50Pn6dam6Qf2Mvtzd6WL1rx8i93pxf0otFY2m72zLMo3MwAfQbpL61NXJBNPp1lkkIQFS/GMUjgZIFamX7hvFYswooZROqy0MgLqZDYrHO2C76MmZ/X/IlzAg8+f2/63+zsCkqSu4LGnA/38HavugCmz+371UFy6nAP1114CkiLNwUrwx8xa/zf1HZGI75wZ7kthr4A6FvzrLX2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:34:43 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:34:43 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/14] net: rtnetlink: Add UAPI for obtaining L3 offload xstats
Date:   Thu, 24 Feb 2022 15:33:28 +0200
Message-Id: <20220224133335.599529-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0142.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::35) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9df8241-f45b-404d-449a-08d9f79a6a33
X-MS-TrafficTypeDiagnostic: DS7PR12MB6008:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB600811CC8C6405B66641B4BFB23D9@DS7PR12MB6008.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pnDHoQngcswOmUNjo1KETMBAltbk3bjdR7fRG1UnX/uuEoVI8s64N+ZF8uE0WcHamU8ZNYBJalYw0nz7y1o9ud/zBDwFgjHa2dTTVC/wPmiK/EqWFZl6wHZoVEKA4x0OI2253YvqkUKi0KYNUaaR4glbJH/hhPzkz5wh6HtVsak+axb9GwWdRuwXHu9Pw3vep9+Qwtd3YUnBezSefdtxL1HIOHt/vtcKl2E8y7U8+PAXKQvcYBwtKyp1P99mBO/CwaOvvaYv1w4aHHU34aMyleRrj3zrai5pQwbFuInadStDvG6Tmy08wjiGduF+VHgZc8yzDK0sGlXTzEU0etCMRTDJ8IrhSPz4ex8Ym4v6+gbmLpRdvmj8pzu9d1YbhRwKFfcaxGfE3r57O89PF7rDe1l5rotPQV7fjfFAOIkfHFLEDNw7jR4DtMqdxryKRdHOzjR/YgWX5/NmNSo3UIHnbn667Yd1Gdjo9gIVeObwJY/qpSB8TzgkwxFl07q9DsrYkjnTHTi8JJocS9RZeA9qp+wc7zOm6s+Kjpv7tiI7U32QEVoTtAORfxaqjPCoZvyiJ8/7zGu7FY45WqHb+cRhDp0k9oYWewNikoUWMLqHTN6/otmJt1D59aDQjVg0a3yN3zkNR+QpJNf2RUV/29Onxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(2616005)(66476007)(66946007)(316002)(38100700002)(186003)(6916009)(4326008)(8676002)(86362001)(66556008)(36756003)(6512007)(1076003)(107886003)(5660300002)(83380400001)(508600001)(66574015)(6666004)(2906002)(8936002)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Ydik2aMH67T6Fz59E6mHZKTIQb8L+DvfhlHl39Yp1b89vs590mfLKCOcXpt?=
 =?us-ascii?Q?1DsRBLydsy1p8+opunT74LSDoDY8A7CBdQyz8+LlrDLS9CZbOTOCZA+regcC?=
 =?us-ascii?Q?0lRMbbsl9N+9Xe9xhZwSRac4PhnK4EjXCLazieA9aok3uuActYOycPd4UyRq?=
 =?us-ascii?Q?Pmqs05PQR34mv3yNvY7gEABl6DLacZI4zXrJFnZLXC1CFAP8d8+9yIbwcs72?=
 =?us-ascii?Q?f3mL2bRA7Dt+iybi0KVEwgPlIdc8LxFvmWa2w1PahnxPaqcpKR8lA0xUJh7K?=
 =?us-ascii?Q?vZXkTDEtjiWN/Rve5wg53YYiupeAY9E7ruO1wc/1aItjcDttse/E2kFA21Ed?=
 =?us-ascii?Q?mLXljn5lMI53SxUex+fThRdDZMyL0mqQQxyAZWvKxx2StDA85rAREleuMQtP?=
 =?us-ascii?Q?YNxMvqr0sbr07eIO+J1Z+RQytJAuRXdNzvlrKg4GHZuxMHOLByLjDNdvAOjy?=
 =?us-ascii?Q?SAd0N66zHSucekR4vyRWeqJddmQGUACWG7BXYn10FmU//ungi1gUZU9SPoAv?=
 =?us-ascii?Q?wT1QqSYQmteBFehmCtV+njmqDPqJ/xlcwhKhOs/2paf4lZC0+nlrsHlweHJw?=
 =?us-ascii?Q?OUZ4FBWK1mIGe2XUjYyYhAUf29X5cQT7kFYvQCgFuyvh8rwRxVN+vNlliapp?=
 =?us-ascii?Q?m98b4e60yWiu7ZJis6l6y7wuYi7ava55D3aINNNkTurR6Wub4+F1lKjBhdIU?=
 =?us-ascii?Q?BijIu0SNh85fVwCRCSmg16fHeY26n86sx1u6WhQK1L/u6bmhiSMMWh6y40j3?=
 =?us-ascii?Q?bfc9DP/24lLiK18xoj1u9MR5mnQxvDsgYp16wATFGQcMt1SI3VveKVNOGfF6?=
 =?us-ascii?Q?Bs9oto1+s3qFHtTwIEyMhoIzuuQFamxYhof4+Eu+NPOdChTNLum5vW5Wa44u?=
 =?us-ascii?Q?sK+cuv6fiddUI9H6oVQYxobFLXG4ZzJM7OwZKitfhwWfwQ5dswxrOanyRMKl?=
 =?us-ascii?Q?4COMw4Kt2ap5O6ofcclotC5Qs5pPYO6lKzwj8W/ar3k4mBdeYpaILGvKkKFj?=
 =?us-ascii?Q?r6aVteEnDQFM0j6VDwB8AqY4K/20MmUq1JX49De8rjIkLq0mSmbrnPk4sdTO?=
 =?us-ascii?Q?kmr15EMOe8PGvc0UvvrxpUNaJ9P4N5UBnGLjGmqmB2AFLGIPXOKExIfPXQ4P?=
 =?us-ascii?Q?b6ANRxIP7Ovl72NSTVPNaLic+RSsMyV+th6bkRNboHyya1rrmVEYfVr5CWpG?=
 =?us-ascii?Q?0q67t4V+3UyMOhncCNxBbJmqIIENY0dB+rIHcUGvl1PUcpDJ3tIOWz6eHVWm?=
 =?us-ascii?Q?X4TbC9xeuyXaLaTLAhZjVGpEHxKIcWfKdJ+/T/5mi7MB72a4NLXNjJlAf5h/?=
 =?us-ascii?Q?LxOpYN8SH6FGZ2L1jEFUmi3ItEifj0nPEnXTTerKO6uWjdj3DtvJ572KJm5w?=
 =?us-ascii?Q?4tH/p/76zEuq2/ilA/gbHbS2uME5zzA8Zm1picKhia7shln6WEbKQ9aTwG0u?=
 =?us-ascii?Q?SyrUftPt9Fl1Qa2wiyGHaAR/4PJqt/G+cBFlKTzDxvMET5+YzXIp1xZV1+Td?=
 =?us-ascii?Q?b5hmH8S86WLgAVhJxxZjHhHyXV5A+F7bdXQhMTz5b9ceSIxN4bXjVk2zTNBI?=
 =?us-ascii?Q?xuIUiPGnEwdfIxTXugfg2GC6e50pHhJiLTrs2l4Zzv/AFVbCJE/RSfBu0fEg?=
 =?us-ascii?Q?nBf0Pp0ColGJXacKp8OI9xs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9df8241-f45b-404d-449a-08d9f79a6a33
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:34:42.9342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CI8zATMBafQx2SYwjDV1mn8LNKvt24/a4YkD+2w1VakAjzZfhkEBGVTGPDEPBi3Kp4uFzbivIUpymgGsj5Hvhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Add a new IFLA_STATS_LINK_OFFLOAD_XSTATS child attribute,
IFLA_OFFLOAD_XSTATS_L3_STATS, to carry statistics for traffic that takes
place in a HW router.

The offloaded HW stats are designed to allow per-netdevice enablement and
disablement. Additionally, as a netdevice is configured, it may become or
cease being suitable for binding of a HW counter. Both of these aspects
need to be communicated to the userspace. To that end, add another child
attribute, IFLA_OFFLOAD_XSTATS_HW_S_INFO:

    - attr nest IFLA_OFFLOAD_XSTATS_HW_S_INFO
	- attr nest IFLA_OFFLOAD_XSTATS_L3_STATS
 	    - attr IFLA_OFFLOAD_XSTATS_HW_S_INFO_REQUEST
	      - {0,1} as u8
 	    - attr IFLA_OFFLOAD_XSTATS_HW_S_INFO_USED
	      - {0,1} as u8

Thus this one attribute is a nest that can be used to carry information
about various types of HW statistics, and indexing is very simply done by
wrapping the information for a given statistics suite into the attribute
that carries the suite is the RTM_GETSTATS query. At the same time, because
_HW_S_INFO is nested directly below IFLA_STATS_LINK_OFFLOAD_XSTATS, it is
possible through filtering to request only the metadata about individual
statistics suites, without having to hit the HW to get the actual counters.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/if_link.h |  11 +++
 net/core/rtnetlink.c         | 170 +++++++++++++++++++++++++++++++++++
 2 files changed, 181 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index f5d88a7b1c36..704e32bbf160 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1186,10 +1186,21 @@ enum {
 enum {
 	IFLA_OFFLOAD_XSTATS_UNSPEC,
 	IFLA_OFFLOAD_XSTATS_CPU_HIT, /* struct rtnl_link_stats64 */
+	IFLA_OFFLOAD_XSTATS_HW_S_INFO,	/* HW stats info. A nest */
+	IFLA_OFFLOAD_XSTATS_L3_STATS,	/* struct rtnl_link_stats64 */
 	__IFLA_OFFLOAD_XSTATS_MAX
 };
 #define IFLA_OFFLOAD_XSTATS_MAX (__IFLA_OFFLOAD_XSTATS_MAX - 1)
 
+enum {
+	IFLA_OFFLOAD_XSTATS_HW_S_INFO_UNSPEC,
+	IFLA_OFFLOAD_XSTATS_HW_S_INFO_REQUEST,		/* u8 */
+	IFLA_OFFLOAD_XSTATS_HW_S_INFO_USED,		/* u8 */
+	__IFLA_OFFLOAD_XSTATS_HW_S_INFO_MAX,
+};
+#define IFLA_OFFLOAD_XSTATS_HW_S_INFO_MAX \
+	(__IFLA_OFFLOAD_XSTATS_HW_S_INFO_MAX - 1)
+
 /* XDP section */
 
 #define XDP_FLAGS_UPDATE_IF_NOEXIST	(1U << 0)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d79e2c26b494..0db745cc3f11 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5091,10 +5091,110 @@ rtnl_offload_xstats_fill_ndo(struct net_device *dev, int attr_id,
 	return 0;
 }
 
+static unsigned int
+rtnl_offload_xstats_get_size_stats(const struct net_device *dev,
+				   enum netdev_offload_xstats_type type)
+{
+	bool enabled = netdev_offload_xstats_enabled(dev, type);
+
+	return enabled ? sizeof(struct rtnl_link_stats64) : 0;
+}
+
+struct rtnl_offload_xstats_request_used {
+	bool request;
+	bool used;
+};
+
+static int
+rtnl_offload_xstats_get_stats(struct net_device *dev,
+			      enum netdev_offload_xstats_type type,
+			      struct rtnl_offload_xstats_request_used *ru,
+			      struct rtnl_link_stats64 *stats,
+			      struct netlink_ext_ack *extack)
+{
+	bool request;
+	bool used;
+	int err;
+
+	request = netdev_offload_xstats_enabled(dev, type);
+	if (!request) {
+		used = false;
+		goto out;
+	}
+
+	err = netdev_offload_xstats_get(dev, type, stats, &used, extack);
+	if (err)
+		return err;
+
+out:
+	if (ru) {
+		ru->request = request;
+		ru->used = used;
+	}
+	return 0;
+}
+
+static int
+rtnl_offload_xstats_fill_hw_s_info_one(struct sk_buff *skb, int attr_id,
+				       struct rtnl_offload_xstats_request_used *ru)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, attr_id);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u8(skb, IFLA_OFFLOAD_XSTATS_HW_S_INFO_REQUEST, ru->request))
+		goto nla_put_failure;
+
+	if (nla_put_u8(skb, IFLA_OFFLOAD_XSTATS_HW_S_INFO_USED, ru->used))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int
+rtnl_offload_xstats_fill_hw_s_info(struct sk_buff *skb, struct net_device *dev,
+				   struct netlink_ext_ack *extack)
+{
+	enum netdev_offload_xstats_type t_l3 = NETDEV_OFFLOAD_XSTATS_TYPE_L3;
+	struct rtnl_offload_xstats_request_used ru_l3;
+	struct nlattr *nest;
+	int err;
+
+	err = rtnl_offload_xstats_get_stats(dev, t_l3, &ru_l3, NULL, extack);
+	if (err)
+		return err;
+
+	nest = nla_nest_start(skb, IFLA_OFFLOAD_XSTATS_HW_S_INFO);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (rtnl_offload_xstats_fill_hw_s_info_one(skb,
+						   IFLA_OFFLOAD_XSTATS_L3_STATS,
+						   &ru_l3))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
 static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
 				    int *prividx, u32 off_filter_mask,
 				    struct netlink_ext_ack *extack)
 {
+	enum netdev_offload_xstats_type t_l3 = NETDEV_OFFLOAD_XSTATS_TYPE_L3;
+	int attr_id_hw_s_info = IFLA_OFFLOAD_XSTATS_HW_S_INFO;
+	int attr_id_l3_stats = IFLA_OFFLOAD_XSTATS_L3_STATS;
 	int attr_id_cpu_hit = IFLA_OFFLOAD_XSTATS_CPU_HIT;
 	bool have_data = false;
 	int err;
@@ -5111,6 +5211,40 @@ static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
 		}
 	}
 
+	if (*prividx <= attr_id_hw_s_info &&
+	    (off_filter_mask & IFLA_STATS_FILTER_BIT(attr_id_hw_s_info))) {
+		*prividx = attr_id_hw_s_info;
+
+		err = rtnl_offload_xstats_fill_hw_s_info(skb, dev, extack);
+		if (err)
+			return err;
+
+		have_data = true;
+		*prividx = 0;
+	}
+
+	if (*prividx <= attr_id_l3_stats &&
+	    (off_filter_mask & IFLA_STATS_FILTER_BIT(attr_id_l3_stats))) {
+		unsigned int size_l3;
+		struct nlattr *attr;
+
+		*prividx = attr_id_l3_stats;
+
+		size_l3 = rtnl_offload_xstats_get_size_stats(dev, t_l3);
+		attr = nla_reserve_64bit(skb, attr_id_l3_stats, size_l3,
+					 IFLA_OFFLOAD_XSTATS_UNSPEC);
+		if (!attr)
+			return -EMSGSIZE;
+
+		err = rtnl_offload_xstats_get_stats(dev, t_l3, NULL,
+						    nla_data(attr), extack);
+		if (err)
+			return err;
+
+		have_data = true;
+		*prividx = 0;
+	}
+
 	if (!have_data)
 		return -ENODATA;
 
@@ -5118,9 +5252,35 @@ static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 }
 
+static unsigned int
+rtnl_offload_xstats_get_size_hw_s_info_one(const struct net_device *dev,
+					   enum netdev_offload_xstats_type type)
+{
+	bool enabled = netdev_offload_xstats_enabled(dev, type);
+
+	return nla_total_size(0) +
+		/* IFLA_OFFLOAD_XSTATS_HW_S_INFO_REQUEST */
+		nla_total_size(sizeof(u8)) +
+		/* IFLA_OFFLOAD_XSTATS_HW_S_INFO_USED */
+		(enabled ? nla_total_size(sizeof(u8)) : 0) +
+		0;
+}
+
+static unsigned int
+rtnl_offload_xstats_get_size_hw_s_info(const struct net_device *dev)
+{
+	enum netdev_offload_xstats_type t_l3 = NETDEV_OFFLOAD_XSTATS_TYPE_L3;
+
+	return nla_total_size(0) +
+		/* IFLA_OFFLOAD_XSTATS_L3_STATS */
+		rtnl_offload_xstats_get_size_hw_s_info_one(dev, t_l3) +
+		0;
+}
+
 static int rtnl_offload_xstats_get_size(const struct net_device *dev,
 					u32 off_filter_mask)
 {
+	enum netdev_offload_xstats_type t_l3 = NETDEV_OFFLOAD_XSTATS_TYPE_L3;
 	int attr_id_cpu_hit = IFLA_OFFLOAD_XSTATS_CPU_HIT;
 	int nla_size = 0;
 	int size;
@@ -5131,6 +5291,16 @@ static int rtnl_offload_xstats_get_size(const struct net_device *dev,
 		nla_size += nla_total_size_64bit(size);
 	}
 
+	if (off_filter_mask &
+	    IFLA_STATS_FILTER_BIT(IFLA_OFFLOAD_XSTATS_HW_S_INFO))
+		nla_size += rtnl_offload_xstats_get_size_hw_s_info(dev);
+
+	if (off_filter_mask &
+	    IFLA_STATS_FILTER_BIT(IFLA_OFFLOAD_XSTATS_L3_STATS)) {
+		size = rtnl_offload_xstats_get_size_stats(dev, t_l3);
+		nla_size += nla_total_size_64bit(size);
+	}
+
 	if (nla_size != 0)
 		nla_size += nla_total_size(0);
 
-- 
2.33.1

