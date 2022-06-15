Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31AD354CA3B
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 15:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349194AbiFONt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 09:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348896AbiFONtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 09:49:25 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CFE3AA60;
        Wed, 15 Jun 2022 06:49:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=da0V2HU5Jg0YXpHZv0LGh22l8OoxjRiRr10ehXp7JmiJo+QINFQlfXHfakDraF6dFE4gRXF2wKufXg/rQGlQf2ZP71Ha8axdje8xKN1S5/M9bTrJuH6L5/9/DSru7/QCMc2j7mgWtYUQ+VhSHy/LaZ0AmJA4PfMMF4dvyqbnf13voR+24a+KKbawMC5rsl7Pe5dhjBsmpcIdscPsSRVokVs9KNy26AQp6Kq6CefiAb88AEAqXhWPWxtxBVdnKZJ0ndMUH0+EKsKJAiXrVL7qOVtBDdn89RaOEHLtJmNWzr9vsH/1XzdoBanUFN73Ohxh466gaM5slIhuu7JJkMMCqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dRQn8gcaLRp4lW4TEtcWFhRs4fi5aCeSIYUt+/WFdW4=;
 b=RMyZQzmTmbJSFsUy53q6GVfxNo4yh4RCm9TAf7e9SggoHibVDmy8kkDMPNJexo2hmrG54miGZrBZCxIw+ptZ1gGNpgl/lNCHzRZCLBcykUYahPuEjP1y6+D2phC5VzSmC2hJYaeARu5GY3+zOCM5c4/7q5gCOXjkgMNfeG6w2cv/Ya4TNf72ecJdBLRbdAyzGJc/Ph2wUKhIViiey+U4AaQOQSmR3nzQNuMuqYxy2yP1wmaXpFkSV3mrSBDXY/btXW8ykZFQFCj57h9DT/c9LkITullJ77ObGzebuesVHvpvoM46+T/vr3xx24ejt+e4c8KWQTxGE0SH3hPkywq0Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dRQn8gcaLRp4lW4TEtcWFhRs4fi5aCeSIYUt+/WFdW4=;
 b=hfVhnC+Go3O7D2bFYM5nzbFiCx+A+HtZZDVx6+enN3Uhq2AR8AE1yMV8N4n6vUVtbSTvrtxcsw70pOdgDle9tTA9vxC7iMD5i/BxjCOIYLr70URkDDmUjxCwyLpU2HHWULm63H/Gbbc4OGcaofQmYk4ueRdzpoTI8rpf8zAO5sN6g+X4mPjZ7Iy5sCldv6Zp4xf5t9FOUyZSVXF5qLtwoJO/8MsxVwuY7Gp8DaQMagMkTVhHFAJ7EytxWPTJ18bS71KsSUYa+kPGiIPooOkM9oi0cFnExLr6ea9HUUHGEIdM2IYWBVtT4Y9Hfi19visdbMeSMKtgMFcSpU0frkUSlw==
