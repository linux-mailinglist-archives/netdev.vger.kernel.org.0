Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C89533C75
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 14:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239239AbiEYMPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 08:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiEYMPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 08:15:08 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66550220E0;
        Wed, 25 May 2022 05:15:06 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gh17so28246531ejc.6;
        Wed, 25 May 2022 05:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QrBazMljV8YDziKAMrRaGBYt/oCZVqU8ZmRCHkABRKE=;
        b=kWbxqbhG7dkA/4CuIrYYJRy3XBcWbneF8HnMpMgW5GFIKHkObbpMjpBAqmMwGxhznz
         7G/0y69Acu1LotVuYVo0Ave84yUrr3Tole7jdUAS83MEVUXCl4MwtY1KDfnmaHBS1ZVu
         1/+TUCAGUfBwApIA4TEGIUV7wxvgwg0mqBCoA/CM3J2KrVd/txkYONNzY00J8tHr6OMx
         xjDQPhJaLSO6p1wettAByI7+9qArFiSzY7WZaq4gN3s43NgTfAk46LZVwMB9XrwLWyut
         S3e4FVm5rhzHddV97dQBTgTvYm9BBZbWCqvzElDvP2te+Hxca1qp1EomJZRkAYqc6QVd
         Mjwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QrBazMljV8YDziKAMrRaGBYt/oCZVqU8ZmRCHkABRKE=;
        b=OY1z3Jo2UDnK9bUFKIXEzEZ4JccSVSg1eBDhnC0VlKFfUw7Lq5RXMRaZw1tN1/oqzB
         VgJKh6y+3+0s4EC7wtmr91c0I22zJOeceiZZLfjmgeBcUH5HT0Ox+yEuVw0RIESop4cC
         5fOcMD89J78haKjtaxZnK/ZyG9Hh9Fpl0IuoDFJiFbaH4Vz2o7NjuMJR8vAnNkPnBYra
         QATjBOXJGMfEks0a34DjGrg8DTkfgrex/O/xkQR6AELOP91dqTf8brz21gFK3i+4Jl8S
         6jrfOUFH0Qg661mSQTqL8CAkVlVCPOXbIexPO0Efz6uDr7pVg1sFX5y54FqPFk276D9Z
         elRw==
X-Gm-Message-State: AOAM530kuLMMZZfOJN/5YqsEIZVfmk3uxmudk2x4BUfuXPWI5sHxpI6N
        3lTwBYzi43OOA+83rKkGOvhS6IgFpKjBGS20GSo=
X-Google-Smtp-Source: ABdhPJxoicBSY3Ejfl1QZtENI/38t0mu/1ls+RVgsbfCLJbzzktIOa4c05rTt92C8lJUTw/yaF/CxNUyhLfaCCtKmRY=
X-Received: by 2002:a17:906:9e83:b0:6fe:9f59:a4a4 with SMTP id
 fx3-20020a1709069e8300b006fe9f59a4a4mr25799393ejc.163.1653480904656; Wed, 25
 May 2022 05:15:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220525103512.3666956-1-gasmibal@gmail.com> <87r14hoox8.fsf@toke.dk>
In-Reply-To: <87r14hoox8.fsf@toke.dk>
From:   Baligh GASMI <gasmibal@gmail.com>
Date:   Wed, 25 May 2022 14:14:54 +0200
Message-ID: <CALxDnQa8d8CGXz2Mxvsz5csLj3KuTDW=z65DSzHk5x1Vg+y-rw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] mac80211: use AQL airtime for expected throughput.
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MAC80211" <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

