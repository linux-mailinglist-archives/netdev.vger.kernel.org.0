Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579DF447E6F
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 12:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238938AbhKHLIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 06:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238937AbhKHLIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 06:08:00 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E095C061570;
        Mon,  8 Nov 2021 03:05:14 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d27so26152418wrb.6;
        Mon, 08 Nov 2021 03:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DwStbK3RkDE5mMWd/g0RKBI9MVvEJL/dRmmFtbZvBbw=;
        b=p2zInDakE0bXtpgmzVtWf/GEkKnU1lgwJopnm9I3jFqXITqawExS/dKDpX/q+LrjlL
         OgR3Dsv9e9MdRQycwsIvHAeplCCyFp0woZksSfzOqiW/Y6H8oz01kHYG91BEMgkIUWfC
         NRSlWPb9Eby5xm1ubI1joVKLD2FiboVwnOylljpuEOjjPhtJC974x0UhF5ywtcLGRqAV
         fGiL+keyB48st5ob15L76b/YXn577+ZT8tFNotje2yplwgr/XMtEfegRmgcYx506vNOS
         cvtUZr86us+Re9c21Z205+13FimtJa65GjaJ0ucd46qswlBlK+GqMJms6nr29sOx9hdd
         oblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=DwStbK3RkDE5mMWd/g0RKBI9MVvEJL/dRmmFtbZvBbw=;
        b=cFuUt1onSoYss819+FrBzaO4S6kqAMIrw60R5NATfrbku2k/R/obBbeoGieprPiHOk
         qqv8IBvLFdxXRBPOsZ9C+Ej1FbDxyfbW2Oe06YfWlCbjWDR3wAbj4SThRC6WPWs//nX3
         v3utfbY0QKfpBg3GIoPRH3nwunDfggXFolI4B+21lfIFe2d5RchtPhh8QNZzOTOBGseS
         aCg6c6tlwmQepZVGkUVplHkFbXD++XgL/ZiwNHuOGFe7olxzUF+MpemhPRD1AHSt3XSn
         UxxVd5zV+Ar31+IKUAV3pbG7MRFpqWdlWCQyqLJ9kzhCFLNcetvcPniqq9Gg/5h4u/f7
         foMg==
X-Gm-Message-State: AOAM531bthPmU++lDGmme9aEwYH14W0bWqnooHDhTyEcRUKy98n8PgX+
        FA3XHCv3x+GPzesu7I5sMZc=
X-Google-Smtp-Source: ABdhPJw6TnSOF8OLxiM0GA+jRtJvANkJzG7hmjyS2xEoUAS8WdIzVolqFFR3P9DzimJ3e7a0KdUj3Q==
X-Received: by 2002:a5d:4a44:: with SMTP id v4mr56635175wrs.246.1636369513184;
        Mon, 08 Nov 2021 03:05:13 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id r17sm16415094wmq.11.2021.11.08.03.05.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Nov 2021 03:05:12 -0800 (PST)
Date:   Mon, 8 Nov 2021 11:05:09 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     davidcomponentone@gmail.com
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, bhelgaas@google.com, yuehaibing@huawei.com,
        arnd@arndb.de, yang.guang5@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] sfc: use swap() to make code cleaner
Message-ID: <20211108110509.yjn4o22en2w22uwp@gmail.com>
Mail-Followup-To: davidcomponentone@gmail.com, ecree.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        bhelgaas@google.com, yuehaibing@huawei.com, arnd@arndb.de,
        yang.guang5@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
References: <20211104065350.1834911-1-yang.guang5@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104065350.1834911-1-yang.guang5@zte.com.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 02:53:50PM +0800, davidcomponentone@gmail.com wrote:
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
> opencoding it.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
> ---
>  drivers/net/ethernet/sfc/falcon/efx.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
> index c68837a951f4..314c9c69eb0e 100644
> --- a/drivers/net/ethernet/sfc/falcon/efx.c
> +++ b/drivers/net/ethernet/sfc/falcon/efx.c
> @@ -817,9 +817,7 @@ ef4_realloc_channels(struct ef4_nic *efx, u32 rxq_entries, u32 txq_entries)
>  	efx->rxq_entries = rxq_entries;
>  	efx->txq_entries = txq_entries;
>  	for (i = 0; i < efx->n_channels; i++) {
> -		channel = efx->channel[i];
> -		efx->channel[i] = other_channel[i];
> -		other_channel[i] = channel;
> +		swap(efx->channel[i], other_channel[i]);
>  	}

The braces are no longer needed. Remove those.

Martin

>  
>  	/* Restart buffer table allocation */
> @@ -863,9 +861,7 @@ ef4_realloc_channels(struct ef4_nic *efx, u32 rxq_entries, u32 txq_entries)
>  	efx->rxq_entries = old_rxq_entries;
>  	efx->txq_entries = old_txq_entries;
>  	for (i = 0; i < efx->n_channels; i++) {
> -		channel = efx->channel[i];
> -		efx->channel[i] = other_channel[i];
> -		other_channel[i] = channel;
> +		swap(efx->channel[i], other_channel[i]);
>  	}
>  	goto out;
>  }
> -- 
> 2.30.2
