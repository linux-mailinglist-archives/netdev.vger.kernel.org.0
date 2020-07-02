Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2332123FE
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbgGBM7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729084AbgGBM7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 08:59:08 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370C2C08C5DC
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 05:59:08 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id p20so29399569ejd.13
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 05:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=S1wfAn53eyRB63woa5Wi2B6BJD6vrhl52IDqeLWsB24=;
        b=u0lpdni5mexeyxsWyeysTjdNv28ThEKamDB8EkFytThJmG/wvbHOsl8jkfU9tiC+hF
         DMwLPmCHDIIC2M7RPUVpkexGYg6fQW3lsgstOY+woxz7wkb0gYR7jbZLbQf3nAzbNC4E
         6mma2fG3iOg3nmyLAb8B4b+9qwCo6vHStO5KU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=S1wfAn53eyRB63woa5Wi2B6BJD6vrhl52IDqeLWsB24=;
        b=D8XjdJPin+qPScNMWpf/Cz/ur3gXCXhC1ZNntkQZagPC+t0M9AHqubrrYP65/7eR6Q
         fFU0svWjFH0DVaA505fQs5l1+/ygDohXNtxyXvwWnQcIP7YXyBnWCbi6+wRFcAgXe161
         y8gppvz+MamhBs+n818osDB3KgukoAqkOrSoELid/t0izeX/sow2yeQjBeVbQVJ76b/d
         qqUtfnsxZGkN51/IFMyfrIWv49Sbn6TfFBwprFKSOoYavtXsdCtLeRhcOCyeOFFzE3rd
         NL7lP6xbAZpLSWVQNIvt1atDPfBzueW2+9f5nQrShvsyXW050KArgYqRIMD0vpgCtLbV
         p7cQ==
X-Gm-Message-State: AOAM531+5Ig5kKs8+w4lscu9gjyQF1rOM+hLAN5s7Nl01xElCSeJ8hRJ
        JRil4/KXUWAs6L0SASKoD4PWcg==
X-Google-Smtp-Source: ABdhPJyNBmE1p78wxUYvudsndF5WF8xdkQy+29pdRgS+VifrAn0v5D4yBCP5d1tQbjMOYPp0UM5idQ==
X-Received: by 2002:a17:906:f88a:: with SMTP id lg10mr26929553ejb.317.1593694746791;
        Thu, 02 Jul 2020 05:59:06 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id cw19sm6846665ejb.39.2020.07.02.05.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 05:59:06 -0700 (PDT)
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-17-jakub@cloudflare.com> <CACAyw98-DaSJ6ZkDv=7Cr62SK1yjvrJVTnz4CrAcvgT-2qqkug@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next v3 16/16] selftests/bpf: Tests for BPF_SK_LOOKUP attach point
In-reply-to: <CACAyw98-DaSJ6ZkDv=7Cr62SK1yjvrJVTnz4CrAcvgT-2qqkug@mail.gmail.com>
Date:   Thu, 02 Jul 2020 14:59:05 +0200
Message-ID: <87lfk2nkdi.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 01:01 PM CEST, Lorenz Bauer wrote:
> On Thu, 2 Jul 2020 at 10:24, Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Add tests to test_progs that exercise:
>>
>>  - attaching/detaching/querying programs to BPF_SK_LOOKUP hook,
>>  - redirecting socket lookup to a socket selected by BPF program,
>>  - failing a socket lookup on BPF program's request,
>>  - error scenarios for selecting a socket from BPF program,
>>  - accessing BPF program context,
>>  - attaching and running multiple BPF programs.
>>
>> Run log:
>> | # ./test_progs -n 68
>> | #68/1 query lookup prog:OK
>> | #68/2 TCP IPv4 redir port:OK
>> | #68/3 TCP IPv4 redir addr:OK
>> | #68/4 TCP IPv4 redir with reuseport:OK
>> | #68/5 TCP IPv4 redir skip reuseport:OK
>> | #68/6 TCP IPv6 redir port:OK
>> | #68/7 TCP IPv6 redir addr:OK
>> | #68/8 TCP IPv4->IPv6 redir port:OK
>> | #68/9 TCP IPv6 redir with reuseport:OK
>> | #68/10 TCP IPv6 redir skip reuseport:OK
>> | #68/11 UDP IPv4 redir port:OK
>> | #68/12 UDP IPv4 redir addr:OK
>> | #68/13 UDP IPv4 redir with reuseport:OK
>> | #68/14 UDP IPv4 redir skip reuseport:OK
>> | #68/15 UDP IPv6 redir port:OK
>> | #68/16 UDP IPv6 redir addr:OK
>> | #68/17 UDP IPv4->IPv6 redir port:OK
>> | #68/18 UDP IPv6 redir and reuseport:OK
>> | #68/19 UDP IPv6 redir skip reuseport:OK
>> | #68/20 TCP IPv4 drop on lookup:OK
>> | #68/21 TCP IPv6 drop on lookup:OK
>> | #68/22 UDP IPv4 drop on lookup:OK
>> | #68/23 UDP IPv6 drop on lookup:OK
>> | #68/24 TCP IPv4 drop on reuseport:OK
>> | #68/25 TCP IPv6 drop on reuseport:OK
>> | #68/26 UDP IPv4 drop on reuseport:OK
>> | #68/27 TCP IPv6 drop on reuseport:OK
>> | #68/28 sk_assign returns EEXIST:OK
>> | #68/29 sk_assign honors F_REPLACE:OK
>> | #68/30 access ctx->sk:OK
>> | #68/31 sk_assign rejects TCP established:OK
>> | #68/32 sk_assign rejects UDP connected:OK
>> | #68/33 multi prog - pass, pass:OK
>> | #68/34 multi prog - pass, inval:OK
>> | #68/35 multi prog - inval, pass:OK
>> | #68/36 multi prog - drop, drop:OK
>> | #68/37 multi prog - pass, drop:OK
>> | #68/38 multi prog - drop, pass:OK
>> | #68/39 multi prog - drop, inval:OK
>> | #68/40 multi prog - inval, drop:OK
>> | #68/41 multi prog - pass, redir:OK
>> | #68/42 multi prog - redir, pass:OK
>> | #68/43 multi prog - drop, redir:OK
>> | #68/44 multi prog - redir, drop:OK
>> | #68/45 multi prog - inval, redir:OK
>> | #68/46 multi prog - redir, inval:OK
>> | #68/47 multi prog - redir, redir:OK
>> | #68 sk_lookup:OK
>> | Summary: 1/47 PASSED, 0 SKIPPED, 0 FAILED
>>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>
>> Notes:
>>     v3:
>>     - Extend tests to cover new functionality in v3:
>>       - multi-prog attachments (query, running, verdict precedence)
>>       - socket selecting for the second time with bpf_sk_assign
>>       - skipping over reuseport load-balancing
>>
>>     v2:
>>      - Adjust for fields renames in struct bpf_sk_lookup.
>>
>>  .../selftests/bpf/prog_tests/sk_lookup.c      | 1353 +++++++++++++++++
>>  .../selftests/bpf/progs/test_sk_lookup_kern.c |  399 +++++
>>  2 files changed, 1752 insertions(+)
>>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_lookup.c
>>  create mode 100644 tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
>> new file mode 100644
>> index 000000000000..2859dc7e65b0
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c

