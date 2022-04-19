Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CA6506F98
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345094AbiDSOCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345181AbiDSOC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:02:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C21F238DBD
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650376784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cNj2bW9wftFFQJnhSD8AA0gpZcIpDPV4/deZqZ43OvI=;
        b=e4reu9f5eZtrlohxKtTly+t3BvydthZv83bru3rUjIjQv68094RbYwythFzwc1v4xazLQE
        M0VcX8whGw/3+tI8JzViPOYRYXVpLz+2xXi/ljikiH3ONCgAXoCOBnpxX1qpWlCNruMd3k
        UGAgouNWAoCcRXsFRMR+9B/kwago40w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-NpH8WmlqPy-VV-XKsIWrTA-1; Tue, 19 Apr 2022 09:59:43 -0400
X-MC-Unique: NpH8WmlqPy-VV-XKsIWrTA-1
Received: by mail-wm1-f71.google.com with SMTP id v62-20020a1cac41000000b0038cfe6edf3fso1383090wme.5
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:59:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cNj2bW9wftFFQJnhSD8AA0gpZcIpDPV4/deZqZ43OvI=;
        b=sioG1wuv2RC46poC/4upUYXXt4BLsDGzYSUTEgTb2SrEyZ8CvoKfN+03lj06veL8D/
         143PdgzpmjuadL0a5m0R5v6muTeFDHPTj9NHurNrUCuiiVBSK62TpSfM3HSdEcMz1bZn
         rxSJ76h7x4j4kqfu07f1nHMTD1Pg24qiwJxz93SDC/6PmbnM2lx6sRa8isz0oKG5ZooX
         P7V8vHUIxQmiYiJdLt3O5cq9Mk4qoaLYA5QjPJXCxPS9onz7byagsr2xD6KD5jmV8wwN
         VQiy4lT1OmdhpFeyRuJBvEMzl4t5suFCuWI0XbE07ComBZ6pJLO6mqKIhQc4at4YFkM/
         64wg==
X-Gm-Message-State: AOAM533HQUjC8lPfFnWS7LG9+EcytRKR/+pevVFyuziROA6LnkxcoV7F
        MuhWkuEQStO205ZvgR0UNCFTdOOtjJ4/hLanYPY0tK6XYozh49b/M/tdRc5xN22ROEz+qNvlWvj
        By1LFo7t7jfGaySxj
X-Received: by 2002:a1c:2744:0:b0:382:a9b7:1c8a with SMTP id n65-20020a1c2744000000b00382a9b71c8amr15512167wmn.187.1650376782114;
        Tue, 19 Apr 2022 06:59:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJya0RyHs4eY96bx9fptenJrBTI300hQq75LI6sH7SxmZT/PQ4ODrjjeLCXAYS0HT65E25mO+A==
X-Received: by 2002:a1c:2744:0:b0:382:a9b7:1c8a with SMTP id n65-20020a1c2744000000b00382a9b71c8amr15512145wmn.187.1650376781799;
        Tue, 19 Apr 2022 06:59:41 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-237.dyn.eolo.it. [146.241.96.237])
        by smtp.gmail.com with ESMTPSA id bh26-20020a05600c3d1a00b003928db85759sm9216126wmb.15.2022.04.19.06.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 06:59:41 -0700 (PDT)
Message-ID: <862fb2570c4350f0fd3bb3ad153d37b528564ed1.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/2] tcp: ensure to use the most recently
 sent skb when filling the rate sample
From:   Paolo Abeni <pabeni@redhat.com>
To:     Neal Cardwell <ncardwell@google.com>,
        Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 19 Apr 2022 15:59:40 +0200
In-Reply-To: <CADVnQymGad1=tvLocBCrGK5vtVDKv8m-dYP83VsZfmE-WFcL3w@mail.gmail.com>
References: <1650100749-10072-1-git-send-email-yangpc@wangsu.com>
         <1650100749-10072-2-git-send-email-yangpc@wangsu.com>
         <CADVnQymGad1=tvLocBCrGK5vtVDKv8m-dYP83VsZfmE-WFcL3w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-04-17 at 14:51 -0400, Neal Cardwell wrote:
> On Sat, Apr 16, 2022 at 5:20 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> > 
> > If an ACK (s)acks multiple skbs, we favor the information
> > from the most recently sent skb by choosing the skb with
> > the highest prior_delivered count. But in the interval
> > between receiving ACKs, we send multiple skbs with the same
> > prior_delivered, because the tp->delivered only changes
> > when we receive an ACK.
> > 
> > We used RACK's solution, copying tcp_rack_sent_after() as
> > tcp_skb_sent_after() helper to determine "which packet was
> > sent last?". Later, we will use tcp_skb_sent_after() instead
> > in RACK.
> > 
> > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
> > ---
> >  include/net/tcp.h   |  6 ++++++
> >  net/ipv4/tcp_rate.c | 11 ++++++++---
> >  2 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index 6d50a66..fcd69fc 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -1042,6 +1042,7 @@ struct rate_sample {
> >         int  losses;            /* number of packets marked lost upon ACK */
> >         u32  acked_sacked;      /* number of packets newly (S)ACKed upon ACK */
> >         u32  prior_in_flight;   /* in flight before this ACK */
> > +       u32  last_end_seq;      /* end_seq of most recently ACKed packet */
> >         bool is_app_limited;    /* is sample from packet with bubble in pipe? */
> >         bool is_retrans;        /* is sample from retransmission? */
> >         bool is_ack_delayed;    /* is this (likely) a delayed ACK? */
> > @@ -1158,6 +1159,11 @@ void tcp_rate_gen(struct sock *sk, u32 delivered, u32 lost,
> >                   bool is_sack_reneg, struct rate_sample *rs);
> >  void tcp_rate_check_app_limited(struct sock *sk);
> > 
> > +static inline bool tcp_skb_sent_after(u64 t1, u64 t2, u32 seq1, u32 seq2)
> > +{
> > +       return t1 > t2 || (t1 == t2 && after(seq1, seq2));
> > +}
> > +
> >  /* These functions determine how the current flow behaves in respect of SACK
> >   * handling. SACK is negotiated with the peer, and therefore it can vary
> >   * between different flows.
> > diff --git a/net/ipv4/tcp_rate.c b/net/ipv4/tcp_rate.c
> > index 617b818..a8f6d9d 100644
> > --- a/net/ipv4/tcp_rate.c
> > +++ b/net/ipv4/tcp_rate.c
> > @@ -74,27 +74,32 @@ void tcp_rate_skb_sent(struct sock *sk, struct sk_buff *skb)
> >   *
> >   * If an ACK (s)acks multiple skbs (e.g., stretched-acks), this function is
> >   * called multiple times. We favor the information from the most recently
> > - * sent skb, i.e., the skb with the highest prior_delivered count.
> > + * sent skb, i.e., the skb with the most recently sent time and the highest
> > + * sequence.
> >   */
> >  void tcp_rate_skb_delivered(struct sock *sk, struct sk_buff *skb,
> >                             struct rate_sample *rs)
> >  {
> >         struct tcp_sock *tp = tcp_sk(sk);
> >         struct tcp_skb_cb *scb = TCP_SKB_CB(skb);
> > +       u64 tx_tstamp;
> > 
> >         if (!scb->tx.delivered_mstamp)
> >                 return;
> > 
> > +       tx_tstamp = tcp_skb_timestamp_us(skb);
> >         if (!rs->prior_delivered ||
> > -           after(scb->tx.delivered, rs->prior_delivered)) {
> > +           tcp_skb_sent_after(tx_tstamp, tp->first_tx_mstamp,
> > +                              scb->end_seq, rs->last_end_seq)) {
> >                 rs->prior_delivered_ce  = scb->tx.delivered_ce;
> >                 rs->prior_delivered  = scb->tx.delivered;
> >                 rs->prior_mstamp     = scb->tx.delivered_mstamp;
> >                 rs->is_app_limited   = scb->tx.is_app_limited;
> >                 rs->is_retrans       = scb->sacked & TCPCB_RETRANS;
> > +               rs->last_end_seq     = scb->end_seq;
> > 
> >                 /* Record send time of most recently ACKed packet: */
> > -               tp->first_tx_mstamp  = tcp_skb_timestamp_us(skb);
> > +               tp->first_tx_mstamp  = tx_tstamp;
> >                 /* Find the duration of the "send phase" of this window: */
> >                 rs->interval_us = tcp_stamp_us_delta(tp->first_tx_mstamp,
> >                                                      scb->tx.first_tx_mstamp);
> > --
> 
> Thanks for the patch! The change looks good to me, and it passes our
> team's packetdrill tests.
> 
> One suggestion: currently this patch seems to be targeted to the
> net-next branch. However, since it's a bug fix my sense is that it
> would be best to target this to the net branch, so that it gets
> backported to stable releases.
> 
> One complication is that the follow-on patch in this series ("tcp: use
> tcp_skb_sent_after() instead in RACK") is a pure re-factor/cleanup,
> which is more appropriate for net-next. So the plan I was trying to
> describe in the previous thread was that this series could be
> implemented as:
> 
> (1) first, submit "tcp: ensure to use the most recently sent skb when
> filling the rate sample" to the net branch
> (2) wait for the fix in the net branch to be merged into the net-next branch
> (3) second, submit "tcp: use tcp_skb_sent_after() instead in RACK" to
> the net-next branch
> 
> What do folks think?

+1 for the above.

@Pengcheng: please additionally provide a suitable 'fixes' tag for
patch 1/2.

Thanks!

Paolo	

