Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A70D5A12B6
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242789AbiHYNtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242785AbiHYNth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:49:37 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB10B69D8;
        Thu, 25 Aug 2022 06:49:32 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id z14-20020a7bc7ce000000b003a5db0388a8so2968511wmk.1;
        Thu, 25 Aug 2022 06:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:references:message-id:date:content-transfer-encoding
         :mime-version:to:from:subject:cc:from:to:cc;
        bh=4uAG3NKnOc0i5V7esuVnskMi7lCBXxtibT9mPDCEo+0=;
        b=ZBgzRNI1lz/gKw5TMxghidks+ji2IZPtcPnVpUe4Oen7YKsu7voD6rFXOAlK5KRoX0
         usAe/qtJGJ7MbGi3hiMIbsQvFVjCVNcYVNPhF/yxu7qVG/VXo9QTWa/yL6Oc2B22BdzW
         wMymH83Srdgojasoi7AgfsUB72a3Z6gwVXDf3HVn4blhvra+Dwc2IVne6q54GjzMzdXD
         RgYw5RpGYr3PFk4q2DPlNeyyUReTz41nJawhRg2ZhMMTqpw6WtDsf1zCGMw4e9wzEqWD
         qgRIK3Cr0WkW384smJ8p5BjVha4HVdPpvIeroXN1t2f3//+t2L31aiZ6epOq/Xcqo8Od
         x+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:message-id:date:content-transfer-encoding
         :mime-version:to:from:subject:cc:x-gm-message-state:from:to:cc;
        bh=4uAG3NKnOc0i5V7esuVnskMi7lCBXxtibT9mPDCEo+0=;
        b=bcakSLLtQP/0UQihXzjJLCvk7MxMwlBiVrOogD5OLCcSkQcJ/+MloHxFKOTxlVxw7F
         hs+QQQT+ALdyytOjNVlq9QqWZu/TMVZxkjtd8Q0vThX2BMDTWg+bzbjgqdeeutW28U/p
         suYkBKmjdce90dEZMfu9/XXs0yWy5OBZvsnfoSTLGe/S2KcigqJBMj2jpoe0OziAUA+4
         BMkkLH4RKqxFPX2tBYSSOg1p3KH1MvIExaaFRJpgaIsDKUlFaSJOYDwYiAy4bh0WD6TP
         4wJG6zFLq0JFIo/GQO9181WsXEZAifjqMU9cf58cb4ovvWNZCtpj8YhHniTuoHMBv78p
         Stvg==
X-Gm-Message-State: ACgBeo23FjY9rNUicf6aIySneO8yn5Wy9qg5MBDfUp8Q+qhZAF/2/8/V
        7qWh4msEfZc1NLqZH6IqXB0=
X-Google-Smtp-Source: AA6agR7WPihDTEFLe+tmDbAbaI0Vpbo1xrcMsB2jo649JsXwIkiC3XqANLjy0/dN1uTaPwJ1K0X98A==
X-Received: by 2002:a05:600c:25ce:b0:3a5:a3b7:bbfe with SMTP id 14-20020a05600c25ce00b003a5a3b7bbfemr8692940wml.115.1661435371278;
        Thu, 25 Aug 2022 06:49:31 -0700 (PDT)
