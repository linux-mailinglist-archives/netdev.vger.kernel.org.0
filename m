Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133ED6DB7ED
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 03:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjDHBKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 21:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDHBKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 21:10:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4A0D53D;
        Fri,  7 Apr 2023 18:10:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C8616542B;
        Sat,  8 Apr 2023 01:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A65C433EF;
        Sat,  8 Apr 2023 01:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680916239;
        bh=MgIHaUPbLPIRxFyPud+qDb3JXtJb7NXLs5o6wXSbmpg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XdhV0Z0zwb4vREI9N7dFTXhIzlK1fYM4PPQBcqdGj9weoUJAS+RfIlIuw1pM5Lb+F
         KOh+/fevkkkcY9LP7oISyP4j+CC+Ned8x8fA+LVDwVDqzfdmq45A9L2jlf5EYlXScT
         MSTDzeOYUdlkA+4z0yPuF6Hn6P7VciUjmqas/uQctPSf9LTVAwI646BYv4/PkV2i68
         sUjAy/yRnejbC/nKfxX9uBWdmZT6vFHEzZMjjejZuyaf1TG/nwk0LvylYr5A6Z1GnX
         tg17iA+cGxtsjFUHhe63EKrTJ7yEDtAIx0U9j6hU0+TyJcSzdzF0dEK/c41YfNnQpF
         CQ9ryUn3hNRkA==
Date:   Fri, 7 Apr 2023 18:10:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oss-drivers@corigine.com,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH 1/8] net: netronome: constify pointers to
 hwmon_channel_info
Message-ID: <20230407181037.4cecfbde@kernel.org>
In-Reply-To: <3a0391e7-21f6-432a-9872-329e298e1582@roeck-us.net>
References: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
        <20230407084745.3aebbc9d@kernel.org>
        <3a0391e7-21f6-432a-9872-329e298e1582@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Apr 2023 11:05:06 -0700 Guenter Roeck wrote:
> On Fri, Apr 07, 2023 at 08:47:45AM -0700, Jakub Kicinski wrote:
> > On Fri,  7 Apr 2023 16:59:04 +0200 Krzysztof Kozlowski wrote:  
> > > This depends on hwmon core patch:
> > > https://lore.kernel.org/all/20230406203103.3011503-2-krzysztof.kozlowski@linaro.org/  
> > 
> > That patch should have been put on a stable branch we can pull
> > and avoid any conflict risks... Next time?  
> 
> Yes, and I don't feel comfortable applying all those patches through
> the hwmon tree since I have zero means to test them.
> 
> I created a stable branch at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-const

Thanks! Krzysztof, give us a nod and we'll take the series to net-next.
