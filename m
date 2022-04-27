Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD918511ED1
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244047AbiD0Rdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 13:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244102AbiD0Rdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 13:33:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5886550
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 10:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ud7Dx5QnCzG3xHNdKfdM7a/es24kbCFWTnwgBlCY2vE=; b=RxxWGn+SjVL1Hj3+7e61IFPr1R
        eNN1qBx94ZkM4MAMfpY3hUiXRZGV7ITZucVf5zicEuQKCpZUoBvHlWf3A1PG9fkcYI0xaTsIjr2e+
        CTpOtYmUM2Nw8BcpNfozOVJa1GPJoqqx2HU+EN3/yYp22B7+Qui+QHE3EnN9VgKpc+Bs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njlUg-0009jF-98; Wed, 27 Apr 2022 19:30:26 +0200
Date:   Wed, 27 Apr 2022 19:30:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko.Oshino@microchip.com
Cc:     Woojung.Huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, Ravi.Hegde@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v2 1/2] net: phy: microchip: update LAN88xx phy
 ID and phy ID mask.
Message-ID: <Yml9sjkUywbZxVZ/@lunn.ch>
References: <20220427121957.13099-1-yuiko.oshino@microchip.com>
 <20220427121957.13099-2-yuiko.oshino@microchip.com>
 <YmljDTD9j3REqi47@lunn.ch>
 <CH0PR11MB5561E9C01C5500D6301E43728EFA9@CH0PR11MB5561.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH0PR11MB5561E9C01C5500D6301E43728EFA9@CH0PR11MB5561.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> The current phy IDs on the available hardware.
> >>         LAN8742 0x0007C130, 0x0007C131
> >>         LAN88xx 0x0007C132
> >>
> >> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
> >> ---
> >>  drivers/net/phy/microchip.c | 6 +++---
> >>  1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
> >> index 9f1f2b6c97d4..131caf659ed2 100644
> >> --- a/drivers/net/phy/microchip.c
> >> +++ b/drivers/net/phy/microchip.c
> >> @@ -344,8 +344,8 @@ static int lan88xx_config_aneg(struct phy_device
> >> *phydev)
> >>
> >>  static struct phy_driver microchip_phy_driver[] = {  {
> >> -     .phy_id         = 0x0007c130,
> >> -     .phy_id_mask    = 0xfffffff0,
> >> +     .phy_id         = 0x0007c132,
> >> +     .phy_id_mask    = 0xfffffff2,
> >
> >Just so my comment on the previous version does not get lost, is this the correct
> >mask, because it is very odd. I think you really want 0xfffffffe?
> >
> >    Andrew
> 
> Hi Andrew,
> 
> thank you for your review.
> Yes, 0xfffffff2 is correct for us.
> We would like to have bits for future revisions of the hardware without updating the driver source code in the future.
> If we use 0xfffffffe, then we need to submit a patch again when we have a new hardware revision.

This has some risks. Do you really have enough control over the
hardware people to say that:

LAN8742 0x0007C130, 0x0007C131, 0x0007C134, 0x0007C135, 0x0007C138, 0x0007C139, ...
LAN88xx 0x0007C132, 0x0007C133, 0x0007C136, 0x0007C137, 0x0007C13a, 0x0007C13b, ...

It seems safer to wait until there is new hardware and then update the
list given whatever they decide on is next.

At minimum, please add a comment in the code, otherwise you are going
to get asked, is this correct, it looks wrong?

     Andrew
