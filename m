Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325F32B16AD
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 08:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgKMHq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 02:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKMHq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 02:46:57 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EC3C0613D6;
        Thu, 12 Nov 2020 23:46:57 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id y4so3751242edy.5;
        Thu, 12 Nov 2020 23:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=xELIDlBC4XpvbVgvkhrHVs/RO1MGhH1tO135RI7QKSA=;
        b=eZDXofxm0CdO5iOJrsSaFzg8mQnKsQtQJu2M9Ku/pa+dVH0ozfoOpRJd2oM5mw1ql3
         ccZruHwc+IoXUUbO3G/0Q339qQcdFH+TGMvDcNkQJ08TcPo1pi4If2evMhwb8n6IW+cJ
         /B0qUB4VUYUUSFN8D/90myy3HNnBrQlPxeWTHxK0IUo1Gb8wgFVSP4ye50kZTGhZZdhY
         6KWkyCteQ+a8nGJJUnyKh9ZYSUNMRqkqWathcf32+xFLqt53ILPoe9NdhqShCcOzM6oT
         zKlMBusmCqTpYAaaz9QWsL7Hwghg05OcJvU1YtSmTnZJHVrjmayNN0RDz+stgVTG4cRS
         SZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=xELIDlBC4XpvbVgvkhrHVs/RO1MGhH1tO135RI7QKSA=;
        b=O9wEEetk0mbjCthOifBGCR3djBEO9TNrBcRVjPa6jVzA4XtCAzlig3unq5uUs36u+M
         iNiRQ9hxlgSk2OtNumIW+Uix50X36mK1FovTJL1jY2Wvodu8byZD4yeniiaCM9EcCwzH
         1WK/zyXS2xwosQQwSRKXI2YgPvlzDJXkJAeBtOGKm59KV8HmygovYV7UsIQZ1lUFkpcQ
         PlK2R8yHcICyu68LEqE+WZodYXiiSgMdE30X+plDPMMEIJ/jH93uP26T2ImpcBeR6NeE
         L2EJAq42vz5KhgMKeQAov6MQAz2894uamSDSHvQFSlN+5YrsDA6EDdlZyNPd77SoSzA4
         UUNQ==
X-Gm-Message-State: AOAM531E5uIiFp5FytVbZpQeHQAvKvLL7cexv8qSru1bxhhP3GSoo4D4
        3LzVq3a92m/2juFHYcEQD1ARyo6gybOlmw==
X-Google-Smtp-Source: ABdhPJwzk5ATnWjy354Emnsiox6X34uHFtzvt0h+SRtPdzNZ5HEZWJbYcpCE8t2JhyDSJQo0avseTw==
X-Received: by 2002:aa7:d351:: with SMTP id m17mr1271632edr.215.1605253615966;
        Thu, 12 Nov 2020 23:46:55 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:e113:5d8d:7b96:ca98? (p200300ea8f232800e1135d8d7b96ca98.dip0.t-ipconnect.de. [2003:ea:8f23:2800:e113:5d8d:7b96:ca98])
        by smtp.googlemail.com with ESMTPSA id z23sm3042644ejb.4.2020.11.12.23.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 23:46:55 -0800 (PST)
Subject: Re: [PATCH 1/3] net: mac80211: use core API for updating TX stats
To:     Lev Stipakov <lstipakov@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Lev Stipakov <lev@openvpn.net>
References: <20201112110953.34055-1-lev@openvpn.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <44c8b5ae-3630-9d98-1ab4-5f57bfe0886c@gmail.com>
Date:   Fri, 13 Nov 2020 08:16:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201112110953.34055-1-lev@openvpn.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 12.11.2020 um 12:09 schrieb Lev Stipakov:
> Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add")
> has added function "dev_sw_netstats_tx_add()" to update
> net device per-cpu TX stats.
> 
> Use this function instead of ieee80211_tx_stats().
> 
I think you can do the same with ieee80211_rx_stats().

> Signed-off-by: Lev Stipakov <lev@openvpn.net>
> ---
>  net/mac80211/tx.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 5f05f4651dd7..7807f8178527 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -38,16 +38,6 @@
>  
>  /* misc utils */
>  
> -static inline void ieee80211_tx_stats(struct net_device *dev, u32 len)
> -{
> -	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
> -
> -	u64_stats_update_begin(&tstats->syncp);
> -	tstats->tx_packets++;
> -	tstats->tx_bytes += len;
> -	u64_stats_update_end(&tstats->syncp);
> -}
> -
>  static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
>  				 struct sk_buff *skb, int group_addr,
>  				 int next_frag_len)
> @@ -3403,7 +3393,7 @@ static void ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sdata,
>  	if (key)
>  		info->control.hw_key = &key->conf;
>  
> -	ieee80211_tx_stats(skb->dev, skb->len);
> +	dev_sw_netstats_tx_add(skb->dev, 1, skb->len);
>  
>  	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
>  		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
> @@ -4021,7 +4011,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
>  			goto out;
>  		}
>  
> -		ieee80211_tx_stats(dev, skb->len);
> +		dev_sw_netstats_tx_add(dev, 1, skb->len);
>  
>  		ieee80211_xmit(sdata, sta, skb);
>  	}
> @@ -4248,7 +4238,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
>  
>  	info->hw_queue = sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
>  
> -	ieee80211_tx_stats(dev, skb->len);
> +	dev_sw_netstats_tx_add(dev, 1, skb->len);
>  
>  	sta->tx_stats.bytes[skb_get_queue_mapping(skb)] += skb->len;
>  	sta->tx_stats.packets[skb_get_queue_mapping(skb)]++;
> 

