Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6A5662C89
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 18:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbjAIRUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 12:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbjAIRUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:20:06 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62463192BE;
        Mon,  9 Jan 2023 09:20:04 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id x37so9590439ljq.1;
        Mon, 09 Jan 2023 09:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1UZ9Z2WXOtLgyCB4HElB1cF2XqHAdKNSqOxl/kT1CWc=;
        b=AfXZvMN+3SI6FXgRY5ThxTi62roQvdJ6QA7TSGgi6F470fByeAtN+pXZllGfImSqjD
         H+zaKGI0KDBeKiLW501Gysbfyvn82XqkBa1k+FOWV1SlnGDxhTLdi4OSU8kNh2dsqpgY
         i3Y/Ou1UfiDEjRUCeRPbUf6w4yh8ji4Z9+obTfB3lQRyK7zZP9eGWOGwtqgTE++SocSk
         jC6D2OMnDCUQ1LRoRkeDjKd0kcTsd/64hWW0dRIPywEonMfF03PBjeMJ0irnvFtayy9F
         yEzRtx344VT9cob4r68kV56gxtFFOwcX8J2ohncxIOYphtaR7o+QGVL4M61rY4WJWWUy
         8Slw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1UZ9Z2WXOtLgyCB4HElB1cF2XqHAdKNSqOxl/kT1CWc=;
        b=p7XWkMbnEQWQYCRVtRLls/zuMDs5mk3dV/2kBpUloshg9A60f1OccMePl0/7tWifOj
         mMuhvuTloQMXb8KZCi5Pzsf8gsCk3uXQCS6YuXGRqDjuUdEmehnVMbHXHFAaVP6X6xIv
         6TtuFTOoRnAB/GYm8WgIqAUFr7Zx7i4vPaj84B0prBjbVqKnnwpU1iRQEf/8BsXaZSpt
         kA6UqBNOeqexKBzrePEFHvH8cXbbP4BpltsSdedmCDHc3bHQ8rXRdoMa0WSxCLHuoCnb
         bHvvetOJcDFyDQ5FAMp7OEZQi7wbTiyxfuyOvvtw+vT4+/hImKW7EMpLYVse6FrhGZQm
         zrjg==
X-Gm-Message-State: AFqh2kop+XsvCE4bQcQi2KGRRnHKoaYQn68nPmBtnn+waIshPp9DGZ4X
        G9KcN99NFNRw3z1SQ8yBxitwLHgxOy5bqr646UslmeSZeok=
X-Google-Smtp-Source: AMrXdXv10u76CqZep83J6Bv2wELC/VOKqXbHrfwcvH5E51vAXVtzqF3gfOc0GU5DDc8I3XpZNjjjvrJ4CuHEcJ6nTO0=
X-Received: by 2002:a2e:98c9:0:b0:280:c07e:595b with SMTP id
 s9-20020a2e98c9000000b00280c07e595bmr1023301ljj.423.1673284802576; Mon, 09
 Jan 2023 09:20:02 -0800 (PST)
MIME-Version: 1.0
References: <20230104150642.v2.1.I1f29bb547a03e9adfe2e6754212f9d14a2e39c4b@changeid>
 <CABBYNZL9FiZjRYJE_h4n2kf9LKv_5XF3Fd=bz=cU4bTcDR-QHQ@mail.gmail.com>
 <Y7d26dhGXOij+xSO@x130> <CABBYNZ+0DsjdQ4z2CEj95VnyR9Nnsemq7FCWYwO=M1gz3WD+=Q@mail.gmail.com>
 <CAAa9mD3hybWw0cZ9_p2ZWKQFFmPUvsj3efOB_j9VLd_4RgcmPA@mail.gmail.com>
In-Reply-To: <CAAa9mD3hybWw0cZ9_p2ZWKQFFmPUvsj3efOB_j9VLd_4RgcmPA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 9 Jan 2023 09:19:50 -0800
Message-ID: <CABBYNZ+3OaN3iyEgz1tT6g5KBjT+Jmsj20J8KxtiMz9RQwBDag@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Fix possible deadlock in rfcomm_sk_state_change
To:     Ying Hsu <yinghsu@chromium.org>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ying,

On Sat, Jan 7, 2023 at 4:35 AM Ying Hsu <yinghsu@chromium.org> wrote:
>
> Hi Luiz,
>
> Based on the stack trace reported by syzbot, the deadlock happened in a single process.
> I'll revise the commit message in the next revision. Thank you for catching that.
>
> Generalizing it sounds good.
> But if it releases the sk lock as below, the do_something() part might be different for different proto.
> ```
> bt_sock_connect_v1(..., callback) {
>     sock_hold(sk);
>     release_sock(sk);
>     err = callback(...);
>     lock_sock(sk);
>     if (!err && !sock_flag(sk, SOCK_ZAPPED)) {
>         do_something();
>     }
>     sock_put(sk);
>     return err;
> }
> ```
>
> Another proposal is to have the callback executed with sk lock acquired, and the callback is almost the same as the original connect function for each proto,
> but they'll have to manage the sk lock and check its ZAPPED state. What do you think?
> ```
> bt_sock_connect_v2(..., callback) {
>     sock_hold(sk);
>     lock_sock(sk);
>     err = callback(...);
>     release_sock(sk);
>     sock_put(sk);
>     return err;
> }
>
> rfcomm_sock_connect(...) {
>     return bt_sock_connect_v2(..., __rfcomm_sock_connect);
> }
> ```

