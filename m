Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144196129E6
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 11:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiJ3KGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 06:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3KGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 06:06:40 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA381A0;
        Sun, 30 Oct 2022 03:06:39 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id b2so22863242eja.6;
        Sun, 30 Oct 2022 03:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KNk7ZNiVH3ImAqj0kSmZACI8FqLd5viyCJ9HhBYf3kQ=;
        b=p34yqM+RHJ5uSSTbVyrdOICfqzpdUYnaa9sv7ZWD7rhBE+rLmFbqGfK0KmSlGRpIc+
         zux3erF/Rb2AZ4Zk34rrR7v+M96VdbuC2FQ7Y/E8gn2q+t4Nj6lAgeSWYfKbA8k6YIuq
         AcOOrtmmCMyAiutpajcTkmIjX7kUePHtsi8swFe96p65mPeAAfybYvqa0gWXcyYk9wSg
         NYede4ux5uhdP13rx3l91Jz1hfYQlhgeTgriOx7BgNlvfnfgaXRVFaeFlGhKZ9HdWI6x
         5qWsyhiMo1FTGzMibFadNLlgoQGV1rPf9hK/EwqeMhwqIU0Kr1fKPtIKTEec5QoTK/d3
         17iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KNk7ZNiVH3ImAqj0kSmZACI8FqLd5viyCJ9HhBYf3kQ=;
        b=IwZdIypNsdn5bkC22E/KTBCsBRBXyY/piLXhz9uqrOF8N6BQtLZnZdWLGBx5zLbGNo
         EWXAcIcUenVrN6Heu90xAQIHlLIZEUgeXc5ZwbJN3wCxBl83rlbePRXHy5Lu45Vw/5xM
         LEA28uEbjDyHAlSG/LeZhuYJX6eDdqWae08I6en6NhyrBsTlcywsFukpP7DaUik7LoAC
         Kp3OEpwhXMROst9+5YjxZOoEhCT6ofzpB+hnN9cvBJPqQdxjMwexEH7rVJTHBSsaK4ph
         zu0Z8csFvY6R1pyJPpu5CepE6l/vNB9fqCva92vbLgWqmC6di2Q43OIQAErpiDIFOEWw
         +DEA==
X-Gm-Message-State: ACrzQf1lZowquhBIBrjtR+NwVveTuNY7wC++IeuezcTnyo4BBwp5QeaH
        Jnvd2zbK4dfXjK6Cdjj2AX6H9UWa/UNg30yyZQU=
X-Google-Smtp-Source: AMsMyM6roRgpaPqYbU28anLsZgZVIb1DqO4lJiEc0aWffhM9qq2gzAIrMkq6mjwhGd3He+C1S1M5EkPw+mDpqdIM+2I=
X-Received: by 2002:a17:907:2da6:b0:78d:3cf1:9132 with SMTP id
 gt38-20020a1709072da600b0078d3cf19132mr7579393ejc.299.1667124397592; Sun, 30
 Oct 2022 03:06:37 -0700 (PDT)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Sun, 30 Oct 2022 18:05:59 +0800
Message-ID: <CAO4mrfexGm_9=cLK+67ryXhG3bLtAwYn7j15iPV+KkMLKuOJPw@mail.gmail.com>
Subject: INFO: task hung in ppp_ioctl
To:     paulus@samba.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux Developer,

Recently when using our tool to fuzz kernel, the following crash was triggered:

HEAD commit: 64570fbc14f8 Linux 5.15-rc5
git tree: upstream
compiler: gcc 8.0.1
console output:
https://drive.google.com/file/d/1CZaZY-5qhU8R8Kx9yRxH3uk-Z-4Klr-H/view?usp=share_link
kernel config: https://drive.google.com/file/d/1uDOeEYgJDcLiSOrx9W8v2bqZ6uOA_55t/view?usp=share_link

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

INFO: task syz-executor.0:21121 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc5 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:13736 pid:21121 ppid: 20431 flags:0x00004004
Call Trace:
 __schedule+0x4a1/0x1720
 schedule+0x36/0xe0
 schedule_preempt_disabled+0xf/0x20
 __mutex_lock+0x67a/0x9a0
 ppp_ioctl+0x1247/0x1ee0
 __x64_sys_ioctl+0xe8/0x140
 do_syscall_64+0x34/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4692c9
RSP: 002b:00007f36d6808c38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004692c9
RDX: 0000000020000040 RSI: 00000000c004743e RDI: 0000000000000004
RBP: 000000000119bfb0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bfac
R13: 0000000000000000 R14: 000000000119bfa0 R15: 00007ffeb87bf8c0

