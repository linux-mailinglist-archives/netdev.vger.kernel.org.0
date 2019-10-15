Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A19D83DF
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733045AbfJOWlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:41:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40486 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732840AbfJOWlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:41:16 -0400
Received: by mail-wr1-f66.google.com with SMTP id o28so3072516wro.7
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 15:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iNvwx32jlzvPxgpCeOzZGokMJtn+IRhkLNzs+blV5jc=;
        b=d0UaLWnXtI4IX+KkbkvOhWkXwRfDZCJ/xgKH3c/HMCpFbFGq4gI+PLcNnWiguSemEU
         iHzabRx7kufJfJviKPqzZFLzERj18NuNlm/H6/MgMCYccEDyRrSvvcTgrJ6gCBVpxc94
         jX486CDPBPcASAhm+ygoqhOSUSCHlO8/daEv6uPvK5Lw6mrpfgBGtSItYqAuNDj2iLBo
         cXntq4oBtIhu+QaNFDQMc+7YvuXR29yxfxyNqyvPUAriLeOMrQZaLaI3zNMOegMs4NUi
         LgrRQaTTBug2EfNE+XrAV2MlIavXlVLHfMi/RUYyONIpWlRSWXkMq5yHKcUKQWeGndJM
         h1KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iNvwx32jlzvPxgpCeOzZGokMJtn+IRhkLNzs+blV5jc=;
        b=gpKR7qhr+DArD5MrCC0wLXi6jxYFo7lXH3n0sSbVKhmbHrOuEAYGvWqrmrZxFw1U4b
         DtWT/xCJ+TDnMRKTqBabTTZKJDVxijRjmqPlkPWo6POrrbCXrzMruaZtlGkp/2dshqL+
         pkLg5CStioqdPibpAvnhJ+V8LfqU2naxVYS1PBD/Pj9JBz1+dNDoh+QGGbstt0QPZe9b
         XH4QJRfKKw5l2UpM4mIf0tXGL9/Ob6nXUcPdTXEKxKFr8WWkzPMIxrdblJGry/F0O9Qi
         jvmS4KMvfq1/wjeeh8zf8h2AYhEfd15/xCsyn+TDFiH3eHW61QoKNCjhQBfCUDMRStEG
         MyXQ==
X-Gm-Message-State: APjAAAULM/UuKP6alrTWHboOFCHuN9XgmCUHZr5oKD2PAD++HMPwwpR5
        Om1lJXroyBGRVJ6p2K51LpANog==
X-Google-Smtp-Source: APXvYqyVAe5sSfeDgQFoO1jlGzThHhNgOA8EcXSLRwTyvCdRyBgjKPfnQmTPqFb8XTyY119j1txd5A==
X-Received: by 2002:a05:6000:1283:: with SMTP id f3mr30576845wrx.370.1571179273881;
        Tue, 15 Oct 2019 15:41:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z6sm21769200wro.16.2019.10.15.15.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 15:41:13 -0700 (PDT)
Date:   Tue, 15 Oct 2019 15:41:07 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v3 net-next 2/8] net: mvneta: introduce page pool API
 for sw buffer manager
Message-ID: <20191015154107.08c4e9e1@cakuba.netronome.com>
In-Reply-To: <af6df39a06cba5b416520c6249c16d2cd2e3bb73.1571049326.git.lorenzo@kernel.org>
References: <cover.1571049326.git.lorenzo@kernel.org>
        <af6df39a06cba5b416520c6249c16d2cd2e3bb73.1571049326.git.lorenzo@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Oct 2019 12:49:49 +0200, Lorenzo Bianconi wrote:
> +static int mvneta_create_page_pool(struct mvneta_port *pp,
> +				   struct mvneta_rx_queue *rxq, int size)
> +{
> +	struct page_pool_params pp_params = {
> +		.order = 0,
> +		.flags = PP_FLAG_DMA_MAP,
> +		.pool_size = size,
> +		.nid = cpu_to_node(0),
> +		.dev = pp->dev->dev.parent,
> +		.dma_dir = DMA_FROM_DEVICE,
> +	};
> +	int err;
> +
> +	rxq->page_pool = page_pool_create(&pp_params);
> +	if (IS_ERR(rxq->page_pool)) {
> +		err = PTR_ERR(rxq->page_pool);
> +		rxq->page_pool = NULL;
> +		return err;
> +	}
> +
> +	err = xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, 0);

The queue_index is always passed as 0, is there only a single queue?
XDP programs can read this field.

> +	if (err < 0)
> +		goto err_free_pp;
> +
> +	err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
> +					 rxq->page_pool);
> +	if (err)
> +		goto err_unregister_rxq;
> +
> +	return 0;
> +
> +err_unregister_rxq:
> +	xdp_rxq_info_unreg(&rxq->xdp_rxq);
> +err_free_pp:
> +	page_pool_destroy(rxq->page_pool);
> +	return err;
> +}
