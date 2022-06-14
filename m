Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408C454BA08
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 21:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357856AbiFNTBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 15:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357538AbiFNTAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 15:00:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9228713C;
        Tue, 14 Jun 2022 11:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IX+klwzAQQ1z7rE9HiAxH5Ct3Iw/kApUkoCb4QjaGFM=; b=SYiH0cCXRGuuwK6ZPC52upau/s
        dvoOTx/1gHnsIFDJU1fwwGzQmwewiDO58Mco275hgLsQzPVMHZZucOXKxUChjQMS3ip4FiO9BuSH9
        mThWpbvD030Rya/sFROCX4GqTxtHWq+AnVZc136uSUDMXkn7WhBRA27KtHdqgg+by+AE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1Bjd-006vCV-6E; Tue, 14 Jun 2022 20:57:53 +0200
Date:   Tue, 14 Jun 2022 20:57:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Riva <emilio.riva@ericsson.com>
Subject: Re: [PATCH net-next v4 4/5] stmmac: intel: add phy-mode and
 fixed-link ACPI _DSD setting support
Message-ID: <YqjaMbUERWuBL9FJ@lunn.ch>
References: <20220614030030.1249850-1-boon.leong.ong@intel.com>
 <20220614030030.1249850-5-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614030030.1249850-5-boon.leong.ong@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* For fixed-link setup, we allow phy-mode setting */
> +	fwnode = dev_fwnode(&pdev->dev);
> +	if (fwnode) {
> +		const char *phy_mode;
> +
> +		if (!fwnode_property_read_string(fwnode, "phy-mode",
> +						 &phy_mode)) {
> +			if (!strcmp(phy_mode, "sgmii"))
> +				plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
> +			if (!strcmp(phy_mode, "1000base-x"))
> +				plat->phy_interface = PHY_INTERFACE_MODE_1000BASEX;
> +		}

fwnode_get_phy_mode() and then validate the value afterwards.

      Andrew
