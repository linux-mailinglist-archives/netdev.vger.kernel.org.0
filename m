Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080A85894D7
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 01:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiHCXa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 19:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiHCXa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 19:30:58 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78ECEBC8E
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 16:30:56 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o18-20020a17090aac1200b001f3252af009so1804634pjq.7
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 16:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=96mz6l5AL8jS2s5QvO8CrtNqKcVW8uW9JbcsNPqqUrM=;
        b=GshwCPXujJOkoyvl/HKv/pg4rYaW5A/NUaLZrhEWKff9N6ozvJjPgy1yBkjVLaLLD0
         tKMLZokZDPQjYtSNbOxyZETtLq6P7HZ0aV3juWnVgy/nlNzrBM8Uf57InHOvHuhp3bRN
         8o/FrirRC7nQEvOS9TJOA5RIk0Y8IKLVHBuDlTXWqJ0DygdvKoBGabadC9D9Oa5/cKPs
         vYvEFjamYDpWdvtTcMtwMdUIkuT2AJu3Ti3R3QWITC5XmCYNEUHMygInN2RbZB/smmq3
         EsDgDNI+xSO3TydczulHd6J/PGQEFRLxUL7ZQud1okfMiHpRVaIc3t1K8/BRDcZVY/Y1
         yBGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=96mz6l5AL8jS2s5QvO8CrtNqKcVW8uW9JbcsNPqqUrM=;
        b=3OnvuwhWsQS0f+GSBWg0mM8i+th6VTmglg0ONzJG81ZXYYHoYyRpYKXadLboADYFTo
         1RmjCq66cBovUBtWjzM3wDDBF4ISoQxQRK+crxOaq+vF8LGYDw85jhh1ZSqq0EzbBMMY
         ZxrVhLJtE4N+dpOla2zYroz1RwdDJs7Dlc+We79lm5Jjv4TtDFa8Olz5AKCZkelQYk4x
         6+o5zem96yzI5XwMtaexDiI7WnzMYOHDjhhJ+jQAL5zW4aqpuHZV0ilrGZPAQx95dWxm
         5JWDfE+Drh6wit01Vw5I32TfsRncZUrQymsN3dDUVaRDSOeabGodPO8qkajfyQ35ul8o
         cCEg==
X-Gm-Message-State: ACgBeo3V2lvPCGG0fsbZff63SK4hSvupnU7ilpYNm2r8Rj0hJJn15tkq
        rWsNmzimeZcKviVMUw/7YO2v5sM=
X-Google-Smtp-Source: AA6agR5sFispC3RpDlDhN2w5QQjSMJDMgKZ9algyXCq3kqoiTXNB9tg+q4cCe3kpH5F6PHSZH9A+I+E=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a62:4e54:0:b0:52d:3980:bd50 with SMTP id
 c81-20020a624e54000000b0052d3980bd50mr20157819pfb.60.1659569455952; Wed, 03
 Aug 2022 16:30:55 -0700 (PDT)
Date:   Wed, 3 Aug 2022 16:30:54 -0700
In-Reply-To: <20220803204736.3082620-1-kafai@fb.com>
Message-Id: <YusFLu+OvcAIq1xr@google.com>
Mime-Version: 1.0
References: <20220803204601.3075863-1-kafai@fb.com> <20220803204736.3082620-1-kafai@fb.com>
Subject: Re: [PATCH v2 bpf-next 15/15] selftests/bpf: bpf_setsockopt tests
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/03, Martin KaFai Lau wrote:
> This patch adds tests to exercise optnames that are allowed
> in bpf_setsockopt().

> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>   .../selftests/bpf/prog_tests/setget_sockopt.c | 125 ++++
>   .../selftests/bpf/progs/setget_sockopt.c      | 547 ++++++++++++++++++
>   2 files changed, 672 insertions(+)
>   create mode 100644  
> tools/testing/selftests/bpf/prog_tests/setget_sockopt.c
>   create mode 100644 tools/testing/selftests/bpf/progs/setget_sockopt.c

