Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927A62A0CB3
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbgJ3RpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbgJ3RpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 13:45:09 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D84962076D;
        Fri, 30 Oct 2020 17:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604079909;
        bh=coCpvbSNlgSLI30nQVg9545TIYWROCvhvr+VAQBwwPM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=edtPBagA/Vxq0TXgC6fSuO3qEYK5Mgq5YEikOQ4VPE9ZOU9LzH61KgpiKu3jOS7U+
         /tRWMGBZIWw8BYjQvRYceJFKikfn+O4ye+XkDzb51WXBkXxzhqCSKsBDevtCgYhVJo
         lOQDDHpi22fakCfI8OlYLFjThpdrm9EfrmNtILI0=
Date:   Fri, 30 Oct 2020 10:45:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "Heiner Kallweit" <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3] net: phy: leds: Deduplicate link LED trigger
 registration
Message-ID: <20201030104507.4ec89ce3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201027182146.21355-1-andriy.shevchenko@linux.intel.com>
References: <20201027182146.21355-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 20:21:46 +0200 Andy Shevchenko wrote:
> Refactor phy_led_trigger_register() and deduplicate its functionality
> when registering LED trigger for link.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied..

> @@ -119,7 +114,7 @@ int phy_led_triggers_register(struct phy_device *phy)
>  
>  	for (i = 0; i < phy->phy_num_led_triggers; i++) {
>  		err = phy_led_trigger_register(phy, &phy->phy_led_triggers[i],
> -					       speeds[i]);
> +					       speeds[i], phy_speed_to_str(speeds[i]));

after wrapping this to 80 chars.

