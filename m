Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65361456766
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbhKSBXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbhKSBXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 20:23:17 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68964C061574;
        Thu, 18 Nov 2021 17:20:16 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z5so35475761edd.3;
        Thu, 18 Nov 2021 17:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E34HgiCaOFVX+GifFvP+LbUSQRcs2toReX/WIG/3s+M=;
        b=iiOa1TSm6JpJYSFdcKSWVTNMZrWt5RwUgeg/KcSvn032dKjDPZDRorWNPLiHpQszKN
         dQk9e3pIkI1rzO/rsbXN/B2LlkOroO8aUNcrlCet+IuJH/QBmt6CEJ11fDxC5gnc0hcv
         kzoHaTrOxrqpVp1xlNynE/njf0TPpNavM3x6sTs9D/rDaQ7bF6IFJpAANQoIfQ67uo/t
         7FVdim2bPnqfgUz+RsKrVtsqn9mK03kv4Ct8luqjBKOb2/Q8lDgFP/XNtgGV3RsY0TpG
         UtPvD5ISirMWOC9tedreW2i98uP29fr75VsLNwXh8Puld6JVGpjq+/Lt2ySpntaYC7si
         xyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E34HgiCaOFVX+GifFvP+LbUSQRcs2toReX/WIG/3s+M=;
        b=oeFiBcw8gKoDjghuU0/UEylw56xupq/v8q/JND9VRKVsYLGQCJjtBQ7sbRVcB4Ku48
         5MBLgOCbuf9quHh198MCOYt8P7mllTWgD4dC3OHNjIacrqT+ZquJpKG/p+wsYSx90lEA
         5BHYgCGOJT8Hpy1S9SYkY1pslpmMtLZfJ1SFDneac3i7kCkV6ROdG82/PQe0SDweL+z9
         VYt9ZsgF94UyK8v4VnTOgVmq164JirouXR1rN19cIbE1mcGMfj2fuGbclO0d12GCp4Il
         w4eRdDLR4OLB4SbLTUlSH9gujT3lVW+/JMoB9l/Im1dbZyJZ6P5g+8/6iJJNW6JRDqCd
         7dpQ==
X-Gm-Message-State: AOAM531lFmb6Rz/caVXar6wXeQgU4TkBbXraiF8NhumIQaqqyQ9U9AnX
        hU3l1MfITXYHTzMzUgU2v+4=
X-Google-Smtp-Source: ABdhPJx6j/zLyHHBtbOifYXNZ42IWX0f5Gd0VIq+Wx8EmhCJyVYbHnCQcbFw9SHVsi1RYB86pdcT4g==
X-Received: by 2002:a50:da0a:: with SMTP id z10mr18232038edj.298.1637284814981;
        Thu, 18 Nov 2021 17:20:14 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id f16sm787101edd.37.2021.11.18.17.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:20:14 -0800 (PST)
Date:   Fri, 19 Nov 2021 03:20:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 10/19] net: dsa: qca8k: add support for port
 fast aging
Message-ID: <20211119012013.e4a74lretsxz66sb@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-11-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-11-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:42PM +0100, Ansuel Smith wrote:
> The switch doesn't support fast aging but it does support the flush of
> the ARL table for a specific port. Add this function to simulate
> fast aging and proprely support stp state set.
                 ~~~~~~~~                   ~~~
                 properly                   verb? noun? what are you saying here?

What difference do you see between fast ageing and ARL table flushing
for a specific port?

> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index cf4f69b36b47..d73886b36e6a 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1823,6 +1823,16 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
>  			   QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
>  }
>  
> +static void
> +qca8k_port_fast_age(struct dsa_switch *ds, int port)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +
> +	mutex_lock(&priv->reg_mutex);
> +	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH_PORT, port);
> +	mutex_unlock(&priv->reg_mutex);
> +}
> +
>  static int
>  qca8k_port_enable(struct dsa_switch *ds, int port,
>  		  struct phy_device *phy)
> @@ -2031,6 +2041,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.port_stp_state_set	= qca8k_port_stp_state_set,
>  	.port_bridge_join	= qca8k_port_bridge_join,
>  	.port_bridge_leave	= qca8k_port_bridge_leave,
> +	.port_fast_age		= qca8k_port_fast_age,
>  	.port_fdb_add		= qca8k_port_fdb_add,
>  	.port_fdb_del		= qca8k_port_fdb_del,
>  	.port_fdb_dump		= qca8k_port_fdb_dump,
> -- 
> 2.32.0
> 
