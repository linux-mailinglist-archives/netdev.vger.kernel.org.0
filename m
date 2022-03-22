Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3489D4E35C7
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 01:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiCVAsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 20:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbiCVAsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 20:48:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBFC1C938;
        Mon, 21 Mar 2022 17:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=59s+ADf1BnOZDJpEUupH6dQ+wtfTBnaf9al8HVTZ3Pk=; b=sWnwNtXA41fFknrAgiMjxnMxG4
        J8sDqtL6TLufFRtnDxa11WAAm3S9HlxvfPqfwN5TuVxw1CoS69V+lUqydICnWGJrcPWIzzh6YmlKF
        N+tXk/M7uguexV5LQeBfTS8Wo9k3HZ4UaeXbCa0EdMSNZuyta8K1qagkfRuvqKj01Pms=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nWSGn-00C2mG-Nz; Tue, 22 Mar 2022 01:21:05 +0100
Date:   Tue, 22 Mar 2022 01:21:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh@kernel.org>
Cc:     Radhey Shyam Pandey <radheys@xilinx.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        "robert.hancock@calian.com" <robert.hancock@calian.com>,
        Michal Simek <michals@xilinx.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v4 3/4] dt-bindings: net: xilinx_axienet: add pcs-handle
 attribute
Message-ID: <YjkWca40JbosV7Hq@lunn.ch>
References: <20220321152515.287119-1-andy.chiu@sifive.com>
 <20220321152515.287119-3-andy.chiu@sifive.com>
 <SA1PR02MB856080742C4C5B1AA50FA254C7169@SA1PR02MB8560.namprd02.prod.outlook.com>
 <YjkN6uo/3hXMU36c@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjkN6uo/3hXMU36c@robh.at.kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The use case is generic i.e. require separate handle to internal SGMII
> > and external Phy so would prefer this new DT convention is 
> > standardized or we discuss possible approaches on how to handle
> > both phys and not add it as vendor specific property in the first 
> > place.
> 
> IMO, you should use 'phys' for the internal PCS phy. That's aligned with 
> other uses like PCIe, SATA, etc. (there is phy h/w that will do PCS, 
> PCIe, SATA). 'phy-handle' is for the ethernet PHY.

We need to be careful here, because the PCS can have a well defined
set of registers accessible over MDIO. Generic PHY has no
infrastructure for that, it is all inside phylink which implements the
pcs registers which are part of 802.3.

I also wonder if a PCS might actually have a generic PHY embedded in
it to provide its lower interface?

   Andrew
