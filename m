Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7B44D0D7E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 02:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237647AbiCHBaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 20:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiCHBaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 20:30:01 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504B565C3;
        Mon,  7 Mar 2022 17:29:06 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id b16so4946997ioz.3;
        Mon, 07 Mar 2022 17:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LDpFgeksUroIuFYxvegbsCyq8RNIruyG8HNhYcbJifg=;
        b=OrY8SIhk3eLfRDDQHodXxN8fTJm34zxteJXnEdbpMTvSRCoDd+FaImfeLSak644Uiw
         okm4+E9qtf7hsxnEqI01aUsY3kPR2d9b24gC8TwRrIBgoC+0WUW1zJztwRIK4i1ASsHH
         JKaRwwQrjzKUAL/6/iBVVP4LsV7ItoOzmBjS18x69WqMS+1EXgMXb9+ra/l78exDnVRT
         X0MZLh4ypop6qvxlmYXTL9pr3/vxftoQRP2qss/jwssKt2eX3zPhGYcJ408RnYqr5yKy
         eEBCe6b4fKGfkZU9YkvtINW0GX36mBUADeq3kfxc1ssmDcw5pDqSv3p71JGi7iZiMgQ+
         38rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LDpFgeksUroIuFYxvegbsCyq8RNIruyG8HNhYcbJifg=;
        b=vH8Xy9UEfShAFbphURWL5eLDaZbG84G7O1agfAHfZtD7MwbHSRUQqd2yrHhfHBkQu3
         cxTRhHL9lePfQ0I5P0oJRy09Ir8iocq8Df2LBLLCcxA+pbadlRpTd7QoOtEfFm2xb6gW
         gQ1bI5QHCmngrrOMJTD9kcW6QlFQw9K1d3xXkKHBtJzp1+vSsd3NGQK4O+3kIxJDUhf/
         jxqKusz/ipPtEMRaZff1cab6J+jBRqMybRPJJ7a/Im0nuWSwjg6o8nBgPxpPgFRc+Sln
         QLOkl6E9N0EtHFXfw5FEI0zYdVIlshe5efP66HC+iMEcTR+M9hCRISj066j2gfAn6+2b
         jZZg==
X-Gm-Message-State: AOAM532isAC8TYMvXAKO5mFahVuH6kQKsQ1eK2p7I+Yv0ClUrTI66Py1
        SQVlhcY4fe9BsbRKgOcmC1xInadGO/J91evgDZLYnlkNb0k=
X-Google-Smtp-Source: ABdhPJyAy7cyNHw0Et7Dt8xQfFOD9Z/LqIl0RKATj6velzSa20Ix6XbY21gTRAduGAHi4SSvK0aBDZKB6zrIIruf4TQ=
X-Received: by 2002:a02:a08c:0:b0:314:ede5:1461 with SMTP id
 g12-20020a02a08c000000b00314ede51461mr13696957jah.103.1646702945630; Mon, 07
 Mar 2022 17:29:05 -0800 (PST)
MIME-Version: 1.0
References: <20220222170600.611515-1-jolsa@kernel.org> <20220222170600.611515-9-jolsa@kernel.org>
 <CAEf4Bza0qRAzA7WmtPD4US4Kur3qf3X+LC5uowr_H3Y-_pLfCA@mail.gmail.com> <YiTvdMGi6GA7i2Ex@krava>
In-Reply-To: <YiTvdMGi6GA7i2Ex@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Mar 2022 17:28:54 -0800
Message-ID: <CAEf4BzZZy6XSb2naSam+W=_wY6JviX6Vz30N7mSg=xYZW_TxQA@mail.gmail.com>
Subject: Re: [PATCH 08/10] libbpf: Add bpf_program__attach_kprobe_opts support
 for multi kprobes
To:     Jiri Olsa <olsajiri@gmail.com>
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

