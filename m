Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E507C4CEC7C
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 18:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbiCFRaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 12:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCFRaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 12:30:03 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0535B275E7;
        Sun,  6 Mar 2022 09:29:11 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id p9so19915192wra.12;
        Sun, 06 Mar 2022 09:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tRKtixCq2vkVN92yBMRPljmnJXwe1i5rOdDIlOZzuDk=;
        b=J080D3g44Cklc4QlyLmGYLzaaUx4BtacJ+HReuhiJK9yjmk5dnBeVT7y+SdAWHR/QD
         Uc4JTiEaj32A7R8Hb5eGCKoc/n2rnjYeMFL0Py5bdvgGYeMc90YI4w11obnh1yMWkJ83
         h0nUDlP4i1F64eEIMxyMfmiZHalYqTzZOfzALs7lsIYH+LB4edjw5ClYj5Jyu6rV9H2F
         ricyAp4cbPFYkwFl0FWAM4PxrPQZkkaZluZAJybGRaDNcdlMAdEFsrNOsYQtHIsgtjnx
         PqofavJic5dFMgRe57wPfJ1ZaX5JFzBmxSm2AbALpP93zwr12soNELu1zMcQ8gim77Sn
         KEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tRKtixCq2vkVN92yBMRPljmnJXwe1i5rOdDIlOZzuDk=;
        b=7J7oBRqLHAH7UOlviraUTY9glShyjZ8emRAHFqwROtxdz1tOLgrHjRTI2FcgmUv48p
         Jg+RdNpCzrvr5wDLbBaqihG1rWjWvACGm9Id2oYGgxHgKCboO2YdMOWRkdzMSIiavkUb
         gf7mDE0apcDjIrj4NcsXbjl1dZ1lOqRmmwj2lvSDJWjk9rb0l2GM+YCF3XojtiM428ef
         1CD5g3PppNsgnap7C/kqej9V4VbQvCUcKTOnveL5p+cg1ZbF2V7u1cSVgw66zKMzO88W
         AdrzS2r2Ud3baypEFhAkY86FDAp0oWFBPKGW+oo6OFh06vIysE2sK3YmIFp2Nw+08sYA
         IAHg==
X-Gm-Message-State: AOAM5304QAbQJkFJ2cq+/aJEqLH/PlR0xY3lUXvqkz92pofuVDhdCLA0
        sH79FvECj3pphuwUjf7Fdc/CD4PdLfDlFg==
X-Google-Smtp-Source: ABdhPJz/8EBo34jh+L1IZNodNYVAdLwJUHAbHueCZwdVkoQ4z2ZjGCs/xRJdqxVlgRX9741ElMKCFw==
X-Received: by 2002:adf:f28a:0:b0:1f0:246e:11f8 with SMTP id k10-20020adff28a000000b001f0246e11f8mr5716448wro.481.1646587749465;
        Sun, 06 Mar 2022 09:29:09 -0800 (PST)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id r13-20020a5d498d000000b001f0587248c4sm8933998wrq.3.2022.03.06.09.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 09:29:09 -0800 (PST)
Date:   Sun, 6 Mar 2022 18:29:07 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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
Subject: Re: [PATCH 05/10] bpf: Add cookie support to programs attached with
 kprobe multi link
Message-ID: <YiTvY2Ly/XWICP2H@krava>
References: <20220222170600.611515-1-jolsa@kernel.org>
 <20220222170600.611515-6-jolsa@kernel.org>
 <CAEf4Bzab_crw+e_POJ39E+JkBDG4WJQqDGz-8Gz_JOt0rYnigA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzab_crw+e_POJ39E+JkBDG4WJQqDGz-8Gz_JOt0rYnigA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 03:11:08PM -0800, Andrii Nakryiko wrote:
> On Tue, Feb 22, 2022 at 9:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding support to call bpf_get_attach_cookie helper from
> > kprobe programs attached with kprobe multi link.
> >
> > The cookie is provided by array of u64 values, where each
> > value is paired with provided function address or symbol
> > with the same array index.
> >
> > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/sort.h           |   2 +
> >  include/uapi/linux/bpf.h       |   1 +
> >  kernel/trace/bpf_trace.c       | 103 ++++++++++++++++++++++++++++++++-
> >  lib/sort.c                     |   2 +-
> >  tools/include/uapi/linux/bpf.h |   1 +
> >  5 files changed, 107 insertions(+), 2 deletions(-)
> >
> 
> [...]
> 
> >  BPF_CALL_1(bpf_get_attach_cookie_trace, void *, ctx)
> >  {
> >         struct bpf_trace_run_ctx *run_ctx;
> > @@ -1297,7 +1312,9 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >                         &bpf_get_func_ip_proto_kprobe_multi :
> >                         &bpf_get_func_ip_proto_kprobe;
> >         case BPF_FUNC_get_attach_cookie:
> > -               return &bpf_get_attach_cookie_proto_trace;
> > +               return prog->expected_attach_type == BPF_TRACE_KPROBE_MULTI ?
> > +                       &bpf_get_attach_cookie_proto_kmulti :
> > +                       &bpf_get_attach_cookie_proto_trace;
> >         default:
> >                 return bpf_tracing_func_proto(func_id, prog);
> >         }
> > @@ -2203,6 +2220,9 @@ struct bpf_kprobe_multi_link {
> >         struct bpf_link link;
> >         struct fprobe fp;
> >         unsigned long *addrs;
> > +       struct bpf_run_ctx run_ctx;
> 
> clever, I like it! Keep in mind, though, that this trick can only be
> used here because this run_ctx is read-only (I'd leave the comment
> here about this, I didn't realize immediately that this approach can't
> be used for run_ctx that needs to be modified).

hum, I don't see it at the moment.. I'll check on that and add the
comment or come up with more questions ;-)

