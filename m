Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C0E507EB1
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 04:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358826AbiDTCOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 22:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiDTCOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 22:14:45 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4084927FF0
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 19:12:01 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id fu34so96693qtb.8
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 19:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1YmXNBroxOAhoLMYlzyd1FuvB7VDP7mOZRyI41EeRAQ=;
        b=nIYQfq1CZzpbKexuxJ4ijfUgTD3fMPskj2KQtF3xJO80TqKnWHN/WSYznS/jtYkd6H
         3J0Z4wJiemTespHUnLzSdhA5A+tt5v1NolR7PkTX7AW6WobHxoZzILeLaIEHAfe05tRb
         lCYFS7eX7pqOJkS/2k3iEFFINMhfIe6VfSI8nJ5pXDD0HnET5zf6wYRa2UG9XRuu2SMj
         /UB65Mse9w/Wts3MeUl7rTn2XkuJJAqM0uW40kjk3zoFikTKZ/VHoC587BiY98lakkIE
         +Zp/rRvB5NAGupl8fSzx0qz/x35wuPaqIJ4gKi9OTdKyK+z2reEM8B74uqai61FCPLZh
         ZT1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1YmXNBroxOAhoLMYlzyd1FuvB7VDP7mOZRyI41EeRAQ=;
        b=t2hWCfLMTopyZ0XRpU/dkECpMS9y1ub/LrHfYRglOKNh1miC8jOmLQE6uFQ7+z9Z4r
         0XX8vdVALb6Qczv1jE7o6t2/Q6l634uYaFPR+r7pR+JVNq0LTBMPUKZA6YoxdwNVd+Ux
         chS0EJC9NFJR/wPf3OxqWwISZMtxLuj9sj1JX6DCacr4Mgw/Ms0682D7iBDNkr29nhdk
         MHu7ia3cOclxgua1W5N+FZM7gOzOCZfGXOK3Wx/CfJMML42o1732q/26xxKj5Bzw+t55
         12ndmhTkXo7+bTaYzSIRDpgmPj1juDLlnJltsSHLHq5XTmHngJpIDP0SaAAwnwb6IRa6
         bDeg==
X-Gm-Message-State: AOAM532bJKNAT7s77Ycp3ayz5IfreY2QoT2Wp0C2P34gTtp6ZTqExDlW
        2lld16MpgghR3z+8xdzCHyXTTb6wwJkzaLlhbsAUcg==
X-Google-Smtp-Source: ABdhPJyxCd8c3vVXtPhOe3YB2GGVF3cWhIVGzcxsVNPSJq41ovtWGstt/uPQ4b5R7MBnxGatdHRxst3Na6IFM+qaA0c=
X-Received: by 2002:a05:622a:507:b0:2e2:3401:49e3 with SMTP id
 l7-20020a05622a050700b002e2340149e3mr12202452qtx.560.1650420720183; Tue, 19
 Apr 2022 19:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <1650100749-10072-1-git-send-email-yangpc@wangsu.com>
 <1650100749-10072-2-git-send-email-yangpc@wangsu.com> <CADVnQymGad1=tvLocBCrGK5vtVDKv8m-dYP83VsZfmE-WFcL3w@mail.gmail.com>
 <862fb2570c4350f0fd3bb3ad153d37b528564ed1.camel@redhat.com> <005c01d85458$bd0ef940$372cebc0$@wangsu.com>
In-Reply-To: <005c01d85458$bd0ef940$372cebc0$@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Tue, 19 Apr 2022 22:11:43 -0400
Message-ID: <CADVnQyn-R7ibSjVMp3jjBWn7S-Qear0DgEU4xnmMv6rP7q7M1Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] tcp: ensure to use the most recently sent
 skb when filling the rate sample
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 .