> > Since the integration of AQL, packet TX airtime estimation is
> > calculated and counted to be used for the dequeue limit.
> >
> > Use this estimated airtime to compute expected throughput for
> > each station.
> >
> > It will be a generic mac80211 implementation. If the driver has
> > get_expected_throughput implementation, it will be used instead.
> >
> > Useful for L2 routing protocols, like B.A.T.M.A.N.
> >
> > Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
> > ---
> >  net/mac80211/driver-ops.h |  2 ++
> >  net/mac80211/sta_info.h   |  2 ++
> >  net/mac80211/status.c     | 22 ++++++++++++++++++++++
> >  net/mac80211/tx.c         |  3 ++-
> >  4 files changed, 28 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> > index 4e2fc1a08681..4331b79647fa 100644
> > --- a/net/mac80211/driver-ops.h
> > +++ b/net/mac80211/driver-ops.h
> > @@ -1142,6 +1142,8 @@ static inline u32 drv_get_expected_throughput(struct ieee80211_local *local,
> >       trace_drv_get_expected_throughput(&sta->sta);
> >       if (local->ops->get_expected_throughput && sta->uploaded)
> >               ret = local->ops->get_expected_throughput(&local->hw, &sta->sta);
> > +     else
> > +             ret = ewma_avg_est_tp_read(&sta->status_stats.avg_est_tp);
> >       trace_drv_return_u32(local, ret);
> >
> >       return ret;
> > diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> > index 379fd367197f..fe60be4c671d 100644
> > --- a/net/mac80211/sta_info.h
> > +++ b/net/mac80211/sta_info.h
> > @@ -123,6 +123,7 @@ enum ieee80211_sta_info_flags {
> >  #define HT_AGG_STATE_STOP_CB         7
> >  #define HT_AGG_STATE_SENT_ADDBA              8
> >
> > +DECLARE_EWMA(avg_est_tp, 8, 16)
> >  DECLARE_EWMA(avg_signal, 10, 8)
> >  enum ieee80211_agg_stop_reason {
> >       AGG_STOP_DECLINED,
> > @@ -641,6 +642,7 @@ struct sta_info {
> >               s8 last_ack_signal;
> >               bool ack_signal_filled;
> >               struct ewma_avg_signal avg_ack_signal;
> > +             struct ewma_avg_est_tp avg_est_tp;
> >       } status_stats;
> >
> >       /* Updated from TX path only, no locking requirements */
> > diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> > index e81e8a5bb774..647ade3719f5 100644
> > --- a/net/mac80211/status.c
> > +++ b/net/mac80211/status.c
> > @@ -1145,6 +1145,28 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
> >                       sta->status_stats.retry_failed++;
> >               sta->status_stats.retry_count += retry_count;
> >
> > +             if (skb && tx_time_est) {
>
> Shouldn't this be conditioned on actually being used (i.e., existence of
> get_expected_throughput op? Also maybe pull it out into its own function
> to make it clear what it's doing...

It's already the case I think, since the tx_time_est is not-zero only
when actually an estimated time is set.
A dedicated function seems good for me, for clarity, yes.

>
> > +                     /* max average packet size */
> > +                     size_t pkt_size = skb->len > 1024 ? 1024 : skb->len;
> > +
> > +                     if (acked) {
> > +                             /* ACK packet size */
> > +                             pkt_size += 14;
> > +                             /* SIFS x 2 */
> > +                             tx_time_est += 2 * 2;
> > +                     }
> > +
> > +                     /* Backoff average x retries */
> > +                     tx_time_est += retry_count ? retry_count * 2 : 2;
> > +
> > +                     /* failed tx */
> > +                     if (!acked && !noack_success)
> > +                             pkt_size = 0;
> > +
> > +                     ewma_avg_est_tp_add(&sta->status_stats.avg_est_tp,
> > +                                         ((pkt_size * 8) * 1000) / tx_time_est);
>
> Could we avoid adding this division in the fast path?

Maybe we can use the do_div() macro for optimization, I don't see how
we can avoid it.


>
> > +             }
> > +
> >               if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
> >                       if (sdata->vif.type == NL80211_IFTYPE_STATION &&
> >                           skb && !(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP))
> > diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> > index b6b20f38de0e..d866a721690d 100644
> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -3793,7 +3793,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
> >       IEEE80211_SKB_CB(skb)->control.vif = vif;
> >
> >       if (vif &&
> > -         wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL)) {
> > +         (!local->ops->get_expected_throughput ||
> > +         wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL))) {
>
> This implicitly enables AQL for every driver that doesn't set
> get_expected_throughput, no? That is probably not a good idea...

No, AQL will be disabled if it's already the case, according to the
NL80211_EXT_FEATURE_AQL, only airtime estimation will be activated
with this diff. The function ieee80211_sta_update_pending_airtime() is
already checking for NL80211_EXT_FEATURE_AQL.

>
> -Toke
>

Back to the base idea, what do you think about it, can it be a good
road to take ?
Other factors can be added progressively to better estimate the throughput...
