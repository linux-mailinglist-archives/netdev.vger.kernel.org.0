Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2AC59963B
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 09:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346700AbiHSHhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 03:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346639AbiHSHhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 03:37:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1E6CACBB
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 00:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660894629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k0gFNpUb8cPLHxn5agos1W9KZX4oD6+OFHde6KkiGjY=;
        b=i81g8vSizjYaRWPDZr5107Tg5/BoatSIPIS4WP6I/oxi6KlUjqqMvHVUk+Kihklxn8mZpD
        olykiQ3xBUhxrWNz6NZbpFD7okH4a+ZCBVpbe40WcYdHWad6SqlotLNbZMXDixQSGQXtlx
        EuJiMiFXfLpkrciphn3efRGu2ygMmZg=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-147-CZIrAZ8GP320mTGGRdg7lw-1; Fri, 19 Aug 2022 03:37:07 -0400
X-MC-Unique: CZIrAZ8GP320mTGGRdg7lw-1
Received: by mail-lj1-f200.google.com with SMTP id o19-20020a05651c051300b002605bf9706aso812129ljp.19
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 00:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=k0gFNpUb8cPLHxn5agos1W9KZX4oD6+OFHde6KkiGjY=;
        b=0et2n8jU+UYbX/fp/EW0Ieoy8aW1Ab0jE3o3q5U37xCISQt59d0lHg1BDloxmUOZKy
         k7R2u1ggrbTtrXOLdVd694fiptZ4ScH/HtAALCMnRwq0Z5P9J4XCc7LQNefjUwkzy+9S
         uCDfH47Z6DKDTfkdejjAb9foggj8BHJEHWNOztmN40xcLZ2qup7ACAKwRevFSx4BJSIB
         MrFPD3SU/O0goVmzMAvSQXSGPKF6b/Vhq+wzNnln+SeGPVFltmubB8Q321IW40+YUdtb
         iHrq2tipqfJKmKZK730oze8wgqzqa2pt7yz2z3s3A5THkZEWmXVTsT1bqKsRmbL3G8Ri
         fDYg==
X-Gm-Message-State: ACgBeo3fzEwZWosjYBF3whqFQtiILc4GuAU+UmBRvkHQaMylXC0IsgJZ
        j0sNLEyy0Ozynin+Uaa87VBNdiAQ3po81Rn4WZ/uem7NgXU+Cr392GjUd/Wi4t8vqCcClnbvJBs
        kDebkHLl1EK09SVwZbTJ/dwaHBzO+fsza
X-Received: by 2002:a2e:9a9a:0:b0:261:bbaa:df12 with SMTP id p26-20020a2e9a9a000000b00261bbaadf12mr826519lji.134.1660894625882;
        Fri, 19 Aug 2022 00:37:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7AbautWsA70csPP74gg4X0MvFsPdgte0tACiYmA7FeMq104V/RyHE4JjY4bYTi/wt99L3Sr4LtKUmzZTC7QMw=
X-Received: by 2002:a2e:9a9a:0:b0:261:bbaa:df12 with SMTP id
 p26-20020a2e9a9a000000b00261bbaadf12mr826504lji.134.1660894625599; Fri, 19
 Aug 2022 00:37:05 -0700 (PDT)
MIME-Version: 1.0
References: <CA+QYu4qxW1BUcbC9MwG1BxXjPO96sa9BOUXOHCj1SLY7ObJnQw@mail.gmail.com>
 <20220802122356.6f163a79@kernel.org> <CA+QYu4ob4cbh3Vnh9DWgaPpyw8nTLFG__TbBpBsYg1tWJPxygg@mail.gmail.com>
 <20220803083751.40b6ee93@kernel.org> <CA+QYu4poBJgXZ=RLTpQVxMeTX3HUSenWA7WZCcw45dzdGeyecg@mail.gmail.com>
 <20220818085106.73aabac2@kernel.org> <BY3PR18MB4612295606F0C22A1863FF44AB6D9@BY3PR18MB4612.namprd18.prod.outlook.com>
