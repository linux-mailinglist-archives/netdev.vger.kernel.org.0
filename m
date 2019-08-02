Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22D87FFF1
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 19:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436794AbfHBR7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 13:59:23 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39852 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406482AbfHBR7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 13:59:23 -0400
Received: by mail-pl1-f196.google.com with SMTP id b7so33969566pls.6
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 10:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OVqucGi6mCgtuzFb+mM0I54hdxnF7iQT16DRkPLbzfw=;
        b=CjA6pbUuaMPDMwcOs1NU1RiCZ3DR8v3r3TDpISfRp+sa+efn/P6rt3PH/uZnyP2ZnZ
         qriwMeECuq/cObFfAIzcDKwqO9kg5UXXdlagupGgYXVp1Nzi/TI2S8IS8UT/sY/wP4ct
         HjvPLaDl0To+ZtkRiw10XQrLFbXCLXCiBEIdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OVqucGi6mCgtuzFb+mM0I54hdxnF7iQT16DRkPLbzfw=;
        b=joj1C8jy5G6iHdnq0Ys4O3F2T8fFDwc5xTjGZPyEl+Vff/GEWcqTknedFqXB9uUirf
         5VZh+OR/PUYwsZTluOZ4iwvgJg7p9iEuJDacTnPjx30AmM8o16oBRwnPysNwYDV1wZNy
         +SGGZ/wUS103H2PqsHsqUsHFad/iB0LkLcYOLJs408xJBsq6G9myRoZ+36aKy9RbVGsl
         ALV4WBVQI8GYj15nHif7NOmJl32StsTicKdIgddLxFIM+sCzE7VvwHIjKHJB5m9i2NOK
         APdqB3FVsU1Crz6XthmSHyW8zvOVn4d21L/4HpSs68UkQ4V6dSCls4UVM8h8CY6gCH3v
         6nQA==
X-Gm-Message-State: APjAAAX9PfvpoVUeu7mN5VlmzmIj0VnmTqKKZWzGZi8V4mhzX/yoR9uZ
        E2fpf1IMPkZKprapKki55qASBQ==
X-Google-Smtp-Source: APXvYqwEB0rTsAhxiTa/i+1acy/zxoYQ//dir91uDgoORP0CSaaYnGoNXT6j/HgT+qMctyliELEGGg==
X-Received: by 2002:a17:902:204:: with SMTP id 4mr45618964plc.178.1564768762354;
        Fri, 02 Aug 2019 10:59:22 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id v184sm75225172pfb.82.2019.08.02.10.59.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 10:59:20 -0700 (PDT)
Date:   Fri, 2 Aug 2019 10:59:18 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v4 2/4] net: phy: Add function to retrieve LED
 configuration from the DT
Message-ID: <20190802175918.GK250418@google.com>
References: <20190801190759.28201-1-mka@chromium.org>
 <20190801190759.28201-3-mka@chromium.org>
 <20190802163810.GL2099@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190802163810.GL2099@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 06:38:10PM +0200, Andrew Lunn wrote:
> On Thu, Aug 01, 2019 at 12:07:57PM -0700, Matthias Kaehlcke wrote:
> > Add a phylib function for retrieving PHY LED configuration that
> > is specified in the device tree using the generic binding. LEDs
> > can be configured to be 'on' for a certain link speed or to blink
> > when there is TX/RX activity.
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > Changes in v4:
> > - patch added to the series
> > ---
> >  drivers/net/phy/phy_device.c | 50 ++++++++++++++++++++++++++++++++++++
> >  include/linux/phy.h          | 15 +++++++++++
> >  2 files changed, 65 insertions(+)
> > 
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 6b5cb87f3866..b4b48de45712 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -2188,6 +2188,56 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
> >  	return phydrv->config_intr && phydrv->ack_interrupt;
> >  }
> >  
> > +int of_get_phy_led_cfg(struct phy_device *phydev, int led,
> > +		       struct phy_led_config *cfg)
> > +{
> > +	struct device_node *np, *child;
> > +	const char *trigger;
> > +	int ret;
> > +
> > +	if (!IS_ENABLED(CONFIG_OF_MDIO))
> > +		return -ENOENT;
> > +
> > +	np = of_find_node_by_name(phydev->mdio.dev.of_node, "leds");
> > +	if (!np)
> > +		return -ENOENT;
> > +
> > +	for_each_child_of_node(np, child) {
> > +		u32 val;
> > +
> > +		if (!of_property_read_u32(child, "reg", &val)) {
> > +			if (val == (u32)led)
> > +				break;
> > +		}
> > +	}
> 
> Hi Matthias
> 
> This is leaking references to np and child. In the past we have not
> cared about this too much, but we are now getting patches adding the
> missing releases. So it would be good to fix this.

Good point, I'll fix it in the next revision.

Thanks

Matthias
