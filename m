Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96075647EAC
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiLIHiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiLIHiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:38:51 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BC7E0A4
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:38:50 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id i15so2015505edf.2
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 23:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ORG5dftntHFQOZDuvn8wzr+O3Xce/vYu6onQkUg6Htg=;
        b=PaAjbxuR3PLMfggeHhBNZAIu0gdcrBeho8qP3n2Vc90xtXgUqbFMyrYYezm5BkYbYS
         XLb+mdQbTN+YDt67ArnT51ey3Opb34VFL37pgUAlqRcWiK5H1zXwcs90dVQL1azb9vme
         3xvcSDx+AeIaLL9nhiaonEf3+OXU/PY5TmNHDp0LBbR3FsUKejbZNylnmPCl/3PSu6Pw
         uueFXHBoJGEscnJEoffVUaTfANQdDUnMJ0pejZmFKm0Cg56bta23paAo5GLQYvnVpxcs
         RldLhTUTTsMHw+G9OY9EFelytiz8GXLq0/5SRUYdxjNC0JjUh0jnMGcUmueBRAnomuws
         0o+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ORG5dftntHFQOZDuvn8wzr+O3Xce/vYu6onQkUg6Htg=;
        b=V1As5vQoNhONjcx+9GT62FvYZC+LKziQNfxlww8T146N4EJ9cejIosKPORsIPfCRJR
         QzGkZAapFoeroQHDFl8m4Uxkh/l2+8H3aXryn6o+MDGZbQQ964IgqFKsLBE1iuM/ed04
         P6r2D5neBvNIl0zjNyzeWETCT63i/MtXpi08bj98kO2pQq8aa1TTPlCemAl6rds7oRDv
         Eji6fbJ2tHWQvDIPAIbn09S0tA63gQR3UJytCQO9BzLZ5OrhXB6ffJfV0mYELOGjofBL
         H33CKUV//guRi1KpFO4X4YMhdbgSvdOxXT2Xr12SPFxcusy3iu50EGkMVwH0FMvtfKbm
         adfw==
X-Gm-Message-State: ANoB5pntHRcQX5nG2pwww5PNIvaU/ORFKffZgmkO0qQ4qyrY4eKBd5rN
        Aw4VX4dlOJZ5B6GvB8latXU8XGVi58aYyX30u3k=
X-Google-Smtp-Source: AA0mqf7EcuZkowjNd1yq5GNdUC66LXt0bHE9blPgsc5YxM/6HkEOWUmPxCtkX32aaHdb/+A9NOzvJlNw/zNWSfJ/NIc=
X-Received: by 2002:a05:6402:14:b0:461:deed:6d20 with SMTP id
 d20-20020a056402001400b00461deed6d20mr87513145edu.55.1670571528504; Thu, 08
 Dec 2022 23:38:48 -0800 (PST)
MIME-Version: 1.0
References: <20221205093359.49350-1-dnlplm@gmail.com> <20221205093359.49350-3-dnlplm@gmail.com>
 <ad410abb19bdbcdac617878d14a4e37228f1157b.camel@redhat.com>
