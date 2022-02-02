Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0983B4A6D6F
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 10:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243887AbiBBJDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 04:03:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243538AbiBBJDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 04:03:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643792592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tBpysxXu/y6O0XEmjrfAdxp73GcDGPjpjHECrtLEYho=;
        b=MClnfuxlWdR3xk3fK7ptu7qnElJw54QWU0bdH8Q60FQlM7URs2AtmuqsLSr87Co6+rIaTN
        wYLTcowHbk512YXOiL7uwvUfAakMNTEnTMytqCxYR7hIp4ydEBB43UFo0TWA5Cd8E56gVd
        Gxzqk7PYSz1oBDHUQkJ6iRWTRqGNKR8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-M_j9Z2V9N-6auge9NoumKA-1; Wed, 02 Feb 2022 04:03:12 -0500
X-MC-Unique: M_j9Z2V9N-6auge9NoumKA-1
Received: by mail-ej1-f72.google.com with SMTP id rl11-20020a170907216b00b006b73a611c1aso7783978ejb.22
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 01:03:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tBpysxXu/y6O0XEmjrfAdxp73GcDGPjpjHECrtLEYho=;
        b=qOUaXV1GOAz2JhGUFSoUn5u7EBIHX560UtkHinWEUlZVihiRQ19GXV2juEeDm41GEs
         CXxIyarQodhAcPU2E1Ia0sSB8cDsV2vFpRpEfCiI7rfD2CShwE/F1mlG8VUluNMhSGc/
         4Uy5DU2+XGnrZHCGBKKrjHIRhxJk3UqApqffJWz/c6NM8kYqqCvC81YIQmQzeWNjDGGJ
         QMqzoZOSSzdxce/J5ZXrRj3lF36qXyanPlnR0IYu7REqsHcvDba1v37uDeOkzCEWCVdy
         kQvtjS99GnCQreU0n7A/NG3PHEH63WJmFzdShGeZ2Bk7di7V7aCHm0MqqwEwfu6Bizsc
         CfrQ==
X-Gm-Message-State: AOAM533ZZlvbma/fQWUjghLJGTYRJN9bLrsTqc4Hee4TLFw7AqhaA+0y
        dFHAJaODWNWQG+36V7ZVlRcPkrOTukSMTcO3TC8ihhBQ515dDhWCQMbxFVwM9P4o+hMnieX3aPB
        uDyLWYUFeOXylmo+i
X-Received: by 2002:a50:fb8d:: with SMTP id e13mr7042897edq.334.1643792590550;
        Wed, 02 Feb 2022 01:03:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycrgETHA1TUmaiILhylhEXqD3m5+a4ptG3yUIOx5s8nbaaTUWPlikogxZT5CXm57xkq9MSjg==
X-Received: by 2002:a50:fb8d:: with SMTP id e13mr7042880edq.334.1643792590349;
        Wed, 02 Feb 2022 01:03:10 -0800 (PST)
Received: from krava ([83.240.63.12])
        by smtp.gmail.com with ESMTPSA id a6sm15414917ejs.214.2022.02.02.01.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 01:03:09 -0800 (PST)
Date:   Wed, 2 Feb 2022 10:03:07 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v7 00/10] fprobe: Introduce fprobe function entry/exit
 probe
Message-ID: <YfpIy+/Pqlw5EcZk@krava>
References: <164360522462.65877.1891020292202285106.stgit@devnote2>
 <YfnKIyTwi+F3IPdI@krava>
 <CAEf4BzYRJuTLJc=Z9P-p3BtuKu_74MtA2MyrY_ceBxofuKuzHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYRJuTLJc=Z9P-p3BtuKu_74MtA2MyrY_ceBxofuKuzHQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 04:09:05PM -0800, Andrii Nakryiko wrote:
