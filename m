Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FD551E13A
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 23:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444599AbiEFVjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 17:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444532AbiEFVip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 17:38:45 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63EB6FA06;
        Fri,  6 May 2022 14:34:59 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id f4so9439796iov.2;
        Fri, 06 May 2022 14:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=goh1DQJe+sz1dYiC/mvHVfy7FXfWzJFBafWl/95lVLw=;
        b=Q/E2STZXNzMx4Q+yJ/lc0DKPocIA4mwRweenOpOKiaMDBjDKBfswmXaPeOxsdWR4Yy
         c74TfcA+fNNNZ6KTx8Zr1u95s9U8v4cQxD07pRonGFXHzY/bdoygkUeltLVUppMwqMw9
         5Bl6w2h6dDljoN1SjTKZlOQT4tGEwOgQ5hVPdcewODSntROFNiwZzrbhZsRSvXOZc0ZU
         fKPkrK/kQxec4+vk5oAIynmSxdiJDsxEgnLEKzMgCGQ5toxTsimGm+Ju9VIRTi+BYPcv
         5OOJHyltHxsjSfOl/ougzDhhQeaNRyRJqPGH4e5hpGAmnxelRxynqo+KGPo/xA56F8LQ
         M08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=goh1DQJe+sz1dYiC/mvHVfy7FXfWzJFBafWl/95lVLw=;
        b=NVj56Y3+CV728YY/TaXL44d22+bV//ZZFyDxo90gYLuOPEp3yt3Jr+PjH3QdsDthns
         wPIOzNaVOwd4h0BVl2JhOdZU5DrEyOt3SOBdCRvzmvSoduciIuVbdndaio4gQYTDVjUH
         YCeGniDw6wRt/UfOF68pT1BZI0vHo3oZdO1V+XjEtTRaFwz2Q4Z+wjBg8B6DIipPo9DG
         1OucyweH+1VivUZx4OVMBTnYd+5f+B1IB3pKQf+vDUZYr+qRvf7xnKmdJf4JzsnVOJtL
         Fudqh7/gKZcCV5/ZUeYUuGpCCcBtzaIdBrwFrj954l5Xi0q61QnpbBNL49vgwbFK63Tb
         AOlA==
X-Gm-Message-State: AOAM5334tsTsy7ydrWE/OFePw2jPUQ83K5KJK24dwmPTfKazwpn6ktVC
        9m+zW+0OGkyP1w+C6sK6HcHY6xj+nJ+t5GVpmoI=
X-Google-Smtp-Source: ABdhPJz6rTLLI/mFRjUGeR0iAT5E28FffWF3pKLrckdk0pqrNSZCEXLXREzXmz3rW+GvXlw3AF7BPl2nWQPz2bnZsOQ=
X-Received: by 2002:a05:6638:2104:b0:326:1e94:efa6 with SMTP id
 n4-20020a056638210400b003261e94efa6mr2412551jaj.234.1651872899249; Fri, 06
 May 2022 14:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220503171437.666326-1-maximmi@nvidia.com> <20220503171437.666326-5-maximmi@nvidia.com>
In-Reply-To: <20220503171437.666326-5-maximmi@nvidia.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 May 2022 14:34:48 -0700
Message-ID: <CAEf4BzZoBjcUqf_X2zNfu5ZUL8uoV3=hqD5OQWptohbXVTT4gg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 4/5] bpf: Add selftests for raw syncookie helpers
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 3, 2022 at 10:15 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> This commit adds selftests for the new BPF helpers:
> bpf_tcp_raw_{gen,check}_syncookie_ipv{4,6}.
>
> xdp_synproxy_kern.c is a BPF program that generates SYN cookies on
> allowed TCP ports and sends SYNACKs to clients, accelerating synproxy
> iptables module.
>
> xdp_synproxy.c is a userspace control application that allows to
> configure the following options in runtime: list of allowed ports, MSS,
> window scale, TTL.
>
> A selftest is added to prog_tests that leverages the above programs to
> test the functionality of the new helpers.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---

selftests should use "selftests/bpf: " subject prefix, not "bpf: ",
please update so it's more obvious that this patch touches selftests
and not kernel-side BPF functionality.

