Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5400633FA3B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 22:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhCQVAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 17:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbhCQVAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 17:00:48 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF36C06175F;
        Wed, 17 Mar 2021 14:00:46 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id f16so4958958ljm.1;
        Wed, 17 Mar 2021 14:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S+hbvjY8Ofr8R5U1G+M1hOF5PvSdWEJuwFSEr/rTTtg=;
        b=kVZ4jhZQ17XJNR0AY3bfdewdeyD7S1ZhncJIhhbz544hLSpgW5DJrhezZgdDbICu8p
         0TsoI2V8bGHIzEZ3xE8evXQHcuPTCe2lLqtkVfGgfEkq+6LetwPFugh2n7EloeSJDGc9
         V7ehlRiCGHtq4e43SWs4H4CoPkAXoCSt2d6au24I+jovN5/JgIYrGZ5cETlUYHUhsCFF
         mxeYIF1uTY9AHxeR1Fh+Am0zJfZ+Y35btS3Tv0hpFp78kuef1jX9STNzizyRNRzWQUwo
         ozXl1WC3MjfwQ9Lzyo70AiTx9G8tbzlKkIUxG4/ubPlfnn6kFalmAg7dIZ4fCMZ7at+4
         mazw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+hbvjY8Ofr8R5U1G+M1hOF5PvSdWEJuwFSEr/rTTtg=;
        b=EkRKj3sCRHJKrLFqG4TKQ4q0lUZhMIrWjsf20zyTvFJXcxvlAAfYFBJ9JkgKdWYs7I
         HNHX+HMT6mNhTlSamPbUVdcB3Clk97jTuf/8Ib/7fDxMNQmTVBLxAB2De19+U4Qmuzo9
         m6+IVyQlcmIyqoi9F4PnLkEXIQNfdyzWNKJafiJEFN6w52uLRNzL8VJojIL2NsfsJH3i
         dxD+z54oO4vZJ7PG7G6yrmswRtARB+0dtYYFMmIu0g2HbtngTC44xkHLquVKcjL5cTVt
         IkQ4LCHf3slvK6IoyO1lKx8Js4a+pJRnvbicBI5tPwWh9QjMay7P/ZMlppx65tvVwAwX
         +5rA==
X-Gm-Message-State: AOAM532u+jib/D+KqYMCQhjSU+H5nBQq6c9tJ2UdgVud+ptmMVUAU6R0
        xA49reoB12ZwG3jfU2lerXMPDJb01hNDfmBNxVvH4qJ4BCg=
X-Google-Smtp-Source: ABdhPJz3T9IfaMkkukEt32EClX3ggy1HoKqa9TTuZ1t274mZ7lNuGSHvQM3uaj+1kC0NhMZotWGlQH7w4Fq9xe4nSVc=
X-Received: by 2002:a2e:b817:: with SMTP id u23mr3352262ljo.44.1616014844802;
 Wed, 17 Mar 2021 14:00:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210313193537.1548766-1-andrii@kernel.org> <20210313193537.1548766-11-andrii@kernel.org>
 <20210317053437.r5zsoksdqrxtt22r@ast-mbp> <CAEf4BzZ2TxWqVG=VqFw18--dvC=M5ONRUAde2EB_0yBaYkHb2Q@mail.gmail.com>
In-Reply-To: <CAEf4BzZ2TxWqVG=VqFw18--dvC=M5ONRUAde2EB_0yBaYkHb2Q@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 17 Mar 2021 14:00:33 -0700
Message-ID: <CAADnVQ+1w8rqGNax6PysTh5SwpdKr8dd3TmCEvwDZ2+=ouTRkA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/11] selftests/bpf: pass all BPF .o's
 through BPF static linker
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 1:47 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Mar 16, 2021 at 10:34 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Sat, Mar 13, 2021 at 11:35:36AM -0800, Andrii Nakryiko wrote:
> > >
> > > -$(TRUNNER_BPF_SKELS): $(TRUNNER_OUTPUT)/%.skel.h:                    \
> > > -                   $(TRUNNER_OUTPUT)/%.o                             \
> > > -                   $(BPFTOOL)                                        \
> > > -                   | $(TRUNNER_OUTPUT)
> > > +$(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
> > >       $$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
> > > -     $(Q)$$(BPFTOOL) gen skeleton $$< > $$@
> > > +     $(Q)$$(BPFTOOL) gen object $$(<:.o=.bpfo) $$<
> > > +     $(Q)$$(BPFTOOL) gen skeleton $$(<:.o=.bpfo) > $$@
> >
> > Do we really need this .bpfo extension?
>
> I thought it would be a better way to avoid user's confusion with .o's
> as produced by compiler and .bpfo as a "final" linked BPF object,
> produced by static linker. Technically, there is no requirement, of
> course. If you think it will be less confusing to stick to .o, that's
> fine.
>
> > bpftool in the previous patch doesn't really care about the extension.
>
> the only thing that cares is the logic to derive object name when
> generating skeleton (we strip .o and/or .bpfo). No loader should ever
> care about extension, it could be my_obj.whocares and it should be
> fine.
>
> > It's still a valid object file with the same ELF format.
>
> Yes, with some extra niceties like fixed up BTF, stripped out DWARF,
> etc. Maybe in the future there will be more "normalization" done as
> compared to what Clang produces.
>
> > I think if we keep the same .o extension for linked .o-s it will be easier.
> > Otherwise all loaders would need to support both .o and .bpfo,
> > but the later is no different than the former in terms of contents of the file
> > and ways to parse it.
>
> So no loaders should care right now. But as I said, I can drop .bpfo as well.
>
> >
> > For testing of the linker this linked .o can be a temp file or better yet a unix pipe ?
> > bpftool gen object - one.o second.o|bpftool gen skeleton -
>
> So I tried to briefly add support for that to `gen skeleton` and `gen
> object` by using /proc/self/fd/{0,1} and that works for `gen object`,
> but only if stdout is redirected to a real file. When piping output to
> another process, libelf fails to write to such a special file for some
> reason. `gen skeleton` is also failing to read from a piped stdin
> because of use of mmap(). So there would need to be more work done to
> support piping like that.
>
> But in any case I'd like to have those intermediate object file
> results lying on disk for further inspection, if anything isn't right,
> so I'll use temp file regardless.

May keep those temp .o files with .linked.o suffix?
Also have you considered doing:
clang -target bpf prog.c -o prog.o
bpftool gen obj obj1.o prog.o
bpftool gen obj obj2.o obj1.o
diff obj1.o obj2.o
They should be the same, right?