On Sun, Mar 6, 2022 at 9:29 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Fri, Mar 04, 2022 at 03:11:19PM -0800, Andrii Nakryiko wrote:
> > On Tue, Feb 22, 2022 at 9:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding support to bpf_program__attach_kprobe_opts to attach kprobes
> > > to multiple functions.
> > >
> > > If the kprobe program has BPF_TRACE_KPROBE_MULTI as expected_attach_type
> > > it will use the new kprobe_multi link to attach the program. In this case
> > > it will use 'func_name' as pattern for functions to attach.
> > >
> > > Adding also new section types 'kprobe.multi' and kretprobe.multi'
> > > that allows to specify wildcards (*?) for functions, like:
> > >
> > >   SEC("kprobe.multi/bpf_fentry_test*")
> > >   SEC("kretprobe.multi/bpf_fentry_test?")
> > >
> > > This will set kprobe's expected_attach_type to BPF_TRACE_KPROBE_MULTI,
> > > and attach it to functions provided by the function pattern.
> > >
> > > Using glob_match from selftests/bpf/test_progs.c and adding support to
> > > match '?' based on original perf code.
> > >
> > > Cc: Masami Hiramatsu <mhiramat@redhat.com>
> > > Cc: Yucong Sun <fallentree@fb.com>
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 130 +++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 125 insertions(+), 5 deletions(-)
> > >
> >
> > [...]
> >
> > > +static struct bpf_link *
> > > +attach_kprobe_multi_opts(const struct bpf_program *prog,
> > > +                  const char *func_pattern,
> > > +                  const struct bpf_kprobe_opts *kopts)
> > > +{
> > > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> >
> > nit: just LIBBPF_OPTS
>
> ok
>
> >
> >
> > > +       struct kprobe_multi_resolve res = {
> > > +               .name = func_pattern,
> > > +       };
> > > +       struct bpf_link *link = NULL;
> > > +       char errmsg[STRERR_BUFSIZE];
> > > +       int err, link_fd, prog_fd;
> > > +       bool retprobe;
> > > +
> > > +       err = libbpf_kallsyms_parse(resolve_kprobe_multi_cb, &res);
> >
> > hm... I think as a generic API we should support three modes of
> > specifying attachment target:
> >
> >
> > 1. glob-based (very convenient, I agree)
> > 2. array of function names (very convenient when I know specific set
> > of functions)
> > 3. array of addresses (advanced use case, so probably will be rarely used).
> >
> >
> >
> > So I wonder if it's better to have a separate
> > bpf_program__attach_kprobe_multi() API for this, instead of doing both
> > inside bpf_program__attach_kprobe()...
> >
> > In such case bpf_program__attach_kprobe() could either fail if
> > expected attach type is BPF_TRACE_KPROBE_MULTI or it can redirect to
> > attach_kprobe_multi with func_name as a pattern or just single
> > function (let's think which one makes more sense)
> >
> > Let's at least think about this
>
> I think it would make the code more clear, how about this:
>
>         struct bpf_kprobe_multi_opts {
>                 /* size of this struct, for forward/backward compatiblity */
>                 size_t sz;
>
>                 const char **funcs;

naming nit: func_names (to oppose it to "func_pattern")? Or just
"names" to be in line with "addrs" (but then "pattern" instead of
"func_pattern"? with kprobe it's always about functions, so this
"func_" everywhere is a bit redundant)

>                 const unsigned long *addrs;
>                 const u64 *cookies;
>                 int cnt;

nit: let's use size_t


>                 bool retprobe;
>                 size_t :0;
>         };
>
>         bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
>                                               const char *pattern,
>                                               const struct bpf_kprobe_multi_opts *opts);
>
>
> if pattern is NULL we'd use opts data:
>
>         bpf_program__attach_kprobe_multi_opts(prog, "ksys_*", NULL);
>         bpf_program__attach_kprobe_multi_opts(prog, NULL, &opts);
>
> to have '2. array of function names' as direct function argument,
> we'd need to add 'cnt' as well, so I think it's better to have it
> in opts, and have just pattern for quick/convenient call without opts
>

yeah, naming pattern as direct argument for common use case makes
sense. Let's go with this scheme


[...]
