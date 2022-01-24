Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CAA49834C
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240653AbiAXPOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:14:08 -0500
Received: from mail-sn1anam02on2086.outbound.protection.outlook.com ([40.107.96.86]:28703
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240645AbiAXPOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 10:14:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m90ZWpiLGswqNyVeEevC+2sdQuSDIIadpEJytHOD9Wdag6+YtpmhqGpilZvoe6E2rO1brXUac4DgR/55lFFqd+1c1S1nEBjBlJL4mg/5DEZdWe4vYezAdkhwEkxWkSyMo88J3rc0bxRrqLqCCxDbF55U2Rwx02zYBr3qc0tH7dUmDWf1QlLgEBbEvCV1ikSMQDgYXpxdNgntJlQ1S7NfmSWgu11FJwumg55ZKo1bD+yf0Q5tgKzv3MPUfY8MPbfhnhmkQtQm8QBQ0V3EVxFCkKq/3s2iovBiUIdGe5OfAXwMn+L0TI/C3Uudna+7ybzvfH8W7A2yrhgi7AM87rLgeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RImuNywVSGNX3/nV1e9CECudm/fVj/P6OOZoEwQVmYA=;
 b=Rg0HbSIp8TtAhVZ+0z4Cbn32frULpe57FPV/m08YCM7lNCZQfei5JuO+9aSe3gE8fyQL/JiyR9hPiFrTYCMzRUD0yC9MPi1y507FIfuhfTDNJybgl9+Bcjv7XdSrThzfC9vdtCqF8nunN6OpXGUU8lD6QO/hyX6R9Ff0bEahf+EeEU0oRreQsmzpvLxhR6BZoTm36XTt0OT3Q+WHhKAh/v0jm2PplgjsBg3RxdZ2ZaHMk8eOaPyTOXvHvMGME7HpHUCG7Z+7Z0TgrY8d+QUQ0o1/6hwqmNsc+n/ABah+C98lI6lXV24wQ++eye7B/hQ1SWGfsoY+/f1xKkA1RXq5Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RImuNywVSGNX3/nV1e9CECudm/fVj/P6OOZoEwQVmYA=;
 b=F4GYkojGqshCqbhXQQhHsAlj+yKcTHLPQfkO4ECOPANSI/+sJAw+Xkkxv7MRY566VGmUkoXfF5eH8hlodeKRuA/9wAhT6wcRtyVFSj0K+eGKyjO2+cAgACrgenewigHZlOEYRoA41QRm1TWzNM92sk+BEUx9lQkGe9y0xnY9R+9OuHTGYADONEYb5PcMcxEj4pUXZrQ77ds91Ge0ot0vnKFofOEsO3bkdx5gwpEi11Re/Qa4LWVB3aXaE8pTX63n46qlPXZ/9h+dBWPefTw0x8ED6Zth8HFyz8bITUl/DzZEQL8KZUNgZD0GQaf+e7ApHhWPpmBzYMvNgdGtpTEOGQ==
Received: from BN6PR1401CA0013.namprd14.prod.outlook.com
 (2603:10b6:405:4b::23) by DM5PR1201MB0042.namprd12.prod.outlook.com
 (2603:10b6:4:50::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Mon, 24 Jan
 2022 15:14:04 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::ff) by BN6PR1401CA0013.outlook.office365.com
 (2603:10b6:405:4b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8 via Frontend
 Transport; Mon, 24 Jan 2022 15:14:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 15:14:03 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 15:14:02 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 07:14:02 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 24 Jan 2022 07:13:56 -0800
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        "Florent Revest" <revest@chromium.org>,
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH bpf-next v2 2/3] bpf: Add helpers to issue and check SYN cookies in XDP
Date:   Mon, 24 Jan 2022 17:13:39 +0200
Message-ID: <20220124151340.376807-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124151340.376807-1-maximmi@nvidia.com>
References: <20220124151340.376807-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27be4611-373f-45d5-fe6c-08d9df4c2870
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0042:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0042A702000D9D6419B012B3DC5E9@DM5PR1201MB0042.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RqJimlprRtzino81lTVG9VfQQu86RNJjPB+skOZhmn+Dn0B9E1wEhwJni5MBnAigmdZUyJHQCgR4cCYgVvZQ59Y2yql7eWkaWhQ0IaKrJV2KpsKI2ZjTaA44U+IrBc24jLk8rRd5CYRtJQLTzCggY2GhblRRVmzuIivVAHr56omq6+tXEwEe7/3GqeNrdjYqsCY3cU4pl3kzEOVG/VuhpJ0HBGlcuUQJ4JjF424bJOr2akG+OuVOomYnh0jEQ7Wl8wu2elEeylRRWKSuSflPD9p11N3h0hJdLFQjdqdDlZivZ7V5589pvewm8Syam7jQl62sD5CKkzRk1CYoDnvmFBf2MaVW1eMLzKfo6b9uO/bEgICGThtb0sTvHor+wU8GcncZY4vcxjofIbxBLlMs6mHqERqtVOtz6mC++xKBSDoNshNjnF/6NNjB2JujItwUHsAvVUxXGQyCbpuUSnXXSQhMR9DLDI2KM0RZumHY2QjY37rEOwbfM8H71NGhBYecnY1OTyXK2am6cfL6zu6YpNDKig3huEgB5QvZKUiQHXUTkxELHW6rQeGDA/akF4ZJahcBtllWxKDB7rBNlxZffXXPnCspHMr2asMLq6N5PPxqJh/cuNAdh1bSz4KTda1krtEbbPqIhTMUBpiYKyl2miEOUgNmm0AQo3DdFlQSJPJAUDI4xdHOYZSSkBZuPQJQdaPSzs0vVgWiuNGgIj/31it/sL0Jtd6UmCHzzQ0L3wuyvs7jELzOXOUF1OsMc6Px7vcmBoIuNhbqGcrWXQwpjkGH/4t4J96TYu0pX74cb6I=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700004)(1076003)(30864003)(110136005)(186003)(7696005)(82310400004)(4326008)(83380400001)(426003)(5660300002)(36756003)(356005)(86362001)(2906002)(508600001)(7416002)(316002)(2616005)(54906003)(81166007)(8936002)(47076005)(70206006)(6666004)(107886003)(70586007)(40460700003)(26005)(8676002)(336012)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 15:14:03.6294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27be4611-373f-45d5-fe6c-08d9df4c2870
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0042
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new helpers bpf_tcp_raw_{gen,check}_syncookie allow an XDP program
to generate SYN cookies in response to TCP SYN packets and to check
those cookies upon receiving the first ACK packet (the final packet of
the TCP handshake).

Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
listening socket on the local machine, which allows to use them together
with synproxy to accelerate SYN cookie generation.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/net/tcp.h              |   1 +
 include/uapi/linux/bpf.h       |  57 +++++++++++++++
 net/core/filter.c              | 122 +++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c           |   3 +-
 tools/include/uapi/linux/bpf.h |  57 +++++++++++++++
 5 files changed, 239 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 44e442bf23f9..0aca79f7b1be 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -432,6 +432,7 @@ u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
 			 struct tcphdr *th, u32 *cookie);
 u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
 			 struct tcphdr *th, u32 *cookie);
