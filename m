Return-Path: <netdev+bounces-6410-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18DB8716358
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7ECB2811F2
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C185121093;
	Tue, 30 May 2023 14:13:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50E921083
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:13:55 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B019132
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:13:19 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f70597707eso87715e9.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685455967; x=1688047967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DfNot7KNj2VwPiVK9ENaX+APjAvDSF0tv9rTi2wIpLs=;
        b=o3+tgDbk9I/rOOfgBCbTaqUjjcn4/f9vkjaD8spOlXD6sIVbR1r4Nhdy+2740z9su8
         vaMsB6/6nrR9nFjGz53/aQSiI4VqKDXefM4Qyjzg3gQ9Y9jsqCVNpJi9iQ50C54+/+7g
         3NNX667Mqkk/ijZLulhv99L4QWmR9wkbWjDcy1gpJb/vVKlJ0t/GxGW0axzeq7aN4axY
         WOLxMwU1clzTELMwDarj1hwFRL3qTR/H21W1/jywJrqebjBEM8yus9fWO1+P/obx0OZv
         4RcBP5nGUH/xO3mnU5YbNeImpmDhwhusg9h7VlOojzop4C4rMDoFWloVYrpguyWrnIPF
         oD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685455967; x=1688047967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DfNot7KNj2VwPiVK9ENaX+APjAvDSF0tv9rTi2wIpLs=;
        b=IP1GFl0MkNliRyAOQmT9+7Izdv3+8gNnCxZD3jkPfbn27YyYACadaDFW7tDifRAGpq
         fB1cGgDD7atIFNC8+CffL4mFVz5nbQz5osd3OomLwNbNayI35mjOG0GTF0LucEhXKyTr
         tq+0dM3fhJzQcp4pygDb6yog58VA9lQJHZ9iMKOBwkXG4eeYJsSldb4e58OC61XGRxAj
         O8mJAz6YEfmVUaCNCR4hAwgs8C129TYxMYf0rWHJZVoXVbXhqtcehVThjv71X4gQEk7v
         PQ3LBb0ThOe0WaZH34nXRf6UyV2M6u3zcwy9ZO+2cUAJ6jHy+qoBllnZZ1xLAuMwjBNx
         X4Rg==
X-Gm-Message-State: AC+VfDzb+KaWFNyfpk/3oL9/C5S0UgmGiagI4YV8ju8URN6FLnOEapyc
	y4rrQxWCPPn/rhmpEFpMO1U/7Y4YTerMLfnpv7lQcnBNCb7K1o+jMv9hgA==
X-Google-Smtp-Source: ACHHUZ5GPzKO5WYgTfz+nXPalr+DLmUiejqRNl4VatYCnhv5JF6RHplbm9Q+5gER7MKBNzMLFA5b920Ng5BXI2oxpZg=
X-Received: by 2002:a05:600c:1c12:b0:3f4:2594:118a with SMTP id
 j18-20020a05600c1c1200b003f42594118amr168111wms.2.1685455966606; Tue, 30 May
 2023 07:12:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d2b08adaa6654692a15b57c9cbbc0bd7@huawei.com>
In-Reply-To: <d2b08adaa6654692a15b57c9cbbc0bd7@huawei.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 30 May 2023 16:12:34 +0200
Message-ID: <CANn89i+Hzz4yjrxFPe2UMZZaYBqdeh74ovnkyRQTHa_tW4h-HA@mail.gmail.com>
Subject: Re: [BUG REPORT] softlock up in net/core cleanup_net
To: "jiangheng (G)" <jiangheng14@huawei.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, 
	"pabeni@redhat.com" <pabeni@redhat.com>, "shakeelb@google.com" <shakeelb@google.com>, 
	"roman.gushchin@linux.dev" <roman.gushchin@linux.dev>, shaozhengchao <shaozhengchao@huawei.com>, 
	"vasily.averin@linux.dev" <vasily.averin@linux.dev>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 3:57=E2=80=AFPM jiangheng (G) <jiangheng14@huawei.c=
om> wrote:
>
> Hi all,
> on linux 5.10,  we want to use docker interactively when testing an inter=
nal feature. When docker restarts the container, it will call cleanup_net a=
nd a crash will occur.
>

Do not use 5.10, please. This is too old.

Back in 5.18, we made some improvements

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D4caaf75888d893b6525173a1537980e13c141988



