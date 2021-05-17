Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC627383C0B
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244179AbhEQSRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:17:41 -0400
Received: from azhdrrw-ex02.nvidia.com ([20.64.145.131]:53252 "EHLO
        AZHDRRW-EX02.NVIDIA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244156AbhEQSRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 14:17:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by mxs.oss.nvidia.com (10.13.234.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 11:16:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnGcLrq24ysLGQzD0qp1KpuEegzJ6jHCavDC/U8QY1Pdpr3XqMdc4E7v5u61MOOqEBd1tZvVWPr9n3FaH8SacqYt5zkUNAxoOYi49f16pnKHcMkbvg+5jW/0evciuSD5BKTKGWZQi/TDn/h+83kUczwXeT3Mg8X/DolO2t7YZxTRalOPDCXl48fWGhPZjEBi902afhSWFqpNsFZT2kVaqeXhk1zPDB8L1BbyXvJEg4yDIh07GyPpaaWMcmgRQ8RVmErAzjiIAgGInN7DE+kbzoLUWKZTZaw5EuIhgobCgRu9XUb9/gMtd0XhBr2cXhZQT2/QjIZvbQOB/9q5qVJJ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgL1LRcZFnxZ5s2rkXSpzIx5ZqgMZoOhxxf4+ZZ5wck=;
 b=FWYHB4B7PPXis+qGtBZ5+PrXPBDbvi7BW6aYYOG2VQRWUdogO4m4k6AyblkXvVQqf7SpAHS4ChohVhVokTkvjAN6Gz5Im20YHozB4wLZgGL7R7NmzrB8iKBBIbWs1jO7PPnhJM3/dIU6BjPVZqPNQjunkFLhwDSZ7a7iU9qJaFcvbHD9M1a2jjFJFz9oTRsfToBUmSx4pARPdoSDUAWz3ON1xg69E/gebOGFlTjwBlk4veRzLM5dVh2Cn2tVQUnmrLKM6s1B7031G2rd8XTkUmXwC711llDcF2g4FZHFVU8gA4gitJtT0Xvqk53qkeocnGdQuhMHO209/VNT8ChC+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgL1LRcZFnxZ5s2rkXSpzIx5ZqgMZoOhxxf4+ZZ5wck=;
 b=uSLVD5QYzyhEK0TGInHRWycABfVLYi24tGMHEbAgNQa/k/KoKj6tE4R+/xv6gFxPB0V7x4qCDaZaF9iCX9gEWr7Xr+EqO8a6X2kmlkWizdPZak2B52AiKj4ERR+DpZ0DGmIA7SupNaBHRj4VMvrDXfSx99J7TwPycIsFJCBa0JMzbSur3no5HT1743WN9LekjHfsKBxZ+3/PNBWoSVShuuS7kFnqFYD021Z49k4hKAieKnwsLCRdoivL15/beRaRiG9YtHE4lS+KWEm8icEm9bp3teYCzGE0lbkqyRu8+lOgu5nmIAlCMfXu2OEXMymOI++h1h+9CZF2Jy4FXtjH8w==
Received: from BN8PR16CA0016.namprd16.prod.outlook.com (2603:10b6:408:4c::29)
 by PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 17 May
 2021 18:16:19 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::3a) by BN8PR16CA0016.outlook.office365.com
 (2603:10b6:408:4c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 17 May 2021 18:16:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 18:16:19 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 18:16:15 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <dsahern@gmail.com>,
        <petrm@OSS.NVIDIA.COM>, <roopa@OSS.NVIDIA.COM>,
        <nikolay@OSS.NVIDIA.COM>, <ssuryaextr@gmail.com>,
        <mlxsw@OSS.NVIDIA.COM>, Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 03/10] ipv4: Add custom multipath hash policy
Date:   Mon, 17 May 2021 21:15:19 +0300
Message-ID: <20210517181526.193786-4-idosch@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: a1493045-8d6a-4fa0-a5b5-08d9195fde76
X-MS-TrafficTypeDiagnostic: PH0PR12MB5481:
X-Microsoft-Antispam-PRVS: <PH0PR12MB548103AD9A5C6D46E7D446DBB22D9@PH0PR12MB5481.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0VVA187EwLbSzJXjbI+ulbI1FSh6jNLpvVlNgcHii/GdtzojWhR4fJM3H7KsBzjsWwptIdo7XxHwrEoeDFC9JkgrHCM0yegQSxzPjkdCymLppLb1m4w29d9xsWNkIU9rM4YRSn2fMgZz6KlpgKyLpAT1hIrKnpeLuhudYY0d1g/+uDIddljPB8BN77amR3JliOpt3fWgTRo4bJCVy9eSPAoG/RJ7GPLbR1mJMniC8oJ5hPMiHtW+4tUW+EVesqbJEtpF+PylLV472TgzNAl2MlM4X7+Z7r72Kjmy/+6/6dszAtYLPqJZYmdgqI1QRbRZk5DirImeqMwr9LRz526IfiGrNIw/2eNISV7HbhWFYFBcrXj7Cu5HnR0Gxc5uynb4BM3bxwiK2zDMA4rsMLltNLI1YsRWUBZVY729pFz2W7jS4Gkdqn8X8MC5lKM+cCjXufjU3C65uVnoJKUaZ9UaDwUaQduV0NlGRfnkFs5GC5JMjWt00brARnB7XpCwxOHPAU02Q/hzunWxmWWwHZw+j7g0NlgyOT6y+GVJ8CpuweAhFSwlB70RslrQlvR0IGMvdHVWkuExCIuQik0GMlfNj0cFfWQ74OtnGlASYOQCvjbGrGBUiIyt0kIuzyOLu0r1inQGlHUWJWED4TkXwy6msqM1sGA2qHaw+5Okl5yuHLs=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(36840700001)(46966006)(16526019)(186003)(1076003)(336012)(5660300002)(2906002)(426003)(82310400003)(82740400003)(356005)(47076005)(70586007)(70206006)(2616005)(36756003)(6916009)(86362001)(478600001)(8936002)(7636003)(316002)(36906005)(54906003)(8676002)(26005)(36860700001)(4326008)(107886003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 18:16:19.2871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1493045-8d6a-4fa0-a5b5-08d9195fde76
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5481
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
 net/ipv4/route.c                       | 121 +++++++++++++++++++++++++
 net/ipv4/sysctl_net_ipv4.c             |   3 +-
 3 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 47494798d03b..afdcdc0691d6 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -99,6 +99,8 @@ fib_multipath_hash_policy - INTEGER
 	- 0 - Layer 3
 	- 1 - Layer 4
 	- 2 - Layer 3 or inner Layer 3 if present
+	- 3 - Custom multipath hash. Fields used for multipath hash calculation
+	  are determined by fib_multipath_hash_fields sysctl
 
 fib_multipath_hash_fields - UNSIGNED INTEGER
 	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 9d61e969446e..a4c477475f4c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1906,6 +1906,121 @@ static void ip_multipath_l3_keys(const struct sk_buff *skb,
 	hash_keys->addrs.v4addrs.dst = key_iph->daddr;
 }
 
+static u32 fib_multipath_custom_hash_outer(const struct net *net,
+					   const struct sk_buff *skb,
+					   bool *p_has_inner)
+{
+	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	struct flow_keys keys, hash_keys;
+
+	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	skb_flow_dissect_flow_keys(skb, &keys, FLOW_DISSECTOR_F_STOP_AT_ENCAP);
+
+	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP)
+		hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP)
+		hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
+		hash_keys.basic.ip_proto = keys.basic.ip_proto;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
+		hash_keys.ports.src = keys.ports.src;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
+		hash_keys.ports.dst = keys.ports.dst;
+
+	*p_has_inner = !!(keys.control.flags & FLOW_DIS_ENCAPSULATION);
+	return flow_hash_from_keys(&hash_keys);
+}
+
+static u32 fib_multipath_custom_hash_inner(const struct net *net,
+					   const struct sk_buff *skb,
+					   bool has_inner)
+{
+	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
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
+static u32 fib_multipath_custom_hash_skb(const struct net *net,
+					 const struct sk_buff *skb)
+{
+	u32 mhash, mhash_inner;
+	bool has_inner = true;
+
+	mhash = fib_multipath_custom_hash_outer(net, skb, &has_inner);
+	mhash_inner = fib_multipath_custom_hash_inner(net, skb, has_inner);
+
+	return jhash_2words(mhash, mhash_inner, 0);
+}
+
+static u32 fib_multipath_custom_hash_fl4(const struct net *net,
+					 const struct flowi4 *fl4)
+{
+	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	struct flow_keys hash_keys;
+
+	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
+		return 0;
+
+	memset(&hash_keys, 0, sizeof(hash_keys));
+	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP)
+		hash_keys.addrs.v4addrs.src = fl4->saddr;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP)
+		hash_keys.addrs.v4addrs.dst = fl4->daddr;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
+		hash_keys.basic.ip_proto = fl4->flowi4_proto;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
+		hash_keys.ports.src = fl4->fl4_sport;
+	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
+		hash_keys.ports.dst = fl4->fl4_dport;
+
+	return flow_hash_from_keys(&hash_keys);
+}
+
 /* if skb is set it will be used and fl4 can be NULL */
 int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 		       const struct sk_buff *skb, struct flow_keys *flkeys)
@@ -1991,6 +2106,12 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 		}
 		mhash = flow_hash_from_keys(&hash_keys);
 		break;
+	case 3:
+		if (skb)
+			mhash = fib_multipath_custom_hash_skb(net, skb);
+		else
+			mhash = fib_multipath_custom_hash_fl4(net, fl4);
+		break;
 	}
 
 	if (multipath_hash)
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 45bab3733621..ffb38ea06841 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -30,6 +30,7 @@
 #include <net/netevent.h>
 
 static int two = 2;
+static int three __maybe_unused = 3;
 static int four = 4;
 static int thousand = 1000;
 static int tcp_retr1_max = 255;
@@ -1053,7 +1054,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_fib_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= &three,
 	},
 	{
 		.procname	= "fib_multipath_hash_fields",
-- 
2.31.1