+u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss);
 u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
 			  const struct tcp_request_sock_ops *af_ops,
 			  struct sock *sk, struct tcphdr *th);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4d2d4a09bf25..07864277297b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5090,6 +5090,61 @@ union bpf_attr {
  *		associated to *xdp_md*, at *offset*.
  *	Return
  *		0 on success, or a negative error in case of failure.
+ *
+ * s64 bpf_tcp_raw_gen_syncookie(void *iph, u32 iph_len, struct tcphdr *th, u32 th_len)
+ *	Description
+ *		Try to issue a SYN cookie for the packet with corresponding
+ *		IP/TCP headers, *iph* and *th*, without depending on a listening
+ *		socket.
+ *
+ *		*iph* points to the start of the IPv4 or IPv6 header, while
+ *		*iph_len* contains **sizeof**\ (**struct iphdr**) or
+ *		**sizeof**\ (**struct ip6hdr**).
+ *
+ *		*th* points to the start of the TCP header, while *th_len*
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
+ *	Return
+ *		On success, lower 32 bits hold the generated SYN cookie in
+ *		followed by 16 bits which hold the MSS value for that cookie,
+ *		and the top 16 bits are unused.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** if the packet or input arguments are invalid.
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ *		**-EPROTONOSUPPORT** if the IP version is not 4 or 6 (or 6, but
+ *		CONFIG_IPV6 is disabled).
+ *
+ * int bpf_tcp_raw_check_syncookie(void *iph, u32 iph_len, struct tcphdr *th, u32 th_len)
+ *	Description
+ *		Check whether *iph* and *th* contain a valid SYN cookie ACK
+ *		without depending on a listening socket.
+ *
+ *		*iph* points to the start of the IPv4 or IPv6 header, while
+ *		*iph_len* contains **sizeof**\ (**struct iphdr**) or
+ *		**sizeof**\ (**struct ip6hdr**).
+ *
+ *		*th* points to the start of the TCP header, while *th_len*
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
+ *	Return
+ *		0 if *iph* and *th* are a valid SYN cookie ACK.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EACCES** if the SYN cookie is not valid.
+ *
+ *		**-EINVAL** if the packet or input arguments are invalid.
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ *		**-EPROTONOSUPPORT** if the IP version is not 4 or 6 (or 6, but
+ *		CONFIG_IPV6 is disabled).
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5283,6 +5338,8 @@ union bpf_attr {
 	FN(xdp_get_buff_len),		\
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
+	FN(tcp_raw_gen_syncookie),	\
+	FN(tcp_raw_check_syncookie),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 18559b5828a3..dc90d2649a7a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7375,6 +7375,124 @@ static const struct bpf_func_proto bpf_sock_ops_reserve_hdr_opt_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_4(bpf_tcp_raw_gen_syncookie, void *, iph, u32, iph_len,
+	   struct tcphdr *, th, u32, th_len)
+{
+#ifdef CONFIG_SYN_COOKIES
+	u32 cookie;
+	u16 mss;
+
+	if (unlikely(th_len < sizeof(*th) || th_len != th->doff * 4))
+		return -EINVAL;
+
+	if (!th->syn || th->ack || th->fin || th->rst)
+		return -EINVAL;
+
+	if (unlikely(iph_len < sizeof(struct iphdr)))
+		return -EINVAL;
+
+	/* Both struct iphdr and struct ipv6hdr have the version field at the
+	 * same offset so we can cast to the shorter header (struct iphdr).
+	 */
+	switch (((struct iphdr *)iph)->version) {
+	case 4:
+		mss = tcp_parse_mss_option(th, 0) ?: TCP_MSS_DEFAULT;
+		cookie = __cookie_v4_init_sequence(iph, th, &mss);
+		break;
+
+#if IS_BUILTIN(CONFIG_IPV6)
+	case 6: {
+		const u16 mss_clamp = IPV6_MIN_MTU - sizeof(struct tcphdr) - sizeof(struct ipv6hdr);
+
+		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
+			return -EINVAL;
+
+		mss = tcp_parse_mss_option(th, 0) ?: mss_clamp;
+		cookie = __cookie_v6_init_sequence(iph, th, &mss);
+		break;
+		}
+#endif /* CONFIG_IPV6 */
+
+	default:
+		return -EPROTONOSUPPORT;
+	}
+
+	return cookie | ((u64)mss << 32);
+#else
+	return -EOPNOTSUPP;
+#endif /* CONFIG_SYN_COOKIES */
+}
+
+static const struct bpf_func_proto bpf_tcp_raw_gen_syncookie_proto = {
+	.func		= bpf_tcp_raw_gen_syncookie,
+	.gpl_only	= true, /* __cookie_v*_init_sequence() is GPL */
+	.pkt_access	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_CONST_SIZE,
+	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_CONST_SIZE,
+};
+
+BPF_CALL_4(bpf_tcp_raw_check_syncookie, void *, iph, u32, iph_len,
+	   struct tcphdr *, th, u32, th_len)
+{
+#ifdef CONFIG_SYN_COOKIES
+	u32 cookie;
+	int ret;
+
+	if (unlikely(th_len < sizeof(*th)))
+		return -EINVAL;
+
+	if (!th->ack || th->rst || th->syn)
+		return -EINVAL;
+
+	if (unlikely(iph_len < sizeof(struct iphdr)))
+		return -EINVAL;
+
+	cookie = ntohl(th->ack_seq) - 1;
+
+	/* Both struct iphdr and struct ipv6hdr have the version field at the
+	 * same offset so we can cast to the shorter header (struct iphdr).
+	 */
+	switch (((struct iphdr *)iph)->version) {
+	case 4:
+		ret = __cookie_v4_check((struct iphdr *)iph, th, cookie);
+		break;
+
+#if IS_BUILTIN(CONFIG_IPV6)
+	case 6:
+		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
+			return -EINVAL;
+
+		ret = __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
+		break;
+#endif /* CONFIG_IPV6 */
+
+	default:
+		return -EPROTONOSUPPORT;
+	}
+
+	if (ret > 0)
+		return 0;
+
+	return -EACCES;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static const struct bpf_func_proto bpf_tcp_raw_check_syncookie_proto = {
+	.func		= bpf_tcp_raw_check_syncookie,
+	.gpl_only	= true, /* __cookie_v*_check is GPL */
+	.pkt_access	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_CONST_SIZE,
+	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_CONST_SIZE,
+};
+
 #endif /* CONFIG_INET */
 
 bool bpf_helper_changes_pkt_data(void *func)
@@ -7785,6 +7903,10 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_tcp_check_syncookie_proto;
 	case BPF_FUNC_tcp_gen_syncookie:
 		return &bpf_tcp_gen_syncookie_proto;
+	case BPF_FUNC_tcp_raw_gen_syncookie:
+		return &bpf_tcp_raw_gen_syncookie_proto;
+	case BPF_FUNC_tcp_raw_check_syncookie:
+		return &bpf_tcp_raw_check_syncookie_proto;
 #endif
 	default:
 		return bpf_sk_base_func_proto(func_id);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index dc49a3d551eb..a60f6aa44b02 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3961,7 +3961,7 @@ static bool smc_parse_options(const struct tcphdr *th,
 /* Try to parse the MSS option from the TCP header. Return 0 on failure, clamped
  * value on success.
  */
-static u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss)
+u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss)
 {
 	const unsigned char *ptr = (const unsigned char *)(th + 1);
 	int length = (th->doff * 4) - sizeof(struct tcphdr);
@@ -4000,6 +4000,7 @@ static u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss)
 	}
 	return mss;
 }
