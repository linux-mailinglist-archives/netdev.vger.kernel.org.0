Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA891648B5C
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 00:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiLIX3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 18:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLIX3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 18:29:14 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050C61A81E;
        Fri,  9 Dec 2022 15:29:13 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id h12so6698531wrv.10;
        Fri, 09 Dec 2022 15:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=etvxLzPBbH9RKsYWwd3Eys3GGtIzUjovM5AMmFekdbI=;
        b=PRwFCbVjGg6G4XvpYN1iEXxSqQMdYP7LEEUU7YiiZUcZQBIOa9Bf6H66EmynD62nwF
         b1fQCIWf9BSJvTQ2PnEO/hA+LmwMVjqBovWgJEJ/3cbU+FvlYEsaFcFgDCRmsL48IGVv
         YpftuY+wQCHe82PRViA5Lew5lva1VHFVNP93Jfip4q+9M4K62RrDizekgUAoKW424pqd
         D/yeZwbqFiZdTmO7uGb+oTgP5ltSaFtdjdDir/EAHTlq+LdZnd5jX68P40pCVde5Glvl
         kd4pCMG02EE0eFiD8LoCA2Jcy4wI8rjKN6h5bPEIkNbIT34CtC1WtA5zeJgLdFs8Xw+S
         EMzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=etvxLzPBbH9RKsYWwd3Eys3GGtIzUjovM5AMmFekdbI=;
        b=QWL5YzM/uEfzcdqqv/szqPFnoaFwSGP0+wRpqQSCGbGMtvf9NvT6qBHlgM3G+QtiPo
         PlXiDA06WashzK8WVjQ+lFTNiWBBNDszR2YpSMllEtZJHcAokT7ivjYtQET4nafte08+
         HRnHHRx3Nv8Sj/sdsWEfQwkIu/fSlxVtF6JS/fkaDbxDZ3zvAv9Wj0zUA1KJnDhiKAL5
         CiejcfLcUAYIa06ZLjBSt1ZEX+xdhDzd3PujGIKYnlUI0zcC8TRKFmBIvqty7+Q0z4lp
         bw+10BWKW0/ddPEvMACHJe28Q9HBYkJz7TZZ/T1jnM10uMO5+1YfkZKzm99vKehaJIxs
         mkxA==
X-Gm-Message-State: ANoB5plMw5IsFeYvXxp34vRnxF5UwPsSzupR8eujH3mEHTLFuZlYzdBR
        pEHhgBjekS6ceocp3RuCYnA=
X-Google-Smtp-Source: AA0mqf40RJ3unjkiNz0MIqS9BA0wXmkM196zs+dq4vp8PXylYGFG4gqUqHc74BhFSYR2SKPe1TqiRQ==
X-Received: by 2002:adf:eccd:0:b0:242:102c:c571 with SMTP id s13-20020adfeccd000000b00242102cc571mr5032436wro.19.1670628551343;
        Fri, 09 Dec 2022 15:29:11 -0800 (PST)
Received: from krava ([83.240.62.58])
        by smtp.gmail.com with ESMTPSA id e3-20020a5d5303000000b002366dd0e030sm2436054wrv.68.2022.12.09.15.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 15:29:10 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Sat, 10 Dec 2022 00:29:09 +0100
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Yonghong Song <yhs@meta.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>, Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
Message-ID: <Y5PExSx9idXP2y/e@krava>
References: <Y5JkomOZaCETLDaZ@krava>
 <Y5JtACA8ay5QNEi7@krava>
 <Y5LfMGbOHpaBfuw4@krava>
 <Y5MaffJOe1QtumSN@krava>
 <Y5M9P95l85oMHki9@krava>
 <Y5NSStSi7h9Vdo/j@krava>
 <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com>
 <Y5OuQNmkoIvcV6IL@krava>
 <ee2a087e-b8c5-fc3e-a114-232490a6c3be@iogearbox.net>
 <Y5O/yxcjQLq5oDAv@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5O/yxcjQLq5oDAv@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 12:07:58AM +0100, Jiri Olsa wrote:

SNIP

