Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6800068EFF3
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 14:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjBHNjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 08:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbjBHNjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 08:39:11 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B73CC34
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 05:39:10 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id k8-20020a05600c1c8800b003dc57ea0dfeso1507354wms.0
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 05:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YuW8vVg4JTqhWS8yFGol8c5I7IEhr9Z1fexB4L0n2p8=;
        b=e5/uwPRnyzTtFQTyY6b3WrihZ6umCs3ZngDvV+DugaIsRwOJ0cmUVi+qCBXRtAowql
         FO2omIhzpZwte9ZQr/B+QLaAol/jrsBRmKqLfC4ECEe6xonXu+L0UEJ7Sk8ocZER61Cx
         gjhGIGdtNO6S7dEGR/cdhDqiSalYENI26Lk/rFoyV9KcsGuCIs/y3Om/RODv+uWn3sAP
         Dya4pMQ21ZxGFNVPRwfhh9novX9+D7U5s3UUXt/CcnSQGzjQ2YuoxI23HVMpjWFkyFvR
         4iaeXZarPh66Q7Tc27XwkE9adg131alHrj6v17JOUzVD5lSAgDT+/47At7IuMokwTvDS
         x0EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YuW8vVg4JTqhWS8yFGol8c5I7IEhr9Z1fexB4L0n2p8=;
        b=Pw/8UFMeDTvkBW2WkySFy92arExJdyUgwGYIQTjT5C+fD23hJ3sTGHt4/G6yIuV5Z1
         kTTj9EwrW02Xh0Gs55qI/7/l37gU28FTPc30djR8WbVzsxxT7O+XqI7OmjteEgOjiKk7
         p4jZZeViM3oAdH8gi/FY+0EUmAd+/RfggRBMgsEpq6BXxDfK0Uk7pferd6S+nLXaOmrK
         CS18f3myC4k0sl9iQqfX55khbBpQiX5XfkJFGAFD3VJb9vHYG7n8nsqKAzJ0lrczSOIh
         R24hHSymD69Bp111tknharTFOOiqgR1z7jHQmB73R9zSYob2S/jFnyClDUYzCNpEb6su
         rgqg==
X-Gm-Message-State: AO0yUKUq2T7wLjpSnj7/ZXQ8y/aoljwQanf7HV/TsUG5kOmjU0weE7K5
        yWKyHo7a3d7Kd7Gug1ffjnLOEoVHflnhCb+fnMpY9A==
X-Google-Smtp-Source: AK7set+PLeZpHFR18NMFmWJtJcXy9wyNQ70wrzKJJYKP4An21w2qZTzV7RvWxbgDCFCSZvw0Dm5XonvFZv1/quv2P1E=
X-Received: by 2002:a7b:cb8b:0:b0:3df:dc12:9684 with SMTP id
 m11-20020a7bcb8b000000b003dfdc129684mr192777wmi.22.1675863548429; Wed, 08 Feb
 2023 05:39:08 -0800 (PST)
MIME-Version: 1.0
References: <20230206173103.2617121-5-edumazet@google.com> <202302081521.8e1a1948-oliver.sang@intel.com>
In-Reply-To: <202302081521.8e1a1948-oliver.sang@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Feb 2023 14:38:56 +0100
Message-ID: <CANn89i+2t0V6XMHPRziW_mZ=LvH7wOJuZfHbRPuKrcDGSOxGVg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 4/4] net: add dedicated kmem_cache for
 typical/small skb->head
To:     kernel test robot <oliver.sang@intel.com>
Cc:     oe-lkp@lists.linux.dev, lkp@intel.com,
        Paolo Abeni <pabeni@redhat.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 8, 2023 at 9:37 AM kernel test robot <oliver.sang@intel.com> wrote:
>
>
> Greeting,
>
> FYI, we noticed kernel_BUG_at_mm/usercopy.c due to commit (built with gcc-11):
>
> commit: b9943e1e516b7fd27d5163cfee1250309fb10dd3 ("[PATCH v2 net-next 4/4] net: add dedicated kmem_cache for typical/small skb->head")
> url: https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-add-SKB_HEAD_ALIGN-helper/20230207-013333
> base: https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git c21adf256f8dcfbc07436d45be4ba2edf7a6f463
> patch link: https://lore.kernel.org/all/20230206173103.2617121-5-edumazet@google.com/
> patch subject: [PATCH v2 net-next 4/4] net: add dedicated kmem_cache for typical/small skb->head
>

