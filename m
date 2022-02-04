Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840104A91B9
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356283AbiBDAq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiBDAq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:46:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F62C061714;
        Thu,  3 Feb 2022 16:46:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA6716194A;
        Fri,  4 Feb 2022 00:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAD1C340E8;
        Fri,  4 Feb 2022 00:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643935585;
        bh=KnasKzPC2rpJ48+6l141M8t0itDGXTYhKozsZuyWfwE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VzNMyLHs39xZVHVY4WDNUfezDCHiOS96hm/rk8Kgo1uAe0noKV2Rqe/ywnVMU95k4
         GghhgewCeMMUhO/GVY+pBiIPij16bA2G2OgZH0FhR6fo4mGfz263OxZVqKFxPlp+Ux
         iD0OjRptj+gb0+0h1nAYo7OTjwLY1H6EZlNT/gAF6kKDbOFxog4W97pVvMRs+oKJEZ
         XAKuBodVLJpyMR8LYLpV0nRK0L+Aq5+8eHTl+oqFTEcyQkdgOM/Ab0+cQ2XpvOOVWY
         DHcpDG761xcF/UUwlXCx519tMkXcIBA77LaPpmjsg+yCrmRl3ZTB+tkgy3svTMkbN0
         Vetsh4AIzMUVw==
Date:   Fri, 4 Feb 2022 09:46:19 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
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
Message-Id: <20220204094619.2784e00c0b7359356458ca57@kernel.org>
In-Reply-To: <YfvvfLlM1FOTgvDm@krava>
References: <20220202135333.190761-1-jolsa@kernel.org>
        <CAADnVQ+hTWbvNgnvJpAeM_-Ui2-G0YSM3QHB9G2+2kWEd4-Ymw@mail.gmail.com>
        <Yfq+PJljylbwJ3Bf@krava>
        <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
        <YfvvfLlM1FOTgvDm@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 16:06:36 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Wed, Feb 02, 2022 at 09:30:21AM -0800, Alexei Starovoitov wrote:
> > On Wed, Feb 2, 2022 at 9:24 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Wed, Feb 02, 2022 at 09:09:53AM -0800, Alexei Starovoitov wrote:
> > > > On Wed, Feb 2, 2022 at 5:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > >
> > > > > hi,
> > > > > this patchset adds new link type BPF_LINK_TYPE_FPROBE that attaches kprobe
> > > > > program through fprobe API [1] instroduced by Masami.
> > > >
> > > > No new prog type please.
> > > > I thought I made my reasons clear earlier.
> > > > It's a multi kprobe. Not a fprobe or any other name.
> > > > The kernel internal names should not leak into uapi.
> > > >
> > >
> > > well it's not new prog type, it's new link type that allows
> > > to attach kprobe program to multiple functions
> > >
> > > the original change used BPF_LINK_TYPE_RAW_KPROBE, which did not
> > > seem to fit anymore, so I moved to FPROBE, because that's what
> > > it is ;-)
> > 
> > Now I don't like the fprobe name even more.
> > Why invent new names? It's an ftrace interface.
> 
> how about ftrace_probe ?

I thought What Alexei pointed was that don't expose the FPROBE name
to user space. If so, I agree with that. We can continue to use
KPROBE for user space. Using fprobe is just for kernel implementation.

It means that we may better to keep simple mind model (there are only
static event or dynamic kprobe event).


> > > but if you don't want new name in uapi we could make this more
> > > obvious with link name:
> > >   BPF_LINK_TYPE_MULTI_KPROBE
> > >
> > > and bpf_attach_type:
> > >   BPF_TRACE_MULTI_KPROBE
> > 
> > I'd rather get rid of fprobe name first.
> >
> 
> Masami, any idea?

Can't we continue to use kprobe prog type for user interface
and internally, if there are multiple kprobes or kretprobes
required, switch to use fprobe?

Thank you,

> 
> thanks,
> jirka
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
