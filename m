Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28BA34D1A74
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347443AbiCHO2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347560AbiCHO2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:28:07 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84D64BB8D;
        Tue,  8 Mar 2022 06:27:09 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id bg10so39661584ejb.4;
        Tue, 08 Mar 2022 06:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=83JVPdRA3CueGn2PS5Rbyc/WFtEL1HpbrKaroAWEv6Y=;
        b=DaZ0b8MRwY7ANKEqyMV9RNkFCLmKupzspm90LVCpSoIEwWlzItxpy5Om0qKOfesK2y
         6oOmgEEGcs/nsx6+Y+aOqxQG/TYN7MMnvjlmONd786x1nPpSv+h0XLAPvOvlzVbDCCT8
         SRR9saRsd6j06VWLmR6u0ZDItH4WNxDweAbFVpVPTBsPeEpxfidAkODfdmLNjdBYSexw
         zYvJiJ8kU7c32jrB8gkXKSpC/aHxSznYZGyI/ncjiVBSZ8kI9Ck/amPDGNwUiGpYAOCP
         pCE3SZkb8qIsnbOQABi43KW0TjQAn8Iwk/yJ/3k333zn+qf0LfnXHlVIb10arn9l2k0i
         Mc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=83JVPdRA3CueGn2PS5Rbyc/WFtEL1HpbrKaroAWEv6Y=;
        b=JwNdVmg19VObEStUlEiZIykOJVaVmRM0Cq4WZGzfmvD7R2r5STe28VNXBolUEEBw0E
         PlteUxsKJ6a/VGD9/di1OMjwYV+ttVgvVONE9RLPNc9D+wDzmj3rzvMBLG0nSRgsJRs3
         ti7MOyHcFjiTdIg1TjQm/Y4L7j2Q6BFIHz14yWTGoBE9DMnh72iea6kEWJtyQ5UsMrV7
         ggaLbFptCFnvKD6my/oDFh6uRVlNNgYKAVhrzwan/BAPEN+++A8hbQawDp9BbHQIiDBK
         DsGsTomm17e87ddR/VybuimGJGXwz4HvCdcIQLQZ3FTTMt3Nh2Bbje7Qg4J3MlK736eC
         PEmA==
X-Gm-Message-State: AOAM532uUnp0vsWHejhn2QYZCZ8s6AMYXoEejxdO+Y/WhbEWAWvdA9ad
        ODU8LubmljYw6ECnZ+83HWI=
X-Google-Smtp-Source: ABdhPJztpsXTFXGFznDhnw9c1DV73G4r0LMBiFGsQK7rYvuqKT1K5By+igyBSMkWhg+7Nn0V0d4EXA==
X-Received: by 2002:a17:907:97c1:b0:6d8:2885:88d7 with SMTP id js1-20020a17090797c100b006d8288588d7mr13392291ejc.222.1646749628327;
        Tue, 08 Mar 2022 06:27:08 -0800 (PST)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id dm11-20020a170907948b00b006cf488e72e3sm5931893ejc.25.2022.03.08.06.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 06:27:08 -0800 (PST)
Date:   Tue, 8 Mar 2022 15:27:05 +0100
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
Message-ID: <YidnuZRVFk1nq+6f@krava>
References: <20220222170600.611515-1-jolsa@kernel.org>
 <20220222170600.611515-6-jolsa@kernel.org>
 <CAEf4Bzab_crw+e_POJ39E+JkBDG4WJQqDGz-8Gz_JOt0rYnigA@mail.gmail.com>
 <YiTvY2Ly/XWICP2H@krava>
 <CAEf4BzatkcxOdttWc92GYF7SY09nYk26RgpKsLGpd4fqX7my+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzatkcxOdttWc92GYF7SY09nYk26RgpKsLGpd4fqX7my+Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 05:23:31PM -0800, Andrii Nakryiko wrote:
> On Sun, Mar 6, 2022 at 9:29 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Fri, Mar 04, 2022 at 03:11:08PM -0800, Andrii Nakryiko wrote:
> > > On Tue, Feb 22, 2022 at 9:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > Adding support to call bpf_get_attach_cookie helper from
> > > > kprobe programs attached with kprobe multi link.
> > > >
> > > > The cookie is provided by array of u64 values, where each
> > > > value is paired with provided function address or symbol
> > > > with the same array index.
> > > >
> > > > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  include/linux/sort.h           |   2 +
> > > >  include/uapi/linux/bpf.h       |   1 +
> > > >  kernel/trace/bpf_trace.c       | 103 ++++++++++++++++++++++++++++++++-
> > > >  lib/sort.c                     |   2 +-
> > > >  tools/include/uapi/linux/bpf.h |   1 +
> > > >  5 files changed, 107 insertions(+), 2 deletions(-)
> > > >
> > >
> > > [...]
> > >
> > > >  BPF_CALL_1(bpf_get_attach_cookie_trace, void *, ctx)
> > > >  {
> > > >         struct bpf_trace_run_ctx *run_ctx;
> > > > @@ -1297,7 +1312,9 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > > >                         &bpf_get_func_ip_proto_kprobe_multi :
> > > >                         &bpf_get_func_ip_proto_kprobe;
> > > >         case BPF_FUNC_get_attach_cookie:
> > > > -               return &bpf_get_attach_cookie_proto_trace;
> > > > +               return prog->expected_attach_type == BPF_TRACE_KPROBE_MULTI ?
> > > > +                       &bpf_get_attach_cookie_proto_kmulti :
> > > > +                       &bpf_get_attach_cookie_proto_trace;
> > > >         default:
> > > >                 return bpf_tracing_func_proto(func_id, prog);
> > > >         }
> > > > @@ -2203,6 +2220,9 @@ struct bpf_kprobe_multi_link {
> > > >         struct bpf_link link;
> > > >         struct fprobe fp;
> > > >         unsigned long *addrs;
> > > > +       struct bpf_run_ctx run_ctx;
> > >
> > > clever, I like it! Keep in mind, though, that this trick can only be
> > > used here because this run_ctx is read-only (I'd leave the comment
> > > here about this, I didn't realize immediately that this approach can't
> > > be used for run_ctx that needs to be modified).
> >
> > hum, I don't see it at the moment.. I'll check on that and add the
> > comment or come up with more questions ;-)
> 
> if run_ctx is used to store some information, it has to be per program
> execution (private to a single bpf program run, just like bpf
> program's stack). So you can't just reuse bpf_link for that, because
> bpf_link is shared across all CPUs and thus (potentially) across
> multiple simultaneous prog runs

ok, I'll put some comments in here about that

thanks,
jirka
