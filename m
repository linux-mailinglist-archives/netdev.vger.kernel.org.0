Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF1F5EE658
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 22:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbiI1UAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 16:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbiI1UAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 16:00:19 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A74A441
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 12:59:37 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id j17so13774235vsp.5
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 12:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=bNBXUpwCRetsQx/CjiQ5MTNGvBxI62ICWnIfR5fYVR0=;
        b=eHI2GPhZ9atU/jeBAlDY6MuX29HnlkE9quVBBquGvhaei7UJchFOKrBCPJlYOoylhI
         zd8/nX5IxU+ouRrpUSd1N5611DIlhjTKMOMZ0uzYqYMBV4Hl7TRn2gK41ug2QM14PANb
         +HFAsYAtwuHkV3mADALm8oWvfsMFqRBohUzvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=bNBXUpwCRetsQx/CjiQ5MTNGvBxI62ICWnIfR5fYVR0=;
        b=b3hG/KobxZSuscwN7qpNMEgx/FHjw8FMjwv31Z8l8CtnQNHwcnnRaltcSHwuHDPc/u
         sV0mIlUd6rA6cDbkXFPik6IQ6Gj/VxeewNdstHKUNSQ5TMeMfsl9iG7r3RRla0FEQK1T
         ZiGdwKYURR0bsK+bpLRkYU68fYMBOylj9C2HtTz+UMQflNbMEHghx0v+AqWFGXe8c3i9
         FEVnG8rw0LeLH6sjHcqW4AuYNilEUUDB0bBm9lXvAWHEHTBxxY6KvM+YWECciVueywMW
         0tecscCpM2oaT8odZlHKYp8tPiItot4h+AxtWoUG2K2JZX+sZUK83VqZBXf9b4haSdne
         38nw==
X-Gm-Message-State: ACrzQf2ge7ty5/b9B9qVekyxwXxsCGx6OkuQLN3SVeVLULMd6ATo5vyQ
        gLbbN6z7es1FRTbiq3o0mrVk2uxJIkcQHrFZNxP1uQ==
X-Google-Smtp-Source: AMsMyM7CwsMqBDd2htVHjt/BZGCtRYEbmzNGzqhElJUdvo5jBqDvSxFTwHmEDgahK9EitIvJEnRhK05TJq158k7gfZE=
X-Received: by 2002:a67:fdd0:0:b0:397:c028:db6a with SMTP id
 l16-20020a67fdd0000000b00397c028db6amr15431274vsq.58.1664395175754; Wed, 28
 Sep 2022 12:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220927095813.v2.1.Ia168b651a69b253059f2bbaa60b98083e619545c@changeid>
 <CABBYNZJkzQfWu_xhtubn=030fi+XLGSx9wMamEMUg8Ly2jpPGg@mail.gmail.com>
In-Reply-To: <CABBYNZJkzQfWu_xhtubn=030fi+XLGSx9wMamEMUg8Ly2jpPGg@mail.gmail.com>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Wed, 28 Sep 2022 12:59:23 -0700
Message-ID: <CANFp7mX_nfzs0YLEs1HJx=W6UQovKvPmRAy6AyftgC8eWrLQqA@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Prevent double register of suspend
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Abhishek Pandit-Subedi <abhishekpandit@google.com>,
        linux-bluetooth@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sure, resending with a v3.

