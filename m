Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB999209FAE
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 15:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405001AbgFYNWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 09:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404805AbgFYNW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 09:22:29 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFC8C08C5C1;
        Thu, 25 Jun 2020 06:22:29 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u185so984416pfu.1;
        Thu, 25 Jun 2020 06:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Mqx674vRJl6DMWpucWWZjOOsJT1naIS1olIEvSAr8p4=;
        b=tdbpncarE6FmGslXExVp/+CjmFJv4djGCEHuaeweAovTDlt9QcOgvfZKMvyvDjST7+
         TwBhvjJRFSyJFLgOhZXEOyYmDHYyxGqWT4D/a7C3aW2923kC6i3GAG1atgB+0hsh311u
         lIGMH4ZhzSTJr7frg/0Cq2ALYnOgkniLPvfDTFg1ZVj3K7vLpOKbywGCYXF26kegOfLn
         y4qcyIb3EIqaLE4ovEChgNSuNCyUBwHYdb8RBPyow0VnNTDpIU7Noo7ynSPwGgKwrDb1
         NMbvUAee43WkMSPQMupQtMRQf7FbeYpELqTVOX43DKY+gKFo8p8jChBND9dr3DNFMvsA
         1FNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Mqx674vRJl6DMWpucWWZjOOsJT1naIS1olIEvSAr8p4=;
        b=coIgcZZye5i0duCE1xilWRoVJS0Kz7wPzoZ9oyRywO4VWl5Cd4r733oErK4qfn1k5E
         Dctzl6rfxJk4rsvzlnCrjd1K4KR1MT9J9JggWvxUGUEGtCC5Mo8lbEySHlYtERFiLx1U
         u1PJglcC6lQF6YZvRvJw/SZQUTqFVk0Tq+4jIqGduPX8g1iqES92R32xOubPT7p5gHl7
         JUOL9wBV+Dp8uRibS9Lm8MhB7ZI55UxPOLzVzZsbn2uvalYqzn97Vbcml3kOekfEGiuF
         tllX+qxWFqzbzfAhrPo6VpObZPEKJe+xAXK4JsRZCYrKFBK9X0R3HAc9GhljAsVKP0dq
         vudg==
X-Gm-Message-State: AOAM532u8UQr+HGtbnUyWdt0lZdIUmSTVPuUOVVf+bLy9kx94JRbbNS1
        dG970FzzTU2Ms+lWzDKnpiTpVtEA
X-Google-Smtp-Source: ABdhPJySB6ZtQ7LGWzqOeMOvggerZvrNttDdyUhEPXWL4c5ap6NVFSXsIW0i3yG/I0nwC7/pc5KKOQ==
X-Received: by 2002:a63:a558:: with SMTP id r24mr26952582pgu.70.1593091349296;
        Thu, 25 Jun 2020 06:22:29 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j17sm20332958pgk.66.2020.06.25.06.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 06:22:28 -0700 (PDT)
Date:   Thu, 25 Jun 2020 06:22:26 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
Subject: Re: [PATCH net-next v4 6/8] net: phy: mscc: timestamping and PHC
 support
Message-ID: <20200625132226.GC2548@localhost>
References: <20200623143014.47864-1-antoine.tenart@bootlin.com>
 <20200623143014.47864-7-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623143014.47864-7-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 04:30:12PM +0200, Antoine Tenart wrote:
> @@ -978,9 +1483,32 @@ static int __vsc8584_init_ptp(struct phy_device *phydev)
>  
>  	vsc85xx_ts_eth_cmp1_sig(phydev);
>  
> +	vsc8531->mii_ts.rxtstamp = vsc85xx_rxtstamp;
> +	vsc8531->mii_ts.txtstamp = vsc85xx_txtstamp;
> +	vsc8531->mii_ts.hwtstamp = vsc85xx_hwtstamp;
> +	vsc8531->mii_ts.ts_info  = vsc85xx_ts_info;
> +	phydev->mii_ts = &vsc8531->mii_ts;
> +
> +	memcpy(&vsc8531->ptp->caps, &vsc85xx_clk_caps, sizeof(vsc85xx_clk_caps));
> +
> +	vsc8531->ptp->ptp_clock = ptp_clock_register(&vsc8531->ptp->caps,
> +						     &phydev->mdio.dev);
> +	if (IS_ERR(vsc8531->ptp->ptp_clock))
> +		return PTR_ERR(vsc8531->ptp->ptp_clock);

The ptp_clock_register() method can also return NULL:

 * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
 * support is missing at the configuration level, this function
 * returns NULL, and drivers are expected to gracefully handle that
 * case separately.

Thanks,
Richard
