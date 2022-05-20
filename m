Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4226F52F1B3
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 19:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352272AbiETRdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 13:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352276AbiETRdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 13:33:02 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D12188E44;
        Fri, 20 May 2022 10:33:01 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-e656032735so11138784fac.0;
        Fri, 20 May 2022 10:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nAroVrprxPAiSacmU0iQvRbZSqh545c+ucLFUrq47yQ=;
        b=Kgk5ilOpL68lRSqNvTkTo2Y62AAxjJGXA56jd9LIh3gtL4RVF6uIuMcg+IzyScA5h7
         TZ8WLoZHdIkwSYxURy3V/cWLG50OQpD3343DaZWiux9aCMiZrgy+0/ZTmNOHGwd7LK0v
         2jodiIlnQbpy/UlJ7LfR7ebcNHn1xWursmVXQU91u9YyvDD/kCpHc4rlIi5Vyev2XcTD
         F1ZXVVQv2K+ZW5xfpPWtxN7GfUcvz6AjSuNHGlE/OvMFSt/Cm9nv+bgxxdCpcWgQ3nuX
         5psF7c7ZXyRsVzJ2wsNgts6fMUD604qA2ts4BJbbZAfn3kH/EXKmIo2lkHCFgNirDGuV
         PCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nAroVrprxPAiSacmU0iQvRbZSqh545c+ucLFUrq47yQ=;
        b=mU/YvZz0dHw2TZOhSu8Aj0SDfZq5RCDjsZBTx+McwiFuQvd2HsFL/a13xZaTl3e3Gu
         ihuVncjlrp9011H+u9ht/enOW8RGjKmBG1bSPGdhtRrmBTtxP+rcVKn9D5VHjqMVojhL
         haYGuFp9tMKz/emjK9CA9cCygcnnkshpMsB+xyMiOKPoT/AMrTFLSY4LjcXGAVTPXqil
         1TuImB67CZJIIU7UUe90ET8LHdXFTVKl4L47LEfTexzgeqpj4NEPv2ZnTqRYwoOGjag9
         PuuKq2Vc08egKIn3UiouwJBwKmLz32MMGhRGPJN0Wk2H8sVrQ/q17HBBd5lUpTpav1Mu
         8Z6w==
X-Gm-Message-State: AOAM531V3liWMnYBreRKO17/T6xd/aCZn63B7dAHTDSXroIwHz0RKKBf
        UfsIB+EamMlWFm1x58w/I4k=
X-Google-Smtp-Source: ABdhPJwBbVfuXwWV2LrtgSFuQI0FmmCV9V2OLGg2gMfoiPen8O9zrqtLUR4FCCTu230A2zv/zpt+zA==
X-Received: by 2002:a05:6870:40c4:b0:f1:a0cb:a46f with SMTP id l4-20020a05687040c400b000f1a0cba46fmr6105711oal.288.1653067980456;
        Fri, 20 May 2022 10:33:00 -0700 (PDT)
Received: from ?IPV6:2603:8090:2005:39b3::100e? (2603-8090-2005-39b3-0000-0000-0000-100e.res6.spectrum.com. [2603:8090:2005:39b3::100e])
        by smtp.gmail.com with ESMTPSA id ds6-20020a0568705b0600b000f1bad20cc9sm1168406oab.0.2022.05.20.10.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 10:32:59 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <f14f19de-d272-b95b-21f3-35bfd23a29d3@lwfinger.net>
Date:   Fri, 20 May 2022 12:32:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 05/10] rtw88: Do not access registers while atomic
Content-Language: en-US
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
 <20220518082318.3898514-6-s.hauer@pengutronix.de>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20220518082318.3898514-6-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/22 03:23, Sascha Hauer wrote:
> The driver uses ieee80211_iterate_active_interfaces_atomic()
> and ieee80211_iterate_stations_atomic() in several places and does
> register accesses in the iterators. This doesn't cope with upcoming
> USB support as registers can only be accessed non-atomically.
> 
> Split these into a two stage process: First use the atomic iterator
> functions to collect all active interfaces or stations on a list, then
> iterate over the list non-atomically and call the iterator on each
> entry.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Suggested-by: Pkshih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtw88/phy.c  |  6 +-
>   drivers/net/wireless/realtek/rtw88/ps.c   |  2 +-
>   drivers/net/wireless/realtek/rtw88/util.c | 92 +++++++++++++++++++++++
>   drivers/net/wireless/realtek/rtw88/util.h | 12 ++-
>   4 files changed, 105 insertions(+), 7 deletions(-)
> 

...

