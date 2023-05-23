Return-Path: <netdev+bounces-4662-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC6D70DB8C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34D9D281209
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3920C4A868;
	Tue, 23 May 2023 11:36:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F664A840
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 11:36:44 +0000 (UTC)
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D04BFA
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 04:36:42 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6af713338ccso1036108a34.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 04:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684841801; x=1687433801;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O5Tj7I7f1brNL3JpWUYPXV5aI/v2uveyJXXIDFWofgk=;
        b=qJBtDQ96+pVB173iM3aexPgkXCe0+8SZp/gAgErOY+c0r2/IIiWIrBfDzNBZ0yJ5lM
         XjzwU5ovC/tqrnrTwbbUtuQtaWbYWENl3ogbkNGFVq2mvj+XsLW0cOMjxRjSK17OV9Az
         ulxBsWDpvMrHeYUKOyxqlEMAr590bp0cWySkbkyDYwEA5JtyC5BhgjqXwjx8NNoynrdH
         v/hzBE1Rpe6TsIK02ICjWPbRrPQZ1FhODnwE7otx+dYHQT+zL/rLP1zKio69bJjxmb5B
         SHc/7XUqYre5yWi3nFy47NfUrw7FVMONYKYcDOycRBLkFph1pKjGlPnfNelPJarw2Cvk
         PS4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684841801; x=1687433801;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O5Tj7I7f1brNL3JpWUYPXV5aI/v2uveyJXXIDFWofgk=;
        b=PCymFqOHirrXsQ3sWAZSSS36lMnphWRrOvBBkvcU6PPz+z77lJE+DDsgOai8Xcbsgj
         rXEzaLK18uBffWiLLAaNsupvIbh4ZH4dvqc45xNDr4Q9UquTn6QP/ciTNxhcQAlSSZv8
         +nhWAM/5kM3fTx1+7xxu9HF6JTAJ5cev/qLGsKWyDgjWdDksFBy4rojJ35ViY5bS8Ydj
         /FPr9x334tnhmGa9Imoq28iIozQQ021zOO7FiUHT8XoIci+ZKiCcWlW5aO5TrclkBEnr
         aJy+x4MLsJMb0mf2h/aVKcQusp2cMRXLPArivM7dSdjhRRsGdcMsAly3O74Qn+dMru1N
         muZg==
X-Gm-Message-State: AC+VfDwFY3+pG7GNiBtM8KiX7rdOVcz+kGB70bIzxIeDpO9NNeWwsBtT
	2iRvNSL3GUyyrjY9i/1IwQx8Ug==
X-Google-Smtp-Source: ACHHUZ6hfcVV1NE0mCUiKt7LjwXEC+P7zIW30bBIiLp73Jk9WBbI0gpvtEzIAjqgSJz5vA+lA1tdnw==
X-Received: by 2002:a9d:6ad9:0:b0:6aa:f539:5ad5 with SMTP id m25-20020a9d6ad9000000b006aaf5395ad5mr6143069otq.23.1684841801209;
        Tue, 23 May 2023 04:36:41 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:6e3:2de7:7b12:484a? ([2804:14d:5c5e:44fb:6e3:2de7:7b12:484a])
        by smtp.gmail.com with ESMTPSA id s9-20020a9d7589000000b006abb3b660a9sm3269996otk.54.2023.05.23.04.36.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 04:36:40 -0700 (PDT)
Message-ID: <e462a91e-8bea-8b72-481c-4a36699e4149@mojatatu.com>
Date: Tue, 23 May 2023 08:36:35 -0300
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
Content-Language: en-US
To: Peilin Ye <yepeilin.cs@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
 Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
 Peilin Ye <peilin.ye@bytedance.com>, Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>, Hillf Danton <hdanton@sina.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Cong Wang <cong.wang@bytedance.com>, Vlad Buslov <vladbu@nvidia.com>
References: <cover.1684796705.git.peilin.ye@bytedance.com>
 <8e3383d0bacd084f0e33d9158d24bd411f1bf6ba.1684796705.git.peilin.ye@bytedance.com>
 <5b28cd6f-d921-b095-1190-474bcce89e53@mojatatu.com>
 <ZGxD1U4fI8SNSNOW@C02FL77VMD6R.googleapis.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <ZGxD1U4fI8SNSNOW@C02FL77VMD6R.googleapis.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 23/05/2023 01:40, Peilin Ye wrote:
