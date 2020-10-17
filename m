Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EF7290FD4
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 08:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436926AbgJQGBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 02:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436630AbgJQGBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 02:01:40 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0591C0604C0;
        Fri, 16 Oct 2020 19:36:02 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id p11so2220646pld.5;
        Fri, 16 Oct 2020 19:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XB376N0VueE3LFToRxxe5fvCbU7rR1aPZMq5nuWveWs=;
        b=PU3BfFUgUUqOiGuKQrRFJLMYgVdHZxIDG6EMw+4DNK19YLIHPpx3WGSNAdImYopbTF
         oIQi5hv81R0R9cm/UGWi6nHyaEEHtB2DQRphBq9Q4E1u4CVyn3FKmU0tKKDvEQfLGCZW
         W6IgnAM5aSHwI+fL2bSHxTxr2qZ0G9gVsRpomU+npmomuX0Dlo/wUvGgdpb5oelqwYp7
         AKC+eBCne0dtDAlFbCzUhdW+LAEJ9/MdRjgX5TEG02s+tQe4L5LG8oilJ6F+7Fwndad5
         3E580qnASrKOeVDBtsNSP33cUZI/cvt9q0R+a+sLG+4NEFl9b8LfsEFoV5picVKrEVnR
         KYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XB376N0VueE3LFToRxxe5fvCbU7rR1aPZMq5nuWveWs=;
        b=c7sv+OK3AGU275rSUG4w+m5Pv1QlgR0DoKXi0VQnlewrPj9G0sB9SyjG4rm7jxoX9u
         hReo2cdZUDHiILgbm6pfJy/xf6Me/Y1j6FfIwTgp9CySX5LWu0U8Z5cojjdlg1DYvj61
         HZclXx7/zta6ZMSJvMnbs3tkCNGCpt5LdGObbuNpcQdo2jPkwua+kjFXOAjUqEcP+EkL
         T9mCTkw2aWaWNn+D5HYzzoJWJ+1KoySnmofHIsuOUAXsP3y9lRjYZAWAmNWLO5wkYICz
         nF67i7L4M0ufhz8mjI2ApiraTHEYeLTG7964kHi58XmrK4LxVO1RxCKhUQl+cO2ydHfV
         aAng==
X-Gm-Message-State: AOAM530NBSvXrgDjcH1Eb3HwCmqNW+WYHN45Sf4P/eg25Mq5zOq+NbVZ
        vvIKVrh+GfvikPrrhnAP5SlzlB/pGKE=
X-Google-Smtp-Source: ABdhPJz2p06J0iBeEXmTgmjhqik/LJuk8vECmt8cMpCi1lGHWyK6z1ICeYLlXHc+bmEsFmDMYXI0QA==
X-Received: by 2002:a17:90b:3649:: with SMTP id nh9mr7026543pjb.123.1602902161747;
        Fri, 16 Oct 2020 19:36:01 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id r3sm4148271pfl.67.2020.10.16.19.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 19:36:00 -0700 (PDT)
To:     Christian Eggers <ceggers@arri.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201016200226.23994-1-ceggers@arri.de>
 <20201016200226.23994-2-ceggers@arri.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 1/3] net: dsa: don't pass cloned skb's to drivers
 xmit function
Message-ID: <3b14e77c-9307-356e-b1cf-d9e9e51716e5@gmail.com>
Date:   Fri, 16 Oct 2020 19:35:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201016200226.23994-2-ceggers@arri.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/16/2020 1:02 PM, Christian Eggers wrote:
> Ensure that the skb is not cloned and has enough tail room for the tail
> tag. This code will be removed from the drivers in the next commits.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---

[snip]

> +	/* We have to pad he packet to the minimum Ethernet frame size,
> +	 * if necessary, before adding the trailer (tail tagging only).
> +	 */
> +	padlen = (skb->len >= ETH_ZLEN) ? 0 : ETH_ZLEN - skb->len;
> +
> +	/* To keep the slave's xmit() methods simple, don't pass cloned skbs to
> +	 * them. Additionally ensure, that suitable room for tail tagging is
> +	 * available.
> +	 */
> +	if (skb_cloned(skb) ||
> +	    (p->tail_tag && skb_tailroom(skb) < (padlen + p->overhead))) {
> +		struct sk_buff *nskb;
> +
> +		nskb = alloc_skb(NET_IP_ALIGN + skb->len +
> +				 padlen + p->overhead, GFP_ATOMIC);
> +		if (!nskb) {
> +			kfree_skb(skb);
> +			return NETDEV_TX_OK;
> +		}
> +		skb_reserve(nskb, NET_IP_ALIGN);
> +
> +		skb_reset_mac_header(nskb);
> +		skb_set_network_header(nskb,
> +				       skb_network_header(skb) - skb->head);
> +		skb_set_transport_header(nskb,
> +					 skb_transport_header(skb) - skb->head);
> +		skb_copy_and_csum_dev(skb, skb_put(nskb, skb->len));
> +		consume_skb(skb);
> +
> +		if (padlen)
> +			skb_put_zero(nskb, padlen);
> +
> +		skb = nskb;
> +	}

Given the low number of tail taggers, maybe this should be a helper 
function that is used by them where applicable? If nothing else you may 
want to sprinkle unlikely() conditions to sort of hing the processor 
that these are unlikely conditions.
-- 
Florian
