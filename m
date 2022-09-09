Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C351B5B2FB1
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 09:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiIIHVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 03:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiIIHVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 03:21:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583E2F756D;
        Fri,  9 Sep 2022 00:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4026CE2160;
        Fri,  9 Sep 2022 07:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2BEC43470;
        Fri,  9 Sep 2022 07:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662708085;
        bh=uBJV1O8Ex9BotYWxMsUg1NMKljVGeaEJPyZK0FSfnHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BAH0QJvjaFpJRkJw8PfQwNS3iZ3eRFxlPx8KbCwR0UPg2C6xyPPy/1tCLoooSb+3f
         NoQXjeAa+H8R50S+t1T3oitUaG+nVtOoLc3F6GNwY0FnhVjrycY3xM1SULp2UeMjXR
         SER0tn+FBFtQ3MKkhQVsL205U/mjbttT2mZwu995gHmi+fEUiKrt3OucMv/PK6uP0n
         vf7XwhAMgwIWvAgZXEsR/wFHC4O3fp1ifZlhftsXj/UttV9VOKgQyDCeblmdZcIT1t
         C6LLiK3btPepnDX3++qbCyk9PHNo+Sn727+aXk+BAjlKmbhtOZ99FqkUginvikfZWh
         LpdH6PMp6PdqQ==
Date:   Fri, 9 Sep 2022 08:21:16 +0100
From:   Lee Jones <lee@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RESEND PATCH v16 mfd 1/8] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <YxrpbN8x+agufDe2@google.com>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
 <20220905162132.2943088-2-colin.foster@in-advantage.com>
 <Yxm4oMq8dpsFg61b@google.com>
 <20220908142256.7aad25k553sqfgbm@skbuf>
 <YxoEbfq6YKx/4Vko@colin-ia-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YxoEbfq6YKx/4Vko@colin-ia-desktop>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 08 Sep 2022, Colin Foster wrote:

> On Thu, Sep 08, 2022 at 02:22:56PM +0000, Vladimir Oltean wrote:
> > On Thu, Sep 08, 2022 at 10:40:48AM +0100, Lee Jones wrote:
> > > Applied, thanks.
> > 
> > Hurray!
> > 
> > Colin, what plans do you have for the rest of VSC7512 upstreaming?
> > Do you need Lee to provide a stable branch for networking to pull, so
> > you can continue development in this kernel release cycle, or do you
> > expect that there won't be dependencies and you can therefore just test
> > on linux-next?
> 
> Yay!
> 
> My plan was to start sending RFCs on the internal copper phys and get
> some feedback there. I assume there'll be a couple rounds and I don't
> expect to hit this next release (if I'm being honest).
> 
> So I'll turn this question around to the net people: would a round or
> two of RFCs that don't cleanly apply to net-next be acceptable? Then I
> could submit a patch right after the next merge window? I've been
> dragging these patches around for quite some time, I can do it for
> another month :-)

Immutable branch now tested and pushed.

See reply to cover-letter.

-- 
Lee Jones [李琼斯]
