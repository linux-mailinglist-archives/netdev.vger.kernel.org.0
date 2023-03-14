Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4BF6B9293
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCNMFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbjCNMFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:05:12 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36E158488;
        Tue, 14 Mar 2023 05:04:36 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id b10so15791434ljr.0;
        Tue, 14 Mar 2023 05:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678795431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F4l0Jk5U2Y4ZWJeRNjevgNn1YlidIzIiYm8LUt/fJF0=;
        b=NhBNJFrvJT06SnC0oval61nKdYEP6Wx3crvZTnRQbsu0qogYGwXLt5Fe2PjJQ6c9u1
         yNROwE8pNa9V4YccLbuKvxD8IRGHo5pm2W0KkAQI4H5PhtFJGHnNUVv3QA1bbKhYbiWa
         7nq7d2cCEJhLKa65ANYQs2YBCWka+DRgd/ByH69JpnLgGLlJKKkD4K8aPdVr8JXv9HK8
         OcgwfpMce5BetdF9UlTsMmlri8jJGlbrRlKHMVeY3weYkTcjlfUUMgiMRfYmBmzeTVNk
         okBOkADgNiN7pMQlVH2GaI7d+20PEZ92rjeR+91neINcNBtazAxgH19z3RBR95hOS9Pz
         kNPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678795431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4l0Jk5U2Y4ZWJeRNjevgNn1YlidIzIiYm8LUt/fJF0=;
        b=P71FgkrwZn1JY/VQi2iPvOE1dwkubDM9VBLR6sNoKJlZ8c4fmYidsyL9BCw8nhGj9G
         XWEhKx5j8npU3D3ESTNBfQykZ89IWN2ediwTEh7hc2aX1HtXVLu+LmjgyY97uBZ+awMS
         e5/WIAXmG/WdaH36AV7k2bf21yfG5CkuWKfqEXcvDdwlsJRUigmtKn+os7LOrMbp4c5h
         oNoLZwTZLbMDYGPACxT7lfSyHNtp3XqPaKif8/71aFr/Lu4a4Et0Cl1eUL9cw3tuw6uC
         Mkv7MPoJE/sjqS6aOupjImH9lUDYOR9nxP3t8NhUwrjUjFp6lMY3G1azEV8TgatWKVdO
         KwmA==
X-Gm-Message-State: AO0yUKWqfUag1xxhimMfLFu5qNN18qzfYRIRmEkL2rPZuntu4xryO03U
        f8dgOJ677+/fkwx0BtQ/5/0=
X-Google-Smtp-Source: AK7set+JKbR9glO0P8avsQhcIFb6G2zj54QLoBDfWlazMJa03FPErSSxpfFETGJQhmJnUP6E22WQHA==
X-Received: by 2002:a2e:b53a:0:b0:294:5a6c:5221 with SMTP id z26-20020a2eb53a000000b002945a6c5221mr3909126ljm.19.1678795430919;
        Tue, 14 Mar 2023 05:03:50 -0700 (PDT)
Received: from mobilestation ([95.79.133.202])
        by smtp.gmail.com with ESMTPSA id u15-20020a2eb80f000000b00295b6bdfdfdsm420294ljo.4.2023.03.14.05.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 05:03:50 -0700 (PDT)
Date:   Tue, 14 Mar 2023 15:03:47 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Piotr Raczynski <piotr.raczynski@intel.com>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: Re: [PATCH net 09/13] net: stmmac: Remove default maxmtu DT-platform
 setting
Message-ID: <20230314120347.ygylkg2ucwqw33qu@mobilestation>
References: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
 <20230313224237.28757-10-Sergey.Semin@baikalelectronics.ru>
 <ZBBYcnh51WMutdG8@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBBYcnh51WMutdG8@nimitz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 12:20:18PM +0100, Piotr Raczynski wrote:
> On Tue, Mar 14, 2023 at 01:42:33AM +0300, Serge Semin wrote:
> > Initializing maxmtu platform parameter in the stmmac_probe_config_dt()
> > method by default makes being pointless the DW MAC-specific maximum MTU
> > selection algorithm implemented in the stmmac_dvr_probe() method. At least
> > for xGMAC we'll always have a frame MTU limited with 9000 while it
> > supports units up to 16KB. Let's remove the default initialization of
> > the maxmtu platform setting then. We don't replace it with setting the
> > maxmtu with some greater value because a default maximum MTU is
> > calculated later in the stmmac_dvr_probe() anyway. That would have been a
> > pointless limitation too. Instead from now the main STMMAC driver code
> > will consider the out of bounds maxmtu value as invalid and will silently
> > replace it with a maximum MTU value specific to the corresponding DW MAC.
> > 
> > Note this alteration will only affect the xGMAC IP-cores due to the way
> > the MTU autodetecion algorithm is implemented. So from now the driver will
> > permit DW xGMACs to handle frames up to 16KB length (XGMAC_JUMBO_LEN). As
> > before DW GMAC IP-cores of v4.0 and higher and IP-cores with enhanced
> > descriptor support will be able to work with frames up to 8KB (JUMBO_LEN).
> > The rest of the NICs will support frames of SKB_MAX_HEAD(NET_SKB_PAD +
> > NET_IP_ALIGN) size.
> > 
> > Fixes: 7d9e6c5afab6 ("net: stmmac: Integrate XGMAC into main driver flow")
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 4 ----
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 5 -----
> >  2 files changed, 9 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 32aa7953d296..e5cb4edc4e23 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -7252,10 +7252,6 @@ int stmmac_dvr_probe(struct device *device,
> >  	if ((priv->plat->maxmtu < ndev->max_mtu) &&
> >  	    (priv->plat->maxmtu >= ndev->min_mtu))
> >  		ndev->max_mtu = priv->plat->maxmtu;

> > -	else if (priv->plat->maxmtu < ndev->min_mtu)
> > -		dev_warn(priv->device,
> > -			 "%s: warning: maxmtu having invalid value (%d)\n",
> > -			 __func__, priv->plat->maxmtu);
> 
> Looks fine but by removing plat->maxmtu = JUMBO_LEN; you eliminate the
> case of dev_warn here or you remove dev_warn since the driver will be
> able to fix the mtu value?

That warning is kind of odd if not to say contradicting. Why having
max_mtu being less than the HW-specific min-value is more dangerous
than having it being greater than the max-value for which there is no
warning? The driver gets to the HW-specific min and max MTU values in
anyway. Why to warn in one case and leaving unnoticed another?..

Anyway getting back to this patch change I remove the warning since
plat_stmmaceth_data.maxmtu is now will be initialized with zero most
of the time (if glue-drivers leave it uninitialized or there is no
"max-frame-size" DT-property specified) which will falsely trigger
that warning.

-Serge(y)

> >  
> >  	if (flow_ctrl)
> >  		priv->flow_ctrl = FLOW_AUTO;	/* RX/TX pause on */
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > index 067a40fe0a23..857411105a0a 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > @@ -468,11 +468,6 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
> >  	plat->en_tx_lpi_clockgating =
> >  		of_property_read_bool(np, "snps,en-tx-lpi-clockgating");
> >  
> > -	/* Set the maxmtu to a default of JUMBO_LEN in case the
> > -	 * parameter is not present in the device tree.
> > -	 */
> > -	plat->maxmtu = JUMBO_LEN;
> > -
> >  	/* Set default value for multicast hash bins */
> >  	plat->multicast_filter_bins = HASH_TABLE_SIZE;
> >  
> > -- 
> > 2.39.2
> > 
> > 
