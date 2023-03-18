Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEAC6C89B5
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 01:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbjCYAou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 20:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCYAot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 20:44:49 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93D312B;
        Fri, 24 Mar 2023 17:44:48 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so3189159pjt.5;
        Fri, 24 Mar 2023 17:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679705088;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gGri5zgrpwBNQccX2+WkAia7t3Mp6NEARVbrGgzBR38=;
        b=qvjtVlA1JomFexRyZAphQnfjJBoWJXtxI2qUFCU/BSgLRCCotn6ZPGvyUQOH/CqsmS
         g7bZHhqDPvTr1VYUzmMojTvQCtwbh0aFbJMGofl79xcvos7cARW6Ay7dNVBAYDUZPdli
         9CRbjXVmN1YKuv229yEdQ8cmG9x/aIkLJEXmFFrbGD3+B8KKfr3id8fIafBhscyvzYM6
         Qfz1HdPhRdT35NBkpOuJ1uipaJ72Puc3943GhebYINHoVBxfVPR8XkSVZJyty42p1rhM
         +G4hgMhQI+dL3kQ3F7Fbl3fVA6ngL3G0PfTk/BVWHNiHWZnv/e6Q7Gkh6Mxk7S889c9W
         qimw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679705088;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gGri5zgrpwBNQccX2+WkAia7t3Mp6NEARVbrGgzBR38=;
        b=oDcva3BfQEEaatSrIihJW9chRSyMI8eOT32tvbaGlxVmqzpVdSlEfY3/NVi9/c+ijd
         fF+ev/zelMNNhtuJKZd4ofHDTvKM31+HWu4stSs690/ewIvg94rQzZp3WjfnZFK+G5Dm
         oUWNbTMmOCI1id/rpX/oKpqLEj12H8nPfBv9qJJ3BLuDMBZ2i4Bx5zkHibBqEnK3/Zp8
         SDf53ybSNqssXLN1mtnT7XM5bbwgCb0bei6lGh3d98n6QZAKNDPxuh851+lwiJnwZcPt
         snOinQPDrDRW6ka4eI2emiWT/gvGGTw5M37uqC3WD239n7XjMw2MPUWhkcPDtUQ6Xw/p
         GXrQ==
X-Gm-Message-State: AAQBX9cwelrmiVaZ4fIA4MI4qFtbXi8RTSyiHethdqfmGrv+uamhfPuj
        kOEz+QKD4lI7PNyATXJ4cb2JX9hBxtfLM06u
X-Google-Smtp-Source: AKy350YWt+yEd85LHuiaoONJDjSIB5/4b2nw6M9WRVg4rD9lE3/1YSyYOvYWxAy33c/kgH1GlMu7Yg==
X-Received: by 2002:a17:902:e30b:b0:1a1:7c2b:4aea with SMTP id q11-20020a170902e30b00b001a17c2b4aeamr3593928plc.0.1679705088042;
        Fri, 24 Mar 2023 17:44:48 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id m6-20020a1709026bc600b001a049441fc8sm3584749plt.193.2023.03.24.17.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 17:44:47 -0700 (PDT)
Date:   Sat, 18 Mar 2023 00:32:39 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        syzbot <syzbot+0bc015ebddc291a97116@syzkaller.appspotmail.com>,
        axboe@kernel.dk, davem@davemloft.net, edumazet@google.com,
        io-uring@vger.kernel.org, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Subject: Re: [syzbot] [net?] [virt?] [io-uring?] [kvm?] BUG: soft lockup in
 vsock_connect
Message-ID: <ZBUGp5bvNuE3sK5g@bullseye>
References: <00000000000075bebb05f79acfde@google.com>
 <CAGxU2F4jxdzK8Y-jaoKRaX_bDhoMtomOT6TyMek+un-Bp8RX3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGxU2F4jxdzK8Y-jaoKRaX_bDhoMtomOT6TyMek+un-Bp8RX3g@mail.gmail.com>
X-Spam-Status: No, score=1.9 required=5.0 tests=DATE_IN_PAST_96_XX,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 09:38:38AM +0100, Stefano Garzarella wrote:
> Hi Bobby,
> FYI we have also this one, but it seems related to
> syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com
> 
> Thanks,
> Stefano
> 

Got it, I'll look into it.

Best,
Bobby

