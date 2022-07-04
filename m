Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC69565039
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbiGDJCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbiGDJCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:02:15 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1643DC52;
        Mon,  4 Jul 2022 02:02:14 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o8HxY-000C6f-0s; Mon, 04 Jul 2022 11:01:36 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o8HxX-00040z-JI; Mon, 04 Jul 2022 11:01:35 +0200
Subject: Re: [syzbot] kernel BUG in __text_poke
To:     syzbot <syzbot+87f65c75f4a72db05445@syzkaller.appspotmail.com>,
        alexei.starovoitov@gmail.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, jgross@suse.com,
        jpoimboe@kernel.org, jpoimboe@redhat.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, peterz@infradead.org, song@kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        x86@kernel.org, bpf@vger.kernel.org
References: <0000000000008c7b8f05e2e23f36@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bdcdf262-b8f2-127e-f0f7-7e70ad64d14b@iogearbox.net>
Date:   Mon, 4 Jul 2022 11:01:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0000000000008c7b8f05e2e23f36@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26593/Mon Jul  4 09:28:57 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/3/22 10:17 AM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:

Song, ptal, thanks.

> HEAD commit:    d28b25a62a47 selftests/net: fix section name when using xd..
> git tree:       bpf
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=11582697f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=833001d0819ddbc9
> dashboard link: https://syzkaller.appspot.com/bug?extid=87f65c75f4a72db05445
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14281c84080000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=102d6448080000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+87f65c75f4a72db05445@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> kernel BUG at arch/x86/kernel/alternative.c:1041!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 3688 Comm: syz-executor292 Not tainted 5.19.0-rc4-syzkaller-00118-gd28b25a62a47 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
> RIP: 0010:__text_poke+0x348/0x8e0 arch/x86/kernel/alternative.c:1041
> Code: c3 0f 86 2c fe ff ff 49 8d bc 24 00 10 00 00 e8 6e 6b 8d 00 48 89 44 24 30 48 85 db 74 0c 48 83 7c 24 30 00 0f 85 1b fe ff ff <0f> 0b 48 b8 00 f0 ff ff ff ff 0f 00 49 21 c0 48 85 db 0f 85 bf 02
> RSP: 0018:ffffc900032cf540 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff888018503b00 RSI: ffffffff81b97e83 RDI: 0000000000000005
> RBP: 0000000000000004 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: ffffffffa0000fc0
> R13: 0000000000000004 R14: 0000000000000fc4 R15: 0000000000002000
> FS:  0000555556bcb300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000002000cf3d CR3: 000000001d6a5000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   text_poke_copy+0x6d/0xa0 arch/x86/kernel/alternative.c:1186
>   bpf_arch_text_copy+0x21/0x40 arch/x86/net/bpf_jit_comp.c:2491
>   bpf_jit_binary_pack_alloc+0x8fd/0x990 kernel/bpf/core.c:1118
>   bpf_int_jit_compile+0x53a/0x13e0 arch/x86/net/bpf_jit_comp.c:2422
>   jit_subprogs kernel/bpf/verifier.c:13562 [inline]
>   fixup_call_args kernel/bpf/verifier.c:13693 [inline]
>   bpf_check+0x6e45/0xbbc0 kernel/bpf/verifier.c:15044
>   bpf_prog_load+0xfb2/0x2250 kernel/bpf/syscall.c:2575
>   __sys_bpf+0x11a1/0x5700 kernel/bpf/syscall.c:4917
>   __do_sys_bpf kernel/bpf/syscall.c:5021 [inline]
>   __se_sys_bpf kernel/bpf/syscall.c:5019 [inline]
>   __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5019
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7fe82c3681f9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe743b9ed8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fe82c3681f9
> RDX: 0000000000000070 RSI: 0000000020000440 RDI: 0000000000000005
> RBP: 00007ffe743b9ef0 R08: 0000000000000002 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
> R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__text_poke+0x348/0x8e0 arch/x86/kernel/alternative.c:1041
> Code: c3 0f 86 2c fe ff ff 49 8d bc 24 00 10 00 00 e8 6e 6b 8d 00 48 89 44 24 30 48 85 db 74 0c 48 83 7c 24 30 00 0f 85 1b fe ff ff <0f> 0b 48 b8 00 f0 ff ff ff ff 0f 00 49 21 c0 48 85 db 0f 85 bf 02
> RSP: 0018:ffffc900032cf540 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff888018503b00 RSI: ffffffff81b97e83 RDI: 0000000000000005
> RBP: 0000000000000004 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: ffffffffa0000fc0
> R13: 0000000000000004 R14: 0000000000000fc4 R15: 0000000000002000
> FS:  0000555556bcb300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000002000cf3d CR3: 000000001d6a5000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 

