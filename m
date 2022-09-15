Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B998C5B9F58
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 18:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiIOQCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 12:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIOQCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 12:02:35 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB8A50187;
        Thu, 15 Sep 2022 09:02:34 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id m65so19798746vsc.1;
        Thu, 15 Sep 2022 09:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=iCDYwc6O8Juptp1i6X4kSV9RCDsADjiuITndOMsqq4c=;
        b=FP2/fOTm2wcHY/6qebJKg3E6YJ7KmACBwd7dcSeoAz84XFDIKPXcF7/UJaP5VF00lK
         FY4npX410SuJF3VlxsUlmjZM0kHq6mHEt68dNMV3IGn7UeyweJcR5/y1jJEh/zc3RIjh
         mKCnkmWH9mUPzvWtd12ICr52MConXRL5uQ/fa1AnBQt1El3o+aqsy07YHHd0hwzD8i6i
         xWFgqSflk/9G2vdfLOQAFUaX+dBnw6c/sk+wrwrAT1sChgn+tOj7D1JImnbDoK4aCCwH
         u+6dHypTmaDXXlcxXEB3a3HR7CvqsQXTsZZWQalna7W2aEVuDCojiR45ebzAt9EBdwxx
         ORtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=iCDYwc6O8Juptp1i6X4kSV9RCDsADjiuITndOMsqq4c=;
        b=XnaCz3uW6XE4EYfr6UHtzbXxof6J3o7Kwa0bKvav3p8MJFTGxg/ibRH3NSDy0uAgPC
         OSHGGqI1fiR9KSTpvT0cBHPqF4x3WBcYASQtMeh3oYmNbF570TCy8++v4L2LXlGde53G
         2I6MfoU4+edHm+78mZ4avqJd9OcTqBkGT3gCWdrnncyjIwUPQKje8euH27u42xcHCOqS
         aNTMqfWh7uJlaOzAypJFB4MaTyrIuUVvKi9salbfxxsuhUZF1+tV/cTzdoAG7s4LTvdY
         knRW1V3wvNbTMQLm6DsQve2zzwHZItx0xdx3F2VTbx5qUoLZeD4QD0WBsghkCd5/4I03
         OCEw==
X-Gm-Message-State: ACrzQf1o1G2yvH2cfZO/8ZZCOhj5/sxyFJHCGLP4EzUHshCX1ix+URNj
        KxH7Z/SeT7YIrM87Q2HaPkUFUxFc4AIUIWaqZdc=
X-Google-Smtp-Source: AMsMyM5NLduxb0v1CmLfswn/NSgH5OWDulXZCuFTXjVEWZxGPS4mqVlJZ6xbuIIrQ8FAAodyD+IDlVBjbGOYg423j8I=
X-Received: by 2002:a67:be16:0:b0:398:c2e4:e01f with SMTP id
 x22-20020a67be16000000b00398c2e4e01fmr264904vsq.33.1663257753623; Thu, 15 Sep
 2022 09:02:33 -0700 (PDT)
MIME-Version: 1.0
From:   Rondreis <linhaoguo86@gmail.com>
Date:   Fri, 16 Sep 2022 00:02:22 +0800
Message-ID: <CAB7eexJUFDKsgE9g_2vp9ZM=A-JHwTMFBDqP2LC54WZ666pdZw@mail.gmail.com>
Subject: general protection fault in ethtool_get_drvinfo
To:     pabeni@redhat.com, huangguangbin2@huawei.com,
        john.fastabend@gmail.com, hawk@kernel.org, trix@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

Hello,

When fuzzing the Linux kernel driver v6.0-rc4, the following crash was
triggered.

HEAD commit: 7e18e42e4b280c85b76967a9106a13ca61c16179
git tree: upstream

kernel config: https://pastebin.com/raw/xtrgsXP3
C reproducer: https://pastebin.com/raw/RtX3naYU
console output: https://pastebin.com/raw/HqjSMu2n

Basically, in the c reproducer, we use the gadget module to emulate
attaching a USB device(vendor id: 0x1b3d, product id: 0x19c, with the
midi function) and executing some simple sequence of system calls.
To reproduce this crash, we utilize a third-party library to emulate
the attaching process: https://github.com/linux-usb-gadgets/libusbgx.
Just clone this repository, install it, and compile the c
reproducer with ``` gcc crash.c -lusbgx -lconfig -o crash ``` will do
the trick.

I would appreciate it if you have any idea how to solve this bug.

