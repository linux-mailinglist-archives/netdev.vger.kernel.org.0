Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5AF576A5C
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiGOXEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiGOXED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:04:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C134D4E2;
        Fri, 15 Jul 2022 16:04:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9FF761E51;
        Fri, 15 Jul 2022 23:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C86AC3411E;
        Fri, 15 Jul 2022 23:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657926241;
        bh=d5MdTIonHKWdt36P0nVxTI+b57TowJdCD+NWNZoxFjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NRGAL6F9qARXkFTmXPKo6vvIUI1rkoJKmL3xGFujpMcLr6eZUq8WPs/tyvHX72U9v
         FCFUyRqEgosieEN+wSJJj0N/BwjZg2oUVm6WWq0ZqewAGOBN+JRg+xDbWDeclL456q
         Bxq4Ht84JmYDsDf+01/glb0/6+CnbnvozOA1tGdCVwm558XnCge2GF2bagOxZkZJFy
         6zy6cx6ou3oP4NvPOII0LZaXw9fv0N0aya2A7bLNIdWqLkKCiNvzblkdqt17j5+GBk
         9OmrkHEWeSAuiMV8yLQU6jqX2j7SxDUhXW02GL3LrIHJoJpxDi+k2KQo9vmKZ3lQSJ
         sxq0MQRa0dwjA==
Date:   Fri, 15 Jul 2022 16:03:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 0/6] net: dsa: always use phylink
Message-ID: <20220715160359.2e9dabfe@kernel.org>
In-Reply-To: <YtHVLGR0RQ6dWuBS@shell.armlinux.org.uk>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
        <20220715171719.niqcrklpk4ittfvl@skbuf>
        <YtHVLGR0RQ6dWuBS@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jul 2022 21:59:24 +0100 Russell King (Oracle) wrote:
> The only thing that delayed them was your eventual comments about
> re-working how it was being done. Yet again, posting the RFC series
> created very little in the way of feedback. I'm getting to the point
> of thinking its a waste of time posting RFC patches - it's counter
> productive. RFC means "request for comments" but it seems that many
> interpret it as "I can ignore it".

I'm afraid you are correct. Dave used to occasionally apply RFC patches
which kept reviewers on their toes a little bit (it kept me for sure).
These days patchwork automatically marks patches as RFC based on
the subject, tossing them out of "Action required" queue. So they are
extremely easy to ignore.

Perhaps an alternative way of posting would be to write "RFC only,
please don't apply" at the end of the cover letter. Maybe folks will 
at least get thru reading the cover letter then :S
