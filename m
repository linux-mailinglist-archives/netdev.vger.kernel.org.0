Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E3F59919D
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 02:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239816AbiHSAL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 20:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiHSAL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 20:11:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0869C9938;
        Thu, 18 Aug 2022 17:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qBpGMSI0v+lMIk9d+oAPPTnYnOFVRgH1kmWyrp4919k=; b=mqRT/H4dztD+vbBeqZe/zUjz9j
        ymGvscm6ayT0gnjvRkv08jBarvt3DezySSpIqD5rLpYw/8AhzIEMKGjmNPgP5hyE4EbzihY3+zu68
        kPb84MOTdheeDYCw29uaCMoLps+WPK8VPvDz3n9jd4q2JGYF8KlI3PGssZmjck5vjnE4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOpbx-00DrFs-6L; Fri, 19 Aug 2022 02:11:41 +0200
Date:   Fri, 19 Aug 2022 02:11:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     andrei.tachici@stud.acs.upb.ro
Cc:     linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: Re: [net-next v4 2/3] net: ethernet: adi: Add ADIN1110 support
Message-ID: <Yv7VPaWAJNz/if80@lunn.ch>
References: <20220817160236.53586-1-andrei.tachici@stud.acs.upb.ro>
 <20220817160236.53586-3-andrei.tachici@stud.acs.upb.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817160236.53586-3-andrei.tachici@stud.acs.upb.ro>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 07:02:35PM +0300, andrei.tachici@stud.acs.upb.ro wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> The ADIN1110 is a low power single port 10BASE-T1L MAC-PHY
> designed for industrial Ethernet applications. It integrates
> an Ethernet PHY core with a MAC and all the associated analog
> circuitry, input and output clock buffering.
> 
> ADIN1110 MAC-PHY encapsulates the ADIN1100 PHY. The PHY registers
> can be accessed through the MDIO MAC registers.
> We are registering an MDIO bus with custom read/write in order
> to let the PHY to be discovered by the PAL. This will let
> the ADIN1100 Linux driver to probe and take control of
> the PHY.
> 
> The ADIN2111 is a low power, low complexity, two-Ethernet ports
> switch with integrated 10BASE-T1L PHYs and one serial peripheral
> interface (SPI) port.
> 
> The device is designed for industrial Ethernet applications using
> low power constrained nodes and is compliant with the IEEE 802.3cg-2019
> Ethernet standard for long reach 10 Mbps single pair Ethernet (SPE).
> The switch supports various routing configurations between
> the two Ethernet ports and the SPI host port providing a flexible
> solution for line, daisy-chain, or ring network topologies.
> 
> The ADIN2111 supports cable reach of up to 1700 meters with ultra
> low power consumption of 77 mW. The two PHY cores support the
> 1.0 V p-p operating mode and the 2.4 V p-p operating mode defined
> in the IEEE 802.3cg standard.
> 
> The device integrates the switch, two Ethernet physical layer (PHY)
> cores with a media access control (MAC) interface and all the
> associated analog circuitry, and input and output clock buffering.
> 
> The device also includes internal buffer queues, the SPI and
> subsystem registers, as well as the control logic to manage the reset
> and clock control and hardware pin configuration.
> 
> Access to the PHYs is exposed via an internal MDIO bus. Writes/reads
> can be performed by reading/writing to the ADIN2111 MDIO registers
> via SPI.
> 
> On probe, for each port, a struct net_device is allocated and
> registered. When both ports are added to the same bridge, the driver
> will enable offloading of frame forwarding at the hardware level.
> 
> Driver offers STP support. Normal operation on forwarding state.
> Allows only frames with the 802.1d DA to be passed to the host
> when in any of the other states.
> 
> Supports both VEB and VEPA modes. In VEB mode multicast/broadcast
> and unknown frames are handled by the ADIN2111, sw bridge will
> not see them (this is to save SPI bandwidth). In VEPA mode,
> all forwarding will be handled by the sw bridge, ADIN2111 will
> not attempt to forward any frames in hardware to the other port.
> 
> Co-developed-by: Lennart Franzen <lennart@lfdomain.com>
> Signed-off-by: Lennart Franzen <lennart@lfdomain.com>
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
