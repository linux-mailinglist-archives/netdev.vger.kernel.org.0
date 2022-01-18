Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C7C492854
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 15:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242710AbiAROZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 09:25:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232372AbiAROZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 09:25:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642515930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N0j/fQ4PflVYGPy/bLo8LyJo0AEkhVcyeqzgco+GTv8=;
        b=VF8b9qOtBTViUT6+Slp36CzezAcdTXWL4olQown8KqKoP8K6N8gehy6fRjSepVu8G/p9JY
        WsKdYZUwgHcGXSGHu3hbfxteNvpimitwxLCtdGyGXYg4inQ8JfdeDozdqAtEWUfnUeoADL
        ltRSI3JuA1tBw8a50y2kPixXvjY2Lo8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-_FRNal_eMbaXVKMYxOXA-g-1; Tue, 18 Jan 2022 09:25:29 -0500
X-MC-Unique: _FRNal_eMbaXVKMYxOXA-g-1
Received: by mail-ed1-f72.google.com with SMTP id s9-20020aa7d789000000b004021d03e2dfso6907012edq.18
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 06:25:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N0j/fQ4PflVYGPy/bLo8LyJo0AEkhVcyeqzgco+GTv8=;
        b=QDt978vVGrwcEVYbpEl5KrAcXj9KK6fikFNs4R2baV0vtekoyt0DtFUSvXRHpV37dp
         rrwx2Nga7F5umuZqRX/+DCu7HoJT/SGPUWgH9Qn+IrXpy/hKUqyjTOg6KQmDftRqNjLG
         +ubvWDWynjkn7nO3l2BUoJpvD7qz9sDkYrf7D21QZ0291uEUFX0BsrbE85qbv+khfCZC
         zVcWmPHBf8aVNZdrk+ybH/SwbTVU//IcQ3E0YqvXJBO1IPw+9XuQf+d2Wi99XswWjWZv
         67KHTBB/05dyK/MnClUbmfPfTzGuMM+0CEZnzHTUKW61kMxIZqN8L+GbosvTx/OBoIB/
         23iA==
X-Gm-Message-State: AOAM531lcCPN8PPIsjQ1f7j819fI3Nwxm3XzhjlgnJCsGuATqezxcweJ
        6OkF0S9hPeEQsABHPq3XYG+mDEREbiE+vQXVj68M2+sJjE2MmPkBTNx7HDPg8jnvnapLzevlD/Z
        K1snuMgSzhQtpee+o
X-Received: by 2002:a17:907:6d22:: with SMTP id sa34mr19840875ejc.635.1642515928024;
        Tue, 18 Jan 2022 06:25:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxt7mNYuWcPmCyBDWs9bQTDMSJk3irHRnoPYop007C8xxpW8ahyJvriCHSEP50GE/m7CBOxBQ==
X-Received: by 2002:a17:907:6d22:: with SMTP id sa34mr19840848ejc.635.1642515927724;
        Tue, 18 Jan 2022 06:25:27 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id cw6sm7205493edb.11.2022.01.18.06.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 06:25:27 -0800 (PST)
Date:   Tue, 18 Jan 2022 15:25:25 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v2 0/8] fprobe: Introduce fprobe function entry/exit
 probe
Message-ID: <YebN1TIRxMX0sgs4@krava>
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
 <Yd77SYWgtrkhFIYz@krava>
 <YeAatqQTKsrxmUkS@krava>
 <20220115135219.64ef1cc6482d5de8a3bce9b0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220115135219.64ef1cc6482d5de8a3bce9b0@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 15, 2022 at 01:52:19PM +0900, Masami Hiramatsu wrote:
