Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3627D2DEA25
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730162AbgLRUZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 15:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbgLRUZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 15:25:26 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E722FC0617A7;
        Fri, 18 Dec 2020 12:24:45 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id 6so5034021ejz.5;
        Fri, 18 Dec 2020 12:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KmZwA9sFuoGFH8swfww22Ud6VHWImiRk8xi92zAVi9U=;
        b=I4Ht8DvArejZH85a2JfDifAruxalIdggu2ndzsYuTY420eELaLk20cfgW4A6hm0EXh
         WiyvNeMeaJ7iu/fIW7gQqYFYZGFqz0Yw2he7SyVAVUAEPslkEguQydhGRjUI69kRXMoz
         YdZ0NKcaqDgWZqI5P0mIPfWIeHq5LLSS+GBRvR89rXAhbslkBXzx7Au9P5YeSOggPOW9
         WlyJvtI2AaB2ZdbUuvjAVFUCK5bxw8SsEODL/32BFq7dxLOBbYLx+pgasztjZpDT5WX+
         rEJcMQB7zNcXbP1zKEcrdw39hSgzkaj5/IU74I3bKOMTcA+VTrwtT15iKSzeQJH8T48J
         Z5KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KmZwA9sFuoGFH8swfww22Ud6VHWImiRk8xi92zAVi9U=;
        b=njMM2vnnlnBuPtBYG0w5aY29/OQbz9h4e1W8y7sQ0SyHyp7YaHN0ynjxKIcVWuxddZ
         PKjFAlxabU/EmMoeUXXOI341cv6oVZbwH3dmhBFNv5m6PobKWWn6LFs38tYQoWurU7xx
         c8nsuRDsmx2+h9zyUM76MLLOzD3Z0LB+6GbMFC9L4t0PMoB6yT4thivLOIk0cCM1PIxN
         oEBwzQECoXPP4wiFQYGGxFfWKIwdqxY1IqM/ArMBdpNe6NCVq1StKatUuE6TTqTZWI9O
         aJ4bJZyKIMU69bqFk2scuKHpAZ4T0DKrGauVmceAL97s5sV1MUfzBjcGHtpcdxT25i0o
         nkLQ==
X-Gm-Message-State: AOAM530UnXxeZz7I2RkKw/e1QPZVt3CIHfuiXlLfe5Klx/VV/JgigzGE
        vy9QLSx/vYJ6F3MQ6QyWGJY=
X-Google-Smtp-Source: ABdhPJw6Qo007oxxLzbqbBiYwjiHUFo5/XhdmeHlWxAQzkO92Ow/13FGm+UsjxBhsufZmIxHfmuWqA==
X-Received: by 2002:a17:906:848:: with SMTP id f8mr5610550ejd.404.1608323083387;
        Fri, 18 Dec 2020 12:24:43 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id e11sm25230016edj.44.2020.12.18.12.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 12:24:42 -0800 (PST)
Date:   Fri, 18 Dec 2020 22:24:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "open list:BROADCOM SYSTEMPORT ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: systemport: set dev->max_mtu to
 UMAC_MAX_MTU_SIZE
Message-ID: <20201218202441.ppcxswvlix3xszsn@skbuf>
References: <20201218173843.141046-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218173843.141046-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Fri, Dec 18, 2020 at 09:38:43AM -0800, Florian Fainelli wrote:
> The driver is already allocating receive buffers of 2KiB and the
> Ethernet MAC is configured to accept frames up to UMAC_MAX_MTU_SIZE.
> 
> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bcmsysport.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
> index 0fdd19d99d99..b1ae9eb8f247 100644
> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
> @@ -2577,6 +2577,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
>  			 NETIF_F_HW_VLAN_CTAG_TX;
>  	dev->hw_features |= dev->features;
>  	dev->vlan_features |= dev->features;
> +	dev->max_mtu = UMAC_MAX_MTU_SIZE;
>  
>  	/* Request the WOL interrupt and advertise suspend if available */
>  	priv->wol_irq_disabled = 1;
> -- 
> 2.25.1
> 

Do you want to treat the SYSTEMPORT Lite differently?

	/* Set maximum frame length */
	if (!priv->is_lite)
		umac_writel(priv, UMAC_MAX_MTU_SIZE, UMAC_MAX_FRAME_LEN);
	else
		gib_set_pad_extension(priv);
