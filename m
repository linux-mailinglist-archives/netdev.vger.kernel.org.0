Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F544FF7F0
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbiDMNoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiDMNoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:44:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C945FF3E;
        Wed, 13 Apr 2022 06:42:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfW6T32MOWxatDR3LxBgfn8+awL+B8Ww2FOUant55my3ktmRVA9odgWxfotXFAO4orf5GxIt5rfnvgk6VqGp8C+hmHnn5G8zgyoBGIKvyupqgRhexVu90LvQaxaoDplr+EqS+E/Dx5Sf81jS0QHyOXtMRuVJ0WYMWWGX9ltSSh0qI5zDbL+T4UhdT37zM95mW6S7i+TFi0HmZfkedBHHPsHNnaqjS1LCDQX7Kx5yb7jECdCAhbXwEqNSABLk/LRS0mCtYFYBfRHa8pAIDchnpKBVD8OlqyaPre5aKN+XITx01krzLsx+kT8bfC6GdAoV3h3VM6mL+LmDJI/TsksRcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skFnDWtkHecdI9+j8t1TTCEhQ0+X4O2XlimM2zgeH5U=;
 b=EuRocdTHhyEBvNRjfLZPg5bDA2/KTC4wYtn2Pz7DvIpWpw7JbAtOeNWGPHCJDVh76PoaEgbYVib6UjlB8Bkilb4jyjqYNJceKRed+7OULg32u8SWSDCkMmkjN5AmoBLn2lxfX73J8fPsBlRBQkPkrKnOq5I3qAKgkjYo3SJ8RmhcqO/93ORYM0tEcxHFL+qW0TZfKvxtI0+nb8JxVdOdUfagZWsEor6Fqa/8TuIPrhO0nHox1jan8ZeX964+yeHPW2VQ6F/BeZlEfa5QR6keVyFvU4OUNBAR4dyboTyXhlkbpIrEl1KlpyO3e/7GJ2Kbchbqa9/aG1a7dFz/gGYc4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skFnDWtkHecdI9+j8t1TTCEhQ0+X4O2XlimM2zgeH5U=;
 b=S9OoMsiVuqZRJn/Zzk7IAdJCoUDRx6ZkY00gMMPlmr/ZyiHZ/mkxrcmNQDr39i/Znf3CHnYnEghNkZM6+8vnlH02fiTtz2JVd+ht9WfoNktzWOjHYMWEK1lFkbwlJkEu+7zZjCq9d1IoqeVxIi832+LKrHPQSWpDgyOXzK5fwZzVUdpwQ/0eEVS8h0MAiiBeLOFRllxg4QNnkD9suWWt2YCeY5I9TviiOybOzwM2yYJzBq8TtkbF4/gQU83oMyUwLJu996Ous69v1z0INmYnJWarP/GgOcJkNCfwrdFTxxF9TttUO+0g2wmF2m9CNtB6rtYsK60UYLzYH8d2s54hrg==
Received: from MW4PR03CA0170.namprd03.prod.outlook.com (2603:10b6:303:8d::25)
 by BL0PR12MB5521.namprd12.prod.outlook.com (2603:10b6:208:1c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Wed, 13 Apr
 2022 13:42:06 +0000
Received: from CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::30) by MW4PR03CA0170.outlook.office365.com
 (2603:10b6:303:8d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Wed, 13 Apr 2022 13:42:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 13:42:05 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Apr
 2022 13:42:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 13 Apr
 2022 06:42:04 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 13 Apr
 2022 06:41:57 -0700
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
Subject: [PATCH bpf-next v5 4/6] bpf: Add helpers to issue and check SYN cookies in XDP
Date:   Wed, 13 Apr 2022 16:41:18 +0300
Message-ID: <20220413134120.3253433-5-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413134120.3253433-1-maximmi@nvidia.com>
References: <20220413134120.3253433-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39609ddc-cce0-455e-4cfb-08da1d53663f
X-MS-TrafficTypeDiagnostic: BL0PR12MB5521:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB552132FA9B1261A457A3E3DBDCEC9@BL0PR12MB5521.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2MMYzF4hCNjR9oPoYbdlrrzeLyqWNfc79TgVRWoS5+H/a9n2A+wUfhakXMr0HZ7SkndDARnCriI/wo9SfZjwJ2No3N2dbuas+jHz57kdaceWF6mflKtKGEav1c35/8C9a8TXwNRhnizq4KeHmpkxS2AQyr9n3HeFaI+UIoHiHCUPyJOHtPYqWJ8W/Rc10QqWAsUUOfiowhNnqAuymlj2YqEkAX+ptIlqMOREQPSmktjF8obN2hOcO6e6ZQcPCCOIqFCxDnm/BiJYAAxGCcaNYLIfoLmlIDT3i40OvV03FvCLk9IvFGVUNVIs4JMXe8UppD92JYv+17r2C09VbPIv2Cmurk80y4GoXTtgg6aySne2M7aYF8qsJ+yincBDYfg2EvoGSAUN7h0FjYNUA3FL2jYURHuWhH/yq/Ml8RmtTmc9gF7/d8LIZJPVf0pu3OWywlSgDRn9ov+tvoHeVTobV75GTuJA0NEytSuJXOFCtFqaYk1+1DyBWQTm2z4z66fWBuZFo5XPVCjyQ1P0VA0DVGmcreFcIRwtcGemOG8Ml56trYgCJ/4uRc6owyDa2stj22lQrC7poiuMqhD+iIG7pl2Z01CLZPyBbo/FkFc0hPfX4BzwVVpT7ltmg4A+2J6bl+RK/F6gKPHfL/V4SXvcN8z0hNGWFXY33MfMvLttmFvyhQ2scF95OoGVd1ylTC7YUrLTKADqJbB28X03PzyxBw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(81166007)(40460700003)(7696005)(8676002)(4326008)(70206006)(8936002)(356005)(26005)(83380400001)(110136005)(107886003)(186003)(6666004)(2616005)(1076003)(36756003)(47076005)(54906003)(426003)(336012)(316002)(36860700001)(2906002)(70586007)(82310400005)(30864003)(508600001)(5660300002)(7416002)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 13:42:05.9855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39609ddc-cce0-455e-4cfb-08da1d53663f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5521
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
index d486d7b6112d..1e34eb776888 100644
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
index 5e1679af8282..65665d0ec217 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5145,6 +5145,92 @@ union bpf_attr {
  *		The **hash_algo** is returned on success,
  *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
  *		invalid arguments are passed.
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
@@ -5341,6 +5427,10 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
+	FN(tcp_raw_gen_syncookie_ipv4),	\
+	FN(tcp_raw_gen_syncookie_ipv6),	\
+	FN(tcp_raw_check_syncookie_ipv4),	\
+	FN(tcp_raw_check_syncookie_ipv6),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 7446b0ba4e38..428cc63ecdf7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7425,6 +7425,124 @@ static const struct bpf_func_proto bpf_skb_set_tstamp_proto = {
 	.arg3_type      = ARG_ANYTHING,
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
@@ -7837,6 +7955,14 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
index 2088f93fa37b..3682ee405eb7 100644
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
index 6ca3c017a664..167a08605d51 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5145,6 +5145,92 @@ union bpf_attr {
  *		The **hash_algo** is returned on success,
  *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
  *		invalid arguments are passed.
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
@@ -5341,6 +5427,10 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
+	FN(tcp_raw_gen_syncookie_ipv4),	\
+	FN(tcp_raw_gen_syncookie_ipv6),	\
+	FN(tcp_raw_check_syncookie_ipv4),	\
+	FN(tcp_raw_check_syncookie_ipv6),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.30.2

