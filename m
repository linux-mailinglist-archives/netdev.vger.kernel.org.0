Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6D126F4AF
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgIRD0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgIRD0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 23:26:48 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D96C06174A;
        Thu, 17 Sep 2020 20:26:48 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id s205so3830488lja.7;
        Thu, 17 Sep 2020 20:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ul5zV1bRKVhaboMGt4RIwflaVUDt2n5N8zmSNNGL//Q=;
        b=Xbh29cptn7V8etz1DmYG2B8mEtgeeJJK3HUvkLKDpWtHIm+G3EduvKJEkxeS8+dE2D
         gessXLggtGUpsHT2mU/74TsWh+eeytAeXExsLkL0uWwVxfu2DC+YRNRsYXMucQs+OVzY
         ZXjvJep2NoLlhcdQ9nazv9qgm1bf3uJjAASL7T55VEm8WHny7U8snKPZgGN/3s2BNBaG
         Rz4bd+R/CAH9Z1XrWzEgqgbZjWO0WXuY07i805EdiLpJ2FZQ9j+zIdbUbiVq6Nk0sP1c
         eAuYu/liVug0/oB+deF8qNq6najOIjfIWmmYVReUe4yeawxFR0062R/xZwP7cfFPZZtP
         IBHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ul5zV1bRKVhaboMGt4RIwflaVUDt2n5N8zmSNNGL//Q=;
        b=hCqI6VYPgpaO4YzLhehL4E5aiHCtFt7tPB5S4efi6muauyUc7SBnQXwXXi5fXbImeQ
         B1FW405bJG+e57M4swDqtkZ8yjn+t1TgRFWV1VraHN176OqtFKl7fuVDaQUekCXSCRBf
         0O1BC82ZBiHPUxTKwPjPGTxMUTSu62F6yMCvRcNvCCv0ytuAVDdD7+zo2zXypo18SFf6
         1QSCDVh0VXEbTtjdBWzka2oWik90SPSTJe48sTR3GcDASprPtBpPY9j+6js0lILJFWCX
         BxewAEg01n7XSp+RG2/r9Oy6SUIFAttK6HOWvw1Mwb93KZPNOOPf8DcN4y6FmPP5sDtM
         OfNw==
X-Gm-Message-State: AOAM532tbAfxcyYAJIfR9YquxHng/vVL5LjqN+62Xo0dIRPRElqoIXSW
        8tcUmOL7pSuNb5EqNi4tD9H/d5gl+VIEkP+cJPI=
X-Google-Smtp-Source: ABdhPJz5pboofniwqNeviqdOXxDp3qsHvEIs0H2zqpQwjZ+LfvN8HQhlNmKbZXFd17UKmc2Rct/csfXJbDccr6g62A0=
X-Received: by 2002:a2e:808f:: with SMTP id i15mr10349752ljg.51.1600399606517;
 Thu, 17 Sep 2020 20:26:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200916211010.3685-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20200916211010.3685-1-maciej.fijalkowski@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Sep 2020 20:26:34 -0700
Message-ID: <CAADnVQLEYHZLeu-d4nV5Px6t+tVtYEgg8AfPE5-GwAS1uizc0w@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 0/7] bpf: tailcalls in BPF subprograms
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 2:16 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Changelog:
>
> v7->v8:
> - teach bpf_patch_insn_data to adjust insn_idx of tailcall insn
> - address case of clearing tail call counter when bpf2bpf with tailcalls
>   are mixed
> - drop unnecessary checks against cbpf in JIT
> - introduce more tailcall_bpf2bpf[X] selftests that are making sure the
>   combination of tailcalls with bpf2bpf calls works correctly
> - add test cases to test_verifier to make sure logic from
>   check_max_stack_depth that limits caller's stack depth down to 256 is
>   correct
> - move the main patch to appear after the one that limits the caller's
>   stack depth so that 'has_tail_call' can be used by 'tail_call_reachable'
>   logic

Thanks a lot for your hard work on this set. 5 month effort!
I think it's a huge milestone that will enable cilium, cloudflare, katran to
use bpf functions. Removing always_inline will improve performance.
Switching to global functions with function-by-function verification
will drastically improve program load times.
libbpf has full support for subprogram composition and call relocations.
Until now these verifier and libbpf features were impossible to use in XDP
programs, since most of them use tail_calls.
It's great to see all these building blocks finally coming together.

I've applied the set with few changes.
In patch 4 I've removed ifdefs and redundant ().
In patch 5 removed redundant !tail_call_reachable check.
In patch 6 replaced CONFIG_JIT_ALWAYS_ON dependency with
jit_requested && IS_ENABLED(CONFIG_X86_64).
It's more user friendly.
I also added patch 7 that checks that ld_abs and tail_call are only
allowed in subprograms that return 'int'.
I felt that the fix is simple enough, so I just pushed it, since
without it the set is not safe. Please review it here:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=09b28d76eac48e922dc293da1aa2b2b85c32aeee
I'll address any issues in the followups.
Because of the above changes I tweaked patch 8 to increase test coverage
with ld_abs and combination of global/static subprogs.
Also did s/__attribute__((noinline))/__noinline/.

John and Daniel,
I wasn't able to test it on cilium programs.
When you have a chance please give it a thorough run.
tail_call poke logic is delicate.

Lorenz,
if you can test it on cloudflare progs would be awesome.

Thanks a lot everyone!