> diff --git a/tools/testing/selftests/bpf/prog_tests/setget_sockopt.c  
> b/tools/testing/selftests/bpf/prog_tests/setget_sockopt.c
> new file mode 100644
> index 000000000000..018611e6b248
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/setget_sockopt.c
> @@ -0,0 +1,125 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) Meta Platforms, Inc. and affiliates. */
> +
> +#define _GNU_SOURCE
> +#include <sched.h>
> +#include <linux/socket.h>
> +#include <net/if.h>
> +
> +#include "test_progs.h"
> +#include "cgroup_helpers.h"
> +#include "network_helpers.h"
> +
> +#include "setget_sockopt.skel.h"
> +
> +#define CG_NAME "/setget-sockopt-test"
> +
> +static const char addr4_str[] = "127.0.0.1";
> +static const char addr6_str[] = "::1";
> +static struct setget_sockopt *skel;
> +static int cg_fd;
> +
> +static int create_netns(void)
> +{
> +	if (!ASSERT_OK(unshare(CLONE_NEWNET), "create netns"))
> +		return -1;
> +
> +	if (!ASSERT_OK(system("ip link set dev lo up"), "set lo up"))
> +		return -1;
> +
> +	if (!ASSERT_OK(system("ip link add dev binddevtest1 type veth peer name  
> binddevtest2"),
> +		       "add veth"))
> +		return -1;
> +
> +	if (!ASSERT_OK(system("ip link set dev binddevtest1 up"),
> +		       "bring veth up"))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static void test_tcp(int family)
> +{
> +	struct setget_sockopt__bss *bss = skel->bss;
> +	int sfd, cfd;
> +
> +	memset(bss, 0, sizeof(*bss));
> +
> +	sfd = start_server(family, SOCK_STREAM,
> +			   family == AF_INET6 ? addr6_str : addr4_str, 0, 0);
> +	if (!ASSERT_GE(sfd, 0, "start_server"))
> +		return;
> +
> +	cfd = connect_to_fd(sfd, 0);
> +	if (!ASSERT_GE(cfd, 0, "connect_to_fd_server")) {
> +		close(sfd);
> +		return;
> +	}
> +	close(sfd);
> +	close(cfd);
> +
> +	ASSERT_EQ(bss->nr_listen, 1, "nr_listen");
> +	ASSERT_EQ(bss->nr_connect, 1, "nr_connect");
> +	ASSERT_EQ(bss->nr_active, 1, "nr_active");
> +	ASSERT_EQ(bss->nr_passive, 1, "nr_passive");
> +	ASSERT_EQ(bss->nr_socket_post_create, 2, "nr_socket_post_create");
> +	ASSERT_EQ(bss->nr_binddev, 2, "nr_bind");
> +}
> +
> +static void test_udp(int family)
> +{
> +	struct setget_sockopt__bss *bss = skel->bss;
> +	int sfd;
> +
> +	memset(bss, 0, sizeof(*bss));
> +
> +	sfd = start_server(family, SOCK_DGRAM,
> +			   family == AF_INET6 ? addr6_str : addr4_str, 0, 0);
> +	if (!ASSERT_GE(sfd, 0, "start_server"))
> +		return;
> +	close(sfd);
> +
> +	ASSERT_GE(bss->nr_socket_post_create, 1, "nr_socket_post_create");
> +	ASSERT_EQ(bss->nr_binddev, 1, "nr_bind");
> +}
> +
> +void test_setget_sockopt(void)
> +{
> +	cg_fd = test__join_cgroup(CG_NAME);
> +	if (cg_fd < 0)
> +		return;
> +
> +	if (create_netns())
> +		goto done;
> +
> +	skel = setget_sockopt__open();
> +	if (!ASSERT_OK_PTR(skel, "open skel"))
> +		goto done;
> +
> +	strcpy(skel->rodata->veth, "binddevtest1");
> +	skel->rodata->veth_ifindex = if_nametoindex("binddevtest1");
> +	if (!ASSERT_GT(skel->rodata->veth_ifindex, 0, "if_nametoindex"))
> +		goto done;
> +
> +	if (!ASSERT_OK(setget_sockopt__load(skel), "load skel"))
> +		goto done;
> +
> +	skel->links.skops_sockopt =
> +		bpf_program__attach_cgroup(skel->progs.skops_sockopt, cg_fd);
> +	if (!ASSERT_OK_PTR(skel->links.skops_sockopt, "attach cgroup"))
> +		goto done;
> +
> +	skel->links.socket_post_create =
> +		bpf_program__attach_cgroup(skel->progs.socket_post_create, cg_fd);
> +	if (!ASSERT_OK_PTR(skel->links.socket_post_create, "attach_cgroup"))
> +		goto done;
> +
> +	test_tcp(AF_INET6);
> +	test_tcp(AF_INET);
> +	test_udp(AF_INET6);
> +	test_udp(AF_INET);
> +
> +done:
> +	setget_sockopt__destroy(skel);
> +	close(cg_fd);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/setget_sockopt.c  
> b/tools/testing/selftests/bpf/progs/setget_sockopt.c
> new file mode 100644
> index 000000000000..560cf4b92d65
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/setget_sockopt.c
> @@ -0,0 +1,547 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) Meta Platforms, Inc. and affiliates. */
> +
> +#include <stddef.h>
> +#include <stdbool.h>
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <linux/in.h>
> +#include <linux/ipv6.h>
> +#include <linux/tcp.h>
> +#include <linux/socket.h>
> +#include <linux/bpf.h>
> +#include <linux/if.h>
> +#include <linux/types.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <errno.h>
> +
> +#ifndef SO_TXREHASH
> +#define SO_TXREHASH 74
> +#endif
> +
> +#ifndef TCP_NAGLE_OFF
> +#define TCP_NAGLE_OFF 1
> +#endif
> +
> +#ifndef ARRAY_SIZE
> +#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> +#endif
> +
> +extern unsigned long CONFIG_HZ __kconfig;
> +
> +const volatile char veth[IFNAMSIZ];
> +const volatile int veth_ifindex;
> +
> +int nr_listen;
> +int nr_passive;
> +int nr_active;
> +int nr_connect;
> +int nr_binddev;
> +int nr_socket_post_create;
> +
> +struct sockopt_test {
> +	int opt;
> +	int new;
> +	int restore;
> +	int expected;
> +	int tcp_expected;
> +	int flip:1;
> +};
> +
> +static const char cubic_cc[] = "cubic";
> +static const char reno_cc[] = "reno";
> +
> +static const struct sockopt_test sol_socket_tests[] = {
> +	{ .opt = SO_REUSEADDR, .flip = 1, },
> +	{ .opt = SO_SNDBUF, .new = 8123, .expected = 8123 * 2, },
> +	{ .opt = SO_RCVBUF, .new = 8123, .expected = 8123 * 2, },
> +	{ .opt = SO_KEEPALIVE, .flip = 1, },
> +	{ .opt = SO_PRIORITY, .new = 0xeb9f, .expected = 0xeb9f, },
> +	{ .opt = SO_REUSEPORT, .flip = 1, },
> +	{ .opt = SO_RCVLOWAT, .new = 8123, .expected = 8123, },
> +	{ .opt = SO_MARK, .new = 0xeb9f, .expected = 0xeb9f, },
> +	{ .opt = SO_MAX_PACING_RATE, .new = 0xeb9f, .expected = 0xeb9f, },
> +	{ .opt = SO_TXREHASH, .flip = 1, },
> +	{ .opt = 0, },
> +};
> +
> +static const struct sockopt_test sol_tcp_tests[] = {
> +	{ .opt = TCP_NODELAY, .flip = 1, },
> +	{ .opt = TCP_MAXSEG, .new = 1314, .expected = 1314, },
> +	{ .opt = TCP_KEEPIDLE, .new = 123, .expected = 123, .restore = 321, },
> +	{ .opt = TCP_KEEPINTVL, .new = 123, .expected = 123, .restore = 321, },
> +	{ .opt = TCP_KEEPCNT, .new = 123, .expected = 123, .restore = 124, },
> +	{ .opt = TCP_SYNCNT, .new = 123, .expected = 123, .restore = 124, },
> +	{ .opt = TCP_WINDOW_CLAMP, .new = 8123, .expected = 8123, .restore =  
> 8124, },
> +	{ .opt = TCP_CONGESTION, },
> +	{ .opt = TCP_THIN_LINEAR_TIMEOUTS, .flip = 1, },
> +	{ .opt = TCP_USER_TIMEOUT, .new = 123400, .expected = 123400, },
> +	{ .opt = TCP_NOTSENT_LOWAT, .new = 1314, .expected = 1314, },
> +	{ .opt = TCP_SAVE_SYN, .new = 1, .expected = 1, },
> +	{ .opt = 0, },
> +};
> +
> +static const struct sockopt_test sol_ip_tests[] = {
> +	{ .opt = IP_TOS, .new = 0xe1, .expected = 0xe1, .tcp_expected = 0xe0, },
> +	{ .opt = 0, },
> +};
> +
> +static const struct sockopt_test sol_ipv6_tests[] = {
> +	{ .opt = IPV6_TCLASS, .new = 0xe1, .expected = 0xe1, .tcp_expected =  
> 0xe0, },
> +	{ .opt = IPV6_AUTOFLOWLABEL, .flip = 1, },
> +	{ .opt = 0, },
> +};
> +
> +struct sock_common {
> +	unsigned short	skc_family;
> +	unsigned long	skc_flags;
> +	unsigned char	skc_reuse:4;
> +	unsigned char	skc_reuseport:1;
> +	unsigned char	skc_ipv6only:1;
> +	unsigned char	skc_net_refcnt:1;
> +} __attribute__((preserve_access_index));
> +
> +struct sock {
> +	struct sock_common	__sk_common;
> +	__u16			sk_type;
> +	__u16			sk_protocol;
> +	int			sk_rcvlowat;
> +	__u32			sk_mark;
> +	unsigned long		sk_max_pacing_rate;
> +	unsigned int		keepalive_time;
> +	unsigned int		keepalive_intvl;
> +} __attribute__((preserve_access_index));
> +
> +struct tcp_options_received {
> +	__u16 user_mss;
> +} __attribute__((preserve_access_index));

I'm assuming you're not using vmlinux here because it doesn't bring
it most of the defines? Should we add missing stuff to bpf_tracing_net.h
instead?

> +struct ipv6_pinfo {
> +	__u16			recverr:1,
> +				sndflow:1,
> +				repflow:1,
> +				pmtudisc:3,
> +				padding:1,
> +				srcprefs:3,
> +				dontfrag:1,
> +				autoflowlabel:1,
> +				autoflowlabel_set:1,
> +				mc_all:1,
> +				recverr_rfc4884:1,
> +				rtalert_isolate:1;
> +}  __attribute__((preserve_access_index));
> +
> +struct inet_sock {
> +	/* sk and pinet6 has to be the first two members of inet_sock */
> +	struct sock		sk;
> +	struct ipv6_pinfo	*pinet6;
> +} __attribute__((preserve_access_index));
> +
> +struct inet_connection_sock {
> +	__u32			  icsk_user_timeout;
> +	__u8			  icsk_syn_retries;
> +} __attribute__((preserve_access_index));
> +
> +struct tcp_sock {
> +	struct inet_connection_sock	inet_conn;
> +	struct tcp_options_received rx_opt;
> +	__u8	save_syn:2,
> +		syn_data:1,
> +		syn_fastopen:1,
> +		syn_fastopen_exp:1,
> +		syn_fastopen_ch:1,
> +		syn_data_acked:1,
> +		is_cwnd_limited:1;
> +	__u32	window_clamp;
> +	__u8	nonagle     : 4,
> +		thin_lto    : 1,
> +		recvmsg_inq : 1,
> +		repair      : 1,
> +		frto        : 1;
> +	__u32	notsent_lowat;
> +	__u8	keepalive_probes;
> +	unsigned int		keepalive_time;
> +	unsigned int		keepalive_intvl;
> +} __attribute__((preserve_access_index));
> +
> +struct socket {
> +	struct sock *sk;
> +} __attribute__((preserve_access_index));
> +
> +struct loop_ctx {
> +	void *ctx;
> +	struct sock *sk;
> +};
> +
> +static int __bpf_getsockopt(void *ctx, struct sock *sk,
> +			    int level, int opt, int *optval,
> +			    int optlen)
> +{
> +	if (level == SOL_SOCKET) {
> +		switch (opt) {
> +		case SO_REUSEADDR:
> +			*optval = !!(sk->__sk_common.skc_reuse);
> +			break;
> +		case SO_KEEPALIVE:
> +			*optval = !!(sk->__sk_common.skc_flags & (1UL << 3));
> +			break;
> +		case SO_RCVLOWAT:
> +			*optval = sk->sk_rcvlowat;
> +			break;

What's the idea with the options above? Why not allow them in
bpf_getsockopt instead?

> +		case SO_MARK:
> +			*optval = sk->sk_mark;
> +			break;

SO_MARK should be handled by bpf_getsockopt ?

> +		case SO_MAX_PACING_RATE:
> +			*optval = sk->sk_max_pacing_rate;
> +			break;
> +		default:
> +			return bpf_getsockopt(ctx, level, opt, optval, optlen);
> +		}
> +		return 0;
> +	}
> +
> +	if (level == IPPROTO_TCP) {
> +		struct tcp_sock *tp = bpf_skc_to_tcp_sock(sk);
> +
> +		if (!tp)
> +			return -1;
> +
> +		switch (opt) {
> +		case TCP_NODELAY:
> +			*optval = !!(tp->nonagle & TCP_NAGLE_OFF);
> +			break;
> +		case TCP_MAXSEG:
> +			*optval = tp->rx_opt.user_mss;
> +			break;
> +		case TCP_KEEPIDLE:
> +			*optval = tp->keepalive_time / CONFIG_HZ;
> +			break;
> +		case TCP_SYNCNT:
> +			*optval = tp->inet_conn.icsk_syn_retries;
> +			break;
> +		case TCP_KEEPINTVL:
> +			*optval = tp->keepalive_intvl / CONFIG_HZ;
> +			break;
> +		case TCP_KEEPCNT:
> +			*optval = tp->keepalive_probes;
> +			break;
> +		case TCP_WINDOW_CLAMP:
> +			*optval = tp->window_clamp;
> +			break;
> +		case TCP_THIN_LINEAR_TIMEOUTS:
> +			*optval = tp->thin_lto;
> +			break;
> +		case TCP_USER_TIMEOUT:
> +			*optval = tp->inet_conn.icsk_user_timeout;
> +			break;
> +		case TCP_NOTSENT_LOWAT:
> +			*optval = tp->notsent_lowat;
> +			break;
> +		case TCP_SAVE_SYN:
> +			*optval = tp->save_syn;
> +			break;
> +		default:
> +			return bpf_getsockopt(ctx, level, opt, optval, optlen);
> +		}
> +		return 0;
> +	}
> +
> +	if (level == IPPROTO_IPV6) {
> +		switch (opt) {
> +		case IPV6_AUTOFLOWLABEL: {
> +			__u16 proto = sk->sk_protocol;
> +			struct inet_sock *inet_sk;
> +
> +			if (proto == IPPROTO_TCP)
> +				inet_sk = (struct inet_sock *)bpf_skc_to_tcp_sock(sk);
> +			else
> +				inet_sk = (struct inet_sock *)bpf_skc_to_udp6_sock(sk);
> +
> +			if (!inet_sk)
> +				return -1;
> +
> +			*optval = !!inet_sk->pinet6->autoflowlabel;
> +			break;
> +		}
> +		default:
> +			return bpf_getsockopt(ctx, level, opt, optval, optlen);
> +		}
> +		return 0;
> +	}
> +
> +	return bpf_getsockopt(ctx, level, opt, optval, optlen);
> +}
> +
> +static int bpf_test_sockopt_flip(void *ctx, struct sock *sk,
> +				 const struct sockopt_test *t,
> +				 int level)
> +{
> +	int old, tmp, new, opt = t->opt;
> +
> +	opt = t->opt;
> +
> +	if (__bpf_getsockopt(ctx, sk, level, opt, &old, sizeof(old)))
> +		return 1;
> +	/* kernel initialized txrehash to 255 */
> +	if (level == SOL_SOCKET && opt == SO_TXREHASH && old != 0 && old != 1)
> +		old = 1;
> +
> +	new = !old;
> +	if (bpf_setsockopt(ctx, level, opt, &new, sizeof(new)))
> +		return 1;
> +	if (__bpf_getsockopt(ctx, sk, level, opt, &tmp, sizeof(tmp)) ||
> +	    tmp != new)
> +		return 1;
> +
> +	if (bpf_setsockopt(ctx, level, opt, &old, sizeof(old)))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static int bpf_test_sockopt_int(void *ctx, struct sock *sk,
> +				const struct sockopt_test *t,
> +				int level)
> +{
> +	int old, tmp, new, expected, opt;
> +
> +	opt = t->opt;
> +	new = t->new;
> +	if (sk->sk_type == SOCK_STREAM && t->tcp_expected)
> +		expected = t->tcp_expected;
> +	else
> +		expected = t->expected;
> +
> +	if (__bpf_getsockopt(ctx, sk, level, opt, &old, sizeof(old)) ||
> +	    old == new)
> +		return 1;
> +
> +	if (bpf_setsockopt(ctx, level, opt, &new, sizeof(new)))
> +		return 1;
> +	if (__bpf_getsockopt(ctx, sk, level, opt, &tmp, sizeof(tmp)) ||
> +	    tmp != expected)
> +		return 1;
> +
> +	if (t->restore)
> +		old = t->restore;
> +	if (bpf_setsockopt(ctx, level, opt, &old, sizeof(old)))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static int bpf_test_socket_sockopt(__u32 i, struct loop_ctx *lc)
> +{
> +	const struct sockopt_test *t;
> +
> +	if (i >= ARRAY_SIZE(sol_socket_tests))
> +		return 1;
> +
> +	t = &sol_socket_tests[i];
> +	if (!t->opt)
> +		return 1;
> +
> +	if (t->flip)
> +		return bpf_test_sockopt_flip(lc->ctx, lc->sk, t, SOL_SOCKET);
> +
> +	return bpf_test_sockopt_int(lc->ctx, lc->sk, t, SOL_SOCKET);
> +}
> +
> +static int bpf_test_ip_sockopt(__u32 i, struct loop_ctx *lc)
> +{
> +	const struct sockopt_test *t;
> +
> +	if (i >= ARRAY_SIZE(sol_ip_tests))
> +		return 1;
> +
> +	t = &sol_ip_tests[i];
> +	if (!t->opt)
> +		return 1;
> +
> +	if (t->flip)
> +		return bpf_test_sockopt_flip(lc->ctx, lc->sk, t, IPPROTO_IP);
> +
> +	return bpf_test_sockopt_int(lc->ctx, lc->sk, t, IPPROTO_IP);
> +}
> +
> +static int bpf_test_ipv6_sockopt(__u32 i, struct loop_ctx *lc)
> +{
> +	const struct sockopt_test *t;
> +
> +	if (i >= ARRAY_SIZE(sol_ipv6_tests))
> +		return 1;
> +
> +	t = &sol_ipv6_tests[i];
> +	if (!t->opt)
> +		return 1;
> +
> +	if (t->flip)
> +		return bpf_test_sockopt_flip(lc->ctx, lc->sk, t, IPPROTO_IPV6);
> +
> +	return bpf_test_sockopt_int(lc->ctx, lc->sk, t, IPPROTO_IPV6);
> +}
> +
> +static int bpf_test_tcp_sockopt(__u32 i, struct loop_ctx *lc)
> +{
> +	const struct sockopt_test *t;
> +	struct sock *sk;
> +	void *ctx;
> +
> +	if (i >= ARRAY_SIZE(sol_tcp_tests))
> +		return 1;
> +
> +	t = &sol_tcp_tests[i];
> +	if (!t->opt)
> +		return 1;
> +
> +	ctx = lc->ctx;
> +	sk = lc->sk;
> +
> +	if (t->opt == TCP_CONGESTION) {
> +		char old_cc[16], tmp_cc[16];
> +		const char *new_cc;
> +
> +		if (bpf_getsockopt(ctx, IPPROTO_TCP, TCP_CONGESTION, old_cc,  
> sizeof(old_cc)))
> +			return 1;
> +		if (!bpf_strncmp(old_cc, sizeof(old_cc), cubic_cc))
> +			new_cc = reno_cc;
> +		else
> +			new_cc = cubic_cc;
> +		if (bpf_setsockopt(ctx, IPPROTO_TCP, TCP_CONGESTION, (void *)new_cc,
> +				   sizeof(new_cc)))
> +			return 1;
> +		if (bpf_getsockopt(ctx, IPPROTO_TCP, TCP_CONGESTION, tmp_cc,  
> sizeof(tmp_cc)))
> +			return 1;
> +		if (bpf_strncmp(tmp_cc, sizeof(tmp_cc), new_cc))
> +			return 1;
> +		if (bpf_setsockopt(ctx, IPPROTO_TCP, TCP_CONGESTION, old_cc,  
> sizeof(old_cc)))
> +			return 1;
> +		return 0;
> +	}
> +
> +	if (t->flip)
> +		return bpf_test_sockopt_flip(ctx, sk, t, IPPROTO_TCP);
> +
> +	return bpf_test_sockopt_int(ctx, sk, t, IPPROTO_TCP);
> +}
> +
> +static int bpf_test_sockopt(void *ctx, struct sock *sk)
> +{
> +	struct loop_ctx lc = { .ctx = ctx, .sk = sk, };
> +	__u16 family, proto;
> +	int n;
> +
> +	family = sk->__sk_common.skc_family;
> +	proto = sk->sk_protocol;
> +
> +	n = bpf_loop(ARRAY_SIZE(sol_socket_tests), bpf_test_socket_sockopt,  
> &lc, 0);
> +	if (n != ARRAY_SIZE(sol_socket_tests))
> +		return -1;
> +
> +	if (proto == IPPROTO_TCP) {
> +		n = bpf_loop(ARRAY_SIZE(sol_tcp_tests), bpf_test_tcp_sockopt, &lc, 0);
> +		if (n != ARRAY_SIZE(sol_tcp_tests))
> +			return -1;
> +	}
> +
> +	if (family == AF_INET) {
> +		n = bpf_loop(ARRAY_SIZE(sol_ip_tests), bpf_test_ip_sockopt, &lc, 0);
> +		if (n != ARRAY_SIZE(sol_ip_tests))
> +			return -1;
> +	} else {
> +		n = bpf_loop(ARRAY_SIZE(sol_ipv6_tests), bpf_test_ipv6_sockopt, &lc,  
> 0);
> +		if (n != ARRAY_SIZE(sol_ipv6_tests))
> +			return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int binddev_test(void *ctx)
> +{
> +	const char empty_ifname[] = "";
> +	int ifindex, zero = 0;
> +
> +	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
> +			   (void *)veth, sizeof(veth)))
> +		return -1;
> +	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
> +			   &ifindex, sizeof(int)) ||
> +	    ifindex != veth_ifindex)
> +		return -1;
> +
> +	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
> +			   (void *)empty_ifname, sizeof(empty_ifname)))
> +		return -1;
> +	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
> +			   &ifindex, sizeof(int)) ||
> +	    ifindex != 0)
> +		return -1;
> +
> +	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
> +			   (void *)&veth_ifindex, sizeof(int)))
> +		return -1;
> +	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
> +			   &ifindex, sizeof(int)) ||
> +	    ifindex != veth_ifindex)
> +		return -1;
> +
> +	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
> +			   &zero, sizeof(int)))
> +		return -1;
> +	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
> +			   &ifindex, sizeof(int)) ||
> +	    ifindex != 0)
> +		return -1;
> +
> +	return 0;
> +}
> +
> +SEC("lsm_cgroup/socket_post_create")
> +int BPF_PROG(socket_post_create, struct socket *sock, int family,
> +	     int type, int protocol, int kern)
> +{
> +	struct sock *sk = sock->sk;
> +
> +	if (!sk)
> +		return 1;
> +
> +	nr_socket_post_create += !bpf_test_sockopt(sk, sk);
> +	nr_binddev += !binddev_test(sk);
> +
> +	return 1;
> +}
> +
> +SEC("sockops")
> +int skops_sockopt(struct bpf_sock_ops *skops)
> +{
> +	struct bpf_sock *bpf_sk = skops->sk;
> +	struct sock *sk;
> +
> +	if (!bpf_sk)
> +		return 1;
> +
> +	sk = (struct sock *)bpf_skc_to_tcp_sock(bpf_sk);
> +	if (!sk)
> +		return 1;
> +
> +	switch (skops->op) {
> +	case BPF_SOCK_OPS_TCP_LISTEN_CB:
> +		nr_listen += !bpf_test_sockopt(skops, sk);
> +		break;
> +	case BPF_SOCK_OPS_TCP_CONNECT_CB:
> +		nr_connect += !bpf_test_sockopt(skops, sk);
> +		break;
> +	case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
> +		nr_active += !bpf_test_sockopt(skops, sk);
> +		break;
> +	case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
> +		nr_passive += !bpf_test_sockopt(skops, sk);
> +		break;
> +	}
> +
> +	return 1;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.30.2

