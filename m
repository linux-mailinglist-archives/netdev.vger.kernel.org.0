Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A684E3FA8
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 14:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiCVNjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 09:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbiCVNjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 09:39:40 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EEA1D33B;
        Tue, 22 Mar 2022 06:38:12 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l7-20020a05600c1d0700b0038c99618859so2586375wms.2;
        Tue, 22 Mar 2022 06:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=utvapRYfpnqQ4aYOHRki5bxoHcGMq/SLyjPazdHRfJA=;
        b=CzDH/d6zC6KMRysXffkdAAJWTUX/WNRR7INSiN8RwF/C7K8zD4uixnYOs74PT67kFR
         7f/aEQM/z35OrcqkkqJNOkkNVtAsVKk4K/5/NPJC4l8n4TIiHW01dK9LtLOotln1sFLU
         Rwa72GfJ1+ITFnnEZXYtZhkzw2qcfuJNMhy7193xryLK3UiAUeYQ+Siec0HK+sBkYccX
         ibMOLldgOmN6BalO/VgNLO+U9S8PiolPg9J1/1Lp9ZLjeD8U9B0uXLlJruqlko6YcRKd
         gJfGkafcYu7CN+1LBISJFzI76vrfw+4AwK/ysGqAGo4w7+s2U8g96chtT7BkT3EBBMnk
         wvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=utvapRYfpnqQ4aYOHRki5bxoHcGMq/SLyjPazdHRfJA=;
        b=8NbiaVJssTWy2g1D16KglHuvB8XvcIKc1kcHRr2ahWUN08qmRL1fLrqrD1Yig2iLdN
         wdKmAXh0EyFIrbpC9ivZ6o2BI0D8Qr2KqkLz8GJNR45gaWFWna1ItFuJXlYOmpoO2sMe
         6LlYmqhHIpb8m9m2DYVU1nwaupi14yl1mUJXPA5TVGlmxqTCgFukJy2KdylTnpyXbyjY
         1sD/kyE/ar+Sjm2PRIEWGjV4Xc0BuwLoxq7Gu8mY0uZCTyAeAzy/fs3ysR6jHj35sxEd
         mmrnRihGihLR5l8Jm7HbVgBpthDgyQaid/OxSoT1TfFeOGDtBJDEDIKgku9YTa1RWwhA
         aiAw==
X-Gm-Message-State: AOAM531Jde+HKUIXsmRqnM1smpIR3DsCum93NwixpbNK01JY6hYjABqz
        ew/SNSgfbgplkqjT2C6aAqo=
X-Google-Smtp-Source: ABdhPJwJYNfgOK2z46ttpy8sV3VqTnriakJNqwxmS7903BUgPJqYy2t4BrxB866Nlh9tDG7aqHwqgQ==
X-Received: by 2002:a5d:6c69:0:b0:203:78af:48b2 with SMTP id r9-20020a5d6c69000000b0020378af48b2mr21929460wrz.123.1647956290234;
        Tue, 22 Mar 2022 06:38:10 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-69-170.ip85.fastwebnet.it. [93.42.69.170])
        by smtp.gmail.com with ESMTPSA id m2-20020a056000024200b00205718e3a3csm1287873wrz.2.2022.03.22.06.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 06:38:09 -0700 (PDT)
Date:   Tue, 22 Mar 2022 14:38:08 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 1/4] drivers: net: dsa: qca8k: drop MTU tracking
 from qca8k_priv
Message-ID: <YjnRQNg/Do0SwNq/@Ansuel-xps.localdomain>
References: <20220322014506.27872-1-ansuelsmth@gmail.com>
 <20220322014506.27872-2-ansuelsmth@gmail.com>
 <20220322115812.mwue2iu2xxrmknxg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322115812.mwue2iu2xxrmknxg@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 01:58:12PM +0200, Vladimir Oltean wrote:
