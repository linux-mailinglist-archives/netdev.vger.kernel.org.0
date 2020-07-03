Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4EF2137BD
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 11:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgGCJdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 05:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGCJdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 05:33:06 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC60C08C5C1
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 02:33:06 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id e4so36212565ljn.4
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 02:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:to:cc:subject:from:date:message-id
         :in-reply-to;
        bh=2IXL7XnztUX4OLhixYrM9vdRH4iSu9LGJagzTEsJ55w=;
        b=bX6xtVFVfqOx0o0ag0niDz6ZzZx1S3oCfzEycqKBD5es1UulO2Fje1Og24k8QyJ5CC
         poYGQZqld+nk8+65R8h49jEx0AaUH/rtehsiVME7VePbxwhEkbieCCn3PvDmlQzR7eYP
         g+kRgFw4lHRST1i0a0uYUI9WQgATaIa1UIWf7s+Dk4ewQX3m4IRlPxGKNItBKtyfluVW
         uS0JMTxJiQXJuJyqfgk6DVJ3s44G21EC8oi4HeVXceHkP1We+qNLGAmLz5C8vS5VymZK
         e3F4n/0i16wrjXI8LIUR5IOr46HKMjxFfg0Am+IqLZdFw8T2hxrKR6KPLp4IJ55cYwni
         oHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:to:cc:subject:from
         :date:message-id:in-reply-to;
        bh=2IXL7XnztUX4OLhixYrM9vdRH4iSu9LGJagzTEsJ55w=;
        b=AjxtrG/6vqFoLDLU0Ysdis2hJIHhwu44fXVTL99AmXr4Ot8GwkfYqc/2+Ec+pncjsS
         hPKJ428SCPBlZkuspd/ab1xL3Ai/o2ncNFVnAUFUgc19v2BsmHMJ4K6LUW+wbUGBjLxV
         i5fAGQ6FMHkAqNSgGGVLU5nnXwBWwYA7o+kVPcYXLexu3VKvXpG0jP8oXVgMBaQ6ZJtN
         2rfQ38yysUK5qgIuqS6AtDSMhVCFzmAEzxiBTG7udFYpn9oOVSJuBYPdSz4IcMwHiSXo
         moPgqOnywpzSwRlW5mP98lue0s6rDd99MhJTHtG2LCeLrg0oKnH1lqObbVP1F4YSWImL
         4Ufg==
X-Gm-Message-State: AOAM5321tbxz1CPIyF8vidKJ9m4d1rwubq4nVv69WkDMU9SX0ye9M0Yo
        Vc4JRuGtUrkHtMrihbNcsF6Kpi8DO4U=
X-Google-Smtp-Source: ABdhPJwp+YysFeHdUxoiwcfOj+TuwbIsYlMaveIwrm2KLNVZMkWLeeoZFf50NHAkYHC3/pp3n4DiJg==
X-Received: by 2002:a2e:880c:: with SMTP id x12mr19623008ljh.375.1593768784166;
        Fri, 03 Jul 2020 02:33:04 -0700 (PDT)
Received: from localhost (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id b6sm451536ljj.89.2020.07.03.02.33.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 02:33:03 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To:     "Andy Duan" <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2 net] net: ethernet: fec: prevent tx starvation
 under high rx load
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
Date:   Fri, 03 Jul 2020 09:55:22 +0200
Message-Id: <C3WTSYT5IONB.21JUB7GA3HBW0@wkz-x280>
In-Reply-To: <AM6PR0402MB36074BB67E6704F82D2003FBFF6A0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri Jul 3, 2020 at 4:45 AM CEST, Andy Duan wrote:
> From: Tobias Waldekranz <tobias@waldekranz.com> Sent: Friday, July 3,
> 2020 4:58 AM
> > In the ISR, we poll the event register for the queues in need of servic=
e and
> > then enter polled mode. After this point, the event register will never=
 be read
> > again until we exit polled mode.
> >=20
> > In a scenario where a UDP flow is routed back out through the same inte=
rface,
> > i.e. "router-on-a-stick" we'll typically only see an rx queue event ini=
tially.
> > Once we start to process the incoming flow we'll be locked polled mode,=
 but
> > we'll never clean the tx rings since that event is never caught.
> >=20
> > Eventually the netdev watchdog will trip, causing all buffers to be dro=
pped and
> > then the process starts over again.
> >=20
> > Rework the NAPI poll to keep trying to consome the entire budget as lon=
g as
> > new events are coming in, making sure to service all rx/tx queues, in p=
riority
> > order, on each pass.
> >=20
> > Fixes: 4d494cdc92b3 ("net: fec: change data structure to support
> > multiqueue")
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> > ---
> >=20
> > v1 -> v2:
> > * Always do a full pass over all rx/tx queues as soon as any event is
> >   received, as suggested by David.
> > * Keep dequeuing packets as long as events keep coming in and we're
> >   under budget.
> >=20
> >  drivers/net/ethernet/freescale/fec.h      |  5 --
> >  drivers/net/ethernet/freescale/fec_main.c | 94 ++++++++---------------
> >  2 files changed, 31 insertions(+), 68 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/freescale/fec.h
> > b/drivers/net/ethernet/freescale/fec.h
> > index a6cdd5b61921..d8d76da51c5e 100644
> > --- a/drivers/net/ethernet/freescale/fec.h
> > +++ b/drivers/net/ethernet/freescale/fec.h
> > @@ -525,11 +525,6 @@ struct fec_enet_private {
> >         unsigned int total_tx_ring_size;
> >         unsigned int total_rx_ring_size;
> >=20
> > -       unsigned long work_tx;
> > -       unsigned long work_rx;
> > -       unsigned long work_ts;
> > -       unsigned long work_mdio;
> > -
> >         struct  platform_device *pdev;
> >=20
> >         int     dev_id;
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c
> > b/drivers/net/ethernet/freescale/fec_main.c
> > index 2d0d313ee7c5..84589d464850 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -75,8 +75,6 @@ static void fec_enet_itr_coal_init(struct net_device
> > *ndev);
> >=20
> >  #define DRIVER_NAME    "fec"
> >=20
> > -#define FEC_ENET_GET_QUQUE(_x) ((_x =3D=3D 0) ? 1 : ((_x =3D=3D 1) ? 2=
 : 0))
