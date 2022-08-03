Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E8A588BD3
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 14:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237793AbiHCMNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 08:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbiHCMNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 08:13:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3DCA227CC7
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 05:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659528795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pac0fLKUr+LLeDtwdQkuut5jEFDOTwai1Q05E+YZAsc=;
        b=QmphaJLb92Z9lZASKdozCbL3pNIM+xXTjPNlHCgwCo6uiBU9BI92jj335eh0OlcGsw43HT
        IiV2CLWxin6zANYa+ylEaGPAn/ACaOLTejdEofMZu/nVY8BJXwtMI3TdLT4vEZhxznF/VI
        B1nii/nDa7CILpONFbaTr/To+hzYwcU=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-j_e6vjF_NoWjj2Hd_m5lOA-1; Wed, 03 Aug 2022 08:13:14 -0400
X-MC-Unique: j_e6vjF_NoWjj2Hd_m5lOA-1
Received: by mail-lj1-f199.google.com with SMTP id j15-20020a2e850f000000b0025e6da69e18so351753lji.18
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 05:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pac0fLKUr+LLeDtwdQkuut5jEFDOTwai1Q05E+YZAsc=;
        b=3ZJMUqdNRydooG+BuqJbjBYMIf0/aubgpBFGWdLrM7Ji6XUmuLSkEchyWPzjksNbrr
         lJohkz+XmfDLjvkrjZJ8EWGudR1KfVgiiHY5yHpjaIKAA7vopFvnMxmUCeopWqcHEvp8
         Idteyo/2DFdH/8V1nlU/Q+1AS1jYpm4mcIWWYjHBMd3fFpFJij3mpXU9UGlDfH2ewTdB
         IhzFuftwYV+4TT9rDGQJv3fJm3O4Y+Nl7Q6QEd4iRJFFH+30JZVFvYHC+fq8KYHB1klJ
         Pv0MuLMFxdZ7iKkBlTSKEv/UYsxma7qfsni53V5lD9CUbfdgSrJJyWivWej2u1K8Vcod
         F2bg==
X-Gm-Message-State: AJIora/q2lT3jFJFk2AewhOUGImGOojF30i9z15aAopBx402YJqcR+5u
        3I/vt2iurGCmBU1MTi8xTsBVrEVF3Qydy8XFHQ9AZQhHCeUfoJlHLbUmxWIdMnbnyJvj94GG1Fp
        RRbVkJMHE4xlo8eOIA5Cw3f6TceMm/xSq
X-Received: by 2002:a05:6512:218c:b0:48a:1e1e:7b59 with SMTP id b12-20020a056512218c00b0048a1e1e7b59mr8636652lft.580.1659528791980;
        Wed, 03 Aug 2022 05:13:11 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5eqLfz51F4vI6hlrko03HSNDnzXK8f0DAxH23CXvm2bAXjm5q5cq5DE8ixYK8xiR7Qkv8/dMoNc3F50YqiLRE=
X-Received: by 2002:a05:6512:218c:b0:48a:1e1e:7b59 with SMTP id
 b12-20020a056512218c00b0048a1e1e7b59mr8636635lft.580.1659528791531; Wed, 03
 Aug 2022 05:13:11 -0700 (PDT)
MIME-Version: 1.0
References: <CA+QYu4qxW1BUcbC9MwG1BxXjPO96sa9BOUXOHCj1SLY7ObJnQw@mail.gmail.com>
 <20220802122356.6f163a79@kernel.org>
