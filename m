Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF7A33DD34
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 20:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbhCPTR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 15:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236607AbhCPTRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 15:17:23 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC8CC061756
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 12:17:23 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x21so22878900eds.4
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 12:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yJC45Mn+RzMch54aRopaf8f4RskUe/2ksYXX6JxgcXQ=;
        b=YOPUQaYu61zNCEW0I+0VuGWO+jZ62N18lasnJhhq8o6+iiKFEp81+bfzEpT+OqjUgd
         6cerNAFAA/uu4CteS1WQ6L3IgnqlVZwoDtfYAtfxR9xGPdrdNnuXux8fHctjnVFTpMYQ
         gIYFau0JEJGmtVSLYofnl7zDMbxVjmrpemoU+viB43FH0mYKC47dNA5WeBc93Z/L6FB7
         M4djVFkpVgCs6I1BFXb6bZMcomTthdDmJkJxBf6Buq06raHBgINJ1Tg69iVv8OTsGIOe
         5ydS/tloN2nzi++WPGP+IWNMPT42Wjpp32gF8RjHMMGLr9Yz+A9g8fP4FZ3VKzCWxYAZ
         bJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yJC45Mn+RzMch54aRopaf8f4RskUe/2ksYXX6JxgcXQ=;
        b=newIaP4lZzpyLU7MNbvop/YhUN06IBdK1k3OsPln+UkxAfwymB9uEJlYUYPO7aOKvu
         UzNMWqLLoVcfYwj7jEHcQTaYNdTjflU3dS44Up6qf7X6eui3TgaBrUBQGSiAlpuRM82X
         8SKWdRBYnF+RT+gMi9eVXbygo7sPkT41uVy8lsTgI1lfTDw17JW+t3+iKmHx6lalwqpb
         tNROg/AFpvilEYqmd4AhVp53DVw3gKPC7BvnUFOnYVwEbd0AL06reiwvZ3w+NhcVH9Xu
         zDmtBYFSiyJ+eNceEThcrx4w2j4j9tHoqat8BkSPJu0GIEia4zgAGmYlpbWx6pAbmrfY
         id8w==
X-Gm-Message-State: AOAM532ve99+a+xugsubvb8noDvhWau8VgEgJZ69hSNnuQQXwiEFJvZp
        Bx13PzkCUMkfUazNuz93qNqKAA==
X-Google-Smtp-Source: ABdhPJx3nc9W89NaX4LY5YY+hb8Y5rL7nTk4bzJZK45Hjhw7No1srHgvS4l5fnzAg1n6yI/g+XSKkA==
X-Received: by 2002:aa7:de11:: with SMTP id h17mr4925753edv.83.1615922241789;
        Tue, 16 Mar 2021 12:17:21 -0700 (PDT)
Received: from holly.lan (cpc141216-aztw34-2-0-cust174.18-1.cable.virginm.net. [80.7.220.175])
        by smtp.gmail.com with ESMTPSA id lx6sm10006261ejb.64.2021.03.16.12.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 12:17:21 -0700 (PDT)
Date:   Tue, 16 Mar 2021 19:17:19 +0000
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v7 04/16] of: mdio: Refactor of_phy_find_device()
Message-ID: <20210316191719.d7nxgywwhczo7tyg@holly.lan>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
 <20210311062011.8054-5-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311062011.8054-5-calvin.johnson@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 11:49:59AM +0530, Calvin Johnson wrote:
> Refactor of_phy_find_device() to use fwnode_phy_find_device().
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

This patch series is provoking depmod dependency cycles for me and
it bisected down to this patch (although I think later patches in
the series add further cycles).

The problems emerge when running modules_install either directly or
indirectly via packaging rules such as bindeb-pkg.

~~~
make -j16 INSTALL_MOD_PATH=$PWD/modules modules_install
...
  INSTALL sound/usb/misc/snd-ua101.ko
  INSTALL sound/usb/snd-usb-audio.ko
  INSTALL sound/usb/snd-usbmidi-lib.ko
  INSTALL sound/xen/snd_xen_front.ko
  DEPMOD  5.12.0-rc3-00009-g1fda33bf463d
depmod: ERROR: Cycle detected: fwnode_mdio -> of_mdio -> fwnode_mdio
depmod: ERROR: Found 2 modules in dependency cycles!
~~~

Kconfig can be found here:
https://gist.github.com/daniel-thompson/6a7d224f3d3950ffa3f63f979b636474

This Kconfig file is for a highly modular kernel derived from the Debian
5.10 arm64 kernel config. I was not able to reproduce using the defconfig
kernel for arm64.


Daniel.


> ---
> 
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/net/mdio/of_mdio.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
> index d5e0970b2561..b5e0b5b22f1a 100644
> --- a/drivers/net/mdio/of_mdio.c
> +++ b/drivers/net/mdio/of_mdio.c
> @@ -360,18 +360,7 @@ EXPORT_SYMBOL(of_mdio_find_device);
>   */
>  struct phy_device *of_phy_find_device(struct device_node *phy_np)
>  {
> -	struct mdio_device *mdiodev;
> -
> -	mdiodev = of_mdio_find_device(phy_np);
> -	if (!mdiodev)
> -		return NULL;
> -
> -	if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
> -		return to_phy_device(&mdiodev->dev);
> -
> -	put_device(&mdiodev->dev);
> -
> -	return NULL;
> +	return fwnode_phy_find_device(of_fwnode_handle(phy_np));
>  }
>  EXPORT_SYMBOL(of_phy_find_device);
>  