> On Tue, Feb 1, 2022 at 4:02 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Mon, Jan 31, 2022 at 02:00:24PM +0900, Masami Hiramatsu wrote:
> > > Hi,
> > >
> > > Here is the 7th version of fprobe. This version fixes unregister_fprobe()
> > > ensures that exit_handler is not called after returning from the
> > > unregister_fprobe(), and fixes some comments and documents.
> > >
> > > The previous version is here[1];
> > >
> > > [1] https://lore.kernel.org/all/164338031590.2429999.6203979005944292576.stgit@devnote2/T/#u
> > >
> > > This series introduces the fprobe, the function entry/exit probe
> > > with multiple probe point support. This also introduces the rethook
> > > for hooking function return as same as the kretprobe does. This
> > > abstraction will help us to generalize the fgraph tracer,
> > > because we can just switch to it from the rethook in fprobe,
> > > depending on the kernel configuration.
> > >
> > > The patch [1/10] is from Jiri's series[2].
> > >
> > > [2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u
> > >
> > > And the patch [9/10] adds the FPROBE_FL_KPROBE_SHARED flag for the case
> > > if user wants to share the same code (or share a same resource) on the
> > > fprobe and the kprobes.
> >
> > hi,
> > it works fine for bpf selftests, but when I use it through bpftrace
> > to attach more probes with:
> >
> >   # ./src/bpftrace -e 'kprobe:ksys_* { }'
> >   Attaching 27 probes
> >
> > I'm getting stalls like:
> >
> > krava33 login: [  988.574069] INFO: task bpftrace:4137 blocked for more than 122 seconds.
> > [  988.577577]       Not tainted 5.16.0+ #89
> > [  988.580173] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  988.585538] task:bpftrace        state:D stack:    0 pid: 4137 ppid:  4123 flags:0x00004004
> > [  988.589869] Call Trace:
> > [  988.591312]  <TASK>
> > [  988.592577]  __schedule+0x3a8/0xd30
> > [  988.594469]  ? wait_for_completion+0x84/0x110
> > [  988.596753]  schedule+0x4e/0xc0
> > [  988.598480]  schedule_timeout+0xed/0x130
> > [  988.600524]  ? rcu_read_lock_sched_held+0x12/0x70
> > [  988.602901]  ? lock_release+0x253/0x4a0
> > [  988.604935]  ? lock_acquired+0x1b7/0x410
> > [  988.607041]  ? trace_hardirqs_on+0x1b/0xe0
> > [  988.609202]  wait_for_completion+0xae/0x110
> > [  988.613762]  __wait_rcu_gp+0x127/0x130
> > [  988.615787]  synchronize_rcu_tasks_generic+0x46/0xa0
> > [  988.618329]  ? call_rcu_tasks+0x20/0x20
> > [  988.620600]  ? rcu_tasks_pregp_step+0x10/0x10
> > [  988.623232]  ftrace_shutdown.part.0+0x174/0x210
> > [  988.625820]  unregister_ftrace_function+0x37/0x60
> > [  988.628480]  unregister_fprobe+0x2d/0x50
> > [  988.630928]  bpf_link_free+0x4e/0x70
> > [  988.633126]  bpf_link_release+0x11/0x20
> > [  988.635249]  __fput+0xae/0x270
> > [  988.637022]  task_work_run+0x5c/0xa0
> > [  988.639016]  exit_to_user_mode_prepare+0x251/0x260
> > [  988.641294]  syscall_exit_to_user_mode+0x16/0x50
> > [  988.646249]  do_syscall_64+0x48/0x90
> > [  988.648218]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [  988.650787] RIP: 0033:0x7f9079e95fbb
> > [  988.652761] RSP: 002b:00007ffd474fa3b0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> > [  988.656718] RAX: 0000000000000000 RBX: 00000000011bf8d0 RCX: 00007f9079e95fbb
> > [  988.660110] RDX: 0000000000000000 RSI: 00007ffd474fa3b0 RDI: 0000000000000019
> > [  988.663512] RBP: 00007ffd474faaf0 R08: 0000000000000000 R09: 000000000000001a
> > [  988.666673] R10: 0000000000000064 R11: 0000000000000293 R12: 0000000000000001
> > [  988.669770] R13: 00000000004a19a1 R14: 00007f9083428c00 R15: 00000000008c02d8
> > [  988.672601]  </TASK>
> > [  988.675763] INFO: lockdep is turned off.
> >
> > I have't investigated yet, any idea?
> >
> 
> Do you happen to have a CPU count that's not a power of 2? Check if
> you have [0] in your tree, it might be that.
> 
>   [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a773abf72eb0cac008743891068ca6edecc44683

yes, that helped, thanks

jirka

