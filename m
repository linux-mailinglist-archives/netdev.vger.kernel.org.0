Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093F55A1344
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 16:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241339AbiHYORX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 10:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241212AbiHYORV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 10:17:21 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C2CA033C;
        Thu, 25 Aug 2022 07:17:20 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id z6so28420504lfu.9;
        Thu, 25 Aug 2022 07:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=svH0f/ovjc36+cztYrriyBIHAyYNi6kUoSEn/6GFfSo=;
        b=dCk4e3DtU88chNrEDYtjUzQ2y11q76uFbHsVIZW+dEufhMzMYyy1R36pyJ3XP93w78
         grp0KNxwzvJSWSaXQU63KUc9Sz2iGbQsyr+jSubzh71dk4qzzEk7JRyfwzGFtPxn8+d0
         b/JC4YuqE7o87JBco82lV1AoO1bqCeyb5NuNMQZsPThw8wbY/yZrghUmkYopPLS7Juno
         8iTw/n4dWw0wYOJvpGhP7/aRyddbpdM9k89A2I/9b7Il31pfpvLo/gHR2iqg5JW1ZoW4
         BOkHQTPdur4l3RJH9qMEgK8i4z4hR4dFG6U74oGquvCqlkrcmKEbsp6ViZuzbxVCkTOt
         g47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=svH0f/ovjc36+cztYrriyBIHAyYNi6kUoSEn/6GFfSo=;
        b=hhx8UUdYmQ046j584xvGnfXEZ7v70pI3JjGcNN8Wyb22183qRZfmfya8OIY6wjlvo8
         Q/bB88ZhnqsjiyHfizjwwyM8OlNg55WYkLWJ05MoZrHOFl2ynwYr1Zmxo+JoUg6m+nG4
         AZ2IEXU/7+sSkmqf3sannXxIYpnNvXYyf4jJ3wAa9G/VkJrUhSnIFM7t7EeCLOIhizQj
         W/xN7fNJefVYxyFzztkMU9y44+6AgNhmhbR2+fhQT5vrLo3R78+6jRofzkE7Lx0XM6uG
         HQpc8Xzx9eXzQJ8ldqZVMrkq691F4IqP4VzOr76FY6/fwr3YALZNj06U5outGxHWHnlh
         jrhQ==
X-Gm-Message-State: ACgBeo3Jx4h+ji6mUw/9q0IDcEjhyXtvgC+JxpaQJjp9ahrVK6ICijxo
        f8DeMS9y1Ha4Fgouvt2V92UFtrFPTJZ/cbiQ0vw=
X-Google-Smtp-Source: AA6agR4F+s0G6KHV/04Zdwcx9S9tMODzO+eFZ5BK7Gd3fcRExOm89D94UvAd6ZodmhUtQNk9bnvQB7AflMmyXwR28y4=
X-Received: by 2002:a05:6512:32c5:b0:48b:fa9f:a98f with SMTP id
 f5-20020a05651232c500b0048bfa9fa98fmr1164283lfg.335.1661437039944; Thu, 25
 Aug 2022 07:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220719123525.3448926-1-gasmibal@gmail.com> <20220719123525.3448926-2-gasmibal@gmail.com>
 <CMF5B109JKDQ.R3G4GDYBLZT6@syracuse>
In-Reply-To: <CMF5B109JKDQ.R3G4GDYBLZT6@syracuse>
From:   Baligh GASMI <gasmibal@gmail.com>
Date:   Thu, 25 Aug 2022 16:17:08 +0200
Message-ID: <CALxDnQbjA-iLaRyN_8CBs5ZyAXbDR7PnFoDDyUWny5=5DBxD7g@mail.gmail.com>
Subject: Re: [RFC/RFT v5 1/4] mac80211: use AQL airtime for expected throughput.
To:     Nicolas Escande <nico.escande@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MAC80211" <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Linus Lussing <linus.luessing@c0d3.blue>,
        Kalle Valo <kvalo@kernel.org>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Nicolas,

