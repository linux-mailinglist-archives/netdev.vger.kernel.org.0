Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E8C51ADD6
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 21:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377521AbiEDThj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 15:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377547AbiEDThg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 15:37:36 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845F94C78B
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 12:33:57 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p10so4039144lfa.12
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 12:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HOEMNGZKa5Tmus2DFi6bec2fIE/amlqELv40n3DXewc=;
        b=PEIWHhsIYTSHa2ubsdOl50RsnGDjnDS6l/9Q78H4R9zjmgI+VIGT6Ch0klO8BTLuzj
         QkwWwD19A6kt/WhbCWEZXPEwJRYM3TpZ+cE3cP5MeDBh+aIOWOcohX49LVwMDFUZVK5N
         F0VOB2O//WhbS3FC0W/bzdzcBd/juFEyjENK2SJFSLuXRN+qFrhWbWdeUAZb9NkbpZXq
         2zaPcFtkldnZ66VWQQ12RIttNJOF73aLxM03ar+OaSwfAD1QeqBOTqRe87Z9uSpnfdVk
         LWYN6y4V8AizqgXtcBrR4CAsLLhpVp/pQ2uF2KJ1p7SkaufPpJk4WxJkAscNOJD11xKa
         W1PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HOEMNGZKa5Tmus2DFi6bec2fIE/amlqELv40n3DXewc=;
        b=3w+PNwZj4D18q4Ey3sm9ILO+YHOT77yqnCEJQmy7gEwITwuvN8cZVp5qf5ozLca5Av
         zws+gvQ2JPDzz4G2f6eI0bHS8lb13pS4LT8dgRQvak3DOm2MDHy39X1+oUhzUz2EcZWQ
         jWihiL5EaizEkg04BUtqnVsgxD1Mqv745F/BV97rqhPMYn/sSffKnSMwxj6zeaAEBcfq
         Ic/Xic1gnyl110njAI+cIQJR9uaWXRGDlU1zwu9QhGsdByip0El0JwFsPdBgIB02yTaj
         wucQU9DUz2dEHhXoLhCqZp66mkXFp86LmxMohXZnr3V8pI2pezFeHKUws5/wMQ0l81rF
         Ar/g==
X-Gm-Message-State: AOAM5310FaW8gr2Elm9GzuTV3jq7Eaj88WliMugdJnzkCEVrZkyJ7A48
        TpbHPmzZEKRvPUjDLUT/bgxJIfQl83ZfqqOwvErFdQ==
X-Google-Smtp-Source: ABdhPJynUP5X7Ap50Ln/lUGnqWbehA2p3TdLaYrpnA1ieEkvyziWiy0Api8fxqxG6H9YOKNmm2giXpx2cEkPaGo5x1g=
X-Received: by 2002:ac2:4c51:0:b0:473:ab19:87d9 with SMTP id
 o17-20020ac24c51000000b00473ab1987d9mr5487995lfk.634.1651692835654; Wed, 04
 May 2022 12:33:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220501111836.10910-1-gerhard@engleder-embedded.com>
 <20220501111836.10910-5-gerhard@engleder-embedded.com> <20220504182402.m6vsxy3hc6ofd2ni@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220504182402.m6vsxy3hc6ofd2ni@bsd-mbp.dhcp.thefacebook.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Wed, 4 May 2022 21:33:44 +0200
