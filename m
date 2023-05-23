Return-Path: <netdev+bounces-4516-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB4970D286
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:51:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B616281153
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFE5A7484;
	Tue, 23 May 2023 03:51:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85616FCB
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:51:55 +0000 (UTC)
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE4D91
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:51:52 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-39831cb47c6so35512b6e.2
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684813912; x=1687405912;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yIkuQZ+qdAD7k8JlzR1OzpyKJcttih6PMIIHdvbXCnY=;
        b=rt8vp2ENKvN+m4mpP6dLJpbZQAMd2pfX6kMHp+UwA3lODujXcPwR6CE5hwBA080m4C
         9FOrwyo8p2jMxcmMDQnp0GJfKqYMmb+9vevwqGDAO5oiNycogVvscxhDjG1gpZynGsv8
         /V0AoItI5MJamtXaDAMW2wqX2wLqvWKNohm5lpGG1kyayXBvF1QY5or5fTRmu5Z4stD4
         TQlhswl+iky4vY2NPGeEOzU0NJobtuWiXStkQMbqXe3JreFti2HBj7OYx4hX6I9/eL8r
         xIrbpNz1Y+L0Vie77YtiZC1S2Dtdd5F7DVo8qRwdZ0HAfSezwI6cZ/sFNqXmrkxGGEfG
         uvtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684813912; x=1687405912;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yIkuQZ+qdAD7k8JlzR1OzpyKJcttih6PMIIHdvbXCnY=;
        b=KY/EjaIxbA69KVLxBTGq4sqCv4LqZFccr5sjfRpv5Z6yJAe05HFRenG3ifeVKXG0Cq
         /gmVx32eQVDFK8TbUogXUCBFIM6yVDQaVH+oI3YbcXTDnUgOAP0MXarFZaUVOemowI1T
         gZsDuiUarkaqwj1t3CHNissFspMdUMnAXdxjC9PDuJ6IkBL5X7pYbj5r+TVxd0l83L+C
         Jo6KgwcjNuKcC/bNDtyXlbWLtCd9MKjSFI708pseNIeluK7v1fhVNABJEBr4KjFBZXt3
         OAi2sPV4/MPW5SMLmX8XRJoYxQC5X6IK3TTpsmWRDJbh7uiKjPk3fjAfXWWAEHkn1U2w
         0Gzw==
X-Gm-Message-State: AC+VfDxsNgSzev8KnEXyYc6FjGONNexRNoIzZYHzIxdQ04z5fddKeDmn
	pP4Upge7Qm0rxOGtxWvzBciJCA==
X-Google-Smtp-Source: ACHHUZ5McP0LDJeLE2FLxhLjthL3iV47QS1t5l5mXQZkP5lEvYu0gxHUJJJn+SdWqCt31/ODTte6WA==
X-Received: by 2002:a54:4584:0:b0:387:7651:e117 with SMTP id z4-20020a544584000000b003877651e117mr6520915oib.0.1684813911973;
        Mon, 22 May 2023 20:51:51 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:6e3:2de7:7b12:484a? ([2804:14d:5c5e:44fb:6e3:2de7:7b12:484a])
        by smtp.gmail.com with ESMTPSA id q2-20020a056870e7c200b0019e8cd4711dsm497826oak.35.2023.05.22.20.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 20:51:51 -0700 (PDT)
Message-ID: <5b28cd6f-d921-b095-1190-474bcce89e53@mojatatu.com>
Date: Tue, 23 May 2023 00:51:44 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
To: Peilin Ye <yepeilin.cs@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>,
 Jiri Pirko <jiri@resnulli.us>
Cc: Peilin Ye <peilin.ye@bytedance.com>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>, Hillf Danton <hdanton@sina.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Cong Wang <cong.wang@bytedance.com>, Vlad Buslov <vladbu@nvidia.com>
References: <cover.1684796705.git.peilin.ye@bytedance.com>
 <8e3383d0bacd084f0e33d9158d24bd411f1bf6ba.1684796705.git.peilin.ye@bytedance.com>
Content-Language: en-US
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <8e3383d0bacd084f0e33d9158d24bd411f1bf6ba.1684796705.git.peilin.ye@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 22/05/2023 20:55, Peilin Ye wrote:
> mini_Qdisc_pair::p_miniq is a double pointer to mini_Qdisc [...]


Hi Peilin!

With V2 patches 5 and 6 applied I was still able to trigger an oops.