> > -
> >  /* Pause frame feild and FIFO threshold */
> >  #define FEC_ENET_FCE   (1 << 5)
> >  #define FEC_ENET_RSEM_V        0x84
> > @@ -1248,8 +1246,6 @@ fec_enet_tx_queue(struct net_device *ndev, u16
> > queue_id)
> >=20
> >         fep =3D netdev_priv(ndev);
> >=20
> > -       queue_id =3D FEC_ENET_GET_QUQUE(queue_id);
> > -
> >         txq =3D fep->tx_queue[queue_id];
> >         /* get next bdp of dirty_tx */
> >         nq =3D netdev_get_tx_queue(ndev, queue_id); @@ -1340,17
> > +1336,14 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
> >                 writel(0, txq->bd.reg_desc_active);  }
> >=20
> > -static void
> > -fec_enet_tx(struct net_device *ndev)
> > +static void fec_enet_tx(struct net_device *ndev)
> >  {
> >         struct fec_enet_private *fep =3D netdev_priv(ndev);
> > -       u16 queue_id;
> > -       /* First process class A queue, then Class B and Best Effort qu=
eue */
> > -       for_each_set_bit(queue_id, &fep->work_tx,
> > FEC_ENET_MAX_TX_QS) {
> > -               clear_bit(queue_id, &fep->work_tx);
> > -               fec_enet_tx_queue(ndev, queue_id);
> > -       }
> > -       return;
> > +       int i;
> > +
> > +       /* Make sure that AVB queues are processed first. */
> > +       for (i =3D fep->num_rx_queues - 1; i >=3D 0; i--)
>
> In fact, you already change the queue priority comparing before.
> Before: queue1 (Audio) > queue2 (video) > queue0 (best effort)
> Now: queue2 (video) > queue1 (Audio) > queue0 (best effort)

Yes, thank you, I meant to ask about that. I was looking at these
definitions in fec.h:

#define RCMR_CMP_1		(RCMR_CMP_CFG(0, 0) | RCMR_CMP_CFG(1, 1) | \
				RCMR_CMP_CFG(2, 2) | RCMR_CMP_CFG(3, 3))
#define RCMR_CMP_2		(RCMR_CMP_CFG(4, 0) | RCMR_CMP_CFG(5, 1) | \
				RCMR_CMP_CFG(6, 2) | RCMR_CMP_CFG(7, 3))

I read that as PCP 0-3 being mapped to queue 1 and 4-7 to queue
2. That led me to believe that the order should be 2, 1, 0. Is the
driver supposed to prioritize PCP 0-3 over 4-7, or have I
misunderstood completely?

> Other logic seems fine, but you should run stress test to avoid any
> block issue since the driver cover more than 20 imx platforms.

I have run stress tests and I observe that we're dequeuing about as
many packets from each queue when the incoming line is filled with 1/3
each of untagged/tagged-pcp0/tagged-pcp7 traffic:

root@envoy:~# ply -c "sleep 2" '
t:net/napi_gro_receive_entry {
    @[data->napi_id, data->queue_mapping] =3D count();
}'
ply: active
ply: deactivating

@:
{ 66, 3 }: 165811
{ 66, 2 }: 167733
{ 66, 1 }: 169470

It seems like this is due to "Receive flushing" not being enabled in
the FEC. If I manually enable it for queue 0, processing is restricted
to only queue 1 and 2:

root@envoy:~# devmem 0x30be01f0 32 $((1 << 3))
root@envoy:~# ply -c "sleep 2" '
t:net/napi_gro_receive_entry {
    @[data->napi_id, data->queue_mapping] =3D count();
}'
ply: active
ply: deactivating

@:
{ 66, 2 }: 275055
{ 66, 3 }: 275870

Enabling flushing on queue 1, focuses all processing on queue 2:

root@envoy:~# devmem 0x30be01f0 32 $((3 << 3))
root@envoy:~# ply -c "sleep 2" '
t:net/napi_gro_receive_entry {
    @[data->napi_id, data->queue_mapping] =3D count();
}'
ply: active
ply: deactivating

@:
{ 66, 3 }: 545442

Changing the default QoS settings feels like a separate change, but I
can submit a v3 as a series if you want?

I do not have access to a single-queue iMX device, would it be
possible for you to test this change on such a device?

