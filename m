Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E3C61BB0
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 10:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbfGHI2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 04:28:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52203 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfGHI2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 04:28:09 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so14792962wma.1
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 01:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WP/bxpc7jj36HjMzQdHQ+ELYjCDX6iz0ci+BdU/KCkk=;
        b=xroaXek2yTXEs2+hF3qAgW1un/WLlY4ifhHokr4Mdm//IEFp5fxA3LRSKk0l1xI3G2
         W3uU28QP2XFMRNGH9jAaxfptyKPfl8Ft+ZGAoTcmGZgJayAjygmN8DpOScd4EY1MGVhn
         8BqM9FRI0BDYCh9V3q/1HFrIyiRcPxNXSEXIxTsq+9fvvYBjwV00JZHmwNEoFKdsVV0f
         oRN7Kum18RO01865AFSRLfnI+gtw2PFIM9VGuqCpCLMHIaXR+flPMp2RKL9eE0q1d2kb
         ILbuE1EKQYp6GV9ylyXfchUVV/A4W9EkaiHk4YaNtflNbBKyu1UldRnCuM9K8EH9cn+v
         kyCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WP/bxpc7jj36HjMzQdHQ+ELYjCDX6iz0ci+BdU/KCkk=;
        b=EJwmIboPjOsDMeg0uLs28ReuTzfdksHDpmZ6OGEC6K34RnTMqPHeOf2OUWQMoV3qRY
         rYQnUEoE7o9sVNN8fJhSrpFbV8LxmjBbiCpIMueYbejVgYe6cPnfqTLQ0VvImY7zvH2f
         PTde7K1rN+u1nU0XqcT/5vIuKBgC/OvkK+AkDA90sagHtE7SMJL3HLa8bD5espmctFdF
         NtvuUPNfVVe743pW1Vm1uGFaNvFOb9dgnH7jm0rEnpmMnMpUFrNU5OD0bE3onVbzUOEY
         9SYMQ7tdpybjiUpzWpsGR6eO2/rOvjaLu5di15gFqlVwrsA/fzXIxEFz1MprNQuM+ONh
         9IAg==
X-Gm-Message-State: APjAAAV3RHkdKGkZJiNiT46RjsxRoDVI5vv3EPy/OBrmymPtVnDassby
        XNsxMCIVEM8TBd686Jc/RYOmmA==
X-Google-Smtp-Source: APXvYqxNigfzHrdAQaA9ED6BpR8ozcFUNpKFb9dOuV/wXncb+nUFcRKYeqgYjYWoFBytP7VgLmkhwQ==
X-Received: by 2002:a05:600c:389:: with SMTP id w9mr15056723wmd.139.1562574486758;
        Mon, 08 Jul 2019 01:28:06 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id r12sm26685608wrt.95.2019.07.08.01.28.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 01:28:06 -0700 (PDT)
Date:   Mon, 8 Jul 2019 11:28:03 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, gospo@broadcom.com, netdev@vger.kernel.org,
        hawk@kernel.org, ast@kernel.org
Subject: Re: [PATCH net-next 3/4] bnxt_en: optimized XDP_REDIRECT support
Message-ID: <20190708082803.GA28592@apalos>
References: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
 <1562398578-26020-4-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562398578-26020-4-git-send-email-michael.chan@broadcom.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Andy, Michael

> +	if (event & BNXT_REDIRECT_EVENT)
> +		xdp_do_flush_map();
> +
>  	if (event & BNXT_TX_EVENT) {
>  		struct bnxt_tx_ring_info *txr = bnapi->tx_ring;
>  		u16 prod = txr->tx_prod;
> @@ -2254,9 +2257,23 @@ static void bnxt_free_tx_skbs(struct bnxt *bp)
>  
>  		for (j = 0; j < max_idx;) {
>  			struct bnxt_sw_tx_bd *tx_buf = &txr->tx_buf_ring[j];
> -			struct sk_buff *skb = tx_buf->skb;
> +			struct sk_buff *skb;
>  			int k, last;
>  
> +			if (i < bp->tx_nr_rings_xdp &&
> +			    tx_buf->action == XDP_REDIRECT) {
> +				dma_unmap_single(&pdev->dev,
> +					dma_unmap_addr(tx_buf, mapping),
> +					dma_unmap_len(tx_buf, len),
> +					PCI_DMA_TODEVICE);
> +				xdp_return_frame(tx_buf->xdpf);
> +				tx_buf->action = 0;
> +				tx_buf->xdpf = NULL;
> +				j++;
> +				continue;
> +			}
> +

Can't see the whole file here and maybe i am missing something, but since you
optimize for that and start using page_pool, XDP_TX will be a re-synced (and
not remapped)  buffer that can be returned to the pool and resynced for 
device usage. 
Is that happening later on the tx clean function?

> +			skb = tx_buf->skb;
>  			if (!skb) {
>  				j++;
>  				continue;
> @@ -2517,6 +2534,13 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
>  		if (rc < 0)
>  			return rc;
>  
> +		rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
> +						MEM_TYPE_PAGE_SHARED, NULL);
> +		if (rc) {
> +			xdp_rxq_info_unreg(&rxr->xdp_rxq);

I think you can use page_pool_free directly here (and pge_pool_destroy once
Ivan's patchset gets nerged), that's what mlx5 does iirc. Can we keep that
common please?

If Ivan's patch get merged please note you'll have to explicitly
page_pool_destroy, after calling xdp_rxq_info_unreg() in the general unregister
case (not the error habdling here). Sorry for the confusion this might bring!

> +			return rc;
> +		}
> +
>  		rc = bnxt_alloc_ring(bp, &ring->ring_mem);
>  		if (rc)
>  			return rc;
> @@ -10233,6 +10257,7 @@ static const struct net_device_ops bnxt_netdev_ops = {
[...]

Thanks!
/Ilias
