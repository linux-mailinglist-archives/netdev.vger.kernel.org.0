Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F5B6E15D5
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 22:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjDMU2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 16:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjDMU2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 16:28:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E584EDD
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 13:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6Zm/OKmJ+0jIfnyUQAlvwE+49qeKnAqNYTn9Zw/MoRQ=; b=1pYFcxH0LN6Nl2VUjJU70ZXa/B
        THyYzhtDR575iCqDOp4lIRhtk85tPTUxTtSw1mbTDXk/FjEApiAsH9md8PaDj4r6R4C9izowUVzCK
        ECr2SfoFcEsxLEHGl+Zi46OOGNakypX+sT2zRv5bp2OWN/eZXvQ2mmVqR1MlFbysgNpQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pn3Xw-00ADwU-Ar; Thu, 13 Apr 2023 22:27:56 +0200
Date:   Thu, 13 Apr 2023 22:27:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ron Eggler <ron.eggler@mistywest.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: issues to bring up two VSC8531 PHYs
Message-ID: <b3776edd-e337-44a4-8196-a6a94b498991@lunn.ch>
References: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
 <bb62e044-034e-771e-e3a9-a4b274e3dec9@gmail.com>
 <46e4d167-5c96-41a0-8823-a6a97a9fa45f@lunn.ch>
 <ba56f0a4-b8af-a478-7c1d-e6532144b820@gmail.com>
 <59fc6f98-0f67-f4a3-23c9-cd589aaa6af8@mistywest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59fc6f98-0f67-f4a3-23c9-cd589aaa6af8@mistywest.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Anyways, I changed the patch specify "ethernet-phy-ieee802.3-c22" instead,
> it seems c22 is just a fallback if it's not specified per phy.txt -
> Documentation/devicetree/bindings/net/phy.txt - Linux source code (v4.14) -
> Bootlin <https://elixir.bootlin.com/linux/v4.14/source/Documentation/devicetree/bindings/net/phy.txt>

I would not trust 4.14 Documentation. That has been dead for a long
long time. We generally request you report networking issues against
the net-next tree, or the last -rcX kernel.

> I connected it with a patch cable to a laptop and fired up tcpdump on the
> laptop.
> I can see ARP requests going out (from the laptop) but VSC8531s are not
> responding (tried both ports).
> What else can I do from here, is it time to probe the RGMII signals on the
> board?

What phy-mode are you using. Generally rgmii-id is what you want, so
that the PHY adds the RGMII delays.

You can also try:

ethtool --phy-statistics ethX

The statistics are mostly about errors, not correctly received frames,
so there might not be anything useful.

     Andrew
