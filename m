Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA625A39B9
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 21:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiH0T22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 15:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiH0T21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 15:28:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9E54BA57;
        Sat, 27 Aug 2022 12:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=64hvREkNh53C/RDviN6vUPQLGsTZMfqdbVZdTxQHdgc=; b=HBVeLjjxnhb1n+GOr4/0fMgkc1
        WoVAyTEjg2tvG5HSL4lF4fcaeff2C7FSUA2TsHYvFFUlWrYTo7+diaMW3P/MlP+lv18t3UCB1fIsI
        J6LwhvK08IPcvJX4AEm6zkz6qqOgrgy9aAhW+eggAEGqZYh4VfphzUMFn1G1gOA7Uv3E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oS1Th-00Enbk-4H; Sat, 27 Aug 2022 21:28:21 +0200
Date:   Sat, 27 Aug 2022 21:28:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v3 1/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
Message-ID: <YwpwVd+qgM+RR8nh@lunn.ch>
References: <20220826154650.615582-1-maxime.chevallier@bootlin.com>
 <20220826154650.615582-2-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826154650.615582-2-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void ipqess_get_strings(struct net_device *netdev, u32 stringset,
> +			       u8 *data)
> +{
> +	u8 *p = data;
> +	u32 i;
> +
> +	switch (stringset) {
> +	case ETH_SS_STATS:
> +		for (i = 0; i < ARRAY_SIZE(ipqess_stats); i++) {
> +			memcpy(p, ipqess_stats[i].string,
> +			       min((size_t)ETH_GSTRING_LEN,
> +				   strlen(ipqess_stats[i].string) + 1));

That looks pretty similar to strlcpy().

> +static int ipqess_get_settings(struct net_device *netdev,
> +			       struct ethtool_link_ksettings *cmd)

It would be traditional to have the k in the name.

> +{
> +	struct ipqess *ess = netdev_priv(netdev);
> +
> +	return phylink_ethtool_ksettings_get(ess->phylink, cmd);
> +}
> +
> +static int ipqess_set_settings(struct net_device *netdev,
> +			       const struct ethtool_link_ksettings *cmd)
> +{

Here too.

     Andrew