> 
> > +       u64 *cookies;
> > +       u32 cnt;
> >  };
> >
> >  static void bpf_kprobe_multi_link_release(struct bpf_link *link)
> > @@ -2219,6 +2239,7 @@ static void bpf_kprobe_multi_link_dealloc(struct bpf_link *link)
> >
> >         kmulti_link = container_of(link, struct bpf_kprobe_multi_link, link);
> >         kvfree(kmulti_link->addrs);
> > +       kvfree(kmulti_link->cookies);
> >         kfree(kmulti_link);
> >  }
> >
> > @@ -2227,10 +2248,57 @@ static const struct bpf_link_ops bpf_kprobe_multi_link_lops = {
> >         .dealloc = bpf_kprobe_multi_link_dealloc,
> >  };
> >
> > +static void bpf_kprobe_multi_cookie_swap(void *a, void *b, int size, const void *priv)
> > +{
> > +       const struct bpf_kprobe_multi_link *link = priv;
> > +       unsigned long *addr_a = a, *addr_b = b;
> > +       u64 *cookie_a, *cookie_b;
> > +
> > +       cookie_a = link->cookies + (addr_a - link->addrs);
> > +       cookie_b = link->cookies + (addr_b - link->addrs);
> > +
> > +       swap_words_64(addr_a, addr_b, size);
> > +       swap_words_64(cookie_a, cookie_b, size);
> 
> is it smart to call (now) non-inlined function just to swap two longs
> and u64s?..
> 
> unsigned long tmp1;
> u64 tmp2;
> 
> tmp1 = *addr_a; *addr_a = addr_b; *addr_b = tmp1;
> tmp2 = *cookie_a; *cookie_a = cookie_b; *cookie_b = tmp2;

the swap_words_64 has CONFIG_64BIT ifdef with some tweaks for 32bit,
so I wanted to use that.. but I agree with your other comment below
wrt performace, so will change

> 
> ?
> 
> > +}
> > +
> > +static int __bpf_kprobe_multi_cookie_cmp(const void *a, const void *b)
> > +{
> > +       const unsigned long *addr_a = a, *addr_b = b;
> > +
> > +       if (*addr_a == *addr_b)
> > +               return 0;
> > +       return *addr_a < *addr_b ? -1 : 1;
> > +}
> > +
> 
> [...]
> 
> > @@ -2238,12 +2306,16 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
> >                 goto out;
> >         }
> >
> > +       old_run_ctx = bpf_set_run_ctx(&link->run_ctx);
> > +
> >         rcu_read_lock();
> 
> so looking at other code, I see that we first migrate_disable() and
> then rcu_read_lock(), so let's swap? We also normally set/reset
> run_ctx inside migrate+rcu_lock region. I'm not sure that's necessary,
> but also shouldn't hurt to stay consistent.

ok, will change

> 
> >         migrate_disable();
> >         err = bpf_prog_run(link->link.prog, regs);
> >         migrate_enable();
> >         rcu_read_unlock();
> >
> > +       bpf_reset_run_ctx(old_run_ctx);
> > +
> >   out:
> >         __this_cpu_dec(bpf_prog_active);
> >         return err;
> 
> [...]
> 
> > diff --git a/lib/sort.c b/lib/sort.c
> > index b399bf10d675..91f7ce701cf4 100644
> > --- a/lib/sort.c
> > +++ b/lib/sort.c
> > @@ -80,7 +80,7 @@ static void swap_words_32(void *a, void *b, size_t n)
> >   * but it's possible to have 64-bit loads without 64-bit pointers (e.g.
> >   * x32 ABI).  Are there any cases the kernel needs to worry about?
> >   */
> > -static void swap_words_64(void *a, void *b, size_t n)
> > +void swap_words_64(void *a, void *b, size_t n)
> 
> I'm worried that this might change performance unintentionally in
> other places (making the function global might pessimize inlining, I
> think). So let's not do that, just do a straightforward swap in cookie
> support code?

right, I did not realize this.. I'll add to cookie code directly

> 
> >  {
> >         do {
> >  #ifdef CONFIG_64BIT
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index 6c66138c1b9b..d18996502aac 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -1482,6 +1482,7 @@ union bpf_attr {
> >                         struct {
> >                                 __aligned_u64   syms;
> >                                 __aligned_u64   addrs;
> > +                               __aligned_u64   cookies;
> 
> looks a bit weird to change layout of UAPI. That's not really a
> problem, because both patches will land at the same time. But if you
> move flags and cnt to the front of the struct it would a bit better.

I was following your previous comment:
  https://lore.kernel.org/bpf/CAEf4BzbPeQbURZOD93TgPudOk3JD4odsZ9uwriNkrphes9V4dg@mail.gmail.com/

I like the idea that syms/addrs/cookies stay together,
because they are all related to cnt.. but yes, it's
'breaking' KABI in between these patches

jirka

> 
> 
> >                                 __u32           cnt;
> >                                 __u32           flags;
> >                         } kprobe_multi;
> > --
> > 2.35.1
> >