Showing all locks held in the system:
1 lock held by khungtaskd/29:
 #0: ffffffff8641dee0 (rcu_read_lock){....}-{1:2}, at:
debug_show_all_locks+0x15/0x17a
1 lock held by in:imklog/6162:
 #0: ffff88800f6a1af0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x92/0xa0
3 locks held by kworker/1:8/7427:
 #0: ffff8881070edb38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at:
process_one_work+0x327/0x9f0
 #1: ffffc90005197e68 ((addr_chk_work).work){+.+.}-{0:0}, at:
process_one_work+0x327/0x9f0
 #2: ffffffff86897be8 (rtnl_mutex){+.+.}-{3:3}, at:
addrconf_verify_work+0xa/0x20
5 locks held by kworker/u4:4/2032:
 #0: ffff888100046938 ((wq_completion)netns){+.+.}-{0:0}, at:
process_one_work+0x327/0x9f0
 #1: ffffc900050cfe68 (net_cleanup_work){+.+.}-{0:0}, at:
process_one_work+0x327/0x9f0
 #2: ffffffff86893750 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x4f/0x540
 #3: ffffffff86897be8 (rtnl_mutex){+.+.}-{3:3}, at:
default_device_exit_batch+0x81/0x1d0
 #4: ffffffff864205b0 (rcu_state.barrier_mutex){+.+.}-{3:3}, at:
rcu_barrier+0x2b/0x280
3 locks held by kworker/0:54/20464:
 #0: ffff888009856738 ((wq_completion)events){+.+.}-{0:0}, at:
process_one_work+0x327/0x9f0
 #1: ffffc9000177be68 ((linkwatch_work).work){+.+.}-{0:0}, at:
process_one_work+0x327/0x9f0
 #2: ffffffff86897be8 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x40
3 locks held by kworker/0:55/20465:
 #0: ffff888009856f38
((wq_completion)events_power_efficient){+.+.}-{0:0}, at:
process_one_work+0x327/0x9f0
 #1: ffffc9000178be68 ((reg_check_chans).work){+.+.}-{0:0}, at:
process_one_work+0x327/0x9f0
 #2: ffffffff86897be8 (rtnl_mutex){+.+.}-{3:3}, at:
reg_check_chans_work+0x37/0x7f0
3 locks held by kworker/0:144/20554:
 #0: ffff888009856738 ((wq_completion)events){+.+.}-{0:0}, at:
process_one_work+0x327/0x9f0
 #1: ffffc90002a73e68 (deferred_process_work){+.+.}-{0:0}, at:
process_one_work+0x327/0x9f0
 #2: ffffffff86897be8 (rtnl_mutex){+.+.}-{3:3}, at:
switchdev_deferred_process_work+0xa/0x20
2 locks held by syz-executor.0/21121:
 #0: ffffffff866c6ec8 (ppp_mutex){+.+.}-{3:3}, at: ppp_ioctl+0x3c/0x1ee0
 #1: ffffffff86897be8 (rtnl_mutex){+.+.}-{3:3}, at: ppp_ioctl+0x1247/0x1ee0

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 29 Comm: khungtaskd Not tainted 5.15.0-rc5 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
Call Trace:
 dump_stack_lvl+0xcd/0x134
 nmi_cpu_backtrace.cold.8+0xf3/0x118
 nmi_trigger_cpumask_backtrace+0x18f/0x1c0
 watchdog+0x9a0/0xb10
 kthread+0x1a6/0x1e0
 ret_from_fork+0x1f/0x30
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 2988 Comm: systemd-journal Not tainted 5.15.0-rc5 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0033:0x7f9ecd0d80f4
Code: c0 0f 84 df 00 00 00 49 8d 2c 08 48 3b 6f 60 48 89 fb 77 42 8d
7e ff 48 8d 43 30 83 ff 07 bf 00 00 00 00 0f 43 f7 48 83 ec 08 <48> 8b
bb 48 01 00 00 41 51 49 89 c9 50 89 f1 41 50 44 0f b6 c2 8b
RSP: 002b:00007ffc82797cd8 EFLAGS: 00000216
RAX: 000056106a359cd0 RBX: 000056106a359ca0 RCX: 000000000024cc20
RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000000
RBP: 00000000002591a8 R08: 000000000000c588 R09: 00007ffc82797d20
R10: 00000000000a43ba R11: 00007f9ec8b7d760 R12: 0000000000000001
R13: 00007ffc82797d98 R14: 0000000000000006 R15: 00007ffc82797d20
FS:  00007f9ecd3e98c0 GS:  0000000000000000

Best,
Wei
