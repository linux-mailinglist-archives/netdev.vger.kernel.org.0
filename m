Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0991C4C2F1D
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbiBXPNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235719AbiBXPNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:13:30 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2062.outbound.protection.outlook.com [40.107.101.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497F820A38B;
        Thu, 24 Feb 2022 07:12:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQ1MVXeGLh1zUSDmOuRErX8ZPaY9hcFEZXCYTBWFECO1BrPjuwM0X483YBBm+kfovr38VWIDKsRgNLIeBKHv6zYxnof+8aIE1inPwRSaiCn4KvriIZ4GvJlbjSxqXzvclXyJjRRJsirNFVGHNRU3AIcuCg0m/g0hDH9nXF39chNOTl1rZg67Dw7XZIn4KaihKG8xkRD6YrSW1TUwapOBvIVT2dwUAH1MFWHEGp+Mq3Z5V41QnVlrpxk+KcO5Z816/T07kCWBbqqyejEr/Y2rXm58kh0KBLP6aobhnM+ArS/edeOtcyZuSz8P2dsLZywPJ3mz5WXzKvy1aJRGBO2NFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bh7qzyZKmfnp/GWP7NINzxb/5ZcuqgVneDZW0H42LM=;
 b=WBwM0HbRYQN3VtoXA2WRRdzo9CXdYnL4fb9Tcnt4NJxT7rWcfQ5tzHk1aSP7npOn59YX3XcUD7leux/t0oh6PyNgZ9nCSzj5lZdhTg/m4FJytZUngqGD8SmZcdffD8pmqV6bhPULJz5DK3sPumssCIT/mHKyYqZ9sDJTFc2gMXzrcwXTy7VEdgId3o3WsGDhKdozPumSqAjzFVG0DrsK/JLMIvOSYZcw9UERpD+dq7lCFiiBL1JAZa+2OkqYrYmgmQOZkq8lZDX7Ed9EQs6HsT2CRiOzDKe+pzjq9kftxvpNkM0gfJvEU7nLZ1N2YWzZ4gXOX1HJyzyR0qBJ3l/ycQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bh7qzyZKmfnp/GWP7NINzxb/5ZcuqgVneDZW0H42LM=;
 b=WULAJ8hXZXe+88K+NHVMsaFNhifmOcReC1J4CQg/IIce8B/qb+H9yEK1BidRumKHIe+3Ppbht/onMakEfS2grWhR9LjTX8GfWFC30+7ylZU5rJpppOnUMDcZr57lwGDbZjwM26CawNANtbsZRhsGumFpCBevOVbT4L6txB+jO72B0GKyv9bOLizW9f6/epBmm2L0pBL7nsgfmKeVXE9/P64QusxfxEhir0do9AREugJ6M0MJ4wZAjhguX/MUccgJFbFPS3sBdig+cKvr7QZA7z9yz9thgH4H+bsBQZzJ/6/3ej2QBemc7aNNb9Lf+f+PGk2lcbS8VqTzWRII9cYYTA==
Received: from MWHPR07CA0022.namprd07.prod.outlook.com (2603:10b6:300:116::32)
 by MWHPR1201MB0255.namprd12.prod.outlook.com (2603:10b6:301:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 15:12:57 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:116:cafe::d2) by MWHPR07CA0022.outlook.office365.com
 (2603:10b6:300:116::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Thu, 24 Feb 2022 15:12:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 15:12:57 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 15:12:56 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 07:12:54 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 07:12:47 -0800
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
Subject: [PATCH bpf-next v3 4/5] bpf: Add helpers to issue and check SYN cookies in XDP
Date:   Thu, 24 Feb 2022 17:11:44 +0200
Message-ID: <20220224151145.355355-5-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220224151145.355355-1-maximmi@nvidia.com>
References: <20220224151145.355355-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65175e82-de9e-4480-d5e3-08d9f7a8237c
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0255:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0255884481D82C26FCE7BED4DC3D9@MWHPR1201MB0255.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QIIPwbuiLzia0MFJVN/2cKJ/KkVLfQOhGvNZ4vvk8deqEgGIPDI7usPav2pHZUV240mZrrfExTbfZttN7XLk3Z3jnVTbuLQQQNata4OjFxm72roh2F7vErdF33s3CPqsyiQOqFsbY+3tr1V7LMELXYQwwitfPc7Uypa+hmkhAn1EWkqwNi4FibHBAw3PohXr5C2Mu5A0edYqYOOVOTXgMwPAJPOpbdMKBPGRfFLhMz4R/B9tgEyBftTdNECksVY2mAzkxzmtVNuce6nuYrAJLVeF7s9Mzzz+N5pXiKDs3TRhkH/HtNCi4x1nhX6zZd5+QYV3Sn3U/ow0Y1+OqwBX9MevU50uXiUoflKI3H6q3Z4a76Z8N1YVZJMcJricvRdrH9ojTstMxPzsSWxSWSDhBTBHr/frZMYM02dN6uaAdvG385Zwk4axQfkXBOD+aHCQYKfeHazGp+goFdaNO20mm4Xcw3AmcjweSnOEkQ6caq9rw+LfkJZz+kO5GWdp5rfQzEO64BDXSyihz7F66s8pdZV7ItuhDM13HjLO3UuMHsgG5UsBe2eu1H6Ha2EbcTUWaGvcmPICcc62kzkheTbMLiJrSWruETECjc/zffVeCoIgp5sN+4OZShtfX061FgEguaVTad6fBXiRWzyeW6UEpJGswYBjxCVPYn9QKlVMev8LgJNSFMNccUn5/E7AjPTyPP3dTOtUTL1s4csIX8vvsg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(2906002)(7696005)(508600001)(316002)(47076005)(54906003)(36860700001)(26005)(186003)(110136005)(83380400001)(36756003)(336012)(426003)(70586007)(82310400004)(356005)(107886003)(2616005)(81166007)(86362001)(5660300002)(6666004)(8936002)(7416002)(8676002)(40460700003)(70206006)(30864003)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 15:12:57.0179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65175e82-de9e-4480-d5e3-08d9f7a8237c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0255
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new helpers bpf_tcp_raw_{gen,check}_syncookie_ipv{4,6} allow an XDP
program to generate SYN cookies in response to TCP SYN packets and to
check those cookies upon receiving the first ACK packet (the final
packet of the TCP handshake).

Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
listening socket on the local machine, which allows to use them together
with synproxy to accelerate SYN cookie generation.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/net/tcp.h              |   1 +
 include/uapi/linux/bpf.h       |  90 +++++++++++++++++++++++
 net/core/filter.c              | 126 +++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c           |   3 +-
 scripts/bpf_doc.py             |   4 ++
 tools/include/uapi/linux/bpf.h |  90 +++++++++++++++++++++++
 6 files changed, 313 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index eff2487d972d..0af13663ae73 100644
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
index 1b933454bbb5..a9a56d555cfb 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5088,6 +5088,92 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure. On error
  *		*dst* buffer is zeroed out.
+ *
+ * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th, u32 th_len)
+ *	Description
+ *		Try to issue a SYN cookie for the packet with corresponding
+ *		IPv4/TCP headers, *iph* and *th*, without depending on a
+ *		listening socket.
+ *
+ *		*iph* points to the IPv4 header.
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
+ *		**-EINVAL** if *th_len* is invalid.
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ * s64 bpf_tcp_raw_gen_syncookie_ipv6(struct ipv6hdr *iph, struct tcphdr *th, u32 th_len)
+ *	Description
+ *		Try to issue a SYN cookie for the packet with corresponding
+ *		IPv6/TCP headers, *iph* and *th*, without depending on a
+ *		listening socket.
+ *
+ *		*iph* points to the IPv6 header.
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
+ *		**-EINVAL** if *th_len* is invalid.
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
+ *
+ * int bpf_tcp_raw_check_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th)
+ *	Description
+ *		Check whether *iph* and *th* contain a valid SYN cookie ACK
+ *		without depending on a listening socket.
+ *
+ *		*iph* points to the IPv4 header.
+ *
+ *		*th* points to the TCP header.
+ *	Return
+ *		0 if *iph* and *th* are a valid SYN cookie ACK.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EACCES** if the SYN cookie is not valid.
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ * int bpf_tcp_raw_check_syncookie_ipv6(struct ipv6hdr *iph, struct tcphdr *th)
+ *	Description
+ *		Check whether *iph* and *th* contain a valid SYN cookie ACK
+ *		without depending on a listening socket.
+ *
+ *		*iph* points to the IPv6 header.
+ *
+ *		*th* points to the TCP header.
+ *	Return
+ *		0 if *iph* and *th* are a valid SYN cookie ACK.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EACCES** if the SYN cookie is not valid.
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5282,6 +5368,10 @@ union bpf_attr {
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
 	FN(copy_from_user_task),	\
+	FN(tcp_raw_gen_syncookie_ipv4),	\
+	FN(tcp_raw_gen_syncookie_ipv6),	\
+	FN(tcp_raw_check_syncookie_ipv4),	\
+	FN(tcp_raw_check_syncookie_ipv6),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 0edbfdc8cb24..76426a87225c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7388,6 +7388,124 @@ static const struct bpf_func_proto bpf_sock_ops_reserve_hdr_opt_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_3(bpf_tcp_raw_gen_syncookie_ipv4, struct iphdr *, iph,
+	   struct tcphdr *, th, u32, th_len)
+{
+#ifdef CONFIG_SYN_COOKIES
+	u32 cookie;
+	u16 mss;
+
+	if (unlikely(th_len < sizeof(*th) || th_len != th->doff * 4))
+		return -EINVAL;
+
+	mss = tcp_parse_mss_option(th, 0) ?: TCP_MSS_DEFAULT;
+	cookie = __cookie_v4_init_sequence(iph, th, &mss);
+
+	return cookie | ((u64)mss << 32);
+#else
+	return -EOPNOTSUPP;
+#endif /* CONFIG_SYN_COOKIES */
+}
+
+static const struct bpf_func_proto bpf_tcp_raw_gen_syncookie_ipv4_proto = {
+	.func		= bpf_tcp_raw_gen_syncookie_ipv4,
+	.gpl_only	= true, /* __cookie_v4_init_sequence() is GPL */
+	.pkt_access	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_size	= sizeof(struct iphdr),
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+};
+
+BPF_CALL_3(bpf_tcp_raw_gen_syncookie_ipv6, struct ipv6hdr *, iph,
+	   struct tcphdr *, th, u32, th_len)
+{
+#ifndef CONFIG_SYN_COOKIES
+	return -EOPNOTSUPP;
+#elif !IS_BUILTIN(CONFIG_IPV6)
+	return -EPROTONOSUPPORT;
+#else
+	const u16 mss_clamp = IPV6_MIN_MTU - sizeof(struct tcphdr) -
+		sizeof(struct ipv6hdr);
+	u32 cookie;
+	u16 mss;
+
+	if (unlikely(th_len < sizeof(*th) || th_len != th->doff * 4))
+		return -EINVAL;
+
+	mss = tcp_parse_mss_option(th, 0) ?: mss_clamp;
+	cookie = __cookie_v6_init_sequence(iph, th, &mss);
+
+	return cookie | ((u64)mss << 32);
+#endif
+}
+
+static const struct bpf_func_proto bpf_tcp_raw_gen_syncookie_ipv6_proto = {
+	.func		= bpf_tcp_raw_gen_syncookie_ipv6,
+	.gpl_only	= true, /* __cookie_v6_init_sequence() is GPL */
+	.pkt_access	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_size	= sizeof(struct ipv6hdr),
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+};
+
+BPF_CALL_2(bpf_tcp_raw_check_syncookie_ipv4, struct iphdr *, iph,
+	   struct tcphdr *, th)
+{
+#ifdef CONFIG_SYN_COOKIES
+	u32 cookie = ntohl(th->ack_seq) - 1;
+
+	if (__cookie_v4_check(iph, th, cookie) > 0)
+		return 0;
+
+	return -EACCES;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static const struct bpf_func_proto bpf_tcp_raw_check_syncookie_ipv4_proto = {
+	.func		= bpf_tcp_raw_check_syncookie_ipv4,
+	.gpl_only	= true, /* __cookie_v4_check is GPL */
+	.pkt_access	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_size	= sizeof(struct iphdr),
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_size	= sizeof(struct tcphdr),
+};
+
+BPF_CALL_2(bpf_tcp_raw_check_syncookie_ipv6, struct ipv6hdr *, iph,
+	   struct tcphdr *, th)
+{
+#ifndef CONFIG_SYN_COOKIES
+	return -EOPNOTSUPP;
+#elif !IS_BUILTIN(CONFIG_IPV6)
+	return -EPROTONOSUPPORT;
+#else
+	u32 cookie = ntohl(th->ack_seq) - 1;
+
+	if (__cookie_v6_check(iph, th, cookie) > 0)
+		return 0;
+
+	return -EACCES;
+#endif
+}
+
+static const struct bpf_func_proto bpf_tcp_raw_check_syncookie_ipv6_proto = {
+	.func		= bpf_tcp_raw_check_syncookie_ipv6,
+	.gpl_only	= true, /* __cookie_v6_check is GPL */
+	.pkt_access	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_size	= sizeof(struct ipv6hdr),
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_size	= sizeof(struct tcphdr),
+};
+
 #endif /* CONFIG_INET */
 
 bool bpf_helper_changes_pkt_data(void *func)
@@ -7798,6 +7916,14 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_tcp_check_syncookie_proto;
 	case BPF_FUNC_tcp_gen_syncookie:
 		return &bpf_tcp_gen_syncookie_proto;
+	case BPF_FUNC_tcp_raw_gen_syncookie_ipv4:
+		return &bpf_tcp_raw_gen_syncookie_ipv4_proto;
+	case BPF_FUNC_tcp_raw_gen_syncookie_ipv6:
+		return &bpf_tcp_raw_gen_syncookie_ipv6_proto;
+	case BPF_FUNC_tcp_raw_check_syncookie_ipv4:
+		return &bpf_tcp_raw_check_syncookie_ipv4_proto;
+	case BPF_FUNC_tcp_raw_check_syncookie_ipv6:
+		return &bpf_tcp_raw_check_syncookie_ipv6_proto;
 #endif
 	default:
 		return bpf_sk_base_func_proto(func_id);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 92e65d56dc2c..ea8a78d52e25 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3963,7 +3963,7 @@ static bool smc_parse_options(const struct tcphdr *th,
 /* Try to parse the MSS option from the TCP header. Return 0 on failure, clamped
  * value on success.
  */
-static u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss)
+u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss)
 {
 	const unsigned char *ptr = (const unsigned char *)(th + 1);
 	int length = (th->doff * 4) - sizeof(struct tcphdr);
@@ -4002,6 +4002,7 @@ static u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss)
 	}
 	return mss;
 }
