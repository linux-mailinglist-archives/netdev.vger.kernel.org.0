Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D257110DD7
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfEAUT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:19:28 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35511 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfEAUT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 16:19:27 -0400
Received: by mail-ot1-f66.google.com with SMTP id g24so123073otq.2;
        Wed, 01 May 2019 13:19:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=pWjiQFV3UJniVf7i9GQdkFxM1mLNQy5apvQLEnb/wcA=;
        b=XT8kSi7FStTspSJhrHhowV4YV87QWx3IoXw8viq3VZsJIyenPoK10/Y30plqk//gx6
         RKCRVFMrjzpv16pf9HZubSxQbddDtdEvrYB+liXndKWiW0PG2zMtEVvpMU5qhVhRUmNv
         1n1VhHAUw6cWXUo3qPQniH20RWvAvokDiy5V31NZsxhCm4O4OJCtdbzjFM652tkIjq7g
         u2W3g1J6OtsReuwUdEJllAMDHeHehtvqgQQk0eyy3tKADIJtbMUVbyBdJTusLr9wIj2T
         rAjsYS4C0p3Dc88E+ckT2YotutXRdm8ajNrwD5y9whumABBfWWn9a2b1i0NDxmWr0/7E
         cWYw==
X-Gm-Message-State: APjAAAXPnwhqqhSNwwAo1Vc1Wya9Rvoje4lu0rJ3Ig+OChWTndswe8/Z
        TaVtXC3iSSj3S0MCuT3yJQ==
X-Google-Smtp-Source: APXvYqw5MFY6FhUc4sy5hYLKwSVXvm613zjKKo4m1Gvry7731V5ByvnaY6LCX29jU2nFksffTD10oQ==
X-Received: by 2002:a05:6830:1647:: with SMTP id h7mr12775386otr.360.1556741966617;
        Wed, 01 May 2019 13:19:26 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 2sm16316487ots.22.2019.05.01.13.19.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 May 2019 13:19:25 -0700 (PDT)
Date:   Wed, 1 May 2019 15:19:25 -0500
From:   Rob Herring <robh@kernel.org>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Alban Bedel <albeu@free.fr>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>
Subject: Re: [PATCH v2 1/4] of_net: Add NVMEM support to of_get_mac_address
Message-ID: <20190501201925.GA15495@bogus>
References: <1556456002-13430-1-git-send-email-ynezz@true.cz>
 <1556456002-13430-2-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1556456002-13430-2-git-send-email-ynezz@true.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 02:53:19PM +0200, Petr Štetiar wrote:
> Many embedded devices have information such as MAC addresses stored
> inside NVMEMs like EEPROMs and so on. Currently there are only two
> drivers in the tree which benefit from NVMEM bindings.
> 
> Adding support for NVMEM into every other driver would mean adding a lot
> of repetitive code. This patch allows us to configure MAC addresses in
> various devices like ethernet and wireless adapters directly from
> of_get_mac_address, which is already used by almost every driver in the
> tree.
> 
> Predecessor of this patch which used directly MTD layer has originated
> in OpenWrt some time ago and supports already about 497 use cases in 357
> device tree files.
> 
> Cc: Alban Bedel <albeu@free.fr>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: John Crispin <john@phrozen.org>
> Signed-off-by: Petr Štetiar <ynezz@true.cz>
> ---
> 
>  Changes since v1:
> 
>   * moved handling of nvmem after mac-address and local-mac-address properties
> 
>  drivers/of/of_net.c | 42 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
> index d820f3e..8ce4f47 100644
> --- a/drivers/of/of_net.c
> +++ b/drivers/of/of_net.c
> @@ -8,6 +8,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/kernel.h>
>  #include <linux/of_net.h>
> +#include <linux/of_platform.h>
>  #include <linux/phy.h>
>  #include <linux/export.h>
>  
> @@ -47,12 +48,45 @@ static const void *of_get_mac_addr(struct device_node *np, const char *name)
>  	return NULL;
>  }
>  
> +static const void *of_get_mac_addr_nvmem(struct device_node *np)
> +{
> +	int r;
> +	u8 mac[ETH_ALEN];
> +	struct property *pp;
> +	struct platform_device *pdev = of_find_device_by_node(np);
> +
> +	if (!pdev)
> +		return NULL;
> +
> +	r = nvmem_get_mac_address(&pdev->dev, &mac);
> +	if (r < 0)
> +		return NULL;
> +
> +	pp = kzalloc(sizeof(*pp), GFP_KERNEL);
> +	if (!pp)
> +		return NULL;
> +
> +	pp->name = "nvmem-mac-address";
> +	pp->length = ETH_ALEN;
> +	pp->value = kmemdup(mac, ETH_ALEN, GFP_KERNEL);
> +	if (!pp->value || of_add_property(np, pp))
> +		goto free;

Why add this to the DT? You have the struct device ptr, so just use 
devm_kzalloc() if you need an allocation.

> +
> +	return pp->value;
> +free:
> +	kfree(pp->value);
> +	kfree(pp);
> +
> +	return NULL;
> +}
> +
>  /**
>   * Search the device tree for the best MAC address to use.  'mac-address' is
>   * checked first, because that is supposed to contain to "most recent" MAC
>   * address. If that isn't set, then 'local-mac-address' is checked next,
> - * because that is the default address.  If that isn't set, then the obsolete
> - * 'address' is checked, just in case we're using an old device tree.
> + * because that is the default address.  If that isn't set, try to get MAC
> + * address from nvmem cell named 'mac-address'. If that isn't set, then the
> + * obsolete 'address' is checked, just in case we're using an old device tree.
>   *
>   * Note that the 'address' property is supposed to contain a virtual address of
>   * the register set, but some DTS files have redefined that property to be the
> @@ -77,6 +111,10 @@ const void *of_get_mac_address(struct device_node *np)
>  	if (addr)
>  		return addr;
>  
> +	addr = of_get_mac_addr_nvmem(np);
> +	if (addr)
> +		return addr;
> +
>  	return of_get_mac_addr(np, "address");
>  }
>  EXPORT_SYMBOL(of_get_mac_address);
> -- 
> 1.9.1
> 