Received: from BN9PR03CA0482.namprd03.prod.outlook.com (2603:10b6:408:130::7)
 by BN6PR12MB1603.namprd12.prod.outlook.com (2603:10b6:405:b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.19; Wed, 15 Jun
 2022 13:49:21 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::5f) by BN9PR03CA0482.outlook.office365.com
 (2603:10b6:408:130::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Wed, 15 Jun 2022 13:49:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 13:49:20 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 15 Jun 2022 13:49:20 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 15 Jun 2022 06:49:19 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 15 Jun 2022 06:49:13 -0700
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
Subject: [PATCH bpf-next v10 3/6] bpf: Add helpers to issue and check SYN cookies in XDP
Date:   Wed, 15 Jun 2022 16:48:44 +0300
Message-ID: <20220615134847.3753567-4-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220615134847.3753567-1-maximmi@nvidia.com>
References: <20220615134847.3753567-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53edf484-c23b-4449-9648-08da4ed5d99f
X-MS-TrafficTypeDiagnostic: BN6PR12MB1603:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1603EC00C26287176E13A7AADCAD9@BN6PR12MB1603.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tjkDF05Ur1g9GvKu0hjuMYZ92bJ83MBvjjphjZf0PQWvpVmUhliFKKkl9nsFo8BU/cam8ObDOrTmNv8xhDcfiwO4LYu+jPywgCTZfF/KqCdZNVY4ozGEtIBdEtmUucsMVMZ51qfn3v4QVbW6l3kGQCAFkNj/Yxd2YXLH+mRi8x+ekAoxMV/DkqjN+jqBe3taAMtmlqcQTBbuw53qqJxWUJj6SamBX6cfZvFPvxJ1NZIbzQA8xJQFIjb7xsv1M0TlB1L+abqsWXOcRSaKBptch8QHhGP0XqH1iaCEePY4z/WqLTNcgGGcAPETiqkk99tCFipYt+3vR56igLWntra+ePQME9QbkWGcVirznJ3OB+NFP5moCiTiNICljRQvPzsu7bWTVr7f/gCp4mgFlcdAUCJ8DISBdQHq+R/M1HAXBN28FmvOYqrlpp4Hgix0MVMd0pQI+oL8pRK7Pnx/G/8tgo76y6T+klU8xy8Hrr05wzq3Lhh76sFmGGY1fc6Klq6D7jxyoIN/n6TNZEv7sZe3itZCsIQL9cu8Xn8p06cZiZ6fevTQyh+89f0sgjyrc1tjqFU4YJRXqsF8pRSxPuYkOW5/cRLsthNcZ+0UteGC033bRcAalLGzQVFe6ozNPFutWLNJU8qpZhbTWe2vUpC4GP4dnFXPDP77CuND1K2TUQ79AOJmd2Lk3CslcGAXR1OyCn1p9OePDxsnmzTetdFDyA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(40470700004)(36840700001)(46966006)(82310400005)(8676002)(4326008)(8936002)(54906003)(110136005)(5660300002)(81166007)(70586007)(2616005)(30864003)(86362001)(7416002)(508600001)(36860700001)(70206006)(2906002)(40460700003)(36756003)(316002)(26005)(1076003)(186003)(336012)(7696005)(6666004)(83380400001)(47076005)(426003)(107886003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 13:49:20.9961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53edf484-c23b-4449-9648-08da4ed5d99f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1603
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 1e99f5c61f84..9a1efe23fab7 100644
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
index f545e39df72a..e81362891596 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5251,6 +5251,80 @@ union bpf_attr {
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
  *		is out of bounds.
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
+ * long bpf_tcp_raw_check_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th)
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
+ * long bpf_tcp_raw_check_syncookie_ipv6(struct ipv6hdr *iph, struct tcphdr *th)
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
@@ -5457,6 +5531,10 @@ union bpf_attr {
 	FN(dynptr_read),		\
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
+	FN(tcp_raw_gen_syncookie_ipv4),	\
+	FN(tcp_raw_gen_syncookie_ipv6),	\
+	FN(tcp_raw_check_syncookie_ipv4),	\
+	FN(tcp_raw_check_syncookie_ipv6),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 5af58eb48587..b62d4126a561 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7444,6 +7444,114 @@ static const struct bpf_func_proto bpf_skb_set_tstamp_proto = {
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
+	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
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
+	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
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
+	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg1_size	= sizeof(struct iphdr),
+	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
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
+	.arg1_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg1_size	= sizeof(struct ipv6hdr),
+	.arg2_type	= ARG_PTR_TO_FIXED_SIZE_MEM,
+	.arg2_size	= sizeof(struct tcphdr),
+};
+#endif /* CONFIG_SYN_COOKIES */
+
 #endif /* CONFIG_INET */
 
 bool bpf_helper_changes_pkt_data(void *func)
@@ -7856,6 +7964,16 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
index 2e2a9ece9af2..6426f6a2e744 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3967,7 +3967,7 @@ static bool smc_parse_options(const struct tcphdr *th,
 /* Try to parse the MSS option from the TCP header. Return 0 on failure, clamped
  * value on success.
  */
-static u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss)
+u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss)
 {
 	const unsigned char *ptr = (const unsigned char *)(th + 1);
 	int length = (th->doff * 4) - sizeof(struct tcphdr);
@@ -4006,6 +4006,7 @@ static u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss)
 	}
 	return mss;
 }
+EXPORT_SYMBOL_GPL(tcp_parse_mss_option);
 
 /* Look for tcp options. Normally only called on SYN and SYNACK packets.
  * But, this can also be called on packets in the established flow when
diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index 855b937e7585..a0ec321469bd 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -635,6 +635,8 @@ class PrinterHelpers(Printer):
             'struct bpf_timer',
             'struct mptcp_sock',
             'struct bpf_dynptr',
+            'struct iphdr',
+            'struct ipv6hdr',
     ]
     known_types = {
             '...',
@@ -686,6 +688,8 @@ class PrinterHelpers(Printer):
             'struct bpf_timer',
             'struct mptcp_sock',
             'struct bpf_dynptr',
+            'struct iphdr',
+            'struct ipv6hdr',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f545e39df72a..e81362891596 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5251,6 +5251,80 @@ union bpf_attr {
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
  *		is out of bounds.
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
+ * long bpf_tcp_raw_check_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th)
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
+ * long bpf_tcp_raw_check_syncookie_ipv6(struct ipv6hdr *iph, struct tcphdr *th)
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
@@ -5457,6 +5531,10 @@ union bpf_attr {
 	FN(dynptr_read),		\
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
+	FN(tcp_raw_gen_syncookie_ipv4),	\
+	FN(tcp_raw_gen_syncookie_ipv6),	\
+	FN(tcp_raw_check_syncookie_ipv4),	\
+	FN(tcp_raw_check_syncookie_ipv6),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.30.2

