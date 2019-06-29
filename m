Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E75E5ACDF
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 20:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfF2Ssm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 14:48:42 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36963 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbfF2Ssm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 14:48:42 -0400
Received: by mail-pg1-f195.google.com with SMTP id g15so2154863pgi.4
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 11:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=XCG9vWlRAYXypzEVH88EahdSFsJ1m1pG2a+oXbrUsyo=;
        b=A2Ue1mmuYuIoZV2bHNhpQYOIcgUaz8KIazYfOG8hePG35iibKTr5v9q2Dtd5tk6Amo
         Z0k478WwHfLzzA+rXnSbgnkXo0QLMyzSOWCZQy6WnoThy2uGsIlPAzU7qwiQcptQAC3q
         BElHeQr0al59sv6BabNZF1B5ZxFrypqzaub5+gZgGQ4yZRwBtN2AXDAIbB5HJhTXXypo
         U0X2P9GM/7V7FWrEdR36VueiJDPSZD0YC1EXVdjdwzNEux+947CmLDjyusgqM+2nouLZ
         EJU1vPGibrR96/YXlX4NVpmpim71IYNh4BAAmNzWn4Lbn2k4qVu0HvOfhBpSzWvnCqcf
         GWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=XCG9vWlRAYXypzEVH88EahdSFsJ1m1pG2a+oXbrUsyo=;
        b=hpzbu1BnN4gAjbZpizwxrdVEKHlhKDMBmTlLZr/QHRv6cTZO/vkduss6lZuyYWqYyf
         LftRHh7r2UeKFgrM+g8ZesQ1qX/RNhz1sT8RHmjFyiwk54W1qgDcqsz2bxIZ86ZIW4yx
         Ad6oJtUE86TDcZ+eTvCGfk6be0cOWtcOY6Nze7VXQwYWw6AfYHsc0XtPzd57miLrJgkV
         SqWmE20914I8unkMpZR08E7KlJSygz4wEsUfmgqgbw9QSijEoyqSIwLr+oogZJkrhBVk
         GXukcO8G6As50zj12MqywC5pMY76BKC/WFB36YflS316JgEh1pwb7Z9cCUU7oHHUQdXy
         65+g==
X-Gm-Message-State: APjAAAU0KUlSHEcUD20bscQVJXTltpJbCnJgRX6wrLxIMgorCDjFFlQW
        WQyFVuYERCP9RdXyOaDqm9elFuDhOiQ=
X-Google-Smtp-Source: APXvYqyol0jqdmEY+rZm2zEnMBbh4EknuOjEWuSAD/c+MRJuIvKpZolkaFfMTgP4vCx9ocwwBl7bIg==
X-Received: by 2002:a17:90a:9289:: with SMTP id n9mr21093350pjo.35.1561834121793;
        Sat, 29 Jun 2019 11:48:41 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id m100sm6622965pje.12.2019.06.29.11.48.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 29 Jun 2019 11:48:41 -0700 (PDT)
Date:   Sat, 29 Jun 2019 11:48:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 17/19] ionic: Add RSS support
Message-ID: <20190629114839.6cf1f048@cakuba.netronome.com>
In-Reply-To: <20190628213934.8810-18-snelson@pensando.io>
References: <20190628213934.8810-1-snelson@pensando.io>
        <20190628213934.8810-18-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 14:39:32 -0700, Shannon Nelson wrote:
> @@ -1260,10 +1266,24 @@ static struct lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
>  	if (err)
>  		goto err_out_free_lif_info;
>  
> +	/* allocate rss indirection table */
> +	tbl_sz = le16_to_cpu(lif->ionic->ident.lif.eth.rss_ind_tbl_sz);
> +	lif->rss_ind_tbl_sz = sizeof(*lif->rss_ind_tbl) * tbl_sz;
> +	lif->rss_ind_tbl = dma_alloc_coherent(dev, lif->rss_ind_tbl_sz,
> +					      &lif->rss_ind_tbl_pa,
> +					      GFP_KERNEL);
> +
> +	if (!lif->rss_ind_tbl) {
> +		dev_err(dev, "Failed to allocate rss indirection table, aborting\n");
> +		goto err_out_free_qcqs;
> +	}
> +
>  	list_add_tail(&lif->list, &ionic->lifs);
>  
>  	return lif;
>  
> +err_out_free_qcqs:
> +	ionic_qcqs_free(lif);
>  err_out_free_lif_info:
>  	dma_free_coherent(dev, lif->info_sz, lif->info, lif->info_pa);
>  	lif->info = NULL;
> @@ -1302,6 +1322,14 @@ static void ionic_lif_free(struct lif *lif)
>  {
>  	struct device *dev = lif->ionic->dev;
>  
> +	/* free rss indirection table */
> +	if (lif->rss_ind_tbl) {
> +		dma_free_coherent(dev, lif->rss_ind_tbl_sz, lif->rss_ind_tbl,
> +				  lif->rss_ind_tbl_pa);

dma_free_coherent() should be able to deal with NULLs just fine.
Besides you fail hard if the allocation failed, no?

> +		lif->rss_ind_tbl = NULL;
> +		lif->rss_ind_tbl_pa = 0;
> +	}