I think it is worth trying to prototype both and see which one we end
up consolidating more code since we might as well do the likes the
likes of bt_sock_wait_state, we could also in theory have a parameter
which indicates if the callback expects the sk to be locked or not.

> On Sat, Jan 7, 2023 at 3:45 AM Luiz Augusto von Dentz <luiz.dentz@gmail.com> wrote:
>>
>> Hi Saeed,
>>
>> On Thu, Jan 5, 2023 at 5:18 PM Saeed Mahameed <saeed@kernel.org> wrote:
>> >
>> > On 04 Jan 14:21, Luiz Augusto von Dentz wrote:
>> > >Hi Ying,
>> > >
>> > >On Wed, Jan 4, 2023 at 7:07 AM Ying Hsu <yinghsu@chromium.org> wrote:
>> > >>
>> > >> There's a possible deadlock when two processes are connecting
>> > >> and closing a RFCOMM socket concurrently. Here's the call trace:
>> > >
>> > >Are you sure it is 2 different processes? Usually that would mean 2
>> > >different sockets (sk) then so they wouldn't share the same lock, so
>> > >this sounds more like 2 different threads, perhaps it is worth
>> > >creating a testing case in our rfcomm-tester so we are able to detect
>> > >this sort of thing in the future.
>> > >
>> > >> -> #2 (&d->lock){+.+.}-{3:3}:
>> > >>        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
>> > >>        __mutex_lock0x12f/0x1360 kernel/locking/mutex.c:747
>> > >>        __rfcomm_dlc_close+0x15d/0x890 net/bluetooth/rfcomm/core.c:487
>> > >>        rfcomm_dlc_close+1e9/0x240 net/bluetooth/rfcomm/core.c:520
>> > >>        __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
>> > >>        rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
>> > >>        rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
>> > >>        __sock_release+0xcd/0x280 net/socket.c:650
>> > >>        sock_close+0x1c/0x20 net/socket.c:1365
>> > >>        __fput+0x27c/0xa90 fs/file_table.c:320
>> > >>        task_work_run+0x16f/0x270 kernel/task_work.c:179
>> > >>        exit_task_work include/linux/task_work.h:38 [inline]
>> > >>        do_exit+0xaa8/0x2950 kernel/exit.c:867
>> > >>        do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
>> > >>        get_signal+0x21c3/0x2450 kernel/signal.c:2859
>> > >>        arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
>> > >>        exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
>> > >>        exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
>> > >>        __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
>> > >>        syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
>> > >>        do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>> > >>        entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> > >>
>> > >> -> #1 (rfcomm_mutex){+.+.}-{3:3}:
>> > >>        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
>> > >>        __mutex_lock+0x12f/0x1360 kernel/locking/mutex.c:747
>> > >>        rfcomm_dlc_open+0x93/0xa80 net/bluetooth/rfcomm/core.c:425
>> > >>        rfcomm_sock_connect+0x329/0x450 net/bluetooth/rfcomm/sock.c:413
>> > >>        __sys_connect_file+0x153/0x1a0 net/socket.c:1976
>> > >>        __sys_connect+0x165/0x1a0 net/socket.c:1993
>> > >>        __do_sys_connect net/socket.c:2003 [inline]
>> > >>        __se_sys_connect net/socket.c:2000 [inline]
>> > >>        __x64_sys_connect+0x73/0xb0 net/socket.c:2000
>> > >>        do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>> > >>        do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>> > >>        entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> > >>
>> > >> -> #0 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}:
>> > >>        check_prev_add kernel/locking/lockdep.c:3097 [inline]
>> > >>        check_prevs_add kernel/locking/lockdep.c:3216 [inline]
>> > >>        validate_chain kernel/locking/lockdep.c:3831 [inline]
>> > >>        __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
>> > >>        lock_acquire kernel/locking/lockdep.c:5668 [inline]
>> > >>        lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
>> > >>        lock_sock_nested+0x3a/0xf0 net/core/sock.c:3470
>> > >>        lock_sock include/net/sock.h:1725 [inline]
>> > >>        rfcomm_sk_state_change+0x6d/0x3a0 net/bluetooth/rfcomm/sock.c:73
>> > >>        __rfcomm_dlc_close+0x1b1/0x890 net/bluetooth/rfcomm/core.c:489
>> > >>        rfcomm_dlc_close+0x1e9/0x240 net/bluetooth/rfcomm/core.c:520
>> > >>        __rfcomm_sock_close+0x13c/0x250 net/bluetooth/rfcomm/sock.c:220
>> > >>        rfcomm_sock_shutdown+0xd8/0x230 net/bluetooth/rfcomm/sock.c:907
>> > >>        rfcomm_sock_release+0x68/0x140 net/bluetooth/rfcomm/sock.c:928
>> > >>        __sock_release+0xcd/0x280 net/socket.c:650
>> > >>        sock_close+0x1c/0x20 net/socket.c:1365
>> > >>        __fput+0x27c/0xa90 fs/file_table.c:320
>> > >>        task_work_run+0x16f/0x270 kernel/task_work.c:179
>> > >>        exit_task_work include/linux/task_work.h:38 [inline]
>> > >>        do_exit+0xaa8/0x2950 kernel/exit.c:867
>> > >>        do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
>> > >>        get_signal+0x21c3/0x2450 kernel/signal.c:2859
>> > >>        arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
>> > >>        exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
>> > >>        exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
>> > >>        __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
>> > >>        syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
>> > >>        do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>> > >>        entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> > >>
>> > >> Signed-off-by: Ying Hsu <yinghsu@chromium.org>
>> > >> ---
>> > >> This commit has been tested with a C reproducer on qemu-x86_64
>> > >> and a ChromeOS device.
>> > >>
>> > >> Changes in v2:
>> > >> - Fix potential use-after-free in rfc_comm_sock_connect.
>> > >>
>> > >>  net/bluetooth/rfcomm/sock.c | 7 ++++++-
>> > >>  1 file changed, 6 insertions(+), 1 deletion(-)
>> > >>
>> > >> diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
>> > >> index 21e24da4847f..4397e14ff560 100644
>> > >> --- a/net/bluetooth/rfcomm/sock.c
>> > >> +++ b/net/bluetooth/rfcomm/sock.c
>> > >> @@ -391,6 +391,7 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
>> > >>             addr->sa_family != AF_BLUETOOTH)
>> > >>                 return -EINVAL;
>> > >>
>> > >> +       sock_hold(sk);
>> > >>         lock_sock(sk);
>> > >>
>> > >>         if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
>> > >> @@ -410,14 +411,18 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
>> > >>         d->sec_level = rfcomm_pi(sk)->sec_level;
>> > >>         d->role_switch = rfcomm_pi(sk)->role_switch;
>> > >>
>> > >> +       /* Drop sock lock to avoid potential deadlock with the RFCOMM lock */
>> > >> +       release_sock(sk);
>> > >>         err = rfcomm_dlc_open(d, &rfcomm_pi(sk)->src, &sa->rc_bdaddr,
>> > >>                               sa->rc_channel);
>> > >> -       if (!err)
>> > >> +       lock_sock(sk);
>> > >> +       if (!err && !sock_flag(sk, SOCK_ZAPPED))
>> > >>                 err = bt_sock_wait_state(sk, BT_CONNECTED,
>> > >>                                 sock_sndtimeo(sk, flags & O_NONBLOCK));
>> > >>
>> > >>  done:
>> > >>         release_sock(sk);
>> > >> +       sock_put(sk);
>> > >>         return err;
>> > >>  }
>> > >
>> > >This sounds like a great solution to hold the reference and then
>> >
>> > Why do you need sock_hold/put in the same proto_ops.callback sock opts ?
>> > it should be guaranteed by the caller the sk will remain valid
>> > or if you are paranoid then sock_hold() on your proto_ops.bind() and put()
>> > on your proto_ops.release()
>>
>> It doesn't looks like there is a sock_hold done in the likes of
>> __sys_connect/__sys_connect_file so afaik it is possible that the sk
>> is freed in the meantime if we attempt to release and lock afterward,
>> and about being paranoid I guess we are past that already since with
>> the likes of fuzzing testing is already paranoid in itself.
>>
>> > >checking if the socket has been zapped when attempting to lock_sock,
>> > >so Ive been thinking on generalize this into something like
>> > >bt_sock_connect(sock, addr, alen, callback) so we make sure the
>> > >callback is done while holding a reference but with the socket
>> > >unlocked since typically the underline procedure only needs to access
>> > >the pi(sk) information without changing it e.g. rfcomm_dlc_open,
>> > >anyway Im fine if you don't want to pursue doing it right now but I'm
>> > >afraid these type of locking problem is no restricted to RFCOMM only.
>> > >
>> > >> --
>> > >> 2.39.0.314.g84b9a713c41-goog
>> > >>
>> > >
>> > >
>> > >--
>> > >Luiz Augusto von Dentz
>>
>>
>>
>> --
>> Luiz Augusto von Dentz



-- 
Luiz Augusto von Dentz