In-Reply-To: <20220802122356.6f163a79@kernel.org>
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Wed, 3 Aug 2022 14:13:00 +0200
Message-ID: <CA+QYu4ob4cbh3Vnh9DWgaPpyw8nTLFG__TbBpBsYg1tWJPxygg@mail.gmail.com>
Subject: Re: RIP: 0010:qede_load+0x128d/0x13b0 [qede] - 5.19.0
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Aug 2022 at 21:24, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 2 Aug 2022 13:27:32 +0200 Bruno Goncalves wrote:
> > Hello,
> >
> > We've noticed the following panic when booting up kernel 5.19.0 on a
> > specific machine.
> > The panic seems to happen when we build the kernel with debug flags.
> > Below is the first crash we noticed, more logs at [1] and the kernel
> > config is at [2].
> >
> > [   59.207684] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> > [   59.212949] CPU: 32 PID: 1967 Comm: NetworkManager Not tainted 5.19.0-rc3 #1
> > [   59.220041] Hardware name: HPE ProLiant DL325 Gen10 Plus/ProLiant
> > DL325 Gen10 Plus, BIOS A43 08/09/2021
> > [   59.229490] RIP: 0010:qede_load.cold+0x5a1/0x819 [qede]
>
> Is it this warning?
>
>    WARN_ON(xdp_rxq_info_reg(&fp->rxq->xdp_rxq, edev->ndev,
>
> Would you be able to run the stacktrace thru
> scripts/decode_stacktrace.sh ?

Got this from the most recent failure (kernel built using commit 0805c6fb39f6):

the tarball is https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/603714145/build%20x86_64%20debug/2807738987/artifacts/kernel-mainline.kernel.org-redhat_603714145_x86_64_debug.tar.gz
and the call trace from
https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/08/02/redhat:603123526/build_x86_64_redhat:603123526_x86_64_debug/tests/1/results_0001/console.log/console.log

[   69.876513] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[   69.888521] Hardware name: HPE ProLiant DL325 Gen10 Plus/ProLiant
DL325 Gen10 Plus, BIOS A43 08/09/2021
[   69.897971] RIP: 0010:qede_load.cold
(/builds/2807738987/workdir/./include/linux/spinlock.h:389
/builds/2807738987/workdir/./include/linux/netdevice.h:4294
/builds/2807738987/workdir/./include/linux/netdevice.h:4385
/builds/2807738987/workdir/drivers/net/ethernet/qlogic/qede/qede_main.c:2594
/builds/2807738987/workdir/drivers/net/ethernet/qlogic/qede/qede_main.c:2575)
qede
[ 69.903242] Code: 41 88 84 24 b1 00 00 00 41 0f b7 84 24 b6 00 00 00
45 88 b4 24 b3 00 00 00 e9 12 ff fe ff 48 c7 c1 09 c6 d7 c0 e9 6f ff
ff ff <0f> 0b 49 8b 7c 24 08 e8 8c e0 fe ff 48 89 c1 48 85 c0 74 32 ba
2a
All code
========
   0:    41 88 84 24 b1 00 00     mov    %al,0xb1(%r12)
   7:    00
   8:    41 0f b7 84 24 b6 00     movzwl 0xb6(%r12),%eax
   f:    00 00
  11:    45 88 b4 24 b3 00 00     mov    %r14b,0xb3(%r12)
  18:    00
  19:    e9 12 ff fe ff           jmpq   0xfffffffffffeff30
  1e:    48 c7 c1 09 c6 d7 c0     mov    $0xffffffffc0d7c609,%rcx
  25:    e9 6f ff ff ff           jmpq   0xffffffffffffff99
  2a:*    0f 0b                    ud2            <-- trapping instruction
  2c:    49 8b 7c 24 08           mov    0x8(%r12),%rdi
  31:    e8 8c e0 fe ff           callq  0xfffffffffffee0c2
  36:    48 89 c1                 mov    %rax,%rcx
  39:    48 85 c0                 test   %rax,%rax
  3c:    74 32                    je     0x70
  3e:    ba                       .byte 0xba
  3f:    2a                       .byte 0x2a

Code starting with the faulting instruction
===========================================
   0:    0f 0b                    ud2
   2:    49 8b 7c 24 08           mov    0x8(%r12),%rdi
   7:    e8 8c e0 fe ff           callq  0xfffffffffffee098
   c:    48 89 c1                 mov    %rax,%rcx
   f:    48 85 c0                 test   %rax,%rax
  12:    74 32                    je     0x46
  14:    ba                       .byte 0xba
  15:    2a                       .byte 0x2a
[   69.922125] RSP: 0018:ffffac3c848a3658 EFLAGS: 00010206
[   69.927385] RAX: 000000000000006b RBX: 0000000000000000 RCX: 0000000000000006
[   69.934562] RDX: ffff94a3f3eabba8 RSI: ffffffff9e9578a7 RDI: ffffffff9e8d8176
[   69.941738] RBP: ffff94a3ee75acd0 R08: 0000000000000001 R09: 0000000000000001
[   69.948914] R10: 0000000000000000 R11: 00000000f6665eaf R12: ffff94a3ee75ac00
[   69.956089] R13: ffff94a3f31bb928 R14: ffffac3ca31dd000 R15: 0000000000000000
[   69.963265] FS:  00007f623da2c500(0000) GS:ffff94b2bc240000(0000)
knlGS:0000000000000000
[   69.971405] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   69.977183] CR2: 000056491c907688 CR3: 000000015ebe2000 CR4: 0000000000350ee0
[   69.984361] Call Trace:
[   69.986820]  <TASK>
[   69.988950] qede_open
(/builds/2807738987/workdir/drivers/net/ethernet/qlogic/qede/qede_main.c:2552)
qede
[   69.992817] __dev_open (/builds/2807738987/workdir/net/core/dev.c:1434)
[   69.996247] __dev_change_flags
(/builds/2807738987/workdir/net/core/dev.c:8537)
[   70.000459] dev_change_flags (/builds/2807738987/workdir/net/core/dev.c:8608)
[   70.004318] do_setlink (/builds/2807738987/workdir/net/core/rtnetlink.c:2780)
[   70.007916] ? lock_is_held_type
(/builds/2807738987/workdir/kernel/locking/lockdep.c:466
/builds/2807738987/workdir/kernel/locking/lockdep.c:5710)
[   70.012131] ? lock_is_held_type
(/builds/2807738987/workdir/kernel/locking/lockdep.c:466
/builds/2807738987/workdir/kernel/locking/lockdep.c:5710)
[   70.016342] ? __nla_validate_parse
(/builds/2807738987/workdir/./include/net/netlink.h:1159
(discriminator 2) /builds/2807738987/workdir/lib/nlattr.c:576
(discriminator 2))
[   70.020816] ? mark_held_locks
(/builds/2807738987/workdir/kernel/locking/lockdep.c:4234)
[   70.024767] ? _raw_spin_unlock_irqrestore
(/builds/2807738987/workdir/./arch/x86/include/asm/paravirt.h:704
/builds/2807738987/workdir/./arch/x86/include/asm/irqflags.h:138
/builds/2807738987/workdir/./include/linux/spinlock_api_smp.h:151
/builds/2807738987/workdir/kernel/locking/spinlock.c:194)
[   70.029763] ? lockdep_hardirqs_on
(/builds/2807738987/workdir/kernel/locking/lockdep.c:4383)
[   70.034152] __rtnl_newlink
(/builds/2807738987/workdir/net/core/rtnetlink.c:3546)
[   70.038020] ? rtnl_newlink
(/builds/2807738987/workdir/net/core/rtnetlink.c:3590)
[   70.041702] ? rcu_read_lock_sched_held
(/builds/2807738987/workdir/kernel/rcu/update.c:125
/builds/2807738987/workdir/kernel/rcu/update.c:119)
[   70.046437] ? trace_kmalloc
(/builds/2807738987/workdir/./include/trace/events/kmem.h:52
/builds/2807738987/workdir/./include/trace/events/kmem.h:52)
[   70.050297] ? kmem_cache_alloc_trace
(/builds/2807738987/workdir/mm/slub.c:3286)
[   70.055035] rtnl_newlink
(/builds/2807738987/workdir/net/core/rtnetlink.c:3594)
[   70.058544] rtnetlink_rcv_msg
(/builds/2807738987/workdir/net/core/rtnetlink.c:6089)
[   70.062667] ? lock_acquire
(/builds/2807738987/workdir/kernel/locking/lockdep.c:466
/builds/2807738987/workdir/kernel/locking/lockdep.c:5668
/builds/2807738987/workdir/kernel/locking/lockdep.c:5631)
[   70.066442] ? rtnl_stats_set
(/builds/2807738987/workdir/net/core/rtnetlink.c:5986)
[   70.070478] netlink_rcv_skb
(/builds/2807738987/workdir/net/netlink/af_netlink.c:2501)
[   70.074345] netlink_unicast
(/builds/2807738987/workdir/net/netlink/af_netlink.c:1320
/builds/2807738987/workdir/net/netlink/af_netlink.c:1345)
[   70.078295] netlink_sendmsg
(/builds/2807738987/workdir/net/netlink/af_netlink.c:1921)
[   70.082249] sock_sendmsg
(/builds/2807738987/workdir/net/socket.c:714
/builds/2807738987/workdir/net/socket.c:734)
[   70.085760] ____sys_sendmsg (/builds/2807738987/workdir/net/socket.c:2488)
[   70.089705] ? import_iovec (/builds/2807738987/workdir/lib/iov_iter.c:2001)
[   70.093389] ? sendmsg_copy_msghdr
(/builds/2807738987/workdir/net/socket.c:2429
/builds/2807738987/workdir/net/socket.c:2519)
[   70.097689] ___sys_sendmsg (/builds/2807738987/workdir/net/socket.c:2544)
[   70.101378] ? lock_is_held_type
(/builds/2807738987/workdir/kernel/locking/lockdep.c:466
/builds/2807738987/workdir/kernel/locking/lockdep.c:5710)
[   70.105588] ? find_held_lock
(/builds/2807738987/workdir/kernel/locking/lockdep.c:5156)
[   70.109451] ? lock_release
(/builds/2807738987/workdir/kernel/locking/lockdep.c:466
/builds/2807738987/workdir/kernel/locking/lockdep.c:5688)
[   70.113313] ? __fget_files (/builds/2807738987/workdir/fs/file.c:917)
[   70.117089] __sys_sendmsg (/builds/2807738987/workdir/net/socket.c:2571)
[   70.120692] do_syscall_64
(/builds/2807738987/workdir/arch/x86/entry/common.c:50
/builds/2807738987/workdir/arch/x86/entry/common.c:80)
[   70.124294] entry_SYSCALL_64_after_hwframe
(/builds/2807206727/workdir/arch/x86/entry/entry_64.S:120)
[   70.129378] RIP: 0033:0x7f623e42e71d
[ 70.132988] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 2a 9b
f7 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00
0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 7e 9b f7 ff
48
All code
========
   0:    28 89 54 24 1c 48        sub    %cl,0x481c2454(%rcx)
   6:    89 74 24 10              mov    %esi,0x10(%rsp)
   a:    89 7c 24 08              mov    %edi,0x8(%rsp)
   e:    e8 2a 9b f7 ff           callq  0xfffffffffff79b3d
  13:    8b 54 24 1c              mov    0x1c(%rsp),%edx
  17:    48 8b 74 24 10           mov    0x10(%rsp),%rsi
  1c:    41 89 c0                 mov    %eax,%r8d
  1f:    8b 7c 24 08              mov    0x8(%rsp),%edi
  23:    b8 2e 00 00 00           mov    $0x2e,%eax
  28:    0f 05                    syscall
  2a:*    48 3d 00 f0 ff ff        cmp    $0xfffffffffffff000,%rax
   <-- trapping instruction
  30:    77 33                    ja     0x65
  32:    44 89 c7                 mov    %r8d,%edi
  35:    48 89 44 24 08           mov    %rax,0x8(%rsp)
  3a:    e8 7e 9b f7 ff           callq  0xfffffffffff79bbd
  3f:    48                       rex.W

Code starting with the faulting instruction
===========================================
   0:    48 3d 00 f0 ff ff        cmp    $0xfffffffffffff000,%rax
   6:    77 33                    ja     0x3b
   8:    44 89 c7                 mov    %r8d,%edi
   b:    48 89 44 24 08           mov    %rax,0x8(%rsp)
  10:    e8 7e 9b f7 ff           callq  0xfffffffffff79b93
  15:    48                       rex.W
[   70.151871] RSP: 002b:00007fff0ccddd70 EFLAGS: 00000293 ORIG_RAX:
000000000000002e
[   70.159488] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f623e42e71d
[   70.166665] RDX: 0000000000000000 RSI: 00007fff0ccdddb0 RDI: 000000000000000d
[   70.173842] RBP: 0000564bf49cb090 R08: 0000000000000000 R09: 0000000000000000
[   70.181017] R10: 0000000000000000 R11: 0000000000000293 R12: 000000000000000b
[   70.188192] R13: 00007fff0ccddf20 R14: 00007fff0ccddf1c R15: 0000000000000000
[   70.195379]  </TASK>
[   70.197575] Modules linked in: acpi_cpufreq(-) rfkill sunrpc qede
vfat fat intel_rapl_msr intel_rapl_common qed ipmi_ssif crc8
edac_mce_amd k10temp pcspkr rapl ptdma acpi_ipmi ses igb hpilo
enclosure ipmi_si ipmi_devintf dca i2c_piix4 ipmi_msghandler acpi_tad
acpi_power_meter fuse zram xfs mgag200 crct10dif_pclmul i2c_algo_bit
crc32_pclmul drm_shmem_helper crc32c_intel drm_kms_helper
ghash_clmulni_intel drm hpwdt ccp smartpqi scsi_transport_sas
sp5100_tco wmi
[   70.238596] ---[ end trace 0000000000000000 ]---
[   70.310657] RIP: 0010:qede_load.cold
(/builds/2807738987/workdir/./include/linux/spinlock.h:389
/builds/2807738987/workdir/./include/linux/netdevice.h:4294
/builds/2807738987/workdir/./include/linux/netdevice.h:4385
/builds/2807738987/workdir/drivers/net/ethernet/qlogic/qede/qede_main.c:2594
/builds/2807738987/workdir/drivers/net/ethernet/qlogic/qede/qede_main.c:2575)
qede
[ 70.316130] Code: 41 88 84 24 b1 00 00 00 41 0f b7 84 24 b6 00 00 00
45 88 b4 24 b3 00 00 00 e9 12 ff fe ff 48 c7 c1 09 c6 d7 c0 e9 6f ff
ff ff <0f> 0b 49 8b 7c 24 08 e8 8c e0 fe ff 48 89 c1 48 85 c0 74 32 ba
2a
All code
========
   0:    41 88 84 24 b1 00 00     mov    %al,0xb1(%r12)
   7:    00
   8:    41 0f b7 84 24 b6 00     movzwl 0xb6(%r12),%eax
   f:    00 00
  11:    45 88 b4 24 b3 00 00     mov    %r14b,0xb3(%r12)
  18:    00
  19:    e9 12 ff fe ff           jmpq   0xfffffffffffeff30
  1e:    48 c7 c1 09 c6 d7 c0     mov    $0xffffffffc0d7c609,%rcx
  25:    e9 6f ff ff ff           jmpq   0xffffffffffffff99
  2a:*    0f 0b                    ud2            <-- trapping instruction
  2c:    49 8b 7c 24 08           mov    0x8(%r12),%rdi
  31:    e8 8c e0 fe ff           callq  0xfffffffffffee0c2
  36:    48 89 c1                 mov    %rax,%rcx
  39:    48 85 c0                 test   %rax,%rax
  3c:    74 32                    je     0x70
  3e:    ba                       .byte 0xba
  3f:    2a                       .byte 0x2a

Code starting with the faulting instruction
===========================================
   0:    0f 0b                    ud2
   2:    49 8b 7c 24 08           mov    0x8(%r12),%rdi
   7:    e8 8c e0 fe ff           callq  0xfffffffffffee098
   c:    48 89 c1                 mov    %rax,%rcx
   f:    48 85 c0                 test   %rax,%rax
  12:    74 32                    je     0x46
  14:    ba                       .byte 0xba
  15:    2a                       .byte 0x2a
[   70.335057] RSP: 0018:ffffac3c848a3658 EFLAGS: 00010206
[   70.340332] RAX: 000000000000006b RBX: 0000000000000000 RCX: 0000000000000006
[   70.347554] RDX: ffff94a3f3eabba8 RSI: ffffffff9e9578a7 RDI: ffffffff9e8d8176
[   70.354747] RBP: ffff94a3ee75acd0 R08: 0000000000000001 R09: 0000000000000001
[   70.361968] R10: 0000000000000000 R11: 00000000f6665eaf R12: ffff94a3ee75ac00
[   70.369160] R13: ffff94a3f31bb928 R14: ffffac3ca31dd000 R15: 0000000000000000
[   70.376385] FS:  00007f623da2c500(0000) GS:ffff94b2bc240000(0000)
knlGS:0000000000000000
[   70.384543] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   70.390336] CR2: 000056491c907688 CR3: 000000015ebe2000 CR4: 0000000000350ee0
[   70.397531] Kernel panic - not syncing: Fatal exception
[   70.406430] Kernel Offset: 0x1c000000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   70.484036] ---[ end Kernel panic - not syncing: Fatal exception ]---