In-Reply-To: <BY3PR18MB4612295606F0C22A1863FF44AB6D9@BY3PR18MB4612.namprd18.prod.outlook.com>
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Fri, 19 Aug 2022 09:36:54 +0200
Message-ID: <CA+QYu4pe47eYEUyEMC3n5iF2+qx30ff_duokWq-2z9b=UcpWzQ@mail.gmail.com>
Subject: Re: [EXT] Re: RIP: 0010:qede_load+0x128d/0x13b0 [qede] - 5.19.0
To:     Manish Chopra <manishc@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ariel Elior <aelior@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Alok Prasad <palok@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 at 19:55, Manish Chopra <manishc@marvell.com> wrote:
>
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Thursday, August 18, 2022 9:21 PM
> > To: Bruno Goncalves <bgoncalv@redhat.com>; Ariel Elior
> > <aelior@marvell.com>
> > Cc: LKML <linux-kernel@vger.kernel.org>; Networking
> > <netdev@vger.kernel.org>; CKI Project <cki-project@redhat.com>; Saurav
> > Kashyap <skashyap@marvell.com>; Javed Hasan <jhasan@marvell.com>;
> > Manish Chopra <manishc@marvell.com>
> > Subject: [EXT] Re: RIP: 0010:qede_load+0x128d/0x13b0 [qede] - 5.19.0
> >
> > External Email
> >
> > ----------------------------------------------------------------------
> > On Thu, 18 Aug 2022 09:22:17 +0200 Bruno Goncalves wrote:
> > > On Wed, 3 Aug 2022 at 17:37, Jakub Kicinski <kuba@kernel.org> wrote:
> > > >
> > > > On Wed, 3 Aug 2022 14:13:00 +0200 Bruno Goncalves wrote:
> > > > > Got this from the most recent failure (kernel built using commit
> > 0805c6fb39f6):
> > > > >
> > > > > the tarball is
> > > > > https://urldefense.proofpoint.com/v2/url?u=https-3A__s3.amazonaws.
> > > > > com_arr-2Dcki-2Dprod-2Dtrusted-2Dartifacts_trusted-2Dartifacts_603
> > > > > 714145_build-2520x86-5F64-2520debug_2807738987_artifacts_kernel-
> > 2D
> > > > > mainline.kernel.org-2Dredhat-5F603714145-5Fx86-5F64-5Fdebug.tar.gz
> > > > >
> > &d=DwICAg&c=nKjWec2b6R0mOyPaz7xtfQ&r=bMTgx2X48QVXyXOEL8ALyI4d
> > sWoR-
> > > > > m74c5n3d-
> > ruJI8&m=zBBoyokuEgJ25hD586tidMPozXvZjlserj2qf3Iqn2o5V-ds8
> > > > >
> > Jb7IkFIggvHpm4H&s=sjyeF4V5YfoiaDBRrtfGEXdVs3el3AdmvUNVQbteSu4&e=
> > > > > and the call trace from
> > > > > https://urldefense.proofpoint.com/v2/url?u=https-3A__s3.us-2Deast-
> > > > > 2D1.amazonaws.com_arr-2Dcki-2Dprod-2Ddatawarehouse-
> > 2Dpublic_datawa
> > > > > rehouse-2Dpublic_2022_08_02_redhat-3A603123526_build-5Fx86-
> > 5F64-5F
> > > > > redhat-3A603123526-5Fx86-5F64-5Fdebug_tests_1_results-
> > 5F0001_conso
> > > > >
> > le.log_console.log&d=DwICAg&c=nKjWec2b6R0mOyPaz7xtfQ&r=bMTgx2X48
> > QV
> > > > > XyXOEL8ALyI4dsWoR-m74c5n3d-
> > ruJI8&m=zBBoyokuEgJ25hD586tidMPozXvZjls
> > > > > erj2qf3Iqn2o5V-
> > ds8Jb7IkFIggvHpm4H&s=wV1Vq1lhXX02fbTXIWy_NRHxb9LgDz
> > > > > Enst11oy-RTpM&e=
> > > > >
> > > > > [   69.876513] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> > > > > [   69.888521] Hardware name: HPE ProLiant DL325 Gen10 Plus/ProLiant
> > > > > DL325 Gen10 Plus, BIOS A43 08/09/2021
> > > > > [   69.897971] RIP: 0010:qede_load.cold
> > > > > (/builds/2807738987/workdir/./include/linux/spinlock.h:389
> > > > > /builds/2807738987/workdir/./include/linux/netdevice.h:4294
> > > > > /builds/2807738987/workdir/./include/linux/netdevice.h:4385
> > > > > /builds/2807738987/workdir/drivers/net/ethernet/qlogic/qede/qede_m
> > > > > ain.c:2594
> > > > > /builds/2807738987/workdir/drivers/net/ethernet/qlogic/qede/qede_m
> > > > > ain.c:2575)
> > > >
> > > > Thanks a lot! That seems to point the finger at commit 3aa6bce9af0e
> > > > ("net: watchdog: hold device global xmit lock during tx disable")
> > > > but frankly IDK why... The driver must be fully initialized to get
> > > > to
> > > > ndo_open() so how is the tx_global_lock busted?!
> > > >
> > > > Would you be able to re-run with CONFIG_KASAN=y ?
> > > > Perhaps KASAN can tell us what's messing up the lock.
> > >
> > > Sorry for taking a long time to provide the info.
> > > Below is the call trace, note it is on a different machine. It might
> > > take me a few days in case I need to try on the original machine.
> >
> > Thanks, looks like KASAN didn't catch anything, it's the same crash :( Let's CC
> > all the Qlogic people, Qlogic PTAL.
> >
> > > [  110.329039] [0000:c1:00.2]:[qedf_link_update:613]:9: LINK DOWN.
> > > [  110.330183] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI [
> > > 110.340728] CPU: 56 PID: 1810 Comm: NetworkManager Not tainted 5.19.0
> > > #1 [  110.347435] Hardware name: Dell Inc. PowerEdge R7425/02MJ3T,
> > > BIOS
> > > 1.18.0 01/17/2022
> > > [  110.355088] RIP: 0010:qede_load.cold+0x14c/0xa08 [qede] [
> > > 110.360348] Code: c6 60 fb 40 c0 48 c7 c7 40 e1 40 c0 e8 b7 21 28
> > > c8 48 8b 3c 24 e8 fa 06 2d c7 41 0f b7 9f b6 00 00 00 41 89 dc e9 c2
> > > 3c fe ff <0f> 0b 48 c7 c1 60 d0 40 c0 eb c1 49 8d 7f 08 e8 36 09 2d c7
> > > 49 8b
> > > [  110.379101] RSP: 0018:ffff888162ab6e00 EFLAGS: 00010206 [
> > > 110.384338] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> > > ffffffffc03ed524 [  110.391479] RDX: 000000000000006b RSI:
> > > 0000000000000007 RDI: ffff88810401a758 [  110.398621] RBP:
> > > ffff8888a20f2cd0 R08: 0000000000000001 R09: ffffffff8bba9e0f [
> > > 110.405761] R10: fffffbfff17753c1 R11: 0000000000000001 R12:
> > > ffff88810401a758 [  110.412895] R13: ffff8888a20f2c08 R14:
> > > ffff8888a20f2cb6 R15: ffff8888a20f2c00 [  110.420036] FS:
> > > 00007fac3a412500(0000) GS:ffff888810d00000(0000)
> > > knlGS:0000000000000000
> > > [  110.428129] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [
> > > 110.433875] CR2: 00007fac38ffca88 CR3: 0000000123528000 CR4:
> > > 00000000003506e0 [  110.441009] Call Trace:
> > > [  110.443464]  <TASK>
> > > [  110.445585]  ? qed_eth_rxq_start_ramrod+0x320/0x320 [qed] [
> > > 110.451110]  ? qede_alloc_mem_txq+0x240/0x240 [qede] [  110.456106]  ?
> > > lock_release+0x233/0x470 [  110.459958]  ?
> > > rwsem_wake.isra.0+0xf1/0x100 [  110.464163]  ?
> > > lock_chain_count+0x20/0x20 [  110.468179]  ? find_held_lock+0x83/0xa0
> > > [  110.472032]  ? lock_is_held_type+0xe3/0x140 [  110.476245]  ?
> > > lockdep_hardirqs_on_prepare+0x132/0x230
> > > [  110.481397]  ? queue_delayed_work_on+0x57/0x90 [  110.485852]  ?
> > > lockdep_hardirqs_on+0x7d/0x100 [  110.490221]  ?
> > > qed_get_int_fp+0xe0/0xe0 [qed] [  110.494703]  qede_open+0x6d/0x100
> > > [qede] [  110.498664]  __dev_open+0x1c3/0x2c0 [  110.502171]  ?
> > > dev_set_rx_mode+0x60/0x60 [  110.506105]  ?
> > > lockdep_hardirqs_on_prepare+0x132/0x230
> > > [  110.511254]  ? __local_bh_enable_ip+0x8f/0x110 [  110.515711]
> > > __dev_change_flags+0x31b/0x3b0 [  110.519906]  ?
> > > dev_set_allmulti+0x10/0x10 [  110.523935]  dev_change_flags+0x58/0xb0
> > > [  110.527783]  do_setlink+0xb38/0x19e0 [  110.531370]  ?
> > > reacquire_held_locks+0x270/0x270 [  110.535910]  ?
> > > rtnetlink_put_metrics+0x2e0/0x2e0 [  110.540538]  ?
> > > entry_SYSCALL_64+0x1/0x29 [  110.544478]  ?
> > > is_bpf_text_address+0x83/0xf0 [  110.548762]  ?
> > > kernel_text_address+0x125/0x130 [  110.553218]  ?
> > > __kernel_text_address+0xe/0x40 [  110.557585]  ?
> > > unwind_get_return_address+0x33/0x50
> > > [  110.562386]  ? create_prof_cpu_mask+0x20/0x20 [  110.566755]  ?
> > > arch_stack_walk+0xa3/0x100 [  110.570781]  ? memset+0x1f/0x40 [
> > > 110.573939]  ? __nla_validate_parse+0xb4/0x1040 [  110.578481]  ?
> > > stack_trace_save+0x96/0xd0 [  110.582504]  ?
> > > nla_get_range_signed+0x180/0x180 [  110.587042]  ?
> > > __stack_depot_save+0x35/0x4a0 [  110.591335]
> > > __rtnl_newlink+0x715/0xc90 [  110.595182]  ? mark_lock+0xd51/0xd90 [
> > > 110.598773]  ? rtnl_link_unregister+0x1e0/0x1e0 [  110.603309]  ?
> > > _raw_spin_unlock_irqrestore+0x40/0x60
> > > [  110.608285]  ? ___slab_alloc+0x919/0xf80 [  110.612222]  ?
> > > rtnl_newlink+0x36/0x70 [  110.615896]  ?
> > > reacquire_held_locks+0x270/0x270 [  110.620440]  ?
> > > lock_is_held_type+0xe3/0x140 [  110.624634]  ?
> > > rcu_read_lock_sched_held+0x3f/0x80
> > > [  110.629353]  ? trace_kmalloc+0x33/0x100 [  110.633207]
> > > rtnl_newlink+0x4f/0x70 [  110.636704]  rtnetlink_rcv_msg+0x242/0x6b0 [
> > > 110.640815]  ? rtnl_stats_set+0x260/0x260 [  110.644836]  ?
> > > lock_acquire+0x16f/0x410 [  110.648682]  ? lock_acquire+0x17f/0x410 [
> > > 110.652533]  netlink_rcv_skb+0xce/0x200 [  110.656385]  ?
> > > rtnl_stats_set+0x260/0x260 [  110.660408]  ? netlink_ack+0x520/0x520 [
> > > 110.664166]  ? netlink_deliver_tap+0x13c/0x5c0 [  110.668626]  ?
> > > netlink_deliver_tap+0x141/0x5c0 [  110.673083]
> > > netlink_unicast+0x2cb/0x460 [  110.677015]  ?
> > > netlink_attachskb+0x440/0x440 [  110.681294]  ?
> > > __build_skb_around+0x12a/0x150 [  110.685667]
> > > netlink_sendmsg+0x3d2/0x710 [  110.689609]  ?
> > > netlink_unicast+0x460/0x460 [  110.693710]  ?
> > > iovec_from_user.part.0+0x95/0x200 [  110.698348]  ?
> > > netlink_unicast+0x460/0x460 [  110.702456]  sock_sendmsg+0x99/0xa0 [
> > > 110.705963]  ____sys_sendmsg+0x3d4/0x410 [  110.709895]  ?
> > > kernel_sendmsg+0x30/0x30 [  110.713740]  ?
> > > __ia32_sys_recvmmsg+0x160/0x160 [  110.718200]  ?
> > > lockdep_hardirqs_on_prepare+0x230/0x230
> > > [  110.723358]  ___sys_sendmsg+0xe2/0x150 [  110.727124]  ?
> > > sendmsg_copy_msghdr+0x110/0x110 [  110.731576]  ?
> > > find_held_lock+0x83/0xa0 [  110.735425]  ? lock_release+0x233/0x470 [
> > > 110.739271]  ? __fget_files+0x14a/0x200 [  110.743120]  ?
> > > reacquire_held_locks+0x270/0x270 [  110.747674]  ?
> > > __fget_files+0x162/0x200 [  110.751524]  ? __fget_light+0x66/0x100 [
> > > 110.755286]  __sys_sendmsg+0xc3/0x140 [  110.758964]  ?
> > > __sys_sendmsg_sock+0x20/0x20 [  110.763158]  ?
> > > mark_held_locks+0x24/0x90 [  110.767099]  ?
> > > ktime_get_coarse_real_ts64+0x19/0x80
> > > [  110.771990]  ? ktime_get_coarse_real_ts64+0x65/0x80
> > > [  110.776879]  ? syscall_trace_enter.constprop.0+0x16f/0x230
> > > [  110.782375]  do_syscall_64+0x5b/0x80 [  110.785963]
> > > entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > [  110.791021] RIP: 0033:0x7fac3b54f71d [  110.794609] Code: 28 89 54
> > > 24 1c 48 89 74 24 10 89 7c 24 08 e8 ea
> > > c4 f4 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00
> > > 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 3e c5 f4
> > > ff 48 [  110.813362] RSP: 002b:00007ffd3b5c7da0 EFLAGS: 00000293
> > > ORIG_RAX:
> > > 000000000000002e
> > > [  110.820938] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
> > > 00007fac3b54f71d [  110.828081] RDX: 0000000000000000 RSI:
> > > 00007ffd3b5c7de0 RDI: 000000000000000d [  110.835221] RBP:
> > > 0000563d7ac60090 R08: 0000000000000000 R09: 0000000000000000 [
> > > 110.842361] R10: 0000000000000000 R11: 0000000000000293 R12:
> > > 00007ffd3b5c7f4c [  110.849494] R13: 00007ffd3b5c7f50 R14:
> > > 0000000000000000 R15: 00007ffd3b5c7f58 [  110.856639]  </TASK> [
> > > 110.858837] Modules linked in: pcc_cpufreq(-) rfkill intel_rapl_msr
> > > dcdbas intel_rapl_common amd64_edac edac_mce_amd rapl pcspkr qedi
> > > mgag200 i2c_algo_bit iscsi_boot_sysfs libiscsi drm_shmem_helper
> > > cdc_ether scsi_transport_iscsi usbnet drm_kms_helper mii uio ipmi_ssif
> > > k10temp i2c_piix4 acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler
> > > acpi_power_meter acpi_cpufreq vfat fat drm fuse xfs qedf qede qed
> > > crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel libfcoe
> > > libfc scsi_transport_fc crc8 ccp tg3 sp5100_tco [  110.904398] ---[
> > > end trace 0000000000000000 ]--- [  110.909039] RIP:
> > > 0010:qede_load.cold+0x14c/0xa08 [qede] [  110.914306] Code: c6 60 fb
> > > 40 c0 48 c7 c7 40 e1 40 c0 e8 b7 21 28
> > > c8 48 8b 3c 24 e8 fa 06 2d c7 41 0f b7 9f b6 00 00 00 41 89 dc e9 c2
> > > 3c fe ff <0f> 0b 48 c7 c1 60 d0 40 c0 eb c1 49 8d 7f 08 e8 36 09 2d c7
> > > 49 8b
> > > [  110.933068] RSP: 0018:ffff888162ab6e00 EFLAGS: 00010206 [
> > > 110.938314] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> > > ffffffffc03ed524 [  110.945466] RDX: 000000000000006b RSI:
> > > 0000000000000007 RDI: ffff88810401a758 [  110.952616] RBP:
> > > ffff8888a20f2cd0 R08: 0000000000000001 R09: ffffffff8bba9e0f [
> > > 110.959772] R10: fffffbfff17753c1 R11: 0000000000000001 R12:
> > > ffff88810401a758 [  110.966925] R13: ffff8888a20f2c08 R14:
> > > ffff8888a20f2cb6 R15: ffff8888a20f2c00 [  110.974092] FS:
> > > 00007fac3a412500(0000) GS:ffff888810d00000(0000)
> > > knlGS:0000000000000000
> > > [  110.982198] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [
> > > 110.987971] CR2: 00007fac38ffca88 CR3: 0000000123528000 CR4:
> > > 00000000003506e0 [  110.995131] Kernel panic - not syncing: Fatal
> > > exception [  111.001311] Kernel Offset: 0x6000000 from
> > > 0xffffffff81000000 (relocation range:
> > > 0xffffffff80000000-0xffffffffbfffffff)
> > > [  111.012016] ---[ end Kernel panic - not syncing: Fatal exception
> > > ]---
> > >
> > > kernel tarball:
> > > https://urldefense.proofpoint.com/v2/url?u=https-
> > 3A__s3.amazonaws.com_
> > > arr-2Dcki-2Dprod-2Dtrusted-2Dartifacts_trusted-2Dartifacts_604654489_p
> > > ublish-2520x86-5F64-2520debug_2813007034_artifacts_kernel-
> > 2Dmainline.k
> > > ernel.org-2Dredhat-5F604654489-5Fx86-5F64-
> > 5Fdebug.tar.gz&d=DwICAg&c=nK
> > > jWec2b6R0mOyPaz7xtfQ&r=bMTgx2X48QVXyXOEL8ALyI4dsWoR-
> > m74c5n3d-ruJI8&m=z
> > > BBoyokuEgJ25hD586tidMPozXvZjlserj2qf3Iqn2o5V-
> > ds8Jb7IkFIggvHpm4H&s=WXbt
> > > GecipcXSY_rwTu6JrCEI7VFKToDZ3UfZ4ciloWk&e=
> > > kernel config:
> > > https://urldefense.proofpoint.com/v2/url?u=https-
> > 3A__s3.amazonaws.com_
> > > arr-2Dcki-2Dprod-2Dtrusted-2Dartifacts_trusted-2Dartifacts_604654489_b
> > > uild-2520x86-5F64-2520debug_2813006987_artifacts_kernel-
> > 2Dmainline.ker
> > > nel.org-2Dredhat-5F604654489-5Fx86-5F64-
> > 5Fdebug.config&d=DwICAg&c=nKjW
> > > ec2b6R0mOyPaz7xtfQ&r=bMTgx2X48QVXyXOEL8ALyI4dsWoR-m74c5n3d-
> > ruJI8&m=zBB
> > > oyokuEgJ25hD586tidMPozXvZjlserj2qf3Iqn2o5V-
> > ds8Jb7IkFIggvHpm4H&s=edaLwi
> > > kEZyvLAk8hrsZNE-Esjsn9HZ5luaW_FARAlCw&e=
> > >
> > >
> > > Bruno
>
> Hi Bruno,
>
> 1. How do you reproduce this issue exactly ? Any specific instructions or any special kernel CONFIG with which issue reproduces ?

We hit the panic by booting up the machine with a kernel 5.19.0 with
debug flags enabled.

kernel tarball:
https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/604654489/publish%20x86_64%20debug/2813007034/artifacts/kernel-mainline.kernel.org-redhat_604654489_x86_64_debug.tar.gz
kernel config is:
https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/604654489/build%20x86_64%20debug/2813006987/artifacts/kernel-mainline.kernel.org-redhat_604654489_x86_64_debug.config

The machine has FastLinQ QL41000 Series 10/25/40/50GbE Controller (mbi
8.52.21 [mfw 8.52.9.0])

> 2. Is there any Bugzilla opened for this already ? Can you please provide the complete crash logs ? (vmcore-dmesg.txt ?)
No, there is no bugzilla, I haven't seen this problem on rhel-9 kernel
(5.14). I don't have a vmcore, but I'll try to get one.

Below is a link to console log from a CKI pipeline execution, it is
not from the same run above as above I ran manually.

https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/06/20/568171088/redhat:568171088_x86_64_debug/tests/12172126_x86_64_5_console.log

For this console.log the kernel config is
http://s3.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/06/20/568171088/redhat:568171088/redhat:568171088_x86_64_debug/.config
and the tarball is
http://s3.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/06/20/568171088/redhat:568171088/redhat:568171088_x86_64_debug/kernel-mainline.kernel.org-x86_64-78ca55889a549a9a194c6ec666836329b774ab6d.tar.gz

Bruno

> 3. You mentioned about commit 3aa6bce9af0e ("net: watchdog: hold device global xmit lock during tx disable")
>     Do you mean issue started surfacing only after this commit ? Driver calls netif_tx_disable() from these two relevant contexts -
>
>     a. One in ndo_stop() flow
>
>                 /* Close OS Tx */
>         netif_tx_disable(edev->ndev);
>         netif_carrier_off(edev->ndev);
>
>    b. Other in LINK events handling from the hard IRQ context
>
>         DP_NOTICE(edev, "Link is down\n");
>         netif_tx_disable(edev->ndev);
>         netif_carrier_off(edev->ndev);
>
> Thanks,
> Manish
>