> > > > > > 
> > > > > > looking at the code.. how do we ensure that code running through
> > > > > > bpf_prog_run_xdp will not get dispatcher image changed while
> > > > > > it's being exetuted
> > > > > > 
> > > > > > we use 'the other half' of the image when we add/remove programs,
> > > > > > but could bpf_dispatcher_update race with bpf_prog_run_xdp like:
> > > > > > 
> > > > > > 
> > > > > > cpu 0:                                  cpu 1:
> > > > > > 
> > > > > > bpf_prog_run_xdp
> > > > > >      ...
> > > > > >      bpf_dispatcher_xdp_func
> > > > > >         start exec image at offset 0x0
> > > > > > 
> > > > > >                                           bpf_dispatcher_update
> > > > > >                                                   update image at offset 0x800
> > > > > >                                           bpf_dispatcher_update
> > > > > >                                                   update image at offset 0x0
> > > > > > 
> > > > > >         still in image at offset 0x0
> > > > > > 
> > > > > > 
> > > > > > that might explain why I wasn't able to trigger that on
> > > > > > bare metal just in qemu
> > > > > 
> > > > > I tried patch below and it fixes the issue for me and seems
> > > > > to confirm the race above.. but not sure it's the best fix
> > > > > 
> > > > > jirka
> > > > > 
> > > > > 
> > > > > ---
> > > > > diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> > > > > index c19719f48ce0..6a2ced102fc7 100644
> > > > > --- a/kernel/bpf/dispatcher.c
> > > > > +++ b/kernel/bpf/dispatcher.c
> > > > > @@ -124,6 +124,7 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
> > > > >    	}
> > > > >    	__BPF_DISPATCHER_UPDATE(d, new ?: (void *)&bpf_dispatcher_nop_func);
> > > > > +	synchronize_rcu_tasks();
> > > > >    	if (new)
> > > > >    		d->image_off = noff;
> > > > 
> > > > This might work. In arch/x86/kernel/alternative.c, we have following
> > > > code and comments. For text_poke, synchronize_rcu_tasks() might be able
> > > > to avoid concurrent execution and update.
> > > 
> > > so my idea was that we need to ensure all the current callers of
> > > bpf_dispatcher_xdp_func (which should have rcu read lock, based
> > > on the comment in bpf_prog_run_xdp) are gone before and new ones
> > > execute the new image, so the next call to the bpf_dispatcher_update
> > > will be safe to overwrite the other half of the image
> > 
> > If v6.1-rc1 was indeed okay, then it looks like this may be related to
> > the trampoline patching for the static_call? Did it repro on v6.1-rc1
> > just with dbe69b299884 ("bpf: Fix dispatcher patchable function entry
> > to 5 bytes nop") cherry-picked?
> 
> I'll try that.. it looks to me like the problem was always there,
> maybe harder to trigger.. also to reproduce it you need to call
> bpf_dispatcher_update heavily, which is not probably the common
> use case
> 
> one other thing is that I think the fix might need rcu locking
> on the bpf_dispatcher_xdp_func side, because local_bh_disable
> seems not to be enough to make synchronize_rcu_tasks work
> 
> I'm now testing patch below
> 
> jirka
> 
> 
> ---
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index efc42a6e3aed..a27245b96d6b 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -772,7 +772,13 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
>  	 * under local_bh_disable(), which provides the needed RCU protection
>  	 * for accessing map entries.
>  	 */
> -	u32 act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
> +	u32 act;
> +
> +	rcu_read_lock();
> +
> +	act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
> +
> +	rcu_read_unlock();
>  
>  	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
>  		if (act == XDP_TX && netif_is_bond_slave(xdp->rxq->dev))
> diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> index c19719f48ce0..6a2ced102fc7 100644
> --- a/kernel/bpf/dispatcher.c
> +++ b/kernel/bpf/dispatcher.c
> @@ -124,6 +124,7 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
>  	}
>  
>  	__BPF_DISPATCHER_UPDATE(d, new ?: (void *)&bpf_dispatcher_nop_func);
> +	synchronize_rcu_tasks();
>  
>  	if (new)
>  		d->image_off = noff;

hm, so I'm eventually getting splats like below

I guess I'm missing some rcu/xdp detail, thoughts? ;-)

jirka