In-Reply-To: <ad410abb19bdbcdac617878d14a4e37228f1157b.camel@redhat.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Fri, 9 Dec 2022 08:38:37 +0100
Message-ID: <CAGRyCJFL5VmeserfoTMY4bR+EWKSEWrdhSTSY8UQsAZphg8PWw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] net: qualcomm: rmnet: add tx packets aggregation
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il giorno mer 7 dic 2022 alle ore 13:46 Paolo Abeni
<pabeni@redhat.com> ha scritto:
>
> On Mon, 2022-12-05 at 10:33 +0100, Daniele Palmas wrote:
> > diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> > index a313242a762e..914ef03b5438 100644
> > --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> > +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> > @@ -164,8 +164,18 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
> >
> >       map_header->mux_id = mux_id;
> >
> > -     skb->protocol = htons(ETH_P_MAP);
> > +     if (port->egress_agg_params.count > 1) {
>
> This is racy. Here you read 'count' outside the 'agg_lock' lock and
> later, in rmnet_map_tx_aggregate() the code assumes the above condition
> helds, but ethtool could have changed the value in the meantime.
>
> You need a READ_ONCE() above, a WRITE_ONCE() on update and cope with 0
> value in rmnet_map_tx_aggregate().
>

Ack.

> [...]
>
> > +static void rmnet_map_flush_tx_packet_work(struct work_struct *work)
> > +{
> > +     struct sk_buff *skb = NULL;
> > +     struct rmnet_port *port;
> > +
> > +     port = container_of(work, struct rmnet_port, agg_wq);
> > +
> > +     spin_lock_bh(&port->agg_lock);
> > +     if (likely(port->agg_state == -EINPROGRESS)) {
> > +             /* Buffer may have already been shipped out */
> > +             if (likely(port->skbagg_head)) {
> > +                     skb = port->skbagg_head;
> > +                     reset_aggr_params(port);
> > +             }
> > +             port->agg_state = 0;
> > +     }
> > +
> > +     spin_unlock_bh(&port->agg_lock);
> > +     if (skb)
> > +             rmnet_send_skb(port, skb);
> > +}
> > +
> > +static enum hrtimer_restart rmnet_map_flush_tx_packet_queue(struct hrtimer *t)
> > +{
> > +     struct rmnet_port *port;
> > +
> > +     port = container_of(t, struct rmnet_port, hrtimer);
> > +
> > +     schedule_work(&port->agg_wq);
>
> Why you need to schedule a work and you can't instead call the core of
> rmnet_map_flush_tx_packet_work() here? it looks like the latter does
> not need process context...
>

Ack.

> > +
> > +     return HRTIMER_NORESTART;
> > +}
> > +
> > +unsigned int rmnet_map_tx_aggregate(struct sk_buff *skb, struct rmnet_port *port,
> > +                                 struct net_device *orig_dev)
> > +{
> > +     struct timespec64 diff, last;
> > +     unsigned int len = skb->len;
> > +     struct sk_buff *agg_skb;
> > +     int size;
> > +
> > +     spin_lock_bh(&port->agg_lock);
> > +     memcpy(&last, &port->agg_last, sizeof(struct timespec64));
> > +     ktime_get_real_ts64(&port->agg_last);
> > +
> > +     if (!port->skbagg_head) {
> > +             /* Check to see if we should agg first. If the traffic is very
> > +              * sparse, don't aggregate.
> > +              */
> > +new_packet:
> > +             diff = timespec64_sub(port->agg_last, last);
> > +             size = port->egress_agg_params.bytes - skb->len;
> > +
> > +             if (size < 0) {
> > +                     /* dropped */
> > +                     spin_unlock_bh(&port->agg_lock);
> > +                     return 0;
> > +             }
> > +
> > +             if (diff.tv_sec > 0 || diff.tv_nsec > RMNET_AGG_BYPASS_TIME_NSEC ||
> > +                 size == 0) {
>
> You can avoid some code duplication moving the following lines under an
> 'error' label and jumping to it here and in the next error case.
>

Ack.

> > +                     spin_unlock_bh(&port->agg_lock);
> > +                     skb->protocol = htons(ETH_P_MAP);
> > +                     dev_queue_xmit(skb);
> > +                     return len;
> > +             }
> > +
> > +             port->skbagg_head = skb_copy_expand(skb, 0, size, GFP_ATOMIC);
> > +             if (!port->skbagg_head) {
> > +                     spin_unlock_bh(&port->agg_lock);
> > +                     skb->protocol = htons(ETH_P_MAP);
> > +                     dev_queue_xmit(skb);
> > +                     return len;
> > +             }
> > +             dev_kfree_skb_any(skb);
> > +             port->skbagg_head->protocol = htons(ETH_P_MAP);
> > +             port->agg_count = 1;
> > +             ktime_get_real_ts64(&port->agg_time);
> > +             skb_frag_list_init(port->skbagg_head);
> > +             goto schedule;
> > +     }
> > +     diff = timespec64_sub(port->agg_last, port->agg_time);
> > +     size = port->egress_agg_params.bytes - port->skbagg_head->len;
> > +
> > +     if (skb->len > size) {
> > +             agg_skb = port->skbagg_head;
> > +             reset_aggr_params(port);
> > +             spin_unlock_bh(&port->agg_lock);
> > +             hrtimer_cancel(&port->hrtimer);
> > +             rmnet_send_skb(port, agg_skb);
> > +             spin_lock_bh(&port->agg_lock);
> > +             goto new_packet;
> > +     }
> > +
> > +     if (skb_has_frag_list(port->skbagg_head))
> > +             port->skbagg_tail->next = skb;
> > +     else
> > +             skb_shinfo(port->skbagg_head)->frag_list = skb;
> > +
> > +     port->skbagg_head->len += skb->len;
> > +     port->skbagg_head->data_len += skb->len;
> > +     port->skbagg_head->truesize += skb->truesize;
> > +     port->skbagg_tail = skb;
> > +     port->agg_count++;
> > +
> > +     if (diff.tv_sec > 0 || diff.tv_nsec > port->egress_agg_params.time_nsec ||
> > +         port->agg_count == port->egress_agg_params.count ||
>
> At this point port->egress_agg_params.count can be 0, you need to check
> for:
>         port->agg_count >= port->egress_agg_params.count
>

Got it, thanks for the review: I'll fix all the above and send v4.

Regards,
Daniele
