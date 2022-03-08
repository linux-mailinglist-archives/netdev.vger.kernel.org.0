Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100C34D1A54
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbiCHOYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiCHOYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:24:36 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85E447AEE;
        Tue,  8 Mar 2022 06:23:38 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id q17so24704019edd.4;
        Tue, 08 Mar 2022 06:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EWTDePeT9c6La97u9wbH4GX9FAATzBXHG6ctqZCvpd8=;
        b=SwqxHt+CEM8U7jF/UK1QRxl5zaWGz+Rpz4kjl8tvUvDaBAc0cOanxW07D6pncov5FM
         gkd2qQwI0YwO6fv6KGfwWTdIhmXVP5unai0Qp+omUXb+WQ5xFptNlsN3Il9kPfrWZRuD
         CeAlmjr+WCW5YMTmeG1wxqXSlw5Y8rfh6YOqPMT3r7liiLMwwk7MPSOlCqq5FNhp5spZ
         +bgyq/QIo2p0dq9S8g0ec/FDVJJD89jCSGDGpl+fJBco42+cQIKend21tWdBKmt4J3wO
         +vBMgEKph46t0L6FqdMWxfStycIg/UlleEu+fPcXuYPcf15ut2tI1yFpYukWA4Y99cq0
         wetw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EWTDePeT9c6La97u9wbH4GX9FAATzBXHG6ctqZCvpd8=;
        b=yVi16mZr87jj1MElEFulv7aLWUIczzorKfy2OsnTasZuzTvlFxSmBgpUmQoCEXMBUN
         vpfTKa/fvKxkg30hLPapnm7dYaUo46dQGQi4InVNj+6lL8KALTEOx2KEMJdVhaPKq/i1
         WpTVN71N/HbzHCFn8hzz51IwZTnEkIE1qNVBP50uWJrvJTaUDPm7twkuMjY1HD0sXNiL
         q/QjjEsFobTT9MiYLTdiOtA6XNrUpnnJchi0yumkO0iDOlmwQekEzhHrtsiEOO+dn0gM
         tZDSKcLxJLTdkccratK65KWcEcrXCBsmQ6EQcAE72w5ddwfUgxAqkRt1uoEp6uwVKTTH
         U/1A==
X-Gm-Message-State: AOAM5309a3rJmNy5plStQKOexG2Xn5T/kX8gmgBmCoR7qqtx8EiPXgri
        V5iz0/jhGSA32I1+ivJlMgo=
X-Google-Smtp-Source: ABdhPJzK8eDtdQLsY2k88vsdbhPp3EbvokltEUVWoGn1cx3RxrX/AsjFlMtrSnnw23OOfx1ddoRO/g==
X-Received: by 2002:a50:fd8e:0:b0:415:fe34:f03 with SMTP id o14-20020a50fd8e000000b00415fe340f03mr16318601edt.310.1646749417260;
        Tue, 08 Mar 2022 06:23:37 -0800 (PST)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id s14-20020aa7cb0e000000b00410bf015567sm7483195edt.92.2022.03.08.06.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 06:23:36 -0800 (PST)
Date:   Tue, 8 Mar 2022 15:23:34 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Yucong Sun <fallentree@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 08/10] libbpf: Add bpf_program__attach_kprobe_opts
 support for multi kprobes
Message-ID: <Yidm5vcehK7k1B2O@krava>
References: <20220222170600.611515-1-jolsa@kernel.org>
 <20220222170600.611515-9-jolsa@kernel.org>
 <CAEf4Bza0qRAzA7WmtPD4US4Kur3qf3X+LC5uowr_H3Y-_pLfCA@mail.gmail.com>
 <YiTvdMGi6GA7i2Ex@krava>
 <CAEf4BzZZy6XSb2naSam+W=_wY6JviX6Vz30N7mSg=xYZW_TxQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZZy6XSb2naSam+W=_wY6JviX6Vz30N7mSg=xYZW_TxQA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 05:28:54PM -0800, Andrii Nakryiko wrote:
