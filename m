Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF1F1859D4
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgCODuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:50:18 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:33523 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgCODuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:50:18 -0400
Received: by mail-vk1-f196.google.com with SMTP id d11so2168215vko.0;
        Sat, 14 Mar 2020 20:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dPG+5nHaG+yMaeQo2rL7AF5LO5E5t2o4wvjjJ/5g6Ww=;
        b=i9qLu0Db3D3Rf/N4q8UxSjIt0hPhJSynIn3pXNM0cLts9JJqqfWknz38IyX1g5ikJf
         hMBvpPo1qVVFoKVyv1YLbvKI5+9Vc+ARQFj9u0CM+dziY+QBh+kBe0JUCJy3qHgeHGkt
         IQtNexkWb/iQz92NR/cNs+WXFI3y4eM0WhlfgVQu18QcIZNUTVfuQ3aH0cf5r+wzoWPB
         R4mCYy6InbcdHDAYM0sSDFtEm4uiqJLxaz/LKEltHaU3SF3fUteAYzGu7ElhW0PXB49R
         l7WPMJVCOaH2REB0iO9KLYk4i8Yjn05BhA7XSjFTeAIBbPhYNKKTpvqPF7ZrYRzwAUmd
         l5Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dPG+5nHaG+yMaeQo2rL7AF5LO5E5t2o4wvjjJ/5g6Ww=;
        b=Hu+DFCkHPaNhanJT+M+PGS3D4dqMfOobdKvpfb5K5lgxcGlE3ulVt/AWMyDHeJ8Sfe
         IJ72YxapzBbF4c/30YER4UD/z1aYTM24/5Zel8EHHi6RYU+bXLn3V9RBeAgrdKtGH6xa
         vQktv/Asum4hrxlC/hJ7IRLDt0Mvh3iXoNf0H2p1gNBFd8P4PErX6rXpScSrHm1q4wmb
         Z0/sqw6A3M0yoU228K2mdlmL/+PBrW7cBV4TjaX8O/P/XDRqtY4RnazC1gW86f8hnFQK
         Mm7HYGZlE7YkV/ex62rXvxTDLh6jHso8mJtfBFoWAw14JCgolnp7YAr8k4PFPU+XKgga
         YlAQ==
X-Gm-Message-State: ANhLgQ0u/ON5Dmz1xXUNSjfg/I7sJKll/Is+jzRlLQRgya8xtYBV3vDt
        ddBFjFPDvv+ZZvC1Oyu6afdJEIst
X-Google-Smtp-Source: ADFU+vsN+N2CoUaX39Eq9MU2Ptt8MTH4IEoo5sPUITDknirnwoXpWrZPAj1e8cFqTl5/yOBaPKm4Tg==
X-Received: by 2002:a17:902:780b:: with SMTP id p11mr18508190pll.61.1584201427240;
        Sat, 14 Mar 2020 08:57:07 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:1356])
        by smtp.gmail.com with ESMTPSA id 13sm61342367pfi.78.2020.03.14.08.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2020 08:57:06 -0700 (PDT)
Date:   Sat, 14 Mar 2020 08:57:03 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "yzaikin@google.com" <yzaikin@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "bristot@redhat.com" <bristot@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: Re: [RFC bpf-next 0/2] sharing bpf runtime stats with /dev/bpf_stats
Message-ID: <20200314155703.bmtojqeofzxbqqhu@ast-mbp>
References: <20200314003518.3114452-1-songliubraving@fb.com>
 <20200314024322.vymr6qkxsf6nzpum@ast-mbp.dhcp.thefacebook.com>
 <E7BBB6E4-F911-47D4-A4BC-3DF3D29B557B@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E7BBB6E4-F911-47D4-A4BC-3DF3D29B557B@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 03:47:50AM +0000, Song Liu wrote:
