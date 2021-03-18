Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A0E340E98
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhCRTrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 15:47:42 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:56973 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhCRTrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:47:23 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 00C0822205;
        Thu, 18 Mar 2021 20:47:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1616096842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kN8bZjd6MucBwy0bM3Jw4atHdJPuaGWV/aoke/M32Sg=;
        b=TgeZAwWc6memHmA1xkgNRFkRTNYd56fxGCqKDiW5Dp/tEM8TUW0Ua9eanj0bWjcuI7X/Tg
        VhzENmExgKtTLQ7cDSw+m8+XUqNXP1yJq3LHYjOHkBcY/5UnZqP/RvhzlsLHEm7bMo8+HS
        4w51Y2FLu6fRbv77M5pIKMHlNbRz6uY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Mar 2021 20:47:21 +0100
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 net-next] net: phy: at803x: remove at803x_aneg_done()
In-Reply-To: <20210318194431.14811-1-michael@walle.cc>
References: <20210318194431.14811-1-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <cc948086f552146bf9ac07b372104138@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-03-18 20:44, schrieb Michael Walle:
> Here is what Vladimir says about it:
> 
>   at803x_aneg_done() keeps the aneg reporting as "not done" even when
>   the copper-side link was reported as up, but the in-band autoneg has
>   not finished.
> 
>   That was the _intended_ behavior when that code was introduced, and
>   Heiner have said about it [1]:
> 
>   | That's not nice from the PHY:
>   | It signals "link up", and if the system asks the PHY for link 
> details,
>   | then it sheepishly says "well, link is *almost* up".
> 
>   If the specification of phy_aneg_done behavior does not include
>   in-band autoneg (and it doesn't), then this piece of code does not
>   belong here.
> 
>   The fact that we can no longer trigger this code from phylib is yet
>   another reason why it fails at its intended (and wrong) purpose and
>   should be removed.
> 
> Removing the SGMII link check, would just keep the call to
> genphy_aneg_done(), which is also the fallback. Thus we can just remove
> at803x_aneg_done() altogether.
> 
> [1] 
> https://lore.kernel.org/netdev/fdf0074a-2572-5914-6f3e-77202cbf96de@gmail.com/
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Sorry forgot the version history:

Changes since v1:
  - more detailed commit message

-michael
