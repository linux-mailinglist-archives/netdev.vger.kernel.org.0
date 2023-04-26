Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A713B6EF8EB
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbjDZREx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbjDZREw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:04:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250A66A54
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 10:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=GMJOZmkhg+hqupCU86k5XcW8fK5zEKyDCekgWvVMDzs=; b=Zz
        WxiwrIF2njS2PrZ7JeXYurxOHtZKCQ/YQn+Ayi1CT5N/o31ZzEAJ4lL9Mah/kqyDAOEUgmsxbgKxR
        Ds+buLr/P+7XJZtVtprmQ5tOavQZcF6Rktdl+sRO9G/WeldDMoVsiJWaXJMCa0uUtg1gjzBsoICUX
        mq6ZQnVfDqt2WqQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1priZT-00BI4D-IZ; Wed, 26 Apr 2023 19:04:47 +0200
Date:   Wed, 26 Apr 2023 19:04:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andreas =?iso-8859-1?Q?B=F6hler?= <news@aboehler.at>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: SFP: Copper module with different PHY address (Netgear AGM734)
Message-ID: <d4d526db-995b-4426-8a8d-b53acceb5f74@lunn.ch>
References: <d57b4fcd-2fa6-bc92-0650-72530fbdc0a8@aboehler.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d57b4fcd-2fa6-bc92-0650-72530fbdc0a8@aboehler.at>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 06:47:33PM +0200, Andreas Böhler wrote:
> Hi,
> 
> I have a bunch of Netgear AGM734 copper SFP modules that I would like to use
> with my switches. Upon insertion, a message "no PHY detected" pops up.
> 
> Upon further investigation I found out that the Marvell PHY in these modules
> is at 0x53 and not at the expected 0x56. A quick check with a changed
> SFP_PHY_ADDR works as expected.
> 
> Which is the best scenario to proceed?
> 
> 1. Always probe SFP_PHY_ADDR and SFP_PHY_ADDR - 3
> 
> 2. Create a fixup for this specific module to probe at a different address.
> However, I'm afraid this might break "compatible" modules.
> 
> 3. Something else?

Hi Andreas

It is a good idea to Cc: the SFP and PHY Maintainers.

What does ethtool -m show?

Is there something we a key a quirk off?

Is it a true Netgear SFP?

There are OEMs which will load there EEPROM to emulate other
vendors. e.g.:

https://edgeoptic.com/products/netgear/agm734/

   Andrew
