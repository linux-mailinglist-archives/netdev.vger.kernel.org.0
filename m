Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76774166F0
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 22:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243139AbhIWUwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 16:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhIWUwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 16:52:39 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7127C061574;
        Thu, 23 Sep 2021 13:51:07 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pf3-20020a17090b1d8300b0019e081aa87bso5808803pjb.0;
        Thu, 23 Sep 2021 13:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JVyWDXyJd0p/RNa9onFmHZlTQ0NybmhOAFf6WpHWxGQ=;
        b=GNRv8zTp8ZUGr+/AYgW3Vqn6U2T+C9Sv4sDdXwbY/xdV69jYWqB72WtBUZ/PX2SNBG
         wUytYY3W2JUT22XZY/GQ4lIJf1jNUxtseunspoHJTD5mKgBSHMcmTZqqWxJ8epv1b7bn
         ylMfhYn6yufKiBO3m4HX8g6mRwYdYJDjdYvYHk/eoxQeL30tOdReJ3+R4wlrBdzLRA/T
         jE5zE57xsM93/QcVXmC4DaIJUdmIxig3yem/sIuBgiI/FGNclnpCE18FFXLcObiuxV3P
         VcJ278x2jyyzb0Z8jdG4C0YYwC+Tk7MM4j/5eeun950J7vDx/08wzSX3QbK/xkMxFGjU
         Od1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JVyWDXyJd0p/RNa9onFmHZlTQ0NybmhOAFf6WpHWxGQ=;
        b=ndfHuL6b4kJwiCBvESG2KEO5AmBdO11h5SM4NkhS57U82k7qvmqAGdEGO66nZfipvp
         4OpRRAS5Yf9fb/JDWdqrYMCHOQrWpgzPw4eC1g87WPNf9w/5sqI7QHzE1ovGT8G1huRs
         JYwEunSGjIciO36KBiMC+yC3DuMJELmb2IyiIxUhh+99kXMONZq/VZkwY79pH3mcxina
         ZHXPZB56c4luwjAW6ri7C7KTFUuD+m6GoOhammVM0xvQWMw/yBjWTycbCKuGF2eSG2t3
         4xxfn03VxejttccoCPQ27kanupZwjdoBXE0rGeyxXPzlvnGPbImerMAh2jBm1jrtzPYj
         IdTA==
X-Gm-Message-State: AOAM5314vtzhvWrPv8N6hBvN0sqj5gLh3+rR8vEcfUAtlYpM/j2rMoIc
        dheIvS/mjI13aptFmg+UKPmWiHQxQE0=
X-Google-Smtp-Source: ABdhPJwM6jyjl8B8uwyiQG2P9mpTf8Q9+NBvT6KmUXBZTNw9hEED/93jXlydxJkYwU/LXfD1IRbuRA==
X-Received: by 2002:a17:902:e88d:b0:13b:8ed2:9f42 with SMTP id w13-20020a170902e88d00b0013b8ed29f42mr5799842plg.67.1632430267307;
        Thu, 23 Sep 2021 13:51:07 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:500::7:504a])
        by smtp.gmail.com with ESMTPSA id i22sm5946342pjv.47.2021.09.23.13.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 13:51:07 -0700 (PDT)
Date:   Thu, 23 Sep 2021 13:51:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [RFC PATCH bpf-next 0/2] bpf: keep track of prog verification
 stats
Message-ID: <20210923205105.zufadghli5772uma@ast-mbp>
References: <20210920151112.3770991-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920151112.3770991-1-davemarchevsky@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 08:11:10AM -0700, Dave Marchevsky wrote:
> The verifier currently logs some useful statistics in
> print_verification_stats. Although the text log is an effective feedback
> tool for an engineer iterating on a single application, it would also be
> useful to enable tracking these stats in a more structured form for
> fleetwide or historical analysis, which this patchset attempts to do.
> 
> A concrete motivating usecase which came up in recent weeks:
> 
> A team owns a complex BPF program, with various folks extending its
> functionality over the years. An engineer tries to make a relatively
> simple addition but encounters "BPF program is too large. Processed
> 1000001 insn". 
> 
> Their changes bumped the processed insns from 700k to over the limit and
> there's no obvious way to simplify. They must now consider a large
> refactor in order to incorporate the new feature. What if there was some
> previous change which bumped processed insns from 200k->700k which
> _could_ be modified to stress verifier less? Tracking historical
> verifier stats for each version of the program over the years would
> reduce manual work necessary to find such a change.
> 
> 
> Although parsing the text log could work for this scenario, a solution
> that's resilient to log format and other verifier changes would be
> preferable.
> 
> This patchset adds a bpf_prog_verif_stats struct - containing the same
> data logged by print_verification_stats - which can be retrieved as part
> of bpf_prog_info. Looking for general feedback on approach and a few
> specific areas before fleshing it out further:
> 
> * None of my usecases require storing verif_stats for the lifetime of a
>   loaded prog, but adding to bpf_prog_aux felt more correct than trying
>   to pass verif_stats back as part of BPF_PROG_LOAD
> * The verif_stats are probably not generally useful enough to warrant
>   inclusion in fdinfo, but hoping to get confirmation before removing
>   that change in patch 1
> * processed_insn, verification_time, and total_states are immediately
>   useful for me, rest were added for parity with
> 	print_verification_stats. Can remove.
> * Perhaps a version field would be useful in verif_stats in case future
>   verifier changes make some current stats meaningless
> * Note: stack_depth stat was intentionally skipped to keep patch 1
>   simple. Will add if approach looks good.

Sorry for the delay. LPC consumes a lot of mental energy :)

I see the value of exposing some of the verification stats as prog_info.
Let's look at the list:
struct bpf_prog_verif_stats {
       __u64 verification_time;
       __u32 insn_processed;
       __u32 max_states_per_insn;
       __u32 total_states;
       __u32 peak_states;
       __u32 longest_mark_read_walk;
};
verification_time is non deterministic. It varies with frequency
and run-to-run. I don't see how alerting tools can use it.

insn_processed is indeed the main verification metric.
By now it's well known and understood.

max_states_per_insn, total_states, etc were the metrics I've studied
carefully with pruning, back tracking and pretty much every significant
change I did or reiviewed in the verifier. They're useful to humans
and developers, but I don't see how alerting tools will use them.

So it feels to me that insn_processed alone will be enough to address the
monitoring goal.
It can be exposed to fd_info and printed by bpftool.
If/when it changes with some future verifier algorithm we should be able
to approximate it.
