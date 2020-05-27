Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE0C1E3AA6
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 09:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387572AbgE0Hb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 03:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387411AbgE0Hbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 03:31:55 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A729DC061A0F;
        Wed, 27 May 2020 00:31:55 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j21so11379542pgb.7;
        Wed, 27 May 2020 00:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dDm+9Z+VPJSjQt7jMvgBvDOrkZkCZvbOfUxGN5gTgvk=;
        b=S+SvSCvKaczRkh6E5rg4fK7H9JKrdv2NKFW/1Jl8phKXX0v58SP3vNScUBJJeZ1jiH
         9wLuz07hmh7lsd6yMzwVIkkkVf8ceMzdc0Yr6NBA6knAhwlR7t2dO3BIjvTCJ3OLCbD2
         eiX5wWpq6qq7lit0AHrOMDrsc9wZAA/LPJbP3dVzoWAMjMaPLScRQHGXskjrUV5c3sb7
         t/0QV6wVICKk9vPcOmHRH9xT2sdZam18hOEPpAHY8rWLzwzdQxnWPKS9L1QVix2lwmEo
         IrwgiicjTwyOegjjNIG+cM8VayUT02sRe5t6mz8WhQ577Wlpb7Kl0FtGgsbzhKr0iCcx
         MPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dDm+9Z+VPJSjQt7jMvgBvDOrkZkCZvbOfUxGN5gTgvk=;
        b=VqgEVy1HOR1sSHbLyTTuMT6rEA3t8qTD/KdM68ubjzoCfy7jOlm9Sh29m1a3xCID06
         Icdbr4I69/2zHEF14thfGW3DekDHyiJvy3L4Cvjrb74RNPG/2KAMYaIeU9RDig1hPXBB
         am6WEPusU9G9gKclpYqiOFlNawRCDUMy85bKynjQaUz54ryty49PHHCPtzsjrfTQmBFh
         jakL1DyvbFCtjEYNNti2uyMkBQCaM6SO9QzdUiPcuel3k+dOIGWnhP7POH3x+OPGxL5D
         arJ98iaFNbEAdPH5E+FB5/abXH2/4NHczloYBP46wdVnY7uvDccGxhHPdFp3XZtFDc0b
         Oktw==
X-Gm-Message-State: AOAM531oEkwRoGUAeTAQSijVGp4U6IMOJTiiCDZVsNHE6v99PhwjpnRA
        u/nytypaOWvTu2t6x9r/elg=
X-Google-Smtp-Source: ABdhPJzvlSTCcW6WROkDcDvZLRqu96Xzc6vtJDJ3FS/a0I++olF+01zUgD6+TMAJ9TnmwyAr3yE5Dg==
X-Received: by 2002:a65:498f:: with SMTP id r15mr2697101pgs.345.1590564714992;
        Wed, 27 May 2020 00:31:54 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id u14sm1371787pfc.87.2020.05.27.00.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 00:31:53 -0700 (PDT)
Date:   Wed, 27 May 2020 00:31:50 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH v5 06/11] net: ethernet: mtk-star-emac: new driver
Message-ID: <20200527073150.GA3384158@ubuntu-s3-xlarge-x86>
References: <20200522120700.838-1-brgl@bgdev.pl>
 <20200522120700.838-7-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522120700.838-7-brgl@bgdev.pl>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 02:06:55PM +0200, Bartosz Golaszewski wrote:

<snip>

> diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> new file mode 100644
> index 000000000000..789c77af501f
> --- /dev/null
> +++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> @@ -0,0 +1,1678 @@

<snip>

I've searched netdev and I cannot find any reports from others but this
function introduces a clang warning:

