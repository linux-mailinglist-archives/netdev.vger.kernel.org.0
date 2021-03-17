Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E74433FA1D
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 21:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbhCQUre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 16:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbhCQUrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 16:47:23 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EEEC06174A;
        Wed, 17 Mar 2021 13:47:22 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 133so333396ybd.5;
        Wed, 17 Mar 2021 13:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=it8U0w3MjTXYKTU/soyaEuoZ9Qji+7MJUL+YSn8iD9E=;
        b=gFqEFwiekclCs0S4mOFoBjZ6R8H98SEnVijubosGjv3cGL61fRXwhGWU/aHWV/2NPu
         1jfYD6do9YnUGO51F2hukxdF0rfHwLS2+ughnVo2qBp6GVrNL2zCJobQ5vVg0tlOI5Hx
         4FyxdcUMvYQw4uiNs6kpQVi0XSa6LKEO5Mhh7kMPV9FPEibnuVGO+vvp9CaPd7rPsmll
         jsrHvq7LlajZ71adzcPUiiEsQMgUZgns8QZvgEvud8Sok780QlF1KNwDuaf7DrWZOxAv
         ER05UgOgCM+tqruFnNQhT3988ZMVh07oCW/Sbwr3Acn0B/KcuUuosalwoOaKxhh1H1Yb
         v1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=it8U0w3MjTXYKTU/soyaEuoZ9Qji+7MJUL+YSn8iD9E=;
        b=kD3sGQh72691NqSxW+l8NpwfwvX3OysgZXw+QsJOf0LYqQvh1NxkP9LsHd0oSXwhjB
         TUrlwhdV+fpSYyEVplFr4dfjTI4hu3GZtza7pHOVtbnVEZu5MilDu4VsFWp7P0CrJZtp
         AUP8Cjumxwp53JnOH4FnnMMMBbl7uOYR9B6wh9bzjOpOrokDnvj3ph3iA5FN+f5Pigrk
         mnoFNE8FB5m2d0/6dwMkKl1PGxesRcGGrCcb4oN67FlOe9M2KlUXiZ5rWY8u2V5TO3Mn
         +NVa0q25ug3tx9jaobmWLzcbxKpFmPnDyo/Ckkztcqi1ZMhBxMxWSL94LXQDnCXLfEoe
         QUiQ==
X-Gm-Message-State: AOAM532GfExct+417klT55os7ZgOzMHABB1sdkjCqHWCdVOcTAR6AOOd
        CU5Jvsz52A74xFIQOQBv10KAUTN2ZvY5mzeze/4=
X-Google-Smtp-Source: ABdhPJzPB2EbyMLIungWARpJAZq47cQKM1cfsI1y9RNwEZZ5l95yKrxMLePJmUiA6CdUXl/IcW4B2cxuqSqEutlkq9g=
X-Received: by 2002:a25:4982:: with SMTP id w124mr864240yba.27.1616014042151;
 Wed, 17 Mar 2021 13:47:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210313193537.1548766-1-andrii@kernel.org> <20210313193537.1548766-11-andrii@kernel.org>
 <20210317053437.r5zsoksdqrxtt22r@ast-mbp>
In-Reply-To: <20210317053437.r5zsoksdqrxtt22r@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 17 Mar 2021 13:47:11 -0700
Message-ID: <CAEf4BzZ2TxWqVG=VqFw18--dvC=M5ONRUAde2EB_0yBaYkHb2Q@mail.gmail.com>
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

On Tue, Mar 16, 2021 at 10:34 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Mar 13, 2021 at 11:35:36AM -0800, Andrii Nakryiko wrote:
> >
> > -$(TRUNNER_BPF_SKELS): $(TRUNNER_OUTPUT)/%.skel.h:                    \
> > -                   $(TRUNNER_OUTPUT)/%.o                             \
> > -                   $(BPFTOOL)                                        \
> > -                   | $(TRUNNER_OUTPUT)
> > +$(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
> >       $$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
> > -     $(Q)$$(BPFTOOL) gen skeleton $$< > $$@
> > +     $(Q)$$(BPFTOOL) gen object $$(<:.o=.bpfo) $$<
> > +     $(Q)$$(BPFTOOL) gen skeleton $$(<:.o=.bpfo) > $$@
>
> Do we really need this .bpfo extension?

I thought it would be a better way to avoid user's confusion with .o's
as produced by compiler and .bpfo as a "final" linked BPF object,
produced by static linker. Technically, there is no requirement, of
course. If you think it will be less confusing to stick to .o, that's
fine.

> bpftool in the previous patch doesn't really care about the extension.

the only thing that cares is the logic to derive object name when
generating skeleton (we strip .o and/or .bpfo). No loader should ever
care about extension, it could be my_obj.whocares and it should be
fine.

> It's still a valid object file with the same ELF format.

Yes, with some extra niceties like fixed up BTF, stripped out DWARF,
etc. Maybe in the future there will be more "normalization" done as
compared to what Clang produces.

> I think if we keep the same .o extension for linked .o-s it will be easier.
> Otherwise all loaders would need to support both .o and .bpfo,
> but the later is no different than the former in terms of contents of the file
> and ways to parse it.

So no loaders should care right now. But as I said, I can drop .bpfo as well.

>
> For testing of the linker this linked .o can be a temp file or better yet a unix pipe ?
> bpftool gen object - one.o second.o|bpftool gen skeleton -

So I tried to briefly add support for that to `gen skeleton` and `gen
object` by using /proc/self/fd/{0,1} and that works for `gen object`,
but only if stdout is redirected to a real file. When piping output to
another process, libelf fails to write to such a special file for some
reason. `gen skeleton` is also failing to read from a piped stdin
because of use of mmap(). So there would need to be more work done to
support piping like that.

But in any case I'd like to have those intermediate object file
results lying on disk for further inspection, if anything isn't right,
so I'll use temp file regardless.
