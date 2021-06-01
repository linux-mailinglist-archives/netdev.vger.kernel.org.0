Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1194D396AE3
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 04:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhFACNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 22:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbhFACNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 22:13:01 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D34DC061574;
        Mon, 31 May 2021 19:11:20 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id s107so15144671ybi.3;
        Mon, 31 May 2021 19:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eQx9xctYuJ3o/fL+k58wM3001vnaqhkuZk05QT6MtrM=;
        b=bOJNbvJHOEK87SsKfxONaqabouGNB8DfGTIM6H+S5tRhGPp2SnpMwu3UbCuFty1Crs
         D84mLcWCvKznvO1/eakwBFflnVW6+cleUwnxLmTYWu6lpYuvjXZ+8QYV0dHwshO7YMKL
         Phq8Y3XGmwORv7NxAqRyE0TJPNTFb/5FuPGnE/8ZN3HrLeHkqPTVtbWC8fKlHsL7JcuW
         c8eYFOD+NeRTDPyCNNVf9oiVBOueWXMIdQWjO0ublxgFpvqM4igYSAryP4aQtFDxcD/z
         NtCywQQEhtIhbih5kTxb1HtwZVfnnFiePkA5zIQkJ1OdqM7KPo8HSMKZl2nK8eLcD7eY
         kqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eQx9xctYuJ3o/fL+k58wM3001vnaqhkuZk05QT6MtrM=;
        b=nMCX+HVDXTTxU62MR2Q463CEhswLjSqLZppDsy48gNH9iytOSTr7o9ZxdMQnUnvNBN
         79fmR25mSFfwx3eVBj0nhjMAWMObi6kesOUh1IN/zN3GjB60Tsyxv8vRMh2F7J6vmGUA
         YT9r7yHd8fXdpcv1/WDYxQC32uWU5keGvwIccV5bc0zwFNdFKqMSNn3vnbH9sgGY8Kgv
         zvGdI7ON5tMBN9k2iZNAUHt5Zmx3mw5mednWx4KRivNjZNc59qHEBwkXV2jj1p5ehUvf
         tiqoqAsb5ypCCQ3K0PwnIFR2ORHJBIJ8gx4TJPvrwrH5rvtKsYwkwzl/NABNQjWKkeKE
         vp6g==
X-Gm-Message-State: AOAM5331jjDmYhnDZGoPp6ur7OHe9w1iKXrFrpRAlhde76w/YAcbabXb
        2e3rw3eV1XOkMqGpbB4L1WFI6oglHkOidd8gsO0=
X-Google-Smtp-Source: ABdhPJwPq/rJ/r7/ossVC6pWzDcwciHJV+txmedd+BBMtu+wGkeLp+cxgaI7u2+R1Xuh29L5U8abqjLu8oXhpjMzji4=
X-Received: by 2002:a25:a466:: with SMTP id f93mr33940228ybi.264.1622513479484;
 Mon, 31 May 2021 19:11:19 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000001d4a3005c39b0b40@google.com> <20210531090414.2558-1-hdanton@sina.com>
