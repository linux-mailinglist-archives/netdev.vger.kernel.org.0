Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9AD577284
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 01:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiGPXod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 19:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiGPXoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 19:44:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C061DE83;
        Sat, 16 Jul 2022 16:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 600AEB8091D;
        Sat, 16 Jul 2022 23:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DB3C34114;
        Sat, 16 Jul 2022 23:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658015069;
        bh=ukLCCzWM9aySlVzwqmY7ZDlVI0di04E9F59zQrFKTqU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=monQSVxJKIdyb7u/QuchITMgVkM+e+i5mTWfqwpS8wzM+O+B4kP8+RBau1d0exlcW
         3HarlgvtCFSw2DJv4Zq8hE+USqlnMfhcicE3ZY1/eIR96IDD8aASVEbl5ysCuWOkbZ
         5wM0SMz0qoZcE26Sv9HUKzyBs2Kbzw+VMDNHXPtK0lEBY2LZ2mdn7TsE1jmg6khO3G
         iHqlbonGoGaMUgv+3Z5G/Mpp1yUVtGT2ZB7/fqZmHjGrzVlUs1GU+Q3K4Odm1DP5bz
         mQvXONzxgkhsz2X17OKXfvYy/JJpzkTYnCGt48290KUlwb0piwkJvBE38j28+cxX2k
         6cdQjRvzJ2HcQ==
Date:   Sat, 16 Jul 2022 16:44:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
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
        Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 0/6] net: dsa: always use phylink
Message-ID: <20220716164426.2cb64a09@kernel.org>
In-Reply-To: <20220716111551.64rjruz4q4g5uzee@skbuf>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
        <20220715171719.niqcrklpk4ittfvl@skbuf>
        <YtHVLGR0RQ6dWuBS@shell.armlinux.org.uk>
        <20220715160359.2e9dabfe@kernel.org>
        <20220716111551.64rjruz4q4g5uzee@skbuf>
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

On Sat, 16 Jul 2022 14:15:51 +0300 Vladimir Oltean wrote:
> > I'm afraid you are correct. Dave used to occasionally apply RFC patches
> > which kept reviewers on their toes a little bit (it kept me for sure).
> > These days patchwork automatically marks patches as RFC based on
> > the subject, tossing them out of "Action required" queue. So they are
> > extremely easy to ignore.
> > 
> > Perhaps an alternative way of posting would be to write "RFC only,
> > please don't apply" at the end of the cover letter. Maybe folks will 
> > at least get thru reading the cover letter then :S  
> 
> Again, expressing complaints to me for responding late is misdirected
> frustration. The fact that I chose to leave my comments only when
> Russell gave up on waiting for feedback from Andrew doesn't mean I
> ignored his RFC patches, it just means I didn't want to add noise and
> ask for minor changes when it wasn't clear that this is the overall
> final direction that the series would follow. I still have preferences
> about the way in which this patch set gets accepted, and now seems like
> the proper moment to express them.

Oh, sorry, I wasn't commenting on how things played out for this
series. I was mostly reflecting on the fact that the automatic patch
state updates in patchwork have changed how RFC postings can be used 
on netdev, and it happened without any of us being asked our opinion.
