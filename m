Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F32C4AD6D3
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 12:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbiBHL36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 06:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356775AbiBHLAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 06:00:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE96C03FEC0;
        Tue,  8 Feb 2022 03:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8EE0B81A1C;
        Tue,  8 Feb 2022 11:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD4FC004E1;
        Tue,  8 Feb 2022 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644318011;
        bh=lgU6ufHve7JlUCO/BFOI9B8QpSdLnyCpTVPTeG8N3x0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eFdfQ5xGfudSGY9mNnEZo7SUi0EYPYpK1U7o+DGAH3uISBV0ZOoqR6KKqgMmcPYEv
         BZaMucZRl3WH2qElqcOTZ7R0oBr2vze8l8xbJ5vLoNajpCKqauLLEhzufYa2RiEXLR
         jmiH+dOS87X8nsj38aVpKhZ+WiB/fimqJGGEZ1LEGK2Cql7qL85GpiUW8YgywcxLys
         t23ws9VQoGMOD6NUYPZcuqqC6dwrqxJ/kBnD1n6Y8OHmIGo+nQ8EJUMkPPIXhw4Hyy
         e+MTFaEQ0dJJGbkQ5+N+W9s51LBGal9F22rOS/wzTHKZsjpS5JrxNzAC7F+Rl8cIEf
         6H8PMZz8SnAIQ==
Received: by pali.im (Postfix)
        id D6E1FC34; Tue,  8 Feb 2022 12:00:08 +0100 (CET)
Date:   Tue, 8 Feb 2022 12:00:08 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] of: net: Add helper function of_get_ethdev_label()
Message-ID: <20220208110008.s7ock4pkspmulwix@pali>
References: <20220107161222.14043-1-pali@kernel.org>
 <Ydhqa+9ya6nHsvLq@shell.armlinux.org.uk>
 <Ydhwfa/ECqTE3rLx@lunn.ch>
 <20220113182719.ixgysemitp5cuidn@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220113182719.ixgysemitp5cuidn@pali>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 13 January 2022 19:27:19 Pali Rohár wrote:
> On Friday 07 January 2022 17:55:25 Andrew Lunn wrote:
> > On Fri, Jan 07, 2022 at 04:29:31PM +0000, Russell King (Oracle) wrote:
> > > On Fri, Jan 07, 2022 at 05:12:21PM +0100, Pali Rohár wrote:
> > > > Adds a new helper function of_get_ethdev_label() which sets initial name of
> > > > specified netdev interface based on DT "label" property. It is same what is
> > > > doing DSA function dsa_port_parse_of() for DSA ports.
> > > > 
> > > > This helper function can be useful for drivers to make consistency between
> > > > DSA and netdev interface names.
> > > > 
> > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > 
> > > Doesn't this also need a patch to update the DT binding document
> > > Documentation/devicetree/bindings/net/ethernet-controller.yaml ?
> > > 
> > > Also it needs a covering message for the series, and a well thought
> > > out argument why this is required. Consistency with DSA probably
> > > isn't a good enough reason.
> > > 
> > > >From what I remember, there have been a number of network interface
> > > naming proposals over the years, and as you can see, none of them have
> > > been successful... but who knows what will happen this time.
> > 
> > I agree with Russell here. I doubt this is going to be accepted.
> > 
> > DSA is special because DSA is very old, much older than DT, and maybe
> > older than udev. The old DSA platform drivers had a mechanism to
> > supply the interface name to the DSA core. When we added a DT binding
> > to DSA we kept that mechanism, since that mechanism had been used for
> > a long time.
> > 
> > Even if you could show there was a generic old mechanism, from before
> > the days of DT, that allowed interface names to be set from platform
> > drivers, i doubt it would be accepted because there is no continuity,
> > which DSA has.
> 
> Well, DT should universally describe HW board wiring. From HW point of
> view, it is really does not matter if RJ45 port is connected to embedded
> PHY on SoC itself or to the external PHY chip, or to the switch chip
> with embedded PHY. And if board has mix of these options, also labels
> (as printed on product box) should be in DTS described in the same way,
> independently of which software solution / driver is used for particular
> chip. It really should not matter for DTS if kernel is using for
> particular HW part DSA driver or ethernet driver.
> 
> So there really should be some common way. And if the one which DSA is
> using is the old mechanism, what is the new mechanism then?

Hello! Any comments on this?
