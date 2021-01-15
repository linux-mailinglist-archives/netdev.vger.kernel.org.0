Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379122F7767
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 12:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbhAOLQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 06:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbhAOLQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 06:16:06 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F256EC0613D3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 03:15:25 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id jx16so12709673ejb.10
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 03:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2+Oguceb/ilLtJRPkMY7L0JsntEwIe6EeBLE3sFVLXA=;
        b=lI9LkTpYVvmW5EXya+8JsQQcGyBDezIS2SewtULyyKz3kYXL/LLIn5Ax7gRzRX2YVb
         hsmxrYNRIpGz25PT4Cw9tfq7xl4YQ+Z+yqcMaa5dfL6jC1VFSIQ10vMiutuBCUNwNr3w
         JM4OMoGMBD5+DjNUtRa3b9ZjUpYwOAHzaYqjvDSLF0PKwMbyaoG1/O8+aeG9qdCn/a6H
         KgVODhd+tzQWeykyzT3Bn98AvaEe102bvokhE9mgBGymI0hByLZj7ouNjURklFXI+WMD
         K33VT+06qlrUJAzhMgRegw06GHLGg+BAUY/WrFkuNhggnaSgmShMhmwMvT+X13Wegjnf
         V5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2+Oguceb/ilLtJRPkMY7L0JsntEwIe6EeBLE3sFVLXA=;
        b=ZJgWtm/JgEn31oKsbXWHV+34+OuXNqUmDh5kXBeiKXCd1gGROoXFYH3C3QkPSrC4Er
         hwsqQLW0pirj+McSK2EBXbbemLDAxz+I1XMOGCjDDgRdLaMYXQNoY2FK11//Xj389nri
         PGroSUVFf/+nkYNHhjgwZsb6ps1mzjdbH3Daa6vc9cuJvPzaHQZn1k7fDFgWqFGV5wDL
         Slf+hazIIztgOs6BPqkrFBTHWL/aZgVoGdzvJamTBKdNYaA8LQSd0ppoMVAxpbp5oDUZ
         245raqVIKlyErY1SPPUWWuHJASJGtoMmVuV6d2mFavV88LOJi1rSq+0y/nnzSsEkuGs5
         YuAA==
X-Gm-Message-State: AOAM532fnwPpd0qQ3mXxOs3VRp++aejR6JJibBsOMX4w9KOveT6HjvQ/
        u0wRCmKgogcO/iphOiExwtY=
X-Google-Smtp-Source: ABdhPJysDIklWjzvX4TkZ80x1gLWTQ8xT4THXHWotN0ezdBzqg/Hs+E5Y1meCkf5qBuRDWfY/kvWrQ==
X-Received: by 2002:a17:906:a20e:: with SMTP id r14mr5735797ejy.404.1610709324660;
        Fri, 15 Jan 2021 03:15:24 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s22sm2819611ejd.106.2021.01.15.03.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 03:15:24 -0800 (PST)
Date:   Fri, 15 Jan 2021 13:15:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Only allow LAG offload
 on supported hardware
Message-ID: <20210115111523.64itmntrl2ykn43x@skbuf>
References: <20210115105834.559-1-tobias@waldekranz.com>
 <20210115105834.559-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115105834.559-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 11:58:34AM +0100, Tobias Waldekranz wrote:
> There are chips that do have Global 2 registers, and therefore trunk
                       ~~
                       do not
> mapping/mask tables are not available. Additionally Global 2 register
> support is build-time optional, so we have to make sure that it is
> compiled in.
> 
> Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 4 ++++
>  drivers/net/dsa/mv88e6xxx/chip.h | 9 +++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index dcb1726b68cc..c48d166c2a70 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -5385,9 +5385,13 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
>  				      struct net_device *lag,
>  				      struct netdev_lag_upper_info *info)
>  {
> +	struct mv88e6xxx_chip *chip = ds->priv;
>  	struct dsa_port *dp;
>  	int id, members = 0;
>  
> +	if (!mv88e6xxx_has_lag(chip))
> +		return false;
> +
>  	id = dsa_lag_id(ds->dst, lag);
>  	if (id < 0 || id >= ds->num_lag_ids)
>  		return false;
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 3543055bcb51..333b4fab5aa2 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -662,6 +662,15 @@ static inline bool mv88e6xxx_has_pvt(struct mv88e6xxx_chip *chip)
>  	return chip->info->pvt;
>  }
>  
> +static inline bool mv88e6xxx_has_lag(struct mv88e6xxx_chip *chip)
> +{
> +#if (defined(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2))
> +	return chip->info->global2_addr != 0;
> +#else
> +	return false;
> +#endif
> +}
> +

Should we also report ds->num_lag_ids = 0 if !mv88e6xxx_has_lag()?

>  static inline unsigned int mv88e6xxx_num_databases(struct mv88e6xxx_chip *chip)
>  {
>  	return chip->info->num_databases;
> -- 
> 2.17.1
> 