+EXPORT_SYMBOL_GPL(tcp_parse_mss_option);
 
 /* Look for tcp options. Normally only called on SYN and SYNACK packets.
  * But, this can also be called on packets in the established flow when
diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index 096625242475..3d0b65e6dea7 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -633,6 +633,8 @@ class PrinterHelpers(Printer):
             'struct socket',
             'struct file',
             'struct bpf_timer',
+            'struct iphdr',
+            'struct ipv6hdr',
     ]
     known_types = {
             '...',
@@ -682,6 +684,8 @@ class PrinterHelpers(Printer):
             'struct socket',
             'struct file',
             'struct bpf_timer',
+            'struct iphdr',
+            'struct ipv6hdr',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1b933454bbb5..a9a56d555cfb 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5088,6 +5088,92 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure. On error
  *		*dst* buffer is zeroed out.
+ *
+ * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th, u32 th_len)
+ *	Description
+ *		Try to issue a SYN cookie for the packet with corresponding
+ *		IPv4/TCP headers, *iph* and *th*, without depending on a
+ *		listening socket.
+ *
+ *		*iph* points to the IPv4 header.
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
+ *		**-EINVAL** if *th_len* is invalid.
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ * s64 bpf_tcp_raw_gen_syncookie_ipv6(struct ipv6hdr *iph, struct tcphdr *th, u32 th_len)
+ *	Description
+ *		Try to issue a SYN cookie for the packet with corresponding
+ *		IPv6/TCP headers, *iph* and *th*, without depending on a
+ *		listening socket.
+ *
+ *		*iph* points to the IPv6 header.
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
+ *		**-EINVAL** if *th_len* is invalid.
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
+ *
+ * int bpf_tcp_raw_check_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th)
+ *	Description
+ *		Check whether *iph* and *th* contain a valid SYN cookie ACK
+ *		without depending on a listening socket.
+ *
+ *		*iph* points to the IPv4 header.
+ *
+ *		*th* points to the TCP header.
+ *	Return
+ *		0 if *iph* and *th* are a valid SYN cookie ACK.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EACCES** if the SYN cookie is not valid.
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ * int bpf_tcp_raw_check_syncookie_ipv6(struct ipv6hdr *iph, struct tcphdr *th)
+ *	Description
+ *		Check whether *iph* and *th* contain a valid SYN cookie ACK
+ *		without depending on a listening socket.
+ *
+ *		*iph* points to the IPv6 header.
+ *
+ *		*th* points to the TCP header.
+ *	Return
+ *		0 if *iph* and *th* are a valid SYN cookie ACK.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EACCES** if the SYN cookie is not valid.
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5282,6 +5368,10 @@ union bpf_attr {
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
 	FN(copy_from_user_task),	\
+	FN(tcp_raw_gen_syncookie_ipv4),	\
+	FN(tcp_raw_gen_syncookie_ipv6),	\
+	FN(tcp_raw_check_syncookie_ipv4),	\
+	FN(tcp_raw_check_syncookie_ipv6),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.30.2