Message-ID: <CANr-f5yQoAbNHd1XfS+8iHObr1U72VMZJeMrdXHjRdzLrUJZfg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/6] ptp: Support late timestamp determination
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > If a physical clock supports a free running cycle counter, then
> > timestamps shall be based on this time too. For TX it is known in
> > advance before the transmission if a timestamp based on the free running
> > cycle counter is needed. For RX it is impossible to know which timestamp
> > is needed before the packet is received and assigned to a socket.
> >
> > Support late timestamp determination by a network device. Therefore, an
> > address/cookie is stored within the new netdev_data field of struct
> > skb_shared_hwtstamps. This address/cookie is provided to a new network
> > device function called ndo_get_tstamp(), which returns a timestamp based
> > on the normal/adjustable time or based on the free running cycle
> > counter. If function is not supported, then timestamp handling is not
> > changed.
> >
> > Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> > ---
> >  include/linux/netdevice.h | 21 ++++++++++++++++++++
> >  include/linux/skbuff.h    | 16 ++++++++++++---
> >  net/socket.c              | 42 +++++++++++++++++++++++++++++----------
> >  3 files changed, 66 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 4aba92a4042a..47dca9adfb17 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1356,6 +1356,12 @@ struct netdev_net_notifier {
> >   *   The caller must be under RCU read context.
> >   * int (*ndo_fill_forward_path)(struct net_device_path_ctx *ctx, struct net_device_path *path);
> >   *     Get the forwarding path to reach the real device from the HW destination address
> > + * ktime_t (*ndo_get_tstamp)(struct net_device *dev,
> > + *                        const struct skb_shared_hwtstamps *hwtstamps,
> > + *                        bool cycles);
> > + *   Get hardware timestamp based on normal/adjustable time or free running
> > + *   cycle counter. This function is required if physical clock supports a
> > + *   free running cycle counter.
> >   */
> >  struct net_device_ops {
> >       int                     (*ndo_init)(struct net_device *dev);
> > @@ -1578,6 +1584,9 @@ struct net_device_ops {
> >       struct net_device *     (*ndo_get_peer_dev)(struct net_device *dev);
> >       int                     (*ndo_fill_forward_path)(struct net_device_path_ctx *ctx,
> >                                                           struct net_device_path *path);
> > +     ktime_t                 (*ndo_get_tstamp)(struct net_device *dev,
> > +                                               const struct skb_shared_hwtstamps *hwtstamps,
> > +                                               bool cycles);
> >  };
> >
> >  /**
> > @@ -4738,6 +4747,18 @@ static inline void netdev_rx_csum_fault(struct net_device *dev,
> >  void net_enable_timestamp(void);
> >  void net_disable_timestamp(void);
> >
> > +static inline ktime_t netdev_get_tstamp(struct net_device *dev,
> > +                                     const struct skb_shared_hwtstamps *hwtstamps,
> > +                                     bool cycles)
> > +{
> > +     const struct net_device_ops *ops = dev->netdev_ops;
> > +
> > +     if (ops->ndo_get_tstamp)
> > +             return ops->ndo_get_tstamp(dev, hwtstamps, cycles);
> > +
> > +     return hwtstamps->hwtstamp;
> > +}
> > +
> >  static inline netdev_tx_t __netdev_start_xmit(const struct net_device_ops *ops,
> >                                             struct sk_buff *skb, struct net_device *dev,
> >                                             bool more)
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index fa03e02b761d..732b995fe54e 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -588,8 +588,10 @@ static inline bool skb_frag_must_loop(struct page *p)
> >
> >  /**
> >   * struct skb_shared_hwtstamps - hardware time stamps
> > - * @hwtstamp:        hardware time stamp transformed into duration
> > - *           since arbitrary point in time
> > + * @hwtstamp:                hardware time stamp transformed into duration
> > + *                   since arbitrary point in time
> > + * @netdev_data:     address/cookie of network device driver used as
> > + *                   reference to actual hardware time stamp
> >   *
> >   * Software time stamps generated by ktime_get_real() are stored in
> >   * skb->tstamp.
> > @@ -601,7 +603,10 @@ static inline bool skb_frag_must_loop(struct page *p)
> >   * &skb_shared_info. Use skb_hwtstamps() to get a pointer.
> >   */
> >  struct skb_shared_hwtstamps {
> > -     ktime_t hwtstamp;
> > +     union {
> > +             ktime_t hwtstamp;
> > +             void *netdev_data;
> > +     };
> >  };
> >
> >  /* Definitions for tx_flags in struct skb_shared_info */
> > @@ -620,6 +625,11 @@ enum {
> >        */
> >       SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
> >
> > +     /* determine hardware time stamp based on time or cycles, flag is used
> > +      * only for RX path
> > +      */
> > +     SKBTX_HW_TSTAMP_NETDEV = 1 << 3,
> > +
> >       /* generate wifi status information (where possible) */
> >       SKBTX_WIFI_STATUS = 1 << 4,
>
> I follow what is being done here, although it seems a bit messy:
>   - abusing tx_flags for recive
>   - keeping a pointer into skb->data for later use.

Abuse of tx_flags is because of saving bits for future flags. The same bit
is used for TX and RX, instead of a separate bit for RX.

>
>
> > diff --git a/net/socket.c b/net/socket.c
> > index 0f680c7d968a..ee81e25e9b98 100644
> > --- a/net/socket.c
> > +++ b/net/socket.c
> > @@ -805,7 +805,8 @@ static bool skb_is_swtx_tstamp(const struct sk_buff *skb, int false_tstamp)
> >       return skb->tstamp && !false_tstamp && skb_is_err_queue(skb);
> >  }
> >
> > -static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb)
> > +static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
> > +                        int if_index)
> >  {
> >       struct scm_ts_pktinfo ts_pktinfo;
> >       struct net_device *orig_dev;
> > @@ -815,11 +816,15 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb)
> >
> >       memset(&ts_pktinfo, 0, sizeof(ts_pktinfo));
> >
> > -     rcu_read_lock();
> > -     orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> > -     if (orig_dev)
> > -             ts_pktinfo.if_index = orig_dev->ifindex;
> > -     rcu_read_unlock();
> > +     if (if_index == -1) {
> > +             rcu_read_lock();
> > +             orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> > +             if (orig_dev)
> > +                     ts_pktinfo.if_index = orig_dev->ifindex;
> > +             rcu_read_unlock();
> > +     } else {
> > +             ts_pktinfo.if_index = if_index;
> > +     }
>
> if_index of 0 is invalid - see dev_new_index().
> So this optimization would be better written as:
>
>         if (!if_index) {
>                 rcu_read_lock();
>                 orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
>                 if (orig_dev)
>                         if_index = orig_dev->ifindex;
>                 rcu_read_unlock();
>         }
>         ts_pktinfo.if_index = if_index;

