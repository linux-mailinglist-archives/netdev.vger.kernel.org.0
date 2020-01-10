Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5A51376D4
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgAJTTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:19:25 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45243 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbgAJTTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:19:25 -0500
Received: by mail-pg1-f196.google.com with SMTP id b9so1416300pgk.12
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 11:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WjWIfNQOtaToOlC4O+CnMrupcAlzvSvYWnr8yCpwi0g=;
        b=H4J9xXilVef6Y4IPfviA78BDdcIVGKxgDNBtsNRkugy2QbbzlvpTzZD2i2wwHXBXFP
         avKj40gnet7HyKq9ytmtIirO4xC/bCjmszTEnkq0+dTV7a8PgdgVBarPQBls6E2RnSQM
         YQMmqx5Qi31huIMPGKJQhyBaKyPFL8cRWJWQc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WjWIfNQOtaToOlC4O+CnMrupcAlzvSvYWnr8yCpwi0g=;
        b=ABplBgQMVRetqW3p/UIvA90nQ3gKomPj1dAOSBAlTS4ZdHjOiGcidFJf2KUT7RKk46
         c3cdq+PjbHGQyZtL+7TDg7+SRNLSBhvKOpBML9giVadXVWPT773r3JQN0b+gB2vZhHlA
         mHN2I5SE5M+G0J+FNIkT/tt5kHGodAHbfHE1T6BEtuPr+SU7QoscHcxbMFeFAy6eA+8Y
         TolXPrMDGlDiL0u+603B1RzqCIVL5MAABk8tsv5vDnNghwgkepwXSwpP3b7EJDFk01pC
         Dc+VzEf4bIJodwSzHIK7GJQuJ1f+L9yxjSqOCQLoHHDyXUqLac2L0OdN7P00XAqPops8
         tOtg==
X-Gm-Message-State: APjAAAVZnU0klIRToWZZaNN8FyOUvNJeBZ/DkwAdMaAxKncy6N7sj7LG
        qli2Xw02zt69dVrjLxq3KMeUxyuKze4=
X-Google-Smtp-Source: APXvYqwKT5kw5CJjNZkgJw+7zCzJKM1U7qCHHHWxjFJeYy6zGdG84QeI1CWQndBfeMLsEYd2UvQFxA==
X-Received: by 2002:a63:26c4:: with SMTP id m187mr6294263pgm.410.1578683964306;
        Fri, 10 Jan 2020 11:19:24 -0800 (PST)
Received: from C02YVCJELVCG.dhcp.broadcom.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id f8sm3728926pjg.28.2020.01.10.11.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 11:19:23 -0800 (PST)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Fri, 10 Jan 2020 14:19:20 -0500
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH net-next] bnxt: Detach page from page pool before sending
 up the stack
Message-ID: <20200110191920.GB75497@C02YVCJELVCG.dhcp.broadcom.net>
References: <20200109193542.4171646-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109193542.4171646-1-jonathan.lemon@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 11:35:42AM -0800, Jonathan Lemon wrote:
> When running in XDP mode, pages come from the page pool, and should
> be freed back to the same pool or specifically detached.  Currently,
> when the driver re-initializes, the page pool destruction is delayed
> forever since it thinks there are oustanding pages.

Looks good.  Thanks for the patch!

> Fixes: 322b87ca55f2 ("bnxt_en: add page_pool support")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Reviewed-by: Andy Gospodarek <gospo@broadcom.com>

> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 39d4309b17fb..33eb8cd6551e 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -944,6 +944,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
>  	dma_addr -= bp->rx_dma_offset;
>  	dma_unmap_page_attrs(&bp->pdev->dev, dma_addr, PAGE_SIZE, bp->rx_dir,
>  			     DMA_ATTR_WEAK_ORDERING);
> +	page_pool_release_page(rxr->page_pool, page);
>  
>  	if (unlikely(!payload))
>  		payload = eth_get_headlen(bp->dev, data_ptr, len);
> -- 
> 2.17.1
> 
