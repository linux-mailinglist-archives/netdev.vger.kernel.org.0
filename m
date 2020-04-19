Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758DE1AFD3E
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgDSTAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgDSTAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 15:00:33 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73C9C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 12:00:32 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e26so8486928wmk.5
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 12:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=dbguNHWcX0WpD8Qi2EDyD45Mg2CX3DqqIAhxCK3ggM4=;
        b=Gn5ICBZna8X/ikaXqhylt5bvcKKmxKDftFrwJbsRy/c75GlY+hA1hKt/xacUGJG6Hy
         //ghE1nPj6WPlOew2yRBuSiDiKNbHd9EZVMQD2sQ9nJxzBlBskoasVPxs4X+mT8ZunVr
         3iQc4nQ+vP7IhQSmHR0anIGuUSqqLT9yXB3ro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=dbguNHWcX0WpD8Qi2EDyD45Mg2CX3DqqIAhxCK3ggM4=;
        b=R193LTEQ40SZi9iAgT6ooFRnQHx0iNAdHNqCaFuzxAnVO0AVtTzyoYHMzeDplXyxlM
         VKcBZCUfBBQNhRSlAV7IFlWxQoVb2kWoY4r7c4KzYJu43npcaCwRMuHGrNlQhd0HXFaA
         WhXNsOp7j47tNRSquvEzeX711CbcP3X8rNMyJXPgM1LQOfneR0oDfQ8yqOSPnSS3+jgi
         Voy69ip6jVgWxYF+4+CCWYPnIqSeqYj4L4QW2XJOuLdeZ000YzW/3SmRzRJWvoWLrAsC
         jtIArSrLHlz1IFsgBrYTpHYaudlPJcoqF/QUOPvgIrsyJc4nvTCWF2T/+ZQ0rUTeUxij
         vSSg==
X-Gm-Message-State: AGi0PuYxPf5e4Ep99VbODJOjxWfRYjdM4dUuiRBWeE5wqJCbtVHKJpYt
        U4TPAU94Kksezgh3OqfoPKe+sw==
X-Google-Smtp-Source: APiQypK0Tg8j9I7eoqCF3fHFUvDiIgShrTnT+ccFYA0TQdZ8pvtl29UwlDpF0tfmHbpPlWgvb3Eeuw==
X-Received: by 2002:a1c:1f8e:: with SMTP id f136mr13394292wmf.166.1587322831285;
        Sun, 19 Apr 2020 12:00:31 -0700 (PDT)
Received: from carbon ([94.26.108.4])
        by smtp.gmail.com with ESMTPSA id x13sm16974899wmc.5.2020.04.19.12.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2020 12:00:30 -0700 (PDT)
Date:   Sun, 19 Apr 2020 22:00:29 +0300
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/3] r8169: use WRITE_ONCE instead of dma_wmb
 in rtl8169_mark_to_asic
Message-ID: <20200419190029.GA37084@carbon>
Mail-Followup-To: Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
 <612105ff-f21d-40c4-2b02-0ac0c12615fb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <612105ff-f21d-40c4-2b02-0ac0c12615fb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-04-19 20:16:21, Heiner Kallweit wrote:
> We want to ensure that desc->opts1 is written as last descriptor field.
> This doesn't require a full compiler barrier, WRITE_ONCE provides the
> ordering guarantee we need.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 2fc65aca3..3e4ed2528 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -3892,11 +3892,9 @@ static inline void rtl8169_mark_to_asic(struct RxDesc *desc)
>  {
>  	u32 eor = le32_to_cpu(desc->opts1) & RingEnd;
>  
> -	desc->opts2 = 0;
> -	/* Force memory writes to complete before releasing descriptor */
> -	dma_wmb();

If dma_wmb() was really ever needed here you should leave it even after you 
order these writes with WRITE_ONCE().  If not, then good riddance.

Just saying, i am not familiar with the hardware nor with the driver. :)


		Petko


> -
> -	desc->opts1 = cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE);
> +	/* Ensure ordering of writes */
> +	WRITE_ONCE(desc->opts2, 0);
> +	WRITE_ONCE(desc->opts1, cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE));
>  }
>  
>  static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
> @@ -3919,7 +3917,7 @@ static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
>  		return NULL;
>  	}
>  
> -	desc->addr = cpu_to_le64(mapping);
> +	WRITE_ONCE(desc->addr, cpu_to_le64(mapping));
>  	rtl8169_mark_to_asic(desc);
>  
>  	return data;
> -- 
> 2.26.1
> 
> 