> On Tue, Mar 22, 2022 at 02:45:03AM +0100, Ansuel Smith wrote:
> > Drop the MTU array from qca8k_priv and use slave net dev to get the max
> > MTU across all user port. CPU port can be skipped as DSA already make
> > sure CPU port are set to the max MTU across all ports.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> 
> I hardly find this to be an improvement and I would rather not see such
> unjustified complexity in a device driver. What are the concrete
> benefits, size wise?
>

The main idea here is, if the value is already present and accessible,
why should we duplicate it? Tracking the MTU in this custom way already
caused some bugs (check the comment i'm removing). We both use standard
way to track ports MTU and we save some additional space. At the cost of
2 additional checks are are not that much of a problem.

Also from this I discovered that (at least on ipq806x that use stmmac)
when master needs to change MTU, stmmac complains that the interface is
up and it must be put down. Wonder if that's common across other drivers
or it's only specific to stmmac.

> >  drivers/net/dsa/qca8k.c | 38 +++++++++++++++++++++++---------------
> >  drivers/net/dsa/qca8k.h |  1 -
> >  2 files changed, 23 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index d3ed0a7f8077..4366d87b4bbd 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -2367,13 +2367,31 @@ static int
> >  qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> >  {
> >  	struct qca8k_priv *priv = ds->priv;
> > -	int i, mtu = 0;
> > +	struct dsa_port *dp;
> > +	int mtu = new_mtu;
> >  
> > -	priv->port_mtu[port] = new_mtu;
> > +	/* We have only have a general MTU setting. So check
> > +	 * every port and set the max across all port.
> > +	 */
> > +	list_for_each_entry(dp, &ds->dst->ports, list) {
> > +		/* We can ignore cpu port, DSA will itself chose
> > +		 * the max MTU across all port
> > +		 */
> > +		if (!dsa_port_is_user(dp))
> > +			continue;
> >  
> > -	for (i = 0; i < QCA8K_NUM_PORTS; i++)
> > -		if (priv->port_mtu[i] > mtu)
> > -			mtu = priv->port_mtu[i];
> > +		if (dp->index == port)
> > +			continue;
> > +
> > +		/* Address init phase where not every port have
> > +		 * a slave device
> > +		 */
> > +		if (!dp->slave)
> > +			continue;
> > +
> > +		if (mtu < dp->slave->mtu)
> > +			mtu = dp->slave->mtu;
> > +	}
> >  
> >  	/* Include L2 header / FCS length */
> >  	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
> > @@ -3033,16 +3051,6 @@ qca8k_setup(struct dsa_switch *ds)
> >  				  QCA8K_PORT_HOL_CTRL1_WRED_EN,
> >  				  mask);
> >  		}
> > -
> > -		/* Set initial MTU for every port.
> > -		 * We have only have a general MTU setting. So track
> > -		 * every port and set the max across all port.
> > -		 * Set per port MTU to 1500 as the MTU change function
> > -		 * will add the overhead and if its set to 1518 then it
> > -		 * will apply the overhead again and we will end up with
> > -		 * MTU of 1536 instead of 1518
> > -		 */
> > -		priv->port_mtu[i] = ETH_DATA_LEN;
> >  	}
> >  
> >  	/* Special GLOBAL_FC_THRESH value are needed for ar8327 switch */
> > diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> > index f375627174c8..562d75997e55 100644
> > --- a/drivers/net/dsa/qca8k.h
> > +++ b/drivers/net/dsa/qca8k.h
> > @@ -398,7 +398,6 @@ struct qca8k_priv {
> >  	struct device *dev;
> >  	struct dsa_switch_ops ops;
> >  	struct gpio_desc *reset_gpio;
> > -	unsigned int port_mtu[QCA8K_NUM_PORTS];
> >  	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
> >  	struct qca8k_mgmt_eth_data mgmt_eth_data;
> >  	struct qca8k_mib_eth_data mib_eth_data;
> > -- 
> > 2.34.1
> > 
> 

-- 
	Ansuel
