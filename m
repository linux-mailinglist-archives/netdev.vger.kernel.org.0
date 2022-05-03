Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0510518ADA
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 19:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240185AbiECRSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 13:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240198AbiECRSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 13:18:49 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F146D6267;
        Tue,  3 May 2022 10:15:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWKFmO8IuwJ/qwG03LVW9jiJC6dNcX8WM2cmTNbjyCamew0cNR8H4KpzhEjxJHXGHdpYJ+agTh24e0ZMJjo1KIqYwtOQEtt2/vXhnlxHvMeVGhT/IB1UTrYSM1AstLmuqZSgOWyTL0tWZtKVasNUchvmeFpSJAx7YI9T/YtVBlRjGhqAIFdJ4hXm0+gnX3ljW2RuqbOyvajrTb4wVNclFkj8NVa8StXwqMP5j1gbVBIVUQMWtAiU3kmcvY/vpeqFD9TCrUQKXkUtKoIh1fv0sVPGPUu8F2V6twrTSoN7Q/gJh/Zp7tjmHUy0/tXAY8nL1p4Amx9qjHnrqgOWubHWhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVv5o6JX++H7RK+k4XrrrkXEnNVthlidhGWsuU/O1jU=;
 b=cY0JG2gjBg4Ti+9PTcdZfNOF0JZHIYOBn2CVoClECiVTAL+DeR1jRSZhF2yrQroSooSChhqU96uslry9MbuD3Ao3jWyWmBmMzQ9EuKIqUO5W3LvymFeCGgln5Fl1dyjjdVl9IT/ZafyJQvH3EkBbSRzRVSYAfqb0akySMod+s6HHUEMkMZsmWbfKzNIdqIPFR4HGJHefSyrFa5Af7ohdKZOT8ArdVXlAkMg5rJP698JcudNwz8gYuVU4rnqhq7H4LGswbSiB0mfTdRUMjbp+uBZSwFPT8s7qUVNktaU53iRwjihcHBXmn05xvHyCdSp5vVjH6igBk/3xKxooDuiDjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVv5o6JX++H7RK+k4XrrrkXEnNVthlidhGWsuU/O1jU=;
 b=Wn25PDWe67B7rBgFVjKpHwNogwVPtUSYEI+/7xy4z/h+ZsjrHGpD4X+ilWhTICz6jraPvWW3WknMw6kqMbpY0hZMLErQ5QVVDMR+smqNiOJwYwVEj2Zon4NgH0yetWEv44zVmkyfj2QbaUVNvEMAEzKPtbYD7bkK9mV34hrwEirahuw2MEDNBoqOgyIJ9X4oCAIlT8NfKYRMFsMVwfDtsCAAbXPg35RapBl6HJ2SrG1E+rELzibvTcAqMyNmME4LZWQlJk+HBUlFkjupMomiJ+JckvGbYJoOZXF2OzENHtbPWJ+PYxNNW7LLMMhRRAulLX9vFrOP7hpeWBz6g/YIAw==
Received: from BN7PR06CA0060.namprd06.prod.outlook.com (2603:10b6:408:34::37)
 by SJ0PR12MB5408.namprd12.prod.outlook.com (2603:10b6:a03:305::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 17:15:12 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::b8) by BN7PR06CA0060.outlook.office365.com
 (2603:10b6:408:34::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12 via Frontend
 Transport; Tue, 3 May 2022 17:15:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Tue, 3 May 2022 17:15:10 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 3 May
 2022 17:15:09 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 3 May 2022
 10:15:09 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 3 May
 2022 10:15:02 -0700
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
        Florian Westphal <fw@strlen.de>, <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf-next v9 3/5] bpf: Add helpers to issue and check SYN cookies in XDP
