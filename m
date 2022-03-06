Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B941F4CEC82
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 18:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbiCFRaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 12:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbiCFRaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 12:30:22 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08B336321;
        Sun,  6 Mar 2022 09:29:28 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id r187-20020a1c2bc4000000b003810e6b192aso8003458wmr.1;
        Sun, 06 Mar 2022 09:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zv/M46/ISZLN7ZZvL7+tcWDDaL4cWZc7A9nmDFFdAxM=;
        b=e5EVznNrTi9pf96ge9G0XtXGZyJg//LyV0XOV1gcC7XyaFXk967DXz2PZQUxAy2g0t
         2FN2MCDlAdckg7sLJMxwGKtNR7l5qhYGan4w4XoiKgdgVLB/AcfhV+EbsbC6pYxno4S5
         jHMBL26wl6QRhP39sNWsetVyFnGGqRnfbf42nOX7AosxAdnmk1UGVipgXev5N3v2da0t
         SVi5HihxWqEql24BzEm2cz7jF9x2rDTnb029aIdzWDn3wQNQ2IzdvFvDHzTKs1/fR2tr
         RepEjlwqQQhM6z5x/TFaUYbDkLtBlhZwBnrc6fKcDqkSNB3umNy/rM7nMFL4bDLJ9t0Z
         hoPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zv/M46/ISZLN7ZZvL7+tcWDDaL4cWZc7A9nmDFFdAxM=;
        b=nzTBfHLG37kwjEmjkb3ynpFgL3/IPPMltjQcIiIm6IPd2qnpV/l+gTMLrd2HZDnQ/I
         nDwsn2P2VWBmMv+xJwfFWturfF8oTDAqNRf/NH7LOt1gVyJbVwxj0iPW31E0MJSj/VuD
         QYM2sOtHmBGgaFoN7uyeqvcpvcaYXcl//OYd/EbLM3yvjuBGSeOlPln0STvs95oxtg+3
         IwMIMH4QxfikOsttLFXbElikUj/jbQL2lEIoOdUY6nVL5D80dOK84VA96K55n8vO6Gr0
         lliea25/tPrVohnfkzAmWDXPyfT2UAiBWHTBJ6dnmbIYAxO9LHp9aTyYhUDOKI1AYuIw
         NDDw==
X-Gm-Message-State: AOAM532zFLjeeCXk9c9yE9mWyI0bNnF/vLSr/CpIwiBKLX9hc//Ohlix
        IFLPLaFMbqIa4wvAwKHapeM=
X-Google-Smtp-Source: ABdhPJwg1eFkIaVp4FVUT3csxrHNcoax/ga1OAp89oF45VQbXzVEHys4seQwtqtb3YWy/Q+IfHwlNg==
X-Received: by 2002:a1c:3b55:0:b0:389:89bc:4207 with SMTP id i82-20020a1c3b55000000b0038989bc4207mr7890194wma.132.1646587767451;
        Sun, 06 Mar 2022 09:29:27 -0800 (PST)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id o12-20020a5d62cc000000b001f048bc25dfsm9150341wrv.67.2022.03.06.09.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 09:29:27 -0800 (PST)
Date:   Sun, 6 Mar 2022 18:29:24 +0100
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
Message-ID: <YiTvdMGi6GA7i2Ex@krava>
References: <20220222170600.611515-1-jolsa@kernel.org>
 <20220222170600.611515-9-jolsa@kernel.org>
 <CAEf4Bza0qRAzA7WmtPD4US4Kur3qf3X+LC5uowr_H3Y-_pLfCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza0qRAzA7WmtPD4US4Kur3qf3X+LC5uowr_H3Y-_pLfCA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 03:11:19PM -0800, Andrii Nakryiko wrote:
