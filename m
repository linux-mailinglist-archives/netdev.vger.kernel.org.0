Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB51509841
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385224AbiDUGyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 02:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385934AbiDUGxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 02:53:45 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC7B140CD;
        Wed, 20 Apr 2022 23:49:17 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id g18so5218272wrb.10;
        Wed, 20 Apr 2022 23:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ufzy6GPDCT+EdtxABpNGV4M1WRq60zj8Sw9h2+oqp74=;
        b=DHdXFxPyfcpHgkSUAcXrGuzDeAjqa5UHlI+cGdFeoPbULu4EkX2UhzMtRctCGhBtcn
         9ZaRyEnT9tt/8RzDKcNzwzTsmMBQXHCSsjuazlWOqRQSrJH8UYMTyEKk0fiPKgXKMg+j
         A1cI7Y0+nsT0207B0m8KsAemhqf8ozCWtxQ7/2rYTK57metyxd2vUpx/Rkf7Rb7+n0Zi
         T5ZNfEjX0FuPo2TmSnv9YBU6smDe7PjvYutBmhgQ302EOQqFWzzNVAuj0jEhxAUrxac+
         Yy6KIdGFpgWTrkU24ecF2g1FocrjLsZSzHjOW/tZJgsMCAgcmeOU9M1Y+K9gXh6G+Riq
         btvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ufzy6GPDCT+EdtxABpNGV4M1WRq60zj8Sw9h2+oqp74=;
        b=U3+pTQYhqIvnX9NTrBA2aZk4tRffSylj6yrNxOhHFzRNlWwGstzmmaJO8UWGffKgiD
         hTY+dxFwE6cqbhQ2S+2oEV238EYgGxfNLvZm0lSJqA9KlMKdJNgZGsxWyymKDMQIEBtM
         5SA5CG3buupW1fPkd3u4BDcF9EmGT+3jKoIp+GLUX4yo+sy6VOEgD7oR2nHcHyHkZCn3
         fFaMl26hiF0lawnEQrRsybuyQEV30vsyIMR4IJhhx3pkY2TiXoClMuvVI1Xf/BFjC9sd
         A80K7Dmr6+clMXOjGFtKlOKSkIgq4DKeR+n7nh6+mhojGN+pefYcg24T1bxyUJNGP6Wj
         Zjaw==
X-Gm-Message-State: AOAM531gQRZjFwAGDn762jDE2zPZin2dJMqZ4QJ79x2sFedrETsii12H
        +e9zZLXNaNOLxj23oXtbMTt6w+RtPtd4swCt
X-Google-Smtp-Source: ABdhPJwwxoXgrrcitntGF+5u7JGyFz0T0yQA+xl3/MlX+vb1NLVPnUG1PgBpP1RfaJv1gvkTDHeS9w==
X-Received: by 2002:adf:efc6:0:b0:207:b89b:232b with SMTP id i6-20020adfefc6000000b00207b89b232bmr17752793wrp.403.1650523756225;
        Wed, 20 Apr 2022 23:49:16 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id d18-20020a05600c34d200b0038ed14b7ac3sm1223454wmq.40.2022.04.20.23.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 23:49:15 -0700 (PDT)
Date:   Thu, 21 Apr 2022 08:49:13 +0200
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
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCHv2 bpf-next 3/4] bpf: Resolve symbols with
 kallsyms_lookup_names for kprobe multi link
Message-ID: <YmD+aXZa/4pYM62C@krava>
References: <20220418124834.829064-1-jolsa@kernel.org>
 <20220418124834.829064-4-jolsa@kernel.org>
 <CAEf4Bzau_RmREQwVQ6wPRbCHVXRuAr1k08btaft2jUwBYTeM-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzau_RmREQwVQ6wPRbCHVXRuAr1k08btaft2jUwBYTeM-Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 02:49:59PM -0700, Andrii Nakryiko wrote:
> On Mon, Apr 18, 2022 at 5:49 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Using kallsyms_lookup_names function to speed up symbols lookup in
> > kprobe multi link attachment and replacing with it the current
> > kprobe_multi_resolve_syms function.
> >
> > This speeds up bpftrace kprobe attachment:
> >
> >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> >   ...
> >   6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )
> >
> > After:
> >
> >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> >   ...
> >   0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> LGTM.
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> >  kernel/trace/bpf_trace.c | 113 +++++++++++++++++++++++----------------
> >  1 file changed, 67 insertions(+), 46 deletions(-)
> >
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index b26f3da943de..f49cdc46a21f 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -2226,6 +2226,60 @@ struct bpf_kprobe_multi_run_ctx {
> >         unsigned long entry_ip;
> >  };
> >
> > +struct user_syms {
> > +       const char **syms;
> > +       char *buf;
> > +};
> > +
> > +static int copy_user_syms(struct user_syms *us, unsigned long __user *usyms, u32 cnt)
> > +{
> > +       unsigned long __user usymbol;
> > +       const char **syms = NULL;
> > +       char *buf = NULL, *p;
> > +       int err = -EFAULT;
> > +       unsigned int i;
> > +
> > +       err = -ENOMEM;
> > +       syms = kvmalloc(cnt * sizeof(*syms), GFP_KERNEL);
> > +       if (!syms)
> > +               goto error;
> > +
> > +       buf = kvmalloc(cnt * KSYM_NAME_LEN, GFP_KERNEL);
> > +       if (!buf)
> > +               goto error;
> > +
> > +       for (p = buf, i = 0; i < cnt; i++) {
> > +               if (__get_user(usymbol, usyms + i)) {
> > +                       err = -EFAULT;
> > +                       goto error;
> > +               }
> > +               err = strncpy_from_user(p, (const char __user *) usymbol, KSYM_NAME_LEN);
> > +               if (err == KSYM_NAME_LEN)
> > +                       err = -E2BIG;
> > +               if (err < 0)
> > +                       goto error;
> > +               syms[i] = p;
> > +               p += err + 1;
> > +       }
> > +
> > +       err = 0;
> > +       us->syms = syms;
> > +       us->buf = buf;
> 
> return 0 here instead of falling through into error: block?

ok, will change

jirka

> 
> > +
> > +error:
> > +       if (err) {
> > +               kvfree(syms);
> > +               kvfree(buf);
> > +       }
> > +       return err;
> > +}
> > +
> > +static void free_user_syms(struct user_syms *us)
> > +{
> > +       kvfree(us->syms);
> > +       kvfree(us->buf);
> > +}
> > +
> >  static void bpf_kprobe_multi_link_release(struct bpf_link *link)
> >  {
> >         struct bpf_kprobe_multi_link *kmulti_link;
> 
> [...]
