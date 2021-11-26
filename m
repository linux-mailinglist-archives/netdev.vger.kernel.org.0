Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEC845EC08
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 11:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhKZLCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 06:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbhKZLAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 06:00:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79C4C08EA3D;
        Fri, 26 Nov 2021 02:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TV9geI3pefr1PEB8Jp2tszmjn2Seeeo5pcnatqfJP5k=; b=rKXbP9Y5VpN5pXTkZNjF7zTtW7
        xXUXssxHzuVMj2cp0fBi25HRXYaOx9UnukCbdLjxDKyP04jn+VQ6ixQ0XjpgRrrBzxJC33IN2gOr8
        7fDOylJO1uy+3skZvcVBGoQKIMNJQjQ/kbPZ30qYaWSgRnKZKeJrUrTwco+uuFKyy4LKOcSXxSkKW
        TZv4W8YkOkyWj8bP/EfUJsiSWV6bIxnLxMoVnHGnrSCCG03qCsDCdAZHQRpUZgjW/8JHukgUBlKxU
        VyODCr/GYdbPLCWJncPB5SupN8swCpk7IAAdF4A7kfK6zQdXLz0m1JhGmg1271OltvuCD1jwOR55E
        fve85ZmA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55910)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mqYST-0002wP-Ag; Fri, 26 Nov 2021 10:27:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mqYSR-0003CQ-Ee; Fri, 26 Nov 2021 10:27:55 +0000
Date:   Fri, 26 Nov 2021 10:27:55 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     zhuyinbo <zhuyinbo@loongson.cn>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, masahiroy@kernel.org,
        michal.lkml@markovi.net, ndesaulniers@google.com
Subject: Re: [PATCH v1 1/2] modpost: file2alias: fixup mdio alias garbled
 code in modules.alias
Message-ID: <YaC2qyfGhOnT3Nve@shell.armlinux.org.uk>
References: <1637583298-20321-1-git-send-email-zhuyinbo@loongson.cn>
 <YZukJBsf3qMOOK+Y@lunn.ch>
 <5b561d5f-d7ac-4d90-e69e-5a80a73929e0@loongson.cn>
 <YZxqLi7/JDN9mQoK@lunn.ch>
 <0a9e959a-bcd1-f649-b4cd-bd0f65fc71aa@loongson.cn>
 <YZzykR2rcXnu/Hzx@lunn.ch>
 <92c667be-7d33-7742-5fb9-7e5670024911@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92c667be-7d33-7742-5fb9-7e5670024911@loongson.cn>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 05:34:36PM +0800, zhuyinbo wrote:
> Hi Andrew,
> 
> 
>     I don't get udev log, but I can find that phy module wether be load by
> lsmod ways,  and you can try
> 
>     it in any a phy deice and in any arch platform.   in addition,  I will
> send v2 version patch that need consider
> 
>     some phy device doesn't follow IEEE802.3 protocol strictly and doesn't
> read phy id from phy register successfully,

I'm not sure I understand what you've said above correctly.

You seem to be saying that the module has been loaded (it appears in
lsmod) but it doesn't get bound to the PHY device? If that is correct,
there isn't a problem with the modalias, but there's something wrong
in the driver matching.

The last sentence seems to point at a completely different problem -
one concerning an inability to correctly read the PHY ID from the PHY
itself. If that's the case, then that isn't a problem with modalias,
it's a problem with reading the PHY ID.


The existing modalias scheme doesn't care about the format of the ID.
Normally the least significant four bits are the PHY revision, but that
doesn't always hold. Let's take a couple of examples:

The PHY ID for a Marvell PHY is 0x01410dd1. This will expand to:

mdio:00000001010000010000110111010001

The kernel modalias tables will be generated from an ID of 0x01410dd0
with a mask of 0xfffffff0. The mask means "ignore the bottom four bits".
So, we end up with this in the module's alias table:

mdio:0000000101000001000011011101????

udev knows that "?" is a wildcard. Consequently the above matches.

On an Atheros PHY, this has an ID value of 0x004dd072. The driver also
has a value of 0x004dd072 and a mask of 0xffffffef, meaning bit 4 is
ignored:

mdio:00000000010011011101000001110010 <= PHY ID
mdio:000000000100110111010000011?0010 <= module alias table

This will also match a PHY with id 0x004dd062.

mdio:00000000010011011101000001100010 <= PHY ID

The current modalias approach is flexible. Publishing the raw hex ID
and having an exact match is too inflexible for phylib and will lead to
users reporting regressions.

Please show us:

1) the contents of the phy_id file for the PHY you are having problems
   with. This can be found in /sys/bus/mdio_bus/devices/.../phy_id

2) which driver in the kernel is a problem.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
