Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A6A52D1EC
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 13:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbiESL64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 07:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiESL6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 07:58:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB686B82FA;
        Thu, 19 May 2022 04:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=g1oTV/kiNlqtvr56G3igwM2BGyOYTI/eWu/vmBAuTXk=; b=E5LplxY+FEFhpWVX4xxIC2piq9
        oWx/pDouOHP7HZjRouoMkAsc7fkJ9bNIhJK8lINHPPCj2eC0bM6GLKrF3/d1tx0w+9r+o+ZJO1ags
        nEPL7PEpmQDfAynliZIiL+KgEo8sUz2T+lJeuyTqhr6t3xOBT0PtZik2vezYNWsZUzu0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nrenK-003TeY-Hz; Thu, 19 May 2022 13:58:18 +0200
Date:   Thu, 19 May 2022 13:58:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/5] dt-bindings: net: Add documentation for optional
 regulators
Message-ID: <YoYw2lKbgCiDXP0A@lunn.ch>
References: <20220518200939.689308-1-clabbe@baylibre.com>
 <20220518200939.689308-5-clabbe@baylibre.com>
 <95f3f0a4-17e6-ec5f-6f2f-23a5a4993a44@linaro.org>
 <YoYqmAB3P7fNOSVG@sirena.org.uk>
 <c74b0524-60c6-c3af-e35f-13521ba2b02e@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c74b0524-60c6-c3af-e35f-13521ba2b02e@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 01:33:21PM +0200, Krzysztof Kozlowski wrote:
> On 19/05/2022 13:31, Mark Brown wrote:
> > On Thu, May 19, 2022 at 11:55:28AM +0200, Krzysztof Kozlowski wrote:
> >> On 18/05/2022 22:09, Corentin Labbe wrote:
> > 
> >>> +  regulators:
> >>> +    description:
> >>> +       List of phandle to regulators needed for the PHY
> > 
> >> I don't understand that... is your PHY defining the regulators or using
> >> supplies? If it needs a regulator (as a supply), you need to document
> >> supplies, using existing bindings.
> > 
> > They're trying to have a generic driver which works with any random PHY
> > so the binding has no idea what supplies it might need.
> 
> OK, that makes sense, but then question is why not using existing
> naming, so "supplies" and "supply-names"?

I'm not saying it is not possible, but in general, the names are not
interesting. All that is needed is that they are all on, or
potentially all off to save power on shutdown. We don't care how many
there are, or what order they are enabled.

Ethernet PHY can have multiple supplies. For example there can be two
digital voltages and one analogue. Most designs just hard wire them
always on. It would not be unreasonable to have one GPIO which
controls all three. Or there could be one GPIO for the two digital
supplies, and one for the analogue. Or potentially, three GPIOs.

Given all the different ways the board could be designed, i doubt any
driver is going to want to control its supplies in an way other than
all on, or all off. 802.3 clause 22 defines a standardized way to put
a PHY into a low power mode. Using that one bit is much simpler than
trying to figure out how a board is wired.

However, the API/binding should be generic, usable for other use
cases. Nobody has needed an API like this before, but it is not to say
it might have other uses in the future. So maybe "supplies" and
"supply-names" is useful, but we still need a way to enumerate them as
a list without caring how many there are, or what their names are.

  Andrew
