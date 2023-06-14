Return-Path: <netdev+bounces-10632-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10C0172F773
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:11:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D0081C20B1F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C19E4696;
	Wed, 14 Jun 2023 08:11:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6517F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:11:03 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E091BD4
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:11:00 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-97460240863so73960966b.0
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686730258; x=1689322258;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+8ruHIDAglH4QoGtludLTKXm2VgL+SnZIxMBze5VGH4=;
        b=isMOPcB6uYfgFgwAWzngp7JrFRD8tgWShotZ++Qm6b+nvrvUnWO29DSI2oCQ1eeoPW
         MUfO4lYdcfv4UAAMUFAy/ofUiHuSCQMgAQ1NpzA4m3qczNTFy+NpsB+XfybJRJ+B7tTN
         WCw5kyiQLd+RU5qEAShW2F0A8HggB0Eb9QOfYxh/s0CwS8PlERgaZfFfT/v4El4gV31h
         9RE0QE6DS8NT/H+2TBT/Nd6c3+qwd075rVnofFN9ogozKJJEh5izR2HNsfMO6W0meaja
         rQCZgkH9Rgy1aWp0qoEisDqXBzIn4IJquxQMGHWjsWs8mtj2oQkVMAyi/dVGK4PTiqqx
         ihfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686730258; x=1689322258;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+8ruHIDAglH4QoGtludLTKXm2VgL+SnZIxMBze5VGH4=;
        b=BoWmLG1pAVtis8gIvKscxwmudipBd21l8LxB2PGhJ2nV5jCUxZofD/99nwLRbwsXKl
         YTSQgoxw3nVhDs8u8WWsLDjFg0XuDzGMYT7hpBLiaejcduJBAIzxpZBsQ5Pro5WnoKjI
         Uhd7UeVCcdKwDRYFtNU2l85UU61se3Lvgas5wI8UK5tRQjL/3Uef8M+RYEpMGBEf1Hej
         GMDgjjaGXpJMhr3wSj2t/OrapbkC4V6QLtPELaBBuP7IJ2ValIoLRr0zTNLqdnWp1dfm
         3W1bVN2M0irf78p2960XbqHvjIT0Cludt8U5dwWdyT/exth0iGc3N+NioAZJPzajNZUw
         nJkA==
X-Gm-Message-State: AC+VfDzn8YvXZVzqGcSK6yolE7VSImC37+OhN4o9RrriWCifV8fIGkq+
	1/J14KmLFRH88GI+Z5/6nhc=
X-Google-Smtp-Source: ACHHUZ7viVkDU0J/i+Zcv8nmbOSV2C56qSVyEU7Zd/BHiC5H7+ZYOwujjHwxpfU7BfEPegXE45gLyg==
X-Received: by 2002:a17:907:168f:b0:94f:449e:75db with SMTP id hc15-20020a170907168f00b0094f449e75dbmr15557097ejc.52.1686730258437;
        Wed, 14 Jun 2023 01:10:58 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id sa1-20020a170906eda100b009745a6d1b37sm7624506ejb.202.2023.06.14.01.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 01:10:57 -0700 (PDT)
Date: Wed, 14 Jun 2023 09:10:55 +0100
From: Martin Habets <habetsm.xilinx@gmail.com>
To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-net-drivers@amd.com, Fei Liu <feliu@redhat.com>
Subject: Re: [PATCH net] sfc: use budget for TX completions
Message-ID: <ZIl2Dw9Ve0b30WmV@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-net-drivers@amd.com, Fei Liu <feliu@redhat.com>
References: <20230612144254.21039-1-ihuguet@redhat.com>
 <ZIdCFbjr0nEiS6+m@boxer>
 <CACT4oucSRrddFYaNDBsuvK_4imDZUvy9r2pvHp8Ji_E=oP6ecg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4oucSRrddFYaNDBsuvK_4imDZUvy9r2pvHp8Ji_E=oP6ecg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 04:42:25PM +0200, Íñigo Huguet wrote:
