Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307E24CE0AB
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiCDXMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiCDXMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:12:15 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B6F27B90D;
        Fri,  4 Mar 2022 15:11:20 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id u8so289655ilv.0;
        Fri, 04 Mar 2022 15:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CQ3PJ1ZVq3VJEavBK8fHBy6EqWFvCJ0UjFc5QnS3yfE=;
        b=A3zJOT5lY7B5Pt/WCHXUtAPLOvgMp2p7VDryda/4MRhN85WK6eMHOKHnVCE9wyWSk4
         7IOXYkuJky/9X5CujCnLZczMz1AnvlHcHDAaAg/IWq5ZE8izuBsRF1DJ/zDUq3Myj/rT
         uJgSEq/ChonqZKwohY7cRqiOBmzTc4NStRzRHk6FncnYI0z0OKQe4TOVh/jQCbkIr7xS
         ppUx3aKJ1WE19kaS/s6Y88ukN6ML2Cz2LwZ6Mh/05GVU96hO4eyuC35+etJzYfFyP6YJ
         ja6RpPfmI1HQ+ezuQJfkADf/UGrsdjoclrPaq0i83o8C014CzAe47it1D1AxIYoTmNT3
         bDaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CQ3PJ1ZVq3VJEavBK8fHBy6EqWFvCJ0UjFc5QnS3yfE=;
        b=Yaap0EAJFgazAaeXoFPTNR0aMBdhCUNSZagEvM8SGfPn6JvvGMUxT09A9Qc5BxwVIX
         dfiACDKKJ/liuUJ3T6vRVWlZDtFx1IR6TrhfvyPys/NajJGjgJZEDDSeQVC2ARWk8F5V
         bNQVOV4TU3aKkJpcsuVsv6ZHjSIjIT/RogfSE9qJuLlajonIgykkvf3PGJTem8vP9WSw
         JkNKmHqJnDtszkPGqUxW+WD7coL0o5cUi85n6DgHNe6V58rPPL/Ru0sZBQFZQThcMCKS
         6PF1hbcggViOLPSp6AjCaVuJq+jlU9NXFGt/eff9T8P6RtHXQrIpRTFhPPwa9K0O51mJ
         +fTw==
X-Gm-Message-State: AOAM531FkEAb6aGLpMuNAiWlIN+DMKNcM/DKh1tTtR61M3u+WvSQ0awm
        JVZ0xsj2A7FD6PARLAlQ2sdQ3PkErHWCp3PusOE=
X-Google-Smtp-Source: ABdhPJzS66hDJzQmAcsbASbUC//fWAS6rH78pT+W91L+QJ8VeHZNVezlHu8set2ACwIcXVkxZwdncmYgIyLToybWJRU=
X-Received: by 2002:a92:6406:0:b0:2bb:f1de:e13e with SMTP id
 y6-20020a926406000000b002bbf1dee13emr814382ilb.305.1646435479739; Fri, 04 Mar
 2022 15:11:19 -0800 (PST)
MIME-Version: 1.0
References: <20220222170600.611515-1-jolsa@kernel.org> <20220222170600.611515-6-jolsa@kernel.org>
In-Reply-To: <20220222170600.611515-6-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Mar 2022 15:11:08 -0800
Message-ID: <CAEf4Bzab_crw+e_POJ39E+JkBDG4WJQqDGz-8Gz_JOt0rYnigA@mail.gmail.com>
Subject: Re: [PATCH 05/10] bpf: Add cookie support to programs attached with
 kprobe multi link
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
> Adding support to call bpf_get_attach_cookie helper from
> kprobe programs attached with kprobe multi link.
>
> The cookie is provided by array of u64 values, where each
> value is paired with provided function address or symbol
> with the same array index.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/sort.h           |   2 +
>  include/uapi/linux/bpf.h       |   1 +
>  kernel/trace/bpf_trace.c       | 103 ++++++++++++++++++++++++++++++++-
>  lib/sort.c                     |   2 +-
>  tools/include/uapi/linux/bpf.h |   1 +
>  5 files changed, 107 insertions(+), 2 deletions(-)
>

[...]

