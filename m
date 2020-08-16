Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2432459B3
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 23:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgHPVuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 17:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgHPVuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 17:50:14 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72717C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 14:50:13 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id i26so10785953edv.4
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 14:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KbIaGpG6pbFS34uHjx3LlPhN6cjB1y3T7ba5E3IPC8Q=;
        b=IAfdEFfaXMpzp1dj653X7yVJYykYG+pJGpH+rQ2BI4qRb9XGmZjcxP0OeAqVg7TVUY
         a8C6vCAv83J+qSY2srdhikl7PuCPQ34+Cruhp4a3mVEXNxmKWO032hLTKCp8ZXFYvszu
         xou9KV9r7oJxjhdnzTX/b9K7hPgpkRBScoa9Mc7nJ86Xxky6N5tnIjXe8Z4cjYT0AHnE
         Nv8G8YzBr4yqwpK5biRKTeIdZtcdvz4dBIJeCq/F2gYc42WEH7hZRY+x3p01XIgYQG5z
         1Gl4gJnu3Zibb/DEzXsjOeW44YW8/44AFUYJszutlYMQBALchAEdDr599rnxeTWFdY+K
         K0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KbIaGpG6pbFS34uHjx3LlPhN6cjB1y3T7ba5E3IPC8Q=;
        b=R1QkZs5qtVQf8aAA60yGY30vH1B+2E5K0Wb5UCCwcrh0Lp0JGk+OlEUz8sCR2NFhEX
         5APFBniQdqCV4f9L0g2tanpb+gu/LpjIwpmv/JkvynfCzSuGWPBrIB6Qou2jtZz0XAX0
         sN/A0q4gt/4VmgANRnlULxV3vrzbDzOE/7G7eJrHqZGL/BT9fAEbla4JKjCxqEunNPhx
         XSa25wrGGsvEh5Cd3r/vDFHtG6AI3pxfTVVXuI5xEAktDWXv5mhS9sX6f6xn78c4LN2p
         pb+aUL89QKHQ4sDK/VgZYD1eGOjTdhO1EEim/A6GeOcMhLNP5JkNKPjin/xy0QIO7TKd
         7FuQ==
X-Gm-Message-State: AOAM530iXJ0EMRD7N0erw47MFgXQUJPsugbP7bf0yxCB300FSm9PokU0
        O8vS40gXfYxfuuaBq0M7L6U=
X-Google-Smtp-Source: ABdhPJyIH+jWZRQVKYZEaZE4O+K2pldsRrE5O4rr/sb/DoLUhlG22pQry39o04pkP4wAxipA7+wN6g==
X-Received: by 2002:a50:fc0a:: with SMTP id i10mr12491006edr.5.1597614612193;
        Sun, 16 Aug 2020 14:50:12 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id u6sm13032843ejf.98.2020.08.16.14.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2020 14:50:11 -0700 (PDT)
Date:   Mon, 17 Aug 2020 00:50:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 2/7] net: dsa: Add devlink regions support to DSA
Message-ID: <20200816215009.m7ovmuwjme3lrl4g@skbuf>
References: <20200816194316.2291489-1-andrew@lunn.ch>
 <20200816194316.2291489-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816194316.2291489-3-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 09:43:11PM +0200, Andrew Lunn wrote:
> Allow DSA drivers to make use of devlink regions, via simple wrappers.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/net/dsa.h |  6 ++++++
>  net/dsa/dsa.c     | 16 ++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 63ff6f717307..8963440ec7f8 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -660,6 +660,12 @@ void dsa_devlink_resource_occ_get_register(struct dsa_switch *ds,
>  					   void *occ_get_priv);
>  void dsa_devlink_resource_occ_get_unregister(struct dsa_switch *ds,
>  					     u64 resource_id);
> +struct devlink_region *
> +dsa_devlink_region_create(struct dsa_switch *ds,
> +			  const struct devlink_region_ops *ops,
> +			  u32 region_max_snapshots, u64 region_size);
> +void dsa_devlink_region_destroy(struct devlink_region *region);
> +
>  struct dsa_port *dsa_port_from_netdev(struct net_device *netdev);
>  
>  struct dsa_devlink_priv {
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index 86351da4e202..fea2efe5fe68 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -412,6 +412,22 @@ void dsa_devlink_resource_occ_get_unregister(struct dsa_switch *ds,
>  }
>  EXPORT_SYMBOL_GPL(dsa_devlink_resource_occ_get_unregister);
>  
> +struct devlink_region *
> +dsa_devlink_region_create(struct dsa_switch *ds,
> +			  const struct devlink_region_ops *ops,
> +			  u32 region_max_snapshots, u64 region_size)
> +{
> +	return devlink_region_create(ds->devlink, ops, region_max_snapshots,
> +				     region_size);
> +}
> +EXPORT_SYMBOL_GPL(dsa_devlink_region_create);
> +
> +void dsa_devlink_region_destroy(struct devlink_region *region)
> +{
> +	devlink_region_destroy(region);
> +}
> +EXPORT_SYMBOL_GPL(dsa_devlink_region_destroy);
> +
>  struct dsa_port *dsa_port_from_netdev(struct net_device *netdev)
>  {
>  	if (!netdev || !dsa_slave_dev_check(netdev))
> -- 
> 2.28.0
> 

Could we perhaps open-code these from the drivers themselves? There's
hardly any added value in DSA providing a "helper" for creation of
devlink resources (regions, shared buffers, etc).

Take the ocelot/felix driver for example. It is a DSA driver whose core
functionality is provided by drivers/net/ethernet/mscc/ocelot*.c, which
is non-DSA code. If it were to implement devlink regions, presumably
that code would live in drivers/net/ethernet/mscc/ and not in
drivers/net/dsa/.

Thanks,
-Vladimir
