Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56003383C10
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244292AbhEQSR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:17:58 -0400
Received: from azhdrrw-ex02.nvidia.com ([20.64.145.131]:53255 "EHLO
        AZHDRRW-EX02.NVIDIA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244157AbhEQSRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 14:17:52 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by mxs.oss.nvidia.com (10.13.234.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 11:16:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbAnkfizO8wg1YjIOLUDochQf9W/THDzNB5uYJInxbJdbFudbHpA0F1w0MkXb7bY+hm8CspnX6c3w0+eSqFluKsGuRIHUzVn+kbG5ix+Y2yfOxVte36Xp8EE3ucOdv8WsvYkDJT2CvixuLAc8jYQJAgmbmFfp1OTc5e4zM1Gm3n8t8hm/egRkTbn9h6qr6kYQCZjY8o+HlU6Yb0zzpIpvHXaMK2U9rLCxYwFYpq0oTtpm7JufYPHENeD3V6PYc+KoyTy6jZmAfh+/RS2GMxrA3D9Xd/9z4Ro36WxEs+i+fs0FuVbdxc4TVT0aL8EpEOPg6YkJiDFKuuAk0xMEhzRxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63Dnq/mZ4a9E6YazWWmcgim36ucTym9vL0GcZ08Ctis=;
 b=fxfdT/TzMA/9nhJDMKiXr+35NcyIxUdAbPX46fSWRcluY4iZeql+W/L+a2L13COfS+hjKkRkmwvPJXvTlKHUwLzT2jxUlLgPEa+rc+i73VOMSPmQnW2M6OF0NTBbYq67TQ71mpjSt74VU8dhM9rJW1sLR88XtmK6GGkgphKan7vYpXORazfQnozND8cZta3kDiNophA64AKbPNnEPAo19jz20peJAZHa8zShU+JokUq4YJ5t4ZkrIIOFLAlmzewT1D9TmBG2HtkbAmX7xDolic1YtiP/KrHntSLrWJJsiSmvVQTSzYNXI2l0Ps7KFCGU3UjS88uhjEfkKp0r4H793Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63Dnq/mZ4a9E6YazWWmcgim36ucTym9vL0GcZ08Ctis=;
 b=pPbM+IQ2VqI4yko/BeWcPX2xkDy6ifNaqbEMiO1k6PLze6wDr731NNPJ/7b7HBDEGpZckIpBfSlTYuBMgfvEk+j4/OzkKGFU3LvGcoHyRPtcX+ki24zACVgIf62qK8xWqJnDpKMx1o8f2Y0NWC0tSp4Tqxfp8bNunZtUI9n+BCuPd1BHZr8Xv7/eznNZ+eER91Hky64mFP/y1q0FI7lyu6h955/wEki7Qqst8CFMHCZMO5IJ/Di63AMXXg8tkJLW/2bxN6a9mFXWvYEW3vhnnZr6JlV++fsm1/UGRL2Ji0qZ6Z6p8jT9legmeVLGO9/3o+WfX7nMKzAC3mlRMZg9TQ==
Received: from BN6PR11CA0053.namprd11.prod.outlook.com (2603:10b6:404:f7::15)
 by BL1PR12MB5206.namprd12.prod.outlook.com (2603:10b6:208:31c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Mon, 17 May
 2021 18:16:34 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f7:cafe::d7) by BN6PR11CA0053.outlook.office365.com
 (2603:10b6:404:f7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Mon, 17 May 2021 18:16:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 18:16:34 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 18:16:29 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <dsahern@gmail.com>,
        <petrm@OSS.NVIDIA.COM>, <roopa@OSS.NVIDIA.COM>,
        <nikolay@OSS.NVIDIA.COM>, <ssuryaextr@gmail.com>,
        <mlxsw@OSS.NVIDIA.COM>, Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 07/10] ipv6: Add custom multipath hash policy
Date:   Mon, 17 May 2021 21:15:23 +0300
Message-ID: <20210517181526.193786-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517181526.193786-1-idosch@nvidia.com>
References: <20210517181526.193786-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78242c00-6bbb-4ded-4ee3-08d9195fe749
X-MS-TrafficTypeDiagnostic: BL1PR12MB5206:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5206B4D04A26D9702F4FA0D3B22D9@BL1PR12MB5206.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KFrayZl51G/KLGQEOUeRSq6F4f+y35Afo7NcnRdueyIPlJEPfdqbRl/XhAiuwZehpSeB9vgFZXacb/y6BKu1zIkcQQiB8nAAaFlRaV3KQTTO3U8EsqvVmG0At+cSrOD7nw/6TqnIlF3qhFymmY9Xz+EEwSadFeaGdcpUSIRpszi4eCMiCmGZuO3DZRcd+2Oi9NArTYwrGkPRXvXwcILNMgiSTXi1cuu1+QUICVdI9mTMH/f8h5RIMcLkorIyBkZ9Bo8wJ6bsYl9hTibUsXtWzhfjGifUoTvdTPTHfaeGOPUZDqcKmOFd6MFZXLoW3zN1B++qVVfpDoOVL6qlIapv+5JV4Tn6pRlDyGVLJ+YRKv5kr66JYBJ115DvDcEfrDXX0uXlxzccDXr7F1q6lzvG7vu07YJSEq0lkCgS+1XCIP51tgbuf1HS/bHo2DHB8dzNJKTHew+WJrBHl5AlWAeAWF1Zk1yZhn8O/bMTy02NE6jxalsTd2KI6VnTni2Y9Nkr9S82JMZ3GyE4Sa/XucGzMdlvx2rdjeT+tw8g3dG4OwFHPtgGoDJVeNPcrFo1qq7BzU1dKbxSzre4UobupwergV/jhqU/Da749qyrK6mzxycJzgnf4EY6FVhDYNNDLxZBW2PjV6IP5PrZCL3F23McBnQVlaIgb1Eif2jH3SHYh3A=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39860400002)(136003)(36840700001)(46966006)(426003)(83380400001)(336012)(186003)(6916009)(82310400003)(356005)(2616005)(36906005)(1076003)(26005)(2906002)(54906003)(47076005)(36756003)(6666004)(70206006)(86362001)(70586007)(8676002)(36860700001)(8936002)(107886003)(16526019)(7636003)(82740400003)(316002)(4326008)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 18:16:34.0695
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78242c00-6bbb-4ded-4ee3-08d9195fe749
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new multipath hash policy where the packet fields used for hash
calculation are determined by user space via the
fib_multipath_hash_fields sysctl that was introduced in the previous
patch.

The current set of available packet fields includes both outer and inner
fields, which requires two invocations of the flow dissector. Avoid
unnecessary dissection of the outer or inner flows by skipping
dissection if none of the outer or inner fields are required.

In accordance with the existing policies, when an skb is not available,
packet fields are extracted from the provided flow key. In which case,
only outer fields are considered.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst |   2 +
 net/ipv6/route.c                       | 125 +++++++++++++++++++++++++
 net/ipv6/sysctl_net_ipv6.c             |   3 +-
 3 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 4246cc4ae35b..a5c250044500 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1772,6 +1772,8 @@ fib_multipath_hash_policy - INTEGER
 	- 0 - Layer 3 (source and destination addresses plus flow label)
 	- 1 - Layer 4 (standard 5-tuple)
 	- 2 - Layer 3 or inner Layer 3 if present
+	- 3 - Custom multipath hash. Fields used for multipath hash calculation
+	  are determined by fib_multipath_hash_fields sysctl
 
 fib_multipath_hash_fields - UNSIGNED INTEGER
 	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 9935e18146e5..c46889381ae4 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2326,6 +2326,125 @@ static void ip6_multipath_l3_keys(const struct sk_buff *skb,
 	}
 }
 