---
[ 1107.911088][   T41] INFO: task rcu_tasks_kthre:12 blocked for more than 122 seconds.
[ 1107.913332][   T41]       Not tainted 6.1.0-rc7+ #847
[ 1107.914801][   T41] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1107.916691][   T41] task:rcu_tasks_kthre state:D stack:14392 pid:12    ppid:2      flags:0x00004000
[ 1107.917324][   T41] Call Trace:
[ 1107.917563][   T41]  <TASK>
[ 1107.917784][   T41]  __schedule+0x419/0xe30
[ 1107.918764][   T41]  schedule+0x5d/0xe0
[ 1107.919061][   T41]  schedule_timeout+0x102/0x140
[ 1107.919386][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.919747][   T41]  ? lock_release+0x264/0x4f0
[ 1107.920079][   T41]  ? lock_acquired+0x207/0x470
[ 1107.920397][   T41]  ? trace_hardirqs_on+0x2b/0xd0
[ 1107.920723][   T41]  __wait_for_common+0xb6/0x210
[ 1107.921067][   T41]  ? usleep_range_state+0xb0/0xb0
[ 1107.921401][   T41]  __synchronize_srcu+0x151/0x1e0
[ 1107.921731][   T41]  ? rcu_tasks_pregp_step+0x10/0x10
[ 1107.922112][   T41]  ? ktime_get_mono_fast_ns+0x3a/0x90
[ 1107.922463][   T41]  ? synchronize_srcu+0xa1/0xe0
[ 1107.922784][   T41]  rcu_tasks_wait_gp+0x183/0x3b0
[ 1107.923129][   T41]  ? lock_release+0x264/0x4f0
[ 1107.923442][   T41]  rcu_tasks_one_gp+0x35a/0x3e0
[ 1107.923766][   T41]  ? rcu_tasks_postscan+0x20/0x20
[ 1107.924114][   T41]  rcu_tasks_kthread+0x31/0x40
[ 1107.924434][   T41]  kthread+0xf2/0x120
[ 1107.924713][   T41]  ? kthread_complete_and_exit+0x20/0x20
[ 1107.925095][   T41]  ret_from_fork+0x1f/0x30
[ 1107.925404][   T41]  </TASK>
[ 1107.925664][   T41] INFO: task ex:7319 blocked for more than 122 seconds.
[ 1107.926121][   T41]       Not tainted 6.1.0-rc7+ #847
[ 1107.926461][   T41] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1107.927090][   T41] task:ex              state:D stack:13648 pid:7319  ppid:677    flags:0x00004006
[ 1107.927791][   T41] Call Trace:
[ 1107.928079][   T41]  <TASK>
[ 1107.928334][   T41]  __schedule+0x419/0xe30
[ 1107.928683][   T41]  schedule+0x5d/0xe0
[ 1107.929019][   T41]  schedule_preempt_disabled+0x14/0x30
[ 1107.929440][   T41]  __mutex_lock+0x3fd/0x850
[ 1107.929799][   T41]  ? bpf_dispatcher_change_prog+0x3a/0x380
[ 1107.930235][   T41]  ? bpf_dispatcher_change_prog+0x3a/0x380
[ 1107.930609][   T41]  bpf_dispatcher_change_prog+0x3a/0x380
[ 1107.930977][   T41]  bpf_prog_test_run_xdp+0x39b/0x600
[ 1107.931340][   T41]  __sys_bpf+0x963/0x2bb0
[ 1107.931684][   T41]  ? futex_wait+0x175/0x250
[ 1107.932014][   T41]  ? lock_acquire+0x2ed/0x370
[ 1107.932328][   T41]  ? lock_release+0x264/0x4f0
[ 1107.932640][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.933028][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.933388][   T41]  ? lock_release+0x264/0x4f0
[ 1107.933700][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.934070][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.934432][   T41]  __x64_sys_bpf+0x1a/0x30
[ 1107.934733][   T41]  do_syscall_64+0x37/0x90
[ 1107.935050][   T41]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[ 1107.935428][   T41] RIP: 0033:0x7f02f9f0af3d
[ 1107.935731][   T41] RSP: 002b:00007f02fa0e9df8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[ 1107.936291][   T41] RAX: ffffffffffffffda RBX: 00007f02fa0ea640 RCX: 00007f02f9f0af3d
[ 1107.936811][   T41] RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
[ 1107.937360][   T41] RBP: 00007f02fa0e9e20 R08: 0000000000000000 R09: 0000000000000000
[ 1107.937884][   T41] R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffff80
[ 1107.938425][   T41] R13: 0000000000000011 R14: 00007ffda75fd290 R15: 00007f02fa0ca000
[ 1107.939050][   T41]  </TASK>
[ 1107.939315][   T41] INFO: task ex:7352 blocked for more than 122 seconds.
[ 1107.939744][   T41]       Not tainted 6.1.0-rc7+ #847
[ 1107.940095][   T41] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1107.940651][   T41] task:ex              state:D stack:13648 pid:7352  ppid:766    flags:0x00004006
[ 1107.941254][   T41] Call Trace:
[ 1107.941492][   T41]  <TASK>
[ 1107.941710][   T41]  __schedule+0x419/0xe30
[ 1107.942018][   T41]  ? lock_acquired+0x207/0x470
[ 1107.942339][   T41]  schedule+0x5d/0xe0
[ 1107.942616][   T41]  schedule_timeout+0x102/0x140
[ 1107.942955][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.943330][   T41]  ? lock_release+0x264/0x4f0
[ 1107.943643][   T41]  ? lock_acquired+0x207/0x470
[ 1107.943965][   T41]  ? trace_hardirqs_on+0x2b/0xd0
[ 1107.944318][   T41]  __wait_for_common+0xb6/0x210
[ 1107.944641][   T41]  ? usleep_range_state+0xb0/0xb0
[ 1107.950003][   T41]  __wait_rcu_gp+0x14d/0x170
[ 1107.950399][   T41]  ? 0xffffffffa0013840
[ 1107.950726][   T41]  synchronize_rcu_tasks_generic.part.0.isra.0+0x31/0x50
[ 1107.951207][   T41]  ? call_rcu_tasks_generic+0x350/0x350
[ 1107.951643][   T41]  ? rcu_tasks_pregp_step+0x10/0x10
[ 1107.952070][   T41]  bpf_dispatcher_change_prog+0x204/0x380
[ 1107.952521][   T41]  bpf_prog_test_run_xdp+0x39b/0x600
[ 1107.952941][   T41]  __sys_bpf+0x963/0x2bb0
[ 1107.953302][   T41]  ? futex_wait+0x175/0x250
[ 1107.953669][   T41]  ? lock_acquire+0x2ed/0x370
[ 1107.954058][   T41]  ? lock_release+0x264/0x4f0
[ 1107.954435][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.954868][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.955329][   T41]  ? lock_release+0x264/0x4f0
[ 1107.955705][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.956148][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.956582][   T41]  __x64_sys_bpf+0x1a/0x30
[ 1107.956937][   T41]  do_syscall_64+0x37/0x90
[ 1107.957312][   T41]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[ 1107.957771][   T41] RIP: 0033:0x7ffaa610af3d
[ 1107.958140][   T41] RSP: 002b:00007ffaa629adf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[ 1107.958792][   T41] RAX: ffffffffffffffda RBX: 00007ffaa629b640 RCX: 00007ffaa610af3d
[ 1107.959427][   T41] RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
[ 1107.960054][   T41] RBP: 00007ffaa629ae20 R08: 0000000000000000 R09: 0000000000000000
[ 1107.960680][   T41] R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffff80
[ 1107.961314][   T41] R13: 0000000000000011 R14: 00007ffef5c89e00 R15: 00007ffaa627b000
[ 1107.961948][   T41]  </TASK>
[ 1107.962226][   T41] INFO: task ex:7354 blocked for more than 122 seconds.
[ 1107.962756][   T41]       Not tainted 6.1.0-rc7+ #847
[ 1107.963178][   T41] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1107.963786][   T41] task:ex              state:D stack:13648 pid:7354  ppid:767    flags:0x00004006
[ 1107.964451][   T41] Call Trace:
[ 1107.964733][   T41]  <TASK>
[ 1107.965001][   T41]  __schedule+0x419/0xe30
[ 1107.965354][   T41]  schedule+0x5d/0xe0
[ 1107.965682][   T41]  schedule_preempt_disabled+0x14/0x30
[ 1107.966130][   T41]  __mutex_lock+0x3fd/0x850
[ 1107.966493][   T41]  ? lock_acquire+0x2ed/0x370
[ 1107.966870][   T41]  ? bpf_dispatcher_change_prog+0x3a/0x380
[ 1107.967340][   T41]  ? bpf_dispatcher_change_prog+0x3a/0x380
[ 1107.967792][   T41]  bpf_dispatcher_change_prog+0x3a/0x380
[ 1107.968236][   T41]  bpf_prog_test_run_xdp+0x2c8/0x600
[ 1107.968654][   T41]  __sys_bpf+0x963/0x2bb0
[ 1107.969012][   T41]  ? futex_wait+0x175/0x250
[ 1107.969380][   T41]  ? lock_acquire+0x2ed/0x370
[ 1107.969754][   T41]  ? lock_release+0x264/0x4f0
[ 1107.970135][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.970565][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.971008][   T41]  ? lock_release+0x264/0x4f0
[ 1107.971385][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.971813][   T41]  ? rcu_read_lock_sched_held+0x10/0x90
[ 1107.972257][   T41]  __x64_sys_bpf+0x1a/0x30
[ 1107.972614][   T41]  do_syscall_64+0x37/0x90
[ 1107.972984][   T41]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[ 1107.973385][   T41] RIP: 0033:0x7ffaa610af3d
[ 1107.973696][   T41] RSP: 002b:00007ffaa629adf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
[ 1107.974261][   T41] RAX: ffffffffffffffda RBX: 00007ffaa629b640 RCX: 00007ffaa610af3d
[ 1107.974795][   T41] RDX: 0000000000000048 RSI: 0000000020000140 RDI: 000000000000000a
[ 1107.975348][   T41] RBP: 00007ffaa629ae20 R08: 0000000000000000 R09: 0000000000000000
[ 1107.975942][   T41] R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffff80
[ 1107.976570][   T41] R13: 0000000000000011 R14: 00007ffef5c89e00 R15: 00007ffaa627b000
[ 1107.977216][   T41]  </TASK>
