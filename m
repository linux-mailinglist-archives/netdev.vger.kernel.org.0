Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D97663726
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 03:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjAJCQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 21:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbjAJCQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 21:16:11 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8363FB7CF
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 18:16:09 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d15so11667932pls.6
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 18:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XsZv/wqW0R/rHACzpDFalIBlwWn8WJeb71dj3WiogXE=;
        b=LEOKXTVJEmt41vHHt2pxhwmlQsw8FBclUwcVlPGN4oQZlwmrWVvIFE0O00XlljlNTe
         Cvr95JTGjqmKTrVJZ0KY3UQvHmooP9mTnjkoOI2t/xNXHeNFX2p13+kmkH7fevFO+TUJ
         xjLN3dF04dr/03O38OCnxF57GcfHDR6O5Blj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XsZv/wqW0R/rHACzpDFalIBlwWn8WJeb71dj3WiogXE=;
        b=AP2yWqEgr5P/siT4W2YiFOQdvRlWpgZshBjLtdTmG8hug+Op/oY/pGJOwHIVKi/Uk1
         GXLj/08KDdj6FqM6dOseAikdJnwfIPx3GwlyszMzWj01+hSDJgehwm06AsEpn+WVGqdI
         l+b4rHfRRgUxqB/rcBKwODSfXVy3f/KtZCc8i2WY6mo1K6JzrQxJOiNilWR49qW6puTp
         FnBLlancmgCGZ9OhN6vWVPc9jM7AL7rAu3Ypul8sZKtuXLki5prnsvsFJhHP0mN4xi28
         NtDwr4LJzudZsvsFn7wND+US2TldhOHtwj7ZoDGPMgiLYaHQmJsXyrZPLXNIe8OFClrj
         6cTg==
X-Gm-Message-State: AFqh2kqo9CWX495BOZi41IlvNCMxyIq/j+6btJOR8E9nd4Ey2AsswnGl
        Bf81V406cHZ7aCony2rgdLa2yalU0AvRtimvn7c=
X-Google-Smtp-Source: AMrXdXt6D467f+/vVrWQ+gG8Wnlal/8a93BPTXc+GPpO29rS4NPF10T1PpsKknC6KxBA/qvmOhd3Sg==
X-Received: by 2002:a05:6a20:d68f:b0:a2:edab:aa73 with SMTP id it15-20020a056a20d68f00b000a2edabaa73mr18517043pzb.25.1673316968876;
        Mon, 09 Jan 2023 18:16:08 -0800 (PST)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com. [209.85.215.176])
        by smtp.gmail.com with ESMTPSA id r2-20020aa79882000000b0057447bb0ddcsm6726021pfl.49.2023.01.09.18.16.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 18:16:06 -0800 (PST)
Received: by mail-pg1-f176.google.com with SMTP id b12so7224779pgj.6
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 18:16:06 -0800 (PST)
X-Received: by 2002:a63:490b:0:b0:4b5:36a7:5583 with SMTP id
 w11-20020a63490b000000b004b536a75583mr252020pga.360.1673316965562; Mon, 09
 Jan 2023 18:16:05 -0800 (PST)
MIME-Version: 1.0
References: <20230104150642.v2.1.I1f29bb547a03e9adfe2e6754212f9d14a2e39c4b@changeid>
 <CABBYNZL9FiZjRYJE_h4n2kf9LKv_5XF3Fd=bz=cU4bTcDR-QHQ@mail.gmail.com>
 <Y7d26dhGXOij+xSO@x130> <CABBYNZ+0DsjdQ4z2CEj95VnyR9Nnsemq7FCWYwO=M1gz3WD+=Q@mail.gmail.com>
 <CAAa9mD3hybWw0cZ9_p2ZWKQFFmPUvsj3efOB_j9VLd_4RgcmPA@mail.gmail.com> <CABBYNZ+3OaN3iyEgz1tT6g5KBjT+Jmsj20J8KxtiMz9RQwBDag@mail.gmail.com>
