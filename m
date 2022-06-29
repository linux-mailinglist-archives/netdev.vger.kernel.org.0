Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8C056048F
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbiF2P2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbiF2P2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:28:07 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52030313BA
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 08:28:04 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l68so4555802wml.3
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 08:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cK/6BR9syE4gm1OltzJi9wBv5dsQLsnv5HxX5cDra8U=;
        b=F+vIL28bRGa7aD8qx2tmDbcPHZrLWIfXbgPGGzJKguLsdwOcJPiJNuOZVFR1p3GNmv
         RuI+kJnnhKwC+t8wyz6aSVvVMrwst0zu8TGS+w2Eqc8ZOWSY1UCZJ0yVimLY5v2x+mF4
         7ktYjnvpfOT3P0cpQeGg2vqwGxyym2QX2hMtqDcFSFZl3xm04OkTd/6tUx8+XmJq6Koa
         5SNhGxAmwZudfg0sVOh9NYpw18wOD40uWXRpuVCTq05tQpV4N5/ZIdMEIUoNtZo4z/wK
         QA9r6N081v5PdV0+i6PLovT2+47kuDi48Ssj2mwUh/8BfCbF1nW65s0GitMLHKPtRMjB
         zqAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cK/6BR9syE4gm1OltzJi9wBv5dsQLsnv5HxX5cDra8U=;
        b=m20jyccNhTpHmaUvaKMOhbRFqX78ULfCF+2laFNzc8vgfdU2qIp5NFIrHXTz01x7oz
         +zhoHPmtVk6kP8o51yRS34+GtWkjP1tu1B6hqCGkuSPyfRer+cPZqYoCj9D3OPKh61+J
         D36EXIuRHdV7cgCfKTVVIeyfCzdsy8tY1HHB/b0Ro7ok9Q7kFXiz8jaFauO2ZpPtSgEH
         LHsGROENzl+GJMiLWQ5TtqQzS+w11SquU49R+DlqJj7iQVXzmSUGJKuHmfi7qsqHm4c0
         2tAEJiOFd3ObzsuDjwR6gDDOvq7/yWmDbpiOxfM2SPHg2LSQhb3+cWzKA2FyC0zLGEZ1
         ksrw==
X-Gm-Message-State: AJIora9PYVJT8vwo1Eoc30OsQl/cO60zjmPOZuvHsx3Hu5nPytU7Sjg5
        sA9GsGXvLry6zjywR9ucrYZqFg==
X-Google-Smtp-Source: AGRyM1temoYl3mRuB+BSq9I1jl3gI92QPOivYhg+cvOIK0l8FuO9jitJk85sRR+md/rxXtgLiFqTZw==
X-Received: by 2002:a05:600c:4149:b0:3a0:4728:60e7 with SMTP id h9-20020a05600c414900b003a0472860e7mr4332881wmm.10.1656516482749;
        Wed, 29 Jun 2022 08:28:02 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id o5-20020a056000010500b00210352bf36fsm16300688wrx.33.2022.06.29.08.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 08:28:02 -0700 (PDT)
Date:   Wed, 29 Jun 2022 16:28:00 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RESEND 1/1] Bluetooth: Use chan_list_lock to protect the whole
 put/destroy invokation
Message-ID: <YrxvgIiWuFVlXBaQ@google.com>
References: <20220622082716.478486-1-lee.jones@linaro.org>
 <CANn89iK-uFP6Swgc0ZeEC38UsuywJ3wbybSNouH202Wa7X7Tzg@mail.gmail.com>
 <CABBYNZ+C=MQ7577Fr5_W8tQ4iWRSDBSiC4fkRBY3x=9ph+YAzA@mail.gmail.com>
 <CABBYNZLysdh3NFK+G8=NUQ=G=hvS8X0PdMp=bVqiwPDPCAokmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABBYNZLysdh3NFK+G8=NUQ=G=hvS8X0PdMp=bVqiwPDPCAokmg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022, Luiz Augusto von Dentz wrote:

> Hi Eric, Lee,
> 
> On Mon, Jun 27, 2022 at 4:39 PM Luiz Augusto von Dentz
> <luiz.dentz@gmail.com> wrote:
> >
> > Hi Eric, Lee,
> >
> > On Mon, Jun 27, 2022 at 7:41 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Wed, Jun 22, 2022 at 10:27 AM Lee Jones <lee.jones@linaro.org> wrote:
> > > >
> > > > This change prevents a use-after-free caused by one of the worker
> > > > threads starting up (see below) *after* the final channel reference
> > > > has been put() during sock_close() but *before* the references to the
> > > > channel have been destroyed.
> > > >
> > > >   refcount_t: increment on 0; use-after-free.
> > > >   BUG: KASAN: use-after-free in refcount_dec_and_test+0x20/0xd0
> > > >   Read of size 4 at addr ffffffc114f5bf18 by task kworker/u17:14/705
> > > >
> > > >   CPU: 4 PID: 705 Comm: kworker/u17:14 Tainted: G S      W       4.14.234-00003-g1fb6d0bd49a4-dirty #28
> > > >   Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM sm8150 Flame DVT (DT)
> > > >   Workqueue: hci0 hci_rx_work
> > > >   Call trace:
> > > >    dump_backtrace+0x0/0x378
> > > >    show_stack+0x20/0x2c
> > > >    dump_stack+0x124/0x148
> > > >    print_address_description+0x80/0x2e8
> > > >    __kasan_report+0x168/0x188
> > > >    kasan_report+0x10/0x18
> > > >    __asan_load4+0x84/0x8c
> > > >    refcount_dec_and_test+0x20/0xd0
> > > >    l2cap_chan_put+0x48/0x12c
> > > >    l2cap_recv_frame+0x4770/0x6550
> > > >    l2cap_recv_acldata+0x44c/0x7a4
> > > >    hci_acldata_packet+0x100/0x188
> > > >    hci_rx_work+0x178/0x23c
> > > >    process_one_work+0x35c/0x95c
> > > >    worker_thread+0x4cc/0x960
> > > >    kthread+0x1a8/0x1c4
> > > >    ret_from_fork+0x10/0x18
> > > >
> > > > Cc: stable@kernel.org
> > >
> > > When was the bug added ? (Fixes: tag please)
> > >
> > > > Cc: Marcel Holtmann <marcel@holtmann.org>
> > > > Cc: Johan Hedberg <johan.hedberg@gmail.com>
> > > > Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > Cc: Eric Dumazet <edumazet@google.com>
> > > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > > Cc: linux-bluetooth@vger.kernel.org
> > > > Cc: netdev@vger.kernel.org
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > >  net/bluetooth/l2cap_core.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > > > index ae78490ecd3d4..82279c5919fd8 100644
> > > > --- a/net/bluetooth/l2cap_core.c
> > > > +++ b/net/bluetooth/l2cap_core.c
> > > > @@ -483,9 +483,7 @@ static void l2cap_chan_destroy(struct kref *kref)
> > > >
> > > >         BT_DBG("chan %p", chan);
> > > >
> > > > -       write_lock(&chan_list_lock);
> > > >         list_del(&chan->global_l);
> > > > -       write_unlock(&chan_list_lock);
> > > >
> > > >         kfree(chan);
> > > >  }
> > > > @@ -501,7 +499,9 @@ void l2cap_chan_put(struct l2cap_chan *c)
> > > >  {
> > > >         BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
> > > >
> > > > +       write_lock(&chan_list_lock);
> > > >         kref_put(&c->kref, l2cap_chan_destroy);
> > > > +       write_unlock(&chan_list_lock);
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(l2cap_chan_put);
> > > >
> > > >
> > >
> > > I do not think this patch is correct.
> > >
> > > a kref does not need to be protected by a write lock.
> > >
> > > This might shuffle things enough to work around a particular repro you have.
> > >
> > > If the patch was correct why not protect kref_get() sides ?
> > >
> > > Before the &hdev->rx_work is scheduled (queue_work(hdev->workqueue,
> > > &hdev->rx_work),
> > > a reference must be taken.
> > >
> > > Then this reference must be released at the end of hci_rx_work() or
> > > when hdev->workqueue
> > > is canceled.
> > >
> > > This refcount is not needed _if_ the workqueue is properly canceled at
> > > device dismantle,
> > > in a synchronous way.
> > >
> > > I do not see this hdev->rx_work being canceled, maybe this is the real issue.
> > >
> > > There is a call to drain_workqueue() but this is not enough I think,
> > > because hci_recv_frame()
> > > can re-arm
> > >    queue_work(hdev->workqueue, &hdev->rx_work);
> >
> > I suspect this likely a refcount problem, we do l2cap_get_chan_by_scid:
> >
> > /* Find channel with given SCID.
> >  * Returns locked channel. */
> > static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn
> > *conn, u16 cid)
> >
> > So we return a locked channel but that doesn't prevent another thread
> > to call l2cap_chan_put which doesn't care about l2cap_chan_lock so
> > perhaps we actually need to host a reference while we have the lock,
> > at least we do something like that on l2cap_sock.c:
> >
> > l2cap_chan_hold(chan);
> > l2cap_chan_lock(chan);
> >
> > __clear_chan_timer(chan);
> > l2cap_chan_close(chan, ECONNRESET);
> > l2cap_sock_kill(sk);
> >
> > l2cap_chan_unlock(chan);
> > l2cap_chan_put(chan);
> 
> Perhaps something like this:

I'm struggling to apply this for test:

  "error: corrupt patch at line 6"

Please could you attach a `git format-patch`ed patch instead?

> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 09ecaf556de5..9050b6af3577 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -111,7 +111,7 @@ static struct l2cap_chan
> *__l2cap_get_chan_by_scid(struct l2cap_conn *conn,
>  }
> 
>  /* Find channel with given SCID.
> - * Returns locked channel. */
> + * Returns a reference locked channel. */
>  static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn *conn,
>                                                  u16 cid)
>  {
> @@ -119,15 +119,17 @@ static struct l2cap_chan
> *l2cap_get_chan_by_scid(struct l2cap_conn *conn,
> 
>         mutex_lock(&conn->chan_lock);
>         c = __l2cap_get_chan_by_scid(conn, cid);
> -       if (c)
> +       if (c) {
> +               l2cap_chan_hold(c);
>                 l2cap_chan_lock(c);
> +       }
>         mutex_unlock(&conn->chan_lock);
> 
>         return c;
>  }
> 
>  /* Find channel with given DCID.
> - * Returns locked channel.
> + * Returns a reference locked channel.
>   */
>  static struct l2cap_chan *l2cap_get_chan_by_dcid(struct l2cap_conn *conn,
>                                                  u16 cid)
> @@ -136,8 +138,10 @@ static struct l2cap_chan
> *l2cap_get_chan_by_dcid(struct l2cap_conn *conn,
> 
>         mutex_lock(&conn->chan_lock);
>         c = __l2cap_get_chan_by_dcid(conn, cid);
> -       if (c)
> +       if (c) {
> +               l2cap_chan_hold(c);
>                 l2cap_chan_lock(c);
> +       }
>         mutex_unlock(&conn->chan_lock);
> 
>         return c;
> @@ -4464,6 +4468,7 @@ static inline int l2cap_config_req(struct
> l2cap_conn *conn,
> 
>  unlock:
>         l2cap_chan_unlock(chan);
> +       l2cap_chan_put(chan);
>         return err;
>  }
> 
> @@ -4578,6 +4583,7 @@ static inline int l2cap_config_rsp(struct
> l2cap_conn *conn,
> 
>  done:
>         l2cap_chan_unlock(chan);
> +       l2cap_chan_put(chan);
>         return err;
>  }
> 
> @@ -5305,6 +5311,7 @@ static inline int l2cap_move_channel_req(struct
> l2cap_conn *conn,
>         l2cap_send_move_chan_rsp(chan, result);
> 
>         l2cap_chan_unlock(chan);
> +       l2cap_chan_put(chan);
> 
>         return 0;
>  }
> @@ -5397,6 +5404,7 @@ static void l2cap_move_continue(struct
> l2cap_conn *conn, u16 icid, u16 result)
>         }
> 
>         l2cap_chan_unlock(chan);
> +       l2cap_chan_put(chan);
>  }
> 
>  static void l2cap_move_fail(struct l2cap_conn *conn, u8 ident, u16 icid,
> @@ -5489,6 +5497,7 @@ static int l2cap_move_channel_confirm(struct
> l2cap_conn *conn,
>         l2cap_send_move_chan_cfm_rsp(conn, cmd->ident, icid);
> 
>         l2cap_chan_unlock(chan);
> +       l2cap_chan_put(chan);
> 
>         return 0;
>  }
> @@ -5524,6 +5533,7 @@ static inline int
> l2cap_move_channel_confirm_rsp(struct l2cap_conn *conn,
>         }
> 
>         l2cap_chan_unlock(chan);
> +       l2cap_chan_put(chan);
> 
>         return 0;
>  }
> @@ -5896,12 +5906,11 @@ static inline int l2cap_le_credits(struct
> l2cap_conn *conn,
>         if (credits > max_credits) {
>                 BT_ERR("LE credits overflow");
>                 l2cap_send_disconn_req(chan, ECONNRESET);
> -               l2cap_chan_unlock(chan);
> 
>                 /* Return 0 so that we don't trigger an unnecessary
>                  * command reject packet.
>                  */
> -               return 0;
> +               goto unlock;
>         }
> 
>         chan->tx_credits += credits;
> @@ -5912,7 +5921,9 @@ static inline int l2cap_le_credits(struct
> l2cap_conn *conn,
>         if (chan->tx_credits)
>                 chan->ops->resume(chan);
> 
> +unlock:
>         l2cap_chan_unlock(chan);
> +       l2cap_chan_put(chan);
> 
>         return 0;
>  }
> @@ -7598,6 +7609,7 @@ static void l2cap_data_channel(struct l2cap_conn
> *conn, u16 cid,
> 
>  done:
>         l2cap_chan_unlock(chan);
> +       l2cap_chan_put(chan);
>  }
> 
>  static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
> 
> 
> >
> 
> 
> 

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