+EXPORT_SYMBOL_GPL(tcp_parse_mss_option);
 
 /* Look for tcp options. Normally only called on SYN and SYNACK packets.
  * But, this can also be called on packets in the established flow when
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4d2d4a09bf25..07864277297b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5090,6 +5090,61 @@ union bpf_attr {
  *		associated to *xdp_md*, at *offset*.
  *	Return
  *		0 on success, or a negative error in case of failure.
+ *
+ * s64 bpf_tcp_raw_gen_syncookie(void *iph, u32 iph_len, struct tcphdr *th, u32 th_len)
+ *	Description
+ *		Try to issue a SYN cookie for the packet with corresponding
+ *		IP/TCP headers, *iph* and *th*, without depending on a listening
+ *		socket.
+ *
+ *		*iph* points to the start of the IPv4 or IPv6 header, while
+ *		*iph_len* contains **sizeof**\ (**struct iphdr**) or
+ *		**sizeof**\ (**struct ip6hdr**).
+ *
+ *		*th* points to the start of the TCP header, while *th_len*
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
+ *	Return
+ *		On success, lower 32 bits hold the generated SYN cookie in
+ *		followed by 16 bits which hold the MSS value for that cookie,
+ *		and the top 16 bits are unused.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** if the packet or input arguments are invalid.
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ *		**-EPROTONOSUPPORT** if the IP version is not 4 or 6 (or 6, but
+ *		CONFIG_IPV6 is disabled).
+ *
+ * int bpf_tcp_raw_check_syncookie(void *iph, u32 iph_len, struct tcphdr *th, u32 th_len)
+ *	Description
+ *		Check whether *iph* and *th* contain a valid SYN cookie ACK
+ *		without depending on a listening socket.
+ *
+ *		*iph* points to the start of the IPv4 or IPv6 header, while
+ *		*iph_len* contains **sizeof**\ (**struct iphdr**) or
+ *		**sizeof**\ (**struct ip6hdr**).
+ *
+ *		*th* points to the start of the TCP header, while *th_len*
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
+ *	Return
+ *		0 if *iph* and *th* are a valid SYN cookie ACK.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EACCES** if the SYN cookie is not valid.
+ *
+ *		**-EINVAL** if the packet or input arguments are invalid.
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ *		**-EPROTONOSUPPORT** if the IP version is not 4 or 6 (or 6, but
+ *		CONFIG_IPV6 is disabled).
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5283,6 +5338,8 @@ union bpf_attr {
 	FN(xdp_get_buff_len),		\
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
+	FN(tcp_raw_gen_syncookie),	\
+	FN(tcp_raw_check_syncookie),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.30.2

