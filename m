Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5B233FA6B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 22:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhCQVWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 17:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhCQVWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 17:22:22 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3F0C06174A;
        Wed, 17 Mar 2021 14:22:21 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id m9so408359ybk.8;
        Wed, 17 Mar 2021 14:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KGe+4PixPm3iQK4PcnZWsHK5Evuz5WbynzjiC9oafV4=;
        b=PWx+Y4rfPNY++geJic6vJS1Zp+BALwBKrr/Q1bSBiIvxcMgUtp3w2xoTym3xEn00dg
         S37lrpAmIAjkPD9ABkJsYqnqyLNYapfgyJjAa5lqOaWuxOrRryKB3/4VrUvEzy42IQih
         ZLqdEebfKGDq+WiSnxXht/j6p3W3zZfWiLzhQHRA5YV3pXbbDf/Dg72FaChhzR+/jh4d
         mRStMFd8LAECvJECJnnkdsPqnU+coTanP9f4c0GwHXXyV4mRcrDrEoVBL10aBsW099V0
         Mp+TkrgF+PkY9S/fJ1k9P2gGLlE8Y63et5I9nLbRvcFI9mpC35G8ZbU5WFdBBiMfSf54
         LhsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KGe+4PixPm3iQK4PcnZWsHK5Evuz5WbynzjiC9oafV4=;
        b=ReP0Nny1dUNtnUkJL7HUhXTMgNPXDZhsuMxBbNrk2PetGv8Zgc0zZPMp8OcSF9hthZ
         3E8cvMFdHmBkPkjqbie0MAsKj90DAgeZDvpGZEd5osH8zEZ4qMQBXFgOORPZnq4PEROr
         p3HCQrF7awco8g76HXNzXb97rACIY2GjaLlVriTFRMyHxrZcuw0eH4+IH3LjGf6LzmsW
         4/yva0ewIgGU8wlKE96/621XZhEUtZvlBXrFVTuAFldtcvzHoo5D4fvI4CIWXAlAQQW0
         0ag+99iijlqCPptOql/eifVUyqSBi5SITYQnmkAS+biAaE01OA+JTMAVGCHruZXwTUds
         /L0A==
X-Gm-Message-State: AOAM531z7S9u45TM54bb7VSF2NtnMs80lXdZlZQmsXuEnLMn0VlI+DnK
        +5EaltrO9kpowbb/NK34o+tF/RdPr72tMCt1M2M=
X-Google-Smtp-Source: ABdhPJzySL7xTCe970GvuQwl5Bl4WXBiUQyM6a7l09Jge/vPhYI3YQoC+O7OI2JB/1RrnsdoUOn/3PdnhTsbEFs7WKg=
X-Received: by 2002:a25:874c:: with SMTP id e12mr6753933ybn.403.1616016140983;
 Wed, 17 Mar 2021 14:22:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210313193537.1548766-1-andrii@kernel.org> <20210313193537.1548766-11-andrii@kernel.org>
 <20210317053437.r5zsoksdqrxtt22r@ast-mbp> <CAEf4BzZ2TxWqVG=VqFw18--dvC=M5ONRUAde2EB_0yBaYkHb2Q@mail.gmail.com>
 <CAADnVQ+1w8rqGNax6PysTh5SwpdKr8dd3TmCEvwDZ2+=ouTRkA@mail.gmail.com>
In-Reply-To: <CAADnVQ+1w8rqGNax6PysTh5SwpdKr8dd3TmCEvwDZ2+=ouTRkA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 17 Mar 2021 14:22:10 -0700
Message-ID: <CAEf4BzZYnSK2nncHocJjMo-obQ_p4u0ofiUFHqvO18nZG2_=Ew@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/11] selftests/bpf: pass all BPF .o's
 through BPF static linker
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 2:00 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Mar 17, 2021 at 1:47 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Mar 16, 2021 at 10:34 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Sat, Mar 13, 2021 at 11:35:36AM -0800, Andrii Nakryiko wrote:
> > > >
> > > > -$(TRUNNER_BPF_SKELS): $(TRUNNER_OUTPUT)/%.skel.h:                    \
> > > > -                   $(TRUNNER_OUTPUT)/%.o                             \
> > > > -                   $(BPFTOOL)                                        \
> > > > -                   | $(TRUNNER_OUTPUT)
> > > > +$(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
> > > >       $$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
> > > > -     $(Q)$$(BPFTOOL) gen skeleton $$< > $$@
> > > > +     $(Q)$$(BPFTOOL) gen object $$(<:.o=.bpfo) $$<
> > > > +     $(Q)$$(BPFTOOL) gen skeleton $$(<:.o=.bpfo) > $$@
> > >
> > > Do we really need this .bpfo extension?
> >
> > I thought it would be a better way to avoid user's confusion with .o's
> > as produced by compiler and .bpfo as a "final" linked BPF object,
> > produced by static linker. Technically, there is no requirement, of
> > course. If you think it will be less confusing to stick to .o, that's
> > fine.
> >
> > > bpftool in the previous patch doesn't really care about the extension.
> >
> > the only thing that cares is the logic to derive object name when
> > generating skeleton (we strip .o and/or .bpfo). No loader should ever
> > care about extension, it could be my_obj.whocares and it should be
> > fine.
> >
> > > It's still a valid object file with the same ELF format.
> >
> > Yes, with some extra niceties like fixed up BTF, stripped out DWARF,
> > etc. Maybe in the future there will be more "normalization" done as
> > compared to what Clang produces.
> >
> > > I think if we keep the same .o extension for linked .o-s it will be easier.
> > > Otherwise all loaders would need to support both .o and .bpfo,
> > > but the later is no different than the former in terms of contents of the file
> > > and ways to parse it.
> >
> > So no loaders should care right now. But as I said, I can drop .bpfo as well.
> >
> > >
> > > For testing of the linker this linked .o can be a temp file or better yet a unix pipe ?
> > > bpftool gen object - one.o second.o|bpftool gen skeleton -
> >
> > So I tried to briefly add support for that to `gen skeleton` and `gen
> > object` by using /proc/self/fd/{0,1} and that works for `gen object`,
> > but only if stdout is redirected to a real file. When piping output to
> > another process, libelf fails to write to such a special file for some
> > reason. `gen skeleton` is also failing to read from a piped stdin
> > because of use of mmap(). So there would need to be more work done to
> > support piping like that.
> >
> > But in any case I'd like to have those intermediate object file
> > results lying on disk for further inspection, if anything isn't right,
> > so I'll use temp file regardless.
>
> May keep those temp .o files with .linked.o suffix?

sure, no problem

> Also have you considered doing:
> clang -target bpf prog.c -o prog.o
> bpftool gen obj obj1.o prog.o
> bpftool gen obj obj2.o obj1.o
> diff obj1.o obj2.o
> They should be the same, right?

yeah, I can add check for that