> [  843.330515] CPU: 0 PID: 158 Comm: kworker/u8:2 Kdump: loaded Tainted: =
G    B      OEL    #1 [  843.330516] Hardware name: QEMU KVM Virtual Machin=
e, BIOS 0.0.0 02/06/2015 [  843.330523] Workqueue: netns cleanup_net [  843=
.330526] pstate: 60400085 (nZCv daIf +PAN -UAO -TCO BTYPE=3D--) [  843.3305=
29] pc : machine_kexec+0x48/0x2b0 [  843.330531] lr : machine_kexec+0x48/0x=
2b0 [  843.330531] sp : ffff80010284bb10 [  843.330533] x29: ffff80010284bb=
10 x28: ffff0000ff851cf8 [  843.330535] x27: ffff0000ff851d78 x26: ffff8001=
0284bda0 [  843.330537] x25: ffff800101d9c000 x24: 0000000000000001 [  843.=
330539] x23: ffff800101d9c650 x22: ffff800101eb6000 [  843.330541] x21: fff=
f800101eb6000 x20: ffff0000cba23c00 [  843.330543] x19: ffff0000cba23c00 x1=
8: 0000000000000020 [  843.330545] x17: 0000000000000000 x16: ffff800100d27=
a3c [  843.330548] x15: ffffffffffffffff x14: 0000000060000085 [  843.33055=
0] x13: ffff8001001c090c x12: 0000000000000040 [  843.330552] x11: ffff8001=
01aad158 x10: 00000000ffff8000 [  843.330554] x9 : ffff800100157654 x8 : 00=
00000000000000 [  843.330556] x7 : ffff8001017ed158 x6 : 0000000000017ffd [=
  843.330559] x5 : ffff0000ff84b410 x4 : ffff80010284b910 [  843.330561] x3=
 : 0000000000000001 x2 : 0000000000000000 [  843.330563] x1 : 0000000000000=
000 x0 : ffff0000c09eb9c0 [  843.330566] Call trace:
> [  843.330569]  machine_kexec+0x48/0x2b0 [  843.330573]  __crash_kexec+0x=
90/0x13c [  843.330578]  panic+0x314/0x4d8 [  843.330582]  watchdog_timer_f=
n+0x26c/0x2f0 [  843.330585]  __run_hrtimer+0x98/0x2b4 [  843.330586]  __hr=
timer_run_queues+0xbc/0x130 [  843.330588]  hrtimer_interrupt+0x150/0x3e4 [=
  843.330592]  arch_timer_handler_virt+0x3c/0x50 [  843.330596]  handle_per=
