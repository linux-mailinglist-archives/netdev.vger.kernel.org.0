Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08814557A03
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 14:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiFWMIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 08:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiFWMIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 08:08:45 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF424B403;
        Thu, 23 Jun 2022 05:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1655986122; x=1687522122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9/CCr0snWfftSFhkeAYUhF2+vCU0/VTKAyn0ef5b+1M=;
  b=RfLwjfKgpEQJskz0RHl1y/wsjOtM21oPgA41GOcm36Prlk0L+V6Lt+ae
   jxD/4pLS5An/DikbhT92gC1r0r3pZlHOir14EHNaWyaX6585ZZoI5+tc6
   eam11olTQOYvdbXOq+Xu9iSL3RsSWyZDBJ+kxstTdCyOrw+3c+Rlzm/To
   ZgjU4ZAVxLK/nSgHoKbv9o1zeFfONkeabUw22LWSSeGD/ndYGt0jRpzJH
   A/D4nJ8F5GiI6828iI9n3umJFtbZnfGSguJB1xsMMAvpEiFXXVUjBsK9J
   kcObcbG9vysqfGvdILhrn9dnYrbAuw4H38YiOudt78jtrRD3Hw2FJTIUR
   A==;
X-IronPort-AV: E=Sophos;i="5.92,216,1650924000"; 
   d="scan'208";a="24631790"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 23 Jun 2022 14:08:39 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 23 Jun 2022 14:08:39 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Thu, 23 Jun 2022 14:08:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1655986119; x=1687522119;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9/CCr0snWfftSFhkeAYUhF2+vCU0/VTKAyn0ef5b+1M=;
  b=HqDs5ssF8L1EkiBFh2ujtpvauytr8wW9ynjPp2xOnD4EQm4zS6BPcHVl
   lxCOGE9jVnfEHBD/8sdZQllqvQTP/1hCMj4QZY6SY4Dsotw+F09xiTIbq
   kPGuT6sVq23fcovCydMWi8mwrwIkHuq0JdWTnYE+8HL1BZeE7m/EB/0Z2
   jXy8EAKffPqzrkqqO6YcQzKY7pIfLm1sMMrgzEp3d8Y8kwIXrn9ZM9Ms+
   zqG3kEyie1oOETmmWcRSdR2GYyqnkSUJwZUXPsUDFrdSKw9PLlNJufhlU
   z97RAyDul51fuxwcMhrOWtYtivSC6bw3XtK+NKpUAday6W/pIZCXrl64Z
   w==;
X-IronPort-AV: E=Sophos;i="5.92,216,1650924000"; 
   d="scan'208";a="24631789"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 23 Jun 2022 14:08:39 +0200
Received: from steina-w.localnet (unknown [10.123.49.12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id C37F4280056;
        Thu, 23 Jun 2022 14:08:38 +0200 (CEST)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Saravana Kannan <saravanak@google.com>,
        Tony Lindgren <tony@atomide.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
Date:   Thu, 23 Jun 2022 14:08:38 +0200
Message-ID: <4799738.LvFx2qVVIh@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <YrFzK6EiVvXmzVG6@atomide.com>
References: <20220601070707.3946847-1-saravanak@google.com> <20220601070707.3946847-2-saravanak@google.com> <YrFzK6EiVvXmzVG6@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am Dienstag, 21. Juni 2022, 09:28:43 CEST schrieb Tony Lindgren:
> Hi,
> 
> * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > Now that fw_devlink=on by default and fw_devlink supports
> > "power-domains" property, the execution will never get to the point
> > where driver_deferred_probe_check_state() is called before the supplier
> > has probed successfully or before deferred probe timeout has expired.
> > 
> > So, delete the call and replace it with -ENODEV.
> 
> Looks like this causes omaps to not boot in Linux next. With this
> simple-pm-bus fails to probe initially as the power-domain is not
> yet available. On platform_probe() genpd_get_from_provider() returns
> -ENOENT.
> 
> Seems like other stuff is potentially broken too, any ideas on
> how to fix this?

I think I'm hit by this as well, although I do not get a lockup.
In my case I'm using arch/arm64/boot/dts/freescale/imx8mq-tqma8mq-mba8mx.dts 
and probing of 38320000.blk-ctrl fails as the power-domain is not (yet) 
registed. See the (filtered) dmesg output:

> [    0.744245] PM: Added domain provider from
> /soc@0/bus@30000000/gpc@303a0000/pgc/power-domain@0 [    0.744756] PM:
> Added domain provider from
> /soc@0/bus@30000000/gpc@303a0000/pgc/power-domain@2 [    0.745012] PM:
> Added domain provider from
> /soc@0/bus@30000000/gpc@303a0000/pgc/power-domain@3 [    0.745268] PM:
> Added domain provider from
> /soc@0/bus@30000000/gpc@303a0000/pgc/power-domain@4 [    0.746121] PM:
> Added domain provider from
> /soc@0/bus@30000000/gpc@303a0000/pgc/power-domain@7 [    0.746400] PM:
> Added domain provider from
> /soc@0/bus@30000000/gpc@303a0000/pgc/power-domain@8 [    0.746665] PM:
> Added domain provider from
> /soc@0/bus@30000000/gpc@303a0000/pgc/power-domain@9 [    0.746927] PM:
> Added domain provider from
> /soc@0/bus@30000000/gpc@303a0000/pgc/power-domain@a [    0.748870]
> imx8m-blk-ctrl 38320000.blk-ctrl: error -ENODEV: failed to attach bus power
> domain [    1.265279] PM: Added domain provider from
> /soc@0/bus@30000000/gpc@303a0000/pgc/power-domain@5 [    1.265861] PM:
> Added domain provider from
> /soc@0/bus@30000000/gpc@303a0000/pgc/power-domain@6

blk-ctrl@38320000 requires the power-domain 'pgc_vpu', which is power-domain@6 
in pgc.

Best regards,
Alexander

> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > ---
> > 
> >  drivers/base/power/domain.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> > index 739e52cd4aba..3e86772d5fac 100644
> > --- a/drivers/base/power/domain.c
> > +++ b/drivers/base/power/domain.c
> > @@ -2730,7 +2730,7 @@ static int __genpd_dev_pm_attach(struct device *dev,
> > struct device *base_dev,> 
> >  		mutex_unlock(&gpd_list_lock);
> >  		dev_dbg(dev, "%s() failed to find PM domain: %ld\n",
> >  		
> >  			__func__, PTR_ERR(pd));
> > 
> > -		return driver_deferred_probe_check_state(base_dev);
> > +		return -ENODEV;
> > 
> >  	}
> >  	
> >  	dev_dbg(dev, "adding to PM domain %s\n", pd->name);