Thanks for the report, I will use kmem_cache_create_usercopy() instead
of kmem_cache_create()

> in testcase: boot
>
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
>
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
>
>
> If you fix the issue, kindly add following tag
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Link: https://lore.kernel.org/oe-lkp/202302081521.8e1a1948-oliver.sang@intel.com
>
>
> [  133.916379][    T1] ------------[ cut here ]------------
> [  133.917321][    T1] kernel BUG at mm/usercopy.c:102!
> [  133.918172][    T1] invalid opcode: 0000 [#1] SMP PTI
> [  133.919045][    T1] CPU: 1 PID: 1 Comm: systemd Not tainted 6.2.0-rc6-01338-gb9943e1e516b #2
> [  133.920417][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
> [ 133.921959][ T1] RIP: 0010:usercopy_abort (kbuild/src/x86_64-2/mm/usercopy.c:102 (discriminator 16))
> [ 133.922891][ T1] Code: e8 dc d5 73 fe ff 74 24 08 49 89 d9 4d 89 e8 ff 74 24 08 4c 89 e1 4c 89 fa 48 89 ee 41 56 48 c7 c7 90 49 5c 83 e8 98 ea fe ff <0f> 0b e8 b0 d5 73 fe 41 0f b6 d5 4d 89 e0 48 89 e9 31 f6 48 c7 c7
> All code
> ========
>    0:   e8 dc d5 73 fe          callq  0xfffffffffe73d5e1
>    5:   ff 74 24 08             pushq  0x8(%rsp)
>    9:   49 89 d9                mov    %rbx,%r9
>    c:   4d 89 e8                mov    %r13,%r8
>    f:   ff 74 24 08             pushq  0x8(%rsp)
>   13:   4c 89 e1                mov    %r12,%rcx
>   16:   4c 89 fa                mov    %r15,%rdx
>   19:   48 89 ee                mov    %rbp,%rsi
>   1c:   41 56                   push   %r14
>   1e:   48 c7 c7 90 49 5c 83    mov    $0xffffffff835c4990,%rdi
>   25:   e8 98 ea fe ff          callq  0xfffffffffffeeac2
>   2a:*  0f 0b                   ud2             <-- trapping instruction
>   2c:   e8 b0 d5 73 fe          callq  0xfffffffffe73d5e1
>   31:   41 0f b6 d5             movzbl %r13b,%edx
>   35:   4d 89 e0                mov    %r12,%r8
>   38:   48 89 e9                mov    %rbp,%rcx
>   3b:   31 f6                   xor    %esi,%esi
>   3d:   48                      rex.W
>   3e:   c7                      .byte 0xc7
>   3f:   c7                      .byte 0xc7
>
> Code starting with the faulting instruction
> ===========================================
>    0:   0f 0b                   ud2
>    2:   e8 b0 d5 73 fe          callq  0xfffffffffe73d5b7
>    7:   41 0f b6 d5             movzbl %r13b,%edx
>    b:   4d 89 e0                mov    %r12,%r8
>    e:   48 89 e9                mov    %rbp,%rcx
>   11:   31 f6                   xor    %esi,%esi
>   13:   48                      rex.W
>   14:   c7                      .byte 0xc7
>   15:   c7                      .byte 0xc7
> [  133.925607][    T1] RSP: 0018:ffffc90000013c00 EFLAGS: 00010286
> [  133.926544][    T1] RAX: 000000000000006a RBX: ffffffff835877b0 RCX: 0000000000000000
> [  133.927822][    T1] RDX: 0000000000000000 RSI: ffffffff811f3595 RDI: ffffffff83bd7cd8
> [  133.929183][    T1] RBP: ffffffff835407f4 R08: ffffffff850ba350 R09: 0000000000000000
> [  133.930540][    T1] R10: 0000000000000004 R11: 0001ffffffffffff R12: ffffffff8354969c
> [  133.931802][    T1] R13: ffffffff8354a96e R14: ffffffff8354a96f R15: ffffffff835429ca
> [  133.933094][    T1] FS:  00007fa58ae35900(0000) GS:ffff88842fd00000(0000) knlGS:0000000000000000
> [  133.934557][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  133.935583][    T1] CR2: 00007fa58b9aff30 CR3: 0000000100e58000 CR4: 00000000000406e0
> [  133.936852][    T1] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  133.938174][    T1] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  133.939489][    T1] Call Trace:
> [  133.940122][    T1]  <TASK>
> [ 133.940724][ T1] __check_heap_object (kbuild/src/x86_64-2/mm/slub.c:4738)
> [ 133.941613][ T1] check_heap_object (kbuild/src/x86_64-2/mm/usercopy.c:196)
> [ 133.942520][ T1] __check_object_size (kbuild/src/x86_64-2/mm/usercopy.c:113 kbuild/src/x86_64-2/mm/usercopy.c:127 kbuild/src/x86_64-2/mm/usercopy.c:254 kbuild/src/x86_64-2/mm/usercopy.c:213)
> [ 133.943386][ T1] ? skb_put (kbuild/src/x86_64-2/net/core/skbuff.c:2313)
> [ 133.944151][ T1] netlink_sendmsg (kbuild/src/x86_64-2/include/linux/uio.h:187 kbuild/src/x86_64-2/include/linux/uio.h:194 kbuild/src/x86_64-2/include/linux/skbuff.h:3977 kbuild/src/x86_64-2/net/netlink/af_netlink.c:1927)
> [ 133.944969][ T1] ? __pfx_netlink_sendmsg (kbuild/src/x86_64-2/net/netlink/af_netlink.c:1861)
> [ 133.945824][ T1] sock_sendmsg (kbuild/src/x86_64-2/net/socket.c:722 kbuild/src/x86_64-2/net/socket.c:745)
> [ 133.946591][ T1] __sys_sendto (kbuild/src/x86_64-2/net/socket.c:2142)
> [ 133.947478][ T1] ? netlink_getsockopt (kbuild/src/x86_64-2/net/netlink/af_netlink.c:1840)
> [ 133.948404][ T1] ? write_comp_data (kbuild/src/x86_64-2/kernel/kcov.c:236)
> [ 133.949240][ T1] ? __pfx_netlink_getsockopt (kbuild/src/x86_64-2/net/netlink/af_netlink.c:1742)
> [ 133.950214][ T1] ? __sys_getsockopt (kbuild/src/x86_64-2/net/socket.c:2325)
> [ 133.951117][ T1] __x64_sys_sendto (kbuild/src/x86_64-2/net/socket.c:2150)
> [ 133.951965][ T1] do_syscall_64 (kbuild/src/x86_64-2/arch/x86/entry/common.c:50 kbuild/src/x86_64-2/arch/x86/entry/common.c:80)
> [ 133.952772][ T1] entry_SYSCALL_64_after_hwframe (kbuild/src/x86_64-2/arch/x86/entry/entry_64.S:120)
> [  133.953782][    T1] RIP: 0033:0x7fa58b613366
> [ 133.954582][ T1] Code: eb 0b 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 72 c3 90 55 48 83 ec 30 44 89 4c 24 2c 4c 89
> All code
> ========
>    0:   eb 0b                   jmp    0xd
>    2:   00 f7                   add    %dh,%bh
>    4:   d8 64 89 02             fsubs  0x2(%rcx,%rcx,4)
>    8:   48 c7 c0 ff ff ff ff    mov    $0xffffffffffffffff,%rax
>    f:   eb b8                   jmp    0xffffffffffffffc9
>   11:   0f 1f 00                nopl   (%rax)
>   14:   41 89 ca                mov    %ecx,%r10d
>   17:   64 8b 04 25 18 00 00    mov    %fs:0x18,%eax
>   1e:   00
>   1f:   85 c0                   test   %eax,%eax
>   21:   75 11                   jne    0x34
>   23:   b8 2c 00 00 00          mov    $0x2c,%eax
>   28:   0f 05                   syscall
>   2a:*  48 3d 00 f0 ff ff       cmp    $0xfffffffffffff000,%rax         <-- trapping instruction
>   30:   77 72                   ja     0xa4
>   32:   c3                      retq
>   33:   90                      nop
>   34:   55                      push   %rbp
>   35:   48 83 ec 30             sub    $0x30,%rsp
>   39:   44 89 4c 24 2c          mov    %r9d,0x2c(%rsp)
>   3e:   4c                      rex.WR
>   3f:   89                      .byte 0x89
>
> Code starting with the faulting instruction
> ===========================================
>    0:   48 3d 00 f0 ff ff       cmp    $0xfffffffffffff000,%rax
>    6:   77 72                   ja     0x7a
>    8:   c3                      retq
>    9:   90                      nop
>    a:   55                      push   %rbp
>    b:   48 83 ec 30             sub    $0x30,%rsp
>    f:   44 89 4c 24 2c          mov    %r9d,0x2c(%rsp)
>   14:   4c                      rex.WR
>   15:   89                      .byte 0x89
> [  133.957460][    T1] RSP: 002b:00007ffe1e572498 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> [  133.958872][    T1] RAX: ffffffffffffffda RBX: 00007ffe1e57251c RCX: 00007fa58b613366
> [  133.960240][    T1] RDX: 0000000000000020 RSI: 00005600c1e5bf80 RDI: 0000000000000004
> [  133.961601][    T1] RBP: 00005600c1e5fd10 R08: 00007ffe1e5724a0 R09: 0000000000000010
> [  133.962897][    T1] R10: 0000000000000000 R11: 0000000000000246 R12: 00005600c1e5fdf0
> [  133.966272][    T1] R13: 0000000000000001 R14: 00005600c1e5c790 R15: 00005600c0f4e543
> [  133.967615][    T1]  </TASK>
> [  133.968228][    T1] Modules linked in: ip_tables
> [  133.969143][    T1] ---[ end trace 0000000000000000 ]---
> [ 133.970098][ T1] RIP: 0010:usercopy_abort (kbuild/src/x86_64-2/mm/usercopy.c:102 (discriminator 16))
> [ 133.971164][ T1] Code: e8 dc d5 73 fe ff 74 24 08 49 89 d9 4d 89 e8 ff 74 24 08 4c 89 e1 4c 89 fa 48 89 ee 41 56 48 c7 c7 90 49 5c 83 e8 98 ea fe ff <0f> 0b e8 b0 d5 73 fe 41 0f b6 d5 4d 89 e0 48 89 e9 31 f6 48 c7 c7
> All code
> ========
>    0:   e8 dc d5 73 fe          callq  0xfffffffffe73d5e1
>    5:   ff 74 24 08             pushq  0x8(%rsp)
>    9:   49 89 d9                mov    %rbx,%r9
>    c:   4d 89 e8                mov    %r13,%r8
>    f:   ff 74 24 08             pushq  0x8(%rsp)
>   13:   4c 89 e1                mov    %r12,%rcx
>   16:   4c 89 fa                mov    %r15,%rdx
>   19:   48 89 ee                mov    %rbp,%rsi
>   1c:   41 56                   push   %r14
>   1e:   48 c7 c7 90 49 5c 83    mov    $0xffffffff835c4990,%rdi
>   25:   e8 98 ea fe ff          callq  0xfffffffffffeeac2
>   2a:*  0f 0b                   ud2             <-- trapping instruction
>   2c:   e8 b0 d5 73 fe          callq  0xfffffffffe73d5e1
>   31:   41 0f b6 d5             movzbl %r13b,%edx
>   35:   4d 89 e0                mov    %r12,%r8
>   38:   48 89 e9                mov    %rbp,%rcx
>   3b:   31 f6                   xor    %esi,%esi
>   3d:   48                      rex.W
>   3e:   c7                      .byte 0xc7
>   3f:   c7                      .byte 0xc7
>
> Code starting with the faulting instruction
> ===========================================
>    0:   0f 0b                   ud2
>    2:   e8 b0 d5 73 fe          callq  0xfffffffffe73d5b7
>    7:   41 0f b6 d5             movzbl %r13b,%edx
>    b:   4d 89 e0                mov    %r12,%r8
>    e:   48 89 e9                mov    %rbp,%rcx
>   11:   31 f6                   xor    %esi,%esi
>   13:   48                      rex.W
>   14:   c7                      .byte 0xc7
>   15:   c7                      .byte 0xc7
>
>
> To reproduce:
>
>         # build kernel
>         cd linux
>         cp config-6.2.0-rc6-01338-gb9943e1e516b .config
>         make HOSTCC=gcc-11 CC=gcc-11 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage modules
>         make HOSTCC=gcc-11 CC=gcc-11 ARCH=x86_64 INSTALL_MOD_PATH=<mod-install-dir> modules_install
>         cd <mod-install-dir>
>         find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz
>
>
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> -m modules.cgz job-script # job-script is attached in this email
>
>         # if come across any failure that blocks the test,
>         # please remove ~/.lkp and /lkp dir to run from a clean state.
>
>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests
>
>