> On Thu, 13 Jan 2022 13:27:34 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > On Wed, Jan 12, 2022 at 05:01:15PM +0100, Jiri Olsa wrote:
> > > On Wed, Jan 12, 2022 at 11:02:46PM +0900, Masami Hiramatsu wrote:
> > > > Hi Jiri and Alexei,
> > > > 
> > > > Here is the 2nd version of fprobe. This version uses the
> > > > ftrace_set_filter_ips() for reducing the registering overhead.
> > > > Note that this also drops per-probe point private data, which
> > > > is not used anyway.
> > > > 
> > > > This introduces the fprobe, the function entry/exit probe with
> > > > multiple probe point support. This also introduces the rethook
> > > > for hooking function return as same as kretprobe does. This
> > > 
> > > nice, I was going through the multi-user-graph support 
> > > and was wondering that this might be a better way
> > > 
> > > > abstraction will help us to generalize the fgraph tracer,
> > > > because we can just switch it from rethook in fprobe, depending
> > > > on the kernel configuration.
> > > > 
> > > > The patch [1/8] and [7/8] are from your series[1]. Other libbpf
> > > > patches will not be affected by this change.
> > > 
> > > I'll try the bpf selftests on top of this
> > 
> > I'm getting crash and stall when running bpf selftests,
> > the fprobe sample module works fine, I'll check on that
> 
> OK, I got a kernel stall. I missed to enable CONFIG_FPROBE.
> I think vmtest.sh should support menuconfig option.
> 
> #6 bind_perm:OK
> #7 bloom_filter_map:OK
> [  107.282403] clocksource: timekeeping watchdog on CPU0: Marking clocksource 'tsc' as unstable because the skew is too large:
> [  107.283240] clocksource:                       'hpet' wd_nsec: 496216090 wd_now: 7ddc7120 wd_last: 7ae746b7 mask: ffffffff
> [  107.284045] clocksource:                       'tsc' cs_nsec: 495996979 cs_now: 31fdb69b39 cs_last: 31c2d29219 mask: ffffffffffffffff
> [  107.284926] clocksource:                       'tsc' is current clocksource.
> [  107.285487] tsc: Marking TSC unstable due to clocksource watchdog
> [  107.285973] TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
> [  107.286616] sched_clock: Marking unstable (107240582544, 45390230)<-(107291410145, -5437339)
> [  107.290408] clocksource: Not enough CPUs to check clocksource 'tsc'.
> [  107.290879] clocksource: Switched to clocksource hpet
> [  604.210415] INFO: rcu_tasks detected stalls on tasks:
> [  604.210830] (____ptrval____): .. nvcsw: 86/86 holdout: 1 idle_cpu: -1/0
> [  604.211314] task:test_progs      state:R  running task     stack:    0 pid:   87 ppid:    85 flags:0x00004000
> [  604.212058] Call Trace:
> [  604.212246]  <TASK>
> [  604.212452]  __schedule+0x362/0xbb0
> [  604.212723]  ? preempt_schedule_notrace_thunk+0x16/0x18
> [  604.213107]  preempt_schedule_notrace+0x48/0x80
> [  604.217403]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  604.217790]  ? ftrace_regs_call+0xd/0x52
> [  604.218087]  ? bpf_test_finish.isra.0+0x190/0x190
> [  604.218461]  ? bpf_fentry_test1+0x5/0x10
> [  604.218750]  ? trace_clock_x86_tsc+0x10/0x10
> [  604.219064]  ? __sys_bpf+0x8b1/0x2970
> [  604.219337]  ? lock_is_held_type+0xd7/0x130
> [  604.219680]  ? __x64_sys_bpf+0x1c/0x20
> [  604.219957]  ? do_syscall_64+0x35/0x80
> [  604.220237]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  604.220653]  </TASK>
> 
> Jiri, is that what you had seen? 

hi,
sorry for late response

I did not get any backtrace for the stall, debugging showed 
that the first probed function was called over and over for
some reason

as for the crash I used the small fix below

do you have any newer version I could play with?

jirka


---
diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 3333893e5217..883151275892 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -157,7 +157,8 @@ int unregister_fprobe(struct fprobe *fp)
 	ret = unregister_ftrace_function(&fp->ftrace);
 
 	if (!ret) {
-		rethook_free(fp->rethook);
+		if (fp->rethook)
+			rethook_free(fp->rethook);
 		if (fp->syms) {
 			kfree(fp->addrs);
 			fp->addrs = NULL;

