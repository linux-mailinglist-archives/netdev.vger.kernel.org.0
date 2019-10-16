Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62413D84B1
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 02:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbfJPAME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 20:12:04 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39264 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfJPAME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 20:12:04 -0400
Received: by mail-lj1-f195.google.com with SMTP id y3so22079265ljj.6
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 17:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=D7irjXnLls42Dxg4HmnRXgXJ21DyPnF9Y3pvnr4IQFM=;
        b=SijKPXea0t4TAuspKxcXQAGRLGKmz2ziiXm+YXW3U1KLIkojpri+tmdw7pG5hu2xZy
         z9k0gNjJjUb8qG3+Wnp0i3Jn8I2CyVvyeORHRyBRcs7hnzJFSe0VqqJZO5tYyNPblkC1
         FtzPZkNAB2q3iLc3VqaG/2t6Qa3u3Su5oRpyo3cBTG0Z1LInCpW9SYAcfpkNllSg+gzr
         NSIpQmDUzbLtOA/+4eVAEhil8drPSQU34VZxCkFDx1kvAdchfPz48URGzma89ylazF5o
         h1jjcGLRTWn5cAdp31zdA8Tk3FD3QKLY3nGVG6bXtX6qJUYbNEGdLUll7G5mK/AgSUdF
         QMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=D7irjXnLls42Dxg4HmnRXgXJ21DyPnF9Y3pvnr4IQFM=;
        b=J/2iOI0Y4EsiUPWAjoutN9F2OTyq+ZHiCK7ZfT3q0PgzH+daiU6jSqr0it0eBrCtEE
         gCRrh2Qn/WyNNUX2eKs62V51bm608sSdbg3bZjHQ1Qrz+fpZfRHw5i5UUdidzd3X7ZeI
         NujeBZFSMwtHn9bSeLIthjeFfS7pDt3LBpnENk3PI5Ntk8kGiSB838uyRRbDnlD9F/+4
         cymN4pvjwEmyh0vHlvHpY/RNQPtOtLmlgyfhcR4mlVTR1JRPHkxyABiSVKxxaMGSsLP7
         eKNjfEvOz1s+Q1ygLrlxG8lAUxZtM1H7XeYJRrniNGrJjhXtUYbqEIJ55lr74yUtFj2O
         NyxA==
X-Gm-Message-State: APjAAAX1HK7MnhwL2m4A+u8DexiVDo0NPllkIK9rLJrPVzLBnGBR9PB+
        0hsezz9uk+3+z0aje2bB9eG5Gw==
X-Google-Smtp-Source: APXvYqyU5Lg8rkX60j9HqJfZB6lKMaE/7Q/SOvZQsb/Uh3pXi2X386bMnz94/HYsSu7RKBGfm4WVuA==
X-Received: by 2002:a2e:420a:: with SMTP id p10mr13507494lja.16.1571184720774;
        Tue, 15 Oct 2019 17:12:00 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r6sm5376477lfn.29.2019.10.15.17.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 17:12:00 -0700 (PDT)
Date:   Tue, 15 Oct 2019 17:11:52 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v3 net-next 8/8] net: mvneta: add XDP_TX support
Message-ID: <20191015171152.41d9a747@cakuba.netronome.com>
In-Reply-To: <a964f1a704f194169e80f9693cf3150adffc1278.1571049326.git.lorenzo@kernel.org>
References: <cover.1571049326.git.lorenzo@kernel.org>
        <a964f1a704f194169e80f9693cf3150adffc1278.1571049326.git.lorenzo@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Oct 2019 12:49:55 +0200, Lorenzo Bianconi wrote:
> Implement XDP_TX verdict and ndo_xdp_xmit net_device_ops function
> pointer
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

> @@ -1972,6 +1975,109 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
>  	return i;
>  }
>  
> +static int
> +mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
> +			struct xdp_frame *xdpf, bool dma_map)
> +{
> +	struct mvneta_tx_desc *tx_desc;
> +	struct mvneta_tx_buf *buf;
> +	dma_addr_t dma_addr;
> +
> +	if (txq->count >= txq->tx_stop_threshold)
> +		return MVNETA_XDP_CONSUMED;
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
> +			return MVNETA_XDP_CONSUMED;
> +		}
> +		buf->type = MVNETA_TYPE_XDP_NDO;
> +	} else {
> +		struct page *page = virt_to_page(xdpf->data);
> +
> +		dma_addr = page_pool_get_dma_addr(page) +
> +			   pp->rx_offset_correction + MVNETA_MH_SIZE;
> +		dma_sync_single_for_device(pp->dev->dev.parent, dma_addr,
> +					   xdpf->len, DMA_BIDIRECTIONAL);

This looks a little suspicious, XDP could have moved the start of frame
with adjust_head, right? You should also use xdpf->data to find where
the frame starts, no?

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
> +
> +static int
> +mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
> +{
> +	struct xdp_frame *xdpf = convert_to_xdp_frame(xdp);
> +	int cpu = smp_processor_id();
> +	struct mvneta_tx_queue *txq;
> +	struct netdev_queue *nq;
> +	u32 ret;
> +
> +	if (unlikely(!xdpf))
> +		return MVNETA_XDP_CONSUMED;

Personally I'd prefer you haven't called a function which return code
has to be error checked in local variable init.

> +
> +	txq = &pp->txqs[cpu % txq_number];
> +	nq = netdev_get_tx_queue(pp->dev, txq->id);
> +
> +	__netif_tx_lock(nq, cpu);
> +	ret = mvneta_xdp_submit_frame(pp, txq, xdpf, false);
> +	if (ret == MVNETA_XDP_TX)
> +		mvneta_txq_pend_desc_add(pp, txq, 0);
> +	__netif_tx_unlock(nq);
> +
> +	return ret;
> +}