> 
> 
> > On Mar 13, 2020, at 7:43 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > On Fri, Mar 13, 2020 at 05:35:16PM -0700, Song Liu wrote:
> >> Motivation (copied from 2/2):
> >> 
> >> ======================= 8< =======================
> >> Currently, sysctl kernel.bpf_stats_enabled controls BPF runtime stats.
> >> Typical userspace tools use kernel.bpf_stats_enabled as follows:
> >> 
> >>  1. Enable kernel.bpf_stats_enabled;
> >>  2. Check program run_time_ns;
> >>  3. Sleep for the monitoring period;
> >>  4. Check program run_time_ns again, calculate the difference;
> >>  5. Disable kernel.bpf_stats_enabled.
> >> 
> >> The problem with this approach is that only one userspace tool can toggle
> >> this sysctl. If multiple tools toggle the sysctl at the same time, the
> >> measurement may be inaccurate.
> >> 
> >> To fix this problem while keep backward compatibility, introduce
> >> /dev/bpf_stats. sysctl kernel.bpf_stats_enabled will only change the
> >> lowest bit of the static key. /dev/bpf_stats, on the other hand, adds 2
> >> to the static key for each open fd. The runtime stats is enabled when
> >> kernel.bpf_stats_enabled == 1 or there is open fd to /dev/bpf_stats.
> >> 
> >> With /dev/bpf_stats, user space tool would have the following flow:
> >> 
> >>  1. Open a fd to /dev/bpf_stats;
> >>  2. Check program run_time_ns;
> >>  3. Sleep for the monitoring period;
> >>  4. Check program run_time_ns again, calculate the difference;
> >>  5. Close the fd.
> >> ======================= 8< =======================
> >> 
> >> 1/2 adds a few new API to jump_label.
> >> 2/2 adds the /dev/bpf_stats and adjust kernel.bpf_stats_enabled handler.
> >> 
> >> Please share your comments.
> > 
> > Conceptually makes sense to me. Few comments:
> > 1. I don't understand why +2 logic is necessary.
> > Just do +1 for every FD and change proc_do_static_key() from doing
> > explicit enable/disable to do +1/-1 as well on transition from 0->1 and 1->0.
> > The handler would need to check that 1->1 and 0->0 is a nop.
> 
> With the +2/-2 logic, we use the lowest bit of the counter to remember 
> the value of the sysctl. Otherwise, we cannot tell whether we are making
> 0->1 transition or 1->1 transition. 

that can be another static int var in the handler.
and no need for patch 1.

> > 
> > 2. /dev is kinda awkward. May be introduce a new bpf command that returns fd?
> 
> Yeah, I also feel /dev is awkward. fd from bpf command sounds great. 
> 
> > 
> > 3. Instead of 1 and 2 tweak sysctl to do ++/-- unconditionally?
> > Like repeated sysctl kernel.bpf_stats_enabled=1 will keep incrementing it
> > and would need equal amount of sysctl kernel.bpf_stats_enabled=0 to get
> > it back to zero where it will stay zero even if users keep spamming
> > sysctl kernel.bpf_stats_enabled=0.
> > This way current services that use sysctl will keep working as-is.
> > Multiple services that currently collide on sysctl will magically start
> > working without any changes to them. It is still backwards compatible.
> 
> I think this is not fully backwards compatible. With current logic, the 
> following sequence disables stats eventually. 
> 
>   sysctl kernel.bpf_stats_enabled=1
>   sysctl kernel.bpf_stats_enabled=1
>   sysctl kernel.bpf_stats_enabled=0
> 
> The same sequence will not disable stats with the ++/-- sysctl. 

sure, but if a process holding an fd 'sysctl kernel.bpf_stats_enabled=0'
won't disable stats either. So it's also not backwards compatible. imo it's a
change in behavior whichever way, but either approach doesn't break user space.
An advantage of not doing an fd is that some user that really wants to have
stats disabled for performance benchmarking can do
'sysctl kernel.bpf_stats_enabled=0' few times and the stats will be off.
We can also make 'sysctl kernel.bpf_stats_enabled' to return current counter,
so humans can see how many daemons are doing stats collection at that very
moment.
We can also do both new fd via bpf syscall and ++/-- via sysctl, but imo
++/-- via sysctl is enough to address the issue of multiple stats collecting
daemons. The patch would be small enough that we can push it via bpf tree
and into older kernels as arguable 'fix'.
