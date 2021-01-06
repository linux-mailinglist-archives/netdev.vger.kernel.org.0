Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B7A2EC04F
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 16:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbhAFPW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 10:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbhAFPW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 10:22:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDFDC06134C;
        Wed,  6 Jan 2021 07:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XbYn0sE+8caLJmEuS8DK8Q++aIHilNF9bPslhNkLP00=; b=ROxI9vKNkqA4PHf3Vky2YwPsi
        kuK2rjMzhmlZkrpEXYe1s3d6cCkJhQczFXaQIrQXPXxBwvZYRVd0YITYogyJT6wUpkSo9gkV0dIYS
        cCxdOxlzxWgs2NSB3F48UXZrTdw7WbTjlozVsK+jWH9sb5f+77xETN6/m8A542/Le/gERTdXJzzIr
        3XVPSvIAqZwc0FJooz4PNDBZVbGlDHLkhWKuVRT8IwQAJSlPuV3K8Hp34vMYacb667Yngt+kruC2K
        GAQchOhjTF6M727y7k2Phn/N+z8LFutVIy8xbgInctPSOH0hb5BYX7KnS3UpQEE9XA7ot5nF4cGXN
        lOywUIWow==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45186)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kxAd2-0001jW-Ky; Wed, 06 Jan 2021 15:21:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kxAd0-0000Kb-43; Wed, 06 Jan 2021 15:21:38 +0000
Date:   Wed, 6 Jan 2021 15:21:38 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20210106152138.GK1551@shell.armlinux.org.uk>
References: <20201230174307.lvehswvj5q6c6vk3@pali>
 <20201230190958.GW1551@shell.armlinux.org.uk>
 <20201231121410.2xlxtyqjelrlysd2@pali>
 <X+3ume1+wz8HXHEf@lunn.ch>
 <20201231170039.zkoa6mij3q3gt7c6@pali>
 <X+4GwpFnJ0Asq/Yj@lunn.ch>
 <20210102014955.2xv27xla65eeqyzz@pali>
 <CALQZrspktLr3SfVRhBrVK2zhjFzJMm9tQjWXU_07zjwJytk7Cg@mail.gmail.com>
 <20210103024132.fpvjumilazrxiuzj@pali>
 <20210106145532.xynhoufpfyzmurd5@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210106145532.xynhoufpfyzmurd5@pali>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 03:55:32PM +0100, Pali Rohár wrote:
> On my tested CarlitoxxPro module is:
> 
>         Option values                             : 0x00 0x1c
>         Option                                    : RX_LOS implemented, inverted
>         Option                                    : TX_FAULT implemented
>         Option                                    : TX_DISABLE implemented
> 
> When cable is disconnected then in EEPROM at position 0x16e is value
> 0x82. If I call 'ip link set eth1 up' then value changes to 0x02, module
> itself has a link and I can connect to its internal telnet/webserver to
> configure it.

Bit 7 reflects the TX_DISABLE pin state. Bit 1 reflects the RX_LOS pin
state. It isn't specified whether the inverted/non-inverted state is
reflected in bit 1 or not - the definition just says that bit 1 is
"Digital state of the RX_LOS Output Pin."

> I also tested UBNT module and result is:
> 
>         Option values                             : 0x00 0x06
>         Option                                    : RX_LOS implemented
>         Option                                    : RX_LOS implemented, inverted
> 
> Which means that those bits are not implemented.
> 
> Anyway I check position 0x16e and value on its value is randomly either
> 0x79 or 0xff independently of the state of the GPON module.
> 
> So it is really not implemented on UBNT.

There are enhanced options at offset 93 which tell you which of the
offset 110 signals are implemented.

We already have support for these, but only when the corresponding
GPIOs on the host side are not implemented.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