Date:   Tue, 3 May 2022 20:14:35 +0300
Message-ID: <20220503171437.666326-4-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503171437.666326-1-maximmi@nvidia.com>
References: <20220503171437.666326-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5835962-b50d-403c-69d1-08da2d287ada
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5408:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB540899B6B4F904A53504579FDCC09@SJ0PR12MB5408.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JK3lXR06xSY1PbzjuhP3dlHY91MXmgZFc0GSaUqJHRfZSRSCT3Qz8yofuNLDS57cr6Bh+XTzp6CagYCOjqGoJAQY8sZJOmrrgssYTIbh5X3b9w4hT3hHvbNb9QHIu82iZJ80OD+qqmAQJuRPoPxP6bj+hzMvLWQR0itHdlBOYKK0WxWFWIQrGDW+HZ4cRjnC24CWzQUbVzAKgAFePitVn2R/v3Ipes8kO1t7lIYqMxLXa5XggDOtLzmCeac65QYc79UcBXWhA4lHlSPIUD4KUmaaD3SKB8jzIMhRj2RXdksX19Tv6CsGmNrs3GvMUiAwKJ3/R3g5Qx2lrcyjhfNYcfCM8AXlK4XeBZGHJ0QVdhH7/qHgb056lXWhS0yAx5v7XP8OSECSQ34br7/gpKyGbO30UgtIOhAV6hoUyDRtNC+q3P0N0ePMnTUtC95V03FJCFr62XujNHVMQJpOCJoZ1YbMp28a8dNM0XV8PxXVGrEc4Bo96GJ8mduZHY4Qj03NPUylqV6QJZWdFEm9t6e5NgjiQSEbAEBkbFPyZBgz+QSvKpUSzu5yVKf3gJItgI3L1/JOYNtIJrFEEBdzvXnWF00K8jdhIFL05wbuNkyLByVVYugvK2GTtDb5pdRzQITkAEmYoWRuZE0UH+TS3wJWa6gcVVx5USlPQI809EJnvpvVcc0DtNHwfqpLbSgKRhUX1/Me86fIg1taOA0RHlBTzg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(70206006)(4326008)(8676002)(70586007)(316002)(5660300002)(83380400001)(8936002)(54906003)(110136005)(508600001)(36756003)(82310400005)(2906002)(7416002)(30864003)(86362001)(36860700001)(26005)(7696005)(6666004)(1076003)(107886003)(40460700003)(47076005)(336012)(2616005)(186003)(426003)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 17:15:10.6922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5835962-b50d-403c-69d1-08da2d287ada
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5408
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 include/uapi/linux/bpf.h       |  78 ++++++++++++++++++++++
 net/core/filter.c              | 118 +++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c           |   3 +-
 scripts/bpf_doc.py             |   4 ++
 tools/include/uapi/linux/bpf.h |  78 ++++++++++++++++++++++
 6 files changed, 281 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 94a52ad1101c..45aafc28ce00 100644
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
index 4dd9e34f2a60..5e611d898302 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5156,6 +5156,80 @@ union bpf_attr {
  *		if not NULL, is a reference which must be released using its
  *		corresponding release function, or moved into a BPF map before
  *		program exit.
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
+ *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5353,6 +5427,10 @@ union bpf_attr {
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
 	FN(kptr_xchg),			\
+	FN(tcp_raw_gen_syncookie_ipv4),	\
+	FN(tcp_raw_gen_syncookie_ipv6),	\
+	FN(tcp_raw_check_syncookie_ipv4),	\
+	FN(tcp_raw_check_syncookie_ipv6),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index b741b9f7e6a9..7efeee6c7624 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7434,6 +7434,114 @@ static const struct bpf_func_proto bpf_skb_set_tstamp_proto = {
 	.arg3_type      = ARG_ANYTHING,
 };
 
+#ifdef CONFIG_SYN_COOKIES
+BPF_CALL_3(bpf_tcp_raw_gen_syncookie_ipv4, struct iphdr *, iph,
+	   struct tcphdr *, th, u32, th_len)
+{
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
+#if IS_BUILTIN(CONFIG_IPV6)
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
+#else
+	return -EPROTONOSUPPORT;
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
+	u32 cookie = ntohl(th->ack_seq) - 1;
+
+	if (__cookie_v4_check(iph, th, cookie) > 0)
+		return 0;
+
+	return -EACCES;
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
+#if IS_BUILTIN(CONFIG_IPV6)
+	u32 cookie = ntohl(th->ack_seq) - 1;
+
+	if (__cookie_v6_check(iph, th, cookie) > 0)
+		return 0;
+
+	return -EACCES;
+#else
+	return -EPROTONOSUPPORT;
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
+#endif /* CONFIG_SYN_COOKIES */
+
 #endif /* CONFIG_INET */
 
 bool bpf_helper_changes_pkt_data(void *func)
@@ -7846,6 +7954,16 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_tcp_check_syncookie_proto;
 	case BPF_FUNC_tcp_gen_syncookie:
 		return &bpf_tcp_gen_syncookie_proto;
+#ifdef CONFIG_SYN_COOKIES
+	case BPF_FUNC_tcp_raw_gen_syncookie_ipv4:
+		return &bpf_tcp_raw_gen_syncookie_ipv4_proto;
+	case BPF_FUNC_tcp_raw_gen_syncookie_ipv6:
+		return &bpf_tcp_raw_gen_syncookie_ipv6_proto;
+	case BPF_FUNC_tcp_raw_check_syncookie_ipv4:
+		return &bpf_tcp_raw_check_syncookie_ipv4_proto;
+	case BPF_FUNC_tcp_raw_check_syncookie_ipv6:
+		return &bpf_tcp_raw_check_syncookie_ipv6_proto;
+#endif
 #endif
 	default:
 		return bpf_sk_base_func_proto(func_id);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index daff631b9486..1eca6be492c8 100644
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
index 4dd9e34f2a60..5e611d898302 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5156,6 +5156,80 @@ union bpf_attr {
  *		if not NULL, is a reference which must be released using its
  *		corresponding release function, or moved into a BPF map before
  *		program exit.
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
+ *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5353,6 +5427,10 @@ union bpf_attr {
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
 	FN(kptr_xchg),			\
+	FN(tcp_raw_gen_syncookie_ipv4),	\
+	FN(tcp_raw_gen_syncookie_ipv6),	\
+	FN(tcp_raw_check_syncookie_ipv4),	\
+	FN(tcp_raw_check_syncookie_ipv6),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.30.2

