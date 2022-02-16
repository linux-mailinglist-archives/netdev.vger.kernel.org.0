Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7BE4B90DF
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbiBPTCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:02:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237717AbiBPTCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:02:15 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA9EAEF3C;
        Wed, 16 Feb 2022 11:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jPVgM3Czxex/BXYWE+oPiRHfRnmgAcQ1bxX494QSNQI=; b=VZTFzOZHB+bbnkwuiRUJFXwUGO
        ZtLX8bRgW/vx23qrs8yzb5U/K/OISrMvF2q7T5OmFOF/J0RdH9vyhmI5lp8WogILrC+XSDyhlkfVb
        VugzkMKPSsPJbLZ/JoXAMK+yAlf2VXrtTYpXUU6n/ffrkkBB7KAHW8NifL7twGhxrS9I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nKPYY-006Fdf-3B; Wed, 16 Feb 2022 20:01:38 +0100
Date:   Wed, 16 Feb 2022 20:01:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Jonas Gorski <jonas.gorski@gmail.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "maintainer:BROADCOM IPROC GBIT ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] Revert "net: ethernet: bgmac: Use
 devm_platform_ioremap_resource_byname"
Message-ID: <Yg1KEsGU1SFE5GUW@lunn.ch>
References: <20220216184634.2032460-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216184634.2032460-1-f.fainelli@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 10:46:34AM -0800, Florian Fainelli wrote:
> From: Jonas Gorski <jonas.gorski@gmail.com>
> 
> This reverts commit 3710e80952cf2dc48257ac9f145b117b5f74e0a5.
> 
> Since idm_base and nicpm_base are still optional resources not present
> on all platforms, this breaks the driver for everything except Northstar
> 2 (which has both).
> 
> The same change was already reverted once with 755f5738ff98 ("net:
> broadcom: fix a mistake about ioremap resource").
> 
> So let's do it again.
> 
> -	bgmac->plat.idm_base = devm_platform_ioremap_resource_byname(pdev, "idm_base");
> -	if (IS_ERR(bgmac->plat.idm_base))
> -		return PTR_ERR(bgmac->plat.idm_base);
> -	else
> +	/* The idm_base resource is optional for some platforms */

I see you are adding a comment. Good idea. Lets see if the bot
handlers are clever enough to actually read it, or just blindly do
what the bot says to do, without actually trying to understand the
code.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
