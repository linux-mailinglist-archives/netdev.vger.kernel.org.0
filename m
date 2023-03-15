Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B2A6BBE8A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 22:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbjCOVKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 17:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjCOVK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 17:10:29 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D982005B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 14:10:24 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id x36so1012998ljq.7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 14:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678914623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OoYynZHoC8ME0sDhHwB1tm1ZbvB2kwT1xjNmP0ScJaU=;
        b=NoRI9E7XhqpGwMq7uXn6V1Xttk/3eUr3pezaYEjozXYDG5j+YJiMC9NDbiKPJA51a2
         ZtpyHHn6InGwvRgK0SBfpNiA8m1H+Dbug68k4tRym4IPVQDqJgOZGhWHXtNUaiLwXkCX
         RcoHf2JXwFeDRi1w04hn4jWoxB2Th4JLKBgiDEJorGPwE9/n1rDo8yDrZDgmLx1Nw4FR
         bXil5ZTlP7hKBaLxiRYAX3MZfPAL4JAGP16zaRqLg5jQIS34xXJE3UN5/xC+q9UrcGHH
         S5RZrdgTkGxr+LhmjGxWATTXsX0w8iBILTr2p2hfm6bfNrUg7SmGUGXuFP1cmyfsJ6rk
         IkXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678914623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OoYynZHoC8ME0sDhHwB1tm1ZbvB2kwT1xjNmP0ScJaU=;
        b=Z+L7z2VXX1Kg4VW5G9nRXVybuugTXKPpjgI/1wJpLkgxxp5JBlsCmq08+urxRw37ob
         XANV5J3ijJ3MpUmCIiUD3otLLKF09imj+2TKr0M3zSt+QNOgf2P+RpBL7/hAA5Kt6V0e
         0nGc9OqXiTNSyq7VHmgAkvo2Kxipt2lcOiknALw8FGu1Eh0r6b0xS5WbU0anCWQLbL8v
         MBSlpcLRBv4twGps7W6FlKV8HLdf1XohDW2IhYtaclBi6MjJRVYcnO5yO9EniutwvSAS
         TTK1Osj1qxZDT3/9nqEzsYwPjIzZ3tCWzPQaXgvluZYF6l5i9rrQ4XJ5WsXz5ooO75e/
         GN3g==
X-Gm-Message-State: AO0yUKWLMW0Ut00C6viy6bDHBpnuCFP/9Ee+ubKKYt44E1tTAgQBhGTS
        g9GLwVUrU1u8UrG15o0tyKIukVTCtW11h+D88LQsig==
X-Google-Smtp-Source: AK7set9i7l06Utbm6bbrPGMefAw7Rsd7OOxque1kZra1yQnOX77naMdDGAktTN4NS80Hq/vu/CPD05vkPgZMGQ7VCRU=
X-Received: by 2002:a05:651c:2005:b0:295:d63a:949b with SMTP id
 s5-20020a05651c200500b00295d63a949bmr1330318ljo.4.1678914622647; Wed, 15 Mar
 2023 14:10:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230313202640.4113427-1-pkaligineedi@google.com>
 <20230313202640.4113427-4-pkaligineedi@google.com> <ZBH37Nn6omSoMQrK@localhost.localdomain>
In-Reply-To: <ZBH37Nn6omSoMQrK@localhost.localdomain>
From:   Praveen Kaligineedi <pkaligineedi@google.com>
Date:   Wed, 15 Mar 2023 14:10:10 -0700
Message-ID: <CA+f9V1NLgLFCjX27vEP9=ugv-MYMrurT-SHFQhcQQcjLbx6zag@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/5] gve: Add XDP DROP and TX support for
 GQI-QPL format
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        maciej.fijalkowski@intel.com, Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

Thanks for your feedback. We will add xdp_features
as part of version V4 of this patch. Please find my responses for other
comments inline:

On Wed, Mar 15, 2023 at 9:53=E2=80=AFAM Michal Kubiak <michal.kubiak@intel.=
com> wrote:
>
> On Mon, Mar 13, 2023 at 01:26:38PM -0700, Praveen Kaligineedi wrote:
> > Add support for XDP PASS, DROP and TX actions.
> >
> > This patch contains the following changes:
> > 1) Support installing/uninstalling XDP program
> > 2) Add dedicated XDP TX queues
> > 3) Add support for XDP DROP action
> > 4) Add support for XDP TX action
> >
> > Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
> > Reviewed-by: Jeroen de Borst <jeroendb@google.com>
> >
> > ---
> > Changed in v2:
> > - Removed gve_close/gve_open when adding XDP dedicated queues. Instead
> > we add and register additional TX queues when the XDP program is
> > installed. If the allocation/registration fails we return error and do
> > not install the XDP program.
> > - Removed xdp tx spin lock from this patch. It is needed for XDP_REDIRE=
CT
> > support as both XDP_REDIRECT and XDP_TX traffic share the dedicated XDP
> > queues. Moved the code to add xdp tx spinlock to the subsequent patch
> > that adds XDP_REDIRECT support.
> > - Added netdev_err when the user tries to set rx/tx queues to the value=
s
> > not supported when XDP is enabled.
> > - Removed rcu annotation for xdp_prog. We disable the napi prior to
> > adding/removing the xdp_prog and reenable it after the program has
> > been installed for all the queues.
> > - Ring the tx doorbell once for napi instead of every XDP TX packet.
> > - Added a new helper function for freeing the FIFO buffer
> > - Unregister xdp rxq for all the queues when the registration
> > fails during XDP program installation
> >
> > Changed in v3:
> > - Padding bytes are used if the XDP TX packet headers do not
> > fit at tail of TX FIFO. Taking these padding bytes into account
> > while checking if enough space is available in TX FIFO.
> > ---
>
> Hi Praveen,
>
> Please find my comments inline.
> Also, I have a general comment regarding newest XDP netdev API. As far
> as I checked you do not use "net_device.xdp_features". That member has
> been added to "struct net_device" since 6.3-rc1 kernel version and that
> feature are checked now before .ndo_bpf is called, so you should set all
> supported flags in that structure member.
>
> Thanks,
> Michal
>
> >  drivers/net/ethernet/google/gve/gve.h         |  44 +-
> >  drivers/net/ethernet/google/gve/gve_ethtool.c |  37 +-
> >  drivers/net/ethernet/google/gve/gve_main.c    | 376 +++++++++++++++++-
> >  drivers/net/ethernet/google/gve/gve_rx.c      |  74 +++-
> >  drivers/net/ethernet/google/gve/gve_tx.c      | 149 ++++++-
> >  5 files changed, 658 insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethern=
et/google/gve/gve.h
> > index f354a6448c25..8d5234d4ba67 100644
> > --- a/drivers/net/ethernet/google/gve/gve.h
> > +++ b/drivers/net/ethernet/google/gve/gve.h
> > @@ -47,6 +47,10 @@
> >
> >  #define GVE_RX_BUFFER_SIZE_DQO 2048
> >
> > +#define GVE_XDP_ACTIONS 5
> > +
> > +#define GVE_TX_MAX_HEADER_SIZE 182
> > +
> >  /* Each slot in the desc ring has a 1:1 mapping to a slot in the data =
ring */
> >  struct gve_rx_desc_queue {
> >       struct gve_rx_desc *desc_ring; /* the descriptor ring */
> > @@ -230,7 +234,9 @@ struct gve_rx_ring {
> >       u64 rx_frag_flip_cnt; /* free-running count of rx segments where =
page_flip was used */
> >       u64 rx_frag_copy_cnt; /* free-running count of rx segments copied=
 */
> >       u64 rx_frag_alloc_cnt; /* free-running count of rx page allocatio=
ns */
> > -
> > +     u64 xdp_tx_errors;
> > +     u64 xdp_redirect_errors;
> > +     u64 xdp_actions[GVE_XDP_ACTIONS];
> >       u32 q_num; /* queue index */
> >       u32 ntfy_id; /* notification block index */
> >       struct gve_queue_resources *q_resources; /* head and tail pointer=
 idx */
> > @@ -238,6 +244,9 @@ struct gve_rx_ring {
> >       struct u64_stats_sync statss; /* sync stats for 32bit archs */
> >
> >       struct gve_rx_ctx ctx; /* Info for packet currently being process=
ed in this ring. */
> > +
> > +     /* XDP stuff */
> > +     struct xdp_rxq_info xdp_rxq;
> >  };
> >
> >  /* A TX desc ring entry */
> > @@ -259,6 +268,9 @@ struct gve_tx_iovec {
> >   */
> >  struct gve_tx_buffer_state {
> >       struct sk_buff *skb; /* skb for this pkt */
> > +     struct {
> > +             u16 size; /* size of xmitted xdp pkt */
> > +     } xdp;
> >       union {
> >               struct gve_tx_iovec iov[GVE_TX_MAX_IOVEC]; /* segments of=
 this pkt */
> >               struct {
> > @@ -526,9 +538,11 @@ struct gve_priv {
> >       u16 rx_data_slot_cnt; /* rx buffer length */
> >       u64 max_registered_pages;
> >       u64 num_registered_pages; /* num pages registered with NIC */
> > +     struct bpf_prog *xdp_prog; /* XDP BPF program */
> >       u32 rx_copybreak; /* copy packets smaller than this */
> >       u16 default_num_queues; /* default num queues to set up */
> >
> > +     u16 num_xdp_queues;
> >       struct gve_queue_config tx_cfg;
> >       struct gve_queue_config rx_cfg;
> >       struct gve_qpl_config qpl_cfg; /* map used QPL ids */
> > @@ -785,7 +799,17 @@ static inline u32 gve_num_tx_qpls(struct gve_priv =
*priv)
> >       if (priv->queue_format !=3D GVE_GQI_QPL_FORMAT)
> >               return 0;
> >
> > -     return priv->tx_cfg.num_queues;
> > +     return priv->tx_cfg.num_queues + priv->num_xdp_queues;
> > +}
> > +
> > +/* Returns the number of XDP tx queue page lists
> > + */
> > +static inline u32 gve_num_xdp_qpls(struct gve_priv *priv)
> > +{
> > +     if (priv->queue_format !=3D GVE_GQI_QPL_FORMAT)
> > +             return 0;
> > +
> > +     return priv->num_xdp_queues;
> >  }
> >
> >  /* Returns the number of rx queue page lists
> > @@ -874,7 +898,17 @@ static inline bool gve_is_gqi(struct gve_priv *pri=
v)
> >
> >  static inline u32 gve_num_tx_queues(struct gve_priv *priv)
> >  {
> > -     return priv->tx_cfg.num_queues;
> > +     return priv->tx_cfg.num_queues + priv->num_xdp_queues;
> > +}
> > +
> > +static inline u32 gve_xdp_tx_queue_id(struct gve_priv *priv, u32 queue=
_id)
> > +{
> > +     return priv->tx_cfg.num_queues + queue_id;
> > +}
> > +
> > +static inline u32 gve_xdp_tx_start_queue_id(struct gve_priv *priv)
> > +{
> > +     return gve_xdp_tx_queue_id(priv, 0);
> >  }
> >
> >  /* buffers */
> > @@ -885,7 +919,11 @@ void gve_free_page(struct device *dev, struct page=
 *page, dma_addr_t dma,
> >                  enum dma_data_direction);
> >  /* tx handling */
> >  netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev);
> > +int gve_xdp_xmit_one(struct gve_priv *priv, struct gve_tx_ring *tx,
> > +                  void *data, int len);
> > +void gve_xdp_tx_flush(struct gve_priv *priv, u32 xdp_qid);
> >  bool gve_tx_poll(struct gve_notify_block *block, int budget);
> > +bool gve_xdp_poll(struct gve_notify_block *block, int budget);
> >  int gve_tx_alloc_rings(struct gve_priv *priv, int start_id, int num_ri=
ngs);
> >  void gve_tx_free_rings_gqi(struct gve_priv *priv, int start_id, int nu=
m_rings);
> >  u32 gve_tx_load_event_counter(struct gve_priv *priv,
> > diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/ne=
t/ethernet/google/gve/gve_ethtool.c
> > index 5b6e31812fae..067b393ccf9d 100644
> > --- a/drivers/net/ethernet/google/gve/gve_ethtool.c
> > +++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
> > @@ -34,6 +34,11 @@ static u32 gve_get_msglevel(struct net_device *netde=
v)
> >       return priv->msg_enable;
> >  }
> >
> > +/* For the following stats column string names, make sure the order
> > + * matches how it is filled in the code. For xdp_aborted, xdp_drop,
> > + * xdp_pass, xdp_tx, xdp_redirect, make sure it also matches the order
> > + * as declared in enum xdp_action inside file uapi/linux/bpf.h .
> > + */
> >  static const char gve_gstrings_main_stats[][ETH_GSTRING_LEN] =3D {
> >       "rx_packets", "tx_packets", "rx_bytes", "tx_bytes",
> >       "rx_dropped", "tx_dropped", "tx_timeouts",
> > @@ -49,6 +54,9 @@ static const char gve_gstrings_rx_stats[][ETH_GSTRING=
_LEN] =3D {
> >       "rx_dropped_pkt[%u]", "rx_copybreak_pkt[%u]", "rx_copied_pkt[%u]"=
,
> >       "rx_queue_drop_cnt[%u]", "rx_no_buffers_posted[%u]",
> >       "rx_drops_packet_over_mru[%u]", "rx_drops_invalid_checksum[%u]",
> > +     "rx_xdp_aborted[%u]", "rx_xdp_drop[%u]", "rx_xdp_pass[%u]",
> > +     "rx_xdp_tx[%u]", "rx_xdp_redirect[%u]",
> > +     "rx_xdp_tx_errors[%u]", "rx_xdp_redirect_errors[%u]",
> >  };
> >
> >  static const char gve_gstrings_tx_stats[][ETH_GSTRING_LEN] =3D {
> > @@ -289,14 +297,25 @@ gve_get_ethtool_stats(struct net_device *netdev,
> >                       if (skip_nic_stats) {
> >                               /* skip NIC rx stats */
> >                               i +=3D NIC_RX_STATS_REPORT_NUM;
> > -                             continue;
> > -                     }
> > -                     for (j =3D 0; j < NIC_RX_STATS_REPORT_NUM; j++) {
> > -                             u64 value =3D
> > -                             be64_to_cpu(report_stats[rx_qid_to_stats_=
idx[ring] + j].value);
> > +                     } else {
> > +                             stats_idx =3D rx_qid_to_stats_idx[ring];
> > +                             for (j =3D 0; j < NIC_RX_STATS_REPORT_NUM=
; j++) {
> > +                                     u64 value =3D
> > +                                             be64_to_cpu(report_stats[=
stats_idx + j].value);
> >
> > -                             data[i++] =3D value;
> > +                                     data[i++] =3D value;
> > +                             }
> >                       }
> > +                     /* XDP rx counters */
> > +                     do {
> > +                             start =3D u64_stats_fetch_begin(&priv->rx=
[ring].statss);
> > +                             for (j =3D 0; j < GVE_XDP_ACTIONS; j++)
> > +                                     data[i + j] =3D rx->xdp_actions[j=
];
> > +                             data[i + j++] =3D rx->xdp_tx_errors;
> > +                             data[i + j++] =3D rx->xdp_redirect_errors=
;
> > +                     } while (u64_stats_fetch_retry(&priv->rx[ring].st=
atss,
> > +                                                    start));
> > +                     i +=3D GVE_XDP_ACTIONS + 2; /* XDP rx counters */
> >               }
> >       } else {
> >               i +=3D priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
> > @@ -418,6 +437,12 @@ static int gve_set_channels(struct net_device *net=
dev,
> >       if (!new_rx || !new_tx)
> >               return -EINVAL;
> >
> > +     if (priv->num_xdp_queues &&
> > +         (new_tx !=3D new_rx || (2 * new_tx > priv->tx_cfg.max_queues)=
)) {
> > +             dev_err(&priv->pdev->dev, "XDP load failed: The number of=
 configured RX queues should be equal to the number of configured TX queues=
 and the number of configured RX/TX queues should be less than or equal to =
half the maximum number of RX/TX queues");
>
> Please explain why the number of RX and TX queues cannot be asymmetric
> while the XDP program is loaded?
> Regarding the second condition: shouldn't it look like:
>         "2 * new_tx > priv->rx_cfg.max_queues" ?
>
> Please take a look at my other comments regarding XDP queues number.
>

For this first iteration of XDP support, we chose to enforce number of
configured RX queues to be equal to the number of configured TX queues
to simplify how the dedicated XDP transmit queues are assigned for
XDP_TX traffic as well as for AF_XDP ZC TX traffic.  We only load XDP
when the number of RX queues is equal to the number of TX queues.
In effect, the number of XDP TX queues =3D number of configured TX queues =
=3D
number of configured RX queues.

The check 2*new_tx > priv->tx_cfg.max_queues ensures that we
are not creating more tx queues than the maximum allowed TX
queues.

> > +             return -EINVAL;
> > +     }
> > +
> >       if (!netif_carrier_ok(netdev)) {
> >               priv->tx_cfg.num_queues =3D new_tx;
> >               priv->rx_cfg.num_queues =3D new_rx;
> > diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/e=
thernet/google/gve/gve_main.c
> > index 160ca77c2751..7d3f15cf79ed 100644
> > --- a/drivers/net/ethernet/google/gve/gve_main.c
> > +++ b/drivers/net/ethernet/google/gve/gve_main.c
> > @@ -4,8 +4,10 @@
> >   * Copyright (C) 2015-2021 Google, Inc.
> >   */
> >
> > +#include <linux/bpf.h>
> >  #include <linux/cpumask.h>
> >  #include <linux/etherdevice.h>
> > +#include <linux/filter.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/module.h>
> >  #include <linux/pci.h>
> > @@ -247,8 +249,13 @@ static int gve_napi_poll(struct napi_struct *napi,=
 int budget)
> >       block =3D container_of(napi, struct gve_notify_block, napi);
> >       priv =3D block->priv;
> >
> > -     if (block->tx)
> > -             reschedule |=3D gve_tx_poll(block, budget);
> > +     if (block->tx) {
> > +             if (block->tx->q_num < priv->tx_cfg.num_queues)
> > +                     reschedule |=3D gve_tx_poll(block, budget);
> > +             else
> > +                     reschedule |=3D gve_xdp_poll(block, budget);
> > +     }
> > +
> >       if (block->rx) {
> >               work_done =3D gve_rx_poll(block, budget);
> >               reschedule |=3D work_done =3D=3D budget;
> > @@ -582,6 +589,28 @@ static void gve_remove_napi(struct gve_priv *priv,=
 int ntfy_idx)
> >       netif_napi_del(&block->napi);
> >  }
> >
> > +static int gve_register_xdp_qpls(struct gve_priv *priv)
> > +{
> > +     int start_id;
> > +     int err;
> > +     int i;
> > +
> > +     start_id =3D gve_tx_qpl_id(priv, gve_xdp_tx_start_queue_id(priv))=
;
> > +     for (i =3D start_id; i < start_id + gve_num_xdp_qpls(priv); i++) =
{
> > +             err =3D gve_adminq_register_page_list(priv, &priv->qpls[i=
]);
> > +             if (err) {
> > +                     netif_err(priv, drv, priv->dev,
> > +                               "failed to register queue page list %d\=
n",
> > +                               priv->qpls[i].id);
> > +                     /* This failure will trigger a reset - no need to=
 clean
> > +                      * up
> > +                      */
> > +                     return err;
> > +             }
> > +     }
> > +     return 0;
> > +}
> > +
> >  static int gve_register_qpls(struct gve_priv *priv)
> >  {
> >       int start_id;
> > @@ -618,6 +647,26 @@ static int gve_register_qpls(struct gve_priv *priv=
)
> >       return 0;
> >  }
> >
> > +static int gve_unregister_xdp_qpls(struct gve_priv *priv)
> > +{
> > +     int start_id;
> > +     int err;
> > +     int i;
> > +
> > +     start_id =3D gve_tx_qpl_id(priv, gve_xdp_tx_start_queue_id(priv))=
;
> > +     for (i =3D start_id; i < start_id + gve_num_xdp_qpls(priv); i++) =
{
> > +             err =3D gve_adminq_unregister_page_list(priv, priv->qpls[=
i].id);
> > +             /* This failure will trigger a reset - no need to clean u=
p */
> > +             if (err) {
> > +                     netif_err(priv, drv, priv->dev,
> > +                               "Failed to unregister queue page list %=
d\n",
> > +                               priv->qpls[i].id);
> > +                     return err;
> > +             }
> > +     }
> > +     return 0;
> > +}
> > +
> >  static int gve_unregister_qpls(struct gve_priv *priv)
> >  {
> >       int start_id;
> > @@ -650,6 +699,27 @@ static int gve_unregister_qpls(struct gve_priv *pr=
iv)
> >       return 0;
> >  }
> >
> > +static int gve_create_xdp_rings(struct gve_priv *priv)
> > +{
> > +     int err;
> > +
> > +     err =3D gve_adminq_create_tx_queues(priv,
> > +                                       gve_xdp_tx_start_queue_id(priv)=
,
> > +                                       priv->num_xdp_queues);
> > +     if (err) {
> > +             netif_err(priv, drv, priv->dev, "failed to create %d XDP =
tx queues\n",
> > +                       priv->num_xdp_queues);
> > +             /* This failure will trigger a reset - no need to clean
> > +              * up
> > +              */
> > +             return err;
> > +     }
> > +     netif_dbg(priv, drv, priv->dev, "created %d XDP tx queues\n",
> > +               priv->num_xdp_queues);
> > +
> > +     return 0;
> > +}
> > +
> >  static int gve_create_rings(struct gve_priv *priv)
> >  {
> >       int num_tx_queues =3D gve_num_tx_queues(priv);
> > @@ -699,6 +769,23 @@ static int gve_create_rings(struct gve_priv *priv)
> >       return 0;
> >  }
> >
> > +static void add_napi_init_xdp_sync_stats(struct gve_priv *priv,
> > +                                      int (*napi_poll)(struct napi_str=
uct *napi,
> > +                                                       int budget))
> > +{
> > +     int start_id =3D gve_xdp_tx_start_queue_id(priv);
> > +     int i;
> > +
> > +     /* Add xdp tx napi & init sync stats*/
> > +     for (i =3D start_id; i < start_id + priv->num_xdp_queues; i++) {
> > +             int ntfy_idx =3D gve_tx_idx_to_ntfy(priv, i);
> > +
> > +             u64_stats_init(&priv->tx[i].statss);
> > +             priv->tx[i].ntfy_id =3D ntfy_idx;
> > +             gve_add_napi(priv, ntfy_idx, napi_poll);
> > +     }
> > +}
> > +
> >  static void add_napi_init_sync_stats(struct gve_priv *priv,
> >                                    int (*napi_poll)(struct napi_struct =
*napi,
> >                                                     int budget))
> > @@ -732,6 +819,23 @@ static void gve_tx_free_rings(struct gve_priv *pri=
v, int start_id, int num_rings
> >       }
> >  }
> >
> > +static int gve_alloc_xdp_rings(struct gve_priv *priv)
> > +{
> > +     int start_id;
> > +     int err =3D 0;
> > +
> > +     if (!priv->num_xdp_queues)
> > +             return 0;
> > +
> > +     start_id =3D gve_xdp_tx_start_queue_id(priv);
> > +     err =3D gve_tx_alloc_rings(priv, start_id, priv->num_xdp_queues);
> > +     if (err)
> > +             return err;
> > +     add_napi_init_xdp_sync_stats(priv, gve_napi_poll);
> > +
> > +     return 0;
> > +}
> > +
> >  static int gve_alloc_rings(struct gve_priv *priv)
> >  {
> >       int err;
> > @@ -782,6 +886,26 @@ static int gve_alloc_rings(struct gve_priv *priv)
> >       return err;
> >  }
> >
> > +static int gve_destroy_xdp_rings(struct gve_priv *priv)
> > +{
> > +     int start_id;
> > +     int err;
> > +
> > +     start_id =3D gve_xdp_tx_start_queue_id(priv);
> > +     err =3D gve_adminq_destroy_tx_queues(priv,
> > +                                        start_id,
> > +                                        priv->num_xdp_queues);
> > +     if (err) {
> > +             netif_err(priv, drv, priv->dev,
> > +                       "failed to destroy XDP queues\n");
> > +             /* This failure will trigger a reset - no need to clean u=
p */
> > +             return err;
> > +     }
> > +     netif_dbg(priv, drv, priv->dev, "destroyed XDP queues\n");
> > +
> > +     return 0;
> > +}
> > +
> >  static int gve_destroy_rings(struct gve_priv *priv)
> >  {
> >       int num_tx_queues =3D gve_num_tx_queues(priv);
> > @@ -814,6 +938,21 @@ static void gve_rx_free_rings(struct gve_priv *pri=
v)
> >               gve_rx_free_rings_dqo(priv);
> >  }
> >
> > +static void gve_free_xdp_rings(struct gve_priv *priv)
> > +{
> > +     int ntfy_idx, start_id;
> > +     int i;
> > +
> > +     start_id =3D gve_xdp_tx_start_queue_id(priv);
> > +     if (priv->tx) {
> > +             for (i =3D start_id; i <  start_id + priv->num_xdp_queues=
; i++) {
> > +                     ntfy_idx =3D gve_tx_idx_to_ntfy(priv, i);
> > +                     gve_remove_napi(priv, ntfy_idx);
> > +             }
> > +             gve_tx_free_rings(priv, start_id, priv->num_xdp_queues);
> > +     }
> > +}
> > +
> >  static void gve_free_rings(struct gve_priv *priv)
> >  {
> >       int num_tx_queues =3D gve_num_tx_queues(priv);
> > @@ -929,6 +1068,28 @@ static void gve_free_queue_page_list(struct gve_p=
riv *priv, u32 id)
> >       priv->num_registered_pages -=3D qpl->num_entries;
> >  }
> >
> > +static int gve_alloc_xdp_qpls(struct gve_priv *priv)
> > +{
> > +     int start_id;
> > +     int i, j;
> > +     int err;
> > +
> > +     start_id =3D gve_tx_qpl_id(priv, gve_xdp_tx_start_queue_id(priv))=
;
> > +     for (i =3D start_id; i < start_id + gve_num_xdp_qpls(priv); i++) =
{
> > +             err =3D gve_alloc_queue_page_list(priv, i,
> > +                                             priv->tx_pages_per_qpl);
> > +             if (err)
> > +                     goto free_qpls;
> > +     }
> > +
> > +     return 0;
> > +
> > +free_qpls:
> > +     for (j =3D start_id; j <=3D i; j++)
> > +             gve_free_queue_page_list(priv, j);
> > +     return err;
> > +}
> > +
> >  static int gve_alloc_qpls(struct gve_priv *priv)
> >  {
> >       int max_queues =3D priv->tx_cfg.max_queues + priv->rx_cfg.max_que=
ues;
> > @@ -978,6 +1139,16 @@ static int gve_alloc_qpls(struct gve_priv *priv)
> >       return err;
> >  }
> >
> > +static void gve_free_xdp_qpls(struct gve_priv *priv)
> > +{
> > +     int start_id;
> > +     int i;
> > +
> > +     start_id =3D gve_tx_qpl_id(priv, gve_xdp_tx_start_queue_id(priv))=
;
> > +     for (i =3D start_id; i < start_id + gve_num_xdp_qpls(priv); i++)
> > +             gve_free_queue_page_list(priv, i);
> > +}
> > +
> >  static void gve_free_qpls(struct gve_priv *priv)
> >  {
> >       int max_queues =3D priv->tx_cfg.max_queues + priv->rx_cfg.max_que=
ues;
> > @@ -1011,11 +1182,64 @@ static int gve_reset_recovery(struct gve_priv *=
priv, bool was_up);
> >  static void gve_turndown(struct gve_priv *priv);
> >  static void gve_turnup(struct gve_priv *priv);
> >
> > +static int gve_reg_xdp_info(struct gve_priv *priv, struct net_device *=
dev)
> > +{
> > +     struct napi_struct *napi;
> > +     struct gve_rx_ring *rx;
> > +     int err =3D 0;
> > +     int i, j;
> > +
> > +     if (!priv->num_xdp_queues)
> > +             return 0;
> > +
> > +     for (i =3D 0; i < priv->rx_cfg.num_queues; i++) {
> > +             rx =3D &priv->rx[i];
> > +             napi =3D &priv->ntfy_blocks[rx->ntfy_id].napi;
> > +
> > +             err =3D xdp_rxq_info_reg(&rx->xdp_rxq, dev, i,
> > +                                    napi->napi_id);
> > +             if (err)
> > +                     goto err;
> > +             err =3D xdp_rxq_info_reg_mem_model(&rx->xdp_rxq,
> > +                                              MEM_TYPE_PAGE_SHARED, NU=
LL);
> > +             if (err)
> > +                     goto err;
> > +     }
> > +     return 0;
> > +
> > +err:
> > +     for (j =3D i; j >=3D 0; j--) {
> > +             rx =3D &priv->rx[j];
> > +             if (xdp_rxq_info_is_reg(&rx->xdp_rxq))
> > +                     xdp_rxq_info_unreg(&rx->xdp_rxq);
> > +     }
> > +     return err;
> > +}
> > +
> > +static void gve_unreg_xdp_info(struct gve_priv *priv)
> > +{
> > +     int i;
> > +
> > +     if (!priv->num_xdp_queues)
> > +             return;
> > +
> > +     for (i =3D 0; i < priv->rx_cfg.num_queues; i++) {
> > +             struct gve_rx_ring *rx =3D &priv->rx[i];
> > +
> > +             xdp_rxq_info_unreg(&rx->xdp_rxq);
> > +     }
> > +}
> > +
> >  static int gve_open(struct net_device *dev)
> >  {
> >       struct gve_priv *priv =3D netdev_priv(dev);
> >       int err;
> >
> > +     if (priv->xdp_prog)
> > +             priv->num_xdp_queues =3D priv->tx_cfg.num_queues;
>
> Why the number of XDP queues is initialized to TX queues number?
> Shouldn't it be rather RX queues number?
>
> For example, if you have:
>  - asymmetric number of RX and TX queues,
>  - tx_cfg.num_queues < rx_cfg.num_queues.
>
> I believe in such a scenario you won't be able to handle XDP_TX action
> for all RX queues.
> Please take a look at your implementation of "XDP_TX" case in "gve_xdp_do=
ne()".
>
> Is it any mistake or an intentional design?
>

As mentioned above, we enforce num of rx queues =3D=3D num of tx queues
=3D=3D num of XDP tx queues.

> > +     else
> > +             priv->num_xdp_queues =3D 0;
> > +
> >       err =3D gve_alloc_qpls(priv);
> >       if (err)
> >               return err;
> > @@ -1031,6 +1255,10 @@ static int gve_open(struct net_device *dev)
> >       if (err)
> >               goto free_rings;
> >
> > +     err =3D gve_reg_xdp_info(priv, dev);
> > +     if (err)
> > +             goto free_rings;
> > +
> >       err =3D gve_register_qpls(priv);
> >       if (err)
> >               goto reset;
> > @@ -1095,6 +1323,7 @@ static int gve_close(struct net_device *dev)
> >       }
> >       del_timer_sync(&priv->stats_report_timer);
> >
> > +     gve_unreg_xdp_info(priv);
> >       gve_free_rings(priv);
> >       gve_free_qpls(priv);
> >       priv->interface_down_cnt++;
> > @@ -1111,6 +1340,148 @@ static int gve_close(struct net_device *dev)
> >       return gve_reset_recovery(priv, false);
> >  }
> >
> > +static int gve_remove_xdp_queues(struct gve_priv *priv)
> > +{
> > +     int err;
> > +
> > +     err =3D gve_destroy_xdp_rings(priv);
> > +     if (err)
> > +             return err;
> > +
> > +     err =3D gve_unregister_xdp_qpls(priv);
> > +     if (err)
> > +             return err;
> > +
> > +     gve_unreg_xdp_info(priv);
> > +     gve_free_xdp_rings(priv);
> > +     gve_free_xdp_qpls(priv);
> > +     priv->num_xdp_queues =3D 0;
> > +     return 0;
> > +}
> > +
> > +static int gve_add_xdp_queues(struct gve_priv *priv)
> > +{
> > +     int err;
> > +
> > +     priv->num_xdp_queues =3D priv->tx_cfg.num_queues;
>
> The same question here: shouldn't it be equal to
> "priv->rx_cfg.num_queues"?
>

We enforce priv->tx_cfg.num_queues =3D=3D priv->rx_cfg.num_queues
when XDP is enabled. We will make this priv->rx_cfg.num_queues
just to be clearer.

> > +
> > +     err =3D gve_alloc_xdp_qpls(priv);
> > +     if (err)
> > +             goto err;
> > +
> > +     err =3D gve_alloc_xdp_rings(priv);
> > +     if (err)
> > +             goto free_xdp_qpls;
> > +
> > +     err =3D gve_reg_xdp_info(priv, priv->dev);
> > +     if (err)
> > +             goto free_xdp_rings;
> > +
> > +     err =3D gve_register_xdp_qpls(priv);
> > +     if (err)
> > +             goto free_xdp_rings;
> > +
> > +     err =3D gve_create_xdp_rings(priv);
> > +     if (err)
> > +             goto free_xdp_rings;
> > +
> > +     return 0;
> > +
> > +free_xdp_rings:
> > +     gve_free_xdp_rings(priv);
> > +free_xdp_qpls:
> > +     gve_free_xdp_qpls(priv);
> > +err:
> > +     priv->num_xdp_queues =3D 0;
> > +     return err;
> > +}
> > +
> > +static int gve_set_xdp(struct gve_priv *priv, struct bpf_prog *prog,
> > +                    struct netlink_ext_ack *extack)
> > +{
> > +     struct bpf_prog *old_prog;
> > +     int err =3D 0;
> > +
> > +     old_prog =3D READ_ONCE(priv->xdp_prog);
> > +     if (!netif_carrier_ok(priv->dev)) {
> > +             WRITE_ONCE(priv->xdp_prog, prog);
> > +             if (old_prog)
> > +                     bpf_prog_put(old_prog);
> > +             return 0;
> > +     }
> > +
> > +     gve_turndown(priv);
> > +     if (!old_prog && prog) {
> > +             // Allocate XDP TX queues if an XDP program is
> > +             // being installed
> > +             err =3D gve_add_xdp_queues(priv);
> > +             if (err)
> > +                     goto out;
> > +     } else if (old_prog && !prog) {
> > +             // Remove XDP TX queues if an XDP program is
> > +             // being uninstalled
> > +             err =3D gve_remove_xdp_queues(priv);
> > +             if (err)
> > +                     goto out;
> > +     }
> > +     WRITE_ONCE(priv->xdp_prog, prog);
> > +     if (old_prog)
> > +             bpf_prog_put(old_prog);
> > +
> > +out:
> > +     gve_turnup(priv);
> > +     queue_work(priv->gve_wq, &priv->service_task);
>
> As far as I understand, you are starting some stuff asynchronously
> (service_task), but you never wait for the result of that stuff.
> So, if err =3D=3D 0, but the "service_task" fails, you will still return
> a success to the kernel.
> Is it OK? Is it possible to return an inconsistent result to the kernel?
>
service_task was being scheduled to turn on the carrier based
on the link status. We will change this in V4 version of this patch
to turn on the carrier based on the link status synchronously rather
than asynchronously.
> > +     return err;
> > +}
> > +
> > +static int verify_xdp_configuration(struct net_device *dev)
> > +{
> > +     struct gve_priv *priv =3D netdev_priv(dev);
> > +
> > +     if (dev->features & NETIF_F_LRO) {
> > +             netdev_warn(dev, "XDP is not supported when LRO is on.\n"=
);
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> > +     if (priv->queue_format !=3D GVE_GQI_QPL_FORMAT) {
> > +             netdev_warn(dev, "XDP is not supported in mode %d.\n",
> > +                         priv->queue_format);
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> > +     if (dev->mtu > (PAGE_SIZE / 2) - sizeof(struct ethhdr) - GVE_RX_P=
AD) {
> > +             netdev_warn(dev, "XDP is not supported for mtu %d.\n",
> > +                         dev->mtu);
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> > +     if (priv->rx_cfg.num_queues !=3D priv->tx_cfg.num_queues ||
> > +         (2 * priv->tx_cfg.num_queues > priv->tx_cfg.max_queues)) {
> > +             netdev_warn(dev, "XDP load failed: The number of configur=
ed RX queues %d should be equal to the number of configured TX queues %d an=
d the number of configured RX/TX queues should be less than or equal to hal=
f the maximum number of RX/TX queues %d",
> > +                         priv->rx_cfg.num_queues,
> > +                         priv->tx_cfg.num_queues,
> > +                         priv->tx_cfg.max_queues);
> > +             return -EINVAL;
> > +     }
> > +     return 0;
> > +}
> > +
> > +static int gve_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> > +{
> > +     struct gve_priv *priv =3D netdev_priv(dev);
> > +     int err;
> > +
> > +     err =3D verify_xdp_configuration(dev);
> > +     if (err)
> > +             return err;
> > +     switch (xdp->command) {
> > +     case XDP_SETUP_PROG:
> > +             return gve_set_xdp(priv, xdp->prog, xdp->extack);
> > +     default:
> > +             return -EINVAL;
> > +     }
> > +}
> > +
> >  int gve_adjust_queues(struct gve_priv *priv,
> >                     struct gve_queue_config new_rx_config,
> >                     struct gve_queue_config new_tx_config)
> > @@ -1305,6 +1676,7 @@ static const struct net_device_ops gve_netdev_ops=
 =3D {
> >       .ndo_get_stats64        =3D       gve_get_stats,
> >       .ndo_tx_timeout         =3D       gve_tx_timeout,
> >       .ndo_set_features       =3D       gve_set_features,
> > +     .ndo_bpf                =3D       gve_xdp,
> >  };
> >
> >  static void gve_handle_status(struct gve_priv *priv, u32 status)
> > diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/eth=
ernet/google/gve/gve_rx.c
> > index 051a15e4f1af..3241f6ea29be 100644
> > --- a/drivers/net/ethernet/google/gve/gve_rx.c
> > +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> > @@ -8,6 +8,8 @@
> >  #include "gve_adminq.h"
> >  #include "gve_utils.h"
> >  #include <linux/etherdevice.h>
> > +#include <linux/filter.h>
> > +#include <net/xdp.h>
> >
> >  static void gve_rx_free_buffer(struct device *dev,
> >                              struct gve_rx_slot_page_info *page_info,
> > @@ -591,6 +593,43 @@ static struct sk_buff *gve_rx_skb(struct gve_priv =
*priv, struct gve_rx_ring *rx,
> >       return skb;
> >  }
> >
> > +static void gve_xdp_done(struct gve_priv *priv, struct gve_rx_ring *rx=
,
> > +                      struct xdp_buff *xdp, struct bpf_prog *xprog,
> > +                      int xdp_act)
> > +{
> > +     struct gve_tx_ring *tx;
> > +     int tx_qid;
> > +     int err;
> > +
> > +     switch (xdp_act) {
> > +     case XDP_ABORTED:
> > +     case XDP_DROP:
> > +     default:
> > +             break;
> > +     case XDP_TX:
> > +             tx_qid =3D gve_xdp_tx_queue_id(priv, rx->q_num);
> > +             tx =3D &priv->tx[tx_qid];
>
> As I have already mentioned: if num_rx_queues > num_tx_queues, you can
> select uninitialized xdp queue (because num_tx_queues =3D=3D
> num_xdp_queues).
>
> Please check if your number of XDP queues should be equal to the number
> of RX queues.
>
> > +             err =3D gve_xdp_xmit_one(priv, tx, xdp->data,
> > +                                    xdp->data_end - xdp->data);
> > +
> > +             if (unlikely(err)) {
> > +                     u64_stats_update_begin(&rx->statss);
> > +                     rx->xdp_tx_errors++;
> > +                     u64_stats_update_end(&rx->statss);
> > +             }
> > +             break;
> > +     case XDP_REDIRECT:
> > +             u64_stats_update_begin(&rx->statss);
> > +             rx->xdp_redirect_errors++;
> > +             u64_stats_update_end(&rx->statss);
> > +             break;
> > +     }
> > +     u64_stats_update_begin(&rx->statss);
> > +     if ((u32)xdp_act < GVE_XDP_ACTIONS)
> > +             rx->xdp_actions[xdp_act]++;
> > +     u64_stats_update_end(&rx->statss);
> > +}
> > +
> >  #define GVE_PKTCONT_BIT_IS_SET(x) (GVE_RXF_PKT_CONT & (x))
> >  static void gve_rx(struct gve_rx_ring *rx, netdev_features_t feat,
> >                  struct gve_rx_desc *desc, u32 idx,
> > @@ -603,9 +642,12 @@ static void gve_rx(struct gve_rx_ring *rx, netdev_=
features_t feat,
> >       union gve_rx_data_slot *data_slot;
> >       struct gve_priv *priv =3D rx->gve;
> >       struct sk_buff *skb =3D NULL;
> > +     struct bpf_prog *xprog;
> > +     struct xdp_buff xdp;
> >       dma_addr_t page_bus;
> >       void *va;
> >
> > +     u16 len =3D frag_size;
> >       struct napi_struct *napi =3D &priv->ntfy_blocks[rx->ntfy_id].napi=
;
> >       bool is_first_frag =3D ctx->frag_cnt =3D=3D 0;
> >
> > @@ -645,9 +687,35 @@ static void gve_rx(struct gve_rx_ring *rx, netdev_=
features_t feat,
> >       dma_sync_single_for_cpu(&priv->pdev->dev, page_bus,
> >                               PAGE_SIZE, DMA_FROM_DEVICE);
> >       page_info->pad =3D is_first_frag ? GVE_RX_PAD : 0;
> > +     len -=3D page_info->pad;
> >       frag_size -=3D page_info->pad;
> >
> > -     skb =3D gve_rx_skb(priv, rx, page_info, napi, frag_size,
> > +     xprog =3D READ_ONCE(priv->xdp_prog);
> > +     if (xprog && is_only_frag) {
> > +             void *old_data;
> > +             int xdp_act;
> > +
> > +             xdp_init_buff(&xdp, rx->packet_buffer_size, &rx->xdp_rxq)=
;
> > +             xdp_prepare_buff(&xdp, page_info->page_address +
> > +                              page_info->page_offset, GVE_RX_PAD,
> > +                              len, false);
> > +             old_data =3D xdp.data;
> > +             xdp_act =3D bpf_prog_run_xdp(xprog, &xdp);
> > +             if (xdp_act !=3D XDP_PASS) {
> > +                     gve_xdp_done(priv, rx, &xdp, xprog, xdp_act);
> > +                     ctx->total_size +=3D frag_size;
> > +                     goto finish_ok_pkt;
> > +             }
> > +
> > +             page_info->pad +=3D xdp.data - old_data;
> > +             len =3D xdp.data_end - xdp.data;
> > +
> > +             u64_stats_update_begin(&rx->statss);
> > +             rx->xdp_actions[XDP_PASS]++;
> > +             u64_stats_update_end(&rx->statss);
> > +     }
> > +
> > +     skb =3D gve_rx_skb(priv, rx, page_info, napi, len,
> >                        data_slot, is_only_frag);
> >       if (!skb) {
> >               u64_stats_update_begin(&rx->statss);
> > @@ -773,6 +841,7 @@ static bool gve_rx_refill_buffers(struct gve_priv *=
priv, struct gve_rx_ring *rx)
> >  static int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
> >                            netdev_features_t feat)
> >  {
> > +     u64 xdp_txs =3D rx->xdp_actions[XDP_TX];
> >       struct gve_rx_ctx *ctx =3D &rx->ctx;
> >       struct gve_priv *priv =3D rx->gve;
> >       struct gve_rx_cnts cnts =3D {0};
> > @@ -820,6 +889,9 @@ static int gve_clean_rx_done(struct gve_rx_ring *rx=
, int budget,
> >               u64_stats_update_end(&rx->statss);
> >       }
> >
> > +     if (xdp_txs !=3D rx->xdp_actions[XDP_TX])
> > +             gve_xdp_tx_flush(priv, rx->q_num);
> > +
> >       /* restock ring slots */
> >       if (!rx->data.raw_addressing) {
> >               /* In QPL mode buffs are refilled as the desc are process=
ed */
> > diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/eth=
ernet/google/gve/gve_tx.c
> > index e24e73e74e33..d37515e6c10c 100644
> > --- a/drivers/net/ethernet/google/gve/gve_tx.c
> > +++ b/drivers/net/ethernet/google/gve/gve_tx.c
> > @@ -19,6 +19,14 @@ static inline void gve_tx_put_doorbell(struct gve_pr=
iv *priv,
> >       iowrite32be(val, &priv->db_bar2[be32_to_cpu(q_resources->db_index=
)]);
> >  }
> >
> > +void gve_xdp_tx_flush(struct gve_priv *priv, u32 xdp_qid)
> > +{
> > +     u32 tx_qid =3D gve_xdp_tx_queue_id(priv, xdp_qid);
> > +     struct gve_tx_ring *tx =3D &priv->tx[tx_qid];
> > +
> > +     gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
> > +}
> > +
> >  /* gvnic can only transmit from a Registered Segment.
> >   * We copy skb payloads into the registered segment before writing Tx
> >   * descriptors and ringing the Tx doorbell.
> > @@ -132,6 +140,50 @@ static void gve_tx_free_fifo(struct gve_tx_fifo *f=
ifo, size_t bytes)
> >       atomic_add(bytes, &fifo->available);
> >  }
> >
> > +static size_t gve_tx_clear_buffer_state(struct gve_tx_buffer_state *in=
fo)
> > +{
> > +     size_t space_freed =3D 0;
> > +     int i;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(info->iov); i++) {
> > +             space_freed +=3D info->iov[i].iov_len + info->iov[i].iov_=
padding;
> > +             info->iov[i].iov_len =3D 0;
> > +             info->iov[i].iov_padding =3D 0;
> > +     }
> > +     return space_freed;
> > +}
> > +
> > +static int gve_clean_xdp_done(struct gve_priv *priv, struct gve_tx_rin=
g *tx,
> > +                           u32 to_do)
> > +{
> > +     struct gve_tx_buffer_state *info;
> > +     u32 clean_end =3D tx->done + to_do;
> > +     u64 pkts =3D 0, bytes =3D 0;
> > +     size_t space_freed =3D 0;
> > +     u32 idx;
> > +
> > +     for (; tx->done < clean_end; tx->done++) {
> > +             idx =3D tx->done & tx->mask;
> > +             info =3D &tx->info[idx];
> > +
> > +             if (unlikely(!info->xdp.size))
> > +                     continue;
> > +
> > +             bytes +=3D info->xdp.size;
> > +             pkts++;
> > +
> > +             info->xdp.size =3D 0;
> > +             space_freed +=3D gve_tx_clear_buffer_state(info);
> > +     }
> > +
> > +     gve_tx_free_fifo(&tx->tx_fifo, space_freed);
> > +     u64_stats_update_begin(&tx->statss);
> > +     tx->bytes_done +=3D bytes;
> > +     tx->pkt_done +=3D pkts;
> > +     u64_stats_update_end(&tx->statss);
> > +     return pkts;
> > +}
> > +
> >  static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring=
 *tx,
> >                            u32 to_do, bool try_to_wake);
> >
> > @@ -144,8 +196,12 @@ static void gve_tx_free_ring(struct gve_priv *priv=
, int idx)
> >
> >       gve_tx_remove_from_block(priv, idx);
> >       slots =3D tx->mask + 1;
> > -     gve_clean_tx_done(priv, tx, priv->tx_desc_cnt, false);
> > -     netdev_tx_reset_queue(tx->netdev_txq);
> > +     if (tx->q_num < priv->tx_cfg.num_queues) {
> > +             gve_clean_tx_done(priv, tx, priv->tx_desc_cnt, false);
> > +             netdev_tx_reset_queue(tx->netdev_txq);
> > +     } else {
> > +             gve_clean_xdp_done(priv, tx, priv->tx_desc_cnt);
> > +     }
> >
> >       dma_free_coherent(hdev, sizeof(*tx->q_resources),
> >                         tx->q_resources, tx->q_resources_bus);
> > @@ -213,7 +269,8 @@ static int gve_tx_alloc_ring(struct gve_priv *priv,=
 int idx)
> >
> >       netif_dbg(priv, drv, priv->dev, "tx[%d]->bus=3D%lx\n", idx,
> >                 (unsigned long)tx->bus);
> > -     tx->netdev_txq =3D netdev_get_tx_queue(priv->dev, idx);
> > +     if (idx < priv->tx_cfg.num_queues)
> > +             tx->netdev_txq =3D netdev_get_tx_queue(priv->dev, idx);
> >       gve_tx_add_to_block(priv, idx);
> >
> >       return 0;
> > @@ -657,6 +714,65 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net=
_device *dev)
> >       return NETDEV_TX_OK;
> >  }
> >
> > +static int gve_tx_fill_xdp(struct gve_priv *priv, struct gve_tx_ring *=
tx,
> > +                        void *data, int len)
> > +{
> > +     int pad, nfrags, ndescs, iovi, offset;
> > +     struct gve_tx_buffer_state *info;
> > +     u32 reqi =3D tx->req;
> > +
> > +     pad =3D gve_tx_fifo_pad_alloc_one_frag(&tx->tx_fifo, len);
> > +     if (pad >=3D GVE_TX_MAX_HEADER_SIZE)
> > +             pad =3D 0;
> > +     info =3D &tx->info[reqi & tx->mask];
> > +     info->xdp.size =3D len;
> > +
> > +     nfrags =3D gve_tx_alloc_fifo(&tx->tx_fifo, pad + len,
> > +                                &info->iov[0]);
> > +     iovi =3D pad > 0;
> > +     ndescs =3D nfrags - iovi;
> > +     offset =3D 0;
> > +
> > +     while (iovi < nfrags) {
> > +             if (!offset)
> > +                     gve_tx_fill_pkt_desc(&tx->desc[reqi & tx->mask], =
0,
> > +                                          CHECKSUM_NONE, false, 0, nde=
scs,
> > +                                          info->iov[iovi].iov_len,
> > +                                          info->iov[iovi].iov_offset, =
len);
> > +             else
> > +                     gve_tx_fill_seg_desc(&tx->desc[reqi & tx->mask],
> > +                                          0, 0, false, false,
> > +                                          info->iov[iovi].iov_len,
> > +                                          info->iov[iovi].iov_offset);
> > +
> > +             memcpy(tx->tx_fifo.base + info->iov[iovi].iov_offset,
> > +                    data + offset, info->iov[iovi].iov_len);
> > +             gve_dma_sync_for_device(&priv->pdev->dev,
> > +                                     tx->tx_fifo.qpl->page_buses,
> > +                                     info->iov[iovi].iov_offset,
> > +                                     info->iov[iovi].iov_len);
> > +             offset +=3D info->iov[iovi].iov_len;
> > +             iovi++;
> > +             reqi++;
> > +     }
>
> Could you please explain the logic above a little bit more?
> How is it possible to xmit more than one frag per one XDP packet?
> I believe in your implementation the XDP supports only one descriptor
> per packet. So, I think this "while" loop will always have only one
> iteration?
>
In GQI-QPL mode, the XDP packets are first copied into TX-FIFO buffer (whic=
h
is preregistered with vNIC). The packets are then DMAed by the vNIC from
TX FIFO buffer. When the entire packet does not fit at the end of TX-FIFO,
we split the packet into two chunks - one at tail of TX FIFO and one at
the head of TX-FIFO and use two descriptors to transmit the packet to vNIC.


> > +
> > +     return ndescs;
> > +}
> > +
> > +int gve_xdp_xmit_one(struct gve_priv *priv, struct gve_tx_ring *tx,
> > +                  void *data, int len)
> > +{
> > +     int nsegs;
> > +
> > +     if (!gve_can_tx(tx, len + GVE_TX_MAX_HEADER_SIZE - 1))
> > +             return -EBUSY;
> > +
> > +     nsegs =3D gve_tx_fill_xdp(priv, tx, data, len);
> > +     tx->req +=3D nsegs;
> > +
> > +     return 0;
> > +}
> > +
> >  #define GVE_TX_START_THRESH  PAGE_SIZE
> >
> >  static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring=
 *tx,
> > @@ -666,7 +782,7 @@ static int gve_clean_tx_done(struct gve_priv *priv,=
 struct gve_tx_ring *tx,
> >       u64 pkts =3D 0, bytes =3D 0;
> >       size_t space_freed =3D 0;
> >       struct sk_buff *skb;
> > -     int i, j;
> > +     int j;
> >       u32 idx;
>
> RCT
>
> >
> >       for (j =3D 0; j < to_do; j++) {
> > @@ -689,12 +805,7 @@ static int gve_clean_tx_done(struct gve_priv *priv=
, struct gve_tx_ring *tx,
> >                       dev_consume_skb_any(skb);
> >                       if (tx->raw_addressing)
> >                               continue;
> > -                     /* FIFO free */
> > -                     for (i =3D 0; i < ARRAY_SIZE(info->iov); i++) {
> > -                             space_freed +=3D info->iov[i].iov_len + i=
nfo->iov[i].iov_padding;
> > -                             info->iov[i].iov_len =3D 0;
> > -                             info->iov[i].iov_padding =3D 0;
> > -                     }
> > +                     space_freed +=3D gve_tx_clear_buffer_state(info);
> >               }
> >       }
> >
> > @@ -729,6 +840,24 @@ u32 gve_tx_load_event_counter(struct gve_priv *pri=
v,
> >       return be32_to_cpu(counter);
> >  }
> >
> > +bool gve_xdp_poll(struct gve_notify_block *block, int budget)
> > +{
> > +     struct gve_priv *priv =3D block->priv;
> > +     struct gve_tx_ring *tx =3D block->tx;
> > +     u32 nic_done;
> > +     u32 to_do;
> > +
> > +     /* If budget is 0, do all the work */
> > +     if (budget =3D=3D 0)
> > +             budget =3D INT_MAX;
> > +
> > +     /* Find out how much work there is to be done */
> > +     nic_done =3D gve_tx_load_event_counter(priv, tx);
> > +     to_do =3D min_t(u32, (nic_done - tx->done), budget);
> > +     gve_clean_xdp_done(priv, tx, to_do);
> > +     return nic_done !=3D tx->done;
> > +}
> > +
> >  bool gve_tx_poll(struct gve_notify_block *block, int budget)
> >  {
> >       struct gve_priv *priv =3D block->priv;
> > --
> > 2.40.0.rc1.284.g88254d51c5-goog
> >