> On Mon, Jun 12, 2023 at 6:05 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > On Mon, Jun 12, 2023 at 04:42:54PM +0200, Íñigo Huguet wrote:
> >
> > Hey Inigo, some trivial things below.
> >
> > > When running workloads heavy unbalanced towards TX (high TX, low RX
> > > traffic), sfc driver can retain the CPU during too long times. Although
> > > in many cases this is not enough to be visible, it can affect
> > > performance and system responsiveness.
> > >
> > > A way to reproduce it is to use a debug kernel and run some parallel
> > > netperf TX tests. In some systems, this will lead to this message being
> > > logged:
> > >   kernel:watchdog: BUG: soft lockup - CPU#12 stuck for 22s!
> > >
> > > The reason is that sfc driver doesn't account any NAPI budget for the TX
> > > completion events work. With high-TX/low-RX traffic, this makes that the
> > > CPU is held for long time for NAPI poll.
> > >
> > > Documentations says "drivers can process completions for any number of Tx
> > > packets but should only process up to budget number of Rx packets".
> > > However, many drivers do limit the amount of TX completions that they
> > > process in a single NAPI poll.
> > >
> > > In the same way, this patch adds a limit for the TX work in sfc. With
> > > the patch applied, the watchdog warning never appears.
> > >
> > > Tested with netperf in different combinations: single process / parallel
> > > processes, TCP / UDP and different sizes of UDP messages. Repeated the
> > > tests before and after the patch, without any noticeable difference in
> > > network or CPU performance.
> > >
> > > Test hardware:
> > > Intel(R) Xeon(R) CPU E5-1620 v4 @ 3.50GHz (4 cores, 2 threads/core)
> > > Solarflare Communications XtremeScale X2522-25G Network Adapter
> > >
> > > Reported-by: Fei Liu <feliu@redhat.com>
> > > Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> >
> > You're missing Fixes: tag.
> 
> Thanks for the reminder!
> 
> >
> > > ---
> > >  drivers/net/ethernet/sfc/ef10.c      | 25 ++++++++++++++++++-------
> > >  drivers/net/ethernet/sfc/ef100_nic.c |  7 ++++++-
> > >  drivers/net/ethernet/sfc/ef100_tx.c  |  4 ++--
> > >  drivers/net/ethernet/sfc/ef100_tx.h  |  2 +-
> > >  drivers/net/ethernet/sfc/tx_common.c |  4 +++-
> > >  drivers/net/ethernet/sfc/tx_common.h |  2 +-
> > >  6 files changed, 31 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> > > index d30459dbfe8f..b63e47af6365 100644
> > > --- a/drivers/net/ethernet/sfc/ef10.c
> > > +++ b/drivers/net/ethernet/sfc/ef10.c
> > > @@ -2950,7 +2950,7 @@ static u32 efx_ef10_extract_event_ts(efx_qword_t *event)
> > >       return tstamp;
> > >  }
> > >
> > > -static void
> > > +static int
> > >  efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
> > >  {
> > >       struct efx_nic *efx = channel->efx;
> > > @@ -2958,13 +2958,14 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
> > >       unsigned int tx_ev_desc_ptr;
> > >       unsigned int tx_ev_q_label;
> > >       unsigned int tx_ev_type;
> > > +     int work_done;
> > >       u64 ts_part;
> > >
> > >       if (unlikely(READ_ONCE(efx->reset_pending)))
> > > -             return;
> > > +             return 0;
> > >
> > >       if (unlikely(EFX_QWORD_FIELD(*event, ESF_DZ_TX_DROP_EVENT)))
> > > -             return;
> > > +             return 0;
> > >
> > >       /* Get the transmit queue */
> > >       tx_ev_q_label = EFX_QWORD_FIELD(*event, ESF_DZ_TX_QLABEL);
> > > @@ -2973,8 +2974,7 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
> > >       if (!tx_queue->timestamping) {
> > >               /* Transmit completion */
> > >               tx_ev_desc_ptr = EFX_QWORD_FIELD(*event, ESF_DZ_TX_DESCR_INDX);
> > > -             efx_xmit_done(tx_queue, tx_ev_desc_ptr & tx_queue->ptr_mask);
> > > -             return;
> > > +             return efx_xmit_done(tx_queue, tx_ev_desc_ptr & tx_queue->ptr_mask);
> > >       }
> > >
> > >       /* Transmit timestamps are only available for 8XXX series. They result
> > > @@ -3000,6 +3000,7 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
> > >        * fields in the event.
> > >        */
> > >       tx_ev_type = EFX_QWORD_FIELD(*event, ESF_EZ_TX_SOFT1);
> > > +     work_done = 0;
> > >
> > >       switch (tx_ev_type) {
> > >       case TX_TIMESTAMP_EVENT_TX_EV_COMPLETION:
> > > @@ -3016,6 +3017,7 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
> > >               tx_queue->completed_timestamp_major = ts_part;
> > >
> > >               efx_xmit_done_single(tx_queue);
> > > +             work_done = 1;
> > >               break;
> > >
> > >       default:
> > > @@ -3026,6 +3028,8 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
> > >                         EFX_QWORD_VAL(*event));
> > >               break;
> > >       }
> > > +
> > > +     return work_done;
> > >  }
> > >
> > >  static void
> > > @@ -3081,13 +3085,16 @@ static void efx_ef10_handle_driver_generated_event(struct efx_channel *channel,
> > >       }
> > >  }
> > >
> > > +#define EFX_NAPI_MAX_TX 512
> > > +
> > >  static int efx_ef10_ev_process(struct efx_channel *channel, int quota)
> > >  {
> > >       struct efx_nic *efx = channel->efx;
> > >       efx_qword_t event, *p_event;
> > >       unsigned int read_ptr;
> > > -     int ev_code;
> > > +     int spent_tx = 0;
> > >       int spent = 0;
> > > +     int ev_code;
> > >
> > >       if (quota <= 0)
> > >               return spent;
> > > @@ -3126,7 +3133,11 @@ static int efx_ef10_ev_process(struct efx_channel *channel, int quota)
> > >                       }
> > >                       break;
> > >               case ESE_DZ_EV_CODE_TX_EV:
> > > -                     efx_ef10_handle_tx_event(channel, &event);
> > > +                     spent_tx += efx_ef10_handle_tx_event(channel, &event);
> > > +                     if (spent_tx >= EFX_NAPI_MAX_TX) {
> > > +                             spent = quota;
> > > +                             goto out;
> > > +                     }
> > >                       break;
> > >               case ESE_DZ_EV_CODE_DRIVER_EV:
> > >                       efx_ef10_handle_driver_event(channel, &event);
> > > diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> > > index 4dc643b0d2db..7adde9639c8a 100644
> > > --- a/drivers/net/ethernet/sfc/ef100_nic.c
> > > +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> > > @@ -253,6 +253,8 @@ static void ef100_ev_read_ack(struct efx_channel *channel)
> > >                  efx_reg(channel->efx, ER_GZ_EVQ_INT_PRIME));
> > >  }
> > >
> > > +#define EFX_NAPI_MAX_TX 512
> >
> > couldn't this go to tx_common.h ? you're defining this two times.
> 
> Not sure about this. I didn't like any place to put it, so I ended up
> putting it here. As it is an implementation detail, I didn't like the
> idea of putting it in a header file that contains the driver's API.
> 
> I would better like to hear the opinion from the sfc maintainers, but
> I don't mind changing it because I'm neither happy with the chosen
> location.