In-Reply-To: <20210531090414.2558-1-hdanton@sina.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 31 May 2021 19:11:08 -0700
Message-ID: <CABBYNZLwdYRMeXFpLqHiyU2Xi3Q1gjygjF_DoMAZR4rp1E+vQA@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in l2cap_chan_timeout (2)
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+008cdbf7a9044c2c2f99@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, May 31, 2021 at 2:04 AM Hillf Danton <hdanton@sina.com> wrote:
>
> On Mon, 31 May 2021 00:19:17 -0700
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    ad9f25d3 Merge tag 'netfs-lib-fixes-20200525' of git://git..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=173d383dd00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=266cda122a0b56c
> > dashboard link: https://syzkaller.appspot.com/bug?extid=008cdbf7a9044c2c2f99
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+008cdbf7a9044c2c2f99@syzkaller.appspotmail.com
> >
> > general protection fault, probably for non-canonical address 0xdffffc000000005a: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x00000000000002d0-0x00000000000002d7]
> > CPU: 0 PID: 8 Comm: kworker/0:2 Not tainted 5.13.0-rc3-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Workqueue: events l2cap_chan_timeout
> > RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:941 [inline]
> > RIP: 0010:__mutex_lock+0xf6/0x10c0 kernel/locking/mutex.c:1104
> > Code: d0 7c 08 84 d2 0f 85 cc 0c 00 00 8b 15 e3 55 5f 07 85 d2 75 29 48 8d 7d 60 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 db 0e 00 00 48 3b 6d 60 0f 85 5a 0a 00 00 bf 01
> > RSP: 0018:ffffc90000cd7b78 EFLAGS: 00010216
> > RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000001
> > RDX: 000000000000005a RSI: 0000000000000000 RDI: 00000000000002d0
> > RBP: 0000000000000270 R08: ffffffff880a40d9 R09: 0000000000000000
> > R10: ffffffff814b4be0 R11: 0000000000000000 R12: 0000000000000000
> > R13: dffffc0000000000 R14: ffff888072e47020 R15: ffff8880b9c34a40
> > FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007fcac15f1d58 CR3: 00000000628fa000 CR4: 0000000000350ef0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> > Call Trace:
> >  l2cap_chan_timeout+0x69/0x2f0 net/bluetooth/l2cap_core.c:422
> >  process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
> >  worker_thread+0x64c/0x1120 kernel/workqueue.c:2422
> >  kthread+0x3b1/0x4a0 kernel/kthread.c:313
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
> To fix the uaf reported, 1) releases connection through rcu 2) detects race
> under rcu lock in the delayed work callback.
>
> Note it is only for idea and thoughts are welcome if it makes sense to you.
>
> +++ x/net/bluetooth/l2cap_core.c
> @@ -414,12 +414,25 @@ static void l2cap_chan_timeout(struct wo
>  {
>         struct l2cap_chan *chan = container_of(work, struct l2cap_chan,
>                                                chan_timer.work);
> -       struct l2cap_conn *conn = chan->conn;
> +       struct l2cap_conn *conn;
>         int reason;
>
> +       rcu_read_lock();
> +       conn = chan->conn;
> +       if (conn && !kref_get_unless_zero(&conn->ref))
> +               conn = NULL;
> +       rcu_read_unlock();
> +
> +       if (!conn)
> +               goto put;
> +
>         BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
>
>         mutex_lock(&conn->chan_lock);
> +
> +       if (!chan->conn)
> +               goto put;
> +
>         /* __set_chan_timer() calls l2cap_chan_hold(chan) while scheduling
>          * this work. No need to call l2cap_chan_hold(chan) here again.
>          */
> @@ -438,9 +451,13 @@ static void l2cap_chan_timeout(struct wo
>         chan->ops->close(chan);
>
>         l2cap_chan_unlock(chan);
> +put:
>         l2cap_chan_put(chan);
>
> +       if (!conn)
> +               return;
>         mutex_unlock(&conn->chan_lock);
> +       l2cap_conn_put(conn);
>  }
>
>  struct l2cap_chan *l2cap_chan_create(void)
> @@ -1915,12 +1932,19 @@ static void l2cap_conn_del(struct hci_co
>         l2cap_conn_put(conn);
>  }
>
> +static void l2cap_conn_rcu_fn(struct rcu_head *r)
> +{
> +       struct l2cap_conn *conn = container_of(r, struct l2cap_conn, rcu);
> +
> +       kfree(conn);
> +}
> +
>  static void l2cap_conn_free(struct kref *ref)
>  {
>         struct l2cap_conn *conn = container_of(ref, struct l2cap_conn, ref);
>
>         hci_conn_put(conn->hcon);
> -       kfree(conn);

Shouldn't we actually cancel the timeout work if the connection is
freed here? At least I don't see a valid reason to have a l2cap_chan
without l2cap_conn.

> +       call_rcu(&conn->rcu, l2cap_conn_rcu_fn);
>  }
>
>  struct l2cap_conn *l2cap_conn_get(struct l2cap_conn *conn)



-- 
Luiz Augusto von Dentz
