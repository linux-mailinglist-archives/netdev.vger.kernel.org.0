Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C288D6C5B6A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 01:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCWAj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 20:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCWAj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 20:39:56 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA9CD520
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 17:39:54 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id r25-20020a056602235900b0074d472df653so10614796iot.2
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 17:39:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679531993;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8NiIyltKxDJdFrINjX75BJjnuGiPstgqlqzvrWa9wCg=;
        b=Fr5Hh5Srumf9MgQOoXsmGZyx3jYosMq4xAMYRVD+UhgqqEIFK+neyoQfPzwUH4ZfFM
         J75SmPBo1lbrxy159+m28tzfvMQTsdNS2QSvatZpxgYJh+5uaPjuCaDJO8pDFUtaZcEu
         kmCPXlfjzzwb/s97yph8OEM3WZPS10RqpMM+E105u/msGl48a4HH2cDO58x1DPOC2m2m
         h9FaRScaPyZuk+MjLYjdtfYtMwaD4JsxIAIHTZGZi+Pk15J9FB32qiPQwuh9rYrsgUsi
         YN5SBRMeakMISpiRk8obPQsPyCv0DQca1cQSb1uPJKdklRzNGUb9PWv8Q7LSTXn1P8//
         Va3w==
X-Gm-Message-State: AO0yUKUNxJFx5vW7CLFcGXDIdyCGPSDpRp19oAcudvRMLOpRrX3rPQXs
        hrkheorM/f7FD96fJKvQCTVNMxUjUM4u605EE/yryLtDCt1U
X-Google-Smtp-Source: AK7set/r2bjv2gut2DmPb/OiOdE6rFWol8dZ6yO9KmoyMdYpYo/Kw3qrwV0I1KCLokNOAifW2P8hAQsLKIegzDdh+VirQ3lR4qPA
MIME-Version: 1.0
X-Received: by 2002:a92:2612:0:b0:313:cc98:7eee with SMTP id
 n18-20020a922612000000b00313cc987eeemr3738082ile.1.1679531993740; Wed, 22 Mar
 2023 17:39:53 -0700 (PDT)
Date:   Wed, 22 Mar 2023 17:39:53 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e03bc805f78683cd@google.com>
Subject: [syzbot] [sctp?] general protection fault in sctp_outq_tail
From:   syzbot <syzbot+47c24ca20a2fa01f082e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        lucien.xin@gmail.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    cdd28833100c net: microchip: sparx5: fix deletion of exist..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1588fe92c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cab35c936731a347
dashboard link: https://syzkaller.appspot.com/bug?extid=47c24ca20a2fa01f082e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d80ff4c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f6e90ac80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2fb6257d1131/disk-cdd28833.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a3025d79117c/vmlinux-cdd28833.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8e6d670a5fed/bzImage-cdd28833.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+47c24ca20a2fa01f082e@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000007: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000038-0x000000000000003f]
CPU: 1 PID: 5783 Comm: syz-executor825 Not tainted 6.2.0-syzkaller-12889-gcdd28833100c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
RIP: 0010:list_add_tail include/linux/list.h:102 [inline]
RIP: 0010:sctp_outq_tail_data net/sctp/outqueue.c:91 [inline]
RIP: 0010:sctp_outq_tail+0x4ab/0xbf0 net/sctp/outqueue.c:299
Code: 8b 48 08 4c 8d 6b 18 48 8d 41 30 48 89 44 24 08 48 8d 41 38 48 89 c2 48 89 44 24 20 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 0a 06 00 00 4c 8b 79 38 4c 89 ef 48 89 4c 24 28
RSP: 0018:ffffc90005257568 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888072779140 RCX: 0000000000000000
RDX: 0000000000000007 RSI: ffffffff841d7ef0 RDI: ffff888071fbb0c8
RBP: ffff8880787a47e0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 1ffff92000a4aeb3
R13: ffff888072779158 R14: ffff8880787c0000 R15: ffff888071ad7c80
FS:  00007f5801104700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f58011b0740 CR3: 000000002a37e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 sctp_cmd_send_msg net/sctp/sm_sideeffect.c:1114 [inline]
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1777 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1199 [inline]
 sctp_do_sm+0x197d/0x5310 net/sctp/sm_sideeffect.c:1170
 sctp_primitive_SEND+0x9f/0xc0 net/sctp/primitive.c:163
 sctp_sendmsg_to_asoc+0x10eb/0x1a30 net/sctp/socket.c:1868
 sctp_sendmsg+0x8d4/0x1d90 net/sctp/socket.c:2026
 inet_sendmsg+0x9d/0xe0 net/ipv4/af_inet.c:825
 sock_sendmsg_nosec net/socket.c:722 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:745
 __sys_sendto+0x23a/0x340 net/socket.c:2145
 __do_sys_sendto net/socket.c:2157 [inline]
 __se_sys_sendto net/socket.c:2153 [inline]
 __x64_sys_sendto+0xe1/0x1b0 net/socket.c:2153
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f5801177ce9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f58011042f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f58012004b8 RCX: 00007f5801177ce9
RDX: 0000000000034000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00007f58012004b0 R08: 00000000200005c0 R09: 000000000000001c
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f58012004bc
R13: 00007f58011cd600 R14: 0100000000000000 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:list_add_tail include/linux/list.h:102 [inline]
RIP: 0010:sctp_outq_tail_data net/sctp/outqueue.c:91 [inline]
RIP: 0010:sctp_outq_tail+0x4ab/0xbf0 net/sctp/outqueue.c:299
Code: 8b 48 08 4c 8d 6b 18 48 8d 41 30 48 89 44 24 08 48 8d 41 38 48 89 c2 48 89 44 24 20 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 0a 06 00 00 4c 8b 79 38 4c 89 ef 48 89 4c 24 28
RSP: 0018:ffffc90005257568 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888072779140 RCX: 0000000000000000
RDX: 0000000000000007 RSI: ffffffff841d7ef0 RDI: ffff888071fbb0c8
RBP: ffff8880787a47e0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 1ffff92000a4aeb3
R13: ffff888072779158 R14: ffff8880787c0000 R15: ffff888071ad7c80
FS:  00007f5801104700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd458c9960 CR3: 000000002a37e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	8b 48 08             	mov    0x8(%rax),%ecx
   3:	4c 8d 6b 18          	lea    0x18(%rbx),%r13
   7:	48 8d 41 30          	lea    0x30(%rcx),%rax
   b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  10:	48 8d 41 38          	lea    0x38(%rcx),%rax
  14:	48 89 c2             	mov    %rax,%rdx
  17:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  1c:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  23:	fc ff df
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 0a 06 00 00    	jne    0x63e
  34:	4c 8b 79 38          	mov    0x38(%rcx),%r15
  38:	4c 89 ef             	mov    %r13,%rdi
  3b:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
