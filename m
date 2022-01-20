Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E9C4953A6
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 18:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbiATR5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 12:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiATR5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 12:57:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46F7C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 09:57:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 24C5ECE217D
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 17:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B0AC340E0;
        Thu, 20 Jan 2022 17:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642701438;
        bh=hM/zKZmMnMwBviUYx8O8x3YMtIhG/jRQbQhiTboq1Jo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AD5SJdxWMcq4yavGGmLOTrDtfkBFotFkXhKnf0IYuhembWFcIcrDr1nMosX8bw6+m
         FhzF1QZjnJaUVjTiZ4EyIkLMCO9VGOzvU51XvZIC17/ToQ9CqO253zpc1U9ur+R3ky
         gIwOc4tuHpQJMY0RfONzrTr+a4N4Kklq3DMsPq6IgDjI9ZYLULTaicSSbOb73anKa3
         kbQYT85ubyO7nkT2/j2EAtX8X+88YQ8JvwY7+0edaCiG+USJgteTah/HcQxuWVzNkB
         45uEVCopdH/b/szxd/rZfKNsPrMLViJ3rvu5knFF1wbs1OSdiDK7cFxB4unPrQGmqE
         XQCJyKL1qNg/A==
Date:   Thu, 20 Jan 2022 18:57:13 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20220120185713.0a3ed53e@thinkpad>
In-Reply-To: <AM0PR0602MB36663B72C5574E30DF7A6805F75A9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
        <20211207202733.56a0cf15@thinkpad>
        <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208162852.4d7361af@thinkpad>
        <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208171720.6a297011@thinkpad>
        <YbDkldWhZNDRkZDO@lunn.ch>
        <20211208181623.6cf39e15@thinkpad>
        <AM0PR0602MB366630C33E7F36499BCD1C40F7769@AM0PR0602MB3666.eurprd06.prod.outlook.com>
        <20211215215350.7a8b353a@thinkpad>
        <AM0PR0602MB36663B72C5574E30DF7A6805F75A9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Holger,

On Thu, 20 Jan 2022 07:52:01 +0000
Holger Brunck <holger.brunck@hitachienergy.com> wrote:

> Hi Marek,
> 
> > >  
> > > > > This gets interesting when PCIe and USB needs to use this
> > > > > property, what names are used, and if it is possible to combine
> > > > > two different lists?  
> > > >
> > > > I don't think it is possible, I tried that once and couldn't get it to work.
> > > >
> > > > I am going to try write the proposal. But unfortunately PHY binding
> > > > is not converted to YAML yet :(
> > > >  
> > >
> > > I saw you recent patches to convert this. Thanks!
> > >
> > > This make my serdes.yaml obsolete then, correct? Should I then only
> > > re-post my driver code, once your patches are accepted?  
> > 
> > Yes, please let's do it this way. It may take some time for Rob to review this,
> > though, and he may require some changes.
> >   
> 
> I saw your v3 patch for the bindings and I would adapt then my patch
> accordingly to tx-p2p-microvolt. 
> 
> > Also I was thinking whether it wouldn't be better to put the property into a
> > separate SerDes PHY node, i.e.
> > 
> >   switch {
> >     compatible = "marvell,mv88e6085";
> >     ...
> > 
> >     ports {
> >       port@6 {
> >         reg = <0x6>;
> >         phy-handle = <&switch_serdes_phy>;
> >       };
> > 
> >       ...
> >     };
> > 
> >     mdio {
> >       switch_serdes_phy: ethernet-phy@f {
> >         reg = <0xf>;
> >         tx-amplitude-microvolt = <1234567>;
> >       };
> > 
> >       ...
> >     };
> >   };  
> 
> this would mean in regard to my patch instead of checking directly for the
> property in mv88e6xxx_setup_port  I would parse for the phy-handle first
> and then for the property? 
> 
> Should I wait until your patch is accepted and merged?

I don't know if Rob will be merging it, but we need to wait at least
for his review/acknowledgement. In the meantime you can prepare your
patch as RFC, though.

Also I want to add a function that will give you the voltage amplitude
given a node and a mode, i.e.

  fwnode_phy_get_tx_p2p_amplitude(fwnode, "1000base-x")

