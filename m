Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E818931D75E
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhBQKN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:13:27 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:54173 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbhBQKM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 05:12:58 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 11A7F22234;
        Wed, 17 Feb 2021 11:12:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613556734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ksN8/hBq42TOuayBOXgGsNoQBvzs2QEmWrrStLVkPX4=;
        b=ZqYEKdnVRHk8glAWxz/RBNMtQXug4lDaV2FMmLMTbPea0mQDKHmc/zax3Os1aD8OqqB0J/
        JWE47y7Su+UK9OcBL0cGHp2n6bdpMEZEURUl2CUvPCVQLoiumbcxjDe5S912eSsn/t/JCv
        jVay5a+r7eCn20WkCtZH4TAAin6MA2U=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 17 Feb 2021 11:12:11 +0100
From:   Michael Walle <michael@walle.cc>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: icplus: Call phy_restore_page() when
 phy_select_page() fails
In-Reply-To: <20210217100420.GD1463@shell.armlinux.org.uk>
References: <YCy1F5xKFJAaLBFw@mwanda>
 <20210217100420.GD1463@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <6a7032cea19b8798176012f128f4977a@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-17 11:04, schrieb Russell King - ARM Linux admin:
> On Wed, Feb 17, 2021 at 09:17:59AM +0300, Dan Carpenter wrote:
>> Smatch warns that there is a locking issue in this function:
>> 
>> drivers/net/phy/icplus.c:273 ip101a_g_config_intr_pin()
>> warn: inconsistent returns '&phydev->mdio.bus->mdio_lock'.
>>   Locked on  : 242
>>   Unlocked on: 273
>> 
>> It turns out that the comments in phy_select_page() say we have to 
>> call
>> phy_restore_page() even if the call to phy_select_page() fails.
> 
> It seems it's a total waste of time documenting functions...

You once said

"""
Kernel development is fundamentally a difficult, frustrating and
depressing activity.
"""

But really this comment doesn't make it much better. Yes I've made
a mistake although I _read_ the function documentation. So shame on
me.

-michael