> On Tue, Feb 22, 2022 at 9:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding support to bpf_program__attach_kprobe_opts to attach kprobes
> > to multiple functions.
> >
> > If the kprobe program has BPF_TRACE_KPROBE_MULTI as expected_attach_type
> > it will use the new kprobe_multi link to attach the program. In this case
> > it will use 'func_name' as pattern for functions to attach.
> >
> > Adding also new section types 'kprobe.multi' and kretprobe.multi'
> > that allows to specify wildcards (*?) for functions, like:
> >
> >   SEC("kprobe.multi/bpf_fentry_test*")
> >   SEC("kretprobe.multi/bpf_fentry_test?")
> >
> > This will set kprobe's expected_attach_type to BPF_TRACE_KPROBE_MULTI,
> > and attach it to functions provided by the function pattern.
> >
> > Using glob_match from selftests/bpf/test_progs.c and adding support to
> > match '?' based on original perf code.
> >
> > Cc: Masami Hiramatsu <mhiramat@redhat.com>
> > Cc: Yucong Sun <fallentree@fb.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/lib/bpf/libbpf.c | 130 +++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 125 insertions(+), 5 deletions(-)
> >
> 
> [...]
> 
> > +static struct bpf_link *
> > +attach_kprobe_multi_opts(const struct bpf_program *prog,
> > +                  const char *func_pattern,
> > +                  const struct bpf_kprobe_opts *kopts)
> > +{
> > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> 
> nit: just LIBBPF_OPTS

ok

> 
> 
> > +       struct kprobe_multi_resolve res = {
> > +               .name = func_pattern,
> > +       };
> > +       struct bpf_link *link = NULL;
> > +       char errmsg[STRERR_BUFSIZE];
> > +       int err, link_fd, prog_fd;
> > +       bool retprobe;
> > +
> > +       err = libbpf_kallsyms_parse(resolve_kprobe_multi_cb, &res);
> 
> hm... I think as a generic API we should support three modes of
> specifying attachment target:
> 
> 
> 1. glob-based (very convenient, I agree)
> 2. array of function names (very convenient when I know specific set
> of functions)
> 3. array of addresses (advanced use case, so probably will be rarely used).
> 
> 
> 
> So I wonder if it's better to have a separate
> bpf_program__attach_kprobe_multi() API for this, instead of doing both
> inside bpf_program__attach_kprobe()...
> 
> In such case bpf_program__attach_kprobe() could either fail if
> expected attach type is BPF_TRACE_KPROBE_MULTI or it can redirect to
> attach_kprobe_multi with func_name as a pattern or just single
> function (let's think which one makes more sense)
> 
> Let's at least think about this

I think it would make the code more clear, how about this:

	struct bpf_kprobe_multi_opts {
		/* size of this struct, for forward/backward compatiblity */
		size_t sz;

		const char **funcs;
		const unsigned long *addrs;
		const u64 *cookies;
		int cnt;
		bool retprobe;
		size_t :0;
	};

	bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
					      const char *pattern,
					      const struct bpf_kprobe_multi_opts *opts);


if pattern is NULL we'd use opts data:

	bpf_program__attach_kprobe_multi_opts(prog, "ksys_*", NULL);
	bpf_program__attach_kprobe_multi_opts(prog, NULL, &opts);

to have '2. array of function names' as direct function argument,
we'd need to add 'cnt' as well, so I think it's better to have it
in opts, and have just pattern for quick/convenient call without opts

> 
> 
> > +       if (err)
> > +               goto error;
> > +       if (!res.cnt) {
> > +               err = -ENOENT;
> > +               goto error;
> > +       }
> > +
> > +       retprobe = OPTS_GET(kopts, retprobe, false);
> > +
> > +       opts.kprobe_multi.addrs = ptr_to_u64(res.addrs);
> > +       opts.kprobe_multi.cnt = res.cnt;
> > +       opts.flags = retprobe ? BPF_F_KPROBE_MULTI_RETURN : 0;
> 
> this should be opts.kprobe_multi.flags

ugh, now I'm curious how kretprobes passed in tests ;-)

> 
> > +
> > +       link = calloc(1, sizeof(*link));
> > +       if (!link) {
> > +               err = -ENOMEM;
> > +               goto error;
> > +       }
> > +       link->detach = &bpf_link__detach_fd;
> > +
> > +       prog_fd = bpf_program__fd(prog);
> > +       link_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_KPROBE_MULTI, &opts);
> > +       if (link_fd < 0) {
> > +               err = -errno;
> > +               pr_warn("prog '%s': failed to attach to %s: %s\n",
> 
> "to attach multi-kprobe for '%s': %s" ?

ok

> 
> > +                       prog->name, res.name,
> > +                       libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > +               goto error;
> > +       }
> > +       link->fd = link_fd;
> > +       free(res.addrs);
> > +       return link;
> > +
> > +error:
> > +       free(link);
> > +       free(res.addrs);
> > +       return libbpf_err_ptr(err);
> > +}
> > +
> >  struct bpf_link *
> >  bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
> >                                 const char *func_name,
> > @@ -10054,6 +10163,9 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
> >         if (!OPTS_VALID(opts, bpf_kprobe_opts))
> >                 return libbpf_err_ptr(-EINVAL);
> >
> > +       if (prog->expected_attach_type == BPF_TRACE_KPROBE_MULTI)
> > +               return attach_kprobe_multi_opts(prog, func_name, opts);
> > +
> >         retprobe = OPTS_GET(opts, retprobe, false);
> >         offset = OPTS_GET(opts, offset, 0);
> >         pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);
> 
> see how you don't support cookies (plural) and this offset doesn't
> make sense for multi-kprobe. Separate API is necessary to expose all
> the possibilities and functionality.
> 
> > @@ -10122,19 +10234,27 @@ struct bpf_link *bpf_program__attach_kprobe(const struct bpf_program *prog,
> >  static struct bpf_link *attach_kprobe(const struct bpf_program *prog, long cookie)
> >  {
> >         DECLARE_LIBBPF_OPTS(bpf_kprobe_opts, opts);
> > +       const char *func_name = NULL;
> >         unsigned long offset = 0;
> >         struct bpf_link *link;
> > -       const char *func_name;
> >         char *func;
> >         int n, err;
> >
> > -       opts.retprobe = str_has_pfx(prog->sec_name, "kretprobe/");
> > -       if (opts.retprobe)
> > +       opts.retprobe = str_has_pfx(prog->sec_name, "kretprobe");
> > +
> > +       if (str_has_pfx(prog->sec_name, "kretprobe/"))
> >                 func_name = prog->sec_name + sizeof("kretprobe/") - 1;
> > -       else
> > +       else if (str_has_pfx(prog->sec_name, "kprobe/"))
> >                 func_name = prog->sec_name + sizeof("kprobe/") - 1;
> > +       else if (str_has_pfx(prog->sec_name, "kretprobe.multi/"))
> > +               func_name = prog->sec_name + sizeof("kretprobe.multi/") - 1;
> > +       else if (str_has_pfx(prog->sec_name, "kprobe.multi/"))
> > +               func_name = prog->sec_name + sizeof("kprobe.multi/") - 1;
> 
> starts to feel that we should find '/' and then do strcmp(), instead
> of this duplication of strings?

ok, another reason to separate the api

thanks,
jirka
