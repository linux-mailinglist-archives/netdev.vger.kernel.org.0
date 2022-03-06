Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABCC4CEC7F
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 18:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbiCFRaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 12:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbiCFRaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 12:30:12 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E216286CC;
        Sun,  6 Mar 2022 09:29:18 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id q7-20020a7bce87000000b00382255f4ca9so9517064wmj.2;
        Sun, 06 Mar 2022 09:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vCBQy4KJqltdm7PE5T/0bIOOTxlcDLe86iRXNeiB2y8=;
        b=fEZugXS/OIKaS3ixfXmb61G2hogkvJM/sDl1zeG4KZtFB9IA4RqbL0v9tmvCtB/9cG
         CulivxeOCACF83ITc/Itlgfoa89BCG8x6BVpa7QsBrrCqRAS5mSeBVTcx21UKQglafO9
         u6UTgrogZ9vVYo6Jpku2R7kPMsS7EEfdJtw3+SzX2DJtExXoGBKvQxgQy3dCuKS9sF8B
         amLHQvYNSImD/ShE48SajnTNT1Us+4y05HR5kgIyEKn7irLWja2spesk/DT+epNSEMua
         hou54Sx51i/eSs8b5vroDkZ5FlihcKuiNGlo26Fxr3W0ZBk7GV9LWtYeDh7urFHQNiAw
         aq4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vCBQy4KJqltdm7PE5T/0bIOOTxlcDLe86iRXNeiB2y8=;
        b=LIOF/Zv3DWwtnX1ccGX8OISOgp26dX3HwM2Jq2Yfzwi81PrddBdjNw9h1348JqsxzE
         rTW+ePIMvT3tXCCJZi06GCsFqKgrvRojcLQ9EM3v5FejfrpI/LAtlHLqWZn2pdMGsTUE
         wiD2KT1dOAiqVOiKQZYJthUJ14hJpEyr/blROpz559kndbd3epkZ+m+nfeOwQgd2Y7V8
         aw8cvKR67TI5qNh1N8deUi2FdW1Ql1rL1lWmRoMzM7VaCekJYOAPBZDOyadM3kzhjp7D
         a764ZanFpIGsHHoLTN40W+AyzqMYTfsBhMo+VzafDmlbtI1Pt7MybgvTzn2BQ19WJRVe
         /yqA==
X-Gm-Message-State: AOAM531jpQGh0NfyfanyRFK2/5EkxQUaCcYhQcqtBu1o6arFltzuXZdN
        u0C233y9aykuLPVN6L8yh80=
X-Google-Smtp-Source: ABdhPJz0xXlL5KoQGSKJRRh5a2AqQ3bvpqqzLjgMHAmw2vD/rGtfFrQ36myHTWngJbYFTva4qqCA+Q==
X-Received: by 2002:a05:600c:1da7:b0:381:2262:56d2 with SMTP id p39-20020a05600c1da700b00381226256d2mr15496337wms.133.1646587756666;
        Sun, 06 Mar 2022 09:29:16 -0800 (PST)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id k10-20020adfe3ca000000b001f0329ba94csm15083787wrm.18.2022.03.06.09.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 09:29:16 -0800 (PST)
Date:   Sun, 6 Mar 2022 18:29:14 +0100
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
Subject: Re: [PATCH 07/10] libbpf: Add bpf_link_create support for multi
 kprobes
Message-ID: <YiTvapbx1pR2bUur@krava>
References: <20220222170600.611515-1-jolsa@kernel.org>
 <20220222170600.611515-8-jolsa@kernel.org>
 <CAEf4BzYdSwPfiTmP-vBry23F7+vDR3Q+r0qwuQ3OaL09YjxUew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYdSwPfiTmP-vBry23F7+vDR3Q+r0qwuQ3OaL09YjxUew@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 03:11:16PM -0800, Andrii Nakryiko wrote:
> On Tue, Feb 22, 2022 at 9:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding new kprobe_multi struct to bpf_link_create_opts object
> > to pass multiple kprobe data to link_create attr uapi.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/lib/bpf/bpf.c | 7 +++++++
> >  tools/lib/bpf/bpf.h | 9 ++++++++-
> >  2 files changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > index 418b259166f8..5e180def2cef 100644
> > --- a/tools/lib/bpf/bpf.c
> > +++ b/tools/lib/bpf/bpf.c
> > @@ -853,6 +853,13 @@ int bpf_link_create(int prog_fd, int target_fd,
> >                 if (!OPTS_ZEROED(opts, perf_event))
> >                         return libbpf_err(-EINVAL);
> >                 break;
> > +       case BPF_TRACE_KPROBE_MULTI:
> > +               attr.link_create.kprobe_multi.syms = OPTS_GET(opts, kprobe_multi.syms, 0);
> > +               attr.link_create.kprobe_multi.addrs = OPTS_GET(opts, kprobe_multi.addrs, 0);
> > +               attr.link_create.kprobe_multi.cookies = OPTS_GET(opts, kprobe_multi.cookies, 0);
> > +               attr.link_create.kprobe_multi.cnt = OPTS_GET(opts, kprobe_multi.cnt, 0);
> > +               attr.link_create.kprobe_multi.flags = OPTS_GET(opts, kprobe_multi.flags, 0);
> > +               break;
> >         default:
> >                 if (!OPTS_ZEROED(opts, flags))
> >                         return libbpf_err(-EINVAL);
> > diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> > index 16b21757b8bf..bd285a8f3420 100644
> > --- a/tools/lib/bpf/bpf.h
> > +++ b/tools/lib/bpf/bpf.h
> > @@ -413,10 +413,17 @@ struct bpf_link_create_opts {
> >                 struct {
> >                         __u64 bpf_cookie;
> >                 } perf_event;
> > +               struct {
> > +                       __u64 syms;
> > +                       __u64 addrs;
> > +                       __u64 cookies;
> 
> hm, I think we can and should use proper types here, no?
> 
> const char **syms;
> const void **addrs;
> const __u64 *cookies;
> 
> ?

right, will change

thanks,
jirka
