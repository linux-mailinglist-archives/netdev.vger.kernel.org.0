Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1555865CAF1
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 01:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbjADAfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 19:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239000AbjADAe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 19:34:29 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3170714D10
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 16:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hP1dotUcEs+vZDp9a42giYltQn9fsCccN7zNcrutxrM=; b=EMovYRM2GZfMxPNNr37edhW1Y3
        9iq7fh+eb3ZXg1jMFN3WjCIChoFevWFR2agGC8BxwQXSe90Tl0KGDQtj4Cc+2uzChRSTnRpW7suMb
        BJ4Cf/iAiq9L01gW1+OeeY5ZprTkAa5EEsJD+IEu68Vgl1eU6ESrtSKGffk3tRF1Yrt8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pCrjQ-0015eY-RX; Wed, 04 Jan 2023 01:34:12 +0100
Date:   Wed, 4 Jan 2023 01:34:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Jamie Gloudon <jamie.gloudon@gmx.fr>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net-next 1/1] e1000e: Enable Link Partner Advertised
 Support
Message-ID: <Y7TJhHjPDQj4UCii@lunn.ch>
References: <20230103230653.1102544-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103230653.1102544-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -192,10 +194,16 @@ static int e1000_get_link_ksettings(struct net_device *netdev,
>  	if (hw->phy.media_type != e1000_media_type_copper)
>  		cmd->base.eth_tp_mdix_ctrl = ETH_TP_MDI_INVALID;
>  
> +	lpa_t = mii_stat1000_to_ethtool_lpa_t(adapter->phy_regs.stat1000);
> +	lp_advertising = lpa_t |
> +	mii_lpa_to_ethtool_lpa_t(adapter->phy_regs.lpa);

The indentation here is a bit odd.

I would also suggest you split this patch into two, since you are
making two changes, adding pause, and adding LPA.

       Andrew
