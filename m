Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F2358035F
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 19:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbiGYRLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 13:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236617AbiGYRLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 13:11:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F88A13E16;
        Mon, 25 Jul 2022 10:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=78+Si4CrQJYqdkHLgNgJiy3BwTK1hLdFACt1eMH2OMc=; b=39N8BAKLfnMzEyu9rVXYquss5e
        7qFUPwAYK4D85h3KSJzPgQV3s85oE+dDt3A4kqJ8Y4ZdzRbeZQFvb6OXQiL03RfTPLrG57+XMDY90
        aR08DVm67HX05jgauO2VjOJLUz+RTVwJwvuiYch4RFqEBbN4ToTu/aek+8YUooiBGMy8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oG1bl-00BTu5-8N; Mon, 25 Jul 2022 19:11:05 +0200
Date:   Mon, 25 Jul 2022 19:11:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Cc:     "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ronak.jain@xilinx.com" <ronak.jain@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "git@xilinx.com" <git@xilinx.com>, "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Message-ID: <Yt7OqU9LXl4SDqYx@lunn.ch>
References: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1658477520-13551-3-git-send-email-radhey.shyam.pandey@amd.com>
 <Yt15J6fO5j9jxFxp@lunn.ch>
 <MN0PR12MB59537FD82D25E5B6BE17D1B6B7959@MN0PR12MB5953.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB59537FD82D25E5B6BE17D1B6B7959@MN0PR12MB5953.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 02:34:51PM +0000, Pandey, Radhey Shyam wrote:
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Sunday, July 24, 2022 10:24 PM
> > To: Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> > Cc: michal.simek@xilinx.com; nicolas.ferre@microchip.com;
> > claudiu.beznea@microchip.com; davem@davemloft.net;
> > edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> > gregkh@linuxfoundation.org; ronak.jain@xilinx.com; linux-arm-
> > kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> > netdev@vger.kernel.org; git@xilinx.com; git (AMD-Xilinx) <git@amd.com>
> > Subject: Re: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
> > configuration support
> > 
> > > +		ret = of_property_read_u32_array(pdev->dev.of_node,
> > "power-domains",
> > > +						 pm_info,
> > ARRAY_SIZE(pm_info));
> > > +		if (ret < 0) {
> > > +			dev_err(&pdev->dev, "Failed to read power
> > management information\n");
> > > +			return ret;
> > > +		}
> > > +		ret = zynqmp_pm_set_gem_config(pm_info[1],
> > GEM_CONFIG_FIXED, 0);
> > > +		if (ret < 0)
> > > +			return ret;
> > > +
> > 
> > Documentation/devicetree/bindings/net/cdns,macb.yaml says:
> > 
> >   power-domains:
> >     maxItems: 1
> > 
> > Yet you are using pm_info[1]?
> 
> >From power-domain description - It's a phandle and PM domain 
> specifier as defined by bindings of the power controller specified
> by phandle.
> 
> I assume the numbers of cells is specified by "#power-domain-cells":
> Power-domain-cell is set to 1 in this case.
> 
> arch/arm64/boot/dts/xilinx/zynqmp.dtsi
> #power-domain-cells = <1>;
> power-domains = <&zynqmp_firmware PD_ETH_0>;
> 
> Please let me know your thoughts.

Ah, so you ignore the phandle value, and just use the PD_ETH_0?

How robust is this? What if somebody specified a different power
domain?

	Andrew
