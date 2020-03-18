Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB8418A82E
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 23:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCRW34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 18:29:56 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40799 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgCRW34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 18:29:56 -0400
Received: by mail-pj1-f65.google.com with SMTP id bo3so61479pjb.5
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 15:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DZz1wswZhNQLIl0+JBgP3SsqWuba02REf62jhG9S3ZI=;
        b=Kku5KUClqyuaPhatO7sm88N4uvJ68/0OFkYJ9qsIHPBfUFHj4PRSzn0UUwX/SjJU9p
         wXtu9h2DMmGO1yFrIL8DnA+dXiTDKgagqCZznXWzrCVkiHKXDeUBX97JCnQr/fUwcTm0
         yXbVLYNc9Az/fkIeHKLfrYj4j2or4f2WXbd7Wwtkx5FOiyJ9CvYQfjPv5fwBPdJ/VtUN
         CI2MwMGqO7KeCJ/Aio99qHV9t9+PZuKg4HLGZV0wEteWOkddHRiXyBgWN2FPMEGxB8DM
         VxKHNbGtgwnGlKF/UZENR9ngDJRQbI0U7FFOweyEspXd3Gfs1ArM+FA5be93h6mIBKi6
         w7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DZz1wswZhNQLIl0+JBgP3SsqWuba02REf62jhG9S3ZI=;
        b=aSx+e9cMonIFLIVSR7mXIz00+HijBQXeOQDUs3E0c0B0urBvw0JfdNVighNHOuVQGC
         ZpDkYMZLoUnrnf/JIQdjhLQYMEka9pvFdTguhKl6ZtCOGorE/F4roJ8g5OE1CDhMj03p
         6wTnGCoVPv4xssph7gXrJc+FrTvViLZp0Bui21JA+V52NpiGqie6/8TddQ1kzUFMoBPK
         12xovw8OTxwbmPdZ0NiPo6hA0A9ypopB1LttKgZqRagOZDtL6GUuDMixJrmewNFfjesD
         LIqmjG//wlckKoiJ8pyOp0tquFoX/Z+5mC2dMjpbBzBUOVFmH13sn+OzV7I0oTVDgehq
         RXRQ==
X-Gm-Message-State: ANhLgQ0pn1m0Ca4CXJZ5JJIxSPWsS83Sld16AJUB4l+122rT/Dvmb1L2
        e/WziW6Pg+WMAt1LvY4Qm0t3NA==
X-Google-Smtp-Source: ADFU+vtlXyEadaWQM3lrXsl2cWkWaOIIV8ypmJy1U2crVXb+REthiCnFJWD8JnoPHi9b2fDGnzAFHQ==
X-Received: by 2002:a17:902:8a88:: with SMTP id p8mr489182plo.56.1584570594534;
        Wed, 18 Mar 2020 15:29:54 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id k4sm73764pfh.0.2020.03.18.15.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 15:29:54 -0700 (PDT)
Date:   Wed, 18 Mar 2020 15:29:53 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Song Liu <songliubraving@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "yzaikin@google.com" <yzaikin@google.com>
Subject: Re: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with
 /dev/bpf_stats
Message-ID: <20200318222953.GA2507308@mini-arch.hsd1.ca.comcast.net>
References: <20200316203329.2747779-1-songliubraving@fb.com>
 <eb31bed3-3be4-501e-4340-bd558b31ead2@iogearbox.net>
 <920839AF-AC7A-4CD3-975F-111C3C6F75B9@fb.com>
 <a69245f8-c70f-857c-b109-556d1bc267f7@iogearbox.net>
 <C126A009-516F-451A-9A83-31BC8F67AA11@fb.com>
 <53f8973f-4b3e-08fe-2363-2300027c8f9d@iogearbox.net>
 <C624907B-22DB-4505-9C9E-1F8A96013AC7@fb.com>
 <6D317BBF-093E-41DC-9838-D685C39F6DAB@fb.com>
 <ba62e0be-6de6-036c-a836-178c1a9c079a@iogearbox.net>
 <3E03D914-36FA-4956-AF14-CAFD784D013A@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E03D914-36FA-4956-AF14-CAFD784D013A@fb.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/18, Song Liu wrote:
