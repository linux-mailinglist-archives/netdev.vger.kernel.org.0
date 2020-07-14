Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2E221EC8C
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGNJUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:20:02 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:32899 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgGNJUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 05:20:00 -0400
Received: by mail-ot1-f66.google.com with SMTP id h13so12557339otr.0;
        Tue, 14 Jul 2020 02:19:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lr6ehkiA+wQTlVbgKUBtfLmjH6B35ZHI7I1BOUE7Afo=;
        b=t3icOm9FBPBdB2+Fp9LxU1YRusbuEdz/FTmz/ZCHqoWOaIJToTAFWFvq4MrZip0sfH
         ZMtC7It3CW5yQfa+pssA3AAvkW3IT/HAKF9jU9QOqBDbtczWUxPw2zg9yYD4ca6Ul4sl
         /L66+Puw1yhpyMFAYHctjn/9JMtvwjGQOhwXjUmKFPj+4BXAEOdElceJkVwCZ3vD2DV4
         6mPyNtQKIQTP4I5SDmy554m65nHLOAj8u2Xe5fzFUs2h5vfCqgzKejrdtXFcL1NzO5FH
         ahkSm4JZ3HVGo4amx+d+pM7QHf93Xjbja0YndPyvwUfMNB+c/Hz6xoivmRvkKdgT6mlX
         nG5w==
X-Gm-Message-State: AOAM530SPu3PO0/rLqk3e50aJcENKQN27GqjkgC2Nmc6KZhzPu/yN/3/
        8vjI8IOk+xylsKRYGi/+YRDRYz+09eZiiomFn94=
X-Google-Smtp-Source: ABdhPJymM3jUthOU7MUC7BJJVYVEZLSfzetmtXN1UCJV7+dkv0NdChE4LhYysx3KVtt2ozOxEExy7AyZyfrvt66ViT4=
X-Received: by 2002:a9d:2646:: with SMTP id a64mr3032121otb.107.1594718399477;
 Tue, 14 Jul 2020 02:19:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200714122247.797cf01e@canb.auug.org.au> <20200714061654.GE183694@krava>
 <20200714083133.GF183694@krava>
In-Reply-To: <20200714083133.GF183694@krava>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 14 Jul 2020 11:19:47 +0200
Message-ID: <CAMuHMdVjyHAJJNNUwva=RnyLxV--kVpgSWAic7WoJMgf_Ri+NQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Tue, Jul 14, 2020 at 10:33 AM Jiri Olsa <jolsa@redhat.com> wrote:
> On Tue, Jul 14, 2020 at 08:16:54AM +0200, Jiri Olsa wrote:
> > On Tue, Jul 14, 2020 at 12:22:47PM +1000, Stephen Rothwell wrote:
> > > After merging the bpf-next tree, today's linux-next build (arm
> > > multi_v7_defconfig) failed like this:
> > >
> > > tmp/ccsqpVCY.s: Assembler messages:
> > > tmp/ccsqpVCY.s:78: Error: unrecognized symbol type ""
> > > tmp/ccsqpVCY.s:91: Error: unrecognized symbol type ""
> > >
> > > I don't know what has caused this (I guess maybe the resolve_btfids
> > > branch).
> > >
> > > I have used the bpf-next tree from next-20200713 for today.

Bummer, didn't find this report before I had bisected this to
c9a0f3b85e09dd16 ("bpf: Resolve BTF IDs in vmlinux image"), and
investigated the root cause (@object) myself, as the failing file path
(net/core/filter.o) was not mentioned...

> > ok, trying to reproduce
>
> damn crossbuilds.. change below fixes it for me,
> will do some more testing and post it today

Thanks, this fixes my (cross)arm32 build, and the (cross)arm64 build
keeps working, and everything boots, so
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