Received: from localhost (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id b18-20020adff252000000b00224f605f39dsm19338050wrp.76.2022.08.25.06.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 06:49:31 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Felix Fietkau" <nbd@nbd.name>,
        "Toke Hoiland-Jorgensen" <toke@redhat.com>,
        "Linus Lussing" <linus.luessing@c0d3.blue>,
        "Kalle Valo" <kvalo@kernel.org>
Subject: Re: [RFC/RFT v5 2/4] mac80211: add periodic monitor for channel
 busy time
From:   "Nicolas Escande" <nico.escande@gmail.com>
To:     "Baligh Gasmi" <gasmibal@gmail.com>,
        "Johannes Berg" <johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 25 Aug 2022 15:35:13 +0200
Message-Id: <CMF5DQR5IOKQ.1AHXQ8IDOC7IT@syracuse>
X-Mailer: aerc 0.11.0
References: <20220719123525.3448926-1-gasmibal@gmail.com>
 <20220719123525.3448926-3-gasmibal@gmail.com>
In-Reply-To: <20220719123525.3448926-3-gasmibal@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue Jul 19, 2022 at 2:35 PM CEST, Baligh Gasmi wrote:
> Add a worker scheduled periodicaly to calculate the busy time average of
> the current channel.
>
> This will be used in the estimation for expected throughput.
>
> Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
> ---
>  net/mac80211/ieee80211_i.h |  6 ++++
>  net/mac80211/iface.c       | 65 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 71 insertions(+)
>
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 86ef0a46a68c..2cb388335ce8 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -901,6 +901,7 @@ struct ieee80211_if_nan {
>  	struct idr function_inst_ids;
>  };
>
> +DECLARE_EWMA(avg_busy, 8, 4)
>  struct ieee80211_sub_if_data {
>  	struct list_head list;
>
> @@ -1024,6 +1025,11 @@ struct ieee80211_sub_if_data {
>  	} debugfs;
>  #endif
>
> +	struct delayed_work monitor_work;
> +	u64 last_time;
> +	u64 last_time_busy;
> +	struct ewma_avg_busy avg_busy;
> +
>  	/* must be last, dynamically sized area in this! */
>  	struct ieee80211_vif vif;
>  };
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 15a73b7fdd75..e1b20964933c 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -1972,6 +1972,64 @@ static void ieee80211_assign_perm_addr(struct ieee=
80211_local *local,
>  	mutex_unlock(&local->iflist_mtx);
>  }
>
> +#define DEFAULT_MONITOR_INTERVAL_MS 1000
> +
> +static void ieee80211_if_monitor_work(struct work_struct *work)
> +{
> +	struct delayed_work *delayed_work =3D to_delayed_work(work);
> +	struct ieee80211_sub_if_data *sdata > +		container_of(delayed_work, str=
uct ieee80211_sub_if_data,
> +				monitor_work);
> +	struct survey_info survey;
> +	struct ieee80211_local *local =3D sdata->local;
> +	struct ieee80211_chanctx_conf *chanctx_conf;
> +	struct ieee80211_channel *channel =3D NULL;
> +	int q =3D 0;
> +	u64 interval =3D DEFAULT_MONITOR_INTERVAL_MS;
> +
> +	rcu_read_lock();
> +	chanctx_conf =3D rcu_dereference(sdata->vif.chanctx_conf);
> +	if (chanctx_conf)
> +		channel =3D chanctx_conf->def.chan;
> +	rcu_read_unlock();
> +
> +	if (!channel)
> +		goto end;
> +
> +	if (!local->started)
> +		goto end;
> +
> +	do {
> +		survey.filled =3D 0;
> +		if (drv_get_survey(local, q++, &survey) !=3D 0) {
> +			survey.filled =3D 0;
> +			break;
> +		}
> +	} while (channel !=3D survey.channel);
> +
> +	if (survey.filled & SURVEY_INFO_TIME) {
> +		/* real interval */
> +		interval =3D survey.time - sdata->last_time;
> +		/* store last time */
> +		sdata->last_time =3D survey.time;
> +	}
> +
> +	if (survey.filled & SURVEY_INFO_TIME_BUSY) {
> +		/* busy */
> +		u64 busy =3D survey.time_busy < sdata->last_time_busy ? 0 :
> +			survey.time_busy - sdata->last_time_busy;
> +		/* average percent busy time */
> +		ewma_avg_busy_add(&sdata->avg_busy,
> +				(busy * 100) / interval);
This could use a div_u64()
> +		/* store last busy time */
> +		sdata->last_time_busy =3D survey.time_busy;
> +	}
> +
> +end:
> +	schedule_delayed_work(&sdata->monitor_work,
> +			msecs_to_jiffies(DEFAULT_MONITOR_INTERVAL_MS));
> +}
> +
>  int ieee80211_if_add(struct ieee80211_local *local, const char *name,
>  		     unsigned char name_assign_type,
>  		     struct wireless_dev **new_wdev, enum nl80211_iftype type,
> @@ -2085,6 +2143,8 @@ int ieee80211_if_add(struct ieee80211_local *local,=
 const char *name,
>  			  ieee80211_dfs_cac_timer_work);
>  	INIT_DELAYED_WORK(&sdata->dec_tailroom_needed_wk,
>  			  ieee80211_delayed_tailroom_dec);
> +	INIT_DELAYED_WORK(&sdata->monitor_work,
> +			ieee80211_if_monitor_work);
>
>  	for (i =3D 0; i < NUM_NL80211_BANDS; i++) {
>  		struct ieee80211_supported_band *sband;
> @@ -2156,6 +2216,9 @@ int ieee80211_if_add(struct ieee80211_local *local,=
 const char *name,
>  	list_add_tail_rcu(&sdata->list, &local->interfaces);
>  	mutex_unlock(&local->iflist_mtx);
>
> +	schedule_delayed_work(&sdata->monitor_work,
> +			msecs_to_jiffies(DEFAULT_MONITOR_INTERVAL_MS));
> +
>  	if (new_wdev)
>  		*new_wdev =3D &sdata->wdev;
>
> @@ -2166,6 +2229,8 @@ void ieee80211_if_remove(struct ieee80211_sub_if_da=
ta *sdata)
>  {
>  	ASSERT_RTNL();
>
> +	cancel_delayed_work_sync(&sdata->monitor_work);
> +
>  	mutex_lock(&sdata->local->iflist_mtx);
>  	list_del_rcu(&sdata->list);
>  	mutex_unlock(&sdata->local->iflist_mtx);
> --
> 2.37.1

