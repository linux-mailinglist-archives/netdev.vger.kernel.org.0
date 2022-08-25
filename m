Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13445A12BB
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242805AbiHYNuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242802AbiHYNuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:50:01 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459FC4D26F;
        Thu, 25 Aug 2022 06:49:56 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l33-20020a05600c1d2100b003a645240a95so2561165wms.1;
        Thu, 25 Aug 2022 06:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:references:message-id:date:content-transfer-encoding
         :mime-version:to:from:subject:cc:from:to:cc;
        bh=yCz3oQJFqTwqovrPNYSJ6P9F0BIA6bLL58cK1Awy8hY=;
        b=ZvM8pw8sLdgOhDwhD3L3X2Xo+tUKO2zIu/Fh5YypqWrZbY9BQzjbeNy05SEZFhqmhF
         tejsgMntHg4uahyjwkiZw+eUpmI+GpFQLrra1lAt1FyGNiQWi6wPbgwyw2mm7t1lhBNE
         H1uyDZt7q4uM7U4nCGL0ErWtM79kUCIeHnUpyh89NyTR2hWnTluX09hPBb6JsNROWzHV
         aSf8CdZ32X+1HxkZb0ZouguH83iX1xRQxlVhyEosMcPOEIcR6cgdEilY0Y/PpM75Jj8T
         0ZtUfr1AGU5ezcPW2z7uZTErB7N5YoSILS3cA8TbiSKAEJBVZEo1mLwEYTbEEOKbyoiE
         ip4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:message-id:date:content-transfer-encoding
         :mime-version:to:from:subject:cc:x-gm-message-state:from:to:cc;
        bh=yCz3oQJFqTwqovrPNYSJ6P9F0BIA6bLL58cK1Awy8hY=;
        b=tsx6CIZJtnYkFZVtTixhkGcmz6T2+m2KNutZG3znxzqarIRYOp5yyFTxeRYPyUPApa
         yk72RP9hOe1qDZyXNbcvgTwvnEF2nB33XhyrUNxwhA5kL6eLcDRQFELihe68AB3AawnK
         gwGQ5P/7hQI9La3FwT0upeJ9b13vqFbW6BdojbahDWu87mbHhq/QeP7FFNTxKSIu/NHl
         79dFh7G9X8T0ZLHoXi94s0xG9P0O59+2+SPyYUc4WabHgsdP/LjwTjguNiv1S+g0RS/S
         Ng6eMAYzlh8wp/iw/0v6SheM2IHtKCtq4CW2pAM5YugTpjvoam8/98lb4EDSZHNwcBCp
         lARw==
X-Gm-Message-State: ACgBeo3pnJDXnQPW25Zhwxw+6jmqLzVhJKdop4LCK7mI0Msl1jbCd0MJ
        a4oJn8jA9VFpAypnqjzX08w=
X-Google-Smtp-Source: AA6agR7vn7Mg6lNsxvU/jEi0ZnXITi/xAhNlK2vPyJCKYaCSO6EVnNSc3FsatM3Rjn/+i8fYnNtO4A==
X-Received: by 2002:a05:600c:4fcd:b0:3a6:2694:e3ba with SMTP id o13-20020a05600c4fcd00b003a62694e3bamr2529473wmq.160.1661435395114;
        Thu, 25 Aug 2022 06:49:55 -0700 (PDT)
Received: from localhost (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id y11-20020a5d470b000000b0022584ab85a8sm1080964wrq.17.2022.08.25.06.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 06:49:54 -0700 (PDT)
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
Subject: Re: [RFC/RFT v5 3/4] mac80211: add busy time factor into expected
 throughput
From:   "Nicolas Escande" <nico.escande@gmail.com>
To:     "Baligh Gasmi" <gasmibal@gmail.com>,
        "Johannes Berg" <johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 25 Aug 2022 15:36:34 +0200
Message-Id: <CMF5ERVFCDM9.G96GZB43SEWO@syracuse>
X-Mailer: aerc 0.11.0
References: <20220719123525.3448926-1-gasmibal@gmail.com>
 <20220719123525.3448926-4-gasmibal@gmail.com>
In-Reply-To: <20220719123525.3448926-4-gasmibal@gmail.com>
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
> When estimating the expected throughput, take into account the busy time
> of the current channel.
>
> Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
> ---
>  net/mac80211/sta_info.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 201aab465234..7e32c06ae771 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -2000,6 +2000,8 @@ void ieee80211_sta_update_tp(struct ieee80211_local=
 *local,
>  			     bool ack, int retry)
>  {
>  	unsigned long diff;
> +	struct ieee80211_sub_if_data *sdata;
> +	u32 avg_busy;
>  	struct rate_control_ref *ref =3D NULL;
>
>  	if (!skb || !sta || !tx_time_est)
> @@ -2014,6 +2016,7 @@ void ieee80211_sta_update_tp(struct ieee80211_local=
 *local,
>  	if (local->ops->get_expected_throughput)
>  		return;
>
> +	sdata =3D sta->sdata;
>  	tx_time_est +=3D ack ? 4 : 0;
>  	tx_time_est +=3D retry ? retry * 2 : 2;
>
> @@ -2022,6 +2025,10 @@ void ieee80211_sta_update_tp(struct ieee80211_loca=
l *local,
>
>  	diff =3D jiffies - sta->deflink.status_stats.last_tp_update;
>  	if (diff > HZ / 10) {
> +		avg_busy =3D ewma_avg_busy_read(&sdata->avg_busy) >> 1;
> +		sta->deflink.tx_stats.tp_tx_time_est +> +			(sta->deflink.tx_stats.tp_=
tx_time_est * avg_busy) / 100;
Once again div_u64() ?
> +
>  		ewma_avg_est_tp_add(&sta->deflink.status_stats.avg_est_tp,
>  				    sta->deflink.tx_stats.tp_tx_size /
>  				    sta->deflink.tx_stats.tp_tx_time_est);
> --
> 2.37.1

