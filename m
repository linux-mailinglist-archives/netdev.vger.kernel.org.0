Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4FB8DA323
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 03:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730953AbfJQB3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 21:29:00 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34917 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727916AbfJQB27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 21:28:59 -0400
Received: by mail-lj1-f193.google.com with SMTP id m7so715081lji.2
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 18:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=x5dwPlN4iFd8a8gfS79sSxwhKFB2wU4wQCoV5Q2NcZU=;
        b=Bm4Cdxoy5kk7dylfgAt0esDG8tO0uB8bRUu/norlK2FFKunR4NCuawHbAMAdmedvWt
         x4a7U4zdYBLtQtl0K12kHufoXZryxGXgBZfIIulw/IdixWKxrCJNXGVkxporRKOfi+4X
         35QY3xwK1s2+Odgr+bcFvxv31Tj8yPmXim7eunkstKILtEpFsjALrgJUlO7asDxpAx6R
         VS0jVSaF5AjLmkDRxgIuc+91Winjpm6j+ciLpRq1hdllZhqLjh3h1eykpRwhgH8FGf3H
         U10fI/4QPG8RXs+gT0zKd9dr+msUDWYP7xQblqRq4TqPoCBMaA4vf1wIHKqA3g92KCZc
         +yWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=x5dwPlN4iFd8a8gfS79sSxwhKFB2wU4wQCoV5Q2NcZU=;
        b=icS4RwwiWefi8nkvjRsTTsYNvJMSDKkeOSaWptOf53CaBJC+qIkZ6E83SN9m+qUQW/
         4eBbSDHqS/V3LI+Wq7WVJBvKDbJU7hTQupon4FbQdxwdhms8hMl6KXItKhh4NMMNoaQW
         I2o9EufVwhaP+Orv/o2bNHtgBToe5DRk+2091hYAx4Z2yqZlIhGAr92CaLRa+f6JmSWP
         pTBVZPtgZeZQKOIOy0X0JTghBS8WLXXFLaGjau6I6QWUaaeWGbbwA+rXompcGLpdAcYF
         +p+zi7+r2irzRgXdYi5+1zgXjuWrvD+3/+gUYD6vd0lmvV4Wk+/SfxynruHFJanMqU1u
         0Ngg==
X-Gm-Message-State: APjAAAUzUtILc/vH4j1jq40mfGqY6Rfr6DvKnxI9Rr0HGusZ9xQaTaCs
        PgGfQ7iiyVt02V8B2+e5H+pFag==
X-Google-Smtp-Source: APXvYqz0Xg4FZWQ5U6mUV5ru3ppwLwTJhllCIsPGH8ekB9S6WIYw0N6H/SnoySlDfIW8ZnirbWzP2w==
X-Received: by 2002:a2e:6c15:: with SMTP id h21mr629209ljc.10.1571275737847;
        Wed, 16 Oct 2019 18:28:57 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s1sm211471lfd.14.2019.10.16.18.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 18:28:57 -0700 (PDT)
Date:   Wed, 16 Oct 2019 18:28:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v4 net-next 7/7] net: mvneta: add XDP_TX support
Message-ID: <20191016182849.27d130db@cakuba.netronome.com>
In-Reply-To: <41267f6501185d6bcf0bc9a883b77e83d5c1f533.1571258793.git.lorenzo@kernel.org>
References: <cover.1571258792.git.lorenzo@kernel.org>
        <41267f6501185d6bcf0bc9a883b77e83d5c1f533.1571258793.git.lorenzo@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 23:03:12 +0200, Lorenzo Bianconi wrote:
> Implement XDP_TX verdict and ndo_xdp_xmit net_device_ops function
> pointer
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

> +static int
> +mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
> +			struct xdp_frame *xdpf, bool dma_map)
> +{
> +	struct mvneta_tx_desc *tx_desc;
> +	struct mvneta_tx_buf *buf;
> +	dma_addr_t dma_addr;
> +
> +	if (txq->count >= txq->tx_stop_threshold)
> +		return MVNETA_XDP_DROPPED;
> +
> +	tx_desc = mvneta_txq_next_desc_get(txq);
> +
> +	buf = &txq->buf[txq->txq_put_index];
> +	if (dma_map) {
> +		/* ndo_xdp_xmit */
> +		dma_addr = dma_map_single(pp->dev->dev.parent, xdpf->data,
> +					  xdpf->len, DMA_TO_DEVICE);
> +		if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
> +			mvneta_txq_desc_put(txq);
> +			return MVNETA_XDP_DROPPED;
> +		}
> +		buf->type = MVNETA_TYPE_XDP_NDO;
> +	} else {
> +		struct page *page = virt_to_page(xdpf->data);
> +
> +		dma_addr = page_pool_get_dma_addr(page) +
> +			   xdpf->headroom + sizeof(*xdpf);

nit:

 sizeof(*xdpf) + xdpf->headroom

order would be slightly preferable since it matches field ordering in
memory.

> +		dma_sync_single_for_device(pp->dev->dev.parent, dma_addr,
> +					   xdpf->len, DMA_BIDIRECTIONAL);
> +		buf->type = MVNETA_TYPE_XDP_TX;
> +	}
> +	buf->xdpf = xdpf;
> +
> +	tx_desc->command = MVNETA_TXD_FLZ_DESC;
> +	tx_desc->buf_phys_addr = dma_addr;
> +	tx_desc->data_size = xdpf->len;
> +
> +	mvneta_update_stats(pp, 1, xdpf->len, true);
> +	mvneta_txq_inc_put(txq);
> +	txq->pending++;
> +	txq->count++;
> +
> +	return MVNETA_XDP_TX;
> +}
