Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51674A8736
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351631AbiBCPGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:06:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58025 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240931AbiBCPGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:06:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643900801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e8niZzxOerSalLROqW1yaPIfEQIUnjkuK5AiQtq2ICQ=;
        b=X5oamp2cmOK8WfguDT/OqzqyxmO/VyAyAPYWR4KjuOrtgRL/Qu99t5eFPeiTWobebCfMaM
        0gcHj65vf5Mbz1pqTgtDB52zxkJSKs/m57lznRcC9pNSicTLyvEic4rHMtBTYa4NldJT0e
        nMWPDdTbseZMXSeo4Rto0G0KuinhXKI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-QZAW2P4PN1S_NtO9hwNB0g-1; Thu, 03 Feb 2022 10:06:40 -0500
X-MC-Unique: QZAW2P4PN1S_NtO9hwNB0g-1
Received: by mail-wm1-f70.google.com with SMTP id s1-20020a1ca901000000b0034ece94dd8cso5947585wme.5
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 07:06:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e8niZzxOerSalLROqW1yaPIfEQIUnjkuK5AiQtq2ICQ=;
        b=bniintgTLHqx9ytvUCrBEDGM382lmXyfkYA/R3z1Dws0TjAVodqAzz6l675P2hvBrm
         fuIhs3DU4lcoQ1fQs5XncCf1I72XZoREgFidScNspIJmufGDm8VO0rqn5tA5nNdbGQ6c
         4s8J8tZwJLbjYZtx0GGcCQCIwV7R4HwI0WdVknloF/uCuVx4QKxuXBTZD1avt6JpnlSE
         EOP8B0JIzfarQndgpcIolPrc8GQT82lTBPjZTaB76WO/4YwsDKRrODK7OMtADamYPjRt
         fIgF+74ckHmcC6spB93Un0QLX528qTspbkda04Q3EmQUeVfufP9Qju/v5jYU7waQjpas
         KHHQ==
X-Gm-Message-State: AOAM532dGWBOncNHpKsTI8HQD46B/OgW81nE6luFavZ/6DHS4kh5dNfr
        6Q5NvzEsCok7TSg0fxQUcelo20OrPFD25CUleGJ5v6R0q/jgNtvhLT6+ofyxKlBdXce8GRPh7d6
        4t5z/jQKcnusBRhvS
X-Received: by 2002:a5d:584a:: with SMTP id i10mr29740979wrf.305.1643900799582;
        Thu, 03 Feb 2022 07:06:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz934L+SQrIz7AUepaOSxtsJhAkKBx/N4nuAG+HSxmSd7bSFbI6AAieW+uCHw3WJ9ij5COWtQ==
X-Received: by 2002:a5d:584a:: with SMTP id i10mr29740953wrf.305.1643900799362;
        Thu, 03 Feb 2022 07:06:39 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id o10sm9478745wri.69.2022.02.03.07.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 07:06:38 -0800 (PST)
Date:   Thu, 3 Feb 2022 16:06:36 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
Message-ID: <YfvvfLlM1FOTgvDm@krava>
References: <20220202135333.190761-1-jolsa@kernel.org>
 <CAADnVQ+hTWbvNgnvJpAeM_-Ui2-G0YSM3QHB9G2+2kWEd4-Ymw@mail.gmail.com>
 <Yfq+PJljylbwJ3Bf@krava>
 <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 09:30:21AM -0800, Alexei Starovoitov wrote:
> On Wed, Feb 2, 2022 at 9:24 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Wed, Feb 02, 2022 at 09:09:53AM -0800, Alexei Starovoitov wrote:
> > > On Wed, Feb 2, 2022 at 5:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > hi,
> > > > this patchset adds new link type BPF_LINK_TYPE_FPROBE that attaches kprobe
> > > > program through fprobe API [1] instroduced by Masami.
> > >
> > > No new prog type please.
> > > I thought I made my reasons clear earlier.
> > > It's a multi kprobe. Not a fprobe or any other name.
> > > The kernel internal names should not leak into uapi.
> > >
> >
> > well it's not new prog type, it's new link type that allows
> > to attach kprobe program to multiple functions
> >
> > the original change used BPF_LINK_TYPE_RAW_KPROBE, which did not
> > seem to fit anymore, so I moved to FPROBE, because that's what
> > it is ;-)
> 
> Now I don't like the fprobe name even more.
> Why invent new names? It's an ftrace interface.

how about ftrace_probe ?

> 
> > but if you don't want new name in uapi we could make this more
> > obvious with link name:
> >   BPF_LINK_TYPE_MULTI_KPROBE
> >
> > and bpf_attach_type:
> >   BPF_TRACE_MULTI_KPROBE
> 
> I'd rather get rid of fprobe name first.
>

Masami, any idea?

thanks,
jirka

