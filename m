Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B705F598C88
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344244AbiHRT3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbiHRT3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:29:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970D0CAC94;
        Thu, 18 Aug 2022 12:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=m2TqgJNIWwyazWLkcfL5XAqqJsNhYd/phFt1LrX7IWI=; b=pqC0tvA1f7M1sE//R6GUZWzhPY
        ijf52Tp9m+74M4K2fWmgGTAHW4gProQ0js2fwOR/EsFjAzOkggrVwPLaqWt0TYQVIZfAjOsok7ftx
        01qLB2sevp7Axe1iwzczxKRex4W0ofZzC9I8nmmgghUJvesFrWC+8fZ9GqodM3zjbtBc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOlCV-00Dplv-O9; Thu, 18 Aug 2022 21:29:07 +0200
Date:   Thu, 18 Aug 2022 21:29:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     wei.fang@nxp.com
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 net 2/2] net: phy: at803x: add disable hibernation
 mode support
Message-ID: <Yv6TA9xfx4m2+YrH@lunn.ch>
References: <20220818030054.1010660-1-wei.fang@nxp.com>
 <20220818030054.1010660-3-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818030054.1010660-3-wei.fang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 11:00:54AM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> When the cable is unplugged, the Atheros AR803x PHYs will enter
> hibernation mode after about 10 seconds if the hibernation mode
> is enabled and will not provide any clock to the MAC. But for
> some MACs, this feature might cause unexpected issues due to the
> logic of MACs.
> Taking SYNP MAC (stmmac) as an example, if the cable is unplugged
> and the "eth0" interface is down, the AR803x PHY will enter
> hibernation mode. Then perform the "ifconfig eth0 up" operation,
> the stmmac can't be able to complete the software reset operation
> and fail to init it's own DMA. Therefore, the "eth0" interface is
> failed to ifconfig up. Why does it cause this issue? The truth is
> that the software reset operation of the stmmac is designed to
> depend on the RX_CLK of PHY.
> So, this patch offers an option for the user to determine whether
> to disable the hibernation mode of AR803x PHYs.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
