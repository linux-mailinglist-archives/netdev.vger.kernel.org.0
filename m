Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFEBC5A12AE
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242700AbiHYNtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbiHYNtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:49:18 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56947B5A47;
        Thu, 25 Aug 2022 06:49:17 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u14so24694089wrq.9;
        Thu, 25 Aug 2022 06:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:references:message-id:date:content-transfer-encoding
         :mime-version:to:from:subject:cc:from:to:cc;
        bh=WPCuzAnadlF8Wne0s3IEnoZsdJC/bDxJQFxU3psjTgs=;
        b=FlzrknLGLaeo9haic8LHkTVXed//r/Uo1Mj7KNs51LotXqhLgM/Ilu3eDKHQqK9br8
         6Sddvm0nb/xLwiZFDnlQLuITzFEBpo8/GHwfL/M4SZ/kEr1FvLW8zxNdwpKcT3wqgL7p
         Mbp5VON84T1YqhX23l4HXBuMGSAPCjg9Qbz56Q8w6m8zfYc227zADS36fPcOkOXDDCAC
         s92gjUpEWDNp5jQR2tPmgIoc889z4aFNvLIdMJ3Ldut85qfr2yUe7XLSYhAjEbEiyi38
         5lVbz/rYIA5a+rwTlPpHsvfwoVMifIDK0sa+4r+VIX/N4iFm9nplkZkquiPUsL6E1i3K
         o0tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:message-id:date:content-transfer-encoding
         :mime-version:to:from:subject:cc:x-gm-message-state:from:to:cc;
        bh=WPCuzAnadlF8Wne0s3IEnoZsdJC/bDxJQFxU3psjTgs=;
        b=iML32XsYisAACYB30kdLN3JzuUcARtG0bHz9Dh1RuDN07kItFuJAOUHfNupIGPNFc1
         rGFoudBuv/9HhirorKdENHZecFoD1cNHvtmPPL0M/v0nALUIMgLR8QU6h5oLfiF7NPJk
         9xEp+veewFcbLe/s+JxjmkHzGylqnCfEUm5d20KRw4AGOmLtEO65HCcP4nWGw9D2HAYP
         Q7nGzXZL5Hhlx1OluE/xcgOE5jmM4WanPUew1ST6f3MypKPJ8WsEeW4hCl8VVs0wONlg
         AWDuJDpcTlzZIDKId+Eefwl0sWMmtax7zhvutLm++ZwIfPlygPXOCZLKnJ6wV7uqgdy9
         o6PA==
X-Gm-Message-State: ACgBeo0adF3XlicxLTerSEBSVtNit1sT5WNLU+wWZKz8dbEUh3kkSHOy
        eziQW/Zrvhd3KCfPc1AttGE=
X-Google-Smtp-Source: AA6agR7kjY0ltpAQVeo1IG40uFqkihwFv8LQMkodTNb2FD6raSMp1Eq8kIiXtR3mIHx1AJFokJrDcw==
X-Received: by 2002:a5d:58ca:0:b0:225:24a8:8861 with SMTP id o10-20020a5d58ca000000b0022524a88861mr2440759wrf.316.1661435355789;
        Thu, 25 Aug 2022 06:49:15 -0700 (PDT)
