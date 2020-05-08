Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D404D1CBA9E
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 00:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgEHWSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 18:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727082AbgEHWSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 18:18:35 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6090DC061A0C;
        Fri,  8 May 2020 15:18:35 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id v63so1656702pfb.10;
        Fri, 08 May 2020 15:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=slBeDdO+NLXpUllYxpa7W5p3QR99sLP2SUFK9a8TVgY=;
        b=m1SEovlOEzStu6rpmVOzUq+28OLBDJ0YCj9SwngPILA0/lelPEAybDX2LlFdhQ5uRf
         8FRNlABALiyFQPMPwhM+qJrczbFshSWQMiMk81+0KC4VpuGKa314QNjwpRE1iJg3OpRl
         eSKuKnZiddvhDfQr8OwAbmC094r5b6ZnDvM/fuEXDWo/X892TZyf3LXHuCdXNDBl2bW5
         q5Ma3XlCvXzL9Y7C6H2UAVLLjkGz+h2AdGvLK8jCNiOBy+pOqx1x6+Dx6s82NRQ7h5Zi
         DbVz9gBu3nQJM9ALm6diYF3PCHKeJWwUlbigzdi65xXrXW16smEBD3sA4ecR6lFpRvKS
         eRMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=slBeDdO+NLXpUllYxpa7W5p3QR99sLP2SUFK9a8TVgY=;
        b=BliqN6+ZK7ELAHjBxPHAYjEXilAQt5x36tyDgbwpuac1Z/rUkkdzHGMTM5NF9AV7/e
         0n1ZM1k4sNs00YLoud5pWxB9aX3Jgep5aVe/YGreGdZFQkfIBaFom67PKAELJgPkkf2p
         dFNukQK+/kVyj4RRCbxX2QaPNIJNzkUkEL0KoYvmtdqZvdnin4UQmT2MQrZuNz5Q0aeQ
         4oJ4BDSqeU7btfiA68T5Ub1r+HIB7oUVzTXmE1+p4lV7v3nfPDvJs5vtVDn8zrXQrqur
         gesJkTFpWawgOR+ZIKxCOJRtIKx8U0OtUVHGKS1j08QyOkZxZBhCWcbVaJFBsjEb9I3j
         gNUw==
X-Gm-Message-State: AGi0PuahHqHEP4LRNuLw6FJnYM5s8TZzrzchoD6O/Ya9w50hyj5X5KuZ
        FTAW4S/UmzRtOnhIfv0a6l4v274P
X-Google-Smtp-Source: APiQypJGsg/+91OUBPAr4UGfb+rF5Qcfq90zvKPEBXSYZH+bSQIpyscPZ9BAGtYViDhbv216BibTOA==
X-Received: by 2002:a62:5cc7:: with SMTP id q190mr4907996pfb.98.1588976314732;
        Fri, 08 May 2020 15:18:34 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:d7c7])
        by smtp.gmail.com with ESMTPSA id w192sm2831148pff.126.2020.05.08.15.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 15:18:33 -0700 (PDT)
Date:   Fri, 8 May 2020 15:18:31 -0700
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
Message-ID: <20200508221831.g6rdviekaqtcxh5f@ast-mbp.dhcp.thefacebook.com>
References: <20200505174300.gech3wr5v6kkho35@ast-mbp.dhcp.thefacebook.com>
 <20200505181108.hwcqanvw3qf5qyxk@treble>
 <20200505195320.lyphpnprn3sjijf6@ast-mbp.dhcp.thefacebook.com>
 <20200505202823.zkmq6t55fxspqazk@treble>
 <20200505235939.utnmzqsn22cec643@ast-mbp.dhcp.thefacebook.com>
 <20200506155343.7x3slq3uasponb6w@treble>
 <CAADnVQJZ1rj1DB-Y=85itvfcHxnXVKjhJXpzqs6zZ6ZLpexhCQ@mail.gmail.com>
 <20200506211945.4qhrxqplzmt4ul66@treble>
 <20200507000357.grprluieqa324v5c@ast-mbp.dhcp.thefacebook.com>
 <20200507140733.v4xlzjogtnpgu5lc@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507140733.v4xlzjogtnpgu5lc@treble>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 09:07:33AM -0500, Josh Poimboeuf wrote:
> On Wed, May 06, 2020 at 05:03:57PM -0700, Alexei Starovoitov wrote:
> > > > > > diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> > > > > > index d7ee4c6bad48..05104c3cc033 100644
> > > > > > --- a/include/linux/compiler-gcc.h
> > > > > > +++ b/include/linux/compiler-gcc.h
> > > > > > @@ -171,4 +171,4 @@
> > > > > >  #define __diag_GCC_8(s)
> > > > > >  #endif
> > > > > >
> > > > > > -#define __no_fgcse __attribute__((optimize("-fno-gcse")))
> > > > > > +#define __no_fgcse __attribute__((optimize("-fno-gcse,-fno-omit-frame-pointer")))
> > > > > > --
> > > > > > 2.23.0
> > > > > >
> > > > > > I've tested it with gcc 8,9,10 and clang 11 with FP=y and with ORC=y.
> > > > > > All works.
> > > > > > I think it's safer to go with frame pointers even for ORC=y considering
> > > > > > all the pain this issue had caused. Even if objtool gets confused again
> > > > > > in the future __bpf_prog_run() will have frame pointers and kernel stack
> > > > > > unwinding can fall back from ORC to FP for that frame.
> > > > > > wdyt?
> > > > >
> > > > > It seems dangerous to me.  The GCC manual recommends against it.
> > > > 
> > > > The manual can says that it's broken. That won't stop the world from using it.
> > > > Just google projects that are using it. For example: qt, lz4, unreal engine, etc
> > > > Telling compiler to disable gcse via flag is a guaranteed way to avoid
> > > > that optimization that breaks objtool whereas messing with C code is nothing
> > > > but guess work. gcc can still do gcse.
> > > 
> > > But the manual's right, it is broken.  How do you know other important
> > > flags won't also be stripped?
> > 
> > What flags are you worried about?
> > I've checked that important things like -mno-red-zone, -fsanitize are preserved.
> 
> It's not any specific flags I'm worried about, it's all of them.  There
> are a lot of possibilities, with all the different configs, and arches.
> Flags are usually added for a good reason, so one randomly missing flag
> could have unforeseen results.
> 
> And I don't have any visibility into how GCC decides which flags to
> drop, and when.  But the docs aren't comforting.

That doc change landed 5 years ago:
https://patchwork.ozlabs.org/project/gcc/patch/20151213081911.GA320@x4/
Sure it's 'broken' by whatever definition of broken.
Yet gcc has
$ git grep '__attribute__((optimize' gcc/testsuite/|wc -l
34 tests to make sure it stays working.
And gcc is using it to bootstrap itself. See LIBGCC2_UNWIND_ATTRIBUTE.
The doc is expressing desire and trying to discourage its use,
but that attribute is not going anywhere.

> Even if things seem to work now, that could (silently) change at any
> point in time.  This time objtool warned about the missing frame
> pointer, but that's not necessarily going to happen for other flags.
> 
> If we go this route, I would much rather do -fno-gcse on a file-wide
> basis.

The fix for broken commit 3193c0836f20 has to be backported all the way
to 5.3 release. I'd like to minimize conflicts.
For that very reason I'm not even renaming #define __no_fgcse.
