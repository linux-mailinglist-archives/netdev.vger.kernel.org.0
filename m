Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159BF3CBB12
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 19:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhGPRZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 13:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbhGPRZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 13:25:24 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A546EC06175F;
        Fri, 16 Jul 2021 10:22:29 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id p22so15993272yba.7;
        Fri, 16 Jul 2021 10:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iMY8oYBreHUC3HzX38zHW82je0nYGAwPUjs+2fokewk=;
        b=Z2UeZH+YATbQCyW5jvTAZnuVuDZjJK4+s3f+rpM+wMlafIcRlI5a6XkHb6d1VvM68d
         iR0JMAYLaw4HvzWjWaGjwAE01YoThOnn785eVOxMTgtKQQSjnYlkNdnoSaZbslQpevwg
         iva8Allz8obdOS3wXqgUV5Hf7oP+9vA+7K8mIXTBYGqiDxzCO+CW/5UzcZXnO4BzG7Af
         eOVlMjxiZZ1w8UU9uUU6+x9kExOogSEa6HMkCBdEyOpxQ/po5PzIFutqiKTfrUqhsRkF
         ef5B+jwPwc8sKXMQBMzFRIKSmlno6j6pVthdKnQs2DDV/TYBwL//Li3zom1e55j9xJOC
         4UMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iMY8oYBreHUC3HzX38zHW82je0nYGAwPUjs+2fokewk=;
        b=PkyF4JIPF72ZJypq0mmA+tpAJmmeX0VBaItLb7ivqY2Cg8L8TG+ajoHn9VbjgBbYoi
         NuwM0R6FXcyAzjFE1oyN4/pEZUKDq0CZh27JqQlxWJaxN7pzTKEXoUEzhj6txkkPDK0O
         KP0xbauCUA/DkU89iSmGRuNW9kJmbldIl3liOMs/oZcNCvLLS8wdE5/6fUr7aKKL9XFR
         840Vd3yDO66rGAUlfk6zZVwPuRbU3H8FHy3sRstQB8Sr3DdPHmJtN52+m98MGdiPqN+l
         +2O1XWsip4WWwizYMSVbJL1CUb6S/lwO5FJmmCffK+cu2fAHFy2LoGMGrCIBLbYg/iCC
         atgg==
X-Gm-Message-State: AOAM533ky7aB1xkbwn8eTFgXdIwPrbtcloznQETuERoDiVcH+amlyyzY
        W5wy9YskO3zBf9H9B8AlLRJl3CWghuXqWd1/rCc=
X-Google-Smtp-Source: ABdhPJxqiXSt92nlOojIIvZKBDLQhzyxC9sMjxayRNb0gYAoXS6Xs1NVx9elaDSP3qpitnlNkmn773bmnVUxea0Pbo8=
X-Received: by 2002:a05:6902:114c:: with SMTP id p12mr14876667ybu.282.1626456148689;
 Fri, 16 Jul 2021 10:22:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210714031733.1395549-1-bobo.shaobowang@huawei.com>
 <CABBYNZL37yLgj1LP7r=rbEcsPXCPy1y55ar816eZXka2W=7-Aw@mail.gmail.com>
 <a1c4ddcb-afbd-c0e4-2003-90590b10ea84@huawei.com> <32ffeb61-f8e8-2a62-e1a7-d5df9672267c@huawei.com>
In-Reply-To: <32ffeb61-f8e8-2a62-e1a7-d5df9672267c@huawei.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 16 Jul 2021 10:22:17 -0700
Message-ID: <CABBYNZKy28hfo811zMB6Z=TEXrUn_JCkpehE7n_a7Cx10qBa8g@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: fix use-after-free error in lock_sock_nested()
To:     "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>
Cc:     cj.chengjian@huawei.com, Wei Yongjun <weiyongjun1@huawei.com>,
        yuehaibing@huawei.com, huawei.libin@huawei.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jul 15, 2021 at 6:38 PM Wangshaobo (bobo)
