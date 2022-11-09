Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83E06230F6
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 18:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiKIRCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 12:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiKIRBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 12:01:16 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC1F248C8;
        Wed,  9 Nov 2022 08:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JyqzWiwPZfcvvZni8B+6LuoQxAl6mxqRVFKIRB4evYw=; b=XCZfr5gYSakAuB33bcK/AaWnAP
        ilf0qpLSv5aDrz4rmJidxHx30jKKdet5IiSHM1oBn9B2vhmedbVo4D1LR3VSmfX42Wd41hx5y2HxF
        xZfo++vNAJZZ8jKJFZq1xUfq2CsJlO1Umqy1OUPbhKtPExq+s2865l9sGgwwwITP4p1Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osoPh-001vqB-6F; Wed, 09 Nov 2022 17:58:57 +0100
Date:   Wed, 9 Nov 2022 17:58:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Noor Azura Ahmad Tarmizi 
        <noor.azura.ahmad.tarmizi@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Subject: Re: [PATCH net 1/1] net: stmmac: add check for supported link mode
 before mode change
Message-ID: <Y2vcUWFTdWG0D2GI@lunn.ch>
References: <20221109024329.15805-1-noor.azura.ahmad.tarmizi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109024329.15805-1-noor.azura.ahmad.tarmizi@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 10:43:29AM +0800, Noor Azura Ahmad Tarmizi wrote:
> From: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
> 
> Currently, change for unsupported speed and duplex are sent to the phy,
> rendering the link to unknown speed (link state down).

Something does not seem correct. See:

https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/net/phy/phy.c#L816

	/* We make sure that we don't pass unsupported values in to the PHY */
	linkmode_and(advertising, advertising, phydev->supported);

Do you somehow have phydev->supported set wrong?

   Andrew
