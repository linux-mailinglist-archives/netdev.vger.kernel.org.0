Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AFE4282E8
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 20:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhJJSU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 14:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbhJJSU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 14:20:56 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CCAC061570;
        Sun, 10 Oct 2021 11:18:57 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g8so58364253edt.7;
        Sun, 10 Oct 2021 11:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0FJDdY87/7GIuzxKKNba+7Pm5+giJl9a7wRHbISFE+M=;
        b=b1Gpd3V9pua5ojd68OdZqSk6RnG8hPUFbrs/khGy++qbqwyRYjmKf3y7OVsMo4fouB
         Cqny1UhHOABf0DHCNCJW6JIDNQJT+lVXZZypTbkR4+kppqX+kTENAnnOAZ/ZCoyomuFa
         lTSzHgnoHu4I08WzmYpIhUFumNnhlG52TMyloBxsOWS7qxh18pGfn4sr69VUPOIz0zvj
         W2tNdj0QVnSM+43E6L+dz1084+V8Ee6lI1s6hDomlgQ8sELcX74JQ+FWKj9DEz1v/xmu
         6dCojW4zPUdZtTHWQhYXAf0RIffLoYkLQQC2zRnt2BXQUl+0t7spKERcTTFRxcHzjNJ6
         rjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0FJDdY87/7GIuzxKKNba+7Pm5+giJl9a7wRHbISFE+M=;
        b=H9jFrGJA3IMuHspYgmG9BArDclRWMemGCXiAWaJT9PQ7IJG23NStL792do4SnWPcr9
         r0ksSo/AjCfiKKDkFZAjRh5yBKz9a7YfIDKSTH2OoCOS2+kJ9kQdMGtZ/ONOcFxgSJgi
         gArmCSK5ArpsOUrYr9/Vbe/KKTtMewjMGA8OOghsjUArRzYuPqJISINl1aSMtj1AZ1fZ
         q4jkCW09QsjJY0IWd5lvIXSGJV0QWe4DQCu/3IGlzOr0uBhAuPbm0y4BMCIVJIochRzu
         BiE+Es3G9A37yG95drLCLjWTvpjSls2LmXd7BEhE9SDT/WbEgccAugAOlBiAfPOOEUCU
         //gA==
X-Gm-Message-State: AOAM531ztmOWksg2vQsH92L2laZqAVHPO2TyeloFjm4HErPIYXJ8/hzq
        /hfRQy22my4ysgxdf/IwSlY=
X-Google-Smtp-Source: ABdhPJzcmYtBza/T9gWNcP8wdTPXrTgXDCPYd5ZSsfA6Drbn+cVUk0Lsxj/j8kzx67NoPLK//stUFA==
X-Received: by 2002:a17:906:7632:: with SMTP id c18mr21263034ejn.317.1633889935518;
        Sun, 10 Oct 2021 11:18:55 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id v9sm998562ejw.22.2021.10.10.11.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 11:18:55 -0700 (PDT)
Date:   Sun, 10 Oct 2021 20:18:53 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v4 06/13] net: dsa: qca8k: move rgmii delay
 detection to phylink mac_config
Message-ID: <YWMujVh232s+Q7dU@Ansuel-xps.localdomain>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-7-ansuelsmth@gmail.com>
 <20211010124732.fageoraoweqqfoew@skbuf>
 <YWLqh2X0lVwiDMCn@Ansuel-xps.localdomain>
 <20211010181107.4as42prroyitew3m@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010181107.4as42prroyitew3m@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 09:11:07PM +0300, Vladimir Oltean wrote:
> On Sun, Oct 10, 2021 at 03:28:39PM +0200, Ansuel Smith wrote:
> > > I was actually going to say that since RGMII delays are runtime
> > > invariants, you should move their entire programming to probe time, now
> > > you move device tree parsing to runtime :-/
> > >
> >
> > The main idea here was to move everything to mac config and scan the DT
> > node of the current port that is being configured.
> 
> If you insist on doing static configuration in a phylink callback, sure,
> the comment was mostly about not accessing directly this struct dsa_port
> member. It might change in the future, and the less refactoring required,
> the better.
>

I think I will put values in qca8k_priv and configure them in mac_config.

> > > > -{
> > > > -	struct device_node *port_dn;
> > > > -	phy_interface_t mode;
> > > > -	struct dsa_port *dp;
> > > > -	u32 val;
> > > > -
> > > > -	/* CPU port is already checked */
> > > > -	dp = dsa_to_port(priv->ds, 0);
> > > > -
> > > > -	port_dn = dp->dn;
> > > > -
> > > > -	/* Check if port 0 is set to the correct type */
> > > > -	of_get_phy_mode(port_dn, &mode);
> > > > -	if (mode != PHY_INTERFACE_MODE_RGMII_ID &&
> > > > -	    mode != PHY_INTERFACE_MODE_RGMII_RXID &&
> > > > -	    mode != PHY_INTERFACE_MODE_RGMII_TXID) {
> > > > -		return 0;
> > > > -	}
> > > > -
> > > > -	switch (mode) {
> > > > -	case PHY_INTERFACE_MODE_RGMII_ID:
> > > > -	case PHY_INTERFACE_MODE_RGMII_RXID:
> > >
> > > Also, since you touch this area.
> > > There have been tons of discussions on this topic, but I believe that
> > > your interpretation of the RGMII delays is wrong.
> > > Basically a MAC should not apply delays based on the phy-mode string (so
> > > it should treat "rgmii" same as "rgmii-id"), but based on the value of
> > > "rx-internal-delay-ps" and "tx-internal-delay-ps".
> > > The phy-mode is for a PHY to use.
> > >
> >
> > Ok so we can just drop the case and directly check for the
> > internal-delay-ps presence?
> 
> Yes, but please consider existing device trees for this driver. I see
> qcom-ipq8064-rb3011.dts and imx6dl-yapp4-common.dtsi, and neither use
> explicit rx-internal-delay-ps or tx-internal-delay-ps properties. So
> changing the driver to look at just those and ignore "rgmii-id" will
> break those device trees, which is not pleasant. What would work is to
> search first for *-internal-delay-ps, and then revert to determining the
> delays based on the phy-mode, for compatibility.

Ok. Will try to implement something that is not entireley a big complex
condition ahahah.

-- 
	Ansuel