<bobo.shaobowang@huawei.com> wrote:
>
>
> =E5=9C=A8 2021/7/15 12:57, Wangshaobo (bobo) =E5=86=99=E9=81=93:
> >
> > =E5=9C=A8 2021/7/15 5:50, Luiz Augusto von Dentz =E5=86=99=E9=81=93:
> >> Hi,
> >>
> >> On Tue, Jul 13, 2021 at 8:20 PM Wang ShaoBo
> >> <bobo.shaobowang@huawei.com> wrote:
> >>> use-after-free error in lock_sock_nested() is reported:
> >>>
> >>> [  179.140137][ T3731]
> >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >>> [  179.142675][ T3731] BUG: KMSAN: use-after-free in
> >>> lock_sock_nested+0x280/0x2c0
> >>> [  179.145494][ T3731] CPU: 4 PID: 3731 Comm: kworker/4:2 Not
> >>> tainted 5.12.0-rc6+ #54
> >>> [  179.148432][ T3731] Hardware name: QEMU Standard PC (i440FX +
> >>> PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> >>> [  179.151806][ T3731] Workqueue: events l2cap_chan_timeout
> >>> [  179.152730][ T3731] Call Trace:
> >>> [  179.153301][ T3731]  dump_stack+0x24c/0x2e0
> >>> [  179.154063][ T3731]  kmsan_report+0xfb/0x1e0
> >>> [  179.154855][ T3731]  __msan_warning+0x5c/0xa0
> >>> [  179.155579][ T3731]  lock_sock_nested+0x280/0x2c0
> >>> [  179.156436][ T3731]  ? kmsan_get_metadata+0x116/0x180
> >>> [  179.157257][ T3731]  l2cap_sock_teardown_cb+0xb8/0x890
> >>> [  179.158154][ T3731]  ? __msan_metadata_ptr_for_load_8+0x10/0x20
> >>> [  179.159141][ T3731]  ? kmsan_get_metadata+0x116/0x180
> >>> [  179.159994][ T3731]  ? kmsan_get_shadow_origin_ptr+0x84/0xb0
> >>> [  179.160959][ T3731]  ? l2cap_sock_recv_cb+0x420/0x420
> >>> [  179.161834][ T3731]  l2cap_chan_del+0x3e1/0x1d50
> >>> [  179.162608][ T3731]  ? kmsan_get_metadata+0x116/0x180
> >>> [  179.163435][ T3731]  ? kmsan_get_shadow_origin_ptr+0x84/0xb0
> >>> [  179.164406][ T3731]  l2cap_chan_close+0xeea/0x1050
> >>> [  179.165189][ T3731]  ? kmsan_internal_unpoison_shadow+0x42/0x70
> >>> [  179.166180][ T3731]  l2cap_chan_timeout+0x1da/0x590
> >>> [  179.167066][ T3731]  ? __msan_metadata_ptr_for_load_8+0x10/0x20
> >>> [  179.168023][ T3731]  ? l2cap_chan_create+0x560/0x560
> >>> [  179.168818][ T3731]  process_one_work+0x121d/0x1ff0
> >>> [  179.169598][ T3731]  worker_thread+0x121b/0x2370
> >>> [  179.170346][ T3731]  kthread+0x4ef/0x610
> >>> [  179.171010][ T3731]  ? process_one_work+0x1ff0/0x1ff0
> >>> [  179.171828][ T3731]  ? kthread_blkcg+0x110/0x110
> >>> [  179.172587][ T3731]  ret_from_fork+0x1f/0x30
> >>> [  179.173348][ T3731]
> >>> [  179.173752][ T3731] Uninit was created at:
> >>> [  179.174409][ T3731]  kmsan_internal_poison_shadow+0x5c/0xf0
> >>> [  179.175373][ T3731]  kmsan_slab_free+0x76/0xc0
> >>> [  179.176060][ T3731]  kfree+0x3a5/0x1180
> >>> [  179.176664][ T3731]  __sk_destruct+0x8af/0xb80
> >>> [  179.177375][ T3731]  __sk_free+0x812/0x8c0
> >>> [  179.178032][ T3731]  sk_free+0x97/0x130
> >>> [  179.178686][ T3731]  l2cap_sock_release+0x3d5/0x4d0
> >>> [  179.179457][ T3731]  sock_close+0x150/0x450
> >>> [  179.180117][ T3731]  __fput+0x6bd/0xf00
> >>> [  179.180787][ T3731]  ____fput+0x37/0x40
> >>> [  179.181481][ T3731]  task_work_run+0x140/0x280
> >>> [  179.182219][ T3731]  do_exit+0xe51/0x3e60
> >>> [  179.182930][ T3731]  do_group_exit+0x20e/0x450
> >>> [  179.183656][ T3731]  get_signal+0x2dfb/0x38f0
> >>> [  179.184344][ T3731]  arch_do_signal_or_restart+0xaa/0xe10
> >>> [  179.185266][ T3731]  exit_to_user_mode_prepare+0x2d2/0x560
> >>> [  179.186136][ T3731]  syscall_exit_to_user_mode+0x35/0x60
> >>> [  179.186984][ T3731]  do_syscall_64+0xc5/0x140
> >>> [  179.187681][ T3731] entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>> [  179.188604][ T3731]
> >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >>>
> >>> In our case, there are two Thread A and B:
> >>>
> >>> Context: Thread A:              Context: Thread B:
> >>>
> >>> l2cap_chan_timeout()            __se_sys_shutdown()
> >>>    l2cap_chan_close()              l2cap_sock_shutdown()
> >>>      l2cap_chan_del()                l2cap_chan_close()
> >>>        l2cap_sock_teardown_cb() l2cap_sock_teardown_cb()
> >>>
> >>> Once l2cap_sock_teardown_cb() excuted, this sock will be marked as
> >>> SOCK_ZAPPED,
> >>> and can be treated as killable in l2cap_sock_kill() if sock_orphan()
> >>> has
> >>> excuted, at this time we close sock through sock_close() which end
> >>> to call
> >>> l2cap_sock_kill() like Thread C:
> >>>
> >>> Context: Thread C:
> >>>
> >>> sock_close()
> >>>    l2cap_sock_release()
> >>>      sock_orphan()
> >>>      l2cap_sock_kill()  #free sock if refcnt is 1
> >>>
> >>> If C completed, Once A or B reaches l2cap_sock_teardown_cb() again,
> >>> use-after-free happened.
> >>>
> >>> We should set chan->data to NULL if sock is freed, for telling teardo=
wn
> >>> operation is not allowed in l2cap_sock_teardown_cb(), and also we
> >>> should
> >>> avoid killing an already killed socket in l2cap_sock_close_cb().
> >>>
> >>> Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
> >>> ---
> >>>   net/bluetooth/l2cap_sock.c | 14 ++++++++++++--
> >>>   1 file changed, 12 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> >>> index c99d65ef13b1..ddc6a692b237 100644
> >>> --- a/net/bluetooth/l2cap_sock.c
> >>> +++ b/net/bluetooth/l2cap_sock.c
> >>> @@ -1215,14 +1215,18 @@ static int l2cap_sock_recvmsg(struct socket
> >>> *sock, struct msghdr *msg,
> >>>    */
> >>>   static void l2cap_sock_kill(struct sock *sk)
> >>>   {
> >>> +       struct l2cap_chan *chan;
> >>> +
> >>>          if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
> >>>                  return;
> >>>
> >>>          BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
> >>>
> >>>          /* Kill poor orphan */
> >>> -
> >>> -       l2cap_chan_put(l2cap_pi(sk)->chan);
> >>> +       chan =3D l2cap_pi(sk)->chan;
> >>> +       l2cap_chan_put(chan);
> >
> > There is a problem here, the above sentence `l2cap_chan_put(chan)`
> > should put after
> >
> > following sentence.
> >
> >>> +       if (refcount_read(&sk->sk_refcnt) =3D=3D 1)
> >>> +               chan->data =3D NULL;
> >> Instead of checking if it is the last reference here, wouldn't it be
> >> better to reset the chan->data to NULL on l2cap_sock_destruct?
> >
> > Hi,
> >
> > In my case it looks OK, this is the diff:
> >
> > diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> > index f1b1edd0b697..32ef3328ab49 100644
> > --- a/net/bluetooth/l2cap_sock.c
> > +++ b/net/bluetooth/l2cap_sock.c
> > @@ -1500,6 +1500,9 @@ static void l2cap_sock_close_cb(struct
> > l2cap_chan *chan)
> >  {
> >         struct sock *sk =3D chan->data;
> >
> > +       if (!sk)
> > +               return;
> > +
> >         l2cap_sock_kill(sk);
> >  }
> >
> > @@ -1508,6 +1511,9 @@ static void l2cap_sock_teardown_cb(struct
> > l2cap_chan *chan, int err)
> >         struct sock *sk =3D chan->data;
> >         struct sock *parent;
> >
> > +       if (!sk)
> > +               return;
> > +
> >         BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
> >
> >         /* This callback can be called both for server (BT_LISTEN)
> > @@ -1700,6 +1706,7 @@ static void l2cap_sock_destruct(struct sock *sk)
> >         BT_DBG("sk %p", sk);
> >
> >         if (l2cap_pi(sk)->chan)
> > +              l2cap_pi(sk)->chan->data =3D NULL;
> >                  l2cap_chan_put(l2cap_pi(sk)->chan);
> >
> > But if it has potential risk if l2cap_sock_destruct() can not be
> > excuted in time ?
> >
> > sk_free():
> >
> >         if (refcount_dec_and_test(&sk->sk_wmem_alloc)) //is possible
> > this condition false ?
> >
> >               __sk_free(sk)   -> ... l2cap_sock_destruct()
> >
> Dear Luiz,
>
> Not only that, if l2cap_sock_kill() has put 'l2cap_pi(sk)->chan', how
> does we avoid re-puting 'l2cap_pi(sk)->chan' if l2cap_sock_destruct()
> work postponed? this will cause underflow of chan->refcount; this PATCH
> 4e1a720d0312 ("Bluetooth: avoid killing an already killed socket") also
> may not work in any case because only sock_orphan() has excuted can this
> sock be killed, but if sco_sock_release() excute first, for this sock
> has been marked as SOCK_DEAD, this sock can never be killed. So should
> we think put chan->data =3D NULL in xx_sock_kill() is a better choice ?

Not sure what do you mean by postponed? Interrupted perhaps? Even in
that case what are trying to prevent is use after free so if the
callback has not run yet that means the sk has not been freed. Anyway
I think we could do it inconditionally in l2cap_sock_kill since we
will be releasing the reference owned by l2cap_pi(sk)->chan->data that
should be reset to NULL immediatelly.

> - WangShaoBo
>


--=20
Luiz Augusto von Dentz