cpu_devid_irq+0x90/0x1f4
> [  843.330599]  __handle_domain_irq+0x84/0x100 [  843.330601]  gic_handle=
_irq+0x88/0x2b0 [  843.330603]  el1_irq+0xb8/0x140 [  843.330605]  smp_call=
_function_single+0x1b8/0x1dc
> [  843.330608]  rcu_barrier+0x1c4/0x2d0
> [  843.330612]  netdev_run_todo+0x7c/0x330 [  843.330615]  rtnl_unlock+0x=
18/0x24 [  843.330616]  default_device_exit_batch+0x15c/0x190
> [  843.330621]  ops_exit_list+0x70/0x84
> [  843.330622]  cleanup_net+0x184/0x2e0
> [  843.330625]  process_one_work+0x1d4/0x4bc [  843.330627]  worker_threa=
d+0x150/0x400 [  843.330629]  kthread+0x108/0x134 [  843.330631]  ret_from_=
fork+0x10/0x18 [  843.330633] ---[ end trace 8378c01c76c90cc4 ]--- [  843.3=
30637] Bye!
>
> Crash:bt -l
> PID: 158    TASK: ffff0000c09eb9c0  CPU: 0   COMMAND: "kworker/u8:2"
> PID: 158    TASK: ffff0000c09eb9c0  CPU: 0   COMMAND: "kworker/u8:2"
> bt: invalid kernel virtual address: 0  type: "IRQ stack contents"
> bt: read of IRQ stack at 0 failed
> #0 [ffff80010284bb60] __crash_kexec at ffff8001001c0908
>     /usr/src/debug/kernel/./arch/arm64/include/asm/kexec.h: 57
> #1 [ffff80010284bcf0] panic at ffff800100d256a4
>     /usr/src/debug/kernel/kernel/panic.c: 392
> #2 [ffff80010284bde0] watchdog_timer_fn at ffff80010020a5c8
>     /usr/src/debug/kernel/kernel/watchdog.c: 578
> #3 [ffff80010284be30] __run_hrtimer at ffff800100191d24
>     /usr/src/debug/kernel/kernel/time/hrtimer.c: 1586
> #4 [ffff80010284be80] __hrtimer_run_queues at ffff800100191ffc
>     /usr/src/debug/kernel/kernel/time/hrtimer.c: 1650
> #5 [ffff80010284bee0] hrtimer_interrupt at ffff80010019267c
>     /usr/src/debug/kernel/kernel/time/hrtimer.c: 1712
> #6 [ffff80010284bf50] arch_timer_handler_virt at ffff800100aa9a38
>     /usr/src/debug/kernel/drivers/clocksource/arm_arch_timer.c: 674
> #7 [ffff80010284bf60] handle_percpu_devid_irq at ffff80010016500c
>     /usr/src/debug/kernel/./arch/arm64/include/asm/percpu.h: 45
> #8 [ffff80010284bf90] __handle_domain_irq at ffff80010015b840
>     /usr/src/debug/kernel/./include/linux/irqdesc.h: 153
> #9 [ffff80010284bfd0] gic_handle_irq at ffff800100010144
>     /usr/src/debug/kernel/./include/linux/irqdesc.h: 171
> --- <IRQ stack> ---
> #10 [ffff800102d4bb20] el1_irq at ffff800100012374
>     /usr/src/debug/kernel/arch/arm64/kernel/entry.S: 672
> #11 [ffff800102d4bb40] smp_call_function_single at ffff8001001b1e68
>     /usr/src/debug/kernel/./arch/arm64/include/asm/cmpxchg.h: 278
> #12 [ffff800102d4bba0] rcu_barrier at ffff800100178ba0
>     /usr/src/debug/kernel/kernel/rcu/tree.c: 3920
> #13 [ffff800102d4bc00] netdev_run_todo at ffff800100b3f768
>     /usr/src/debug/kernel/net/core/dev.c: 10313
> #14 [ffff800102d4bc80] rtnl_unlock at ffff800100b4cb54
>     /usr/src/debug/kernel/net/core/rtnetlink.c: 114
> #15 [ffff800102d4bc90] default_device_exit_batch at ffff800100b378d8
>     /usr/src/debug/kernel/net/core/dev.c: 11287
> #16 [ffff800102d4bd00] ops_exit_list at ffff800100b2337c
>     /usr/src/debug/kernel/net/core/net_namespace.c: 200
> #17 [ffff800102d4bd30] cleanup_net at ffff800100b25ab0
>     /usr/src/debug/kernel/net/core/net_namespace.c: 616
> #18 [ffff800102d4bd90] process_one_work at ffff8001000de784
>     /usr/src/debug/kernel/kernel/workqueue.c: 2354
> #19 [ffff800102d4bdf0] worker_thread at ffff8001000df18c
>     /usr/src/debug/kernel/kernel/workqueue.c: 2500
> #20 [ffff800102d4be50] kthread at ffff8001000e75a4
>     /usr/src/debug/kernel/kernel/kthread.c: 313
>
> The above backtrace seems to be caused func:netdev_run_todo() that the si=
ze of list not null.
> void netdev_run_todo(void)
> {
>          struct net_device *dev, *tmp;
>          struct list_head list;
> #ifdef CONFIG_LOCKDEP
>          struct list_head unlink_list;
>
>          list_replace_init(&net_unlink_list, &unlink_list);
>
>          while (!list_empty(&unlink_list)) {
>                    struct net_device *dev =3D list_first_entry(&unlink_li=
st,
>                                                     struct net_device,
>                                                unlink_list);
>                    list_del_init(&dev->unlink_list);
>                    dev->nested_level =3D dev->lower_level - 1;
>          }
> #endif
>
>          /* Snapshot list, allow later requests */
>          list_replace_init(&net_todo_list, &list);
>
>          __rtnl_unlock();
>
>          /* Wait for rcu callbacks to finish before next phase */
>          if !(list_empty(&list))
>                    rcu_barrier();
>
> I wonder if softlockup is due to the above code? Please help analyze the =
possible causes of this.

I have seen similar reports about RTNL starvation from syzbot reports.

How many netns do you dismantle per second ?

On recent kernels this is how fast things run :

# time (for i in {1..1000}; do unshare -n /bin/bash -c "ifconfig lo up"; do=
ne)

real 0m3.379s
user 0m1.708s
sys 0m1.553s

