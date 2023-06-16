Return-Path: <netdev+bounces-11310-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC012732877
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE60D1C20F5E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A716130;
	Fri, 16 Jun 2023 07:10:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3281210A
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 07:10:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5412D4C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 00:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686899447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9EfZviK8y+xCennODDVFKmoj6RoIJIadxDImLRxBk50=;
	b=B+A/LV9CdvWJSVZC5N5Ijs4TM/RtreIvbNWgGiyDsiHAZgEO9+xonAEqdQhXsxmTcNnVbt
	6KqOBw1pjlHPY7jN6dColVFnwXllK7aoAyGoEn9w111zLaESfhwK1inw7kJU+FbLSPmkAM
	wGhYXcfE+wUmRBk+ACEiQou1GeS+CYo=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-U1mYUbqdN0uqpkSYU1KQJQ-1; Fri, 16 Jun 2023 03:10:43 -0400
X-MC-Unique: U1mYUbqdN0uqpkSYU1KQJQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4ec817fb123so237783e87.3
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 00:10:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686899442; x=1689491442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9EfZviK8y+xCennODDVFKmoj6RoIJIadxDImLRxBk50=;
        b=L7gA1n4LgOiYakoDqEuCye+zYUzaYjNCmhNinGMFVbBDAsHTF4s2ptP5Uv66mxpVay
         jck3gLQEJmpyAd1bxMLKXr+BwDkGFyCTIMoESvgBEp5sgRgdFcFBNosIPR9u33Ne2+SM
         488LhDRyC5/ToE9kLjcnOAF5vn/aVPr5Zll/ACdn7H3gP8wayL3WEnKiXrNm1OuVNiup
         VaynSwatYHJ4F5dm5/GohyKE2tp+V44/LDfTs4ixjGVslYGo70UUDpDZaAdqGcM4enF+
         Ue74RIkVWc8g5vd5eTj1a80HOhwS/vu7bFl/NuPagxy1Hs/cF/RADiezdfbcdOamsUdJ
         CD3A==
X-Gm-Message-State: AC+VfDxneCIDscAAERJqoyJm0R6a+aO9sns+fo1d2FrohwmcnFh4qr1e
	yTsKuzweKlkQ1lOoG9e1btOdMLMshyTF80pZK4nNtnRULgQJn/79jt6XIs2AhP111EdiVZIfoxT
	8B+ZGHdYdmxkhXxtbY8TDSUkxo19Yc4tO
X-Received: by 2002:a19:e005:0:b0:4db:1e4a:74a1 with SMTP id x5-20020a19e005000000b004db1e4a74a1mr553984lfg.0.1686899442240;
        Fri, 16 Jun 2023 00:10:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ45EeE5jjrxXy/EfdgQ2Y4cR3tKY/Vgk0UmKs5015Ouy2WOw0VEq3BYGKwI/krjwXB2XvHdDTIOPUNknyH7TIM=
X-Received: by 2002:a19:e005:0:b0:4db:1e4a:74a1 with SMTP id
 x5-20020a19e005000000b004db1e4a74a1mr553963lfg.0.1686899441855; Fri, 16 Jun
 2023 00:10:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230615084929.10506-1-ihuguet@redhat.com> <ZIroTOtyvknhzP2r@boxer>
In-Reply-To: <ZIroTOtyvknhzP2r@boxer>
From: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date: Fri, 16 Jun 2023 09:10:30 +0200
Message-ID: <CACT4oufpuQcV9Ma+3XwbiOGKev8Pq1Kk+f=QFX9KfURhjU-G=g@mail.gmail.com>
Subject: Re: [PATCH v2 net] sfc: use budget for TX completions
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	netdev@vger.kernel.org, linux-net-drivers@amd.com, bkenward@solarflare.com, 
	Fei Liu <feliu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 12:31=E2=80=AFPM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Thu, Jun 15, 2023 at 10:49:29AM +0200, =C3=8D=C3=B1igo Huguet wrote:
> > When running workloads heavy unbalanced towards TX (high TX, low RX
> > traffic), sfc driver can retain the CPU during too long times. Although
> > in many cases this is not enough to be visible, it can affect
> > performance and system responsiveness.
>
> What is a v1..v2 diff? Please include this in future.