Yes, you are right.
I'll take it into account in the next version, and the other 64bits
divisions you detected on the other patches.

Thanks



Le jeu. 25 ao=C3=BBt 2022 =C3=A0 15:49, Nicolas Escande <nico.escande@gmail=
.com> a =C3=A9crit :
>
> Hello Baligh,
>
> On Tue Jul 19, 2022 at 2:35 PM CEST, Baligh Gasmi wrote:
> > Since the integration of AQL, packet TX airtime estimation is
> > calculated and counted to be used for the dequeue limit.
> >
> > Use this estimated airtime to compute expected throughput for
> > each station.
> >
> > It will be a generic mac80211 implementation. that can be used if the
> > driver do not have get_expected_throughput implementation.
> >
> > Useful for L2 routing protocols, like B.A.T.M.A.N.
> >
> > Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
> > Reported-by: kernel test robot <lkp@intel.com>
> > CC: Felix Fietkau <nbd@nbd.name>
> > ---
> >  net/mac80211/driver-ops.h |  2 ++
> >  net/mac80211/sta_info.c   | 39 +++++++++++++++++++++++++++++++++++++++
> >  net/mac80211/sta_info.h   | 11 +++++++++++
> >  net/mac80211/status.c     |  2 ++
> >  net/mac80211/tx.c         |  8 +++++++-
> >  5 files changed, 61 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> > index 4e2fc1a08681..fa9952154795 100644
> > --- a/net/mac80211/driver-ops.h
> > +++ b/net/mac80211/driver-ops.h
> > @@ -1142,6 +1142,8 @@ static inline u32 drv_get_expected_throughput(str=
uct ieee80211_local *local,
> >       trace_drv_get_expected_throughput(&sta->sta);
> >       if (local->ops->get_expected_throughput && sta->uploaded)
> >               ret =3D local->ops->get_expected_throughput(&local->hw, &=
sta->sta);
> > +     else
> > +             ret =3D ewma_avg_est_tp_read(&sta->deflink.status_stats.a=
vg_est_tp);
> >       trace_drv_return_u32(local, ret);
> >
> >       return ret;
> > diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> > index e04a0905e941..201aab465234 100644
> > --- a/net/mac80211/sta_info.c
> > +++ b/net/mac80211/sta_info.c
> > @@ -1993,6 +1993,45 @@ void ieee80211_sta_update_pending_airtime(struct=
 ieee80211_local *local,
> >                              tx_pending, 0);
> >  }
> >
> > +void ieee80211_sta_update_tp(struct ieee80211_local *local,
> > +                          struct sta_info *sta,
> > +                          struct sk_buff *skb,
> > +                          u16 tx_time_est,
> > +                          bool ack, int retry)
> > +{
> > +     unsigned long diff;
> > +     struct rate_control_ref *ref =3D NULL;
> > +
> > +     if (!skb || !sta || !tx_time_est)
> > +             return;
> > +
> > +     if (test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
> > +             ref =3D sta->rate_ctrl;
> > +
> > +     if (ref && ref->ops->get_expected_throughput)
> > +             return;
> > +
> > +     if (local->ops->get_expected_throughput)
> > +             return;
> > +
> > +     tx_time_est +=3D ack ? 4 : 0;
> > +     tx_time_est +=3D retry ? retry * 2 : 2;
> > +
> > +     sta->deflink.tx_stats.tp_tx_size +=3D (skb->len * 8) * 1000;
> > +     sta->deflink.tx_stats.tp_tx_time_est +=3D tx_time_est;
> > +
> > +     diff =3D jiffies - sta->deflink.status_stats.last_tp_update;
> > +     if (diff > HZ / 10) {
> > +             ewma_avg_est_tp_add(&sta->deflink.status_stats.avg_est_tp=
,
> > +                                 sta->deflink.tx_stats.tp_tx_size /
> > +                                 sta->deflink.tx_stats.tp_tx_time_est)=
;
> This needs a div_u64(), the arch may not have native 64 bits div support
> > +
> > +             sta->deflink.tx_stats.tp_tx_size =3D 0;
> > +             sta->deflink.tx_stats.tp_tx_time_est =3D 0;
> > +             sta->deflink.status_stats.last_tp_update =3D jiffies;
> > +     }
> > +}
> > +
> >  int sta_info_move_state(struct sta_info *sta,
> >                       enum ieee80211_sta_state new_state)
> >  {
> > diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> > index 35c390bedfba..4200856fefcd 100644
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
> > @@ -157,6 +158,12 @@ void ieee80211_register_airtime(struct ieee80211_t=
xq *txq,
> >
> >  struct sta_info;
> >
> > +void ieee80211_sta_update_tp(struct ieee80211_local *local,
> > +                          struct sta_info *sta,
> > +                          struct sk_buff *skb,
> > +                          u16 tx_time_est,
> > +                          bool ack, int retry);
> > +
> >  /**
> >   * struct tid_ampdu_tx - TID aggregation information (Tx).
> >   *
> > @@ -549,6 +556,8 @@ struct link_sta_info {
> >               s8 last_ack_signal;
> >               bool ack_signal_filled;
> >               struct ewma_avg_signal avg_ack_signal;
> > +             struct ewma_avg_est_tp avg_est_tp;
> > +             unsigned long last_tp_update;
> >       } status_stats;
> >
> >       /* Updated from TX path only, no locking requirements */
> > @@ -558,6 +567,8 @@ struct link_sta_info {
> >               struct ieee80211_tx_rate last_rate;
> >               struct rate_info last_rate_info;
> >               u64 msdu[IEEE80211_NUM_TIDS + 1];
> > +             u64 tp_tx_size;
> > +             u64 tp_tx_time_est;
> >       } tx_stats;
> >
> >       enum ieee80211_sta_rx_bandwidth cur_max_bandwidth;
> > diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> > index e69272139437..1fb93abc1709 100644
> > --- a/net/mac80211/status.c
> > +++ b/net/mac80211/status.c
> > @@ -1152,6 +1152,8 @@ void ieee80211_tx_status_ext(struct ieee80211_hw =
*hw,
> >       ack_signal_valid >              !!(info->status.flags & IEEE80211=
_TX_STATUS_ACK_SIGNAL_VALID);
> >
> > +     ieee80211_sta_update_tp(local, sta, skb, tx_time_est, acked, retr=
y_count);
> > +
> >       if (pubsta) {
> >               struct ieee80211_sub_if_data *sdata =3D sta->sdata;
> >
> > diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> > index c425f4fb7c2e..beb79b04c287 100644
> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -3617,6 +3617,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee8=
0211_hw *hw,
> >       struct ieee80211_tx_data tx;
> >       ieee80211_tx_result r;
> >       struct ieee80211_vif *vif =3D txq->vif;
> > +     struct rate_control_ref *ref =3D NULL;
> >
> >       WARN_ON_ONCE(softirq_count() =3D=3D 0);
> >
> > @@ -3775,8 +3776,13 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee=
80211_hw *hw,
> >  encap_out:
> >       IEEE80211_SKB_CB(skb)->control.vif =3D vif;
> >
> > +     if (tx.sta && test_sta_flag(tx.sta, WLAN_STA_RATE_CONTROL))
> > +             ref =3D tx.sta->rate_ctrl;
> > +
> >       if (vif &&
> > -         wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_=
AQL)) {
> > +         ((!local->ops->get_expected_throughput &&
> > +          (!ref || !ref->ops->get_expected_throughput)) ||
> > +         wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_=
AQL))) {
> >               bool ampdu =3D txq->ac !=3D IEEE80211_AC_VO;
> >               u32 airtime;
> >
> > --
> > 2.37.1
>
