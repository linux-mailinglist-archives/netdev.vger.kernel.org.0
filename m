Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03A44FE827
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 20:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358762AbiDLSoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 14:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244339AbiDLSod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 14:44:33 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C23552E75;
        Tue, 12 Apr 2022 11:42:15 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id bh17so39072590ejb.8;
        Tue, 12 Apr 2022 11:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0vLtlk/2vLSpLboaNitHRcOySnoML+sxdweNgqoysJE=;
        b=auj/Zv0UekaDc7AG5Z3zGZrfV4g+HiVFTTHyx9/D41zo6CLt4nMx987PJ7l369tS9L
         8yg9Cro2uKoGpjCyOReEECe1hcBtNXkrQ2DGq8R+WAFddfh3lArZMKhgvTyLPjvFd2Uo
         T1z54Hhrn6YPl/4sV+uG5p6l+K6HQb3flTlJuTpAEzPgweFt6vZfSGCSGdCUGAlKZaiB
         S2CJh1R7ygk0Frpg1bYnvkUMCnMSVcXLHrX6YQGMp0xgNtIMwnhzh90GOhn6At+O4mig
         z7EDVyAS5NAFi4tqGJbE2JvPLUY1q30KHnIhVNCUL1A8UloXO6/8+zKnCBkSKjp/cy2r
         AX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0vLtlk/2vLSpLboaNitHRcOySnoML+sxdweNgqoysJE=;
        b=Po/wAw1acgu7EH5iz0Y0hiQo0/nzU6YQqBDY2aHyqs8M55cnb4Rb2yvn12BdzZacvk
         F5XOHzkLnhya9EyRlo34+2ES5VxP2FT3CmzvJHh0L+eli+si9KMfV3EvGpkkfqBG9Yg6
         7HMwPJUqr2hhSiteEUwcDJzE1zmpUZdJayRHiluSULncpCTJKtUJv3lUp3nSEFfE3ZfX
         A/teqwFAarxNV4Xsz61xlz1xEL2sLzR5pB5Gr65X12ILG1XfQ999mcAsx5R0EJVCp0Pt
         8MynUM6UjKGYMeDlPbt5YgldwZjngqUHqpa/oRhGY1G65H3G7rYq2sevyhj3ljQs6IE6
         1zVA==
X-Gm-Message-State: AOAM5336P/Hr89MQQGrddaf5R4xeqcjwOOlrhRgSLtATVwsHnZX+im6V
        +bGSHTc7dD68smIdOqry9uM=
X-Google-Smtp-Source: ABdhPJzgexsqD1nWONwCvU85BNOtwwnyOA88W4A/iZRHD5+kzIJOuKZhpb5QHPd8iqaWsr+65Uxf1Q==
X-Received: by 2002:a17:906:cec3:b0:6e8:a49f:2189 with SMTP id si3-20020a170906cec300b006e8a49f2189mr6931952ejb.119.1649788933759;
        Tue, 12 Apr 2022 11:42:13 -0700 (PDT)
Received: from krava ([83.240.62.142])
        by smtp.gmail.com with ESMTPSA id o22-20020a170906289600b006e44a0c1105sm13486453ejd.46.2022.04.12.11.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:42:13 -0700 (PDT)
Date:   Tue, 12 Apr 2022 20:42:11 +0200
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
Subject: Re: [RFC bpf-next 3/4] bpf: Resolve symbols with
 kallsyms_lookup_names for kprobe multi link
Message-ID: <YlXIA12sLNUOc+nm@krava>
References: <20220407125224.310255-1-jolsa@kernel.org>
 <20220407125224.310255-4-jolsa@kernel.org>
 <CAEf4BzYrRSB2wSYVmMCGA80RY6Hy2Chtt3MnXFy7+-Feh+2FBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYrRSB2wSYVmMCGA80RY6Hy2Chtt3MnXFy7+-Feh+2FBw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 03:15:32PM -0700, Andrii Nakryiko wrote:
> On Thu, Apr 7, 2022 at 5:53 AM Jiri Olsa <jolsa@kernel.org> wrote:
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
> >  kernel/trace/bpf_trace.c | 123 +++++++++++++++++++++++----------------
> >  1 file changed, 73 insertions(+), 50 deletions(-)
> >
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index b26f3da943de..2602957225ba 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -2226,6 +2226,72 @@ struct bpf_kprobe_multi_run_ctx {
> >         unsigned long entry_ip;
> >  };
> >
> > +struct user_syms {
> > +       const char **syms;
> > +       char *buf;
> > +};
> > +
> > +static int copy_user_syms(struct user_syms *us, void __user *usyms, u32 cnt)
> > +{
> > +       const char __user **usyms_copy = NULL;
> > +       const char **syms = NULL;
> > +       char *buf = NULL, *p;
> > +       int err = -EFAULT;
> > +       unsigned int i;
> > +       size_t size;
> > +
> > +       size = cnt * sizeof(*usyms_copy);
> > +
> > +       usyms_copy = kvmalloc(size, GFP_KERNEL);
> > +       if (!usyms_copy)
> > +               return -ENOMEM;
> 
> do you really need usyms_copy? why not just read one pointer at a time?
> 
> > +
> > +       if (copy_from_user(usyms_copy, usyms, size))
> > +               goto error;
> > +
> > +       err = -ENOMEM;
> > +       syms = kvmalloc(size, GFP_KERNEL);
> > +       if (!syms)
> > +               goto error;
> > +
> > +       /* TODO this potentially allocates lot of memory (~6MB in my tests
> > +        * with attaching ~40k functions). I haven't seen this to fail yet,
> > +        * but it could be changed to allocate memory gradually if needed.
> > +        */
> > +       size = cnt * KSYM_NAME_LEN;
> 
> this reassignment of size is making it hard to follow the code, you
> can just do cnt * KSYM_NAME_LEN inside kvmalloc, you don't ever use it
> anywhere else

ok

> 
> > +       buf = kvmalloc(size, GFP_KERNEL);
> > +       if (!buf)
> > +               goto error;
> > +
> > +       for (p = buf, i = 0; i < cnt; i++) {
> 
> like here, before doing strncpy_from_user() you can read usyms[i] from
> user-space into temporary variable, no need for extra kvmalloc?

yes, that could work.. one copy_from_user seemed faster than separate
get_user calls, but then it's without memory allocation.. so perhaps
that's better

jirka

> 
> > +               err = strncpy_from_user(p, usyms_copy[i], KSYM_NAME_LEN);
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
> > +
> 
> [...]