drivers/net/ethernet/mediatek/mtk_star_emac.c:1296:6: warning: variable 'new_dma_addr' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
        if (!new_skb) {
            ^~~~~~~~
drivers/net/ethernet/mediatek/mtk_star_emac.c:1321:23: note: uninitialized use occurs here
        desc_data.dma_addr = new_dma_addr;
                             ^~~~~~~~~~~~
drivers/net/ethernet/mediatek/mtk_star_emac.c:1296:2: note: remove the 'if' if its condition is always false
        if (!new_skb) {
        ^~~~~~~~~~~~~~~
drivers/net/ethernet/mediatek/mtk_star_emac.c:1285:6: warning: variable 'new_dma_addr' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
        if ((desc_data.flags & MTK_STAR_DESC_BIT_RX_CRCE) ||
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mediatek/mtk_star_emac.c:1321:23: note: uninitialized use occurs here
        desc_data.dma_addr = new_dma_addr;
                             ^~~~~~~~~~~~
drivers/net/ethernet/mediatek/mtk_star_emac.c:1285:2: note: remove the 'if' if its condition is always false
        if ((desc_data.flags & MTK_STAR_DESC_BIT_RX_CRCE) ||
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mediatek/mtk_star_emac.c:1285:6: warning: variable 'new_dma_addr' is used uninitialized whenever '||' condition is true [-Wsometimes-uninitialized]
        if ((desc_data.flags & MTK_STAR_DESC_BIT_RX_CRCE) ||
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mediatek/mtk_star_emac.c:1321:23: note: uninitialized use occurs here
        desc_data.dma_addr = new_dma_addr;
                             ^~~~~~~~~~~~
drivers/net/ethernet/mediatek/mtk_star_emac.c:1285:6: note: remove the '||' if its condition is always false
        if ((desc_data.flags & MTK_STAR_DESC_BIT_RX_CRCE) ||
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mediatek/mtk_star_emac.c:1274:25: note: initialize the variable 'new_dma_addr' to silence this warning
        dma_addr_t new_dma_addr;
                               ^
                                = 0
3 warnings generated.

> +static int mtk_star_receive_packet(struct mtk_star_priv *priv)
> +{
> +	struct mtk_star_ring *ring = &priv->rx_ring;
> +	struct device *dev = mtk_star_get_dev(priv);
> +	struct mtk_star_ring_desc_data desc_data;
> +	struct net_device *ndev = priv->ndev;
> +	struct sk_buff *curr_skb, *new_skb;
> +	dma_addr_t new_dma_addr;

Uninitialized here

> +	int ret;
> +
> +	spin_lock(&priv->lock);
> +	ret = mtk_star_ring_pop_tail(ring, &desc_data);
> +	spin_unlock(&priv->lock);
> +	if (ret)
> +		return -1;
> +
> +	curr_skb = desc_data.skb;
> +
> +	if ((desc_data.flags & MTK_STAR_DESC_BIT_RX_CRCE) ||
> +	    (desc_data.flags & MTK_STAR_DESC_BIT_RX_OSIZE)) {
> +		/* Error packet -> drop and reuse skb. */
> +		new_skb = curr_skb;
> +		goto push_new_skb;

this goto

> +	}
> +
> +	/* Prepare new skb before receiving the current one. Reuse the current
> +	 * skb if we fail at any point.
> +	 */
> +	new_skb = mtk_star_alloc_skb(ndev);
> +	if (!new_skb) {
> +		ndev->stats.rx_dropped++;
> +		new_skb = curr_skb;
> +		goto push_new_skb;

and this goto

> +	}
> +
> +	new_dma_addr = mtk_star_dma_map_rx(priv, new_skb);
> +	if (dma_mapping_error(dev, new_dma_addr)) {
> +		ndev->stats.rx_dropped++;
> +		dev_kfree_skb(new_skb);
> +		new_skb = curr_skb;
> +		netdev_err(ndev, "DMA mapping error of RX descriptor\n");
> +		goto push_new_skb;
> +	}
> +
> +	/* We can't fail anymore at this point: it's safe to unmap the skb. */
> +	mtk_star_dma_unmap_rx(priv, &desc_data);
> +
> +	skb_put(desc_data.skb, desc_data.len);
> +	desc_data.skb->ip_summed = CHECKSUM_NONE;
> +	desc_data.skb->protocol = eth_type_trans(desc_data.skb, ndev);
> +	desc_data.skb->dev = ndev;
> +	netif_receive_skb(desc_data.skb);
> +
> +push_new_skb:
> +	desc_data.dma_addr = new_dma_addr;

assign it uninitialized here.

> +	desc_data.len = skb_tailroom(new_skb);
> +	desc_data.skb = new_skb;
> +
> +	spin_lock(&priv->lock);
> +	mtk_star_ring_push_head_rx(ring, &desc_data);
> +	spin_unlock(&priv->lock);
> +
> +	return 0;
> +}

I don't know if there should be a new label that excludes that
assignment for those particular gotos or if new_dma_addr should
be initialized to something at the top. Please take a look at
addressing this when you get a chance.

Cheers,
Nathan
