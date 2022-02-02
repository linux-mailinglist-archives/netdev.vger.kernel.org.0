Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29664A68E5
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243061AbiBBACu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:02:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48968 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230250AbiBBACt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:02:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643760169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hsfDlwN8c6tnMU/iltAgO/gq/FAXpbav+vaBqYWS55g=;
        b=GT6jQtvnkR+5bo8EyVHpVtAsK3anFrrbDDwa1MsIiyERWtj76ozkaW8ASzEyLwkFEAhMN/
        HTEncIimXw/1CistF7NokNXfIPOknq9Nd631Uh618YBBjoS6p99Jv1Bf3T91raoXOmXR33
        jMciTQRIbX5lOuESN1h1LA+6/uKUPuw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-GgFqAoTTOxiNOVQXY9MgIg-1; Tue, 01 Feb 2022 19:02:48 -0500
X-MC-Unique: GgFqAoTTOxiNOVQXY9MgIg-1
Received: by mail-ed1-f69.google.com with SMTP id k10-20020a50cb8a000000b00403c8326f2aso9503574edi.6
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 16:02:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hsfDlwN8c6tnMU/iltAgO/gq/FAXpbav+vaBqYWS55g=;
        b=cNQyDh6s49Z10UF2VLv3DUvn8jWtOU0moQDbq3wuJST+02vXGytbh+BSG/Tc8EpEic
         imXRQcl3Y1kIBnRxNbqCeHIt0uhZshhGF87spaXLzuMPSYHvNgQZ7lpdDiAZ/uz3p53Z
         njAHP1vZpIJTBE74b3Sa21GgKU0oWIqomw3eVHFXi8DwaxyQC2BW7HlAZler22XnW/9G
         9QV42Hp1Xjhp3OefbvXZa2d5a6Jc9b/gZI8MNfkMYQSGqlSg7E4wDaVlCgDzk6tx9wPD
         i3ik64jHO52vFZROWFQWVdZ1pucyriPxXIyFSpZNdfAJcNLr+0p6Q4V/PJ6kX9m2AJaH
         qLmg==
X-Gm-Message-State: AOAM5306q9aYgiJHOcqZM2kcQSCJc1kh0LTQWIxeTrrqQzNoOhqdBb1p
        v07yet3aF4sjRTDiNRff8daTzrhPP8pM9zu1DBo+9nIEbMs/gALiXk4ja4MJ4HAT0B6Bypr8c5c
        Ynq5hNDgroS9KdEnN
X-Received: by 2002:a17:907:7412:: with SMTP id gj18mr23636776ejc.381.1643760167029;
        Tue, 01 Feb 2022 16:02:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnLQ/NbTjRUNUcLwZztPQCV/CTnkzZHTDqgRAnlFfFp6XdVIw1PiVg5mtWPg+REBAZREzMgQ==
X-Received: by 2002:a17:907:7412:: with SMTP id gj18mr23636758ejc.381.1643760166822;
        Tue, 01 Feb 2022 16:02:46 -0800 (PST)
Received: from krava ([83.240.63.12])
        by smtp.gmail.com with ESMTPSA id co19sm20170185edb.7.2022.02.01.16.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:02:46 -0800 (PST)
Date:   Wed, 2 Feb 2022 01:02:43 +0100
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
Subject: Re: [PATCH v7 00/10] fprobe: Introduce fprobe function entry/exit
 probe
Message-ID: <YfnKIyTwi+F3IPdI@krava>
References: <164360522462.65877.1891020292202285106.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164360522462.65877.1891020292202285106.stgit@devnote2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 02:00:24PM +0900, Masami Hiramatsu wrote:
> Hi,
> 
> Here is the 7th version of fprobe. This version fixes unregister_fprobe()
> ensures that exit_handler is not called after returning from the
> unregister_fprobe(), and fixes some comments and documents.
> 
> The previous version is here[1];
> 
> [1] https://lore.kernel.org/all/164338031590.2429999.6203979005944292576.stgit@devnote2/T/#u
> 
> This series introduces the fprobe, the function entry/exit probe
> with multiple probe point support. This also introduces the rethook
> for hooking function return as same as the kretprobe does. This
> abstraction will help us to generalize the fgraph tracer,
> because we can just switch to it from the rethook in fprobe,
> depending on the kernel configuration.
> 
> The patch [1/10] is from Jiri's series[2].
> 
> [2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u
> 
> And the patch [9/10] adds the FPROBE_FL_KPROBE_SHARED flag for the case
> if user wants to share the same code (or share a same resource) on the
> fprobe and the kprobes.

hi,
it works fine for bpf selftests, but when I use it through bpftrace
to attach more probes with:

  # ./src/bpftrace -e 'kprobe:ksys_* { }'
  Attaching 27 probes

I'm getting stalls like:

krava33 login: [  988.574069] INFO: task bpftrace:4137 blocked for more than 122 seconds.
[  988.577577]       Not tainted 5.16.0+ #89
[  988.580173] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  988.585538] task:bpftrace        state:D stack:    0 pid: 4137 ppid:  4123 flags:0x00004004
[  988.589869] Call Trace:
[  988.591312]  <TASK>
[  988.592577]  __schedule+0x3a8/0xd30
[  988.594469]  ? wait_for_completion+0x84/0x110
[  988.596753]  schedule+0x4e/0xc0
[  988.598480]  schedule_timeout+0xed/0x130
[  988.600524]  ? rcu_read_lock_sched_held+0x12/0x70
[  988.602901]  ? lock_release+0x253/0x4a0
[  988.604935]  ? lock_acquired+0x1b7/0x410
[  988.607041]  ? trace_hardirqs_on+0x1b/0xe0
[  988.609202]  wait_for_completion+0xae/0x110
[  988.613762]  __wait_rcu_gp+0x127/0x130
[  988.615787]  synchronize_rcu_tasks_generic+0x46/0xa0
[  988.618329]  ? call_rcu_tasks+0x20/0x20
[  988.620600]  ? rcu_tasks_pregp_step+0x10/0x10
[  988.623232]  ftrace_shutdown.part.0+0x174/0x210
[  988.625820]  unregister_ftrace_function+0x37/0x60
[  988.628480]  unregister_fprobe+0x2d/0x50
[  988.630928]  bpf_link_free+0x4e/0x70
[  988.633126]  bpf_link_release+0x11/0x20
[  988.635249]  __fput+0xae/0x270
[  988.637022]  task_work_run+0x5c/0xa0
[  988.639016]  exit_to_user_mode_prepare+0x251/0x260
[  988.641294]  syscall_exit_to_user_mode+0x16/0x50
[  988.646249]  do_syscall_64+0x48/0x90
[  988.648218]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  988.650787] RIP: 0033:0x7f9079e95fbb
[  988.652761] RSP: 002b:00007ffd474fa3b0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
[  988.656718] RAX: 0000000000000000 RBX: 00000000011bf8d0 RCX: 00007f9079e95fbb
[  988.660110] RDX: 0000000000000000 RSI: 00007ffd474fa3b0 RDI: 0000000000000019
[  988.663512] RBP: 00007ffd474faaf0 R08: 0000000000000000 R09: 000000000000001a
[  988.666673] R10: 0000000000000064 R11: 0000000000000293 R12: 0000000000000001
[  988.669770] R13: 00000000004a19a1 R14: 00007f9083428c00 R15: 00000000008c02d8
[  988.672601]  </TASK>
[  988.675763] INFO: lockdep is turned off.

I have't investigated yet, any idea?

thanks,
jirka