> 
> On Fri, Mar 24, 2023 at 1:52 AM syzbot
> <syzbot+0bc015ebddc291a97116@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    fe15c26ee26e Linux 6.3-rc1
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1577c97ec80000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=7573cbcd881a88c9
> > dashboard link: https://syzkaller.appspot.com/bug?extid=0bc015ebddc291a97116
> > compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
> > userspace arch: arm64
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1077c996c80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e38929c80000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/89d41abd07bd/disk-fe15c26e.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/fa75f5030ade/vmlinux-fe15c26e.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/590d0f5903ee/Image-fe15c26e.gz.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+0bc015ebddc291a97116@syzkaller.appspotmail.com
> >
> > watchdog: BUG: soft lockup - CPU#0 stuck for 27s! [syz-executor244:6747]
> > Modules linked in:
> > irq event stamp: 6033
> > hardirqs last  enabled at (6032): [<ffff8000124604ac>] __exit_to_kernel_mode arch/arm64/kernel/entry-common.c:84 [inline]
> > hardirqs last  enabled at (6032): [<ffff8000124604ac>] exit_to_kernel_mode+0xe8/0x118 arch/arm64/kernel/entry-common.c:94
> > hardirqs last disabled at (6033): [<ffff80001245e188>] __el1_irq arch/arm64/kernel/entry-common.c:468 [inline]
> > hardirqs last disabled at (6033): [<ffff80001245e188>] el1_interrupt+0x24/0x68 arch/arm64/kernel/entry-common.c:486
> > softirqs last  enabled at (616): [<ffff80001066ca80>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
> > softirqs last  enabled at (616): [<ffff80001066ca80>] lock_sock_nested+0xe8/0x138 net/core/sock.c:3480
> > softirqs last disabled at (618): [<ffff8000122dbcfc>] spin_lock_bh include/linux/spinlock.h:355 [inline]
> > softirqs last disabled at (618): [<ffff8000122dbcfc>] virtio_transport_purge_skbs+0x11c/0x500 net/vmw_vsock/virtio_transport_common.c:1372
> > CPU: 0 PID: 6747 Comm: syz-executor244 Not tainted 6.3.0-rc1-syzkaller-gfe15c26ee26e #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
> > pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > pc : __sanitizer_cov_trace_pc+0xc/0x8c kernel/kcov.c:203
> > lr : virtio_transport_purge_skbs+0x19c/0x500 net/vmw_vsock/virtio_transport_common.c:1374
> > sp : ffff80001e787890
> > x29: ffff80001e7879e0 x28: 1ffff00003cf0f2a x27: ffff80001a487a60
> > x26: ffff80001e787950 x25: ffff0000ce2d3b80 x24: ffff80001a487a78
> > x23: 1ffff00003490f4c x22: ffff80001a29c1a8 x21: dfff800000000000
> > x20: ffff80001a487a60 x19: ffff80001e787940 x18: 1fffe000368951b6
> > x17: ffff800015cdd000 x16: ffff8000085110b0 x15: 0000000000000000
> > x14: 1ffff00002b9c0b2 x13: dfff800000000000 x12: ffff700003cf0efc
> > x11: ff808000122dbee8 x10: 0000000000000000 x9 : ffff8000122dbee8
> > x8 : ffff0000ce511b40 x7 : ffff8000122dbcfc x6 : 0000000000000000
> > x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff80000832d758
> > x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000000
> > Call trace:
> >  get_current arch/arm64/include/asm/current.h:19 [inline]
> >  __sanitizer_cov_trace_pc+0xc/0x8c kernel/kcov.c:206
> >  vsock_loopback_cancel_pkt+0x28/0x3c net/vmw_vsock/vsock_loopback.c:48
> >  vsock_transport_cancel_pkt net/vmw_vsock/af_vsock.c:1284 [inline]
> >  vsock_connect+0x6b8/0xaec net/vmw_vsock/af_vsock.c:1426
> >  __sys_connect_file net/socket.c:2004 [inline]
> >  __sys_connect+0x268/0x290 net/socket.c:2021
> >  __do_sys_connect net/socket.c:2031 [inline]
> >  __se_sys_connect net/socket.c:2028 [inline]
> >  __arm64_sys_connect+0x7c/0x94 net/socket.c:2028
> >  __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
> >  invoke_syscall+0x98/0x2c0 arch/arm64/kernel/syscall.c:52
> >  el0_svc_common+0x138/0x258 arch/arm64/kernel/syscall.c:142
> >  do_el0_svc+0x64/0x198 arch/arm64/kernel/syscall.c:193
> >  el0_svc+0x58/0x168 arch/arm64/kernel/entry-common.c:637
> >  el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
> >  el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> >
> 