The crash report is as follows:
general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 6495 Comm: systemd-udevd Not tainted 6.0.0-rc4+ #20
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:ethtool_get_drvinfo+0x533/0x7d0 net/ethtool/ioctl.c:723
Code: 49 8d 7d 68 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 60 02 00 00
48 b8 00 00 00 00 00 fc ff df 4d 8b 6d 68 4c 89 ea 48 c1 ea 03 <80> 3c
02 00 0f 85 34 02 00 00 4d 8b 7d 00 4c 8d 73 0c 41 bd 1f 00
RSP: 0018:ffffc9000215f8c0 EFLAGS: 00010256
RAX: dffffc0000000000 RBX: ffff88804af0e000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff888013aa45a8 RDI: ffff8880152d0cf8
RBP: ffff8880225ba000 R08: ffffffff877f1966 R09: ffffed10095e1c0f
R10: ffff88804af0e073 R11: ffffed10095e1c0e R12: ffffffff8ad292a0
R13: 0000000000000000 R14: ffff8880225ba658 R15: ffff88804af0e06c
FS: 00007f60d186e6c0(0000) GS:ffff88807ec00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb0b563b000 CR3: 0000000046f26000 CR4: 0000000000350ee0
Call Trace:
<TASK>
__dev_ethtool net/ethtool/ioctl.c:2800 [inline]
dev_ethtool+0x18df/0x54f0 net/ethtool/ioctl.c:3038
dev_ioctl+0x510/0xe50 net/core/dev_ioctl.c:524
sock_do_ioctl+0x1c0/0x250 net/socket.c:1183
sock_ioctl+0x3b3/0x680 net/socket.c:1286
vfs_ioctl fs/ioctl.c:51 [inline]
__do_sys_ioctl fs/ioctl.c:870 [inline]
__se_sys_ioctl fs/ioctl.c:856 [inline]
__x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f60d152fcc7
Code: 00 00 00 48 8b 05 c9 91 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff
ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 8b 0d 99 91 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffc43cbe4d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00005634ecc852c0 RCX: 00007f60d152fcc7
RDX: 00007ffc43cbe5a0 RSI: 0000000000008946 RDI: 0000000000000006
RBP: 00007ffc43cbe5d0 R08: 00005634eccc7bc0 R09: 0000000000000000
R10: 00007f60d186e4c0 R11: 0000000000000246 R12: 00005634eccc7bc0
R13: 00005634ecccfb70 R14: 00007ffc43cbe5a0 R15: 0000000000000007
</TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ethtool_get_drvinfo+0x533/0x7d0 net/ethtool/ioctl.c:723
Code: 49 8d 7d 68 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 60 02 00 00
48 b8 00 00 00 00 00 fc ff df 4d 8b 6d 68 4c 89 ea 48 c1 ea 03 <80> 3c
02 00 0f 85 34 02 00 00 4d 8b 7d 00 4c 8d 73 0c 41 bd 1f 00
RSP: 0018:ffffc9000215f8c0 EFLAGS: 00010256
RAX: dffffc0000000000 RBX: ffff88804af0e000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff888013aa45a8 RDI: ffff8880152d0cf8
RBP: ffff8880225ba000 R08: ffffffff877f1966 R09: ffffed10095e1c0f
R10: ffff88804af0e073 R11: ffffed10095e1c0e R12: ffffffff8ad292a0
R13: 0000000000000000 R14: ffff8880225ba658 R15: ffff88804af0e06c
FS: 00007f60d186e6c0(0000) GS:ffff88807ec00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb0b5640000 CR3: 0000000046f26000 CR4: 0000000000350ee0
----------------
Code disassembly (best guess):
0: 49 8d 7d 68 lea 0x68(%r13),%rdi
4: 48 89 fa mov %rdi,%rdx
7: 48 c1 ea 03 shr $0x3,%rdx
b: 80 3c 02 00 cmpb $0x0,(%rdx,%rax,1)
f: 0f 85 60 02 00 00 jne 0x275
15: 48 b8 00 00 00 00 00 movabs $0xdffffc0000000000,%rax
1c: fc ff df
1f: 4d 8b 6d 68 mov 0x68(%r13),%r13
23: 4c 89 ea mov %r13,%rdx
26: 48 c1 ea 03 shr $0x3,%rdx
* 2a: 80 3c 02 00 cmpb $0x0,(%rdx,%rax,1) <-- trapping instruction
2e: 0f 85 34 02 00 00 jne 0x268
34: 4d 8b 7d 00 mov 0x0(%r13),%r15
38: 4c 8d 73 0c lea 0xc(%rbx),%r14
3c: 41 rex.B
3d: bd .byte 0xbd
3e: 1f (bad)