Branch is 'net' + patches 5 & 6:
145f639b9403 (HEAD -> main) net/sched: qdisc_destroy() old ingress and 
clsact Qdiscs before grafting
1aac74ef9673 net/sched: Refactor qdisc_graft() for ingress and clsact Qdiscs
18c40a1cc1d9 (origin/main, origin/HEAD) net/handshake: Fix sock->file 
allocation

Kernel config is the same as in the syzbot report.
Note that this was on a _single core_ VM.
I will double check if v1 is triggering this issue (basically run the 
repro for a long time). For multi-core my VM is running OOM even on a 
32Gb system. I will check if we have a spare server to run the repro.

[  695.782780][T12033] 
==================================================================
[  695.783617][T12033] BUG: KASAN: slab-use-after-free in 
mini_qdisc_pair_swap+0x1c2/0x1f0
[  695.784323][T12033] Write of size 8 at addr ffff888060cafb08 by task 
repro/12033
[  695.784996][T12033]
[  695.785210][T12033] CPU: 0 PID: 12033 Comm: repro Not tainted 
6.4.0-rc2-00187-g145f639b9403 #1
[  695.785981][T12033] Hardware name: QEMU Standard PC (i440FX + PIIX, 
1996), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
[  695.786883][T12033] Call Trace:
[  695.787178][T12033]  <TASK>
[  695.787444][T12033]  dump_stack_lvl+0xd9/0x1b0
[  695.787871][T12033]  print_report+0xc4/0x5f0
[  695.788283][T12033]  ? __virt_addr_valid+0x5e/0x2d0
[  695.788736][T12033]  ? __phys_addr+0xc6/0x140
[  695.789138][T12033]  ? mini_qdisc_pair_swap+0x1c2/0x1f0
[  695.789604][T12033]  kasan_report+0xc0/0xf0
[  695.789604][T12033]  ? mini_qdisc_pair_swap+0x1c2/0x1f0
[  695.789604][T12033]  mini_qdisc_pair_swap+0x1c2/0x1f0
[  695.789604][T12033]  ? ingress_init+0x1c0/0x1c0
[  695.789604][T12033]  tcf_chain0_head_change.isra.0+0xb9/0x120
[  695.789604][T12033]  tc_new_tfilter+0x1ebb/0x22b0
[  695.789604][T12033]  ? tc_del_tfilter+0x1570/0x1570
[  695.789604][T12033]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[  695.789604][T12033]  ? kasan_quarantine_put+0x102/0x230
[  695.789604][T12033]  ? lockdep_hardirqs_on+0x7d/0x100
[  695.789604][T12033]  ? rtnetlink_rcv_msg+0x94a/0xd30
[  695.789604][T12033]  ? reacquire_held_locks+0x4b0/0x4b0
[  695.789604][T12033]  ? bpf_lsm_capable+0x9/0x10
[  695.789604][T12033]  ? tc_del_tfilter+0x1570/0x1570
[  695.789604][T12033]  rtnetlink_rcv_msg+0x98a/0xd30
[  695.789604][T12033]  ? rtnl_getlink+0xb10/0xb10
[  695.789604][T12033]  ? reacquire_held_locks+0x4b0/0x4b0
[  695.789604][T12033]  ? netdev_core_pick_tx+0x390/0x390
[  695.789604][T12033]  netlink_rcv_skb+0x166/0x440
[  695.789604][T12033]  ? rtnl_getlink+0xb10/0xb10
[  695.789604][T12033]  ? netlink_ack+0x1370/0x1370
[  695.789604][T12033]  ? kasan_set_track+0x25/0x30
[  695.789604][T12033]  ? netlink_deliver_tap+0x1b1/0xd00
[  695.789604][T12033]  netlink_unicast+0x530/0x800
[  695.789604][T12033]  ? netlink_attachskb+0x880/0x880
[  695.789604][T12033]  ? __sanitizer_cov_trace_switch+0x54/0x90
[  695.789604][T12033]  ? __phys_addr_symbol+0x30/0x70
[  695.789604][T12033]  ? __check_object_size+0x323/0x740
[  695.789604][T12033]  netlink_sendmsg+0x90b/0xe10
[  695.789604][T12033]  ? netlink_unicast+0x800/0x800
[  695.789604][T12033]  ? bpf_lsm_socket_sendmsg+0x9/0x10
[  695.789604][T12033]  ? netlink_unicast+0x800/0x800
[  695.789604][T12033]  sock_sendmsg+0xd9/0x180
[  695.789604][T12033]  ____sys_sendmsg+0x264/0x910
[  695.789604][T12033]  ? kernel_sendmsg+0x50/0x50
[  695.789604][T12033]  ? __copy_msghdr+0x460/0x460
[  695.789604][T12033]  ___sys_sendmsg+0x11d/0x1b0
[  695.789604][T12033]  ? do_recvmmsg+0x700/0x700
[  695.789604][T12033]  ? find_held_lock+0x2d/0x110
[  695.789604][T12033]  ? __might_fault+0xe5/0x190
[  695.789604][T12033]  ? reacquire_held_locks+0x4b0/0x4b0
[  695.789604][T12033]  __sys_sendmmsg+0x18e/0x430
[  695.789604][T12033]  ? __ia32_sys_sendmsg+0xb0/0xb0
[  695.789604][T12033]  ? reacquire_held_locks+0x4b0/0x4b0
[  695.789604][T12033]  ? rcu_is_watching+0x12/0xb0
[  695.789604][T12033]  ? xfd_validate_state+0x5d/0x180
[  695.789604][T12033]  ? restore_fpregs_from_fpstate+0xc1/0x1d0
[  695.789604][T12033]  ? unlock_page_memcg+0x2d0/0x2d0
[  695.789604][T12033]  ? do_futex+0x350/0x350
[  695.789604][T12033]  __x64_sys_sendmmsg+0x9c/0x100
[  695.789604][T12033]  ? syscall_enter_from_user_mode+0x26/0x80
[  695.789604][T12033]  do_syscall_64+0x38/0xb0
[  695.789604][T12033]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  695.789604][T12033] RIP: 0033:0x7f4aca44a89d
[  695.789604][T12033] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 
0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 
24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4b 05 0e 00 f7 d8 64 
89 01 48
[  695.789604][T12033] RSP: 002b:00007f4aca2eec68 EFLAGS: 00000203 
ORIG_RAX: 0000000000000133
[  695.789604][T12033] RAX: ffffffffffffffda RBX: 00007f4aca2efcdc RCX: 
00007f4aca44a89d
[  695.789604][T12033] RDX: 040000000000009f RSI: 00000000200002c0 RDI: 
0000000000000007
[  695.789604][T12033] RBP: 00007f4aca2eede0 R08: 0000000000000000 R09: 
0000000000000000
[  695.789604][T12033] R10: 0000000000000000 R11: 0000000000000203 R12: 
fffffffffffffeb8
[  695.789604][T12033] R13: 000000000000006e R14: 00007ffd1a53f720 R15: 
00007f4aca2cf000
[  695.789604][T12033]  </TASK>
[  695.789604][T12033]
[  695.789604][T12033] Allocated by task 12031:
[  695.789604][T12033]  kasan_save_stack+0x20/0x40
[  695.789604][T12033]  kasan_set_track+0x25/0x30
[  695.789604][T12033]  __kasan_kmalloc+0xa2/0xb0
[  695.789604][T12033]  __kmalloc_node+0x60/0x100
[  695.789604][T12033]  qdisc_alloc+0xb3/0xa90
[  695.789604][T12033]  qdisc_create+0xcf/0x1020
[  695.789604][T12033]  tc_modify_qdisc+0x495/0x1ab0
[  695.789604][T12033]  rtnetlink_rcv_msg+0x439/0xd30
[  695.789604][T12033]  netlink_rcv_skb+0x166/0x440
[  695.789604][T12033]  netlink_unicast+0x530/0x800
[  695.789604][T12033]  netlink_sendmsg+0x90b/0xe10
[  695.789604][T12033]  sock_sendmsg+0xd9/0x180
[  695.789604][T12033]  ____sys_sendmsg+0x264/0x910
[  695.789604][T12033]  ___sys_sendmsg+0x11d/0x1b0
[  695.789604][T12033]  __sys_sendmmsg+0x18e/0x430
[  695.789604][T12033]  __x64_sys_sendmmsg+0x9c/0x100
[  695.789604][T12033]  do_syscall_64+0x38/0xb0
[  695.789604][T12033]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  695.789604][T12033]
[  695.789604][T12033] Freed by task 15:
[  695.789604][T12033]  kasan_save_stack+0x20/0x40
[  695.789604][T12033]  kasan_set_track+0x25/0x30
[  695.789604][T12033]  kasan_save_free_info+0x2e/0x40
[  695.789604][T12033]  ____kasan_slab_free+0x15e/0x1b0
[  695.789604][T12033]  slab_free_freelist_hook+0x10b/0x1e0
[  695.789604][T12033]  __kmem_cache_free+0xaf/0x2e0
[  695.789604][T12033]  rcu_core+0x7f7/0x1ac0
[  695.789604][T12033]  __do_softirq+0x1d8/0x8fd
[  695.789604][T12033]
[  695.789604][T12033] Last potentially related work creation:
[  695.789604][T12033]  kasan_save_stack+0x20/0x40
[  695.789604][T12033]  __kasan_record_aux_stack+0xbf/0xd0
[  695.789604][T12033]  __call_rcu_common.constprop.0+0x9a/0x790
[  695.789604][T12033]  qdisc_put_unlocked+0x74/0x90
[  695.789604][T12033]  tcf_block_release+0x90/0xa0
[  695.789604][T12033]  tc_new_tfilter+0xa5e/0x22b0
[  695.789604][T12033]  rtnetlink_rcv_msg+0x98a/0xd30
[  695.789604][T12033]  netlink_rcv_skb+0x166/0x440
[  695.789604][T12033]  netlink_unicast+0x530/0x800
[  695.789604][T12033]  netlink_sendmsg+0x90b/0xe10
[  695.789604][T12033]  sock_sendmsg+0xd9/0x180
[  695.789604][T12033]  ____sys_sendmsg+0x264/0x910
[  695.789604][T12033]  ___sys_sendmsg+0x11d/0x1b0
[  695.789604][T12033]  __sys_sendmmsg+0x18e/0x430
[  695.789604][T12033]  __x64_sys_sendmmsg+0x9c/0x100
[  695.789604][T12033]  do_syscall_64+0x38/0xb0
[  695.789604][T12033]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  695.789604][T12033]
[  695.789604][T12033] Second to last potentially related work creation:
[  695.789604][T12033]  kasan_save_stack+0x20/0x40
[  695.789604][T12033]  __kasan_record_aux_stack+0xbf/0xd0
[  695.789604][T12033]  __call_rcu_common.constprop.0+0x9a/0x790
[  695.789604][T12033]  rht_deferred_worker+0x10fd/0x2010
[  695.789604][T12033]  process_one_work+0x9f9/0x15f0
[  695.789604][T12033]  worker_thread+0x687/0x1110
[  695.789604][T12033]  kthread+0x334/0x430
[  695.789604][T12033]  ret_from_fork+0x1f/0x30
[  695.789604][T12033]
[  695.789604][T12033] The buggy address belongs to the object at 
ffff888060caf800
[  695.789604][T12033]  which belongs to the cache kmalloc-1k of size 1024
[  695.789604][T12033] The buggy address is located 776 bytes inside of
[  695.789604][T12033]  freed 1024-byte region [ffff888060caf800, 
ffff888060cafc00)
[  695.789604][T12033]
[  695.789604][T12033] The buggy address belongs to the physical page:
[  695.789604][T12033] page:ffffea0001832b00 refcount:1 mapcount:0 
mapping:0000000000000000 index:0x0 pfn:0x60cac
[  695.789604][T12033] head:ffffea0001832b00 order:2 entire_mapcount:0 
nr_pages_mapped:0 pincount:0
[  695.789604][T12033] flags: 
0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
[  695.789604][T12033] page_type: 0xffffffff()
[  695.789604][T12033] raw: 00fff00000010200 ffff888012441dc0 
ffffea0000bac600 dead000000000002
[  695.789604][T12033] raw: 0000000000000000 0000000000080008 
00000001ffffffff 0000000000000000
[  695.789604][T12033] page dumped because: kasan: bad access detected
[  695.789604][T12033] page_owner tracks the page as allocated
[  695.789604][T12033] page last allocated via order 2, migratetype 
Unmovable, gfp_mask 
0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), 
pid 13324, tgid 13318 (repro), ts 170262603079, free_ts 0
[  695.789604][T12033]  get_page_from_freelist+0xe71/0x2e80
[  695.789604][T12033]  __alloc_pages+0x1c8/0x4a0
[  695.789604][T12033]  alloc_pages+0x1a9/0x270
[  695.789604][T12033]  allocate_slab+0x24e/0x380
[  695.789604][T12033]  ___slab_alloc+0x89a/0x1400
[  695.789604][T12033]  __slab_alloc.constprop.0+0x56/0xa0
[  695.789604][T12033]  __kmem_cache_alloc_node+0x126/0x330
[  695.789604][T12033]  kmalloc_trace+0x25/0xe0
[  695.789604][T12033]  fl_change+0x1b3/0x51e0
[  695.789604][T12033]  tc_new_tfilter+0x992/0x22b0
[  695.789604][T12033]  rtnetlink_rcv_msg+0x98a/0xd30
[  695.789604][T12033]  netlink_rcv_skb+0x166/0x440
[  695.789604][T12033]  netlink_unicast+0x530/0x800
[  695.789604][T12033]  netlink_sendmsg+0x90b/0xe10
[  695.789604][T12033]  sock_sendmsg+0xd9/0x180
[  695.789604][T12033]  ____sys_sendmsg+0x264/0x910
[  695.789604][T12033] page_owner free stack trace missing
[  695.789604][T12033]
[  695.789604][T12033] Memory state around the buggy address:
[  695.789604][T12033]  ffff888060cafa00: fb fb fb fb fb fb fb fb fb fb 
fb fb fb fb fb fb
[  695.789604][T12033]  ffff888060cafa80: fb fb fb fb fb fb fb fb fb fb 
fb fb fb fb fb fb
[  695.789604][T12033] >ffff888060cafb00: fb fb fb fb fb fb fb fb fb fb 
fb fb fb fb fb fb
[  695.789604][T12033]                       ^
[  695.789604][T12033]  ffff888060cafb80: fb fb fb fb fb fb fb fb fb fb 
fb fb fb fb fb fb
[  695.789604][T12033]  ffff888060cafc00: fc fc fc fc fc fc fc fc fc fc 
fc fc fc fc fc fc
[  695.789604][T12033] 
==================================================================
[  695.996261][T12042] __nla_validate_parse: 32 callbacks suppressed
[  695.996271][T12042] netlink: 24 bytes leftover after parsing 
attributes in process `repro'.
[  696.473670][T12046] netlink: 24 bytes leftover after parsing 
attributes in process `repro'.
[  696.660496][T12033] Kernel panic - not syncing: KASAN: panic_on_warn 
set ...
[  696.661250][T12033] CPU: 0 PID: 12033 Comm: repro Not tainted 
6.4.0-rc2-00187-g145f639b9403 #1
[  696.661947][T12033] Hardware name: QEMU Standard PC (i440FX + PIIX, 
1996), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
[  696.662768][T12033] Call Trace:
[  696.663031][T12033]  <TASK>
[  696.663268][T12033]  dump_stack_lvl+0xd9/0x1b0
[  696.663659][T12033]  panic+0x689/0x730
[  696.663977][T12033]  ? panic_smp_self_stop+0xa0/0xa0
[  696.664396][T12033]  ? preempt_schedule_thunk+0x1a/0x20
[  696.664829][T12033]  ? preempt_schedule_common+0x45/0xc0
[  696.665263][T12033]  ? mini_qdisc_pair_swap+0x1c2/0x1f0
[  696.665698][T12033]  check_panic_on_warn+0xab/0xb0
[  696.666087][T12033]  ? mini_qdisc_pair_swap+0x1c2/0x1f0
[  696.666519][T12033]  end_report+0xe9/0x120
[  696.666861][T12033]  kasan_report+0xcd/0xf0
[  696.667209][T12033]  ? mini_qdisc_pair_swap+0x1c2/0x1f0
[  696.667639][T12033]  mini_qdisc_pair_swap+0x1c2/0x1f0
[  696.668064][T12033]  ? ingress_init+0x1c0/0x1c0
[  696.668451][T12033]  tcf_chain0_head_change.isra.0+0xb9/0x120
[  696.668964][T12033]  tc_new_tfilter+0x1ebb/0x22b0
[  696.669391][T12033]  ? tc_del_tfilter+0x1570/0x1570
[  696.669608][T12033]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[  696.669608][T12033]  ? kasan_quarantine_put+0x102/0x230
[  696.669608][T12033]  ? lockdep_hardirqs_on+0x7d/0x100
[  696.669608][T12033]  ? rtnetlink_rcv_msg+0x94a/0xd30
[  696.669608][T12033]  ? reacquire_held_locks+0x4b0/0x4b0
[  696.669608][T12033]  ? bpf_lsm_capable+0x9/0x10
[  696.669608][T12033]  ? tc_del_tfilter+0x1570/0x1570
[  696.669608][T12033]  rtnetlink_rcv_msg+0x98a/0xd30
[  696.669608][T12033]  ? rtnl_getlink+0xb10/0xb10
[  696.669608][T12033]  ? reacquire_held_locks+0x4b0/0x4b0
[  696.669608][T12033]  ? netdev_core_pick_tx+0x390/0x390
[  696.669608][T12033]  netlink_rcv_skb+0x166/0x440
[  696.669608][T12033]  ? rtnl_getlink+0xb10/0xb10
[  696.669608][T12033]  ? netlink_ack+0x1370/0x1370
[  696.669608][T12033]  ? kasan_set_track+0x25/0x30
[  696.669608][T12033]  ? netlink_deliver_tap+0x1b1/0xd00
[  696.669608][T12033]  netlink_unicast+0x530/0x800
[  696.669608][T12033]  ? netlink_attachskb+0x880/0x880
[  696.669608][T12033]  ? __sanitizer_cov_trace_switch+0x54/0x90
[  696.669608][T12033]  ? __phys_addr_symbol+0x30/0x70
[  696.669608][T12033]  ? __check_object_size+0x323/0x740
[  696.669608][T12033]  netlink_sendmsg+0x90b/0xe10
[  696.669608][T12033]  ? netlink_unicast+0x800/0x800
[  696.669608][T12033]  ? bpf_lsm_socket_sendmsg+0x9/0x10
[  696.669608][T12033]  ? netlink_unicast+0x800/0x800
[  696.669608][T12033]  sock_sendmsg+0xd9/0x180
[  696.669608][T12033]  ____sys_sendmsg+0x264/0x910
[  696.669608][T12033]  ? kernel_sendmsg+0x50/0x50
[  696.669608][T12033]  ? __copy_msghdr+0x460/0x460
[  696.669608][T12033]  ___sys_sendmsg+0x11d/0x1b0
[  696.669608][T12033]  ? do_recvmmsg+0x700/0x700
[  696.669608][T12033]  ? find_held_lock+0x2d/0x110
[  696.669608][T12033]  ? __might_fault+0xe5/0x190
[  696.669608][T12033]  ? reacquire_held_locks+0x4b0/0x4b0
[  696.669608][T12033]  __sys_sendmmsg+0x18e/0x430
[  696.669608][T12033]  ? __ia32_sys_sendmsg+0xb0/0xb0
[  696.669608][T12033]  ? reacquire_held_locks+0x4b0/0x4b0
[  696.669608][T12033]  ? rcu_is_watching+0x12/0xb0
[  696.669608][T12033]  ? xfd_validate_state+0x5d/0x180
[  696.669608][T12033]  ? restore_fpregs_from_fpstate+0xc1/0x1d0
[  696.669608][T12033]  ? unlock_page_memcg+0x2d0/0x2d0
[  696.669608][T12033]  ? do_futex+0x350/0x350
[  696.669608][T12033]  __x64_sys_sendmmsg+0x9c/0x100
[  696.669608][T12033]  ? syscall_enter_from_user_mode+0x26/0x80
[  696.669608][T12033]  do_syscall_64+0x38/0xb0
[  696.669608][T12033]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  696.669608][T12033] RIP: 0033:0x7f4aca44a89d
[  696.669608][T12033] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 
0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 
24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4b 05 0e 00 f7 d8 64 
89 01 48
[  696.669608][T12033] RSP: 002b:00007f4aca2eec68 EFLAGS: 00000203 
ORIG_RAX: 0000000000000133
[  696.669608][T12033] RAX: ffffffffffffffda RBX: 00007f4aca2efcdc RCX: 
00007f4aca44a89d
[  696.669608][T12033] RDX: 040000000000009f RSI: 00000000200002c0 RDI: 
0000000000000007
[  696.669608][T12033] RBP: 00007f4aca2eede0 R08: 0000000000000000 R09: 
0000000000000000
[  696.669608][T12033] R10: 0000000000000000 R11: 0000000000000203 R12: 
fffffffffffffeb8
[  696.669608][T12033] R13: 000000000000006e R14: 00007ffd1a53f720 R15: 
00007f4aca2cf000
[  696.669608][T12033]  </TASK>
[  696.669608][T12033] Kernel Offset: disabled
[  696.669608][T12033] Rebooting in 86400 seconds..





