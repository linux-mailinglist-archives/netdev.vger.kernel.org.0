Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01328368AEB
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240330AbhDWCD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 22:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhDWCD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 22:03:56 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B07DC061574;
        Thu, 22 Apr 2021 19:03:18 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id g5so64910127ejx.0;
        Thu, 22 Apr 2021 19:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3XKuyqUzDOuX16SXd9OtTX2N8z10+36sGgTfwqHicEU=;
        b=jFVAUcObhHH3rjXs4KcCH/PO8aNbIyqiguGFgop25zWtS93hGm+r1NtZUY3284YFFv
         P/TA+2ewN68s6AeAWuaNoghFu47b0S5onAnJzLZtIRO3ySaMX6pxgrE9zmro7aHntYyd
         wDfZTxqDjBlCI9t3gXpgatYYiTcXlcq9skNQjI2k9e6lo2qghLBh0BI9PoJD+dbn9S/l
         OUfckaS374eqJhPEK1nV+OFkr07+wTaaVB42BrtJT6GB4k0IOXfJmj2wB3gmRb0Xwgzz
         zDbCG3klDg99+Zca5yAwZGNrMx9M2n0xGdwhtZfAp9TDvQX6Iek9s/moNb+OyfYInN7K
         k0PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3XKuyqUzDOuX16SXd9OtTX2N8z10+36sGgTfwqHicEU=;
        b=ROY0OrvU/6yK2QGIfEgOjGCCtp5NwmQXN+1SLnahvhn7KQXT5Fp1rS0U12jttuj5tT
         RxYGRJUYP1eNV1aixSPp+NHSdkf3zhuHZcex3eLZrbic4n2R/nTDIokh5YmR9FTw4AKz
         Izi/vVGJx+pIhWT29QKm+DXDeMtHkmwL0LV09CxtUZW7gLPA8DIK82nJqBaBuwRDBkt8
         zfhveddbQ2GoHGTXGi6DWJuOe/mlDAqsGr/LrMCJ5TtT/LtIci10rxJh+PPpLo18mMgT
         6jQ+7VvuGMWv3DoTKa94dKDPskttdom0J/rNDVO8NA8enDsnhk8YeXzvyhMP+4Wk+zWB
         rQgw==
X-Gm-Message-State: AOAM532TvIGqMEOvAZPkbvSmySIqyeF96A9JBDUMm/voVrFWEyFgY4vR
        YeuUnwPEI0EWGoM8WrIwKJE=
X-Google-Smtp-Source: ABdhPJzDX7REHeUvBPsrXFyngPuRNIm2YTRVmBd943aZu+j8XRksIFU1UXutpijlRJ2aL2yry4BkOA==
X-Received: by 2002:a17:906:c08f:: with SMTP id f15mr1658363ejz.318.1619143396943;
        Thu, 22 Apr 2021 19:03:16 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id b22sm3608094edr.52.2021.04.22.19.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 19:03:16 -0700 (PDT)
Date:   Fri, 23 Apr 2021 04:03:13 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/14] drivers: net: mdio: mdio-ip8064: improve busy wait
 delay
Message-ID: <YIIq4SgzceJfhwDC@Ansuel-xps.localdomain>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-4-ansuelsmth@gmail.com>
 <3157ddd3-0a93-fe2d-bc99-751708d3b9e9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3157ddd3-0a93-fe2d-bc99-751708d3b9e9@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 06:56:34PM -0700, Florian Fainelli wrote:
> 
> 
> On 4/22/2021 6:47 PM, Ansuel Smith wrote:
> > With the use of the qca8k dsa driver, some problem arised related to
> > port status detection. With a load on a specific port (for example a
> > simple speed test), the driver starts to bheave in a strange way and
> 
> s/bheave/behave/
> 
> > garbage data is produced. To address this, enlarge the sleep delay and
> > address a bug for the reg offset 31 that require additional delay for
> > this specific reg.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/mdio/mdio-ipq8064.c | 36 ++++++++++++++++++++-------------
> >  1 file changed, 22 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
> > index 1bd18857e1c5..5bd6d0501642 100644
> > --- a/drivers/net/mdio/mdio-ipq8064.c
> > +++ b/drivers/net/mdio/mdio-ipq8064.c
> > @@ -15,25 +15,26 @@
> >  #include <linux/mfd/syscon.h>
> >  
> >  /* MII address register definitions */
> > -#define MII_ADDR_REG_ADDR                       0x10
> > -#define MII_BUSY                                BIT(0)
> > -#define MII_WRITE                               BIT(1)
> > -#define MII_CLKRANGE_60_100M                    (0 << 2)
> > -#define MII_CLKRANGE_100_150M                   (1 << 2)
> > -#define MII_CLKRANGE_20_35M                     (2 << 2)
> > -#define MII_CLKRANGE_35_60M                     (3 << 2)
> > -#define MII_CLKRANGE_150_250M                   (4 << 2)
> > -#define MII_CLKRANGE_250_300M                   (5 << 2)
> > +#define MII_ADDR_REG_ADDR			0x10
> > +#define MII_BUSY				BIT(0)
> > +#define MII_WRITE				BIT(1)
> > +#define MII_CLKRANGE(x)				((x) << 2)
> > +#define MII_CLKRANGE_60_100M			MII_CLKRANGE(0)
> > +#define MII_CLKRANGE_100_150M			MII_CLKRANGE(1)
> > +#define MII_CLKRANGE_20_35M			MII_CLKRANGE(2)
> > +#define MII_CLKRANGE_35_60M			MII_CLKRANGE(3)
> > +#define MII_CLKRANGE_150_250M			MII_CLKRANGE(4)
> > +#define MII_CLKRANGE_250_300M			MII_CLKRANGE(5)
> >  #define MII_CLKRANGE_MASK			GENMASK(4, 2)
> >  #define MII_REG_SHIFT				6
> >  #define MII_REG_MASK				GENMASK(10, 6)
> >  #define MII_ADDR_SHIFT				11
> >  #define MII_ADDR_MASK				GENMASK(15, 11)
> >  
> > -#define MII_DATA_REG_ADDR                       0x14
> > +#define MII_DATA_REG_ADDR			0x14
> >  
> > -#define MII_MDIO_DELAY_USEC                     (1000)
> > -#define MII_MDIO_RETRY_MSEC                     (10)
> > +#define MII_MDIO_DELAY_USEC			(1000)
> > +#define MII_MDIO_RETRY_MSEC			(10)
> 
> These changes are not related to what you are doing and are just
> whitespace cleaning, better not to mix them with functional changes.
>

Ok will send them in a different patch.

> >  
> >  struct ipq8064_mdio {
> >  	struct regmap *base; /* NSS_GMAC0_BASE */
> > @@ -65,7 +66,7 @@ ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
> >  		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
> >  
> >  	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> > -	usleep_range(8, 10);
> > +	usleep_range(10, 13);
> >  
> >  	err = ipq8064_mdio_wait_busy(priv);
> >  	if (err)
> > @@ -91,7 +92,14 @@ ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
> >  		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
> >  
> >  	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> > -	usleep_range(8, 10);
> > +
> > +	/* For the specific reg 31 extra time is needed or the next
> > +	 * read will produce grabage data.
> 
> s/grabage/garbage/
> 
> > +	 */
> > +	if (reg_offset == 31)
> > +		usleep_range(30, 43);
> > +	else
> > +		usleep_range(10, 13);
> 
> This is just super weird, presumably register 31 needs to be conditional
> to the PHY, or pseudo-PHY being driven here. Not that it would harm, but
> waiting an extra 30 to 43 microseconds with a Marvell PHY or Broadcom
> PHY or from another vendor would not be necessary.
>

Any idea how to check this? I found this by printing every value wrote
and read to the mdio driver and notice this. With only this reg. By
adding extra delay the problem is solved, without this the very next
read produce bad data. Maybe some type of specific binding can be useful
here? Some type of 'qcom,extra-delay-31' binding? (fell free to suggest
a better name since i'm very bad at them)

> >  
> >  	return ipq8064_mdio_wait_busy(priv);
> >  }
> > 
> 
> -- 
> Florian
