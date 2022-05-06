Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8AF451E144
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 23:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444547AbiEFVnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 17:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352550AbiEFVnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 17:43:02 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AC66FA13;
        Fri,  6 May 2022 14:39:18 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id m6so9457004iob.4;
        Fri, 06 May 2022 14:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OshuYdi3mkXkKwphYHfoNTYLlgVkbS/n5H63gaEbdPA=;
        b=BnBLKDdkE01B9gzYpT7+xo6GROb0grAE8OQ4omX6+dHMoKyVvW7PXddFZK/pWv1fRH
         l81dqcMxUa8eaOCF53wRE/GCxN71rSn+Ty8et7r8Z68AgWt4BOLLOs8ubqf3gza5TE2F
         Lcmrb78xwTR20VL6KbW/wZoT/F0azeeIpDA7P6h6yt3wAnEQOGfDig7++iARuYYCDVHS
         B6gmvhg51x74JnqQ1LH9RymEO8Rs13oDHUew7mSCsPw9Rfb2qltSveTWJ3luhX7VaAFr
         DArUO6vZ/m5/1zPU9h9QotL7O2UiA5EY8qe6zczCsPbRpIVJ1pVMrXxdVMgk3xjFtgy4
         3azw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OshuYdi3mkXkKwphYHfoNTYLlgVkbS/n5H63gaEbdPA=;
        b=x5cbmbs+62YTGMcZE8pveZfF5XOe9aiaKStRBKZDHtSzOXiiWCNDmK6ZBXBSMZCmcm
         XJJ9uvzyKsexhBvLJMHJJta5Kb20RBy53yJMHwQEE8xQexTmUDyrlp7RlihF12eMOHR9
         RByRuRVFzYwIsfFlbauBtwVt4cbDfbKi6a4bq1ew7T0h4NJcJwC0vUhnBSz2ZgCGVAd8
         lxifWsCOvPG3Lv5RZjVwVOMEKaaII7fd3aycKgnHaagTJBU7Q6A9E2p8JbM4nePtZr0v
         59egMqmJ7GIuDGVyg7Zp53f+0Bzoe3okKhvFWbecE1doG15/M37tA0V2IDuRByw2dnAh
         0VGQ==
X-Gm-Message-State: AOAM530m9eWGA43frfkb40CFuV8r32/oonxp/LiyG4/FJNyD4y8VO/Xo
        Hqk1AXA0RXlulFXSy2aKTQ8xEJMfJmRiU03tzRw=
X-Google-Smtp-Source: ABdhPJwFKqekhY9a+lweru+5CWuqFc5GrgqmwTckqf7ouwymeFmW8jRzIamCDCok1zRHz7O73y2QMlywtPqhwS13u3o=
X-Received: by 2002:a02:5d47:0:b0:32b:4387:51c8 with SMTP id
 w68-20020a025d47000000b0032b438751c8mr2349692jaa.103.1651873157649; Fri, 06
 May 2022 14:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220503171437.666326-1-maximmi@nvidia.com> <20220503171437.666326-6-maximmi@nvidia.com>
In-Reply-To: <20220503171437.666326-6-maximmi@nvidia.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 May 2022 14:39:06 -0700
Message-ID: <CAEf4BzZRHsW=e40+ZD7GAnUr+03GroouxpF82zO7GoBjrGBB7A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 5/5] bpf: Allow the new syncookie helpers to
 work with SKBs
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
> This commits allows the new BPF helpers to work in SKB context (in TC
> BPF programs): bpf_tcp_raw_{gen,check}_syncookie_ipv{4,6}.
>
> The sample application and selftest are updated to support the TC mode.
> It's not the recommended mode of operation, because the SKB is already
> created at this point, and it's unlikely that the BPF program will
> provide any substantional speedup compared to regular SYN cookies or
> synproxy.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  net/core/filter.c                             |  10 ++
>  .../selftests/bpf/prog_tests/xdp_synproxy.c   |  53 +++++--
>  .../selftests/bpf/progs/xdp_synproxy_kern.c   | 141 +++++++++++++-----
>  tools/testing/selftests/bpf/xdp_synproxy.c    |  94 +++++++++---

please split selftests and kernel code into separate patches (and use
selftests/bpf: prefix for selftests)

>  4 files changed, 230 insertions(+), 68 deletions(-)
>

[...]

> @@ -87,7 +112,11 @@ void test_xdp_synproxy(void)
>         if (!ASSERT_OK_PTR(ns, "setns"))
>                 goto out;
>
> -       ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --single");
> +       if (xdp)
> +               ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --single");
> +       else
> +               ctrl_file = SYS_OUT("./xdp_synproxy --prog %s --single",
> +                                   prog_id);
>         size = fread(buf, 1, sizeof(buf), ctrl_file);
>         pclose(ctrl_file);
>         if (!ASSERT_TRUE(expect_str(buf, size, "Total SYNACKs generated: 1\n"),
> @@ -107,3 +136,9 @@ void test_xdp_synproxy(void)
>         system("ip link del tmp0");
>         system("ip netns del synproxy");
>  }
> +
> +void test_xdp_synproxy(void)
> +{
> +       test_synproxy(true);
> +       test_synproxy(false);

let's model this as subtests instead? See test__start_subtest() use in
other selftests

> +}
> diff --git a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
> index 9ae85b189072..f70b5f776dcf 100644
> --- a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
> +++ b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
> @@ -7,6 +7,9 @@
>  #include <bpf/bpf_endian.h>
>  #include <asm/errno.h>
>

[...]

> @@ -201,21 +220,50 @@ static int syncookie_attach(const char *argv0, unsigned int ifindex)
>                 fprintf(stderr, "Error: bpf_obj_get_info_by_fd: %s\n", strerror(-err));
>                 goto out;
>         }
> +       attached_tc = tc;
>         attached_prog_id = info.id;
>         signal(SIGINT, cleanup);
>         signal(SIGTERM, cleanup);
> -       err = bpf_xdp_attach(ifindex, prog_fd, XDP_FLAGS_UPDATE_IF_NOEXIST, NULL);
> -       if (err < 0) {
> -               fprintf(stderr, "Error: bpf_set_link_xdp_fd: %s\n", strerror(-err));
> -               signal(SIGINT, SIG_DFL);
> -               signal(SIGTERM, SIG_DFL);
> -               attached_prog_id = 0;
> -               goto out;
> +       if (tc) {
> +               DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook,

nit: LIBBPF_OPTS is shorter, DECLARE_LIBBPF_OPTS is discouraged

> +                                   .ifindex = ifindex,
> +                                   .attach_point = BPF_TC_INGRESS);
> +               DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts,
> +                                   .handle = 1,
> +                                   .priority = 1,
> +                                   .prog_fd = prog_fd);
> +

[...]