On Wed, Sep 28, 2022 at 12:32 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Abhishek,
>
> On Tue, Sep 27, 2022 at 9:58 AM Abhishek Pandit-Subedi
> <abhishekpandit@google.com> wrote:
> >
> > From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> >
> > Suspend notifier should only be registered and unregistered once per
> > hdev. Simplify this by only registering during driver registration and
> > simply exiting early when HCI_USER_CHANNEL is set.
> >
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Fixes: 359ee4f834f5 (Bluetooth: Unregister suspend with userchannel)
> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > ---
> > This is fixing a syzbot reported warning. Tested in the following ways:
> > * Normal start-up of driver with bluez.
> > * Start/stop loop using HCI_USER_CHANNEL (sock path).
> > * USB reset triggering hci_dev_unregister (driver path).
> >
> > ------------[ cut here ]------------
> > double register detected
> > WARNING: CPU: 0 PID: 2657 at kernel/notifier.c:27
> > notifier_chain_register kernel/notifier.c:27 [inline]
> > WARNING: CPU: 0 PID: 2657 at kernel/notifier.c:27
> > notifier_chain_register+0x5c/0x124 kernel/notifier.c:22
> > Modules linked in:
> > CPU: 0 PID: 2657 Comm: syz-executor212 Not tainted
> > 5.10.136-syzkaller-19376-g6f46a5fe0124 #0
> >     8f0771607702f5ef7184d2ee33bd0acd70219fc4
> >     Hardware name: Google Google Compute Engine/Google Compute Engine,
> >     BIOS Google 07/22/2022
> >     RIP: 0010:notifier_chain_register kernel/notifier.c:27 [inline]
> >     RIP: 0010:notifier_chain_register+0x5c/0x124 kernel/notifier.c:22
> >     Code: 6a 41 00 4c 8b 23 4d 85 e4 0f 84 88 00 00 00 e8 c2 1e 19 00 49
> >     39 ec 75 18 e8 b8 1e 19 00 48 c7 c7 80 6d ca 84 e8 2c 68 48 03 <0f> 0b
> >         e9 af 00 00 00 e8 a0 1e 19 00 48 8d 7d 10 48 89 f8 48 c1 e8
> >         RSP: 0018:ffffc900009d7da8 EFLAGS: 00010286
> >         RAX: 0000000000000000 RBX: ffff8881076fd1d8 RCX: 0000000000000000
> >         RDX: 0000001810895100 RSI: ffff888110895100 RDI: fffff5200013afa7
> >         RBP: ffff88811a4191d0 R08: ffffffff813b8ca1 R09: 0000000080000000
> >         R10: 0000000000000000 R11: 0000000000000005 R12: ffff88811a4191d0
> >         R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
> >         FS: 00005555571f5300(0000) GS:ffff8881f6c00000(0000)
> >         knlGS:0000000000000000
> >         CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >         CR2: 000078e3857f3075 CR3: 000000010d668000 CR4: 00000000003506f0
> >         DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >         DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >         Call Trace:
> >         blocking_notifier_chain_register+0x8c/0xa6 kernel/notifier.c:254
> >         hci_register_suspend_notifier net/bluetooth/hci_core.c:2733
> >         [inline]
> >         hci_register_suspend_notifier+0x6b/0x7c
> >         net/bluetooth/hci_core.c:2727
> >         hci_sock_release+0x270/0x3cf net/bluetooth/hci_sock.c:889
> >         __sock_release+0xcd/0x1de net/socket.c:597
> >         sock_close+0x18/0x1c net/socket.c:1267
> >         __fput+0x418/0x729 fs/file_table.c:281
> >         task_work_run+0x12b/0x15b kernel/task_work.c:151
> >         tracehook_notify_resume include/linux/tracehook.h:188 [inline]
> >         exit_to_user_mode_loop kernel/entry/common.c:165 [inline]
> >         exit_to_user_mode_prepare+0x8f/0x130 kernel/entry/common.c:192
> >         syscall_exit_to_user_mode+0x172/0x1b2 kernel/entry/common.c:268
> >         entry_SYSCALL_64_after_hwframe+0x61/0xc6
> >         RIP: 0033:0x78e38575e1db
> >         Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89
> >         7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05
> >         <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
> >         RSP: 002b:00007ffffc20a0b0 EFLAGS: 00000293 ORIG_RAX:
> >         0000000000000003
> >         RAX: 0000000000000000 RBX: 0000000000000006 RCX: 000078e38575e1db
> >         RDX: ffffffffffffffb8 RSI: 0000000020000000 RDI: 0000000000000005
> >         RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000150
> >         R10: 0000000000000000 R11: 0000000000000293 R12: 000000000000e155
> >         R13: 00007ffffc20a140 R14: 00007ffffc20a130 R15: 00007ffffc20a0e8
> >
> > Changes in v2:
> > - Removed suspend registration from hci_sock.
> > - Exit hci_suspend_notifier early if user channel.
> >
> >  net/bluetooth/hci_core.c | 4 ++++
> >  net/bluetooth/hci_sock.c | 3 ---
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index 66c7cdba0d32..86ce2dd1c7fb 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -2406,6 +2406,10 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
> >                 container_of(nb, struct hci_dev, suspend_notifier);
> >         int ret = 0;
> >
> > +       /* Userspace has full control of this device. Do nothing. */
> > +       if (hci_dev_test_flag(hdev, HCI_USER_CHANNEL))
> > +               return NOTIFY_DONE;
> > +
> >         if (action == PM_SUSPEND_PREPARE)
> >                 ret = hci_suspend_dev(hdev);
> >         else if (action == PM_POST_SUSPEND)
> > diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> > index b2a33a05c93e..06581223238c 100644
> > --- a/net/bluetooth/hci_sock.c
> > +++ b/net/bluetooth/hci_sock.c
> > @@ -887,7 +887,6 @@ static int hci_sock_release(struct socket *sock)
> >                          */
> >                         hci_dev_do_close(hdev);
> >                         hci_dev_clear_flag(hdev, HCI_USER_CHANNEL);
> > -                       hci_register_suspend_notifier(hdev);
> >                         mgmt_index_added(hdev);
> >                 }
> >
> > @@ -1216,7 +1215,6 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
> >                 }
> >
> >                 mgmt_index_removed(hdev);
> > -               hci_unregister_suspend_notifier(hdev);
> >
> >                 err = hci_dev_open(hdev->id);
> >                 if (err) {
> > @@ -1231,7 +1229,6 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
> >                                 err = 0;
> >                         } else {
> >                                 hci_dev_clear_flag(hdev, HCI_USER_CHANNEL);
> > -                               hci_register_suspend_notifier(hdev);
> >                                 mgmt_index_added(hdev);
> >                                 hci_dev_put(hdev);
> >                                 goto done;
> > --
> > 2.37.3.998.g577e59143f-goog
> >
>
> Looks like our CI got stuck for some reason, do you mind sending a v3
> just to confirm nothing breaks with these changes?
>
> --
> Luiz Augusto von Dentz
