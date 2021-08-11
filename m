Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBBE3E8FA7
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 13:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbhHKLrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 07:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236679AbhHKLrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 07:47:52 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0451C061765;
        Wed, 11 Aug 2021 04:47:28 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id d11so3672657eja.8;
        Wed, 11 Aug 2021 04:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3HU9DvFBnTju4DLZdXq4Jv9gd2bJaKkbcMSzvEkfQ4s=;
        b=UAeNdhRG7GQN+0cF7ejPzdp4Ti6ufJtANqzjLaJvlZ/ZHuaGzgEt43XN4hj88JOs9Y
         VR+kdbY+MoXr4S5jd5lCe3Ym5MlNP2P7ldxUlBn3WEuwSTBtfSmfgqeXxbotSXAB5RsG
         nLbeG1FqTjpRr3nX+dC+jysCJUMXbxtL/s6IlqLM88QEX1nG/qZALg7td7sXRrZNX5BZ
         WfoiMQR7+mxxSJ36WapFj7Ch62Qptl0uUQ2FCPjOeD2pToj3vns3Y1idjK37Wm0JgbfM
         o3apbMOgDxNhP0cx+FhEoD5FRwTHhCgVsAAT0z47pnTw7MeFg9eFCeYVxDKKGlwIT4j8
         Ceuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3HU9DvFBnTju4DLZdXq4Jv9gd2bJaKkbcMSzvEkfQ4s=;
        b=VabsEy9xR3GHuSbMQekGxsBOcY7V0VS4F1G0GrSxF01aCBcGT0F+I33rqSoUINeDPw
         +Ii4AADcYrqCeOpsC03meJZ80uqjsXnjxAM1akjHkQ5H/0KJjnwuTRy2NQSdThlpmory
         vaViROVPSfwKLZSPIgyzFMmMKA3bMNglrhD4S8mIaHA1denXesUn9KEN2I7pajnzDCs0
         YqJN9M+EDD/ekSZyoQ6garPurvCBAncV9luIBD3BLurhqwH1L0ULCVhgoRH9hI0TBxWx
         QrvaNqG4VEQN60PRQiuyIs4WkNt5n50ggfQmFwLHPbxtP3cpZKq07w2LqmzIdTgIFiNm
         BO1g==
X-Gm-Message-State: AOAM532CXh6qj3fWxg5W449i2Pshv7kpwaD1n/p5M/OedwT3mH1XNTSj
        0vu1xs80vzYgi/1TiTOTHg/EIBiiaAM=
X-Google-Smtp-Source: ABdhPJw9GDi1ZpFJvGlifbU22+p3IvTC7kqu5ZxsZhDM2dOi0fmyKa3Th/DfINtv/YmIg7odKaQ5GA==
X-Received: by 2002:a17:906:a3d8:: with SMTP id ca24mr3216497ejb.533.1628682447015;
        Wed, 11 Aug 2021 04:47:27 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id f15sm8077972ejt.75.2021.08.11.04.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 04:47:26 -0700 (PDT)
Date:   Wed, 11 Aug 2021 14:47:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 1/1] net: pcs: xpcs: fix error handling on
 failed to allocate memory
Message-ID: <20210811114724.nr6qza3n7nknh7ew@skbuf>
References: <20210810085812.1808466-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810085812.1808466-1-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 04:58:12PM +0800, Wong Vee Khee wrote:
> Drivers such as sja1105 and stmmac that call xpcs_create() expects an
> error returned by the pcs-xpcs module, but this was not the case on
> failed to allocate memory.
> 
> Fixed this by returning an -ENOMEM instead of a NULL pointer.
> 
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> ---
>  drivers/net/pcs/pcs-xpcs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> index 63fda3fc40aa..4bd61339823c 100644
> --- a/drivers/net/pcs/pcs-xpcs.c
> +++ b/drivers/net/pcs/pcs-xpcs.c
> @@ -1089,7 +1089,7 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
>  
>  	xpcs = kzalloc(sizeof(*xpcs), GFP_KERNEL);
>  	if (!xpcs)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  
>  	xpcs->mdiodev = mdiodev;
>  
> -- 
> 2.25.1
> 

I know I changed my mind, but seeing that Intel's Alder Lake S patches
are likely going to stall for a while due to ungoing design discussions:
https://patchwork.kernel.org/project/netdevbpf/patch/20210809102229.933748-2-vee.khee.wong@linux.intel.com/
the net -> net-next merge might not be so far in the future after all.

So could this patch be applied to the "net" tree after all? According to
the cadence of the last 2 net -> net-next merges, which were on Jul 31
and Aug 5, the next one should be soon-ish.

The patch is fine:

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Fixes: 3ad1d171548e ("net: dsa: sja1105: migrate to xpcs for SGMII")
