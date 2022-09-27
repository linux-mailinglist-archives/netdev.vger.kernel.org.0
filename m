Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF3E5ED14F
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 01:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiI0XxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 19:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbiI0Xw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 19:52:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739441D73E5
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 16:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD19BB81E49
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 23:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DCDC433D7;
        Tue, 27 Sep 2022 23:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664322700;
        bh=xrPMe+xART9mc7iuf9P5FswWYnPcS064DXyVi7VUA6M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T14Jgj1KpYQfOdvaDlRi0CIBRqIMDrVDbkOsHab6PxvyWDIRtXWrRq5We4R6qtnOh
         CjavWUt0aV1xBqBbp8zgzfWuR/r7qDB4m+5rg/5x8OqsnhjC/xe4GEc8Q4bvaPuxkr
         5BOF+E4k/kkTTqLB2K4nZVOk1LyOIerSAONI9ciWXn8Bllr/Cxlx3g4yEI+ZLNmS1u
         9gxqafe3an9WLaP75NremCJ3WXPgDxWJkhblHgovyrUN7pWVLzLuFigfWWb5PUI078
         WkmO2sKUs/yHxrRpyVZDYvg1iH1h4xmcQmGRMjejZ+YE+5xXJaZLms8erqpy/ge6j6
         Y6gqgKmRfxLVg==
Date:   Tue, 27 Sep 2022 16:51:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH net-next 5/5] net: dsa: felix: update init_regmap to be
 string-based
Message-ID: <20220927165139.1ad8538b@kernel.org>
In-Reply-To: <20220927192736.l7dgadcyazyvkpmr@skbuf>
References: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
        <20220927191521.1578084-6-vladimir.oltean@nxp.com>
        <20220927192736.l7dgadcyazyvkpmr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 19:27:36 +0000 Vladimir Oltean wrote:
> On Tue, Sep 27, 2022 at 10:15:20PM +0300, Vladimir Oltean wrote:
> > Existing felix DSA drivers (vsc9959, vsc9953) are all switches that were
> > integrated in NXP SoCs, which makes them a bit unusual compared to the
> > usual Microchip branded Ocelot switches.  
> 
> Damn, I did something stupid, I reworded the commit title for this, and
> I didn't rm -rf the patch output folder first, so now this patch is a
> duplicate of the other 5/5.
> 
> I know I'm going to get a lot of hate for reposting in a matter of
> minutes, so I won't, but on the other hand, patchwork took the wrong
> patch (this one) as part of the series, and the other one as "Untitled
> series #681176". The code is the same, just the commit message differs.
> 
> Can that be fixed in post-production or something?

Just replace the commit message with the other 5/5? Can do.
