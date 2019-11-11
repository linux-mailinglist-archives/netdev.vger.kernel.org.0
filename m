Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96654F7720
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKKOyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:54:32 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34616 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfKKOyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 09:54:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PMM8m0oOXHaxLjKtCimHL8KYh0qVxQ2Hftjl2Qo1OZM=; b=U5jVMdIzY7Tgi965JUQUZRYA6
        NlW6RiaSjqw1cFcwL/yXU/N/gMzlBhFmDT2VL0vT42VN7kecDWdIAoaa9EDsaJJDJIukyXPtHeHXz
        ZCxeNaRGlTfD2HNE1G/Kprn9twIBg03JlWfSjE28ZZfA+5ZJt7hkIzQfLypiQ7EBtOOV/PVutnp8y
        h0Ohtb10d8ALFP62CJhbIQAZaPvHtYZ1oyX4GhSiPhJJU0IeSGs6qEzQw7pQLDzzlEEQoFdqwk3I3
        h80H2sLbsCOqVHfr7D527mYEQuWWwA8EDTx4f4lGqaKS8CQ5PZWh87yHxDCK8KK7SYWsECXoSmkOc
        tHSZtsU6w==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:54824)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iUB5E-0006Ka-Ne; Mon, 11 Nov 2019 14:54:24 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iUB5B-0000Zd-KH; Mon, 11 Nov 2019 14:54:21 +0000
Date:   Mon, 11 Nov 2019 14:54:21 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: add core phylib sfp support
Message-ID: <20191111145421.GF1344@shell.armlinux.org.uk>
References: <20191110142226.GB25745@shell.armlinux.org.uk>
 <E1iTo7N-0005Sj-Nk@rmk-PC.armlinux.org.uk>
 <20191110161307.GC25889@lunn.ch>
 <20191110164007.GC25745@shell.armlinux.org.uk>
 <20191110170040.GG25889@lunn.ch>
 <20191111140114.GH25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111140114.GH25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 02:01:14PM +0000, Russell King - ARM Linux admin wrote:
> So, how does one make sure that the .yaml files are correct?
> 
> The obvious thing is to use the "dtbs_check" target, described by
> Documentation/devicetree/writing-schema.md, but that's far from
> trivial.
> 
> First it complained about lack of libyaml development, which is easy
> to solve.  Having given it that, "dtbs_check" now complains:
> 
> /bin/sh: 1: dt-doc-validate: not found
> /bin/sh: 1: dt-mk-schema: not foundmake[2]: ***
> [...Documentation/devicetree/bindings/Makefile:12:
> Documentation/devicetree/bindings/arm/stm32/stm32.example.dts] Error 127
> 
> (spot the lack of newline character - which is obviously an entirely
> different problem...)
> 
> # apt search dt-doc-validate
> Sorting... Done
> Full Text Search... Done
> # apt search dt-mk-schema
> Sorting... Done
> Full Text Search... Done
> 
> Searching google, it appears it needs another git repository
> (https://github.com/robherring/dt-schema/) from Rob Herring to use
> this stuff, which is totally undocumented in the kernel tree.

Okay, that just seems to be "examples" rather than something which is
installable to provide the necessary commands.

So, I'm afraid I've no idea how I can change any of the .yaml files
and know that the changes are in fact correct.  Given that, I think we
need to drop the rule that DT bindings are documented prior to being
merged into the kernel until there is some decent and full
documentation.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
