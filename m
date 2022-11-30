Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCC763D20C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 10:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbiK3Jdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 04:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbiK3JdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 04:33:18 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE2073400
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 01:32:26 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1322d768ba7so20294834fac.5
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 01:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nmp/KXSWp7j/op7rlj+32saQZGYoAszbSHX9jQ3Ehj4=;
        b=NIK6BO/R+llQL/gldiQMtwfKTmOU7KJ4vyiAKg1zESF7S1YjqfZi+EJTfTbjc6oJhb
         auKWhVr5AbnOeWDhyX5/Gt0Ro1ky0OuD5Mo30iOvhG6Zz1BZUIUXSs13xucfD8+mlnei
         mZAq2igF4uP4X6ZEiutxj2zcW8dXM4v3Qn58EKMNBnetOI+GVfGDjET6KTcgT+MfK2hS
         M7zzOeJOI+UQs5w93k0IeoPo0Xuhun/Tx0BhsPYAOOuLup3+mdQ7/5jRAv6kbKE14TTf
         lUhe1wqKw8QyNtwxsabgOekRy6d9YDjSBajrXGJ/CcHnjG/r//DYbn06L4rU5LPUcZ7T
         DsMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nmp/KXSWp7j/op7rlj+32saQZGYoAszbSHX9jQ3Ehj4=;
        b=M5BdJiyvohHmNRUHz+5ahihDuQaIklV3z3ps9rfKyEJpGT+QBGvqtLkvRI8r7H7SfZ
         x44yvnaPSXgO4UYReT7OMAvU6nMlXQJRSO9r8kzLR67ebWSV55pNkwDrR/FWfB6P4XGC
         1CsqlcbBOClSRTaELPWz0mdTSqQaQw6vGKhB6+RJH2s37uCjIso8liju26JTKZifk2hw
         /oWzkFeO4Zuw67d16O7tSdwrJSfzsBoNfFOZzPLLOnLaQu75Enj88Ga83CjlHoZplzxa
         H8pI5FB/pHA4y9EU3VIWa+yuFrsPYxdCXePqE9yPhxNPscWlPw1HXhc2wrThS+EwBwKD
         gsIw==
X-Gm-Message-State: ANoB5pm3uuzJg6C+oj9z64Nj9a/esweALH26JAxdtAG2hA6+JS6MIuoP
        zOqHEw8hbveXOJhwaZLgeRK/I8Nz0xAhNeInd40mQw==
X-Google-Smtp-Source: AA0mqf7AB6sBWSMI+8Ehf8sccDG+HagnJt5P39Z6LikaoYVGS3f19+SeEcRUvP+EXYmaXlOcavz7RwnDhKwOdLC7de4=
X-Received: by 2002:a05:6871:4609:b0:143:955d:ed7 with SMTP id
 nf9-20020a056871460900b00143955d0ed7mr10432917oab.233.1669800745480; Wed, 30
 Nov 2022 01:32:25 -0800 (PST)
MIME-Version: 1.0
References: <000000000000790da005ee3175a8@google.com> <26b9771db88198ff982476e3e24f411277cd213b.camel@sipsolutions.net>
 <0ee688ac-5c34-1592-23d3-fe100cadc570@linaro.org> <CACT4Y+bxoaskRKAwFGLh7zVNKY7TszJNhLyAo4MrKaWSzyA8wg@mail.gmail.com>
 <1a6abe2b-c382-a283-74a0-5869d2ba102e@linaro.org>
