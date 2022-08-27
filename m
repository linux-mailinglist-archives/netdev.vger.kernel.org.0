Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EF05A3383
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 03:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239126AbiH0BhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 21:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbiH0BhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 21:37:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD079DF0AF;
        Fri, 26 Aug 2022 18:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B631B831BD;
        Sat, 27 Aug 2022 01:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA85DC433D6;
        Sat, 27 Aug 2022 01:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661564232;
        bh=gCe5krUjt94WhtRKYuI73X7CtqBoOaSa4DzCVLYy4Zw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=scS+oXKoPVI7/Fj6tkib3BKNPT+WmkmHIUQ54KyLmfgR3uZTZnojA/Ps//YoWJrJT
         MsWaN2mpo0SG58YVGaRTxprQ5dIHuS/UtSjMe+AEG+A3XiUxAY0VvPZl053N/iTiFv
         7fU51+UuAsfptR3A7NYtonhfX4A3AwyazdxRwoPTof/7jPp8I18XS+62czefLJ79C2
         +3bvldG3SZSh7z+dvuz9shcj8oEK1RbykDSs5pAlf1p8UnNiKASjT0z6wI8SMZqJtU
         zAuqsLCRqXrDod/AJcX2YRy7X9lphuMHRvT8GpfpNh8ODOkDit1gDowjc47+3E/8IB
         KiKxdpdOgJtFA==
Date:   Fri, 26 Aug 2022 18:37:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, michael@walle.cc,
        UNGLinuxDriver@microchip.com, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next v2] net: phy: micrel: Make the GPIO to be
 non-exclusive
Message-ID: <20220826183711.567bc7e8@kernel.org>
In-Reply-To: <YwfYnwzQsDruVi5y@lunn.ch>
References: <20220825201447.1444396-1-horatiu.vultur@microchip.com>
        <YwfYnwzQsDruVi5y@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 22:16:31 +0200 Andrew Lunn wrote:
> On Thu, Aug 25, 2022 at 10:14:47PM +0200, Horatiu Vultur wrote:
> > The same GPIO line can be shared by multiple phys for the coma mode pin.
> > If that is the case then, all the other phys that share the same line
> > will failed to be probed because the access to the gpio line is not
> > non-exclusive.
> > Fix this by making access to the gpio line to be nonexclusive using flag
> > GPIOD_FLAGS_BIT_NONEXCLUSIVE. This allows all the other PHYs to be
> > probed.
> > 
> > Fixes: 738871b09250ee ("net: phy: micrel: add coma mode GPIO")
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

The tree name switch in the subject compared to v1 is unintentional?
