Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6ADB50BEA4
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 19:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbiDVRbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 13:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiDVRbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:31:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20613.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::613])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FC1E543F;
        Fri, 22 Apr 2022 10:28:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmnH6wMhkGg311NQcFd7kHM0DMd3z+6hxCgxf8nO11B1iyv0IpbyNJSfCunuwLH6ni01YBBWNlk6Uj0vH8zV+zJvdQNNlDoP1L3dSu2RFQ0j0uppvO1a+I7N2kQ1O1qBfHYY6RuZjI1mMdemQ46C9e6tP0YsHu5HROZwrOEDnIdeU/1BYxJgNaL+gJt6fw8LW408EpgO1U06/jm0mtpbp2qcKLASzVQJS4FxHgO2+m6Bo9b7JoSa0lYGYsbAeufLtSKeyV5n5hDNoykH82EFfL3plTxRehOK7D0zcrrpqYrwmJI17phSoGD6tZuYBLRolFFgGyo1PFxVZh1HJxEEIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2RUMwFwnHT0l0R84k4g5jGne0tZqIzSzt6Quc3zQj4Q=;
 b=kRZdVRzm+5m3zssFJt48RQMmTBVE69grj4wi0qcgA+uGFncvA1yVqZg2HJvIMVwMMBIaNOKvxsjhY0ELopyDkqUwPRBFqyA+A81pO9B6Cf5bbvqUcT+5ns5dVRPHrijwKr99twlRBVrTGfuDMAwpt3q0xPB9rj3nSvk8X3c0b7eFCsG98ygD4p+e55rkmIvgOE+y2hk8+ARJEedWLWtCK6M+uwYSeWW4IngZacIYlqTfHM+n4SAmuqPinCQhC1ibAXhVcyCWFa4AAfhYRi3BGP+DL6LoMaHVlFboGrl7Nm/CrOiQPokwZAiStXdbGsc6jqYOeHHbSh+r2YYK4dLUwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2RUMwFwnHT0l0R84k4g5jGne0tZqIzSzt6Quc3zQj4Q=;
 b=OPiJtQN9B0xV8cnybPmIKZ5Smw642obOINpN6GIwp89FmetCsQYqNnzO298u9vzQpi8fd/VEB5HY0scKLRuWnBA34gTmf8gWy/KAequ9oG+VMrnbLC72EV9Eg8ahwwtPldtSgObk1hNFnuP80qyxLoBhe/cok4vLm8W4CpDq1mOeiefyh5Xu9mfRnhdMxGBZ3Zm7s2o4AqxKl2rAeVej4mVaNA9fAQFOs1aTwMvudxqd9xjpVoUchneV6EzDo/HFxo7t8262dK0jP7ELMINh5sprtm+I1prNjJ+pIJxOXn/xADWJTnr3U/MJLPiHLJmm+a6aue8HkV3vwTYbdyEJ0A==
Received: from DM6PR02CA0125.namprd02.prod.outlook.com (2603:10b6:5:1b4::27)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 17:25:06 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::1b) by DM6PR02CA0125.outlook.office365.com
 (2603:10b6:5:1b4::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Fri, 22 Apr 2022 17:25:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 17:25:06 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 17:25:05 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 10:25:05 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Fri, 22 Apr
 2022 10:24:58 -0700
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
        Florian Westphal <fw@strlen.de>, <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf-next v6 4/6] bpf: Add helpers to issue and check SYN cookies in XDP
Date:   Fri, 22 Apr 2022 20:24:20 +0300
Message-ID: <20220422172422.4037988-5-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422172422.4037988-1-maximmi@nvidia.com>
References: <20220422172422.4037988-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e569ca0-348f-4cf3-1e13-08da24850b70
X-MS-TrafficTypeDiagnostic: DM6PR12MB4402:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4402DF416F160F1BCF520582DCF79@DM6PR12MB4402.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fUKeXnsAuzfX7I0Y/ulLI4wxelgLCDHSxvFPheETYUlUvEaM8YougCHl7qqYSPE1xxWQnC9jTO2fRX9qHx0JZVsV0s1AWw6Kp2q0sG9/3J1aGDV48hADxhyTA1y3zXFjFyS7PM+fqeD0cNjAW46zkOesq9LkBcnz8WZGKHHCShvwkQ9y6syQpm0r2RGwnxRw7SEikltj2BR7hUgO7zsIzqg2jB92Qm1tEcLAQIEBEX8BG9AtwPzAyhB8HYOLvjGgz1oA1Q3nRIdL3aMDcq+qOQHD7xEsMY/YzFEEq95+BEHGrqy0srVVUJZXlvZdX80uLTKjoAzqCpUEohCJfKm6T1rl9hkOGc6CVXnYoYtTcj078OXOBKCIJLhMdEkBLXFp5sCuzBh8d88q14TaT1IQQc7nJ6lu6xb9WFLJ2ReKxMTwjcwdsjljke/PosgorZKLOiO+/SnOb3w0hG2csK3sxh6h99BmQAY/tDTZNe9NvaZLOqMyshz2KOCGzWpXcvoyoJaNFyH4XIUd3IABBgLBJ3VIL/fwclJ1o/3bbA1OtB4NBzjkYhCsUiwdQOId6sMrM1/dvYvBdJnqXtsG9uLLkCj0o71JUFZesugE/cFGYoqc1J+G+K/fuI3O/d+9ZMZoRIxrPq86KuCLKi7H7tlMaPEyoI7GkECmsYYKyoWfbsoJI28hmLf4FHrz6llNjEYUS/FCt5BxYVYi7a6NWuE3sA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(8936002)(36860700001)(7416002)(54906003)(36756003)(110136005)(2906002)(316002)(40460700003)(47076005)(356005)(83380400001)(1076003)(26005)(2616005)(4326008)(186003)(336012)(426003)(86362001)(81166007)(107886003)(7696005)(508600001)(6666004)(82310400005)(5660300002)(30864003)(70586007)(70206006)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 17:25:06.5775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e569ca0-348f-4cf3-1e13-08da24850b70
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4402
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index 6d50a662bf89..b9617974e4d0 100644
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
index 5e1679af8282..ee218bae74c3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5145,6 +5145,80 @@ union bpf_attr {
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
@@ -5341,6 +5415,10 @@ union bpf_attr {
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
index 207a13db5c80..ffb7e93f60c5 100644
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
index 1595b76ea2be..0eb77cc4c05d 100644
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
index 5e1679af8282..ee218bae74c3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5145,6 +5145,80 @@ union bpf_attr {
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
@@ -5341,6 +5415,10 @@ union bpf_attr {
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