In-Reply-To: <1a6abe2b-c382-a283-74a0-5869d2ba102e@linaro.org>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 30 Nov 2022 10:32:14 +0100
Message-ID: <CACT4Y+bB+FvP1QFUadF=ExMjxPKs4GPYGzbU7hpKya+jUwLKaQ@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in rfkill_blocked
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        =?UTF-8?B?6ams6bqf?= <kylin.formalin@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        syzbot <syzbot+0299462c067009827b2a@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Nov 2022 at 11:15, Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 28/11/2022 11:07, Dmitry Vyukov wrote:
> > On Sun, 27 Nov 2022 at 20:59, Krzysztof Kozlowski
> > <krzysztof.kozlowski@linaro.org> wrote:
> >>
> >> On 25/11/2022 10:09, Johannes Berg wrote:
> >>> Looks like an NFC issue to me, Krzysztof?
> >>>
> >>> I mean, rfkill got allocated by nfc_register_device(), freed by
> >>> nfc_unregister_device(), and then used by nfc_dev_up(). Seems like the
> >>> last bit shouldn't be possible after nfc_unregister_device()?
> >>>
> >>> johannes
> >>>
> >>> On Wed, 2022-11-23 at 22:24 -0800, syzbot wrote:
> >>>> Hello,
> >>>>
> >>>> syzbot found the following issue on:
> >>>>
> >>>> HEAD commit:    0966d385830d riscv: Fix auipc+jalr relocation range checks
> >>>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> >>>> console output: https://syzkaller.appspot.com/x/log.txt?x=11196d0d880000
> >>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=6295d67591064921
> >>>> dashboard link: https://syzkaller.appspot.com/bug?extid=0299462c067009827b2a
> >>>> compiler:       riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> >>>> userspace arch: riscv64
> >>>>
> >>>> Unfortunately, I don't have any reproducer for this issue yet.
> >>>>
> >>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >>>> Reported-by: syzbot+0299462c067009827b2a@syzkaller.appspotmail.com
> >>>>
> >>>> ==================================================================
> >>>> BUG: KASAN: use-after-free in __lock_acquire+0x8ee/0x333e kernel/locking/lockdep.c:4897
> >>>> Read of size 8 at addr ffffaf8024249018 by task syz-executor.0/7946
> >>>>
> >>>> CPU: 0 PID: 7946 Comm: syz-executor.0 Not tainted 5.17.0-rc1-syzkaller-00002-g0966d385830d #0
> >>>> Hardware name: riscv-virtio,qemu (DT)
> >>>> Call Trace:
> >>>> [<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
> >>>> [<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
> >>>> [<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
> >>>> [<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
> >>>> [<ffffffff8047479e>] print_address_description.constprop.0+0x2a/0x330 mm/kasan/report.c:255
> >>>> [<ffffffff80474d4c>] __kasan_report mm/kasan/report.c:442 [inline]
> >>>> [<ffffffff80474d4c>] kasan_report+0x184/0x1e0 mm/kasan/report.c:459
> >>>> [<ffffffff80475b20>] check_region_inline mm/kasan/generic.c:183 [inline]
> >>>> [<ffffffff80475b20>] __asan_load8+0x6e/0x96 mm/kasan/generic.c:256
> >>>> [<ffffffff80112b70>] __lock_acquire+0x8ee/0x333e kernel/locking/lockdep.c:4897
> >>>> [<ffffffff80116582>] lock_acquire.part.0+0x1d0/0x424 kernel/locking/lockdep.c:5639
> >>>> [<ffffffff8011682a>] lock_acquire+0x54/0x6a kernel/locking/lockdep.c:5612
> >>>> [<ffffffff831afa2c>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
> >>>> [<ffffffff831afa2c>] _raw_spin_lock_irqsave+0x3e/0x62 kernel/locking/spinlock.c:162
> >>>> [<ffffffff83034f0a>] rfkill_blocked+0x22/0x62 net/rfkill/core.c:941
> >>>> [<ffffffff830b8862>] nfc_dev_up+0x8e/0x26c net/nfc/core.c:102
> >>>> [<ffffffff830bb742>] nfc_genl_dev_up+0x5e/0x8a net/nfc/netlink.c:770
> >>>> [<ffffffff8296f9ae>] genl_family_rcv_msg_doit+0x19a/0x23c net/netlink/genetlink.c:731
> >>>> [<ffffffff82970420>] genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
> >>>> [<ffffffff82970420>] genl_rcv_msg+0x236/0x3ba net/netlink/genetlink.c:792
> >>>> [<ffffffff8296ded2>] netlink_rcv_skb+0xf8/0x2be net/netlink/af_netlink.c:2494
> >>>> [<ffffffff8296ecb2>] genl_rcv+0x36/0x4c net/netlink/genetlink.c:803
> >>>> [<ffffffff8296cbcc>] netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
> >>>> [<ffffffff8296cbcc>] netlink_unicast+0x40e/0x5fe net/netlink/af_netlink.c:1343
> >>>> [<ffffffff8296d29c>] netlink_sendmsg+0x4e0/0x994 net/netlink/af_netlink.c:1919
> >>>> [<ffffffff826d264e>] sock_sendmsg_nosec net/socket.c:705 [inline]
> >>>> [<ffffffff826d264e>] sock_sendmsg+0xa0/0xc4 net/socket.c:725
> >>>> [<ffffffff826d4dd4>] ____sys_sendmsg+0x46e/0x484 net/socket.c:2413
> >>>> [<ffffffff826d8bca>] ___sys_sendmsg+0x16c/0x1f6 net/socket.c:2467
> >>>> [<ffffffff826d8e78>] __sys_sendmsg+0xba/0x150 net/socket.c:2496
> >>>> [<ffffffff826d8f3a>] __do_sys_sendmsg net/socket.c:2505 [inline]
> >>>> [<ffffffff826d8f3a>] sys_sendmsg+0x2c/0x3a net/socket.c:2503
> >>>> [<ffffffff80005716>] ret_from_syscall+0x0/0x2
> >>>>
> >>>> Allocated by task 7946:
> >>>>  stack_trace_save+0xa6/0xd8 kernel/stacktrace.c:122
> >>>>  kasan_save_stack+0x2c/0x58 mm/kasan/common.c:38
> >>>>  kasan_set_track mm/kasan/common.c:45 [inline]
> >>>>  set_alloc_info mm/kasan/common.c:436 [inline]
> >>>>  ____kasan_kmalloc mm/kasan/common.c:515 [inline]
> >>>>  ____kasan_kmalloc mm/kasan/common.c:474 [inline]
> >>>>  __kasan_kmalloc+0x80/0xb2 mm/kasan/common.c:524
> >>>>  kasan_kmalloc include/linux/kasan.h:270 [inline]
> >>>>  __kmalloc+0x190/0x318 mm/slub.c:4424
> >>>>  kmalloc include/linux/slab.h:586 [inline]
> >>>>  kzalloc include/linux/slab.h:715 [inline]
> >>>>  rfkill_alloc+0x96/0x1aa net/rfkill/core.c:983
> >>>>  nfc_register_device+0xe4/0x29e net/nfc/core.c:1129
> >>>>  nci_register_device+0x538/0x612 net/nfc/nci/core.c:1252
> >>>>  virtual_ncidev_open+0x82/0x12c drivers/nfc/virtual_ncidev.c:143
> >>>>  misc_open+0x272/0x2c8 drivers/char/misc.c:141
> >>>>  chrdev_open+0x1d4/0x478 fs/char_dev.c:414
> >>>>  do_dentry_open+0x2a4/0x7d4 fs/open.c:824
> >>>>  vfs_open+0x52/0x5e fs/open.c:959
> >>>>  do_open fs/namei.c:3476 [inline]
> >>>>  path_openat+0x12b6/0x189e fs/namei.c:3609
> >>>>  do_filp_open+0x10e/0x22a fs/namei.c:3636
> >>>>  do_sys_openat2+0x174/0x31e fs/open.c:1214
> >>>>  do_sys_open fs/open.c:1230 [inline]
> >>>>  __do_sys_openat fs/open.c:1246 [inline]
> >>>>  sys_openat+0xdc/0x164 fs/open.c:1241
> >>>>  ret_from_syscall+0x0/0x2
> >>>>
> >>>> Freed by task 7944:
> >>>>  stack_trace_save+0xa6/0xd8 kernel/stacktrace.c:122
> >>>>  kasan_save_stack+0x2c/0x58 mm/kasan/common.c:38
> >>>>  kasan_set_track+0x1a/0x26 mm/kasan/common.c:45
> >>>>  kasan_set_free_info+0x1e/0x3a mm/kasan/generic.c:370
> >>>>  ____kasan_slab_free mm/kasan/common.c:366 [inline]
> >>>>  ____kasan_slab_free+0x15e/0x180 mm/kasan/common.c:328
> >>>>  __kasan_slab_free+0x10/0x18 mm/kasan/common.c:374
> >>>>  kasan_slab_free include/linux/kasan.h:236 [inline]
> >>>>  slab_free_hook mm/slub.c:1728 [inline]
> >>>>  slab_free_freelist_hook+0x8e/0x1cc mm/slub.c:1754
> >>>>  slab_free mm/slub.c:3509 [inline]
> >>>>  kfree+0xe0/0x3e4 mm/slub.c:4562
> >>>>  rfkill_release+0x20/0x2a net/rfkill/core.c:831
> >>>>  device_release+0x66/0x148 drivers/base/core.c:2229
> >>>>  kobject_cleanup lib/kobject.c:705 [inline]
> >>>>  kobject_release lib/kobject.c:736 [inline]
> >>>>  kref_put include/linux/kref.h:65 [inline]
> >>>>  kobject_put+0x1bc/0x38e lib/kobject.c:753
> >>>>  put_device+0x28/0x3a drivers/base/core.c:3512
> >>>>  rfkill_destroy+0x2a/0x3c net/rfkill/core.c:1142
> >>>>  nfc_unregister_device+0xac/0x232 net/nfc/core.c:1167
> >>>>  nci_unregister_device+0x168/0x182 net/nfc/nci/core.c:1298
> >>>>  virtual_ncidev_close+0x9c/0xbc drivers/nfc/virtual_ncidev.c:163
> >>
> >> There were several issues found recently in virtual NCI driver, so this
> >> might be one of them. There is no reproducer, though...
> >
> >
> > Hi Krzysztof,
> >
> > Do you think it's related specifically to the virtual driver?
>
> Both, although maybe not this particular issue. There were like five
> separate reports last few days...
>
> >
> > I would assume it's a bug in the NCI core itself related to dynamic
> > device destructions. This should affect e.g. USB devices as well.
>
> Earlier this year there was a bigger fix for unregister path in NFC -
> see commits:
> da5c0f119203 (nfc_unregister_device+nfc_fw_download
> ef27324e2c (nci_unregister_device+nci_cmd_work)
> 1b0e81416 (rfkill related)
> and these pointed out inherent issues in locking/synchronization of NFC
> core modules. I don't think we fixed all of the core issues, rather only
> what was reported, so some specific scenarios.
>
> > It's an issue only in the virtual driver. It means that the virtual
> > driver uses the NCI core incorrectly, not the way all real drivers use
> > it. If so the question is: what is the difference? We need to fix it.
> > It's not useful to have unrealistic test drivers -- we both get false
> > positives and don't get true positives.
> >
> > I think the issue may be localized from the KASAN report itself w/o a
> > reproducer.
> > Is there proper synchronization between
> > nfc_unregister_device/rfkill_destroy and nfc_dev_up/rfkill_blocked?
> > Something that prevents rfkill_blocked to be called after
> > rfkill_destroy? If not, then that's the issue.
>
> Mentioned 1b0e81416a tried to do this and that time I had impression fix
> is correct. However it seems it is not... (or not enough)
>
> Best regards,
> Krzysztof


#syz dup: WARNING in nci_send_cmd
