Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27602185409
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 03:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgCNCn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 22:43:29 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43578 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgCNCn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 22:43:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id c144so6401360pfb.10;
        Fri, 13 Mar 2020 19:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gTv57bmUMayhCzk1O5/3xfBPFk4Ei/L2Uv/w0qE0Uv0=;
        b=ly0MizdiHMFMcicd+GU7QtHM+8WzWpkV44Hh1TPHgoTYKre3lIteHxI+yfpTc4IfDO
         Q79BIqjwGKKYV2U/x/Q0zMTj0z9Mwxd7ZDhfUox6MU2b7qyDUQsgTMeVwoQHD4PxPpi/
         dFoMfwlJibJQE+lqeuTgQN4hti/Kf+eeL3abrBrKCPaebccbIGQ2HGqfNFpMoYvkjJJJ
         MYXH+MDVrxTTOmfcgrIRSyFIV/nm9nD911k1jQX51CWlNeGmhIol4O42qCtA6oe8ZCxs
         dbEbXgeNpU3svP3K8vWceBRk41dMDyglZtlUMLQ/8kNUbylEOLd+F1s+XzHEyChALtle
         VchQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gTv57bmUMayhCzk1O5/3xfBPFk4Ei/L2Uv/w0qE0Uv0=;
        b=CIbxZ1WaM2z03DQ4OMzP6LTKs6bKvBlY5/4J9FqHJnu0Da0fFxCf1L9A2AM++kWwGB
         TivjQWPjLBbIJwGmiZOWp6gUT8MYa1lkYwMeURcCz10qN8HdXshKRJAZQnlC7BqCdTWI
         RAr5QyVcJqED+PLfqc5CfZSHhu6FLqo/EJFvMptQM7YuElvK4mwLysdwb/vtp9b8aL2Z
         QFcfqIHrPlnJKvvhQtKjmdFeXRFCjvKUje+sFD2BUKdUUrVk2rLxwmjmZIJKuOQRVXw8
         4z/xjnQIg5KuflQEqQ4GQkmfCiSN1EY9OopKRaIGwpLwXuVDlylY+VCZSvjS2C+PcAqe
         O1jA==
X-Gm-Message-State: ANhLgQ1Zo54a3VtPxEJs9XP3xst1dS3Z5VXGeW9CMXMcYUtmKN6eTmyZ
        KgdyI36RrOX0Bglal2/0ow0=
X-Google-Smtp-Source: ADFU+vvOwDoGiIm44wVUxc27PMRID193NOa35a03TjsbfiGuiRz7u+J3vD+Y8CcNtvCEvxL7rQBNZQ==
X-Received: by 2002:aa7:9a95:: with SMTP id w21mr2061733pfi.57.1584153805842;
        Fri, 13 Mar 2020 19:43:25 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1661])
        by smtp.gmail.com with ESMTPSA id w9sm6137719pfd.94.2020.03.13.19.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 19:43:25 -0700 (PDT)
Date:   Fri, 13 Mar 2020 19:43:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        ast@kernel.org, daniel@iogearbox.net, mcgrof@kernel.org,
        keescook@chromium.org, yzaikin@google.com, peterz@infradead.org,
        bristot@redhat.com, mingo@kernel.org
Subject: Re: [RFC bpf-next 0/2] sharing bpf runtime stats with /dev/bpf_stats
Message-ID: <20200314024322.vymr6qkxsf6nzpum@ast-mbp.dhcp.thefacebook.com>
References: <20200314003518.3114452-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314003518.3114452-1-songliubraving@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 05:35:16PM -0700, Song Liu wrote:
> Motivation (copied from 2/2):
> 
> ======================= 8< =======================
> Currently, sysctl kernel.bpf_stats_enabled controls BPF runtime stats.
> Typical userspace tools use kernel.bpf_stats_enabled as follows:
> 
>   1. Enable kernel.bpf_stats_enabled;
>   2. Check program run_time_ns;
>   3. Sleep for the monitoring period;
>   4. Check program run_time_ns again, calculate the difference;
>   5. Disable kernel.bpf_stats_enabled.
> 
> The problem with this approach is that only one userspace tool can toggle
> this sysctl. If multiple tools toggle the sysctl at the same time, the
> measurement may be inaccurate.
> 
> To fix this problem while keep backward compatibility, introduce
> /dev/bpf_stats. sysctl kernel.bpf_stats_enabled will only change the
> lowest bit of the static key. /dev/bpf_stats, on the other hand, adds 2
> to the static key for each open fd. The runtime stats is enabled when
> kernel.bpf_stats_enabled == 1 or there is open fd to /dev/bpf_stats.
> 
> With /dev/bpf_stats, user space tool would have the following flow:
> 
>   1. Open a fd to /dev/bpf_stats;
>   2. Check program run_time_ns;
>   3. Sleep for the monitoring period;
>   4. Check program run_time_ns again, calculate the difference;
>   5. Close the fd.
> ======================= 8< =======================
> 
> 1/2 adds a few new API to jump_label.
> 2/2 adds the /dev/bpf_stats and adjust kernel.bpf_stats_enabled handler.
> 
> Please share your comments.

Conceptually makes sense to me. Few comments:
1. I don't understand why +2 logic is necessary.
Just do +1 for every FD and change proc_do_static_key() from doing
explicit enable/disable to do +1/-1 as well on transition from 0->1 and 1->0.
The handler would need to check that 1->1 and 0->0 is a nop.

2. /dev is kinda awkward. May be introduce a new bpf command that returns fd?

3. Instead of 1 and 2 tweak sysctl to do ++/-- unconditionally?
 Like repeated sysctl kernel.bpf_stats_enabled=1 will keep incrementing it
 and would need equal amount of sysctl kernel.bpf_stats_enabled=0 to get
 it back to zero where it will stay zero even if users keep spamming
 sysctl kernel.bpf_stats_enabled=0.
 This way current services that use sysctl will keep working as-is.
 Multiple services that currently collide on sysctl will magically start
 working without any changes to them. It is still backwards compatible.
