Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD15D55C8AB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240818AbiF0XkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 19:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiF0XkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 19:40:10 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00D913CC9;
        Mon, 27 Jun 2022 16:40:09 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id t25so19276089lfg.7;
        Mon, 27 Jun 2022 16:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g9TIf+3x3caizlqAmKMq5kNmA2BfpsDTk6Fwe26qpEo=;
        b=IwQQhKq3UNveZs7dOmZGfBcnIBnkaCMDK7sKXtpazmL8V1T02SjSdtk8IuICV817Op
         JPxmob5AgOLVm9L4BuKk5FOaUYazy/zHzqHFrWBAY6KiLq0NYAsMbc2uJMhpK4a7Hsh2
         7yOyU9xT9VN7y/84DT3SDqxuzLVPLE0dgxfN+s0ElDRT80u24N2C2d1DTVUJHSTzVci0
         rZMUcESMqSJFrGPe2tSvHddJjO4ny4Rz6p8wELk0+frpcBTMp+hY6ur0albcdVmetZ23
         A4EE/hJVLWDFJOXkHs/uUSZq1zS+FK8qgJJevLCyDTwZ2Pw6T/zQzosEzs3JunEqZKyp
         m24w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g9TIf+3x3caizlqAmKMq5kNmA2BfpsDTk6Fwe26qpEo=;
        b=c8gfGr2Rq1mJrRkcDDFdm+YHAyY4a+KZqLauWI0D6efsStAqEehbtJ14eRZp7Jpkyg
         f8oMLqtkuAXofipiSeRILmO1/GFCjKME1UpU6JKYplWzRT5ICSxEa8vTGjAXjJcWHjRy
         Uh/MOfndnOJYv6WkIdeqNFRAz4CwKZED3uS1wwBPgdG2Ls9ChuFOIvFfOUBTSbzmZz17
         Sc6QymAxTeeX/N4+DnQYQpPDEZXqVtk4cUdcxYCuES60Ezd9zQ9um3e+njWGc2bxt+Zx
         wjSkKQksqY+XTwf8lPKN2/9h+n4xDKpkvJiHjLmCgFAIyADIijgUfj+YIRsxatQBwKkG
         s+ZQ==
X-Gm-Message-State: AJIora/aR2ZWoygGeorEtKxvVqjqsdK/8qxd3XHdhW6KKG6y8/mdPH+o
        50pbiezk4H/guTeHAP695lCtyfI2C7PPi/uXYLaiH9cX1ZS42w==
X-Google-Smtp-Source: AGRyM1vSrDGCaf8Egi8rgU5w2J/m/P1YNJS3w5Hnouvho4Wlr31ukVPtiAd29Pm3PrW7vqS8JheZoYzwLM5ShTF55UI=
X-Received: by 2002:a05:6512:39ca:b0:47f:a9e1:e3b8 with SMTP id
 k10-20020a05651239ca00b0047fa9e1e3b8mr9443878lfu.564.1656373207989; Mon, 27
 Jun 2022 16:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220622082716.478486-1-lee.jones@linaro.org> <CANn89iK-uFP6Swgc0ZeEC38UsuywJ3wbybSNouH202Wa7X7Tzg@mail.gmail.com>
In-Reply-To: <CANn89iK-uFP6Swgc0ZeEC38UsuywJ3wbybSNouH202Wa7X7Tzg@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 27 Jun 2022 16:39:56 -0700
Message-ID: <CABBYNZ+C=MQ7577Fr5_W8tQ4iWRSDBSiC4fkRBY3x=9ph+YAzA@mail.gmail.com>
Subject: Re: [RESEND 1/1] Bluetooth: Use chan_list_lock to protect the whole
 put/destroy invokation
To:     Eric Dumazet <edumazet@google.com>
Cc:     Lee Jones <lee.jones@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric, Lee,

