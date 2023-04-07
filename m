Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2376DB29D
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 20:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjDGSOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 14:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjDGSOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 14:14:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17B5420F;
        Fri,  7 Apr 2023 11:14:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F46765055;
        Fri,  7 Apr 2023 18:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03C0C4339C;
        Fri,  7 Apr 2023 18:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680891276;
        bh=MJFycUcWL2cO35uDIVWw8uNPJwtHVVwCZayep99bjJQ=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=WZmHswgqiuJ/KXzwr0H+OGUxdKlv6uJpxFsur3jHySumnOGmsMNk0vVGWZ//rIskU
         T0bG8DqfhEzAWE3YD8nhhErERz1xp7X0nZwvSl3o/i9tOa7pTtHzAzmYiE68i+0H6f
         UpbFKcC6pA0v2gB1BjtE3xziJQZoZqbc3Hflldgt2usehDyfy11Zfh8h5kNPFQJlre
         6WCkTd3vvz2+3v0GqebcGMerF/0QfT3nJ2eXdAE/Fbjy4xRVuBCFV2S1NYy6szz+wO
         4Koz0z4vKeP4E1NuPT4kHa7ZD8jKj09diMPpJ6fwtszDm9ku4109xMwX5JIjiI5MRK
         /k1y/BvW1hXYg==
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
In-Reply-To: <20230407152604.105467-1-maxime.chevallier@bootlin.com>
References: <20230407152604.105467-1-maxime.chevallier@bootlin.com>
Subject: Re: [PATCH] regmap: allow upshifting register addresses before
 performing operations
Message-Id: <168089127328.178922.2584057638774170261.b4-ty@kernel.org>
Date:   Fri, 07 Apr 2023 19:14:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-2eb1a
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 07 Apr 2023 17:26:04 +0200, Maxime Chevallier wrote:
> Similar to the existing reg_downshift mechanism, that is used to
> translate register addresses on busses that have a smaller address
> stride, it's also possible to want to upshift register addresses.
> 
> Such a case was encountered when network PHYs and PCS that usually sit
> on a MDIO bus (16-bits register with a stride of 1) are integrated
> directly as memory-mapped devices. Here, the same register layout
> defined in 802.3 is used, but the register now have a larger stride.
> 
> [...]

Applied to

   broonie/regmap.git for-next

Thanks!

[1/1] regmap: allow upshifting register addresses before performing operations
      commit: 4a670ac3e75e517c96cbd01ef870dbd598c3ce71

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