[...]

>> +static void query_lookup_prog(struct test_sk_lookup_kern *skel)
>> +{
>> +       struct bpf_link *link[3] = {};
>> +       __u32 attach_flags = 0;
>> +       __u32 prog_ids[3] = {};
>> +       __u32 prog_cnt = 3;
>> +       __u32 prog_id;
>> +       int net_fd;
>> +       int err;
>> +
>> +       net_fd = open("/proc/self/ns/net", O_RDONLY);
>> +       if (CHECK_FAIL(net_fd < 0)) {
>> +               log_err("failed to open /proc/self/ns/net");
>> +               return;
>> +       }
>> +
>> +       link[0] = attach_lookup_prog(skel->progs.lookup_pass);
>> +       if (!link[0])
>> +               goto close;
>> +       link[1] = attach_lookup_prog(skel->progs.lookup_pass);
>> +       if (!link[1])
>> +               goto detach;
>> +       link[2] = attach_lookup_prog(skel->progs.lookup_drop);
>> +       if (!link[2])
>> +               goto detach;
>> +
>> +       err = bpf_prog_query(net_fd, BPF_SK_LOOKUP, 0 /* query flags */,
>> +                            &attach_flags, prog_ids, &prog_cnt);
>> +       if (CHECK_FAIL(err)) {
>> +               log_err("failed to query lookup prog");
>> +               goto detach;
>> +       }
>> +
>> +       system("/home/jkbs/src/linux/tools/bpf/bpftool/bpftool link show");
>
> This is to make sure that I read all of the tests as well? ;P

Ha! Yes!

Of course, my bad. A left-over from debugging a test I extended last
minute to cover prog query when multiple programs are attached.

Thanks for reading through it all, though.

>
>> +
>> +       errno = 0;
>> +       if (CHECK_FAIL(attach_flags != 0)) {
>> +               log_err("wrong attach_flags on query: %u", attach_flags);
>> +               goto detach;
>> +       }
>> +       if (CHECK_FAIL(prog_cnt != 3)) {
>> +               log_err("wrong program count on query: %u", prog_cnt);
>> +               goto detach;
>> +       }
>> +       prog_id = link_info_prog_id(link[0]);
>> +       if (CHECK_FAIL(prog_ids[0] != prog_id)) {
>> +               log_err("invalid program id on query: %u != %u",
>> +                       prog_ids[0], prog_id);
>> +               goto detach;
>> +       }
>> +       prog_id = link_info_prog_id(link[1]);
>> +       if (CHECK_FAIL(prog_ids[1] != prog_id)) {
>> +               log_err("invalid program id on query: %u != %u",
>> +                       prog_ids[1], prog_id);
>> +               goto detach;
>> +       }
>> +       prog_id = link_info_prog_id(link[2]);
>> +       if (CHECK_FAIL(prog_ids[2] != prog_id)) {
>> +               log_err("invalid program id on query: %u != %u",
>> +                       prog_ids[2], prog_id);
>> +               goto detach;
>> +       }
>> +
>> +detach:
>> +       if (link[2])
>> +               bpf_link__destroy(link[2]);
>> +       if (link[1])
>> +               bpf_link__destroy(link[1]);
>> +       if (link[0])
>> +               bpf_link__destroy(link[0]);
>> +close:
>> +       close(net_fd);
>> +}
>> +
>> +static void run_lookup_prog(const struct test *t)
>> +{
>> +       int client_fd, server_fds[MAX_SERVERS] = { -1 };
>> +       struct bpf_link *lookup_link;
>> +       int i, err;
>> +
>> +       lookup_link = attach_lookup_prog(t->lookup_prog);
>> +       if (!lookup_link)
>
> Why doesn't this fail the test? Same for the other error paths in the
> function, and the other helpers.

I took the approach of placing CHECK_FAIL checks only right after the
failure point. So a syscall or a call to libbpf.

This way if I'm calling a helper, I know it already fails the test if
anything goes wrong, and I can have less CHECK_FAILs peppered over the
code.

[...]

>> diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
>> new file mode 100644
>> index 000000000000..75745898fd3b
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
>> @@ -0,0 +1,399 @@
>> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
>> +// Copyright (c) 2020 Cloudflare
>> +
>> +#include <errno.h>
>> +#include <linux/bpf.h>
>> +#include <sys/socket.h>
>> +
>> +#include <bpf/bpf_endian.h>
>> +#include <bpf/bpf_helpers.h>
>> +
>> +#define IP4(a, b, c, d)                                        \
>> +       bpf_htonl((((__u32)(a) & 0xffU) << 24) |        \
>> +                 (((__u32)(b) & 0xffU) << 16) |        \
>> +                 (((__u32)(c) & 0xffU) <<  8) |        \
>> +                 (((__u32)(d) & 0xffU) <<  0))
>> +#define IP6(aaaa, bbbb, cccc, dddd)                    \
>> +       { bpf_htonl(aaaa), bpf_htonl(bbbb), bpf_htonl(cccc), bpf_htonl(dddd) }
>> +
>> +#define MAX_SOCKS 32
>> +
>> +struct {
>> +       __uint(type, BPF_MAP_TYPE_SOCKMAP);
>> +       __uint(max_entries, MAX_SOCKS);
>> +       __type(key, __u32);
>> +       __type(value, __u64);
>> +} redir_map SEC(".maps");
>> +
>> +struct {
>> +       __uint(type, BPF_MAP_TYPE_ARRAY);
>> +       __uint(max_entries, 2);
>> +       __type(key, int);
>> +       __type(value, int);
>> +} run_map SEC(".maps");
>> +
>> +enum {
>> +       PROG1 = 0,
>> +       PROG2,
>> +};
>> +
>> +enum {
>> +       SERVER_A = 0,
>> +       SERVER_B,
>> +};
>> +
>> +/* Addressable key/value constants for convenience */
>> +static const int KEY_PROG1 = PROG1;
>> +static const int KEY_PROG2 = PROG2;
>> +static const int PROG_DONE = 1;
>> +
>> +static const __u32 KEY_SERVER_A = SERVER_A;
>> +static const __u32 KEY_SERVER_B = SERVER_B;
>> +
>> +static const __u32 DST_PORT = 7007;
>> +static const __u32 DST_IP4 = IP4(127, 0, 0, 1);
>> +static const __u32 DST_IP6[] = IP6(0xfd000000, 0x0, 0x0, 0x00000001);
>> +
>> +SEC("sk_lookup/lookup_pass")
>> +int lookup_pass(struct bpf_sk_lookup *ctx)
>> +{
>> +       return BPF_OK;
>> +}
>> +
>> +SEC("sk_lookup/lookup_drop")
>> +int lookup_drop(struct bpf_sk_lookup *ctx)
>> +{
>> +       return BPF_DROP;
>> +}
>> +
>> +SEC("sk_reuseport/reuse_pass")
>> +int reuseport_pass(struct sk_reuseport_md *ctx)
>> +{
>> +       return SK_PASS;
>> +}
>> +
>> +SEC("sk_reuseport/reuse_drop")
>> +int reuseport_drop(struct sk_reuseport_md *ctx)
>> +{
>> +       return SK_DROP;
>> +}
>> +
>> +/* Redirect packets destined for port DST_PORT to socket at redir_map[0]. */
>> +SEC("sk_lookup/redir_port")
>> +int redir_port(struct bpf_sk_lookup *ctx)
>> +{
>> +       struct bpf_sock *sk;
>> +       int err;
>> +
>> +       if (ctx->local_port != DST_PORT)
>> +               return BPF_OK;
>> +
>> +       sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
>> +       if (!sk)
>> +               return BPF_OK;
>> +
>> +       err = bpf_sk_assign(ctx, sk, 0);
>> +       bpf_sk_release(sk);
>> +       return err ? BPF_DROP : BPF_REDIRECT;
>> +}
>> +
>> +/* Redirect packets destined for DST_IP4 address to socket at redir_map[0]. */
>> +SEC("sk_lookup/redir_ip4")
>> +int redir_ip4(struct bpf_sk_lookup *ctx)
>> +{
>> +       struct bpf_sock *sk;
>> +       int err;
>> +
>> +       if (ctx->family != AF_INET)
>> +               return BPF_OK;
>> +       if (ctx->local_port != DST_PORT)
>> +               return BPF_OK;
>> +       if (ctx->local_ip4 != DST_IP4)
>> +               return BPF_OK;
>> +
>> +       sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
>> +       if (!sk)
>> +               return BPF_OK;
>> +
>> +       err = bpf_sk_assign(ctx, sk, 0);
>> +       bpf_sk_release(sk);
>> +       return err ? BPF_DROP : BPF_REDIRECT;
>> +}
>> +
>> +/* Redirect packets destined for DST_IP6 address to socket at redir_map[0]. */
>> +SEC("sk_lookup/redir_ip6")
>> +int redir_ip6(struct bpf_sk_lookup *ctx)
>> +{
>> +       struct bpf_sock *sk;
>> +       int err;
>> +
>> +       if (ctx->family != AF_INET6)
>> +               return BPF_OK;
>> +       if (ctx->local_port != DST_PORT)
>> +               return BPF_OK;
>> +       if (ctx->local_ip6[0] != DST_IP6[0] ||
>> +           ctx->local_ip6[1] != DST_IP6[1] ||
>> +           ctx->local_ip6[2] != DST_IP6[2] ||
>> +           ctx->local_ip6[3] != DST_IP6[3])
>> +               return BPF_OK;
>> +
>> +       sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
>> +       if (!sk)
>> +               return BPF_OK;
>> +
>> +       err = bpf_sk_assign(ctx, sk, 0);
>> +       bpf_sk_release(sk);
>> +       return err ? BPF_DROP : BPF_REDIRECT;
>> +}
>> +
>> +SEC("sk_lookup/select_sock_a")
>> +int select_sock_a(struct bpf_sk_lookup *ctx)
>
> Nit: you could have a function __force_inline__
> select_sock_helper(ctx, key, flags)
> and then call that from select_sock_a, select_sock_a_no_reuseport, etc.
> That might help cut down on code duplication.

I will play with that. Thanks for the idea.

Overall I realize tests could use more polishing. I was focusing on
coverage first to demonstrate correctness. But am planning improving
code sharing.

>
>> +{
>> +       struct bpf_sock *sk;
>> +       int err;
>> +
>> +       sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
>> +       if (!sk)
>> +               return BPF_OK;
>> +
>> +       err = bpf_sk_assign(ctx, sk, 0);
>> +       bpf_sk_release(sk);
>> +       return err ? BPF_DROP : BPF_REDIRECT;
>> +}
>> +
>> +SEC("sk_lookup/select_sock_a_no_reuseport")
>> +int select_sock_a_no_reuseport(struct bpf_sk_lookup *ctx)
>> +{
>> +       struct bpf_sock *sk;
>> +       int err;
>> +
>> +       sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
>> +       if (!sk)
>> +               return BPF_DROP;
>> +
>> +       err = bpf_sk_assign(ctx, sk, BPF_SK_LOOKUP_F_NO_REUSEPORT);
>> +       bpf_sk_release(sk);
>> +       return err ? BPF_DROP : BPF_REDIRECT;
>> +}
>> +
>> +SEC("sk_reuseport/select_sock_b")
>> +int select_sock_b(struct sk_reuseport_md *ctx)
>> +{
>> +       __u32 key = KEY_SERVER_B;
>> +       int err;
>> +
>> +       err = bpf_sk_select_reuseport(ctx, &redir_map, &key, 0);
>> +       return err ? SK_DROP : SK_PASS;
>> +}
>> +

[...]