On Mon, Jun 27, 2022 at 7:41 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Jun 22, 2022 at 10:27 AM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > This change prevents a use-after-free caused by one of the worker
> > threads starting up (see below) *after* the final channel reference
> > has been put() during sock_close() but *before* the references to the
> > channel have been destroyed.
> >
> >   refcount_t: increment on 0; use-after-free.
> >   BUG: KASAN: use-after-free in refcount_dec_and_test+0x20/0xd0
> >   Read of size 4 at addr ffffffc114f5bf18 by task kworker/u17:14/705
> >
> >   CPU: 4 PID: 705 Comm: kworker/u17:14 Tainted: G S      W       4.14.234-00003-g1fb6d0bd49a4-dirty #28
> >   Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM sm8150 Flame DVT (DT)
> >   Workqueue: hci0 hci_rx_work
> >   Call trace:
> >    dump_backtrace+0x0/0x378
> >    show_stack+0x20/0x2c
> >    dump_stack+0x124/0x148
> >    print_address_description+0x80/0x2e8
> >    __kasan_report+0x168/0x188
> >    kasan_report+0x10/0x18
> >    __asan_load4+0x84/0x8c
> >    refcount_dec_and_test+0x20/0xd0
> >    l2cap_chan_put+0x48/0x12c
> >    l2cap_recv_frame+0x4770/0x6550
> >    l2cap_recv_acldata+0x44c/0x7a4
> >    hci_acldata_packet+0x100/0x188
> >    hci_rx_work+0x178/0x23c
> >    process_one_work+0x35c/0x95c
> >    worker_thread+0x4cc/0x960
> >    kthread+0x1a8/0x1c4
> >    ret_from_fork+0x10/0x18
> >
> > Cc: stable@kernel.org
>
> When was the bug added ? (Fixes: tag please)
>
> > Cc: Marcel Holtmann <marcel@holtmann.org>
> > Cc: Johan Hedberg <johan.hedberg@gmail.com>
> > Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: linux-bluetooth@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  net/bluetooth/l2cap_core.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > index ae78490ecd3d4..82279c5919fd8 100644
> > --- a/net/bluetooth/l2cap_core.c
> > +++ b/net/bluetooth/l2cap_core.c
> > @@ -483,9 +483,7 @@ static void l2cap_chan_destroy(struct kref *kref)
> >
> >         BT_DBG("chan %p", chan);
> >
> > -       write_lock(&chan_list_lock);
> >         list_del(&chan->global_l);
> > -       write_unlock(&chan_list_lock);
> >
> >         kfree(chan);
> >  }
> > @@ -501,7 +499,9 @@ void l2cap_chan_put(struct l2cap_chan *c)
> >  {
> >         BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
> >
> > +       write_lock(&chan_list_lock);
> >         kref_put(&c->kref, l2cap_chan_destroy);
> > +       write_unlock(&chan_list_lock);
> >  }
> >  EXPORT_SYMBOL_GPL(l2cap_chan_put);
> >
> > --
> > 2.36.1.255.ge46751e96f-goog
> >
>
> I do not think this patch is correct.
>
> a kref does not need to be protected by a write lock.
>
> This might shuffle things enough to work around a particular repro you have.
>
> If the patch was correct why not protect kref_get() sides ?
>
> Before the &hdev->rx_work is scheduled (queue_work(hdev->workqueue,
> &hdev->rx_work),
> a reference must be taken.
>
> Then this reference must be released at the end of hci_rx_work() or
> when hdev->workqueue
> is canceled.
>
> This refcount is not needed _if_ the workqueue is properly canceled at
> device dismantle,
> in a synchronous way.
>
> I do not see this hdev->rx_work being canceled, maybe this is the real issue.
>
> There is a call to drain_workqueue() but this is not enough I think,
> because hci_recv_frame()
> can re-arm
>    queue_work(hdev->workqueue, &hdev->rx_work);

I suspect this likely a refcount problem, we do l2cap_get_chan_by_scid:

/* Find channel with given SCID.
 * Returns locked channel. */
static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn
*conn, u16 cid)

So we return a locked channel but that doesn't prevent another thread
to call l2cap_chan_put which doesn't care about l2cap_chan_lock so
perhaps we actually need to host a reference while we have the lock,
at least we do something like that on l2cap_sock.c:

l2cap_chan_hold(chan);
l2cap_chan_lock(chan);

__clear_chan_timer(chan);
l2cap_chan_close(chan, ECONNRESET);
l2cap_sock_kill(sk);

l2cap_chan_unlock(chan);
l2cap_chan_put(chan);


-- 
Luiz Augusto von Dentz
