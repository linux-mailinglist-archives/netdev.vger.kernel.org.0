Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9912397B68
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 22:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhFAUu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 16:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbhFAUuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 16:50:25 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15AFC061574;
        Tue,  1 Jun 2021 13:48:42 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id x6so610875ybl.9;
        Tue, 01 Jun 2021 13:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EsStg/j3/ZepGYdqJeIoOSE6ElsprIKmavPM+bVhMzM=;
        b=Gq5zLe0yyjx63gMZMx0hNhym1dNMS0ddT/QiE94twT45iMkF/oMOmIHZS1z/iXA80R
         +x4xe/lg08CH6l+e64SC9fxe7TkrUHTs6ekghcahn6jnOFD83PeE969v0tN1ZbSoQ3aj
         dGV2pjPrg5seB0qCKp0upX5CNqJuFcRhv3VkH8ACo9WqQraRClPp9bYrNiK38Hw85BjG
         CZj2JAjjyfunjX4ea2m2d//rTit4s4WgCzwkyLk0ShTUNigOoz5sqZUhlc6BEhj6tSxa
         BhLYVqeHfaGyHXKcsaKImy+FWK27opIPGWDlvJ/znJrJaiQf9Q3NWjsAd7OVBzF/Iu7x
         YmTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EsStg/j3/ZepGYdqJeIoOSE6ElsprIKmavPM+bVhMzM=;
        b=ORFIPBSPB/eDtI0aXI+DHRns0MujI255ml7/cCHpCZglMQLA5ifDmzmD3O8h1JYSaJ
         dUkCaolO+Ti3fKohD18jbPLVJ4CH/K2LnGXjhrUjfnfHastggm3d6lhx72XVDB7fG+G5
         YCDScsZwNvXfQaKsaT3pRJ6qzP+WuainopjkjBEgyHNIKTtMmGcGezTLIkkjk78PB7vT
         ewGKSi58Zqb2uHXXEYxUd/X5QkxfX7mk20wLui4JIwfNDtU8Rip70YQ8oY4+EotI3vgN
         cv84mLh6GMFy9pYEt6MmjDj6309j4L00jcu6eNZF99A0d3ZYxRkazAxEp04GCHqMkT3w
         grgA==
X-Gm-Message-State: AOAM531SZro4Er+pOk6BGVe2oiXQbA98QE0xsDW0baHzqe4+BGYcJ3MU
        J2L2rXW9jZpJB8dTgPjYsi9lpl8/hRi0+Zf3Yhw=
X-Google-Smtp-Source: ABdhPJxlOGGTd1dhABxbeDRhpSoNL5oGnWE+6Yw7haD1bBh5wpE16xgZl+yf3znamXPZNcvebFDRDbaNi47N3liD0vM=
X-Received: by 2002:a25:4048:: with SMTP id n69mr37703343yba.91.1622580522014;
 Tue, 01 Jun 2021 13:48:42 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000001d4a3005c39b0b40@google.com> <20210531090414.2558-1-hdanton@sina.com>
 <CABBYNZLwdYRMeXFpLqHiyU2Xi3Q1gjygjF_DoMAZR4rp1E+vQA@mail.gmail.com> <20210601075417.2763-1-hdanton@sina.com>
In-Reply-To: <20210601075417.2763-1-hdanton@sina.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 1 Jun 2021 13:48:30 -0700
Message-ID: <CABBYNZJGs0OQd3s0r7BWcY8pXm90E+HB6FG5CDf4DdL7i9T4qg@mail.gmail.com>
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

On Tue, Jun 1, 2021 at 12:54 AM Hillf Danton <hdanton@sina.com> wrote:
>
> On Mon, 31 May 2021 19:11:08 -0700 Luiz Augusto von Dentz wrote:
> >
> >Shouldn't we actually cancel the timeout work if the connection is
> >freed here? At least I don't see a valid reason to have a l2cap_chan
> >without l2cap_conn.
>
> A far neater approach at the cost of making l2cap_conn_put() blocking and
> nobody currently seems to care about it.

I wonder what is going on here, there doesn't seem to be any code path
where the chan_timer is not cleared since the code path should be:

l2cap_conn_del -> l2cap_chan_del -> __clear_chan_timer -> cancel_delayed_work
                                                             chan->conn = NULL

Perhaps the problem is that cancel_delayed_work does not actually
prevent l2cap_chan_timeout to run if that is already pending, so maybe
something like this would work:

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 9ebb85df4db4..f6e423111dfc 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -414,17 +414,23 @@ static void l2cap_chan_timeout(struct work_struct *work)
 {
        struct l2cap_chan *chan = container_of(work, struct l2cap_chan,
                                               chan_timer.work);
-       struct l2cap_conn *conn = chan->conn;
+       struct l2cap_conn *conn;
        int reason;

        BT_DBG("chan %p state %s", chan, state_to_string(chan->state));

-       mutex_lock(&conn->chan_lock);
        /* __set_chan_timer() calls l2cap_chan_hold(chan) while scheduling
         * this work. No need to call l2cap_chan_hold(chan) here again.
         */
        l2cap_chan_lock(chan);

+       conn = chan->conn;
+       if (!conn)
+               /* l2cap_conn_del might have run */
+               goto unlock;
+
+       mutex_lock(&conn->chan_lock);
+
        if (chan->state == BT_CONNECTED || chan->state == BT_CONFIG)
                reason = ECONNREFUSED;
        else if (chan->state == BT_CONNECT &&
@@ -437,10 +443,11 @@ static void l2cap_chan_timeout(struct work_struct *work)

        chan->ops->close(chan);

+       mutex_unlock(&conn->chan_lock);
+
+unlock:
        l2cap_chan_unlock(chan);
        l2cap_chan_put(chan);
-
-       mutex_unlock(&conn->chan_lock);
 }


-- 
Luiz Augusto von Dentz
