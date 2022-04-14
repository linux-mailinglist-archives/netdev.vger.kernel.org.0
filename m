Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360AA50119E
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245082AbiDNNrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 09:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344028AbiDNNje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 09:39:34 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F9F1C6;
        Thu, 14 Apr 2022 06:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RtIzITOXCt3rbCs8YTplU39bL8FmkvrPa1PNdf4xnRY=; b=xshPJ5m+QfE5fHJ7T9haO0gQ7T
        JbmiQfLDpbtq87bR7pK0TO413MUY3GiV4wntUqdwULUMs4qLLXv1BcK21008nkITGLC2cSNbaMIJ0
        IitKrReeV4RwaL8hGwc6JZ/qVR3HQF8MiUJ17XvdGNrMEa0DHZWbyk4P9Y3Xz/nBcIMk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nezeL-00FpgQ-Bm; Thu, 14 Apr 2022 15:36:41 +0200
Date:   Thu, 14 Apr 2022 15:36:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Wells Lu <wellslutw@gmail.com>, davem@davemloft.net,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, pabeni@redhat.com, krzk+dt@kernel.org,
        roopa@nvidia.com, edumazet@google.com, wells.lu@sunplus.com
Subject: Re: [PATCH net-next v8 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <Ylgjab6qLsrzKZKc@lunn.ch>
References: <1649817118-14667-1-git-send-email-wellslutw@gmail.com>
 <1649817118-14667-3-git-send-email-wellslutw@gmail.com>
 <20220414141825.50eb8b6a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414141825.50eb8b6a@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +		/* Get mac-address from nvmem. */
> > +		ret = spl2sw_nvmem_get_mac_address(&pdev->dev, port_np, mac_addr);
> > +		if (ret) {
> > +			dev_info(&pdev->dev, "Generate a random mac address!\n");
> > +
> > +			/* Generate a mac address using OUI of Sunplus Technology
> > +			 * and random controller number.
> > +			 */
> > +			mac_addr[0] = 0xfc; /* OUI of Sunplus: fc:4b:bc */
> > +			mac_addr[1] = 0x4b;
> > +			mac_addr[2] = 0xbc;
> > +			mac_addr[3] = get_random_int() % 256;
> > +			mac_addr[4] = get_random_int() % 256;
> > +			mac_addr[5] = get_random_int() % 256;
> 
> I don't think you can do that. Either you use your OUI and assign the
> address at manufacture or you must use a locally administered address.
> And if locally administered address is used it better be completely
> random to lower the probability of collision to absolute minimum.

I commented about that in an earlier version of these patches. We
probably need a quote from the 802.1 or 802.3 which says this is O.K.

	 Andrew
