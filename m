Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD76F661EFF
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbjAIHGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjAIHGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:06:44 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40678FAC5
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 23:06:43 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d15so8545622pls.6
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 23:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mWQ0kDsyvcih2dH/qpkcVXNF1elAyvevQFayUEjDoXg=;
        b=D7eNMvpLZWjM1JtA6zqqtVuKykRRT/UPqzjlzUUp1rSBd+O+T59BOhfSfcHfUlAx8g
         +icBzLcYYhab5ytZOBEycGIHmDdezmXd6xcqs8KvkOUOdyPJ/aCns6W6ofLmZj2k2158
         5KgIzP4qOJlZVbuYQzIebsozSQ5uCNdUUNJcQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mWQ0kDsyvcih2dH/qpkcVXNF1elAyvevQFayUEjDoXg=;
        b=fD7pQ2/at2hjLguLb0pq47JrYIRoSQACqiiCD1Q18MRbcFDg4/EzjjmMFdLWEy5raQ
         S/ea0SKnWHZvJ9Xn+yf6UjqRiEud1oqMUG18PD853s/JlJgj1ZCrPVYWKwgomVfNQCOr
         h5T3723XoiJYefQKZh1v3+F3kM3zKPR0YIdILrm8seXGjC7vVFxY9oErRNKcjVmXjVNT
         geBB4EwIva2sjKVk+lLF8DuwOoP4dvQVGrlpMkDy6fv6PevHMwKrkNV/Y7NtjrB7XsRb
         UOToEYKEnD9o5RuDCJ0+1rIfp0EcJjW9DtwLXJ5/QyP5Tpv2dn+7sD4gGvEvaAuxdbrw
         mvMA==
X-Gm-Message-State: AFqh2kpZq+Qr9yfm8Yn2U4LP7W0w5aPxiDOycb+Le0V4FCxb9LmDnLHn
        5zoRm4ZcKH0HKaLHvXjkUji2fesirK3L7C0LcFA=
X-Google-Smtp-Source: AMrXdXtaYT5b05t7gNWohktQPuyAA5JTu1D7cYC6iANmFQO5aJC7XtyvCf1oSZMl+C+j3FC1K0J9Ig==
X-Received: by 2002:a17:90a:6a41:b0:225:f792:734d with SMTP id d1-20020a17090a6a4100b00225f792734dmr52063900pjm.7.1673248002638;
        Sun, 08 Jan 2023 23:06:42 -0800 (PST)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com. [209.85.216.43])
        by smtp.gmail.com with ESMTPSA id fv16-20020a17090b0e9000b00218daa55e5fsm4815439pjb.12.2023.01.08.23.06.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jan 2023 23:06:41 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso11815352pjp.4
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 23:06:40 -0800 (PST)
X-Received: by 2002:a17:902:9883:b0:193:1c8f:182f with SMTP id
 s3-20020a170902988300b001931c8f182fmr347084plp.14.1673247999674; Sun, 08 Jan
 2023 23:06:39 -0800 (PST)
MIME-Version: 1.0
References: <20230104150642.v2.1.I1f29bb547a03e9adfe2e6754212f9d14a2e39c4b@changeid>
 <CABBYNZL9FiZjRYJE_h4n2kf9LKv_5XF3Fd=bz=cU4bTcDR-QHQ@mail.gmail.com>
 <Y7d26dhGXOij+xSO@x130> <CABBYNZ+0DsjdQ4z2CEj95VnyR9Nnsemq7FCWYwO=M1gz3WD+=Q@mail.gmail.com>
In-Reply-To: <CABBYNZ+0DsjdQ4z2CEj95VnyR9Nnsemq7FCWYwO=M1gz3WD+=Q@mail.gmail.com>
From:   Ying Hsu <yinghsu@chromium.org>
Date:   Mon, 9 Jan 2023 15:06:03 +0800
X-Gmail-Original-Message-ID: <CAAa9mD2UYXi+9GpGypOoo119TckDSHc_SDHXrEWAqd3-FsFhtA@mail.gmail.com>
Message-ID: <CAAa9mD2UYXi+9GpGypOoo119TckDSHc_SDHXrEWAqd3-FsFhtA@mail.gmail.com>
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

Hi Luiz,

Based on the stack trace reported by syzbot, the deadlock happened in
a single process.
I'll revise the commit message in the next revision. Thank you for
catching that.