I will fix that.

> >       ts_pktinfo.pkt_length = skb->len - skb_mac_offset(skb);
> >       put_cmsg(msg, SOL_SOCKET, SCM_TIMESTAMPING_PKTINFO,
> > @@ -839,6 +844,8 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
> >       int empty = 1, false_tstamp = 0;
> >       struct skb_shared_hwtstamps *shhwtstamps =
> >               skb_hwtstamps(skb);
> > +     struct net_device *orig_dev;
> > +     int if_index = -1;
>
> This should be set to 0 in the SOF_TIMESTAMPING_RAW_HARDWARE block.
> (see below)

I will fix that.

> >       ktime_t hwtstamp;
> >
> >       /* Race occurred between timestamp enabling and packet
> > @@ -887,18 +894,33 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
> >       if (shhwtstamps &&
> >           (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
> >           !skb_is_swtx_tstamp(skb, false_tstamp)) {
> > +             if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_NETDEV) {
> > +                     rcu_read_lock();
> > +                     orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> > +                     if (orig_dev) {
> > +                             if_index = orig_dev->ifindex;
> > +                             hwtstamp = netdev_get_tstamp(orig_dev,
> > +                                                          shhwtstamps,
> > +                                                          sk->sk_tsflags &
> > +                                                          SOF_TIMESTAMPING_BIND_PHC);
> > +                     } else {
> > +                             hwtstamp = shhwtstamps->hwtstamp;
> > +                     }
> > +                     rcu_read_unlock();
> > +             } else {
> > +                     hwtstamp = shhwtstamps->hwtstamp;
> > +             }
> > +
>
> I'd suggest moving all this into a helper function, so it reads
> something like this:
>
>                 if_index = 0;
>
>                 if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_NETDEV)
>                         hwtstamp = recover_hw_tstamp(skb, sk, &if_index);
>                 else
>                         hwtstamp = shhwtstamps->hwtstamp;

I will add a helper function.

> >               if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
> > -                     hwtstamp = ptp_convert_timestamp(&shhwtstamps->hwtstamp,
> > +                     hwtstamp = ptp_convert_timestamp(&hwtstamp,
> >                                                        sk->sk_bind_phc);
> > -             else
> > -                     hwtstamp = shhwtstamps->hwtstamp;
> >
> >               if (ktime_to_timespec64_cond(hwtstamp, tss.ts + 2)) {
> >                       empty = 0;
> >
> >                       if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_PKTINFO) &&
> >                           !skb_is_err_queue(skb))
> > -                             put_ts_pktinfo(msg, skb);
> > +                             put_ts_pktinfo(msg, skb, if_index);
> >               }
> >       }
> >       if (!empty) {
> > --
> > 2.20.1
> >
>
> --
> Jonathan

Thank you for the review!

Gerhard
