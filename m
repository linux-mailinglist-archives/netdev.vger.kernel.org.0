Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E61A16B0AA
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 22:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388758AbfGPUzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 16:55:03 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35020 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbfGPUzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 16:55:02 -0400
Received: by mail-pl1-f193.google.com with SMTP id w24so10730671plp.2;
        Tue, 16 Jul 2019 13:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JyDP2xrY1+vm6sbAE05lGR3/BE8oRL7Tl3eVMst2SbI=;
        b=Heifp6lPgv05YjnXAE6GeXjzI1GGrmbh6WZginvD1pu6jIKYv7O1u4o8f9ZLo7O43J
         GWwLegDY3aS6djFvijJkap3lbDOJimy431xQPA/7pF8mRgtYIf8yJJ5kSHFmHqGFMD9x
         INh3r+mOdj9UsKQ7ufiIpwx5n6odOWCAhM3QyoKrloRRCmePIUR2wDQiYiyoatidc2+j
         wlSO+pEClBKL6XEp9ULmFfpEXkIz6Q5fKGjZsKJmZnhgj3X7gib9JGp8I+VYCRb28aFt
         s+SNVfKZW/od80ZoYlLDxP3/p2N4mvQyK1DdeS/Z6TYiE0bX5vfj7dH0cM4Xm0fMMSLb
         Wjnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JyDP2xrY1+vm6sbAE05lGR3/BE8oRL7Tl3eVMst2SbI=;
        b=BOGlP2EzSN1OhPZ1/c6MXg+B5NXdKi/2/3HIWJSx5OMWIjx8z+WVAa7k5vkYN5gjp+
         FoX9+UvosesXzByBBMJ0irRJmPDCnNJ6bKGmcDAtnnWT7HF9mP754RrZfE9rJ3rdBt0M
         TJhcPZc+5Kjfgq9w2OIxRR21msaLvetkxadFWnMNTV0sIsPsxkMulfjBVxW0o+PMFAOn
         IUsslIp782k7IjmJ9ZMuL0EE1HFgX+6o/o2d3qjGxCLobgimH4xAFKCJwhWUDu8w8R7/
         E5Z9q20BjwHnSwKOEtsv2WzqEVxV4wahU4lVkrXxJxSCbmiu8342KuKt53FJmiy19H73
         yLKw==
X-Gm-Message-State: APjAAAUaRk1YD1qFzEDcOy8yt7qSOM4M7huyk2REsfcW6ZXan6mPm0AY
        Dph8aUAeLhM2YjEJJXydlB4=
X-Google-Smtp-Source: APXvYqzhq/GJvJ6rmN/or6wgrI2tKcjSDWXXI6SiYB/Y6tgHmyzGbm7M/E5KZ5ezy8gEDEWjVLMooQ==
X-Received: by 2002:a17:902:724a:: with SMTP id c10mr35809877pll.298.1563310501294;
        Tue, 16 Jul 2019 13:55:01 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::c7d4])
        by smtp.gmail.com with ESMTPSA id 4sm26151120pfc.92.2019.07.16.13.54.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 13:55:00 -0700 (PDT)
Date:   Tue, 16 Jul 2019 13:54:57 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Brendan Gregg <brendan.d.gregg@gmail.com>, connoro@google.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        duyuchao <yuchao.du@unisoc.com>, Ingo Molnar <mingo@redhat.com>,
        jeffv@google.com, Karim Yaghmour <karim.yaghmour@opersys.com>,
        kernel-team@android.com, linux-kselftest@vger.kernel.org,
        Manali Shukla <manalishukla14@gmail.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Matt Mullins <mmullins@fb.com>,
        Michal Gregorczyk <michalgr@fb.com>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>, namhyung@google.com,
        namhyung@kernel.org, netdev@vger.kernel.org,
        paul.chaignon@gmail.com, primiano@google.com,
        Qais Yousef <qais.yousef@arm.com>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH RFC 0/4] Add support to directly attach BPF program to
 ftrace
Message-ID: <20190716205455.iimn3pqpvsc3k4ry@ast-mbp.dhcp.thefacebook.com>
References: <20190710141548.132193-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710141548.132193-1-joel@joelfernandes.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 10:15:44AM -0400, Joel Fernandes (Google) wrote:
> Hi,

why are you cc-ing the whole world for this patch set?
I'll reply to all as well, but I suspect a bunch of folks consider it spam.
Please read Documentation/bpf/bpf_devel_QA.rst

Also, I think, netdev@vger rejects emails with 80+ characters in cc as spam,
so I'm not sure this set reached public mailing lists.

> These patches make it possible to attach BPF programs directly to tracepoints
> using ftrace (/sys/kernel/debug/tracing) without needing the process doing the
> attach to be alive. This has the following benefits:
> 
> 1. Simplified Security: In Android, we have finer-grained security controls to
> specific ftrace trace events using SELinux labels. We control precisely who is
> allowed to enable an ftrace event already. By adding a node to ftrace for
> attaching BPF programs, we can use the same mechanism to further control who is
> allowed to attach to a trace event.
> 
> 2. Process lifetime: In Android we are adding usecases where a tracing program
> needs to be attached all the time to a tracepoint, for the full life time of
> the system. Such as to gather statistics where there no need for a detach for
> the full system lifetime. With perf or bpf(2)'s BPF_RAW_TRACEPOINT_OPEN, this
> means keeping a process alive all the time.  However, in Android our BPF loader
> currently (for hardeneded security) involves just starting a process at boot
> time, doing the BPF program loading, and then pinning them to /sys/fs/bpf.  We
> don't keep this process alive all the time. It is more suitable to do a
> one-shot attach of the program using ftrace and not need to have a process
> alive all the time anymore for this. Such process also needs elevated
> privileges since tracepoint program loading currently requires CAP_SYS_ADMIN
> anyway so by design Android's bpfloader runs once at init and exits.
> 
> This series add a new bpf file to /sys/kernel/debug/tracing/events/X/Y/bpf
> The following commands can be written into it:
> attach:<fd>     Attaches BPF prog fd to tracepoint
> detach:<fd>     Detaches BPF prog fd to tracepoint

Looks like, to detach a program the user needs to read a text file,
parse bpf prog id from text into binary. Then call fd_from_id bpf syscall,
get a binary FD, convert it back to text and write as a text back into this file.
I think this is just a single example why text based apis are not accepted
in bpf anymore.

Through the patch set you call it ftrace. As far as I can see, this set
has zero overlap with ftrace. There is no ftrace-bpf connection here at all
that we discussed in the past Steven. It's all quite confusing.

I suggest android to solve sticky raw_tracepoint problem with user space deamon.
The reasons, you point out why user daemon cannot be used, sound weak to me.
Another acceptable solution would be to introduce pinning of raw_tp objects.
bpf progs and maps can be pinned in bpffs already. Pinning raw_tp would
be natural extension.