> diff --git a/drivers/net/wireless/realtek/rtw88/util.c b/drivers/net/wireless/realtek/rtw88/util.c
> index 2c515af214e76..db55dbd5c533e 100644
> --- a/drivers/net/wireless/realtek/rtw88/util.c
> +++ b/drivers/net/wireless/realtek/rtw88/util.c
> @@ -105,3 +105,95 @@ void rtw_desc_to_mcsrate(u16 rate, u8 *mcs, u8 *nss)
>   		*mcs = rate - DESC_RATEMCS0;
>   	}
>   }
> +
> +struct rtw_stas_entry {
> +	struct list_head list;
> +	struct ieee80211_sta *sta;
> +};
> +
> +struct rtw_iter_stas_data {
> +	struct rtw_dev *rtwdev;
> +	struct list_head list;
> +};
> +
> +void rtw_collect_sta_iter(void *data, struct ieee80211_sta *sta)
> +{
> +	struct rtw_iter_stas_data *iter_stas = data;
> +	struct rtw_stas_entry *stas_entry;
> +
> +	stas_entry = kmalloc(sizeof(*stas_entry), GFP_ATOMIC);
> +	if (!stas_entry)
> +		return;
> +
> +	stas_entry->sta = sta;
> +	list_add_tail(&stas_entry->list, &iter_stas->list);
> +}
> +
> +void rtw_iterate_stas(struct rtw_dev *rtwdev,
> +		      void (*iterator)(void *data,
> +				       struct ieee80211_sta *sta),
> +				       void *data)
> +{
> +	struct rtw_iter_stas_data iter_data;
> +	struct rtw_stas_entry *sta_entry, *tmp;
> +
> +	iter_data.rtwdev = rtwdev;
> +	INIT_LIST_HEAD(&iter_data.list);
> +
> +	ieee80211_iterate_stations_atomic(rtwdev->hw, rtw_collect_sta_iter,
> +					  &iter_data);
> +
> +	list_for_each_entry_safe(sta_entry, tmp, &iter_data.list,
> +				 list) {
> +		list_del_init(&sta_entry->list);
> +		iterator(data, sta_entry->sta);
> +		kfree(sta_entry);
> +	}
> +}
> +
> +struct rtw_vifs_entry {
> +	struct list_head list;
> +	struct ieee80211_vif *vif;
> +	u8 mac[ETH_ALEN];
> +};
> +
> +struct rtw_iter_vifs_data {
> +	struct rtw_dev *rtwdev;
> +	struct list_head list;
> +};
> +
> +void rtw_collect_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
> +{
> +	struct rtw_iter_vifs_data *iter_stas = data;
> +	struct rtw_vifs_entry *vifs_entry;
> +
> +	vifs_entry = kmalloc(sizeof(*vifs_entry), GFP_ATOMIC);
> +	if (!vifs_entry)
> +		return;
> +
> +	vifs_entry->vif = vif;
> +	ether_addr_copy(vifs_entry->mac, mac);
> +	list_add_tail(&vifs_entry->list, &iter_stas->list);
> +}
> +
> +void rtw_iterate_vifs(struct rtw_dev *rtwdev,
> +		      void (*iterator)(void *data, u8 *mac,
> +				       struct ieee80211_vif *vif),
> +		      void *data)
> +{
> +	struct rtw_iter_vifs_data iter_data;
> +	struct rtw_vifs_entry *vif_entry, *tmp;
> +
> +	iter_data.rtwdev = rtwdev;
> +	INIT_LIST_HEAD(&iter_data.list);
> +
> +	ieee80211_iterate_active_interfaces_atomic(rtwdev->hw,
> +			IEEE80211_IFACE_ITER_NORMAL, rtw_collect_vif_iter, &iter_data);
> +
> +	list_for_each_entry_safe(vif_entry, tmp, &iter_data.list,
> +				 list) {
> +		list_del_init(&vif_entry->list);
> +		iterator(data, vif_entry->mac, vif_entry->vif);
> +		kfree(vif_entry);
> +	}
> +}

Sasha,

Sparse shows the following warnings:

   CHECK   /home/finger/iwireless-next/drivers/net/wireless/realtek/rtw88/util.c
/home/finger/wireless-next/drivers/net/wireless/realtek/rtw88/util.c:119:6: 
warning: symbol 'rtw_collect_sta_iter' was not declared. Should it be static?
/home/finger/wireless-next/drivers/net/wireless/realtek/rtw88/util.c:165:6: 
warning: symbol 'rtw_collect_vif_iter' was not declared. Should it be static?

Larry
