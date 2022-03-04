Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72194CE0A7
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiCDXMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiCDXMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:12:21 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA7227B8E1;
        Fri,  4 Mar 2022 15:11:27 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id k7so7632918ilo.8;
        Fri, 04 Mar 2022 15:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JjwSb7R1n2qpR7tlhhF3QjARWFXB3APeNzXlJxgM55o=;
        b=Kz4pTHjuVXNkCIWzktgwe4FPORUdWg/EwldbaxLftYJbGZTF/Vhg9LLnscOsF09Rj3
         cM2BcvAnjPo0pHjOFfxB8mrdhGxAf7c301q+vxRn9x7W1sfLikGgPnZqci4zXaR+IKRs
         HSoPNTJQJt7aLkfsFP7WiBEOk42g9fVms2jzEcKCf1QZg4loMeVymXclpV3UqRtWN1Cp
         xvRkN8T1mG2VSVmgH7yO043xsRrNJoHQG8eS0N3EV+TWkGYbvjD4NybBNaeuwU5j+KQb
         aXK5CR5gpNNEP0KktsWFPb8hoW78/7g2wc125r3Hc4nIFtPoU/BxbN3C4BUvBe4zc+YW
         UVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JjwSb7R1n2qpR7tlhhF3QjARWFXB3APeNzXlJxgM55o=;
        b=ShYgpKT4+RPMC1HYYsAC5XJhQPovYPrCMQdhhnvWQxqrPsJ/9xi2gr6m/Ei2b8EDk4
         4RaIFzfg3YP53ePOKWJQ4CMXxORKDXp9iDdNWnK8JX+tpQBeBeeDew6PaiR2qrtKoaLS
         UCVBa+K8UOaH121suUeysoqqgd5v5BaNS04VmdE/phveaJkK2wGzcMJCAUQKZN3M2qV+
         QjVlSYhW6VlS2jtianGQaUhTJK1Yo3E3fg+n+PDgQW0ek40QVklGbjK+s+QqnMic+fYR
         luovWX1gi9SgZGEwDBknP/pMYVc27eYdVAVJdV/GApjb2r2Nglo4fUidfhzJyJu6OHZk
         OU+Q==
X-Gm-Message-State: AOAM5324cMgoDqiP0lKaAkT92HNJqZwo1q50payi93JM60SaKVIrsr70
        g3lCEbPe3aBnBv+cCDiHUNhYgFk0p1aqWoxpQ8E=
X-Google-Smtp-Source: ABdhPJxSzbHqmJoBlz56TrF+bBLxS1uvyIO6GO5aJ8D4+jehb/g+9Slf+xvr64KuMoG8XGxBjeoxoDdns87sbmatMGw=
X-Received: by 2002:a92:d241:0:b0:2c6:d22:27cf with SMTP id
 v1-20020a92d241000000b002c60d2227cfmr851207ilg.98.1646435487387; Fri, 04 Mar
 2022 15:11:27 -0800 (PST)
MIME-Version: 1.0
References: <20220222170600.611515-1-jolsa@kernel.org> <20220222170600.611515-8-jolsa@kernel.org>
In-Reply-To: <20220222170600.611515-8-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Mar 2022 15:11:16 -0800
Message-ID: <CAEf4BzYdSwPfiTmP-vBry23F7+vDR3Q+r0qwuQ3OaL09YjxUew@mail.gmail.com>
Subject: Re: [PATCH 07/10] libbpf: Add bpf_link_create support for multi kprobes
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
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

On Tue, Feb 22, 2022 at 9:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding new kprobe_multi struct to bpf_link_create_opts object
> to pass multiple kprobe data to link_create attr uapi.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/bpf.c | 7 +++++++
>  tools/lib/bpf/bpf.h | 9 ++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 418b259166f8..5e180def2cef 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -853,6 +853,13 @@ int bpf_link_create(int prog_fd, int target_fd,
>                 if (!OPTS_ZEROED(opts, perf_event))
>                         return libbpf_err(-EINVAL);
>                 break;
> +       case BPF_TRACE_KPROBE_MULTI:
> +               attr.link_create.kprobe_multi.syms = OPTS_GET(opts, kprobe_multi.syms, 0);
> +               attr.link_create.kprobe_multi.addrs = OPTS_GET(opts, kprobe_multi.addrs, 0);
> +               attr.link_create.kprobe_multi.cookies = OPTS_GET(opts, kprobe_multi.cookies, 0);
> +               attr.link_create.kprobe_multi.cnt = OPTS_GET(opts, kprobe_multi.cnt, 0);
> +               attr.link_create.kprobe_multi.flags = OPTS_GET(opts, kprobe_multi.flags, 0);
> +               break;
>         default:
>                 if (!OPTS_ZEROED(opts, flags))
>                         return libbpf_err(-EINVAL);
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 16b21757b8bf..bd285a8f3420 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -413,10 +413,17 @@ struct bpf_link_create_opts {
>                 struct {
>                         __u64 bpf_cookie;
>                 } perf_event;
> +               struct {
> +                       __u64 syms;
> +                       __u64 addrs;
> +                       __u64 cookies;

hm, I think we can and should use proper types here, no?

const char **syms;
const void **addrs;
const __u64 *cookies;

?




> +                       __u32 cnt;
> +                       __u32 flags;
> +               } kprobe_multi;
>         };
>         size_t :0;
>  };
> -#define bpf_link_create_opts__last_field perf_event
> +#define bpf_link_create_opts__last_field kprobe_multi.flags
>
>  LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
>                                enum bpf_attach_type attach_type,
> --
> 2.35.1
>
