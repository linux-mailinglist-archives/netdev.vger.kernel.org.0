Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D387654537
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 17:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiLVQge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 11:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiLVQgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 11:36:32 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D7827DFC;
        Thu, 22 Dec 2022 08:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=d99wBLUq4yQ4eQDQtyjO01+kHuKyie+U+1uevyf9EBU=; b=53zDqYwiG4C835IlzVAdpx44nM
        OfEUQO8pz2dGRMnDvhFA7jIZopgYFjq4LjtPfXL0lkqj4l+T9Cf90HZ+DoMpV6ptk8nihRbGIkrR9
        +jeagLNU39thNGwsqHqf158MMvg1Igd8lN+wnMfMRBwdYMT2gIEOpzAH9gNuVrduMZ18=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p8OYQ-000GtY-Ew; Thu, 22 Dec 2022 17:36:22 +0100
Date:   Thu, 22 Dec 2022 17:36:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lee Jones <lee@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Advice on MFD-style probing of DSA switch SoCs
Message-ID: <Y6SHhiMx4V9tyJuG@lunn.ch>
References: <20221222134844.lbzyx5hz7z5n763n@skbuf>
 <Y6Rq8+wYpDkGGbYs@lunn.ch>
 <20221222161806.mhqsr2ot64v34al2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222161806.mhqsr2ot64v34al2@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Maybe the media subsystem has some pointers how to do this. It also
> > has complex devices made up from lots of sub devices.
> 
> You mean something like struct v4l2_subdev_ops? This seems like the
> precise definition of what I'd like to avoid: a predefined set of
> subfunctions decided by the DSA core.
> 
> Or maybe something else? To be honest, I don't know much about the media
> subsystem. This is what I saw.

Russell King put in some infrastructure where a media 'glue' driver
has a list of other drivers which need to probe and register there
resources with the kernel before it then becomes active and glues all
the parts together. I just know it exists, i've never used it, so i've
no idea if it could be useful or not.

What i'm really trying to say is that we should look outside of netdev
and see if similar problems have been solved somewhere else and all
that is needed is some code copying.

     Andrew