Generalizing it sounds good.
But if it releases the sk lock as below, the do_something() part might
be different for different proto.
```
bt_sock_connect_v1(..., callback) {
    sock_hold(sk);
    release_sock(sk);
    err = callback(...);
    lock_sock(sk);
    if (!err && !sock_flag(sk, SOCK_ZAPPED)) {
        do_something();
    }
    sock_put(sk);
    return err;
}
```

Another proposal is to have the callback executed with sk lock
acquired, and the callback is almost the same as the original connect
function for each proto,
but they'll have to manage the sk lock and check its ZAPPED state.
What do you think?
```
bt_sock_connect_v2(..., callback) {
    sock_hold(sk);
    lock_sock(sk);
    err = callback(...);
    release_sock(sk);
    sock_put(sk);
    return err;
}

rfcomm_sock_connect(...) {
    return bt_sock_connect_v2(..., __rfcomm_sock_connect);
}
```


On Sat, Jan 7, 2023 at 3:45 AM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Saeed,
>
> On Thu, Jan 5, 2023 at 5:18 PM Saeed Mahameed <saeed@kernel.org> wrote:
> >
> > On 04 Jan 14:21, Luiz Augusto von Dentz wrote:
> > >Hi Ying,
> > >
> > >On Wed, Jan 4, 2023 at 7:07 AM Ying Hsu <yinghsu@chromium.org> wrote:
> > >>
> > >> There's a possible deadlock when two processes are connecting
> > >> and closing a RFCOMM socket concurrently. Here's the call trace:
> > >
> > >Are you sure it is 2 different processes? Usually that would mean 2
> > >different sockets (sk) then so they wouldn't share the same lock, so
> > >this sounds more like 2 different threads, perhaps it is worth
> > >creating a testing case in our rfcomm-tester so we are able to detect
> > >this sort of thing in the future.
> > >
> > >> -> #2 (&d->lock){+.+.}-{3:3}:
> > >>        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
> > >>        __mutex_lock0x12f/0x1360 kernel/locking/mutex.c:747
> > >>        __rfcomm_dlc_close+0x15d/0x890 net/bluetooth/rfcomm/core.c:487
> > >>        rfcomm_dlc_close+1e9/0x240 net/bluetooth/rfcomm/core.c:520
> > >>        __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
> > >>        rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
> > >>        rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
> > >>        __sock_release+0xcd/0x280 net/socket.c:650
> > >>        sock_close+0x1c/0x20 net/socket.c:1365
> > >>        __fput+0x27c/0xa90 fs/file_table.c:320
> > >>        task_work_run+0x16f/0x270 kernel/task_work.c:179
> > >>        exit_task_work include/linux/task_work.h:38 [inline]
> > >>        do_exit+0xaa8/0x2950 kernel/exit.c:867
> > >>        do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
> > >>        get_signal+0x21c3/0x2450 kernel/signal.c:2859
> > >>        arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
> > >>        exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> > >>        exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
> > >>        __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
> > >>        syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
> > >>        do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
> > >>        entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > >>
> > >> -> #1 (rfcomm_mutex){+.+.}-{3:3}:
> > >>        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
> > >>        __mutex_lock+0x12f/0x1360 kernel/locking/mutex.c:747
> > >>        rfcomm_dlc_open+0x93/0xa80 net/bluetooth/rfcomm/core.c:425
> > >>        rfcomm_sock_connect+0x329/0x450 net/bluetooth/rfcomm/sock.c:413
> > >>        __sys_connect_file+0x153/0x1a0 net/socket.c:1976
> > >>        __sys_connect+0x165/0x1a0 net/socket.c:1993
> > >>        __do_sys_connect net/socket.c:2003 [inline]
> > >>        __se_sys_connect net/socket.c:2000 [inline]
> > >>        __x64_sys_connect+0x73/0xb0 net/socket.c:2000
> > >>        do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >>        do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> > >>        entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > >>
> > >> -> #0 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}:
> > >>        check_prev_add kernel/locking/lockdep.c:3097 [inline]
> > >>        check_prevs_add kernel/locking/lockdep.c:3216 [inline]
> > >>        validate_chain kernel/locking/lockdep.c:3831 [inline]
> > >>        __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
> > >>        lock_acquire kernel/locking/lockdep.c:5668 [inline]
> > >>        lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
> > >>        lock_sock_nested+0x3a/0xf0 net/core/sock.c:3470
> > >>        lock_sock include/net/sock.h:1725 [inline]
> > >>        rfcomm_sk_state_change+0x6d/0x3a0 net/bluetooth/rfcomm/sock.c:73
> > >>        __rfcomm_dlc_close+0x1b1/0x890 net/bluetooth/rfcomm/core.c:489
> > >>        rfcomm_dlc_close+0x1e9/0x240 net/bluetooth/rfcomm/core.c:520
> > >>        __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
> > >>        rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
> > >>        rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
> > >>        __sock_release+0xcd/0x280 net/socket.c:650
> > >>        sock_close+0x1c/0x20 net/socket.c:1365
> > >>        __fput+0x27c/0xa90 fs/file_table.c:320
> > >>        task_work_run+0x16f/0x270 kernel/task_work.c:179
> > >>        exit_task_work include/linux/task_work.h:38 [inline]
> > >>        do_exit+0xaa8/0x2950 kernel/exit.c:867
> > >>        do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
> > >>        get_signal+0x21c3/0x2450 kernel/signal.c:2859
> > >>        arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
> > >>        exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> > >>        exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
> > >>        __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
> > >>        syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
> > >>        do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
> > >>        entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > >>
> > >> Signed-off-by: Ying Hsu <yinghsu@chromium.org>
> > >> ---
> > >> This commit has been tested with a C reproducer on qemu-x86_64
> > >> and a ChromeOS device.
> > >>
> > >> Changes in v2:
> > >> - Fix potential use-after-free in rfc_comm_sock_connect.
> > >>
> > >>  net/bluetooth/rfcomm/sock.c | 7 ++++++-
> > >>  1 file changed, 6 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
> > >> index 21e24da4847f..4397e14ff560 100644
> > >> --- a/net/bluetooth/rfcomm/sock.c
> > >> +++ b/net/bluetooth/rfcomm/sock.c
> > >> @@ -391,6 +391,7 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
> > >>             addr->sa_family != AF_BLUETOOTH)
> > >>                 return -EINVAL;
> > >>
> > >> +       sock_hold(sk);
> > >>         lock_sock(sk);
> > >>
> > >>         if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
> > >> @@ -410,14 +411,18 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
> > >>         d->sec_level = rfcomm_pi(sk)->sec_level;
> > >>         d->role_switch = rfcomm_pi(sk)->role_switch;
> > >>
> > >> +       /* Drop sock lock to avoid potential deadlock with the RFCOMM lock */
> > >> +       release_sock(sk);
> > >>         err = rfcomm_dlc_open(d, &rfcomm_pi(sk)->src, &sa->rc_bdaddr,
> > >>                               sa->rc_channel);
> > >> -       if (!err)
> > >> +       lock_sock(sk);
> > >> +       if (!err && !sock_flag(sk, SOCK_ZAPPED))
> > >>                 err = bt_sock_wait_state(sk, BT_CONNECTED,
> > >>                                 sock_sndtimeo(sk, flags & O_NONBLOCK));
> > >>
> > >>  done:
> > >>         release_sock(sk);
> > >> +       sock_put(sk);
> > >>         return err;
> > >>  }
> > >
> > >This sounds like a great solution to hold the reference and then
> >
> > Why do you need sock_hold/put in the same proto_ops.callback sock opts ?
> > it should be guaranteed by the caller the sk will remain valid
> > or if you are paranoid then sock_hold() on your proto_ops.bind() and put()
> > on your proto_ops.release()
>
> It doesn't looks like there is a sock_hold done in the likes of
> __sys_connect/__sys_connect_file so afaik it is possible that the sk
> is freed in the meantime if we attempt to release and lock afterward,
> and about being paranoid I guess we are past that already since with
> the likes of fuzzing testing is already paranoid in itself.
>
> > >checking if the socket has been zapped when attempting to lock_sock,
> > >so Ive been thinking on generalize this into something like
> > >bt_sock_connect(sock, addr, alen, callback) so we make sure the
> > >callback is done while holding a reference but with the socket
> > >unlocked since typically the underline procedure only needs to access
> > >the pi(sk) information without changing it e.g. rfcomm_dlc_open,
> > >anyway Im fine if you don't want to pursue doing it right now but I'm
> > >afraid these type of locking problem is no restricted to RFCOMM only.
> > >
> > >> --
> > >> 2.39.0.314.g84b9a713c41-goog
> > >>
> > >
> > >
> > >--
> > >Luiz Augusto von Dentz
>
>
>
> --
> Luiz Augusto von Dentz