>  tools/testing/selftests/bpf/.gitignore        |   1 +
>  tools/testing/selftests/bpf/Makefile          |   5 +-
>  .../selftests/bpf/prog_tests/xdp_synproxy.c   | 109 +++
>  .../selftests/bpf/progs/xdp_synproxy_kern.c   | 750 ++++++++++++++++++
>  tools/testing/selftests/bpf/xdp_synproxy.c    | 418 ++++++++++
>  5 files changed, 1281 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
>  create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
>  create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c
>
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> index 595565eb68c0..ca2f47f45670 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -43,3 +43,4 @@ test_cpp
>  *.tmp
>  xdpxceiver
>  xdp_redirect_multi
> +xdp_synproxy
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index bafdc5373a13..8ae602843b16 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -82,9 +82,9 @@ TEST_PROGS_EXTENDED := with_addr.sh \
>  TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
>         flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
>         test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
> -       xdpxceiver xdp_redirect_multi
> +       xdpxceiver xdp_redirect_multi xdp_synproxy
>
> -TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
> +TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read $(OUTPUT)/xdp_synproxy
>
>  # Emit succinct information message describing current building step
>  # $1 - generic step name (e.g., CC, LINK, etc);
> @@ -500,6 +500,7 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c      \
>                          cap_helpers.c
>  TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko \
>                        $(OUTPUT)/liburandom_read.so                     \
> +                      $(OUTPUT)/xdp_synproxy                           \

this is the right way to make external binary available to test_progs
flavors, but is there anything inherently requiring external binary
instead of having a helper function doing the same? urandom_read has
to be a separate binary.

>                        ima_setup.sh                                     \
>                        $(wildcard progs/btf_dump_test_case_*.c)
>  TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
> new file mode 100644
> index 000000000000..e08b28e25047
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
> @@ -0,0 +1,109 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +
> +#define SYS(cmd) ({ \
> +       if (!ASSERT_OK(system(cmd), (cmd))) \
> +               goto out; \
> +})
> +
> +#define SYS_OUT(cmd) ({ \
> +       FILE *f = popen((cmd), "r"); \
> +       if (!ASSERT_OK_PTR(f, (cmd))) \
> +               goto out; \
> +       f; \
> +})
> +
> +static bool expect_str(char *buf, size_t size, const char *str)
> +{
> +       if (size != strlen(str))
> +               return false;
> +       return !memcmp(buf, str, size);
> +}
> +
> +void test_xdp_synproxy(void)
> +{
> +       int server_fd = -1, client_fd = -1, accept_fd = -1;
> +       struct nstoken *ns = NULL;
> +       FILE *ctrl_file = NULL;
> +       char buf[1024];
> +       size_t size;
> +
> +       SYS("ip netns add synproxy");
> +
> +       SYS("ip link add tmp0 type veth peer name tmp1");
> +       SYS("ip link set tmp1 netns synproxy");
> +       SYS("ip link set tmp0 up");
> +       SYS("ip addr replace 198.18.0.1/24 dev tmp0");

> +
> +       // When checksum offload is enabled, the XDP program sees wrong
> +       // checksums and drops packets.
> +       SYS("ethtool -K tmp0 tx off");
> +       // Workaround required for veth.

don't use C++ comments, please stick to /* */

> +       SYS("ip link set tmp0 xdp object xdp_dummy.o section xdp 2> /dev/null");
> +
> +       ns = open_netns("synproxy");
> +       if (!ASSERT_OK_PTR(ns, "setns"))
> +               goto out;
> +
> +       SYS("ip link set lo up");
> +       SYS("ip link set tmp1 up");
> +       SYS("ip addr replace 198.18.0.2/24 dev tmp1");
> +       SYS("sysctl -w net.ipv4.tcp_syncookies=2");
> +       SYS("sysctl -w net.ipv4.tcp_timestamps=1");
> +       SYS("sysctl -w net.netfilter.nf_conntrack_tcp_loose=0");
> +       SYS("iptables -t raw -I PREROUTING \
> +           -i tmp1 -p tcp -m tcp --syn --dport 8080 -j CT --notrack");
> +       SYS("iptables -t filter -A INPUT \
> +           -i tmp1 -p tcp -m tcp --dport 8080 -m state --state INVALID,UNTRACKED \
> +           -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460");
> +       SYS("iptables -t filter -A INPUT \
> +           -i tmp1 -m state --state INVALID -j DROP");
> +
> +       ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --ports 8080 --single \
> +                           --mss4 1460 --mss6 1440 --wscale 7 --ttl 64");
> +       size = fread(buf, 1, sizeof(buf), ctrl_file);

buf is uninitialized so if fread fail strlen() can cause SIGSEGV or
some other failure mode

> +       pclose(ctrl_file);
> +       if (!ASSERT_TRUE(expect_str(buf, size, "Total SYNACKs generated: 0\n"),
> +                        "initial SYNACKs"))
> +               goto out;
> +
> +       server_fd = start_server(AF_INET, SOCK_STREAM, "198.18.0.2", 8080, 0);
> +       if (!ASSERT_GE(server_fd, 0, "start_server"))
> +               goto out;
> +
> +       close_netns(ns);
> +       ns = NULL;
> +
> +       client_fd = connect_to_fd(server_fd, 10000);
> +       if (!ASSERT_GE(client_fd, 0, "connect_to_fd"))
> +               goto out;
> +
> +       accept_fd = accept(server_fd, NULL, NULL);
> +       if (!ASSERT_GE(accept_fd, 0, "accept"))
> +               goto out;
> +
> +       ns = open_netns("synproxy");
> +       if (!ASSERT_OK_PTR(ns, "setns"))
> +               goto out;
> +
> +       ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --single");
> +       size = fread(buf, 1, sizeof(buf), ctrl_file);
> +       pclose(ctrl_file);
> +       if (!ASSERT_TRUE(expect_str(buf, size, "Total SYNACKs generated: 1\n"),
> +                        "SYNACKs after connection"))

please use ASSERT_STREQ instead, same above

> +               goto out;
> +
> +out:
> +       if (accept_fd >= 0)
> +               close(accept_fd);
> +       if (client_fd >= 0)
> +               close(client_fd);
> +       if (server_fd >= 0)
> +               close(server_fd);
> +       if (ns)
> +               close_netns(ns);
> +
> +       system("ip link del tmp0");
> +       system("ip netns del synproxy");
> +}
> diff --git a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
> new file mode 100644
> index 000000000000..9ae85b189072
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
> @@ -0,0 +1,750 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB

