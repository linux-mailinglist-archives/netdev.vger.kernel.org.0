Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD74F2354F1
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 05:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgHBDH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 23:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgHBDH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 23:07:57 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AD5C06174A;
        Sat,  1 Aug 2020 20:07:57 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a79so643000pfa.8;
        Sat, 01 Aug 2020 20:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1j8EZXvJ6xp75+ihAeh4iIkHpaXz+pr5TsFcys/H1Yk=;
        b=UXYgk6JT1tLyuw3n039g+FdSYwm92nm+sojh0SwSOaYu8YDFKoihftnHKhvNz1Rd0o
         5WBYYI8T2Oz6ZGJcg6WhrJsccGOzL/fKEOVIptdUExKX/YTPkAydlo9oWnA2osmco9pZ
         KF1AEekAtuJ4D7kG5kbkV//jlkbNghuJLrymHBKkfvCC5xAvzTzqG5ZPBDipSWieGwBZ
         w/txhrmUx9pTwuA6moDmF9VTWsf+bVMM8zMYxXHSgmad19tPb1NjUqXoXIeTxVXG7QL2
         Mx/yQwxux1SCukRxiSbEC3Gz7ItqFLYzNzTVbCOd9fnZhMpFd4UJdtdxbmCTen6NM8ow
         rr8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1j8EZXvJ6xp75+ihAeh4iIkHpaXz+pr5TsFcys/H1Yk=;
        b=TH3NiGRfkgM2irZHR2nsquKQUDSDkfeA87zWOYupVEJuw3aHxQ8iXPpbgSu4W0GgkJ
         8R7ertd2juKToD8/BLPOZ9ArCt0jU9hF0XS0TT17Z/42cMGy8ZimJ5FocTWk0dpswzSf
         6rTdck4AkgVj+2abMATW8WSoR7nDYliRcdFEB4YCzpH7jgR+TFvIV//8yY3+4jGFwvzL
         Sve+7wOIuGrmgryFRmvwO0WVxl1pxi3uPEQQL8w09IAHIcuomhS5OdTfr2P3QyJZ7JUN
         YRDTeDV4Zhe8I9IteGP7Eb2cBraxguoD/LHNY3t0yoOL/ppHlv/FjNcrj7PyME1h8eXB
         9kYA==
X-Gm-Message-State: AOAM5311H/SwI9yndG3YMA2jccbu+hiFPovmgEl2LKl4sRz5nfp96IbN
        yWEXbVkpiKcGKL17O4eHsF0FBS2r
X-Google-Smtp-Source: ABdhPJyi5RZdJWEB81cYcVQaDNZtdTx2ihrUqe7MvqbeXEZfa37yBakOCSFYTxpuQZzwnaor05bF4Q==
X-Received: by 2002:a63:d10a:: with SMTP id k10mr9896815pgg.382.1596337675940;
        Sat, 01 Aug 2020 20:07:55 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:65b5])
        by smtp.gmail.com with ESMTPSA id d93sm13997738pjk.44.2020.08.01.20.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 20:07:54 -0700 (PDT)
Date:   Sat, 1 Aug 2020 20:07:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH v6 bpf-next 0/6] bpf: tailcalls in BPF subprograms
Message-ID: <20200802030752.bnebgrr6jkl3dgnk@ast-mbp.dhcp.thefacebook.com>
References: <20200731000324.2253-1-maciej.fijalkowski@intel.com>
 <fbe6e5ca-65ba-7698-3b8d-1214b5881e88@iogearbox.net>
 <20200801071357.GA19421@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801071357.GA19421@ranger.igk.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 01, 2020 at 09:13:57AM +0200, Maciej Fijalkowski wrote:
> On Sat, Aug 01, 2020 at 03:03:19AM +0200, Daniel Borkmann wrote:
> > On 7/31/20 2:03 AM, Maciej Fijalkowski wrote:
> > > v5->v6:
> > > - propagate only those poke descriptors that individual subprogram is
> > >    actually using (Daniel)
> > > - drop the cumbersome check if poke desc got filled in map_poke_run()
> > > - move poke->ip renaming in bpf_jit_add_poke_descriptor() from patch 4
> > >    to patch 3 to provide bisectability (Daniel)
> > 
> > I did a basic test with Cilium on K8s with this set, spawning a few Pods
> > and checking connectivity & whether we're not crashing since it has bit more
> > elaborate tail call use. So far so good. I was inclined to push the series
> > out, but there is one more issue I noticed and didn't notice earlier when
> > reviewing, and that is overall stack size:
> > 
> > What happens when you create a single program that has nested BPF to BPF
> > calls e.g. either up to the maximum nesting or one call that is using up
> > the max stack size which is then doing another BPF to BPF call that contains
> > the tail call. In the tail call map, you have the same program in there.
> > This means we create a worst case stack from BPF size of max_stack_size *
> > max_tail_call_size, that is, 512*32. So that adds 16k worst case. For x86
> > we have a stack of arch/x86/include/asm/page_64_types.h:
> > 
> >   #define THREAD_SIZE_ORDER       (2 + KASAN_STACK_ORDER)
> >  #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
> > 
> > So we end up with 16k in a typical case. And this will cause kernel stack
> > overflow; I'm at least not seeing where we handle this situation in the

Not quite. The subprog is always 32 byte stack (from safety pov).
The real stack (when JITed) can be lower or zero.
So the max stack is (512 - 32) * 32 = 15360.
So there is no overflow, but may be a bit too close to comfort.
Imo the room is ok to land the set and the better enforcement can
be done as a follow up later, like below idea...

> > set. Hm, need to think more, but maybe this needs tracking of max stack
> > across tail calls to force an upper limit..
> 
> My knee jerk reaction would be to decrement the allowed max tail calls,
> but not sure if it's an option and if it would help.

How about make the verifier use a lower bound for a function with a tail call ?
Something like 64 would work.
subprog_info[idx].stack_depth with tail_call will be >= 64.
Then the main function will be automatically limited to 512-64 and the worst
case stack = 14kbyte.
When the sub prog with tail call is not an empty body (malicious stack
abuser) then the lower bound won't affect anything.
A bit annoying that stack_depth will be used by JIT to actually allocate
that much. Some of it will not be used potentially, but I think it's fine.
It's much simpler solution than to keep two variables to track stack size.
Or may be check_max_stack_depth() can be a bit smarter and it can detect
that subprog is using tail_call without actually hacking stack_depth variable.
Essentially I'm proposing to tweak this formula:
depth += round_up(max_t(u32, subprog[idx].stack_depth, 1), 32);
and replace 1 with 64 for subprogs with tail_call.