Thanks,
Bruno
>
> > [   59.234757] Code: 41 88 84 24 b1 00 00 00 41 0f b7 84 24 b6 00 00
> > 00 45 88 b4 24 b3 00 00 00 e9 b8 00 ff ff 48 c7 c1 09 66 46 c1 e9 6f
> > ff ff ff <0f> 0b 49 8b 7c 24 08 e8 82 e2 fe ff 48 89 c1 48 85 c0 74 32
> > ba 2a
> > [   59.253639] RSP: 0018:ffffae1e04593688 EFLAGS: 00010206
> > [   59.258897] RAX: 000000000000006b RBX: 0000000000000000 RCX: 0000000000000006
> > [   59.266073] RDX: ffff8f8f35332be8 RSI: ffffffffaf96411f RDI: ffffffffaf8e4b1e
> > [   59.273250] RBP: ffff8f8f2a87acd0 R08: 0000000000000001 R09: 0000000000000001
> > [   59.280426] R10: 0000000000000000 R11: 000000000f8c087f R12: ffff8f8f2a87ac00
> > [   59.287602] R13: ffff8f8f34d7f928 R14: ffffae1e0c039000 R15: 0000000000000000
> > [   59.294777] FS:  00007f164509f500(0000) GS:ffff8f9dfd800000(0000)
> > knlGS:0000000000000000
> > [   59.302917] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   59.308697] CR2: 00005575f29a5c08 CR3: 0000000163810000 CR4: 0000000000350ee0
> > [   59.315875] Call Trace:
> > [   59.318335]  <TASK>
> > [   59.320458]  qede_open+0x3b/0x90 [qede]
> > [   59.324323]  __dev_open+0xf1/0x1c0
> > [   59.327748]  __dev_change_flags+0x1f8/0x280
> > [   59.331957]  dev_change_flags+0x22/0x60
> > [   59.335816]  do_setlink+0x327/0x1140
> > [   59.339413]  ? lock_is_held_type+0xe3/0x140
> > [   59.343625]  ? lock_is_held_type+0xe3/0x140
> > [   59.347833]  ? __nla_validate_parse+0x5f/0xb70
> > [   59.352307]  ? mark_held_locks+0x49/0x70
> > [   59.356256]  ? _raw_spin_unlock_irqrestore+0x30/0x60
> > [   59.361254]  ? lockdep_hardirqs_on+0x7d/0x100
> > [   59.365640]  __rtnl_newlink+0x59c/0x950
> > [   59.369502]  ? rtnl_newlink+0x2a/0x60
> > [   59.373185]  ? rcu_read_lock_sched_held+0x3c/0x70
> > [   59.377918]  ? trace_kmalloc+0x30/0xf0
> > [   59.381692]  ? kmem_cache_alloc_trace+0x1ad/0x270
> > [   59.386426]  rtnl_newlink+0x43/0x60
> > [   59.389936]  rtnetlink_rcv_msg+0x184/0x540
> > [   59.394057]  ? lock_acquire+0xe2/0x2e0
> > [   59.397830]  ? rtnl_stats_set+0x190/0x190
> > [   59.401863]  netlink_rcv_skb+0x51/0xf0
> > [   59.405639]  netlink_unicast+0x189/0x260
> > [   59.409586]  netlink_sendmsg+0x25a/0x4c0
> > [   59.413536]  sock_sendmsg+0x5c/0x60
> > [   59.417045]  ____sys_sendmsg+0x22b/0x270
> > [   59.420991]  ? import_iovec+0x17/0x20
> > [   59.424675]  ? sendmsg_copy_msghdr+0x78/0xa0
> > [   59.428972]  ___sys_sendmsg+0x85/0xc0
> > [   59.432658]  ? lock_is_held_type+0xe3/0x140
> > [   59.436867]  ? find_held_lock+0x2b/0x80
> > [   59.440727]  ? lock_release+0x145/0x300
> > [   59.444586]  ? __fget_files+0xe5/0x170
> > [   59.448360]  __sys_sendmsg+0x5c/0xb0
> > [   59.451961]  do_syscall_64+0x5b/0x80
> > [   59.455558]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > [   59.460641] RIP: 0033:0x7f164628539d
> > [   59.464251] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 0a
> > b1 f7 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00
> > 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 5e b1 f7
> > ff 48
> > [   59.483133] RSP: 002b:00007ffd9bf01520 EFLAGS: 00000293 ORIG_RAX:
> > 000000000000002e
> > [   59.490749] RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007f164628539d
> > [   59.497925] RDX: 0000000000000000 RSI: 00007ffd9bf01560 RDI: 000000000000000c
> > [   59.505100] RBP: 00005575f2915040 R08: 0000000000000000 R09: 0000000000000000
> > [   59.512275] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
> > [   59.519453] R13: 00007ffd9bf016c0 R14: 00007ffd9bf016bc R15: 0000000000000000
> > [   59.526637]  </TASK>
> > [   59.528834] Modules linked in: rfkill sunrpc intel_rapl_msr
> > intel_rapl_common vfat fat qede qed edac_mce_amd i2c_piix4 crc8 rapl
> > igb ipmi_ssif ptdma ses enclosure pcspkr dca hpilo k10temp acpi_ipmi
> > acpi_tad ipmi_si acpi_power_meter fuse zram xfs crct10dif_pclmul
> > crc32_pclmul crc32c_intel mgag200 i2c_algo_bit drm_shmem_helper
> > drm_kms_helper ghash_clmulni_intel drm hpwdt smartpqi ccp
> > scsi_transport_sas sp5100_tco wmi ipmi_devintf ipmi_msghandler
> > [   59.568459] ---[ end trace 0000000000000000 ]---
> > [   59.632952] RIP: 0010:qede_load.cold+0x5a1/0x819 [qede]
> > [   59.632967] Code: 41 88 84 24 b1 00 00 00 41 0f b7 84 24 b6 00 00
> > 00 45 88 b4 24 b3 00 00 00 e9 b8 00 ff ff 48 c7 c1 09 66 46 c1 e9 6f
> > ff ff ff <0f> 0b 49 8b 7c 24 08 e8 82 e2 fe ff 48 89 c1 48 85 c0 74 32
> > ba 2a
> > [   59.632970] RSP: 0018:ffffae1e04593688 EFLAGS: 00010206
> > [   59.632972] RAX: 000000000000006b RBX: 0000000000000000 RCX: 0000000000000006
> > [   59.632974] RDX: ffff8f8f35332be8 RSI: ffffffffaf96411f RDI: ffffffffaf8e4b1e
> > [   59.632977] RBP: ffff8f8f2a87acd0 R08: 0000000000000001 R09: 0000000000000001
> > [   59.632978] R10: 0000000000000000 R11: 000000000f8c087f R12: ffff8f8f2a87ac00
> > [   59.632980] R13: ffff8f8f34d7f928 R14: ffffae1e0c039000 R15: 0000000000000000
> > [   59.632982] FS:  00007f164509f500(0000) GS:ffff8f9dfd800000(0000)
> > knlGS:0000000000000000
> > [   59.632984] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   59.632986] CR2: 00005575f29a5c08 CR3: 0000000163810000 CR4: 0000000000350ee0
> > [   59.632989] Kernel panic - not syncing: Fatal exception
> > [   59.732905] Kernel Offset: 0x2d000000 from 0xffffffff81000000
> > (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> > [   59.807803] ---[ end Kernel panic - not syncing: Fatal exception ]---
> >
> >
> > cki issue tracker: https://datawarehouse.cki-project.org/issue/1470
> >
> > [1] https://datawarehouse.cki-project.org/kcidb/tests/4002370
> > [2] http://s3.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/06/20/568171088/redhat:568171088/redhat:568171088_x86_64_debug/.config
> >
> > Thanks,
> > Bruno Goncalves
> >
>

