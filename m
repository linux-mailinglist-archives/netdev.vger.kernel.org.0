Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBD66EC750
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 09:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbjDXHnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 03:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjDXHnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 03:43:20 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18CEE3
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 00:43:17 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4efea87c578so2168e87.1
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 00:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682322196; x=1684914196;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XWKez64uXF0lxIyjlea8Na3PXa06xwVvpVBYUxO4AWo=;
        b=ZsM+fLB2+s8hh50+Gu8PmJKVHinSjqXtwQ13WMKUvMoSPq0rZx2J8pxHTgXirbmEYy
         hw+pvIfiK9bNiauGc6QNVexMbd7sBoKwBRYV1Eh34vWgLbuUPIiUgz+P69PtuoBYVFX/
         JkBzX6lKTDR1AV3nNfzGXReHPn7S5Sr3HP5mQVeisK5ih4vgfRnVENiQEFaF6dYA1Uz9
         nRCrKcM43Rh3JdgNhGiCcnyoxin6hrO7t5e1iiO8Brm6WgYKlRSqIc95rEVCZmjhQ7X3
         KESDOM4v6ZNyZ3IcwiLAYozQkFN16iwvepiCHpRmI0+vAbWxQ3C+7D58sbSTetMrOIRr
         C1Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682322196; x=1684914196;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XWKez64uXF0lxIyjlea8Na3PXa06xwVvpVBYUxO4AWo=;
        b=Mjq18/sA0NPnZlY2DuTgJY63R5H0RDWu4vvovdv37jV76Tw826GrInfchqaYxOFm2K
         fbtw1ZUxC7eK44jmwA8KFV9uy8XZxeWKRA8JZ/mbPVCfVxtHGN3akGKY8VfQv3FMySkP
         Vytoq1jmsOUupoYBtB7o2X9W8AlZv7rKTFpD82uJsXzfrjSrypG2l646W332oKIPQFzr
         Nla6MeT6vKdh8Pk1WDIyeSE4SfY5HLMrKK6BAcUb1OklnXLYtX9vQ1kJncOG4nS2zc3A
         DK2YFEdRma2+OpxWCVKCqPQxMlJI/N6ZIEGvK6lIHGNpuHhOX9QIvE+gP4penSQ4eUq5
         njhw==
X-Gm-Message-State: AAQBX9deGtsP3pHUDWTNCJSEXX+BPdyNPLjqMU0SrI+KlBgLjOzEhNb6
        dWf7xi65H8mM8CiN/CFWm/hRVsKv5oLhIGLoPAW+9A==
X-Google-Smtp-Source: AKy350YuT/e5Z03klGMzn+0ke3erqJ0xhgwE7X2C1HUSnDE7vI9L13jM1eFvztiAq833VbI5xSoheAmM8xUKIGgOKxE=
X-Received: by 2002:a05:6512:12ce:b0:4e8:3f1e:de43 with SMTP id
 p14-20020a05651212ce00b004e83f1ede43mr219358lfg.7.1682322195956; Mon, 24 Apr
 2023 00:43:15 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006efbbe05fa0fd886@google.com>
In-Reply-To: <0000000000006efbbe05fa0fd886@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 24 Apr 2023 09:43:03 +0200
Message-ID: <CACT4Y+Z1m2F368m1YLXQQP2TgM_1YSLYjU5z8LFGTjgnyXi8_g@mail.gmail.com>
Subject: Re: [syzbot] [nfc?] KCSAN: data-race in __list_del_entry_valid / nfc_llcp_register_device
To:     syzbot <syzbot+742c192afb1b2a0cbe86@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Apr 2023 at 09:20, syzbot
<syzbot+742c192afb1b2a0cbe86@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    44149752e998 Merge tag 'cgroup-for-6.3-rc6-fixes' of git:/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1682221fc80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=710057cbb8def08c
> dashboard link: https://syzkaller.appspot.com/bug?extid=742c192afb1b2a0cbe86
> compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/7bfa303f05cc/disk-44149752.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/4e8ea8730409/vmlinux-44149752.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e584bce13ba7/bzImage-44149752.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+742c192afb1b2a0cbe86@syzkaller.appspotmail.com

Concurrent list modifications can lead to arbitrary memory corruptions.

> ==================================================================
> BUG: KCSAN: data-race in __list_del_entry_valid / nfc_llcp_register_device
>
> read to 0xffff88810318c808 of 8 bytes by task 28453 on cpu 1:
>  __list_del_entry_valid+0x15/0xe0 lib/list_debug.c:46
>  __list_del_entry include/linux/list.h:134 [inline]
>  list_del include/linux/list.h:148 [inline]
>  local_release net/nfc/llcp_core.c:172 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  nfc_llcp_local_put net/nfc/llcp_core.c:182 [inline]
>  nfc_llcp_unregister_device+0x7e/0x130 net/nfc/llcp_core.c:1620
>  nfc_unregister_device+0xe6/0x130 net/nfc/core.c:1179
>  nci_unregister_device+0x14c/0x160 net/nfc/nci/core.c:1303
>  virtual_ncidev_close+0x30/0x50 drivers/nfc/virtual_ncidev.c:163
>  __fput+0x245/0x570 fs/file_table.c:321
>  ____fput+0x15/0x20 fs/file_table.c:349
>  task_work_run+0x123/0x160 kernel/task_work.c:179
>  resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>  exit_to_user_mode_loop+0xd1/0xe0 kernel/entry/common.c:171
>  exit_to_user_mode_prepare+0x6c/0xb0 kernel/entry/common.c:204
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
>  syscall_exit_to_user_mode+0x26/0x140 kernel/entry/common.c:297
>  do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> write to 0xffff88810318c808 of 8 bytes by task 28459 on cpu 0:
>  __list_add include/linux/list.h:72 [inline]
>  list_add include/linux/list.h:88 [inline]
>  nfc_llcp_register_device+0x3e4/0x440 net/nfc/llcp_core.c:1604
>  nfc_register_device+0x67/0x190 net/nfc/core.c:1124
>  nci_register_device+0x4e6/0x570 net/nfc/nci/core.c:1257
>  virtual_ncidev_open+0xdc/0x140 drivers/nfc/virtual_ncidev.c:148
>  misc_open+0x1fd/0x230 drivers/char/misc.c:165
>  chrdev_open+0x349/0x3c0 fs/char_dev.c:414
>  do_dentry_open+0x5b3/0x930 fs/open.c:920
>  vfs_open+0x47/0x50 fs/open.c:1051
>  do_open fs/namei.c:3560 [inline]
>  path_openat+0x17e6/0x1d00 fs/namei.c:3715
>  do_filp_open+0xf6/0x200 fs/namei.c:3742
>  do_sys_openat2+0xb5/0x2a0 fs/open.c:1348
>  do_sys_open fs/open.c:1364 [inline]
>  __do_sys_openat fs/open.c:1380 [inline]
>  __se_sys_openat fs/open.c:1375 [inline]
>  __x64_sys_openat+0xf3/0x120 fs/open.c:1375
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> value changed: 0xffffffff85eac670 -> 0xdead000000000122
>
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 0 PID: 28459 Comm: syz-executor.0 Not tainted 6.3.0-rc6-syzkaller-00138-g44149752e998 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
> ==================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000006efbbe05fa0fd886%40google.com.
