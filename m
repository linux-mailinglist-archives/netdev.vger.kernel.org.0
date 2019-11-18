Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61807100F5F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 00:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfKRXTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 18:19:43 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46095 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfKRXTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 18:19:43 -0500
Received: by mail-lf1-f67.google.com with SMTP id o65so15282992lff.13
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 15:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=9WG6cMl/gBqW9/dUbHwS2oVdtkU/FExq1G0KUcb14jY=;
        b=CsevRdAJ/oiKXMYgfDr//L3LiNwwpSy9/RnWu2vXLF0iy61wUPpF0eTeXvu3LDUMr7
         lmdJEQef0drOfdl0l0pehcSNrImC0vIwT77Ct0uiGUVBp7+0Lz9F7pyz93CPoyGdlCVK
         Ze9EsgpuhEpsCzTe7QX540RpavyzgT6NEOPf4VTCFv19w+fS0BJYw54wxHzXGEwpd3Jl
         DOa8UrZ4fSTBUTVJ5GuBBRfehohUq69Du3MguA0VqkUrBLa8z9dd7Y1S8jEo85UpFEGo
         Jq/2wnmR4DPIv+13Jx1C3efzChpErZbAFJmPjNfCT6+SPTIS5u+KiRzhn+Qkq/GST6wF
         vcbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9WG6cMl/gBqW9/dUbHwS2oVdtkU/FExq1G0KUcb14jY=;
        b=KrOclxcp7w4NrK3bNgmT8m2KEux/G09p3UcCdPKeXF7trZhAjfnBoP0EF+wWwyzhCG
         0sJ8pu7mBiu64qkU3xYc1BuHtMwQT5kiOitfFmv9jjNRtd+cZxsAGlNbn+i5WP8e3hOg
         JsBnYJqdUh7Akve90BIDTTs2btJAm9s3EnwmdLeevCQceZKKPKPoSLmdW+PrAzZ2pOIC
         gEnfkifKwNzvr4KkBWqQ73xlP3HKNccenuUkTeX8aAMfx+eLatd9drYLe/nJwG7HioSe
         yOLziM/8CX/97hyynaEtb1rLyXiLzeisLE+F8Gbpr4LJxoNfC2k50Y7+sE+tOJllxk5N
         TMfA==
X-Gm-Message-State: APjAAAXanVk8aLrsV6tBBHoltH6zGYQ8SKiahANv6FbSMJtuAZ0lNAuq
        CbnUE8ipz0ZBx8XI5HWxsaOtzQ==
X-Google-Smtp-Source: APXvYqw9prMNJXbxcMC1OGev6zxSBvn2cIFI4HSsRJFfEVYIueUL/4DU13iMZDTVUiUkXEokk7+BoQ==
X-Received: by 2002:a19:4318:: with SMTP id q24mr1327561lfa.12.1574119180107;
        Mon, 18 Nov 2019 15:19:40 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a8sm8789626ljb.11.2019.11.18.15.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 15:19:39 -0800 (PST)
Date:   Mon, 18 Nov 2019 15:19:27 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Adi Suresh <adisuresh@google.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>
Subject: Re: [PATCH net] gve: fix dma sync bug where not all pages synced
Message-ID: <20191118151927.14b103b0@cakuba.netronome.com>
In-Reply-To: <20191118223630.7468-1-adisuresh@google.com>
References: <20191118223630.7468-1-adisuresh@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Nov 2019 14:36:30 -0800, Adi Suresh wrote:
> The previous commit "Fixes DMA synchronization" had a bug where the

Please use the standard way of quoting commits.

> last page in the memory range could not be synced. This change fixes
> the behavior so that all the required pages are synced.
> 

Please add a Fixes tag.

> Signed-off-by: Adi Suresh <adisuresh@google.com>
> Reviewed-by: Catherine Sullivan <csully@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve_tx.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
> index 0a9a7ee2a866..89271380bbfd 100644
> --- a/drivers/net/ethernet/google/gve/gve_tx.c
> +++ b/drivers/net/ethernet/google/gve/gve_tx.c
> @@ -393,12 +393,12 @@ static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
>  static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
>  				    u64 iov_offset, u64 iov_len)
>  {
> -	dma_addr_t dma;
> -	u64 addr;
> +	u64 last_page = (iov_offset + iov_len - 1) / PAGE_SIZE;
> +	u64 first_page = iov_offset / PAGE_SIZE;
> +	u64 page;
>  
> -	for (addr = iov_offset; addr < iov_offset + iov_len;
> -	     addr += PAGE_SIZE) {
> -		dma = page_buses[addr / PAGE_SIZE];
> +	for (page = first_page; page <= last_page; page++) {
> +		dma_addr_t dma = page_buses[page];

Empty line after variable declaration. Perhaps keep the dma declaration
outside the loop, since this is a fix the smaller the better.

>  		dma_sync_single_for_device(dev, dma, PAGE_SIZE, DMA_TO_DEVICE);
>  	}
>  }

