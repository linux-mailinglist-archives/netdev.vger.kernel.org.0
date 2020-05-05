Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705B41C6162
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbgEETxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726350AbgEETxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:53:25 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157AAC061A0F;
        Tue,  5 May 2020 12:53:25 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t16so1276028plo.7;
        Tue, 05 May 2020 12:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IypnnQBGuIXnhQzcC4uwCcgachLRDQLArvlBeVJnyNA=;
        b=lD4ywxWa6zeKoZ3Kj3uc3z2UQk+S6vsm7JQF/xZOwv2TnuARyEDKQ5B77dAe5UR0bg
         33JP6kBaZosM5y+dJZc2vyGRgAdqeSeBSM2ISrxyzc8zHnXBFdW01J0snzqKHyG5TeUN
         MpbKS4DlG3Y4z0fzpXO2e8LHs0vFn8CyUddZGdeVMOmMqt7uyZWJQ1R3ljB+4ZMiZI9l
         gydM9BFe1t0NiDnXwLsKFfSSB3ZQUtwVa46EQLviRJ9dxHi3D0mRu0zWKTsJo42v36Ds
         7xQrvWPechXfigIXLyYtFgrT6oG4MQwxUTS4P1Kqs5yk28edp3DQwCSe/B5l6TDbU9vX
         tw9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IypnnQBGuIXnhQzcC4uwCcgachLRDQLArvlBeVJnyNA=;
        b=WSyjqYtN0zAgXgVdE2p4IaZ+mqvLK3iKu9b+PM5yjDThLkY9qYGn+k1fDAC3wg83su
         S5n+3cVYconYFza8u3J9ZsJz296ONaW9qYROIybMTFxkjfzoJplTHkdSrwSb0IOJ07ly
         ZsZqPWUC5UpoSdQx/e93ETQwPNXnFfq/W/LGgGpYi2bCxZ76byxM1zy7K3NSNZ1denvf
         i0CmKm9NmKrwf4JzfQgsL6IJwC6/7VrsZOnLvLw0HPtgRwJnaWmeh/zjvMO2nYv6jOa1
         PAz/w2WXecvPQcyup0XcbPffvK20CYWh0U0y42UV95nI5w2nKYOYS9R8awIY3lfAJuZC
         fzgQ==
X-Gm-Message-State: AGi0PubiftBjjXeo8MS6MLvpxGKNjUoK7C98xorNlXA7L4JEat2eBwBe
        EXzYz/G6BuXumvTtsR9eaaM=
X-Google-Smtp-Source: APiQypL8q8LwGyybfhE8UQPvvleTYO6XllaxSllnF9wLyCJ8TbP17xuNLJeUlD1A8GdvaK8M0VoP3w==
X-Received: by 2002:a17:902:7c12:: with SMTP id x18mr4371447pll.230.1588708404444;
        Tue, 05 May 2020 12:53:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e28e])
        by smtp.gmail.com with ESMTPSA id x63sm2764601pfc.56.2020.05.05.12.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 12:53:23 -0700 (PDT)
Date:   Tue, 5 May 2020 12:53:20 -0700
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
Message-ID: <20200505195320.lyphpnprn3sjijf6@ast-mbp.dhcp.thefacebook.com>
References: <b581438a16e78559b4cea28cf8bc74158791a9b3.1588273491.git.jpoimboe@redhat.com>
 <20200501190930.ptxyml5o4rviyo26@ast-mbp.dhcp.thefacebook.com>
 <20200501192204.cepwymj3fln2ngpi@treble>
 <20200501194053.xyahhknjjdu3gqix@ast-mbp.dhcp.thefacebook.com>
 <20200501195617.czrnfqqcxfnliz3k@treble>
 <20200502030622.yrszsm54r6s6k6gq@ast-mbp.dhcp.thefacebook.com>
 <20200502192105.xp2osi5z354rh4sm@treble>
 <20200505174300.gech3wr5v6kkho35@ast-mbp.dhcp.thefacebook.com>
 <20200505181108.hwcqanvw3qf5qyxk@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505181108.hwcqanvw3qf5qyxk@treble>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 01:11:08PM -0500, Josh Poimboeuf wrote:
> On Tue, May 05, 2020 at 10:43:00AM -0700, Alexei Starovoitov wrote:
> > > Or, if you want to minimize the patch's impact on other arches, and keep
> > > the current patch the way it is (with bug fixed and changed patch
> > > description), that's fine too.  I can change the patch description
> > > accordingly.
> > > 
> > > Or if you want me to measure the performance impact of the +40% code
> > > growth, and *then* decide what to do, that's also fine.  But you'd need
> > > to tell me what tests to run.
> > 
> > I'd like to minimize the risk and avoid code churn,
> > so how about we step back and debug it first?
> > Which version of gcc are you using and what .config?
> > I've tried:
> > Linux version 5.7.0-rc2 (gcc version 10.0.1 20200505 (prerelease) (GCC)
> > CONFIG_UNWINDER_ORC=y
> > # CONFIG_RETPOLINE is not set
> > 
> > and objtool didn't complain.
> > I would like to reproduce it first before making any changes.
> 
> Revert
> 
>   3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> 
> and compile with retpolines off (and either ORC or FP, doesn't matter).
> 
> I'm using GCC 9.3.1:
> 
>   kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x8dc: sibling call from callable instruction with modified stack frame
> 
> That's the original issue described in that commit.

I see something different.
With gcc 8, 9, and 10 and CCONFIG_UNWINDER_FRAME_POINTER=y
I see:
kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x4837: call without frame pointer save/setup
and sure enough assembly code for ___bpf_prog_run does not countain frame setup
though -fno-omit-frame-pointer flag was passed at command line.
Then I did:
static u64 /*__no_fgcse*/ ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
and the assembly had proper frame, but objtool wasn't happy:
kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x480a: sibling call from callable instruction with modified stack frame

gcc 6.3 doesn't have objtool warning with and without -fno-gcse.

Looks like we have two issues here.
First gcc 8, 9 and 10 have a severe bug with __attribute__((optimize("")))
In this particular case passing -fno-gcse somehow overruled -fno-omit-frame-pointer
which is serious issue. powerpc is using __nostackprotector. I don't understand
how it can keep working with newer gcc-s. May be got lucky.
Plenty of other projects use various __attribute__((optimize("")))
they all have to double check that their vesion of GCC produces correct code.
Can somebody reach out to gcc folks for explanation?

The second objtool issue is imo minor one. It can be worked around for now
and fixed for real later.

> > Also since objtool cannot follow the optimizations compiler is doing
> > how about admit the design failure and teach objtool to build ORC
> > (and whatever else it needs to build) based on dwarf for the functions where
> > it cannot understand the assembly code ?
> > Otherwise objtool will forever be playing whackamole with compilers.
> 
> I agree it's not a good long term approach.  But DWARF has its own
> issues and we can't rely on it for live patching.

Curious what is the issue with dwarf and live patching ?
I'm sure dwarf is enough to build ORC tables.

> As I mentioned we have a plan to use a compiler plugin to annotate jump
> tables (including GCC switch tables).  But the approach taken by this
> patch should be good enough for now.

I don't have gcc 7 around. Could you please test the workaround with gcc 7,8,9,10
and several clang versions? With ORC and with FP ? and retpoline on/off ?
I don't see any issues with ORC=y. objtool complains with FP=y only for my configs.
I want to make sure the workaround is actually effective.