Received: from localhost (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id n7-20020a5d4207000000b002253fd19a6asm19648458wrq.18.2022.08.25.06.49.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 06:49:14 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Felix Fietkau" <nbd@nbd.name>,
        "Toke Hoiland-Jorgensen" <toke@redhat.com>,
        "Linus Lussing" <linus.luessing@c0d3.blue>,
        "Kalle Valo" <kvalo@kernel.org>,
        "kernel test robot" <lkp@intel.com>
Subject: Re: [RFC/RFT v5 1/4] mac80211: use AQL airtime for expected
 throughput.
From:   "Nicolas Escande" <nico.escande@gmail.com>
To:     "Baligh Gasmi" <gasmibal@gmail.com>,
        "Johannes Berg" <johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 25 Aug 2022 15:31:40 +0200
Message-Id: <CMF5B109JKDQ.R3G4GDYBLZT6@syracuse>
X-Mailer: aerc 0.11.0
References: <20220719123525.3448926-1-gasmibal@gmail.com>
 <20220719123525.3448926-2-gasmibal@gmail.com>
In-Reply-To: <20220719123525.3448926-2-gasmibal@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Baligh,

On Tue Jul 19, 2022 at 2:35 PM CEST, Baligh Gasmi wrote:
> Since the integration of AQL, packet TX airtime estimation is
> calculated and counted to be used for the dequeue limit.
>
> Use this estimated airtime to compute expected throughput for
> each station.
>
> It will be a generic mac80211 implementation. that can be used if the
> driver do not have get_expected_throughput implementation.
>
> Useful for L2 routing protocols, like B.A.T.M.A.N.
>
> Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
> Reported-by: kernel test robot <lkp@intel.com>
> CC: Felix Fietkau <nbd@nbd.name>
> ---
>  net/mac80211/driver-ops.h |  2 ++
>  net/mac80211/sta_info.c   | 39 +++++++++++++++++++++++++++++++++++++++
>  net/mac80211/sta_info.h   | 11 +++++++++++
>  net/mac80211/status.c     |  2 ++
>  net/mac80211/tx.c         |  8 +++++++-
>  5 files changed, 61 insertions(+), 1 deletion(-)
>
> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> index 4e2fc1a08681..fa9952154795 100644
> --- a/net/mac80211/driver-ops.h
> +++ b/net/mac80211/driver-ops.h
> @@ -1142,6 +1142,8 @@ static inline u32 drv_get_expected_throughput(struc=
t ieee80211_local *local,
>  	trace_drv_get_expected_throughput(&sta->sta);
>  	if (local->ops->get_expected_throughput && sta->uploaded)
>  		ret =3D local->ops->get_expected_throughput(&local->hw, &sta->sta);
> +	else
> +		ret =3D ewma_avg_est_tp_read(&sta->deflink.status_stats.avg_est_tp);
>  	trace_drv_return_u32(local, ret);
>
>  	return ret;
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index e04a0905e941..201aab465234 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -1993,6 +1993,45 @@ void ieee80211_sta_update_pending_airtime(struct i=
eee80211_local *local,
>  			       tx_pending, 0);
>  }
>
> +void ieee80211_sta_update_tp(struct ieee80211_local *local,
> +			     struct sta_info *sta,
> +			     struct sk_buff *skb,
> +			     u16 tx_time_est,
> +			     bool ack, int retry)
> +{
> +	unsigned long diff;
> +	struct rate_control_ref *ref =3D NULL;
> +
> +	if (!skb || !sta || !tx_time_est)
> +		return;
> +
> +	if (test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
> +		ref =3D sta->rate_ctrl;
> +
> +	if (ref && ref->ops->get_expected_throughput)
> +		return;
> +
> +	if (local->ops->get_expected_throughput)
> +		return;
> +
> +	tx_time_est +=3D ack ? 4 : 0;
> +	tx_time_est +=3D retry ? retry * 2 : 2;
> +
> +	sta->deflink.tx_stats.tp_tx_size +=3D (skb->len * 8) * 1000;
> +	sta->deflink.tx_stats.tp_tx_time_est +=3D tx_time_est;
> +
> +	diff =3D jiffies - sta->deflink.status_stats.last_tp_update;
> +	if (diff > HZ / 10) {
> +		ewma_avg_est_tp_add(&sta->deflink.status_stats.avg_est_tp,
> +				    sta->deflink.tx_stats.tp_tx_size /
> +				    sta->deflink.tx_stats.tp_tx_time_est);
This needs a div_u64(), the arch may not have native 64 bits div support
> +
> +		sta->deflink.tx_stats.tp_tx_size =3D 0;
> +		sta->deflink.tx_stats.tp_tx_time_est =3D 0;
> +		sta->deflink.status_stats.last_tp_update =3D jiffies;
> +	}
> +}
> +
>  int sta_info_move_state(struct sta_info *sta,
>  			enum ieee80211_sta_state new_state)
>  {
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 35c390bedfba..4200856fefcd 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -123,6 +123,7 @@ enum ieee80211_sta_info_flags {
>  #define HT_AGG_STATE_STOP_CB		7
>  #define HT_AGG_STATE_SENT_ADDBA		8
>
> +DECLARE_EWMA(avg_est_tp, 8, 16)
>  DECLARE_EWMA(avg_signal, 10, 8)
>  enum ieee80211_agg_stop_reason {
>  	AGG_STOP_DECLINED,
> @@ -157,6 +158,12 @@ void ieee80211_register_airtime(struct ieee80211_txq=
 *txq,
>
>  struct sta_info;
>
> +void ieee80211_sta_update_tp(struct ieee80211_local *local,
> +			     struct sta_info *sta,
> +			     struct sk_buff *skb,
> +			     u16 tx_time_est,
> +			     bool ack, int retry);
> +
>  /**
>   * struct tid_ampdu_tx - TID aggregation information (Tx).
>   *
> @@ -549,6 +556,8 @@ struct link_sta_info {
>  		s8 last_ack_signal;
>  		bool ack_signal_filled;
>  		struct ewma_avg_signal avg_ack_signal;
> +		struct ewma_avg_est_tp avg_est_tp;
> +		unsigned long last_tp_update;
>  	} status_stats;
>
>  	/* Updated from TX path only, no locking requirements */
> @@ -558,6 +567,8 @@ struct link_sta_info {
>  		struct ieee80211_tx_rate last_rate;
>  		struct rate_info last_rate_info;
>  		u64 msdu[IEEE80211_NUM_TIDS + 1];
> +		u64 tp_tx_size;
> +		u64 tp_tx_time_est;
>  	} tx_stats;
>
>  	enum ieee80211_sta_rx_bandwidth cur_max_bandwidth;
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index e69272139437..1fb93abc1709 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -1152,6 +1152,8 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *h=
w,
>  	ack_signal_valid >  		!!(info->status.flags & IEEE80211_TX_STATUS_ACK_S=
IGNAL_VALID);
>
> +	ieee80211_sta_update_tp(local, sta, skb, tx_time_est, acked, retry_coun=
t);
> +
>  	if (pubsta) {
>  		struct ieee80211_sub_if_data *sdata =3D sta->sdata;
>
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index c425f4fb7c2e..beb79b04c287 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -3617,6 +3617,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee802=
11_hw *hw,
>  	struct ieee80211_tx_data tx;
>  	ieee80211_tx_result r;
>  	struct ieee80211_vif *vif =3D txq->vif;
> +	struct rate_control_ref *ref =3D NULL;
>
>  	WARN_ON_ONCE(softirq_count() =3D=3D 0);
>
> @@ -3775,8 +3776,13 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80=
211_hw *hw,
>  encap_out:
>  	IEEE80211_SKB_CB(skb)->control.vif =3D vif;
>
> +	if (tx.sta && test_sta_flag(tx.sta, WLAN_STA_RATE_CONTROL))
> +		ref =3D tx.sta->rate_ctrl;
> +
>  	if (vif &&
> -	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL)) =
{
> +	    ((!local->ops->get_expected_throughput &&
> +	     (!ref || !ref->ops->get_expected_throughput)) ||
> +	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL)))=
 {
>  		bool ampdu =3D txq->ac !=3D IEEE80211_AC_VO;
>  		u32 airtime;
>
> --
> 2.37.1