On Tue, Apr 19, 2022 at 9:48 PM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> On Tue, Apr 19, 2022 at 10:00 PM Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > On Sun, 2022-04-17 at 14:51 -0400, Neal Cardwell wrote:
> > > On Sat, Apr 16, 2022 at 5:20 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> > > >
> > > > If an ACK (s)acks multiple skbs, we favor the information
> > > > from the most recently sent skb by choosing the skb with
> > > > the highest prior_delivered count. But in the interval
> > > > between receiving ACKs, we send multiple skbs with the same
> > > > prior_delivered, because the tp->delivered only changes
> > > > when we receive an ACK.
> > > >
> > > > We used RACK's solution, copying tcp_rack_sent_after() as
> > > > tcp_skb_sent_after() helper to determine "which packet was
> > > > sent last?". Later, we will use tcp_skb_sent_after() instead
> > > > in RACK.
> > > >
> > > > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > > > Cc: Neal Cardwell <ncardwell@google.com>
> > > > ---
> > > >  include/net/tcp.h   |  6 ++++++
> > > >  net/ipv4/tcp_rate.c | 11 ++++++++---
> > > >  2 files changed, 14 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > > > index 6d50a66..fcd69fc 100644
> > > > --- a/include/net/tcp.h
> > > > +++ b/include/net/tcp.h
> > > > @@ -1042,6 +1042,7 @@ struct rate_sample {
> > > >         int  losses;            /* number of packets marked lost upon ACK */
> > > >         u32  acked_sacked;      /* number of packets newly (S)ACKed upon ACK */
> > > >         u32  prior_in_flight;   /* in flight before this ACK */
> > > > +       u32  last_end_seq;      /* end_seq of most recently ACKed packet */
> > > >         bool is_app_limited;    /* is sample from packet with bubble in pipe? */
> > > >         bool is_retrans;        /* is sample from retransmission? */
> > > >         bool is_ack_delayed;    /* is this (likely) a delayed ACK? */
> > > > @@ -1158,6 +1159,11 @@ void tcp_rate_gen(struct sock *sk, u32 delivered, u32 lost,
> > > >                   bool is_sack_reneg, struct rate_sample *rs);
> > > >  void tcp_rate_check_app_limited(struct sock *sk);
> > > >
> > > > +static inline bool tcp_skb_sent_after(u64 t1, u64 t2, u32 seq1, u32 seq2)
> > > > +{
> > > > +       return t1 > t2 || (t1 == t2 && after(seq1, seq2));
> > > > +}
> > > > +
> > > >  /* These functions determine how the current flow behaves in respect of SACK
> > > >   * handling. SACK is negotiated with the peer, and therefore it can vary
> > > >   * between different flows.
> > > > diff --git a/net/ipv4/tcp_rate.c b/net/ipv4/tcp_rate.c
> > > > index 617b818..a8f6d9d 100644
> > > > --- a/net/ipv4/tcp_rate.c
> > > > +++ b/net/ipv4/tcp_rate.c
> > > > @@ -74,27 +74,32 @@ void tcp_rate_skb_sent(struct sock *sk, struct sk_buff *skb)
> > > >   *
> > > >   * If an ACK (s)acks multiple skbs (e.g., stretched-acks), this function is
> > > >   * called multiple times. We favor the information from the most recently
> > > > - * sent skb, i.e., the skb with the highest prior_delivered count.
> > > > + * sent skb, i.e., the skb with the most recently sent time and the highest
> > > > + * sequence.
> > > >   */
> > > >  void tcp_rate_skb_delivered(struct sock *sk, struct sk_buff *skb,
> > > >                             struct rate_sample *rs)
> > > >  {
> > > >         struct tcp_sock *tp = tcp_sk(sk);
> > > >         struct tcp_skb_cb *scb = TCP_SKB_CB(skb);
> > > > +       u64 tx_tstamp;
> > > >
> > > >         if (!scb->tx.delivered_mstamp)
> > > >                 return;
> > > >
> > > > +       tx_tstamp = tcp_skb_timestamp_us(skb);
> > > >         if (!rs->prior_delivered ||
> > > > -           after(scb->tx.delivered, rs->prior_delivered)) {
> > > > +           tcp_skb_sent_after(tx_tstamp, tp->first_tx_mstamp,
> > > > +                              scb->end_seq, rs->last_end_seq)) {
> > > >                 rs->prior_delivered_ce  = scb->tx.delivered_ce;
> > > >                 rs->prior_delivered  = scb->tx.delivered;
> > > >                 rs->prior_mstamp     = scb->tx.delivered_mstamp;
> > > >                 rs->is_app_limited   = scb->tx.is_app_limited;
> > > >                 rs->is_retrans       = scb->sacked & TCPCB_RETRANS;
> > > > +               rs->last_end_seq     = scb->end_seq;
> > > >
> > > >                 /* Record send time of most recently ACKed packet: */
> > > > -               tp->first_tx_mstamp  = tcp_skb_timestamp_us(skb);
> > > > +               tp->first_tx_mstamp  = tx_tstamp;
> > > >                 /* Find the duration of the "send phase" of this window: */
> > > >                 rs->interval_us = tcp_stamp_us_delta(tp->first_tx_mstamp,
> > > >                                                      scb->tx.first_tx_mstamp);
> > > > --
> > >
> > > Thanks for the patch! The change looks good to me, and it passes our
> > > team's packetdrill tests.
> > >
> > > One suggestion: currently this patch seems to be targeted to the
> > > net-next branch. However, since it's a bug fix my sense is that it
> > > would be best to target this to the net branch, so that it gets
> > > backported to stable releases.
> > >
> > > One complication is that the follow-on patch in this series ("tcp: use
> > > tcp_skb_sent_after() instead in RACK") is a pure re-factor/cleanup,
> > > which is more appropriate for net-next. So the plan I was trying to
> > > describe in the previous thread was that this series could be
> > > implemented as:
> > >
> > > (1) first, submit "tcp: ensure to use the most recently sent skb when
> > > filling the rate sample" to the net branch
> > > (2) wait for the fix in the net branch to be merged into the net-next branch
> > > (3) second, submit "tcp: use tcp_skb_sent_after() instead in RACK" to
> > > the net-next branch
> > >
> > > What do folks think?
> >
> > +1 for the above.
> >
> > @Pengcheng: please additionally provide a suitable 'fixes' tag for
> > patch 1/2.
>
> Fixes: b9f64820fb22 ("tcp: track data delivery rate for a TCP connection")

Thanks. That looks like the correct SHA1. However, I think there may
be a miscommunication. :-)

I think what Paolo and I are suggesting is:

(1) e-mail the patch "tcp: ensure to use the most recently sent skb
when filling the rate sample" as a submission to the net branch
("[PATCH net v3] tcp: ensure to use the most recently sent skb when
filling the rate sample"), with the "Fixes:" footer in the commit
message  in the line above your "Signed-off-by:" footer.

(2) wait for the fix in the net branch to be merged into the net-next branch

(3) submit "tcp: use tcp_skb_sent_after() instead in RACK" to the
net-next branch

thanks,
neal