> Hi Pedro,
> 
> On Tue, May 23, 2023 at 12:51:44AM -0300, Pedro Tammela wrote:
>> With V2 patches 5 and 6 applied I was still able to trigger an oops.
>>
>> Branch is 'net' + patches 5 & 6:
>> 145f639b9403 (HEAD -> main) net/sched: qdisc_destroy() old ingress and
>> clsact Qdiscs before grafting
>> 1aac74ef9673 net/sched: Refactor qdisc_graft() for ingress and clsact Qdiscs
>> 18c40a1cc1d9 (origin/main, origin/HEAD) net/handshake: Fix sock->file
>> allocation
>>
>> Kernel config is the same as in the syzbot report.
>> Note that this was on a _single core_ VM.
>> I will double check if v1 is triggering this issue (basically run the repro
>> for a long time). For multi-core my VM is running OOM even on a 32Gb system.
>> I will check if we have a spare server to run the repro.
> 
> Thanks for testing this, but the syzbot reproducer creates ingress Qdiscs
> under TC_H_ROOT, which isn't covered by [6/6] i.e. it exercises the
> "!ingress" path in qdisc_graft().  I think that's why you are still seeing
> the oops.  Adding sch_{ingress,clsact} to TC_H_ROOT is no longer possible
> after [1,2/6], and I think we'll need a different reproducer for [5,6/6].
> 
> However I just noticed that for some reason my git-send-email in my new
> setup didn't auto-generate From: tags with my work email, so Author: will
> be my personal email (I have to send patches from personal email to avoid
> "[External] " subject prefixes) ... I will fix it in v3 soon.  Sorry in
> advance for spamming.
> 
> Thanks,
> Peilin Ye
> 

I see,
We need to make sure then, when the time comes, that all the required 
patches are back ported in the same bundle so we don't have a partial 
fix; given that they target different commit tags.

I was still able to trigger an oops with the full patchset:

