Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EAA6493E6
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 12:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiLKL3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 06:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiLKL3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 06:29:01 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CFB9598
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 03:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=X2+1onL9PR3dRGzBMY2tcgXIhjI7vkSx6BhzYKN0/OE=; b=D6SXWhUUqFamxEEtKObyoi8ta9
        pcXqwiQ+OHoJgSe1ORo7zt0X6CHENSTjOfEQv0IVZ9bjzaTH+Pb1P4FL7hrI+e29PQqBgKDoMVNVJ
        Txx3x5NXs4R9IowMiTHHSg6L1tht4iR4J0EhO+B0SttKhXgdGMMNHYsV62bVaTbiefPo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p4KVn-0050ry-Cz; Sun, 11 Dec 2022 12:28:51 +0100
Date:   Sun, 11 Dec 2022 12:28:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v2] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <Y5W+86YXppK2NocE@lunn.ch>
References: <20221206114035.66260-1-mengyuanlou@net-swift.com>
 <Y5RjwYgetMdzlQVZ@lunn.ch>
 <8BEEC6D9-EB5F-4A66-8BFD-E8FEE4EB723F@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8BEEC6D9-EB5F-4A66-8BFD-E8FEE4EB723F@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +static void ngbe_up(struct ngbe_adapter *adapter)
> >> +{
> >> +	struct ngbe_hw *hw = &adapter->hw;
> >> +
> >> +	pci_set_master(adapter->pdev);
> >> +	if (hw->gpio_ctrl)
> >> +		/* gpio0 is used to power on control*/
> >> +		wr32(&hw->wxhw, NGBE_GPIO_DR, 0);
> > 
> > Control of what?
> Control for sfp modules power down/up.
> The chip has not i2c interface, so I do not use phylink.

Please give this a better name. Is this connected to the TX_DISABLE
pin of the SFP, or the transmit and receiver power pins?

If you don't have the I2C bus, i'm wondering how you can actually
driver the SFP and the MAC. You have no idea what has been
inserted. Is it actually an SFF, not an SFP? Do you have any of the
GPIOs normally associated with an SFP? TX_DISABLE, LOS, TX_FAULT?


	  Andrew