I think we should add it in include/linux/netdevice.h, close to
NAPI_POLL_WEIGHT. That way all drivers can use it.
Do we need to add this TX poll weight to struct napi_struct and
extend netif_napi_add_weight()?
That way all drivers could use the value from napi_struct in stead of using
a hard-coded define. And at some point we can adjust it.

Martin

> 
> >
> > > +
> > >  static int ef100_ev_process(struct efx_channel *channel, int quota)
> > >  {
> > >       struct efx_nic *efx = channel->efx;
> > > @@ -260,6 +262,7 @@ static int ef100_ev_process(struct efx_channel *channel, int quota)
> > >       bool evq_phase, old_evq_phase;
> > >       unsigned int read_ptr;
> > >       efx_qword_t *p_event;
> > > +     int spent_tx = 0;
> > >       int spent = 0;
> > >       bool ev_phase;
> > >       int ev_type;
> > > @@ -295,7 +298,9 @@ static int ef100_ev_process(struct efx_channel *channel, int quota)
> > >                       efx_mcdi_process_event(channel, p_event);
> > >                       break;
> > >               case ESE_GZ_EF100_EV_TX_COMPLETION:
> > > -                     ef100_ev_tx(channel, p_event);
> > > +                     spent_tx += ef100_ev_tx(channel, p_event);
> > > +                     if (spent_tx >= EFX_NAPI_MAX_TX)
> > > +                             spent = quota;
> > >                       break;
> > >               case ESE_GZ_EF100_EV_DRIVER:
> > >                       netif_info(efx, drv, efx->net_dev,
> > > diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
> > > index 29ffaf35559d..849e5555bd12 100644
> > > --- a/drivers/net/ethernet/sfc/ef100_tx.c
> > > +++ b/drivers/net/ethernet/sfc/ef100_tx.c
> > > @@ -346,7 +346,7 @@ void ef100_tx_write(struct efx_tx_queue *tx_queue)
> > >       ef100_tx_push_buffers(tx_queue);
> > >  }
> > >
> > > -void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event)
> > > +int ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event)
> > >  {
> > >       unsigned int tx_done =
> > >               EFX_QWORD_FIELD(*p_event, ESF_GZ_EV_TXCMPL_NUM_DESC);
> > > @@ -357,7 +357,7 @@ void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event)
> > >       unsigned int tx_index = (tx_queue->read_count + tx_done - 1) &
> > >                               tx_queue->ptr_mask;
> > >
> > > -     efx_xmit_done(tx_queue, tx_index);
> > > +     return efx_xmit_done(tx_queue, tx_index);
> > >  }
> > >
> > >  /* Add a socket buffer to a TX queue
> > > diff --git a/drivers/net/ethernet/sfc/ef100_tx.h b/drivers/net/ethernet/sfc/ef100_tx.h
> > > index e9e11540fcde..d9a0819c5a72 100644
> > > --- a/drivers/net/ethernet/sfc/ef100_tx.h
> > > +++ b/drivers/net/ethernet/sfc/ef100_tx.h
> > > @@ -20,7 +20,7 @@ void ef100_tx_init(struct efx_tx_queue *tx_queue);
> > >  void ef100_tx_write(struct efx_tx_queue *tx_queue);
> > >  unsigned int ef100_tx_max_skb_descs(struct efx_nic *efx);
> > >
> > > -void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event);
> > > +int ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event);
> > >
> > >  netdev_tx_t ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
> > >  int __ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
> > > diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
> > > index 67e789b96c43..755aa92bf823 100644
> > > --- a/drivers/net/ethernet/sfc/tx_common.c
> > > +++ b/drivers/net/ethernet/sfc/tx_common.c
> > > @@ -249,7 +249,7 @@ void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue)
> > >       }
> > >  }
> > >
> > > -void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
> > > +int efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
> > >  {
> > >       unsigned int fill_level, pkts_compl = 0, bytes_compl = 0;
> > >       unsigned int efv_pkts_compl = 0;
> > > @@ -279,6 +279,8 @@ void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
> > >       }
> > >
> > >       efx_xmit_done_check_empty(tx_queue);
> > > +
> > > +     return pkts_compl + efv_pkts_compl;
> > >  }
> > >
> > >  /* Remove buffers put into a tx_queue for the current packet.
> > > diff --git a/drivers/net/ethernet/sfc/tx_common.h b/drivers/net/ethernet/sfc/tx_common.h
> > > index d87aecbc7bf1..1e9f42938aac 100644
> > > --- a/drivers/net/ethernet/sfc/tx_common.h
> > > +++ b/drivers/net/ethernet/sfc/tx_common.h
> > > @@ -28,7 +28,7 @@ static inline bool efx_tx_buffer_in_use(struct efx_tx_buffer *buffer)
> > >  }
> > >
> > >  void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue);
> > > -void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
> > > +int efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
> > >
> > >  void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
> > >                       unsigned int insert_count);
> > > --
> > > 2.40.1
> > >
> > >
> >
> 
> 
> -- 
> Íñigo Huguet

