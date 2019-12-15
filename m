Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D5E11F5B9
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 05:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfLOE1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 23:27:49 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36367 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfLOE1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 23:27:49 -0500
Received: by mail-pf1-f196.google.com with SMTP id x184so3735967pfb.3
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 20:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=kC7oENBrcIHmeqoO4HcWKA6Dp+aWK6pRUqc/0qg7pUM=;
        b=TyieL2OQ4XZsrRl5yaF3UEWOMglWvhXnMEQFrbNmrmX8uBuDO82i2j7r5XiLn4AS99
         Zxun8jeEiCbVO6AclIRMawu3nreKwHxpu6clGEr71XsNtKpKOMROWVDno4XrjzQOjY27
         5Qqv3TC5iY4omM4bcxkCNDys0gSUWvZgTL6pISPIKnmHxnAlRB+x2zvN+LOi6NYigEhZ
         +bxvMqwkWz8ri0vA7ZWGgN5Ub/bZe9+5B0CQ3mBQqWrcNNeXiLM/0mwpo+0LNwmj/MN3
         xv8/Pd5jyPMwuktacyRfTSCjUlYViL8Ms+WknpuQgLFpR7sZ7COdfHf2fJCNwtnn3r2S
         JFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kC7oENBrcIHmeqoO4HcWKA6Dp+aWK6pRUqc/0qg7pUM=;
        b=VAzENomcASdxclVuq1Uig8Z9YifNrJv7FJQrG3iOC1kAjCLoNq7gEt1TKjsXcIsOl1
         4mA5Mg+rnCWmcfW7OHuCS+evR6XtOab2t2srXMVN+wjN6dmH53QskN2a63YbXbbhK7jy
         aovpeOYzxDPRBFhBSlnBZMxHDHqpeVd4lLOOwb3YTWYVt+p4EI49fNFpjGh9T7hIs+I0
         bD+swSCfXQ8dQ3nZERqX7nx7L5Z3+40vqzgY0Q6w2qBA3gNTj9tDlyD7AcsJ6wCBfHBO
         W5xDiJYKWF30/hg8aAiGEm3JYEMhEWNYsiYb/Kxs1KRXEK/FZ7p1rdpcWL7YaxQ4LC/i
         +PHQ==
X-Gm-Message-State: APjAAAXNg4jGuzu/49+wbUEfx+T1KvADOpEGsU+QP6vneowd3YbODQrr
        4yfhDw3OOnZt0ye9AF81raTAsw==
X-Google-Smtp-Source: APXvYqxyw3l3xbVWatYuIC61DiT+3wlICRTm78v2DbKdh6jqkJnxRchGAbCJacXZKVo642Q1d0lFMw==
X-Received: by 2002:a63:f64a:: with SMTP id u10mr9766478pgj.16.1576384068814;
        Sat, 14 Dec 2019 20:27:48 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id h11sm15953529pgv.38.2019.12.14.20.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 20:27:48 -0800 (PST)
Date:   Sat, 14 Dec 2019 20:27:45 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Milind Parab <mparab@cadence.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: propagate phy_attach_direct()
 return code
Message-ID: <20191214202745.649bbed2@cakuba.netronome.com>
In-Reply-To: <E1ifS4S-000706-ON@rmk-PC.armlinux.org.uk>
References: <E1ifS4S-000706-ON@rmk-PC.armlinux.org.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 17:16:12 +0000, Russell King wrote:
> of_phy_attach() hides the return value of phy_attach_direct(), forcing
> us to return a "generic" ENODEV error code that is indistinguishable
> from the lack-of-phy-property case.
> 
> Switch to using of_phy_find_device() to find the PHY device, and then
> propagating any phy_attach_direct() error back to the caller.
> 
> Link: https://lore.kernel.org/lkml/20191210113829.GT25745@shell.armlinux.org.uk
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied thanks, the ref counting is not entirely obvious to a layman.
In your reply to Milind you said he can immediately of_node_put()
because the phy_dev is never deferenced in his code, but here it looks
like it is actually - the reference used to be given up after attach is
done, now its given up before attach_direct is called.

But I don't know how the refcounting here works, so applied, and on the
off chance the code is wrong follow up will be fine.

> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index f7c660bf99d1..8d20cf3ba0b7 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -859,14 +859,17 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
>  		return 0;
>  	}
>  
> -	phy_dev = of_phy_attach(pl->netdev, phy_node, flags,
> -				pl->link_interface);
> +	phy_dev = of_phy_find_device(phy_node);
>  	/* We're done with the phy_node handle */
>  	of_node_put(phy_node);
> -
>  	if (!phy_dev)
>  		return -ENODEV;
>  
> +	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
> +				pl->link_interface);
> +	if (ret)
> +		return ret;
> +
>  	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
>  	if (ret)
>  		phy_detach(phy_dev);

