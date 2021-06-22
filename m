Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624CF3AFE2F
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 09:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhFVHrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 03:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhFVHrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 03:47:45 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C8EC061574;
        Tue, 22 Jun 2021 00:45:28 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso1755495pjp.2;
        Tue, 22 Jun 2021 00:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rTA9Ge9ztWJg6qu4WnRUxoLw0dKUZdpAeQoMLnN27LI=;
        b=sO8Qr+cKOoS9FFMwhHMmBRROUFXOc4mYXbSrj3q4I9aa/7WgaygubUaATqWccoO4Ew
         Szplz4/pkFp41LIoz//7GarOONmHu/e7bViZcLUdm6AzBVUw5baLNSA5pE5CjJ0ZAMSh
         X1A5FhBV6WqY/wv1ySo16Rm0rt9ENiTXGyAFElVbZEsRyng3TNRLqmASUDypQSmBB7Uv
         UNBA4SsU+L9w7HLzTJuOwLoH26y9YfMEqdJGXZOclR4x+nHw+p+sRh5JIA12fUJz68UQ
         +BVEMymQMH5X6dGY1vZeoxCm90cVBdIgQhHtQOUsmGMpeepu+3g5hrcTOzq+MpptMEEO
         MrQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rTA9Ge9ztWJg6qu4WnRUxoLw0dKUZdpAeQoMLnN27LI=;
        b=MVREKz1Um0UvmMXUbjKjWOl6Yu2GGhUHk10WBJYCt6WhsIQ0IFwESN6d5BHXsX0Ili
         ejzCS1t2IMFYFSXyGHNjvZFEacUCIKZdOKDFxIf1BTH+zFt/JGZfSZjZ7ra3tqQ4uN/c
         WGwDMbSS6Cz2McjwHJQRn3c/iSvuUGDIcr6Tyhvz0wWNclm/+wY5pwaXud19i/K1RN+g
         JyW1OTKLCK+TTBN+U2yEqLsVNP+xwnnbPNY9wRytS6ZEdwoIH+9RPH4fwgYMQdyKeM52
         kUiCb/TpfL04c/PRyZNBG5WgBCWrhpWI5LgOfK2eYeGfNNv48wS0QzfPPPRy2BeKWvdJ
         43ow==
X-Gm-Message-State: AOAM530MhnvnloVSf2UPEpRUWrhv/8lSTUhvQpHfAu3LX2iu8GDmXPxl
        hBMBW/OsQ5ZhFDAssewoOus=
X-Google-Smtp-Source: ABdhPJzMBA5sJR+94E9iAB6vMokMhc1pEt84r+vNnG+VInBYxTlSEk+FfUe3ay+4zpdhxsDYnbUNWQ==
X-Received: by 2002:a17:902:ce86:b029:125:8c21:2ab9 with SMTP id f6-20020a170902ce86b02901258c212ab9mr6136618plg.45.1624347928208;
        Tue, 22 Jun 2021 00:45:28 -0700 (PDT)
Received: from d3 ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id f13sm3076941pfe.149.2021.06.22.00.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 00:45:27 -0700 (PDT)
Date:   Tue, 22 Jun 2021 16:45:22 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 12/19] staging: qlge: rewrite do while loops as for loops
 in qlge_start_rx_ring
Message-ID: <YNGVEiS8mITXQ5sS@d3>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-13-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621134902.83587-13-coiby.xu@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-21 21:48 +0800, Coiby Xu wrote:
> Since MAX_DB_PAGES_PER_BQ > 0, the for loop is equivalent to do while
> loop.
> 
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 7aee9e904097..c5e161595b1f 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -3029,12 +3029,11 @@ static int qlge_start_cq(struct qlge_adapter *qdev, struct qlge_cq *cq)
>  		tmp = (u64)rx_ring->lbq.base_dma;
>  		base_indirect_ptr = rx_ring->lbq.base_indirect;
>  		page_entries = 0;

This initialization can be removed now. Same thing below.

> -		do {
> +		for (page_entries = 0; page_entries < MAX_DB_PAGES_PER_BQ; page_entries++) {
>  			*base_indirect_ptr = cpu_to_le64(tmp);
>  			tmp += DB_PAGE_SIZE;
>  			base_indirect_ptr++;
> -			page_entries++;
> -		} while (page_entries < MAX_DB_PAGES_PER_BQ);
> +		}
>  		cqicb->lbq_addr = cpu_to_le64(rx_ring->lbq.base_indirect_dma);
>  		cqicb->lbq_buf_size =
>  			cpu_to_le16(QLGE_FIT16(qdev->lbq_buf_size));
> @@ -3046,12 +3045,11 @@ static int qlge_start_cq(struct qlge_adapter *qdev, struct qlge_cq *cq)
>  		tmp = (u64)rx_ring->sbq.base_dma;
>  		base_indirect_ptr = rx_ring->sbq.base_indirect;
>  		page_entries = 0;
> -		do {
> +		for (page_entries = 0; page_entries < MAX_DB_PAGES_PER_BQ; page_entries++) {
>  			*base_indirect_ptr = cpu_to_le64(tmp);
>  			tmp += DB_PAGE_SIZE;
>  			base_indirect_ptr++;
> -			page_entries++;
> -		} while (page_entries < MAX_DB_PAGES_PER_BQ);
> +		}
>  		cqicb->sbq_addr = cpu_to_le64(rx_ring->sbq.base_indirect_dma);
>  		cqicb->sbq_buf_size = cpu_to_le16(QLGE_SMALL_BUFFER_SIZE);
>  		cqicb->sbq_len = cpu_to_le16(QLGE_FIT16(QLGE_BQ_LEN));
> -- 
> 2.32.0
> 