> 
> 
> > On Mar 18, 2020, at 1:58 PM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> > 
> > On 3/18/20 7:33 AM, Song Liu wrote:
> >>> On Mar 17, 2020, at 4:08 PM, Song Liu <songliubraving@fb.com> wrote:
> >>>> On Mar 17, 2020, at 2:47 PM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>>>>> 
> >>>>>> Hm, true as well. Wouldn't long-term extending "bpftool prog profile" fentry/fexit
> >>>>>> programs supersede this old bpf_stats infrastructure? Iow, can't we implement the
> >>>>>> same (or even more elaborate stats aggregation) in BPF via fentry/fexit and then
> >>>>>> potentially deprecate bpf_stats counters?
> >>>>> I think run_time_ns has its own value as a simple monitoring framework. We can
> >>>>> use it in tools like top (and variations). It will be easier for these tools to
> >>>>> adopt run_time_ns than using fentry/fexit.
> >>>> 
> >>>> Agree that this is easier; I presume there is no such official integration today
> >>>> in tools like top, right, or is there anything planned?
> >>> 
> >>> Yes, we do want more supports in different tools to increase the visibility.
> >>> Here is the effort for atop: https://github.com/Atoptool/atop/pull/88 .
> >>> 
> >>> I wasn't pushing push hard on this one mostly because the sysctl interface requires
> >>> a user space "owner".
> >>> 
> >>>>> On the other hand, in long term, we may include a few fentry/fexit based programs
> >>>>> in the kernel binary (or the rpm), so that these tools can use them easily. At
> >>>>> that time, we can fully deprecate run_time_ns. Maybe this is not too far away?
> >>>> 
> >>>> Did you check how feasible it is to have something like `bpftool prog profile top`
> >>>> which then enables fentry/fexit for /all/ existing BPF programs in the system? It
> >>>> could then sort the sample interval by run_cnt, cycles, cache misses, aggregated
> >>>> runtime, etc in a top-like output. Wdyt?
> >>> 
> >>> I wonder whether we can achieve this with one bpf prog (or a trampoline) that covers
> >>> all BPF programs, like a trampoline inside __BPF_PROG_RUN()?
> >>> 
> >>> For long term direction, I think we could compare two different approaches: add new
> >>> tools (like bpftool prog profile top) vs. add BPF support to existing tools. The
> >>> first approach is easier. The latter approach would show BPF information to users
> >>> who are not expecting BPF programs in the systems. For many sysadmins, seeing BPF
> >>> programs in top/ps, and controlling them via kill is more natural than learning
> >>> bpftool. What's your thought on this?
> >> More thoughts on this.
> >> If we have a special trampoline that attach to all BPF programs at once, we really
> >> don't need the run_time_ns stats anymore. Eventually, tools that monitor BPF
> >> programs will depend on libbpf, so using fentry/fexit to monitor BPF programs doesn't
> >> introduce extra dependency. I guess we also need a way to include BPF program in
> >> libbpf.
> >> To summarize this plan, we need:
> >> 1) A global trampoline that attaches to all BPF programs at once;
> > 
> > Overall sounds good, I think the `at once` part might be tricky, at least it would
> > need to patch one prog after another, each prog also needs to store its own metrics
> > somewhere for later collection. The start-to-sample could be a shared global var (aka
> > shared map between all the programs) which would flip the switch though.
> 
> I was thinking about adding bpf_global_trampoline and use it in __BPF_PROG_RUN. 
> Something like:
> 
> diff --git i/include/linux/filter.h w/include/linux/filter.h
> index 9b5aa5c483cc..ac9497d1fa7b 100644
> --- i/include/linux/filter.h
> +++ w/include/linux/filter.h
> @@ -559,9 +559,14 @@ struct sk_filter {
> 
>  DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
> 
> +extern struct bpf_trampoline *bpf_global_trampoline;
> +DECLARE_STATIC_KEY_FALSE(bpf_global_tr_active);
> +
>  #define __BPF_PROG_RUN(prog, ctx, dfunc)       ({                      \
>         u32 ret;                                                        \
>         cant_migrate();                                                 \
> +       if (static_branch_unlikely(&bpf_global_tr_active))              \
> +               run_the_trampoline();                                   \
>         if (static_branch_unlikely(&bpf_stats_enabled_key)) {           \
>                 struct bpf_prog_stats *stats;                           \
>                 u64 start = sched_clock();                              \
> 
> 
> I am not 100% sure this is OK. 
> 
> I am also not sure whether this is an overkill. Do we really want more complex
> metric for all BPF programs? Or run_time_ns is enough? 
I was thinking about exporting a real distribution of the prog runtimes
instead of doing an average. It would be interesting to see
50%/95%/99%/max stats.
