Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810A05E57F0
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiIVBTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiIVBTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:19:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6471EC7C;
        Wed, 21 Sep 2022 18:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gZMvLQWwTExo10mo76cnJcxFdLAq2Xdyav4OP3PXoL4=; b=38186mXIsgh5H15k0jq064g7Nh
        f8wbR92vfbCTWafu5+Ikqra1vc2GjQN/ckQ1Rgg3trETUaDzXDpCYeNBMnlWnfxNPb+8jv7ahpbwb
        MH3H4zn+h3MrtsbUfGKFZmzEq12Merc3JdXNhEOzq2KJVVmP3DxG69pfc01r1SLIkJ54=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obArS-00HU64-VZ; Thu, 22 Sep 2022 03:18:42 +0200
Date:   Thu, 22 Sep 2022 03:18:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
Message-ID: <Yyu38hhzNcjFfgCN@lunn.ch>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921074004.43a933fe@kernel.org>
 <TYBPR01MB534186B5BA8E5936C46E3B6DD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <20220921180640.696efb1a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921180640.696efb1a@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 06:06:40PM -0700, Jakub Kicinski wrote:
> On Thu, 22 Sep 2022 00:46:34 +0000 Yoshihiro Shimoda wrote:
> > I thought we have 2 types about the use of the treewide:
> > 1) Completely depends on multiple subsystems and/or
> >    change multiple subsystems in a patch.
> > 2) Convenient for review.
> > 
> > This patch series type is the 2) above. However, should I use
> > treewide for the 1) only?
> 
> I thought "treewide" means you're changing something across the tree.
> If you want to get a new platform reviewed I'd just post the patches
> as RFC without any prefix in the subject. But I could be wrong.
> 
> My main point (which I did a pretty poor job of actually making)
> was that for the networking driver to be merged it needs to get
> posted separately.

Expanding on that...

You have a clock patch, which should go via the clock subsystem Maintainer.
You have a PHY path, which should go via the generic PHY subsystem Maintainer.
You have an Ethernet driver and binding patch, which can go via netdev,
Cc: the device tree list.
And a patch to add the needed nodes to .dts files which can go via the
renesas Maintainer.

At an early RFC stage, posting them all at once can be useful, to help
see all the bits and pieces. But by the time you have code ready for
merging, it should really go via easu subsystem Maintainer.

All these patches should then meet up in next, and work. If any are
missing, the driver should return -ENODEV or similar.

If there are any compile time dependencies in these patches, then we
need to handle them differently. But at a very quick glance, i don't
see any.

	 Andrew
