Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E961C64B1
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 01:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbgEEX7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 19:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728875AbgEEX7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 19:59:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923D6C061A0F;
        Tue,  5 May 2020 16:59:43 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o18so1776820pgg.8;
        Tue, 05 May 2020 16:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=szYwvsdRj79cRVT2Gpz1TxpVJP8+RjL1MmVEYqGKUlE=;
        b=Ey0SjiuGIH690bTUnJEKx76RYYLMSN5gUCW45Ao9FuptWCljoMUo1ENHwK48dzx8SO
         tL2NafaLrLA0zQqKx2bT8fq2WcOtgfJUie9BxogGClxQcAZHFplLBF6nBCEnQkcjx1ju
         TMX9YaCqc25GbwZ06zryFnHP9+6s/38Ps7+SHCQsgyrvdr/y3YI8mHZ62JryC+Wv8t+k
         V38+8PNMjlcVkpajGGET3xHU1M1NIN2RjotDGj7VJ2DA2o4HIyYepPNaI6FXOJpKPPp5
         g50FYlb752kscX0JYBSrfq1KHzZkj1DuqFDJwtMuoYpith1EENigueWQ3bmXit33sEmb
         UBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=szYwvsdRj79cRVT2Gpz1TxpVJP8+RjL1MmVEYqGKUlE=;
        b=Anyc/EMlh9gsOtXXsnIlIKJUQ7OTyyntoDIvxf+5xrdQhQf17h58piV48iNy/aVjcP
         ogWW6au0NrrJLd7uPRXuEkju7JhOabipW2qktNDlyXXxzrvpBhA+0gq/3stTmbY2RAEn
         NzRjaLlZ4/l+tuYMMj5ETSBhudm6lTSMrurdGAWK6/ZHxQl3ltl6rKWyyAdIsrjdS2it
         D2OBcOP5pGyy8W+Tn8xayX6lXP/4Qehr3lGCZniSkoEjmwsWJ5DHIipwHgaAqrdAHSDD
         Ym56o5locHFjyiYOrczx90aXUZsXhw9nGl7UFJQPgbwqMlOk4HAoV5/2nt/s3DlNfQfV
         Jzhg==
X-Gm-Message-State: AGi0PuYRN501QLb+qKqjKknAuSqXPuHD2eF2ZRdeRrdN+7cmzWCLtBKl
        aRhANAeI2cHABA0cyOaHzcJFyabN
X-Google-Smtp-Source: APiQypJ+cPtvi0KmYvnPzMJohCS6FYIqzTsTupo9R0dBKgjN+LZRimGxRIFLz7nSaEmc0u0UsqnQcQ==
X-Received: by 2002:aa7:8619:: with SMTP id p25mr5406755pfn.105.1588723183002;
        Tue, 05 May 2020 16:59:43 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:62d5])
        by smtp.gmail.com with ESMTPSA id c2sm119863pfp.118.2020.05.05.16.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 16:59:42 -0700 (PDT)
Date:   Tue, 5 May 2020 16:59:39 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bpf: Tweak BPF jump table optimizations for objtool
 compatibility
Message-ID: <20200505235939.utnmzqsn22cec643@ast-mbp.dhcp.thefacebook.com>
References: <20200501190930.ptxyml5o4rviyo26@ast-mbp.dhcp.thefacebook.com>
 <20200501192204.cepwymj3fln2ngpi@treble>
 <20200501194053.xyahhknjjdu3gqix@ast-mbp.dhcp.thefacebook.com>
 <20200501195617.czrnfqqcxfnliz3k@treble>
 <20200502030622.yrszsm54r6s6k6gq@ast-mbp.dhcp.thefacebook.com>
 <20200502192105.xp2osi5z354rh4sm@treble>
 <20200505174300.gech3wr5v6kkho35@ast-mbp.dhcp.thefacebook.com>
 <20200505181108.hwcqanvw3qf5qyxk@treble>
 <20200505195320.lyphpnprn3sjijf6@ast-mbp.dhcp.thefacebook.com>
 <20200505202823.zkmq6t55fxspqazk@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505202823.zkmq6t55fxspqazk@treble>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 03:28:23PM -0500, Josh Poimboeuf wrote:
> On Tue, May 05, 2020 at 12:53:20PM -0700, Alexei Starovoitov wrote:
> > On Tue, May 05, 2020 at 01:11:08PM -0500, Josh Poimboeuf wrote:
> > > On Tue, May 05, 2020 at 10:43:00AM -0700, Alexei Starovoitov wrote:
> > > > > Or, if you want to minimize the patch's impact on other arches, and keep
> > > > > the current patch the way it is (with bug fixed and changed patch
> > > > > description), that's fine too.  I can change the patch description
> > > > > accordingly.
> > > > > 
> > > > > Or if you want me to measure the performance impact of the +40% code
> > > > > growth, and *then* decide what to do, that's also fine.  But you'd need
> > > > > to tell me what tests to run.
> > > > 
> > > > I'd like to minimize the risk and avoid code churn,
> > > > so how about we step back and debug it first?
> > > > Which version of gcc are you using and what .config?
> > > > I've tried:
> > > > Linux version 5.7.0-rc2 (gcc version 10.0.1 20200505 (prerelease) (GCC)
> > > > CONFIG_UNWINDER_ORC=y
> > > > # CONFIG_RETPOLINE is not set
> > > > 
> > > > and objtool didn't complain.
> > > > I would like to reproduce it first before making any changes.
> > > 
> > > Revert
> > > 
> > >   3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > > 
> > > and compile with retpolines off (and either ORC or FP, doesn't matter).
> > > 
> > > I'm using GCC 9.3.1:
> > > 
> > >   kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x8dc: sibling call from callable instruction with modified stack frame
> > > 
> > > That's the original issue described in that commit.
> > 
> > I see something different.
> > With gcc 8, 9, and 10 and CCONFIG_UNWINDER_FRAME_POINTER=y
> > I see:
> > kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x4837: call without frame pointer save/setup
> > and sure enough assembly code for ___bpf_prog_run does not countain frame setup
> > though -fno-omit-frame-pointer flag was passed at command line.
> > Then I did:
> > static u64 /*__no_fgcse*/ ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> > and the assembly had proper frame, but objtool wasn't happy:
> > kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x480a: sibling call from callable instruction with modified stack frame
> > 
> > gcc 6.3 doesn't have objtool warning with and without -fno-gcse.
> > 
> > Looks like we have two issues here.
> > First gcc 8, 9 and 10 have a severe bug with __attribute__((optimize("")))
> > In this particular case passing -fno-gcse somehow overruled -fno-omit-frame-pointer
> > which is serious issue. powerpc is using __nostackprotector. I don't understand
> > how it can keep working with newer gcc-s. May be got lucky.
> > Plenty of other projects use various __attribute__((optimize("")))
> > they all have to double check that their vesion of GCC produces correct code.
> > Can somebody reach out to gcc folks for explanation?
> 
> Right.  I've mentioned this several times now.  That's why my patch
> reverts 3193c0836f20.  I don't see any other way around it.  The GCC
> manual even says this attribute should not be used in production code.

What you mentioned in commit log is:
"It doesn't append options to the command-line arguments.  Instead
it starts from a blank slate.  And according to recent GCC documentation
it's not recommended for production use."

I don't think anyone could have guessed from such description that it kills
-fno-omit-frame-pointer but it doesn't reduce optimization level to -O0
and it doesn't kill -D, -m, -I, -std= and other flags.

As far as workaround I prefer the following:
From 94bbc27c5a70d78846a5cb675df4cf8732883564 Mon Sep 17 00:00:00 2001
From: Alexei Starovoitov <ast@kernel.org>
Date: Tue, 5 May 2020 16:52:41 -0700
Subject: [PATCH] bpf,objtool: tweak interpreter compilation flags to help objtool

tbd

Fixes: 3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/compiler-gcc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index d7ee4c6bad48..05104c3cc033 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -171,4 +171,4 @@
 #define __diag_GCC_8(s)
 #endif

-#define __no_fgcse __attribute__((optimize("-fno-gcse")))
+#define __no_fgcse __attribute__((optimize("-fno-gcse,-fno-omit-frame-pointer")))
--
2.23.0

I've tested it with gcc 8,9,10 and clang 11 with FP=y and with ORC=y.
All works.
I think it's safer to go with frame pointers even for ORC=y considering
all the pain this issue had caused. Even if objtool gets confused again
in the future __bpf_prog_run() will have frame pointers and kernel stack
unwinding can fall back from ORC to FP for that frame.
wdyt?
