Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F392CF411
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbgLDS2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbgLDS2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:28:39 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA60EC061A4F
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 10:27:58 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id h7so4149998pjk.1
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 10:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QwHOG8Frc7bzBTfXiWwmMwmYXFnsJN/XO1JxQW1NcUk=;
        b=sBiB+xvCLI9pUJGj2OxsbpHMTeGCA/0pcycPgfsO0JF5MSduZuxaMJeZn2WlZMCBAF
         EDmuXbXs1FJGIrNLa+Ohx/gyoLPEE/BrYQZu1PipfeMiQmg8rf5b33bu699AV3+SrSj+
         aEc2wUzg0xK16+ldwRrNLocZphiT+EhDVUzomOHEhdIgY+Y36Hi3FeDSz2ONU7Hh3hWL
         YmTtoprMgZ+A4QgLocFJNrNTm9Fp+LNBwdgUc9VN5W8x0CLIGTovReuRFNxMiRsPMyyP
         3fZG9ft4ORJzFSA2VVskWiba9Ya8tY5uieUqmMBVmfJD9vIhb0gLKpG3FUrRXL0YE4vC
         EZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QwHOG8Frc7bzBTfXiWwmMwmYXFnsJN/XO1JxQW1NcUk=;
        b=KHFblRiX74puLUmHEHYOs0zUwH/6FC9jj2Qxw/85SOcNnEYEkc36xxvj8jWNCfqlIw
         a3OqaenNZg1Fn5wM4fRa43ecLa8bKE6rc8qyCf/CMfXAMrlBNgTjHcmzgiQIeZK+4yc2
         eyxhSq+pPKCu+Xeel5M/l+t2LkWC6kSin/VSS6AvyUgqkD+e31DE+apryrjt6r8jQeGv
         tG1uI84HnGM0LdLURuxWg3dWhOLDF9E7PshTtF11ER/UWLObosC/PZ54Kul/CU4bFynm
         QfeHG5WiWCU3qaM8GOhztuJUMKXSKP/M0YmsLJrjs+iYHa2Fw/qQYvOMfOFT4GWBlTRR
         M8qg==
X-Gm-Message-State: AOAM530d0BcEv9WPDXXwdkHWWgMgLbiivJMjbiTXzeAsJJ7CqEN8AbH0
        HQL2Au5x78NbRbL6aFj1iMx66//yZ2U=
X-Google-Smtp-Source: ABdhPJxBAjjmYxVd0qBU7zVRarON80TNYkSTNrTMdfBrXxCHmmBfEk49pFsTF8oc/EP6ArFSRYIQKQ==
X-Received: by 2002:a17:90a:9f8e:: with SMTP id o14mr5311641pjp.89.1607106478046;
        Fri, 04 Dec 2020 10:27:58 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s30sm4606229pgl.39.2020.12.04.10.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 10:27:57 -0800 (PST)
Subject: Re: [PATCH net-next] bcm63xx_enet: add BQL support
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20201204054616.26876-1-liew.s.piaw@gmail.com>
 <20201204054616.26876-2-liew.s.piaw@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a5ccedca-a2c9-b0df-394c-0cc460923a09@gmail.com>
Date:   Fri, 4 Dec 2020 10:27:50 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204054616.26876-2-liew.s.piaw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/3/2020 9:46 PM, Sieng Piaw Liew wrote:
> Add Byte Queue Limits support to reduce/remove bufferbloat in
> bcm63xx_enet.
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> index b82b7805c36a..c1eba5fa3258 100644
> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> @@ -417,9 +417,11 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
>  static int bcm_enet_tx_reclaim(struct net_device *dev, int force)
>  {
>  	struct bcm_enet_priv *priv;
> +	unsigned int bytes;
>  	int released;
>  
>  	priv = netdev_priv(dev);
> +	bytes = 0;
>  	released = 0;
>  
>  	while (priv->tx_desc_count < priv->tx_ring_size) {
> @@ -456,10 +458,13 @@ static int bcm_enet_tx_reclaim(struct net_device *dev, int force)
>  		if (desc->len_stat & DMADESC_UNDER_MASK)
>  			dev->stats.tx_errors++;
>  
> +		bytes += skb->len;
>  		dev_kfree_skb(skb);
>  		released++;
>  	}
>  
> +	netdev_completed_queue(dev, released, bytes);
> +
>  	if (netif_queue_stopped(dev) && released)
>  		netif_wake_queue(dev);
>  
> @@ -626,6 +631,8 @@ bcm_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	desc->len_stat = len_stat;
>  	wmb();
>  
> +	netdev_sent_queue(dev, skb->len);
> +
>  	/* kick tx dma */
>  	enet_dmac_writel(priv, priv->dma_chan_en_mask,
>  				 ENETDMAC_CHANCFG, priv->tx_chan);
> @@ -1069,6 +1076,7 @@ static int bcm_enet_open(struct net_device *dev)
>  	else
>  		bcm_enet_adjust_link(dev);
>  
> +	netdev_reset_queue(dev);
>  	netif_start_queue(dev);
>  	return 0;
>  
> @@ -2246,6 +2254,7 @@ static int bcm_enetsw_open(struct net_device *dev)
>  			 ENETDMAC_IRMASK, priv->tx_chan);
>  
>  	netif_carrier_on(dev);
> +	netdev_reset_queue(dev);
>  	netif_start_queue(dev);

Doing netdev_reset_queue() in bcm_enetsw_stop() and bcm_enet_stop()
would feel more natural and be consistent with where the resources are
being shut down. With that fixed:

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
