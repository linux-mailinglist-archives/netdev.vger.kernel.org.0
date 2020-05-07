Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5960A1C7E4C
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgEGAED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbgEGAEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:04:02 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2E7C061A0F;
        Wed,  6 May 2020 17:04:01 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q24so1801341pjd.1;
        Wed, 06 May 2020 17:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=okdKAUysX4Iogtq2tGm2REvSuUq1m7NdPWmOdWCDAs0=;
        b=Xuv/JAvCTDu6Iy65aZsYW5VreQZWmcn99qdKaBhMNAiewObGh4BBNt8nnk4aCrdXNT
         AGTf+rnpUCYBia+cqAEV0d+2cbUOoe5/WuyxVbVMrx5f8LVTtqTKq2yccct0ln+Hs+CP
         dw5qDnHLCi8V1LWC8YTu9pL/Yu5r6vCiEqmBkNuP/2/uB3lzZ4owM5fFAvlR+0DY/nmk
         xvFZcbDR2Q9fYQ/Nmo/4IwDvi1z/FFSkq3/Wwa8hBjdUbPrm2/pWClMq0fnUaux04PZh
         nROm2uAxK+NxFyQg3UIcZ1kaJHVnaHM2tC3iRzn9YYbwvsxi3RfNKPBarZUmizw1ZgwP
         j/bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=okdKAUysX4Iogtq2tGm2REvSuUq1m7NdPWmOdWCDAs0=;
        b=pVpe8kk7o1ar7DyQe9pDnhKap2PciHt0bXtgAIBTg5Bih+kmOVftpYN04Vzr+wDTUJ
         W5v5CJdr/sn5AeJiaFFEXRw2456EleIpTcwK4tWphUj4LQ/pqXke0mAeix8IUvneo69j
         tYl/HJht6i3ir374S3jV/IIUeLr3N1oIUT0ZCIK2Q7uwnsVl2dV7NjBnutw5K16UBgFc
         THoDCwJQKJpYHgoPqbrPaHhFDhx71ablj6ZEzebePm+WuVQkB4EUHuez9WX6g4VChiZM
         MYNk5N21lw9UeRJM6PIWNwehR8ZuV+IKfjXjb+CP2J8ahb4S1ThFgkgF36JQjdjoXC/r
         FKxg==
X-Gm-Message-State: AGi0PuZY+MhuzN+Pi7LzD3DsHaMoIUpIt7Jg1G4fQVvUYWpaoAWjlzU0
        EzRCGxIyQnGJdRy9+iEAUqBigskS
X-Google-Smtp-Source: APiQypKYnifcuPrcGrAR6TRht9Xh/IqAubgwjUtpDTsslMwwnK2ZmtxkSNurHi4nLSRXKwXbjn0F7g==
X-Received: by 2002:a17:90a:d3ce:: with SMTP id d14mr12678369pjw.46.1588809840491;
        Wed, 06 May 2020 17:04:00 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2663])
        by smtp.gmail.com with ESMTPSA id 131sm2486768pgg.65.2020.05.06.17.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 17:03:59 -0700 (PDT)
Date:   Wed, 6 May 2020 17:03:57 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bpf: Tweak BPF jump table optimizations for objtool
 compatibility
Message-ID: <20200507000357.grprluieqa324v5c@ast-mbp.dhcp.thefacebook.com>
References: <20200502030622.yrszsm54r6s6k6gq@ast-mbp.dhcp.thefacebook.com>
 <20200502192105.xp2osi5z354rh4sm@treble>
 <20200505174300.gech3wr5v6kkho35@ast-mbp.dhcp.thefacebook.com>
 <20200505181108.hwcqanvw3qf5qyxk@treble>
 <20200505195320.lyphpnprn3sjijf6@ast-mbp.dhcp.thefacebook.com>
 <20200505202823.zkmq6t55fxspqazk@treble>
 <20200505235939.utnmzqsn22cec643@ast-mbp.dhcp.thefacebook.com>
 <20200506155343.7x3slq3uasponb6w@treble>
 <CAADnVQJZ1rj1DB-Y=85itvfcHxnXVKjhJXpzqs6zZ6ZLpexhCQ@mail.gmail.com>
 <20200506211945.4qhrxqplzmt4ul66@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506211945.4qhrxqplzmt4ul66@treble>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 04:19:45PM -0500, Josh Poimboeuf wrote:
> On Wed, May 06, 2020 at 09:45:01AM -0700, Alexei Starovoitov wrote:
> > On Wed, May 6, 2020 at 8:53 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > >
> > > On Tue, May 05, 2020 at 04:59:39PM -0700, Alexei Starovoitov wrote:
> > > > As far as workaround I prefer the following:
> > > > From 94bbc27c5a70d78846a5cb675df4cf8732883564 Mon Sep 17 00:00:00 2001
> > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > Date: Tue, 5 May 2020 16:52:41 -0700
> > > > Subject: [PATCH] bpf,objtool: tweak interpreter compilation flags to help objtool
> > > >
> > > > tbd
> > > >
> > > > Fixes: 3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > > > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > > > Reported-by: Arnd Bergmann <arnd@arndb.de>
> > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > > ---
> > > >  include/linux/compiler-gcc.h | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> > > > index d7ee4c6bad48..05104c3cc033 100644
> > > > --- a/include/linux/compiler-gcc.h
> > > > +++ b/include/linux/compiler-gcc.h
> > > > @@ -171,4 +171,4 @@
> > > >  #define __diag_GCC_8(s)
> > > >  #endif
> > > >
> > > > -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> > > > +#define __no_fgcse __attribute__((optimize("-fno-gcse,-fno-omit-frame-pointer")))
> > > > --
> > > > 2.23.0
> > > >
> > > > I've tested it with gcc 8,9,10 and clang 11 with FP=y and with ORC=y.
> > > > All works.
> > > > I think it's safer to go with frame pointers even for ORC=y considering
> > > > all the pain this issue had caused. Even if objtool gets confused again
> > > > in the future __bpf_prog_run() will have frame pointers and kernel stack
> > > > unwinding can fall back from ORC to FP for that frame.
> > > > wdyt?
> > >
> > > It seems dangerous to me.  The GCC manual recommends against it.
> > 
> > The manual can says that it's broken. That won't stop the world from using it.
> > Just google projects that are using it. For example: qt, lz4, unreal engine, etc
> > Telling compiler to disable gcse via flag is a guaranteed way to avoid
> > that optimization that breaks objtool whereas messing with C code is nothing
> > but guess work. gcc can still do gcse.
> 
> But the manual's right, it is broken.  How do you know other important
> flags won't also be stripped?

What flags are you worried about?
I've checked that important things like -mno-red-zone, -fsanitize are preserved.