+static u32 rt6_multipath_custom_hash_outer(const struct net *net,
+					   const struct sk_buff *skb,
+					   bool *p_has_inner)
+{
+	u32 hash_fields = ip6_multipath_hash_fields(net);
+	struct flow_keys keys, hash_keys;
+
+	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	skb_flow_dissect_flow_keys(skb, &keys, FLOW_DISSECTOR_F_STOP_AT_ENCAP);
+
+	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP)
+		hash_keys.addrs.v6addrs.src = keys.addrs.v6addrs.src;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP)
+		hash_keys.addrs.v6addrs.dst = keys.addrs.v6addrs.dst;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
+		hash_keys.basic.ip_proto = keys.basic.ip_proto;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_FLOWLABEL)
+		hash_keys.tags.flow_label = keys.tags.flow_label;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
+		hash_keys.ports.src = keys.ports.src;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
+		hash_keys.ports.dst = keys.ports.dst;
+
+	*p_has_inner = !!(keys.control.flags & FLOW_DIS_ENCAPSULATION);
+	return flow_hash_from_keys(&hash_keys);
+}
+
+static u32 rt6_multipath_custom_hash_inner(const struct net *net,
+					   const struct sk_buff *skb,
+					   bool has_inner)
+{
+	u32 hash_fields = ip6_multipath_hash_fields(net);
+	struct flow_keys keys, hash_keys;
+
+	/* We assume the packet carries an encapsulation, but if none was
+	 * encountered during dissection of the outer flow, then there is no
+	 * point in calling the flow dissector again.
+	 */
+	if (!has_inner)
+		return 0;
+
+	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_MASK))
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	skb_flow_dissect_flow_keys(skb, &keys, 0);
+
+	if (!(keys.control.flags & FLOW_DIS_ENCAPSULATION))
+		return 0;
+
+	if (keys.control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP)
+			hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP)
+			hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
+	} else if (keys.control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP)
+			hash_keys.addrs.v6addrs.src = keys.addrs.v6addrs.src;
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP)
+			hash_keys.addrs.v6addrs.dst = keys.addrs.v6addrs.dst;
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_FLOWLABEL)
+			hash_keys.tags.flow_label = keys.tags.flow_label;
+	}
+
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_IP_PROTO)
+		hash_keys.basic.ip_proto = keys.basic.ip_proto;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_PORT)
+		hash_keys.ports.src = keys.ports.src;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_PORT)
+		hash_keys.ports.dst = keys.ports.dst;
+
+	return flow_hash_from_keys(&hash_keys);
+}
+
+static u32 rt6_multipath_custom_hash_skb(const struct net *net,
+					 const struct sk_buff *skb)
+{
+	u32 mhash, mhash_inner;
+	bool has_inner = true;
+
+	mhash = rt6_multipath_custom_hash_outer(net, skb, &has_inner);
+	mhash_inner = rt6_multipath_custom_hash_inner(net, skb, has_inner);
+
+	return jhash_2words(mhash, mhash_inner, 0);
+}
+
+static u32 rt6_multipath_custom_hash_fl6(const struct net *net,
+					 const struct flowi6 *fl6)
+{
+	u32 hash_fields = ip6_multipath_hash_fields(net);
+	struct flow_keys hash_keys;
+
+	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP)
+		hash_keys.addrs.v6addrs.src = fl6->saddr;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP)
+		hash_keys.addrs.v6addrs.dst = fl6->daddr;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
+		hash_keys.basic.ip_proto = fl6->flowi6_proto;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_FLOWLABEL)
+		hash_keys.tags.flow_label = (__force u32)flowi6_get_flowlabel(fl6);
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
+		hash_keys.ports.src = fl6->fl6_sport;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
+		hash_keys.ports.dst = fl6->fl6_dport;
+
+	return flow_hash_from_keys(&hash_keys);
+}
+
 /* if skb is set it will be used and fl6 can be NULL */
 u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 		       const struct sk_buff *skb, struct flow_keys *flkeys)
@@ -2416,6 +2535,12 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 		}
 		mhash = flow_hash_from_keys(&hash_keys);
 		break;
+	case 3:
+		if (skb)
+			mhash = rt6_multipath_custom_hash_skb(net, skb);
+		else
+			mhash = rt6_multipath_custom_hash_fl6(net, fl6);
+		break;
 	}
 
 	return mhash >> 1;
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index ce23c8f7ceb3..160bea5db973 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -23,6 +23,7 @@
 #endif
 
 static int two = 2;
+static int three = 3;
 static int flowlabel_reflect_max = 0x7;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
 static u32 rt6_multipath_hash_fields_all_mask =
@@ -152,7 +153,7 @@ static struct ctl_table ipv6_table_template[] = {
 		.mode		= 0644,
 		.proc_handler   = proc_rt6_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= &three,
 	},
 	{
 		.procname	= "fib_multipath_hash_fields",
-- 
2.31.1

