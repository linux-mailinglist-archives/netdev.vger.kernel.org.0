Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C624AFF79
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiBIVwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:52:02 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbiBIVwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:52:00 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BBBDF498A4
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:52:02 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p15so10827732ejc.7
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 13:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RZ84TpOHexbTMnfVb02UAjOHGkMGSzUm5IbMzEHywhs=;
        b=Yngp9nolKlgTKdaDzf6CJbyRUPDr0kChoh0km0udJ+FBsTC4ro570A1nHI6IHUgWzY
         ggGUpPHmLqZgN9+C+y7J0OIM6G4kbyKknzxxfdx+VVHrkPwRVKaF2WHByxRKXnBQu9vF
         5pKD0/rcwWs2qWmXGgtGRQca3nmuNBVetvB/MMvG/CtoFrtyILFWBJkarxGKo8xOxn5U
         v4OHXKxaXFYD9XGgrJ98T6YQ12+pxgJ5y8Sd4nZFTdGwlOJ0j5m54mGdsMQQh2MqOISg
         A5FEQSV+p6EjAgU4MKC3euAudjsFrgSPQxSr+bSE0vWsPS58nrA3PINLesDsMNaUUG1R
         g8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RZ84TpOHexbTMnfVb02UAjOHGkMGSzUm5IbMzEHywhs=;
        b=W86oQ2UsGQvlGl2m1TqLShokUfRj6ziocV7KwNCNrUm8KGPXv2o7M7X3BR1cn1sTwj
         OnlT+4hX9/JFPLs5Mq6zQuMei57xyJ8lJAzWy2+ZtNswWJVLjy9GAvmhFBhlmiMm+Wbi
         PZEsohdxhlhrEWbKvOk55yTWWF5qdtDco6DII35W4+dMH6toK8GbzlSul/PYFj3enRvF
         2qlIu4lPzNBvSEmnJuG4f6FD0SZuCVJbXCQXa0V5OFBUc9apIqmr+46N/banRVcdFvBJ
         zGS8Ww6Wr0Rn8RGhfkcy9QiE0eNr2tTo8nZb3Km59RF9y8K118XfjgMqAzicJwspnpff
         Ph0Q==
X-Gm-Message-State: AOAM530MEBIG42S8y4zwD4YMsLbkd/y4E61FaTiCeHk9UyCoI7xtzhWF
        Bj78iVLtG3FU/iPy2f6V+sy/MCVZ3fs=
X-Google-Smtp-Source: ABdhPJzX90kAbKgdk7lZZcd7HgbmlPsWhJYOvaiNw9IZplS08KQWdAq1Yr/obyb1wPu+doqfpHlHFA==
X-Received: by 2002:a17:907:1c97:: with SMTP id nb23mr3803834ejc.92.1644443520387;
        Wed, 09 Feb 2022 13:52:00 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id q5sm5631438eds.82.2022.02.09.13.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 13:51:59 -0800 (PST)
Date:   Wed, 9 Feb 2022 23:51:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
Subject: Re: [PATCH net-next 1/2] net: dsa: tag_rtl8_4: add rtl8_4t tailing
 variant
Message-ID: <20220209215158.qdjg7ko4epylwuv7@skbuf>
References: <20220209211312.7242-1-luizluca@gmail.com>
 <20220209211312.7242-2-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209211312.7242-2-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re: title. Tail or trailing?

On Wed, Feb 09, 2022 at 06:13:11PM -0300, Luiz Angelo Daros de Luca wrote:
> +static inline void rtl8_4_write_tag(struct sk_buff *skb, struct net_device *dev,
> +				    char *tag)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
> -	__be16 *tag;
> -
> -	skb_push(skb, RTL8_4_TAG_LEN);
> -
> -	dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
> -	tag = dsa_etype_header_pos_tx(skb);
> +	__be16 *tag16 = (__be16 *)tag;

Can the tail tag be aligned to an odd offset? In that case, should you
access byte by byte, maybe? I'm not sure how arches handle this.

>  
>  	/* Set Realtek EtherType */
> -	tag[0] = htons(ETH_P_REALTEK);
> +	tag16[0] = htons(ETH_P_REALTEK);
>  
>  	/* Set Protocol; zero REASON */
> -	tag[1] = htons(FIELD_PREP(RTL8_4_PROTOCOL, RTL8_4_PROTOCOL_RTL8365MB));
> +	tag16[1] = htons(FIELD_PREP(RTL8_4_PROTOCOL, RTL8_4_PROTOCOL_RTL8365MB));
>  
>  	/* Zero FID_EN, FID, PRI_EN, PRI, KEEP; set LEARN_DIS */
> -	tag[2] = htons(FIELD_PREP(RTL8_4_LEARN_DIS, 1));
> +	tag16[2] = htons(FIELD_PREP(RTL8_4_LEARN_DIS, 1));
>  
>  	/* Zero ALLOW; set RX (CPU->switch) forwarding port mask */
> -	tag[3] = htons(FIELD_PREP(RTL8_4_RX, BIT(dp->index)));
> +	tag16[3] = htons(FIELD_PREP(RTL8_4_RX, BIT(dp->index)));
> +}
> +
> +static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
> +				       struct net_device *dev)
> +{
> +	skb_push(skb, RTL8_4_TAG_LEN);
> +
> +	dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
> +
> +	rtl8_4_write_tag(skb, dev, dsa_etype_header_pos_tx(skb));
>  
>  	return skb;
>  }
>  
> -static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
> -				      struct net_device *dev)
> +static struct sk_buff *rtl8_4t_tag_xmit(struct sk_buff *skb,
> +					struct net_device *dev)
> +{

Why don't you want to add:

	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
		return NULL;

and then you'll make this tagging protocol useful in production too.

> +	rtl8_4_write_tag(skb, dev, skb_put(skb, RTL8_4_TAG_LEN));
> +
> +	return skb;
> +}