Can you please elaborate on what Linux-OpenIB license is and why
GPL-2.0 isn't enough? We usually have GPL-2.0 or LGPL-2.1 OR
BSD-2-Clause

> +/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
> +
> +#include "vmlinux.h"
> +
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +#include <asm/errno.h>
> +

[...]

> +
> +static __always_inline __u16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
> +                                              __u32 len, __u8 proto,
> +                                              __u32 csum)
> +{
> +       __u64 s = csum;
> +
> +       s += (__u32)saddr;
> +       s += (__u32)daddr;
> +#if defined(__BIG_ENDIAN__)
> +       s += proto + len;
> +#elif defined(__LITTLE_ENDIAN__)

I've got few nudges in libbpf code base previously to use

#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__

instead (I don't remember the exact reason now, but there was a
reason). Let's do the same here for consistency?

> +       s += (proto + len) << 8;
> +#else
> +#error Unknown endian
> +#endif
> +       s = (s & 0xffffffff) + (s >> 32);
> +       s = (s & 0xffffffff) + (s >> 32);
> +
> +       return csum_fold((__u32)s);
> +}
> +
> +static __always_inline __u16 csum_ipv6_magic(const struct in6_addr *saddr,
> +                                            const struct in6_addr *daddr,
> +                                            __u32 len, __u8 proto, __u32 csum)
> +{
> +       __u64 sum = csum;
> +       int i;
> +
> +#pragma unroll
> +       for (i = 0; i < 4; i++)
> +               sum += (__u32)saddr->in6_u.u6_addr32[i];
> +
> +#pragma unroll

why unroll? BPF verifier handles such loops just fine, even if
compiler decides to not unroll them

> +       for (i = 0; i < 4; i++)
> +               sum += (__u32)daddr->in6_u.u6_addr32[i];
> +
> +       // Don't combine additions to avoid 32-bit overflow.
> +       sum += bpf_htonl(len);
> +       sum += bpf_htonl(proto);
> +
> +       sum = (sum & 0xffffffff) + (sum >> 32);
> +       sum = (sum & 0xffffffff) + (sum >> 32);
> +
> +       return csum_fold((__u32)sum);
> +}
> +
> +static __always_inline __u64 tcp_clock_ns(void)

__always_inline isn't mandatory, you can just have static __u64
tcp_clock_ns() here and let compiler decide on inlining? same for
below

> +{
> +       return bpf_ktime_get_ns();
> +}
> +
> +static __always_inline __u32 tcp_ns_to_ts(__u64 ns)
> +{
> +       return ns / (NSEC_PER_SEC / TCP_TS_HZ);
> +}
> +
> +static __always_inline __u32 tcp_time_stamp_raw(void)
> +{
> +       return tcp_ns_to_ts(tcp_clock_ns());
> +}
> +

[...]

> +static __always_inline void values_inc_synacks(void)
> +{
> +       __u32 key = 1;
> +       __u32 *value;
> +
> +       value = bpf_map_lookup_elem(&values, &key);
> +       if (value)
> +               __sync_fetch_and_add(value, 1);
> +}
> +
> +static __always_inline bool check_port_allowed(__u16 port)
> +{
> +       __u32 i;
> +
> +       for (i = 0; i < MAX_ALLOWED_PORTS; i++) {
> +               __u32 key = i;
> +               __u16 *value;
> +
> +               value = bpf_map_lookup_elem(&allowed_ports, &key);
> +
> +               if (!value)
> +                       break;
> +               // 0 is a terminator value. Check it first to avoid matching on
> +               // a forbidden port == 0 and returning true.

please no C++ comments (everywhere)

> +               if (*value == 0)
> +                       break;
> +
> +               if (*value == port)
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +

[...]