In-Reply-To: <CABBYNZ+3OaN3iyEgz1tT6g5KBjT+Jmsj20J8KxtiMz9RQwBDag@mail.gmail.com>
From:   Ying Hsu <yinghsu@chromium.org>
Date:   Tue, 10 Jan 2023 10:15:29 +0800
X-Gmail-Original-Message-ID: <CAAa9mD2JOd70hduDKTqe_rQZ-cLsU3xq9Ei_yu-qDkduCaJ6dQ@mail.gmail.com>
Message-ID: <CAAa9mD2JOd70hduDKTqe_rQZ-cLsU3xq9Ei_yu-qDkduCaJ6dQ@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Fix possible deadlock in rfcomm_sk_state_change
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, linux-bluetooth@vger.kernel.org,
        marcel@holtmann.org, leon@kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sure, let me wrap up the fix for RFCOMM in the next patchset first. We
can follow the generic fix in other patches.

On Tue, Jan 10, 2023 at 1:20 AM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Ying,
>
> On Sat, Jan 7, 2023 at 4:35 AM Ying Hsu <yinghsu@chromium.org> wrote:
> >
> > Hi Luiz,
> >
> > Based on the stack trace reported by syzbot, the deadlock happened in a single process.
> > I'll revise the commit message in the next revision. Thank you for catching that.
> >
> > Generalizing it sounds good.
> > But if it releases the sk lock as below, the do_something() part might be different for different proto.
> > ```
> > bt_sock_connect_v1(..., callback) {
> >     sock_hold(sk);
> >     release_sock(sk);
> >     err = callback(...);
> >     lock_sock(sk);
> >     if (!err && !sock_flag(sk, SOCK_ZAPPED)) {
> >         do_something();
> >     }
> >     sock_put(sk);
> >     return err;
> > }
> > ```
> >
> > Another proposal is to have the callback executed with sk lock acquired, and the callback is almost the same as the original connect function for each proto,
> > but they'll have to manage the sk lock and check its ZAPPED state. What do you think?
> > ```
> > bt_sock_connect_v2(..., callback) {
> >     sock_hold(sk);
> >     lock_sock(sk);
> >     err = callback(...);
> >     release_sock(sk);
> >     sock_put(sk);
> >     return err;
> > }
> >
> > rfcomm_sock_connect(...) {
> >     return bt_sock_connect_v2(..., __rfcomm_sock_connect);
> > }
> > ```
>
> I think it is worth trying to prototype both and see which one we end
> up consolidating more code since we might as well do the likes the
> likes of bt_sock_wait_state, we could also in theory have a parameter
> which indicates if the callback expects the sk to be locked or not.
>
> > On Sat, Jan 7, 2023 at 3:45 AM Luiz Augusto von Dentz <luiz.dentz@gmail.com> wrote:
> >>
> >> Hi Saeed,
> >>
> >> On Thu, Jan 5, 2023 at 5:18 PM Saeed Mahameed <saeed@kernel.org> wrote:
> >> >
> >> > On 04 Jan 14:21, Luiz Augusto von Dentz wrote:
> >> > >Hi Ying,
> >> > >
> >> > >On Wed, Jan 4, 2023 at 7:07 AM Ying Hsu <yinghsu@chromium.org> wrote:
> >> > >>
> >> > >> There's a possible deadlock when two processes are connecting
> >> > >> and closing a RFCOMM socket concurrently. Here's the call trace:
> >> > >
> >> > >Are you sure it is 2 different processes? Usually that would mean 2
> >> > >different sockets (sk) then so they wouldn't share the same lock, so
> >> > >this sounds more like 2 different threads, perhaps it is worth
> >> > >creating a testing case in our rfcomm-tester so we are able to detect
> >> > >this sort of thing in the future.
> >> > >
> >> > >> -> #2 (&d->lock){+.+.}-{3:3}:
> >> > >>        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
> >> > >>        __mutex_lock0x12f/0x1360 kernel/locking/mutex.c:747
> >> > >>        __rfcomm_dlc_close+0x15d/0x890 net/bluetooth/rfcomm/core.c:487
> >> > >>        rfcomm_dlc_close+1e9/0x240 net/bluetooth/rfcomm/core.c:520
> >> > >>        __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
> >> > >>        rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
> >> > >>        rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
> >> > >>        __sock_release+0xcd/0x280 net/socket.c:650
> >> > >>        sock_close+0x1c/0x20 net/socket.c:1365
> >> > >>        __fput+0x27c/0xa90 fs/file_table.c:320
> >> > >>        task_work_run+0x16f/0x270 kernel/task_work.c:179
> >> > >>        exit_task_work include/linux/task_work.h:38 [inline]
> >> > >>        do_exit+0xaa8/0x2950 kernel/exit.c:867
> >> > >>        do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
> >> > >>        get_signal+0x21c3/0x2450 kernel/signal.c:2859
> >> > >>        arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
> >> > >>        exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> >> > >>        exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
> >> > >>        __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
> >> > >>        syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
> >> > >>        do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
> >> > >>        entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >> > >>
> >> > >> -> #1 (rfcomm_mutex){+.+.}-{3:3}:
> >> > >>        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
> >> > >>        __mutex_lock+0x12f/0x1360 kernel/locking/mutex.c:747
> >> > >>        rfcomm_dlc_open+0x93/0xa80 net/bluetooth/rfcomm/core.c:425
> >> > >>        rfcomm_sock_connect+0x329/0x450 net/bluetooth/rfcomm/sock.c:413
> >> > >>        __sys_connect_file+0x153/0x1a0 net/socket.c:1976
> >> > >>        __sys_connect+0x165/0x1a0 net/socket.c:1993
> >> > >>        __do_sys_connect net/socket.c:2003 [inline]
> >> > >>        __se_sys_connect net/socket.c:2000 [inline]
> >> > >>        __x64_sys_connect+0x73/0xb0 net/socket.c:2000
> >> > >>        do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >> > >>        do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >> > >>        entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >> > >>
> >> > >> -> #0 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}:
> >> > >>        check_prev_add kernel/locking/lockdep.c:3097 [inline]
> >> > >>        check_prevs_add kernel/locking/lockdep.c:3216 [inline]
> >> > >>        validate_chain kernel/locking/lockdep.c:3831 [inline]
> >> > >>        __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
> >> > >>        lock_acquire kernel/locking/lockdep.c:5668 [inline]
> >> > >>        lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
> >> > >>        lock_sock_nested+0x3a/0xf0 net/core/sock.c:3470
> >> > >>        lock_sock include/net/sock.h:1725 [inline]
> >> > >>        rfcomm_sk_state_change+0x6d/0x3a0 net/bluetooth/rfcomm/sock.c:73
> >> > >>        __rfcomm_dlc_close+0x1b1/0x890 net/bluetooth/rfcomm/core.c:489
> >> > >>        rfcomm_dlc_close+0x1e9/0x240 net/bluetooth/rfcomm/core.c:520
> >> > >>        __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
> >> > >>        rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
> >> > >>        rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
> >> > >>        __sock_release+0xcd/0x280 net/socket.c:650
> >> > >>        sock_close+0x1c/0x20 net/socket.c:1365
> >> > >>        __fput+0x27c/0xa90 fs/file_table.c:320
> >> > >>        task_work_run+0x16f/0x270 kernel/task_work.c:179
> >> > >>        exit_task_work include/linux/task_work.h:38 [inline]
> >> > >>        do_exit+0xaa8/0x2950 kernel/exit.c:867
> >> > >>        do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
> >> > >>        get_signal+0x21c3/0x2450 kernel/signal.c:2859
> >> > >>        arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
> >> > >>        exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> >> > >>        exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
> >> > >>        __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
> >> > >>        syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
> >> > >>        do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
> >> > >>        entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >> > >>
> >> > >> Signed-off-by: Ying Hsu <yinghsu@chromium.org>
> >> > >> ---
> >> > >> This commit has been tested with a C reproducer on qemu-x86_64
> >> > >> and a ChromeOS device.
> >> > >>
> >> > >> Changes in v2:
> >> > >> - Fix potential use-after-free in rfc_comm_sock_connect.
> >> > >>
> >> > >>  net/bluetooth/rfcomm/sock.c | 7 ++++++-
> >> > >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >> > >>
> >> > >> diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
> >> > >> index 21e24da4847f..4397e14ff560 100644
> >> > >> --- a/net/bluetooth/rfcomm/sock.c
> >> > >> +++ b/net/bluetooth/rfcomm/sock.c
> >> > >> @@ -391,6 +391,7 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
> >> > >>             addr->sa_family != AF_BLUETOOTH)
> >> > >>                 return -EINVAL;
> >> > >>
> >> > >> +       sock_hold(sk);
> >> > >>         lock_sock(sk);
> >> > >>
> >> > >>         if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
> >> > >> @@ -410,14 +411,18 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
> >> > >>         d->sec_level = rfcomm_pi(sk)->sec_level;
> >> > >>         d->role_switch = rfcomm_pi(sk)->role_switch;
> >> > >>
> >> > >> +       /* Drop sock lock to avoid potential deadlock with the RFCOMM lock */
> >> > >> +       release_sock(sk);
> >> > >>         err = rfcomm_dlc_open(d, &rfcomm_pi(sk)->src, &sa->rc_bdaddr,
> >> > >>                               sa->rc_channel);
> >> > >> -       if (!err)
> >> > >> +       lock_sock(sk);
> >> > >> +       if (!err && !sock_flag(sk, SOCK_ZAPPED))
> >> > >>                 err = bt_sock_wait_state(sk, BT_CONNECTED,
> >> > >>                                 sock_sndtimeo(sk, flags & O_NONBLOCK));
> >> > >>
> >> > >>  done:
> >> > >>         release_sock(sk);
> >> > >> +       sock_put(sk);
> >> > >>         return err;
> >> > >>  }
> >> > >
> >> > >This sounds like a great solution to hold the reference and then
> >> >
> >> > Why do you need sock_hold/put in the same proto_ops.callback sock opts ?
> >> > it should be guaranteed by the caller the sk will remain valid
> >> > or if you are paranoid then sock_hold() on your proto_ops.bind() and put()
> >> > on your proto_ops.release()
> >>
> >> It doesn't looks like there is a sock_hold done in the likes of
> >> __sys_connect/__sys_connect_file so afaik it is possible that the sk
> >> is freed in the meantime if we attempt to release and lock afterward,
> >> and about being paranoid I guess we are past that already since with
> >> the likes of fuzzing testing is already paranoid in itself.
> >>
> >> > >checking if the socket has been zapped when attempting to lock_sock,
> >> > >so Ive been thinking on generalize this into something like
> >> > >bt_sock_connect(sock, addr, alen, callback) so we make sure the
> >> > >callback is done while holding a reference but with the socket
> >> > >unlocked since typically the underline procedure only needs to access
> >> > >the pi(sk) information without changing it e.g. rfcomm_dlc_open,
> >> > >anyway Im fine if you don't want to pursue doing it right now but I'm
> >> > >afraid these type of locking problem is no restricted to RFCOMM only.
> >> > >
> >> > >> --
> >> > >> 2.39.0.314.g84b9a713c41-goog
> >> > >>
> >> > >
> >> > >
> >> > >--
> >> > >Luiz Augusto von Dentz
> >>
> >>
> >>
> >> --
> >> Luiz Augusto von Dentz
>
>
>
> --
> Luiz Augusto von Dentz
