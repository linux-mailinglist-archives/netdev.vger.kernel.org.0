Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF571C76E2
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbgEFQpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729443AbgEFQpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:45:15 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F915C061A0F;
        Wed,  6 May 2020 09:45:15 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id a21so3068271ljj.11;
        Wed, 06 May 2020 09:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MMJ57z7gyime8JUbPPTxoLaqhFOSgbz56a0mqbrKKmU=;
        b=rfsmTOrWnb8AT7pSMRewv20SzwAbPx5OxdUQSAlPuypsh96/n+P4HvmwqSHOwuF2q7
         LyqsibwbMRusPiHBjOzIBAtAXGIjW/Ysxsp830wc04cezAVwVFKuHfreRP93sAcXwxI6
         0EIcYyVCez9xGy9sS2Tlj2LFkWRKoHWaOOIbgQkSCt280OeIs594hg2kvApmgsuFtF2e
         BB03lFupEiju1cv25/xg5yv5XFVdK6Sthf2DkUUnStx4A2I8RC/IUtvyw6MQ977GT2my
         i+boDP1UnRbQ89qglSJKAqfP1P9WYyr6G8U3gsK15ef0o+cw1KdDszEwk3nnqOwCTIM3
         nv5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MMJ57z7gyime8JUbPPTxoLaqhFOSgbz56a0mqbrKKmU=;
        b=haRdtC+P6O5fTOXeddn1ZXcGVo8nmNfG4J4wytFWEosG8B9WfeBEAZCNlLMMA+Axve
         PTfi0laRDbo82mwEruLL0K2GwuM9xXYHziOHbjIb8E0b4jwr9yyTfY/XuHmQPYggFOI6
         /kFdHa499F0pL4Sv1PHTB/3IrLxveGZA9wDqelg71hP7w5xi2gnVGzaKp8idptK84tWj
         9E45Z8QHxt+MoFClHAFlqMiUK6z1Rm9uoeWm83i3Zzyy1JwQA7YYA19QLvgmcp9I1AeM
         +fvqNRLzmRGurypZ1VRs/0SVFCEh7Unxjx+UVuXz1dSxtBaMmnUEMGMW+5izIf4lfe2g
         NwYg==
X-Gm-Message-State: AGi0PuZxbRZA4KL5LEEVy1Z2gWnUpR9AgYnDkH0Ul1YlXI/cQlPkPuVs
        jealIlI4woOu0q6qPKymvfqM543rEEV2/xEenCM=
X-Google-Smtp-Source: APiQypITXZ7XxLeHgER4itpYg0oH53NvUDXD6iE/CeuNaxMVseabfH6r/ENyVn6h5hAkP262ZIYTbFUzmMETktxGj/0=
X-Received: by 2002:a2e:b80b:: with SMTP id u11mr5753394ljo.212.1588783512822;
 Wed, 06 May 2020 09:45:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200501192204.cepwymj3fln2ngpi@treble> <20200501194053.xyahhknjjdu3gqix@ast-mbp.dhcp.thefacebook.com>
 <20200501195617.czrnfqqcxfnliz3k@treble> <20200502030622.yrszsm54r6s6k6gq@ast-mbp.dhcp.thefacebook.com>
 <20200502192105.xp2osi5z354rh4sm@treble> <20200505174300.gech3wr5v6kkho35@ast-mbp.dhcp.thefacebook.com>
 <20200505181108.hwcqanvw3qf5qyxk@treble> <20200505195320.lyphpnprn3sjijf6@ast-mbp.dhcp.thefacebook.com>
 <20200505202823.zkmq6t55fxspqazk@treble> <20200505235939.utnmzqsn22cec643@ast-mbp.dhcp.thefacebook.com>
 <20200506155343.7x3slq3uasponb6w@treble>
In-Reply-To: <20200506155343.7x3slq3uasponb6w@treble>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 6 May 2020 09:45:01 -0700
Message-ID: <CAADnVQJZ1rj1DB-Y=85itvfcHxnXVKjhJXpzqs6zZ6ZLpexhCQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: Tweak BPF jump table optimizations for objtool compatibility
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 8:53 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Tue, May 05, 2020 at 04:59:39PM -0700, Alexei Starovoitov wrote:
> > As far as workaround I prefer the following:
> > From 94bbc27c5a70d78846a5cb675df4cf8732883564 Mon Sep 17 00:00:00 2001
> > From: Alexei Starovoitov <ast@kernel.org>
> > Date: Tue, 5 May 2020 16:52:41 -0700
> > Subject: [PATCH] bpf,objtool: tweak interpreter compilation flags to help objtool
> >
> > tbd
> >
> > Fixes: 3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Reported-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  include/linux/compiler-gcc.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> > index d7ee4c6bad48..05104c3cc033 100644
> > --- a/include/linux/compiler-gcc.h
> > +++ b/include/linux/compiler-gcc.h
> > @@ -171,4 +171,4 @@
> >  #define __diag_GCC_8(s)
> >  #endif
> >
> > -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> > +#define __no_fgcse __attribute__((optimize("-fno-gcse,-fno-omit-frame-pointer")))
> > --
> > 2.23.0
> >
> > I've tested it with gcc 8,9,10 and clang 11 with FP=y and with ORC=y.
> > All works.
> > I think it's safer to go with frame pointers even for ORC=y considering
> > all the pain this issue had caused. Even if objtool gets confused again
> > in the future __bpf_prog_run() will have frame pointers and kernel stack
> > unwinding can fall back from ORC to FP for that frame.
> > wdyt?
>
> It seems dangerous to me.  The GCC manual recommends against it.

The manual can says that it's broken. That won't stop the world from using it.
Just google projects that are using it. For example: qt, lz4, unreal engine, etc
Telling compiler to disable gcse via flag is a guaranteed way to avoid
that optimization that breaks objtool whereas messing with C code is nothing
but guess work. gcc can still do gcse.