Oh, yes, sorry. I'm not inspired at all with this patch's
"administrative" requirements.

The only diff is the addition of the Fixes tags.

>
> >
> > A way to reproduce it is to use a debug kernel and run some parallel
> > netperf TX tests. In some systems, this will lead to this message being
> > logged:
> >   kernel:watchdog: BUG: soft lockup - CPU#12 stuck for 22s!
>
> Hmm debug kernel is pretty wide term to me. maybe you could drop few
> config options specific to your setup?

I used RHEL's kernel-debug package. It has many debug options enabled,
but to name a few: kasan, lockdep, etc. In this case, I think that it
was mostly relevant to artificially increase the CPU stress in kernel
mode, nothing more.

>
> >
> > The reason is that sfc driver doesn't account any NAPI budget for the T=
X
> > completion events work. With high-TX/low-RX traffic, this makes that th=
e
> > CPU is held for long time for NAPI poll.
> >
> > Documentations says "drivers can process completions for any number of =
Tx
> > packets but should only process up to budget number of Rx packets".
> > However, many drivers do limit the amount of TX completions that they
> > process in a single NAPI poll.
> >
> > In the same way, this patch adds a limit for the TX work in sfc. With
> > the patch applied, the watchdog warning never appears.
>
> please use imperative mood.
>
> >
> > Tested with netperf in different combinations: single process / paralle=
l
> > processes, TCP / UDP and different sizes of UDP messages. Repeated the
> > tests before and after the patch, without any noticeable difference in
> > network or CPU performance.
> >
> > Test hardware:
> > Intel(R) Xeon(R) CPU E5-1620 v4 @ 3.50GHz (4 cores, 2 threads/core)
> > Solarflare Communications XtremeScale X2522-25G Network Adapter
> >
> > Fixes: 5227ecccea2d ("sfc: remove tx and MCDI handling from NAPI budget=
 consideration")
> > Fixes: d19a53721863 ("sfc_ef100: TX path for EF100 NICs")
> > Reported-by: Fei Liu <feliu@redhat.com>
> > Signed-off-by: =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>
> > ---
> >  drivers/net/ethernet/sfc/ef10.c      | 25 ++++++++++++++++++-------
> >  drivers/net/ethernet/sfc/ef100_nic.c |  7 ++++++-
> >  drivers/net/ethernet/sfc/ef100_tx.c  |  4 ++--
> >  drivers/net/ethernet/sfc/ef100_tx.h  |  2 +-
> >  drivers/net/ethernet/sfc/tx_common.c |  4 +++-
> >  drivers/net/ethernet/sfc/tx_common.h |  2 +-
> >  6 files changed, 31 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc=
/ef10.c
> > index d30459dbfe8f..b63e47af6365 100644
> > --- a/drivers/net/ethernet/sfc/ef10.c
> > +++ b/drivers/net/ethernet/sfc/ef10.c
> > @@ -2950,7 +2950,7 @@ static u32 efx_ef10_extract_event_ts(efx_qword_t =
*event)
> >       return tstamp;
> >  }
> >
> > -static void
> > +static int
> >  efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *eve=
nt)
> >  {
> >       struct efx_nic *efx =3D channel->efx;
> > @@ -2958,13 +2958,14 @@ efx_ef10_handle_tx_event(struct efx_channel *ch=
annel, efx_qword_t *event)
> >       unsigned int tx_ev_desc_ptr;
> >       unsigned int tx_ev_q_label;
> >       unsigned int tx_ev_type;
> > +     int work_done;
> >       u64 ts_part;
> >
> >       if (unlikely(READ_ONCE(efx->reset_pending)))
> > -             return;
> > +             return 0;
> >
> >       if (unlikely(EFX_QWORD_FIELD(*event, ESF_DZ_TX_DROP_EVENT)))
> > -             return;
> > +             return 0;
> >
> >       /* Get the transmit queue */
> >       tx_ev_q_label =3D EFX_QWORD_FIELD(*event, ESF_DZ_TX_QLABEL);
> > @@ -2973,8 +2974,7 @@ efx_ef10_handle_tx_event(struct efx_channel *chan=
nel, efx_qword_t *event)
> >       if (!tx_queue->timestamping) {
> >               /* Transmit completion */
> >               tx_ev_desc_ptr =3D EFX_QWORD_FIELD(*event, ESF_DZ_TX_DESC=
R_INDX);
> > -             efx_xmit_done(tx_queue, tx_ev_desc_ptr & tx_queue->ptr_ma=
sk);
> > -             return;
> > +             return efx_xmit_done(tx_queue, tx_ev_desc_ptr & tx_queue-=
>ptr_mask);
> >       }
> >
> >       /* Transmit timestamps are only available for 8XXX series. They r=
esult
> > @@ -3000,6 +3000,7 @@ efx_ef10_handle_tx_event(struct efx_channel *chan=
nel, efx_qword_t *event)
> >        * fields in the event.
> >        */
> >       tx_ev_type =3D EFX_QWORD_FIELD(*event, ESF_EZ_TX_SOFT1);
> > +     work_done =3D 0;
> >
> >       switch (tx_ev_type) {
> >       case TX_TIMESTAMP_EVENT_TX_EV_COMPLETION:
> > @@ -3016,6 +3017,7 @@ efx_ef10_handle_tx_event(struct efx_channel *chan=
nel, efx_qword_t *event)
> >               tx_queue->completed_timestamp_major =3D ts_part;
> >
> >               efx_xmit_done_single(tx_queue);
> > +             work_done =3D 1;
> >               break;
> >
> >       default:
> > @@ -3026,6 +3028,8 @@ efx_ef10_handle_tx_event(struct efx_channel *chan=
nel, efx_qword_t *event)
> >                         EFX_QWORD_VAL(*event));
> >               break;
> >       }
> > +
> > +     return work_done;
> >  }
> >
> >  static void
> > @@ -3081,13 +3085,16 @@ static void efx_ef10_handle_driver_generated_ev=
ent(struct efx_channel *channel,
> >       }
> >  }
> >
> > +#define EFX_NAPI_MAX_TX 512
> > +
> >  static int efx_ef10_ev_process(struct efx_channel *channel, int quota)
> >  {
> >       struct efx_nic *efx =3D channel->efx;
> >       efx_qword_t event, *p_event;
> >       unsigned int read_ptr;
> > -     int ev_code;
> > +     int spent_tx =3D 0;
> >       int spent =3D 0;
> > +     int ev_code;
> >
> >       if (quota <=3D 0)
> >               return spent;
> > @@ -3126,7 +3133,11 @@ static int efx_ef10_ev_process(struct efx_channe=
l *channel, int quota)
> >                       }
> >                       break;
> >               case ESE_DZ_EV_CODE_TX_EV:
> > -                     efx_ef10_handle_tx_event(channel, &event);
> > +                     spent_tx +=3D efx_ef10_handle_tx_event(channel, &=
event);
> > +                     if (spent_tx >=3D EFX_NAPI_MAX_TX) {
> > +                             spent =3D quota;
> > +                             goto out;
> > +                     }
> >                       break;
> >               case ESE_DZ_EV_CODE_DRIVER_EV:
> >                       efx_ef10_handle_driver_event(channel, &event);
> > diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/etherne=
t/sfc/ef100_nic.c
> > index 4dc643b0d2db..7adde9639c8a 100644
> > --- a/drivers/net/ethernet/sfc/ef100_nic.c
> > +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> > @@ -253,6 +253,8 @@ static void ef100_ev_read_ack(struct efx_channel *c=
hannel)
> >                  efx_reg(channel->efx, ER_GZ_EVQ_INT_PRIME));
> >  }
> >
> > +#define EFX_NAPI_MAX_TX 512
> > +
> >  static int ef100_ev_process(struct efx_channel *channel, int quota)
> >  {
> >       struct efx_nic *efx =3D channel->efx;
> > @@ -260,6 +262,7 @@ static int ef100_ev_process(struct efx_channel *cha=
nnel, int quota)
> >       bool evq_phase, old_evq_phase;
> >       unsigned int read_ptr;
> >       efx_qword_t *p_event;
> > +     int spent_tx =3D 0;
> >       int spent =3D 0;
> >       bool ev_phase;
> >       int ev_type;
> > @@ -295,7 +298,9 @@ static int ef100_ev_process(struct efx_channel *cha=
nnel, int quota)
> >                       efx_mcdi_process_event(channel, p_event);
> >                       break;
> >               case ESE_GZ_EF100_EV_TX_COMPLETION:
> > -                     ef100_ev_tx(channel, p_event);
> > +                     spent_tx +=3D ef100_ev_tx(channel, p_event);
> > +                     if (spent_tx >=3D EFX_NAPI_MAX_TX)
> > +                             spent =3D quota;
> >                       break;
> >               case ESE_GZ_EF100_EV_DRIVER:
> >                       netif_info(efx, drv, efx->net_dev,
> > diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet=
/sfc/ef100_tx.c
> > index 29ffaf35559d..849e5555bd12 100644
> > --- a/drivers/net/ethernet/sfc/ef100_tx.c
> > +++ b/drivers/net/ethernet/sfc/ef100_tx.c
> > @@ -346,7 +346,7 @@ void ef100_tx_write(struct efx_tx_queue *tx_queue)
> >       ef100_tx_push_buffers(tx_queue);
> >  }
> >
> > -void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_eve=
nt)
> > +int ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_even=
t)
> >  {
> >       unsigned int tx_done =3D
> >               EFX_QWORD_FIELD(*p_event, ESF_GZ_EV_TXCMPL_NUM_DESC);
> > @@ -357,7 +357,7 @@ void ef100_ev_tx(struct efx_channel *channel, const=
 efx_qword_t *p_event)
> >       unsigned int tx_index =3D (tx_queue->read_count + tx_done - 1) &
> >                               tx_queue->ptr_mask;
> >
> > -     efx_xmit_done(tx_queue, tx_index);
> > +     return efx_xmit_done(tx_queue, tx_index);
> >  }
> >
> >  /* Add a socket buffer to a TX queue
> > diff --git a/drivers/net/ethernet/sfc/ef100_tx.h b/drivers/net/ethernet=
/sfc/ef100_tx.h
> > index e9e11540fcde..d9a0819c5a72 100644
> > --- a/drivers/net/ethernet/sfc/ef100_tx.h
> > +++ b/drivers/net/ethernet/sfc/ef100_tx.h
> > @@ -20,7 +20,7 @@ void ef100_tx_init(struct efx_tx_queue *tx_queue);
> >  void ef100_tx_write(struct efx_tx_queue *tx_queue);
> >  unsigned int ef100_tx_max_skb_descs(struct efx_nic *efx);
> >
> > -void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_eve=
nt);
> > +int ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_even=
t);
> >
> >  netdev_tx_t ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk=
_buff *skb);
> >  int __ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff =
*skb,
> > diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/etherne=
t/sfc/tx_common.c
> > index 67e789b96c43..755aa92bf823 100644
> > --- a/drivers/net/ethernet/sfc/tx_common.c
> > +++ b/drivers/net/ethernet/sfc/tx_common.c
> > @@ -249,7 +249,7 @@ void efx_xmit_done_check_empty(struct efx_tx_queue =
*tx_queue)
> >       }
> >  }
> >
> > -void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
> > +int efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
> >  {
> >       unsigned int fill_level, pkts_compl =3D 0, bytes_compl =3D 0;
> >       unsigned int efv_pkts_compl =3D 0;
> > @@ -279,6 +279,8 @@ void efx_xmit_done(struct efx_tx_queue *tx_queue, u=
nsigned int index)
> >       }
> >
> >       efx_xmit_done_check_empty(tx_queue);
> > +
> > +     return pkts_compl + efv_pkts_compl;
> >  }
> >
> >  /* Remove buffers put into a tx_queue for the current packet.
> > diff --git a/drivers/net/ethernet/sfc/tx_common.h b/drivers/net/etherne=
t/sfc/tx_common.h
> > index d87aecbc7bf1..1e9f42938aac 100644
> > --- a/drivers/net/ethernet/sfc/tx_common.h
> > +++ b/drivers/net/ethernet/sfc/tx_common.h
> > @@ -28,7 +28,7 @@ static inline bool efx_tx_buffer_in_use(struct efx_tx=
_buffer *buffer)
> >  }
> >
> >  void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue);
> > -void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
> > +int efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
> >
> >  void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
> >                       unsigned int insert_count);
> > --
> > 2.40.1
> >
> >
>


--=20
=C3=8D=C3=B1igo Huguet


