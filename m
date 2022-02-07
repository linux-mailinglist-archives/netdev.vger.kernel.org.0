Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC7D4AB421
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 07:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiBGFrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 00:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbiBGF3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 00:29:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262C4C043184;
        Sun,  6 Feb 2022 21:29:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FFF161140;
        Mon,  7 Feb 2022 05:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FEEC004E1;
        Mon,  7 Feb 2022 05:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644211782;
        bh=IScjOYArVNYVbJH6MdKnmqqYzf1ygoeSC6Cat/SyezM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZKr+40RwCyLTmBLqDyLA6NfttVuysn3LAXf6bwqRngyYCtAe7oBoc9d08siEND25g
         5sEvUB6SRqwpHSyYh+Nxu/w40pGCL/ae3bklPZXBjKSsbq2Fy9xzvspbOAiqwWsp/2
         wpi2IyOQ7oYNpXqEnC1MI8Z6kibSUmPwjpwBYM4nS+MKboN7nJo/3fSWDuChgkfdly
         BkB/g8sXdfrB2A8/xLoir1UkQ+rMpxbs6T/9+EddJprBls4JXsBMKxd2iX7eFou+W7
         3CCEDPnYyoxFooqYA0tLKFfAdA7Fy6+9McuGwYMZOwpfBm8XuCIrZDHnYT9Ip0EpnV
         a2PoM7SXEh6Hg==
Date:   Mon, 7 Feb 2022 10:59:38 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH devicetree v3] dt-bindings: phy: Add `tx-p2p-microvolt`
 property binding
Message-ID: <YgCuQjN5tBvljrQN@matsya>
References: <20220119131117.30245-1-kabel@kernel.org>
 <74566284-ff3f-8e69-5b7d-d8ede75b78ad@gmail.com>
 <Yf3egEVYyyXUkklM@robh.at.kernel.org>
 <20220206185413.4c1ac00d@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220206185413.4c1ac00d@thinkpad>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06-02-22, 18:54, Marek Behún wrote:
> On Fri, 4 Feb 2022 20:18:40 -0600
> Rob Herring <robh@kernel.org> wrote:
> 
> > On Fri, Jan 21, 2022 at 11:18:09AM -0800, Florian Fainelli wrote:
> > > On 1/19/22 5:11 AM, Marek Behún wrote:  
> > > > Common PHYs and network PCSes often have the possibility to specify
> > > > peak-to-peak voltage on the differential pair - the default voltage
> > > > sometimes needs to be changed for a particular board.
> > > > 
> > > > Add properties `tx-p2p-microvolt` and `tx-p2p-microvolt-names` for this
> > > > purpose. The second property is needed to specify the mode for the
> > > > corresponding voltage in the `tx-p2p-microvolt` property, if the voltage
> > > > is to be used only for speficic mode. More voltage-mode pairs can be
> > > > specified.
> > > > 
> > > > Example usage with only one voltage (it will be used for all supported
> > > > PHY modes, the `tx-p2p-microvolt-names` property is not needed in this
> > > > case):
> > > > 
> > > >   tx-p2p-microvolt = <915000>;
> > > > 
> > > > Example usage with voltages for multiple modes:
> > > > 
> > > >   tx-p2p-microvolt = <915000>, <1100000>, <1200000>;
> > > >   tx-p2p-microvolt-names = "2500base-x", "usb", "pcie";
> > > > 
> > > > Add these properties into a separate file phy/transmit-amplitude.yaml,
> > > > which should be referenced by any binding that uses it.  
> > > 
> > > p2p commonly means peer to peer which incidentally could be confusing,
> > > can you spell out the property entire:
> > > 
> > > tx-peaktopeak-microvolt or:
> > > 
> > > tx-pk2pk-microvolt for a more compact name maybe?  
> > 
> > Peer to peer makes little sense in terms of a voltage. I think this is 
> > fine as-is.
> 
> Cool. Should this get merged via devicetree, or via phy maintainers?
> Or should I resend this together with patches that make use of this
> property? (In that case can you add your Ack?)

Sending with patches using this would be better.. It can go thru phy
tree

-- 
~Vinod