>  BPF_CALL_1(bpf_get_attach_cookie_trace, void *, ctx)
>  {
>         struct bpf_trace_run_ctx *run_ctx;
> @@ -1297,7 +1312,9 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                         &bpf_get_func_ip_proto_kprobe_multi :
>                         &bpf_get_func_ip_proto_kprobe;
>         case BPF_FUNC_get_attach_cookie:
> -               return &bpf_get_attach_cookie_proto_trace;
> +               return prog->expected_attach_type == BPF_TRACE_KPROBE_MULTI ?
> +                       &bpf_get_attach_cookie_proto_kmulti :
> +                       &bpf_get_attach_cookie_proto_trace;
>         default:
>                 return bpf_tracing_func_proto(func_id, prog);
>         }
> @@ -2203,6 +2220,9 @@ struct bpf_kprobe_multi_link {
>         struct bpf_link link;
>         struct fprobe fp;
>         unsigned long *addrs;
> +       struct bpf_run_ctx run_ctx;

clever, I like it! Keep in mind, though, that this trick can only be
used here because this run_ctx is read-only (I'd leave the comment
here about this, I didn't realize immediately that this approach can't
be used for run_ctx that needs to be modified).

> +       u64 *cookies;
> +       u32 cnt;
>  };
>
>  static void bpf_kprobe_multi_link_release(struct bpf_link *link)
> @@ -2219,6 +2239,7 @@ static void bpf_kprobe_multi_link_dealloc(struct bpf_link *link)
>
>         kmulti_link = container_of(link, struct bpf_kprobe_multi_link, link);
>         kvfree(kmulti_link->addrs);
> +       kvfree(kmulti_link->cookies);
>         kfree(kmulti_link);
>  }
>
> @@ -2227,10 +2248,57 @@ static const struct bpf_link_ops bpf_kprobe_multi_link_lops = {
>         .dealloc = bpf_kprobe_multi_link_dealloc,
>  };
>
> +static void bpf_kprobe_multi_cookie_swap(void *a, void *b, int size, const void *priv)
> +{
> +       const struct bpf_kprobe_multi_link *link = priv;
> +       unsigned long *addr_a = a, *addr_b = b;
> +       u64 *cookie_a, *cookie_b;
> +
> +       cookie_a = link->cookies + (addr_a - link->addrs);
> +       cookie_b = link->cookies + (addr_b - link->addrs);
> +
> +       swap_words_64(addr_a, addr_b, size);
> +       swap_words_64(cookie_a, cookie_b, size);

is it smart to call (now) non-inlined function just to swap two longs
and u64s?..

unsigned long tmp1;
u64 tmp2;

tmp1 = *addr_a; *addr_a = addr_b; *addr_b = tmp1;
tmp2 = *cookie_a; *cookie_a = cookie_b; *cookie_b = tmp2;

?

> +}
> +
> +static int __bpf_kprobe_multi_cookie_cmp(const void *a, const void *b)
> +{
> +       const unsigned long *addr_a = a, *addr_b = b;
> +
> +       if (*addr_a == *addr_b)
> +               return 0;
> +       return *addr_a < *addr_b ? -1 : 1;
> +}
> +

[...]

> @@ -2238,12 +2306,16 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
>                 goto out;
>         }
>
> +       old_run_ctx = bpf_set_run_ctx(&link->run_ctx);
> +
>         rcu_read_lock();

so looking at other code, I see that we first migrate_disable() and
then rcu_read_lock(), so let's swap? We also normally set/reset
run_ctx inside migrate+rcu_lock region. I'm not sure that's necessary,
but also shouldn't hurt to stay consistent.

>         migrate_disable();
>         err = bpf_prog_run(link->link.prog, regs);
>         migrate_enable();
>         rcu_read_unlock();
>
> +       bpf_reset_run_ctx(old_run_ctx);
> +
>   out:
>         __this_cpu_dec(bpf_prog_active);
>         return err;

[...]

> diff --git a/lib/sort.c b/lib/sort.c
> index b399bf10d675..91f7ce701cf4 100644
> --- a/lib/sort.c
> +++ b/lib/sort.c
> @@ -80,7 +80,7 @@ static void swap_words_32(void *a, void *b, size_t n)
>   * but it's possible to have 64-bit loads without 64-bit pointers (e.g.
>   * x32 ABI).  Are there any cases the kernel needs to worry about?
>   */
> -static void swap_words_64(void *a, void *b, size_t n)
> +void swap_words_64(void *a, void *b, size_t n)

I'm worried that this might change performance unintentionally in
other places (making the function global might pessimize inlining, I
think). So let's not do that, just do a straightforward swap in cookie
support code?

>  {
>         do {
>  #ifdef CONFIG_64BIT
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 6c66138c1b9b..d18996502aac 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -1482,6 +1482,7 @@ union bpf_attr {
>                         struct {
>                                 __aligned_u64   syms;
>                                 __aligned_u64   addrs;
> +                               __aligned_u64   cookies;

looks a bit weird to change layout of UAPI. That's not really a
problem, because both patches will land at the same time. But if you
move flags and cnt to the front of the struct it would a bit better.


>                                 __u32           cnt;
>                                 __u32           flags;
>                         } kprobe_multi;
> --
> 2.35.1
>