> On Sun, Mar 6, 2022 at 9:29 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Fri, Mar 04, 2022 at 03:11:19PM -0800, Andrii Nakryiko wrote:
> > > On Tue, Feb 22, 2022 at 9:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > Adding support to bpf_program__attach_kprobe_opts to attach kprobes
> > > > to multiple functions.
> > > >
> > > > If the kprobe program has BPF_TRACE_KPROBE_MULTI as expected_attach_type
> > > > it will use the new kprobe_multi link to attach the program. In this case
> > > > it will use 'func_name' as pattern for functions to attach.
> > > >
> > > > Adding also new section types 'kprobe.multi' and kretprobe.multi'
> > > > that allows to specify wildcards (*?) for functions, like:
> > > >
> > > >   SEC("kprobe.multi/bpf_fentry_test*")
> > > >   SEC("kretprobe.multi/bpf_fentry_test?")
> > > >
> > > > This will set kprobe's expected_attach_type to BPF_TRACE_KPROBE_MULTI,
> > > > and attach it to functions provided by the function pattern.
> > > >
> > > > Using glob_match from selftests/bpf/test_progs.c and adding support to
> > > > match '?' based on original perf code.
> > > >
> > > > Cc: Masami Hiramatsu <mhiramat@redhat.com>
> > > > Cc: Yucong Sun <fallentree@fb.com>
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  tools/lib/bpf/libbpf.c | 130 +++++++++++++++++++++++++++++++++++++++--
> > > >  1 file changed, 125 insertions(+), 5 deletions(-)
> > > >
> > >
> > > [...]
> > >
> > > > +static struct bpf_link *
> > > > +attach_kprobe_multi_opts(const struct bpf_program *prog,
> > > > +                  const char *func_pattern,
> > > > +                  const struct bpf_kprobe_opts *kopts)
> > > > +{
> > > > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> > >
> > > nit: just LIBBPF_OPTS
> >
> > ok
> >
> > >
> > >
> > > > +       struct kprobe_multi_resolve res = {
> > > > +               .name = func_pattern,
> > > > +       };
> > > > +       struct bpf_link *link = NULL;
> > > > +       char errmsg[STRERR_BUFSIZE];
> > > > +       int err, link_fd, prog_fd;
> > > > +       bool retprobe;
> > > > +
> > > > +       err = libbpf_kallsyms_parse(resolve_kprobe_multi_cb, &res);
> > >
> > > hm... I think as a generic API we should support three modes of
> > > specifying attachment target:
> > >
> > >
> > > 1. glob-based (very convenient, I agree)
> > > 2. array of function names (very convenient when I know specific set
> > > of functions)
> > > 3. array of addresses (advanced use case, so probably will be rarely used).
> > >
> > >
> > >
> > > So I wonder if it's better to have a separate
> > > bpf_program__attach_kprobe_multi() API for this, instead of doing both
> > > inside bpf_program__attach_kprobe()...
> > >
> > > In such case bpf_program__attach_kprobe() could either fail if
> > > expected attach type is BPF_TRACE_KPROBE_MULTI or it can redirect to
> > > attach_kprobe_multi with func_name as a pattern or just single
> > > function (let's think which one makes more sense)
> > >
> > > Let's at least think about this
> >
> > I think it would make the code more clear, how about this:
> >
> >         struct bpf_kprobe_multi_opts {
> >                 /* size of this struct, for forward/backward compatiblity */
> >                 size_t sz;
> >
> >                 const char **funcs;
> 
> naming nit: func_names (to oppose it to "func_pattern")? Or just
> "names" to be in line with "addrs" (but then "pattern" instead of
> "func_pattern"? with kprobe it's always about functions, so this
> "func_" everywhere is a bit redundant)

ok

> 
> >                 const unsigned long *addrs;
> >                 const u64 *cookies;
> >                 int cnt;
> 
> nit: let's use size_t

ok

> 
> 
> >                 bool retprobe;
> >                 size_t :0;
> >         };
> >
> >         bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
> >                                               const char *pattern,
> >                                               const struct bpf_kprobe_multi_opts *opts);
> >
> >
> > if pattern is NULL we'd use opts data:
> >
> >         bpf_program__attach_kprobe_multi_opts(prog, "ksys_*", NULL);
> >         bpf_program__attach_kprobe_multi_opts(prog, NULL, &opts);
> >
> > to have '2. array of function names' as direct function argument,
> > we'd need to add 'cnt' as well, so I think it's better to have it
> > in opts, and have just pattern for quick/convenient call without opts
> >
> 
> yeah, naming pattern as direct argument for common use case makes
> sense. Let's go with this scheme

great, I'll make the changes

thanks,
jirka
