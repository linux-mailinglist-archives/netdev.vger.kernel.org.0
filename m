Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B143A482D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 19:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhFKR5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 13:57:51 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:45845 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhFKR5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 13:57:50 -0400
Received: by mail-ed1-f51.google.com with SMTP id r7so23676878edv.12
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 10:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DuwjVu2ah8R74VEunsWVfDwhHMrlU5qQzdUQ6C052p4=;
        b=aEIc9uZwe+u9+svEykjNBa6wj8i514+l/hkd6EuCzc8CM9yYfATHUKIjl51aNACgMC
         ksCox/b9uWsZEoXL09PdpyRopHgsbzTmMj+lniYnOsJrkKJ51n4UXW70Gog3ZKkkh24f
         akOu/j5U0fbnuxa4P2IInNkEA2vXY/Ub6BX9MlyUPCaUvzWwUy80Ks13JK/reShiN8KG
         58CyX1xEy/SrVJLjo3YLZQKS5l1oBHYTpQ+DJh23nQgCijXsK4V1qMVCjV8eKEW/jHIM
         wBF7ja1FLRZDRkcG48NkzSpyvsjTCzgkmhaFV0r7tNLacANFAcsfVzL1pQnnCAkyXkVY
         78yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DuwjVu2ah8R74VEunsWVfDwhHMrlU5qQzdUQ6C052p4=;
        b=JeMazJDmxOS1oHEEqq0x3Tr3/V14p2JkAJzi40oKJ1Z3htQNfJ1H3vUTOlN+XHUx3t
         KbTmQf06qN7g4mBXmyT3czYCdZZ7DYJRduJFIc5Na/lRA2joQABTisVPOXqHvy4JpOxn
         KJdTxDgHRMirgWn59/zfx4h82qdiZkDsWhrql9G6GZJCPZVIcsQ2JoLQ4QMtxdlsQeg4
         uGHRgCAQrCgiNmBP2VhIqiFqIv15J3u7J25D8+ubXBQtu183T6afSy9snzqgCXKNZgAP
         G7i27F6d/cR3CR7IdTh7sRSmclRtfkYxQXqQTRnLhxzUxHgEceQULmj9FN6EXSU7WpDO
         792w==
X-Gm-Message-State: AOAM531xfZblqyEeb9KyWl1TQi5yteMwqm/M1cyRdH1D6SFUQdbu6zwn
        4sBZjjS9nvGXZswd49PqpuC6AQ==
X-Google-Smtp-Source: ABdhPJzX0K7xMLtbbSp/J2M82Ugtlqu5gL7Kezy/X6FaNm1QAbvBPQibDqxe4EXb3WZcU3YDvUH/0A==
X-Received: by 2002:a50:9345:: with SMTP id n5mr5010249eda.289.1623434091734;
        Fri, 11 Jun 2021 10:54:51 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id h8sm2351459ejj.22.2021.06.11.10.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 10:54:51 -0700 (PDT)
Date:   Fri, 11 Jun 2021 19:54:49 +0200
From:   Ben Hutchings <ben.hutchings@essensium.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-omap@vger.kernel.org, Lokesh Vutla <lokeshvutla@ti.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH net] net: ethernet: ti: cpsw: fix min eth packet size for
 non-switch use-cases
Message-ID: <20210611175448.GA25728@cephalopod>
References: <20210611132732.10690-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611132732.10690-1-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 04:27:32PM +0300, Grygorii Strashko wrote:
[...]
> --- a/drivers/net/ethernet/ti/cpsw_new.c
> +++ b/drivers/net/ethernet/ti/cpsw_new.c
> @@ -918,14 +918,17 @@ static netdev_tx_t cpsw_ndo_start_xmit(struct sk_buff *skb,
>  	struct cpts *cpts = cpsw->cpts;
>  	struct netdev_queue *txq;
>  	struct cpdma_chan *txch;
> +	unsigned int len;
>  	int ret, q_idx;
>  
> -	if (skb_padto(skb, CPSW_MIN_PACKET_SIZE)) {
> +	if (skb_padto(skb, priv->tx_packet_min)) {
>  		cpsw_err(priv, tx_err, "packet pad failed\n");
>  		ndev->stats.tx_dropped++;
>  		return NET_XMIT_DROP;
>  	}
>  
> +	len = skb->len < priv->tx_packet_min ? priv->tx_packet_min : skb->len;
> +
>  	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
>  	    priv->tx_ts_enabled && cpts_can_timestamp(cpts, skb))
>  		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> @@ -937,7 +940,7 @@ static netdev_tx_t cpsw_ndo_start_xmit(struct sk_buff *skb,
>  	txch = cpsw->txv[q_idx].ch;
>  	txq = netdev_get_tx_queue(ndev, q_idx);
>  	skb_tx_timestamp(skb);
> -	ret = cpdma_chan_submit(txch, skb, skb->data, skb->len,
> +	ret = cpdma_chan_submit(txch, skb, skb->data, len,
>  				priv->emac_port);
>  	if (unlikely(ret != 0)) {
>  		cpsw_err(priv, tx_err, "desc submit failed\n");

This change is odd because cpdma_chan_submit() already pads the DMA
length.

Would it not make more sense to update cpdma_params::min_packet_size
instead of adding a second minimum?

[...]
> @@ -1686,6 +1690,7 @@ static int cpsw_dl_switch_mode_set(struct devlink *dl, u32 id,
>  
>  			priv = netdev_priv(sl_ndev);
>  			slave->port_vlan = vlan;
> +			priv->tx_packet_min = CPSW_MIN_PACKET_SIZE_VLAN;
>  			if (netif_running(sl_ndev))
>  				cpsw_port_add_switch_def_ale_entries(priv,
>  								     slave);
> @@ -1714,6 +1719,7 @@ static int cpsw_dl_switch_mode_set(struct devlink *dl, u32 id,
>  
>  			priv = netdev_priv(slave->ndev);
>  			slave->port_vlan = slave->data->dual_emac_res_vlan;
> +			priv->tx_packet_min = CPSW_MIN_PACKET_SIZE;
>  			cpsw_port_add_dual_emac_def_ale_entries(priv, slave);
>  		}
>
[...]

What happens if this races with the TX path?  Should there be a
netif_tx_lock() / netif_tx_unlock() around this change?

Ben.
