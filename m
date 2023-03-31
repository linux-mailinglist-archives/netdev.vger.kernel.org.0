Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CF96D21BE
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbjCaNvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjCaNvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:51:20 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28D82103;
        Fri, 31 Mar 2023 06:51:18 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1piF8o-00039R-1c;
        Fri, 31 Mar 2023 15:50:06 +0200
Date:   Fri, 31 Mar 2023 14:50:02 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Neil Armstrong <neil.armstrong@linaro.org>,
        Olof Johansson <olof@lixom.net>, soc@kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sebastian Reichel <sre@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-mtd@lists.infradead.org, Netdev <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH RFC 00/20] ARM: oxnas support removal
Message-ID: <ZCblCsKMHYDZI-H9@makrotopia.org>
References: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
 <df218abb-fa83-49d2-baf5-557b83b33670@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df218abb-fa83-49d2-baf5-557b83b33670@app.fastmail.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 03:42:15PM +0200, Arnd Bergmann wrote:
> On Fri, Mar 31, 2023, at 10:34, Neil Armstrong wrote:
> > With [1] removing MPCore SMP support, this makes the OX820 barely usable,
> > associated with a clear lack of maintainance, development and migration to
> > dt-schema it's clear that Linux support for OX810 and OX820 should be removed.
> >
> > In addition, the OX810 hasn't been booted for years and isn't even present
> > in an ARM config file.
> >
> > For the OX820, lack of USB and SATA support makes the platform not usable
> > in the current Linux support and relies on off-tree drivers hacked from the
> > vendor (defunct for years) sources.
> >
> > The last users are in the OpenWRT distribution, and today's removal means
> > support will still be in stable 6.1 LTS kernel until end of 2026.
> >
> > If someone wants to take over the development even with lack of SMP, I'll
> > be happy to hand off maintainance.
> >
> > The plan is to apply the first 4 patches first, then the drivers
> > followed by bindings. Finally the MAINTAINANCE entry can be removed.
> >
> > I'm not sure about the process of bindings removal, but perhaps the bindings
> > should be marked as deprecated first then removed later on ?
> >
> > It has been a fun time adding support for this architecture, but it's time
> > to get over!
> >
> > Patch 2 obviously depends on [1].
> >
> > [1] https://lore.kernel.org/all/20230327121317.4081816-1-arnd@kernel.org/
> >
> > Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> 
> Thanks a lot for going through this and preparing the patches!
> 
> I've discussed this with Daniel Golle on the OpenWRT channel as well,
> and he indicated that the timing is probably fine here, as there are
> already close to zero downloads for oxnas builds, and the 6.1 kernel
> will only be part of a release in 2024.
> 
> For the dependency on my other patch, I'd suggest you instead
> remove the SMP files here as well, which means we can merge either
> part independently based on just 6.3-rc. I can do that change
> myself by picking up patches 1-4 of your RFC series, or maybe you
> can send resend them after rebase to 6.3-rc1.
> 
> For the driver removals, I think we can merge those at the same
> time as the platform removal since there are no shared header files
> that would cause build time regressions and there are no runtime
> regressions other than breaking the platform itself. Maybe
> just send the driver removal separately to the subsystem
> maintainers with my
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Sounds reasonable, so also

Acked-by: Daniel Golle <daniel@makrotopia.org>

(but I am a bit sad about it anyway. without SMP it doesn't make sense
to keep ox820 though)