[  104.944353][ T6588] ------------[ cut here ]------------
[  104.944896][ T6588] jump label: negative count!
[  104.945780][ T6588] WARNING: CPU: 0 PID: 6588 at 
kernel/jump_label.c:263 static_key_slow_try_dec+0xf2/0x110
[  104.946795][ T6588] Modules linked in:
[  104.947111][ T6588] CPU: 0 PID: 6588 Comm: repro Not tainted 
6.4.0-rc2-00191-g4a3f9100193d #3
[  104.947765][ T6588] Hardware name: QEMU Standard PC (i440FX + PIIX, 
1996), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
[  104.948557][ T6588] RIP: 0010:static_key_slow_try_dec+0xf2/0x110
[  104.949064][ T6588] Code: d5 ff e8 c1 33 d5 ff 44 89 e8 5b 5d 41 5c 
41 5d c3 44 89 e5 e9 66 ff ff ff e8 aa 33 d5 ff 48 c7 c7 00 9c 56 8a e8 
4e ce 9c ff <0f> 0b eb ae 48 89 df e8 02 4b 28 00 e9 42 ff ff ff 66 66 
2e 0f 1f
[  104.951134][ T6588] RSP: 0018:ffffc900079cf2c0 EFLAGS: 00010286
[  104.951646][ T6588] RAX: 0000000000000000 RBX: ffffffff9213a160 RCX: 
0000000000000000
[  104.952269][ T6588] RDX: ffff888112f83b80 RSI: ffffffff814c7747 RDI: 
0000000000000001
[  104.952901][ T6588] RBP: 00000000ffffffff R08: 0000000000000001 R09: 
0000000000000000
[  104.953523][ T6588] R10: 0000000000000001 R11: 0000000000000001 R12: 
00000000ffffffff
[  104.954133][ T6588] R13: ffff88816a514001 R14: 0000000000000001 R15: 
ffffffff8e7b0680
[  104.954746][ T6588] FS:  00007f76c65d56c0(0000) 
GS:ffff8881f5a00000(0000) knlGS:0000000000000000
[  104.955430][ T6588] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  104.955941][ T6588] CR2: 00007f9a40357a50 CR3: 000000011461e000 CR4: 
0000000000350ef0
[  104.956559][ T6588] Call Trace:
[  104.956829][ T6588]  <TASK>
[  104.957062][ T6588]  ? clsact_egress_block_get+0x40/0x40
[  104.957507][ T6588]  static_key_slow_dec+0x60/0xc0
[  104.957906][ T6588]  qdisc_create+0xa45/0x1090
[  104.958274][ T6588]  ? tc_get_qdisc+0xb70/0xb70
[  104.958646][ T6588]  tc_modify_qdisc+0x491/0x1b70
[  104.959031][ T6588]  ? qdisc_create+0x1090/0x1090
[  104.959420][ T6588]  ? bpf_lsm_capable+0x9/0x10
[  104.959797][ T6588]  ? qdisc_create+0x1090/0x1090
[  104.960175][ T6588]  rtnetlink_rcv_msg+0x439/0xd30
[  104.960625][ T6588]  ? rtnl_getlink+0xb10/0xb10
[  104.960995][ T6588]  ? __x64_sys_sendmmsg+0x9c/0x100
[  104.961397][ T6588]  ? do_syscall_64+0x38/0xb0
[  104.961767][ T6588]  ? netdev_core_pick_tx+0x390/0x390
[  104.962195][ T6588]  netlink_rcv_skb+0x166/0x440
[  104.962584][ T6588]  ? rtnl_getlink+0xb10/0xb10
[  104.962954][ T6588]  ? netlink_ack+0x1370/0x1370
[  104.963336][ T6588]  ? kasan_set_track+0x25/0x30
[  104.963731][ T6588]  ? netlink_deliver_tap+0x1b1/0xd00
[  104.964156][ T6588]  netlink_unicast+0x530/0x800
[  104.964537][ T6588]  ? netlink_attachskb+0x880/0x880
[  104.964951][ T6588]  ? __sanitizer_cov_trace_switch+0x54/0x90
[  104.965405][ T6588]  ? __phys_addr_symbol+0x30/0x70
[  104.965793][ T6588]  ? __check_object_size+0x323/0x740
[  104.966205][ T6588]  netlink_sendmsg+0x90b/0xe10
[  104.966577][ T6588]  ? netlink_unicast+0x800/0x800
[  104.966965][ T6588]  ? bpf_lsm_socket_sendmsg+0x9/0x10
[  104.967374][ T6588]  ? netlink_unicast+0x800/0x800
[  104.967761][ T6588]  sock_sendmsg+0xd9/0x180
[  104.968109][ T6588]  ____sys_sendmsg+0x264/0x910
[  104.968490][ T6588]  ? kernel_sendmsg+0x50/0x50
[  104.968871][ T6588]  ? __copy_msghdr+0x460/0x460
[  104.969244][ T6588]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[  104.969716][ T6588]  ? find_held_lock+0x2d/0x110
[  104.970088][ T6588]  ___sys_sendmsg+0x11d/0x1b0
[  104.970491][ T6588]  ? do_recvmmsg+0x700/0x700
[  104.970853][ T6588]  ? __fget_files+0x260/0x420
[  104.971221][ T6588]  ? reacquire_held_locks+0x4b0/0x4b0
[  104.971649][ T6588]  ? __fget_files+0x282/0x420
[  104.972018][ T6588]  ? __fget_light+0xe6/0x270
[  104.972384][ T6588]  __sys_sendmmsg+0x18e/0x430
[  104.972766][ T6588]  ? __ia32_sys_sendmsg+0xb0/0xb0
[  104.973167][ T6588]  ? reacquire_held_locks+0x4b0/0x4b0
[  104.973588][ T6588]  ? rcu_is_watching+0x12/0xb0
[  104.973958][ T6588]  ? xfd_validate_state+0x5d/0x180
[  104.974355][ T6588]  ? restore_fpregs_from_fpstate+0xc1/0x1d0
[  104.974796][ T6588]  ? unlock_page_memcg+0x2d0/0x2d0
[  104.975178][ T6588]  ? do_futex+0x350/0x350
[  104.975501][ T6588]  __x64_sys_sendmmsg+0x9c/0x100
[  104.975867][ T6588]  ? syscall_enter_from_user_mode+0x26/0x80
[  104.976307][ T6588]  do_syscall_64+0x38/0xb0
[  104.976649][ T6588]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  104.977088][ T6588] RIP: 0033:0x7f76c66ee89d
[  104.977417][ T6588] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 
0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 
24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4b 05 0e 00 f7 d8 64 
89 01 48
[  104.978835][ T6588] RSP: 002b:00007f76c65d4c68 EFLAGS: 00000203 
ORIG_RAX: 0000000000000133
[  104.979468][ T6588] RAX: ffffffffffffffda RBX: 00007f76c65d5cdc RCX: 
00007f76c66ee89d
[  104.980073][ T6588] RDX: 040000000000009f RSI: 00000000200002c0 RDI: 
0000000000000007
[  104.980739][ T6588] RBP: 00007f76c65d4de0 R08: 0000000100000001 R09: 
0000000000000000
[  104.981352][ T6588] R10: 0000000000000000 R11: 0000000000000203 R12: 
fffffffffffffeb8
[  104.981968][ T6588] R13: 0000000000000002 R14: 00007ffce5a5fd90 R15: 
00007f76c65b5000
[  104.982587][ T6588]  </TASK>
[  104.982833][ T6588] Kernel panic - not syncing: kernel: panic_on_warn 
set ...
[  104.983391][ T6588] CPU: 0 PID: 6588 Comm: repro Not tainted 
6.4.0-rc2-00191-g4a3f9100193d #3
[  104.984054][ T6588] Hardware name: QEMU Standard PC (i440FX + PIIX, 
1996), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
[  104.984854][ T6588] Call Trace:
[  104.985121][ T6588]  <TASK>
[  104.985359][ T6588]  dump_stack_lvl+0xd9/0x1b0
[  104.985733][ T6588]  panic+0x689/0x730
[  104.986053][ T6588]  ? panic_smp_self_stop+0xa0/0xa0
[  104.986467][ T6588]  ? show_trace_log_lvl+0x28e/0x400
[  104.986888][ T6588]  ? static_key_slow_try_dec+0xf2/0x110
[  104.987329][ T6588]  check_panic_on_warn+0xab/0xb0
[  104.987729][ T6588]  __warn+0xf2/0x380
[  104.988046][ T6588]  ? static_key_slow_try_dec+0xf2/0x110
[  104.988476][ T6588]  report_bug+0x3bc/0x580
[  104.988838][ T6588]  handle_bug+0x3c/0x70
[  104.989169][ T6588]  exc_invalid_op+0x17/0x40
[  104.989529][ T6588]  asm_exc_invalid_op+0x1a/0x20
[  104.989914][ T6588] RIP: 0010:static_key_slow_try_dec+0xf2/0x110
[  104.990402][ T6588] Code: d5 ff e8 c1 33 d5 ff 44 89 e8 5b 5d 41 5c 
41 5d c3 44 89 e5 e9 66 ff ff ff e8 aa 33 d5 ff 48 c7 c7 00 9c 56 8a e8 
4e ce 9c ff <0f> 0b eb ae 48 89 df e8 02 4b 28 00 e9 42 ff ff ff 66 66 
2e 0f 1f
[  104.990702][ T6588] RSP: 0018:ffffc900079cf2c0 EFLAGS: 00010286
[  104.990702][ T6588] RAX: 0000000000000000 RBX: ffffffff9213a160 RCX: 
0000000000000000
[  104.990702][ T6588] RDX: ffff888112f83b80 RSI: ffffffff814c7747 RDI: 
0000000000000001
[  104.990702][ T6588] RBP: 00000000ffffffff R08: 0000000000000001 R09: 
0000000000000000
[  104.990702][ T6588] R10: 0000000000000001 R11: 0000000000000001 R12: 
00000000ffffffff
[  104.990702][ T6588] R13: ffff88816a514001 R14: 0000000000000001 R15: 
ffffffff8e7b0680
[  104.990702][ T6588]  ? __warn_printk+0x187/0x310
[  104.990702][ T6588]  ? clsact_egress_block_get+0x40/0x40
[  104.990702][ T6588]  static_key_slow_dec+0x60/0xc0
[  104.990702][ T6588]  qdisc_create+0xa45/0x1090
[  104.990702][ T6588]  ? tc_get_qdisc+0xb70/0xb70
[  104.990702][ T6588]  tc_modify_qdisc+0x491/0x1b70
[  104.990702][ T6588]  ? qdisc_create+0x1090/0x1090
[  104.990702][ T6588]  ? bpf_lsm_capable+0x9/0x10
[  104.990702][ T6588]  ? qdisc_create+0x1090/0x1090
[  104.990702][ T6588]  rtnetlink_rcv_msg+0x439/0xd30
[  104.990702][ T6588]  ? rtnl_getlink+0xb10/0xb10
[  104.990702][ T6588]  ? __x64_sys_sendmmsg+0x9c/0x100
[  104.990702][ T6588]  ? do_syscall_64+0x38/0xb0
[  104.990702][ T6588]  ? netdev_core_pick_tx+0x390/0x390
[  104.990702][ T6588]  netlink_rcv_skb+0x166/0x440
[  104.990702][ T6588]  ? rtnl_getlink+0xb10/0xb10
[  104.990702][ T6588]  ? netlink_ack+0x1370/0x1370
[  104.990702][ T6588]  ? kasan_set_track+0x25/0x30
[  104.990702][ T6588]  ? netlink_deliver_tap+0x1b1/0xd00
[  104.990702][ T6588]  netlink_unicast+0x530/0x800
[  104.990702][ T6588]  ? netlink_attachskb+0x880/0x880
[  104.990702][ T6588]  ? __sanitizer_cov_trace_switch+0x54/0x90
[  104.990702][ T6588]  ? __phys_addr_symbol+0x30/0x70
[  104.990702][ T6588]  ? __check_object_size+0x323/0x740
[  104.990702][ T6588]  netlink_sendmsg+0x90b/0xe10
[  104.990702][ T6588]  ? netlink_unicast+0x800/0x800
[  104.990702][ T6588]  ? bpf_lsm_socket_sendmsg+0x9/0x10
[  104.990702][ T6588]  ? netlink_unicast+0x800/0x800
[  104.990702][ T6588]  sock_sendmsg+0xd9/0x180
[  104.990702][ T6588]  ____sys_sendmsg+0x264/0x910
[  104.990702][ T6588]  ? kernel_sendmsg+0x50/0x50
[  104.990702][ T6588]  ? __copy_msghdr+0x460/0x460
[  104.990702][ T6588]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[  104.990702][ T6588]  ? find_held_lock+0x2d/0x110
[  104.990702][ T6588]  ___sys_sendmsg+0x11d/0x1b0
[  104.990702][ T6588]  ? do_recvmmsg+0x700/0x700
[  104.990702][ T6588]  ? __fget_files+0x260/0x420
[  104.990702][ T6588]  ? reacquire_held_locks+0x4b0/0x4b0
[  104.990702][ T6588]  ? __fget_files+0x282/0x420
[  104.990702][ T6588]  ? __fget_light+0xe6/0x270
[  104.990702][ T6588]  __sys_sendmmsg+0x18e/0x430
[  104.990702][ T6588]  ? __ia32_sys_sendmsg+0xb0/0xb0
[  104.990702][ T6588]  ? reacquire_held_locks+0x4b0/0x4b0
[  104.990702][ T6588]  ? rcu_is_watching+0x12/0xb0
[  104.990702][ T6588]  ? xfd_validate_state+0x5d/0x180
[  104.990702][ T6588]  ? restore_fpregs_from_fpstate+0xc1/0x1d0
[  104.990702][ T6588]  ? unlock_page_memcg+0x2d0/0x2d0
[  104.990702][ T6588]  ? do_futex+0x350/0x350
[  104.990702][ T6588]  __x64_sys_sendmmsg+0x9c/0x100
[  104.990702][ T6588]  ? syscall_enter_from_user_mode+0x26/0x80
[  104.990702][ T6588]  do_syscall_64+0x38/0xb0
[  104.990702][ T6588]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  104.990702][ T6588] RIP: 0033:0x7f76c66ee89d
[  104.990702][ T6588] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 
0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 
24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4b 05 0e 00 f7 d8 64 
89 01 48
[  104.990702][ T6588] RSP: 002b:00007f76c65d4c68 EFLAGS: 00000203 
ORIG_RAX: 0000000000000133
[  104.990702][ T6588] RAX: ffffffffffffffda RBX: 00007f76c65d5cdc RCX: 
00007f76c66ee89d
[  104.990702][ T6588] RDX: 040000000000009f RSI: 00000000200002c0 RDI: 
0000000000000007
[  104.990702][ T6588] RBP: 00007f76c65d4de0 R08: 0000000100000001 R09: 
0000000000000000
[  104.990702][ T6588] R10: 0000000000000000 R11: 0000000000000203 R12: 
fffffffffffffeb8
[  104.990702][ T6588] R13: 0000000000000002 R14: 00007ffce5a5fd90 R15: 
00007f76c65b5000
[  104.990702][ T6588]  </TASK>
[  104.990702][ T6588] Kernel Offset: disabled
[  104.990702][ T6588] Rebooting in 86400 seconds..



