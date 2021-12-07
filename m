Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AED546B9F4
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 12:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbhLGLW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 06:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhLGLW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 06:22:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AD9C061574;
        Tue,  7 Dec 2021 03:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=puXO/URYZZV0HEmNm8bcF52r22t9X05W7Zkze/s7HN0=; b=fxqH8h8L+SjiPLy3Y5uaD61+q2
        yBlqSZLmsUzV4TaPX9cARVKB/9Tu03LLgflqgAD+N3+ofLbX/wkDDemVAjstezyjItKBGvmp0GCJi
        u9h/hhyDfH4aADQasZTuy+RGfYFJkSh36hpyrPB6wlysCBdWDkEcM3Ie1R91N25tfIyO/IPJJOyq5
        cGt74hXz5dOwDQiFdgI4bE4DwYfQbvOmp+DdX2/Ma6VFhmrbRu3Rt3kwBdRBA7yRw/RbIc4xd3BFW
        yPAhuRmMqno7Fg71f6EaCeUjVXch5X6rJ7b/TN3sfyN0ZW6nF7ZWtgk5ETHXPjFCH+FsBYekYlu6C
        4Te5fW8Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56142)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muYUm-00065O-DO; Tue, 07 Dec 2021 11:18:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muYUj-0005HR-Mo; Tue, 07 Dec 2021 11:18:49 +0000
Date:   Tue, 7 Dec 2021 11:18:49 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     zhuyinbo <zhuyinbo@loongson.cn>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled
 code in modules.alias
Message-ID: <Ya9DGWhJBJA1zRZ5@shell.armlinux.org.uk>
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
 <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
 <YaYPMOJ/+OXIWcnj@shell.armlinux.org.uk>
 <YabEHd+Z5SPAhAT5@lunn.ch>
 <f91f4fff-8bdf-663b-68f5-b8ccbd0c187a@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f91f4fff-8bdf-663b-68f5-b8ccbd0c187a@loongson.cn>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 05:41:51PM +0800, zhuyinbo wrote:
> 在 2021/12/1 上午8:38, Andrew Lunn 写道:
> > > However, this won't work for PHY devices created _before_ the kernel
> > > has mounted the rootfs, whether or not they end up being used. So,
> > > every PHY mentioned in DT will be created before the rootfs is mounted,
> > > and none of these PHYs will have their modules loaded.
> > 
> > Hi Russell
> > 
> > I think what you are saying here is, if the MAC or MDIO bus driver is
> > built in, the PHY driver also needs to be built in?
> > 
> > If the MAC or MDIO bus driver is a module, it means the rootfs has
> > already been mounted in order to get these modules. And so the PHY
> > driver as a module will also work.
> > 
> > > I believe this is the root cause of Yinbo Zhu's issue.
> 
> I think you should be right and I had did lots of test but use rquest_module
> it doesn't load marvell module, and dts does't include any phy node. even
> though I was use "marvell" as input's args of request_module.

Please can you report the contents of /proc/sys/kernel/modprobe, and
the kernel configuration of CONFIG_MODPROBE_PATH. I wonder if your
userspace has that module loading mechanism disabled, or your kernel
has CONFIG_MODPROBE_PATH as an empty string.

If the module is not present by the time this call is made, then
even if you load the appropriate driver module later, that module
will not be used - the PHY will end up being driven by the generic
clause 22 driver.

> > That is not true universally for all MDIO though - as
> > xilinx_gmii2rgmii.c clearly shows. That is a MDIO driver which uses DT
> > the compatible string to do the module load. So, we have proof there
> > that Yinbo Zhu's change will definitely cause a regression which we
> > can not allow.
> 
> I don't understand that what you said about regression.  My patch doesn't
> cause  xilinx_gmii2rgmii.c driver load fail, in this time that do_of_table
> and platform_uevent will be responsible "of" type driver auto load and my
> patch was responsible for "mdio" type driver auto load,

xilinx_gmii2rgmii is not a platform driver. It is a mdio driver:

static struct mdio_driver xgmiitorgmii_driver = {
              ^^^^^^^^^^^

Therefore, platform_uevent() is irrelevant since this will never match
a platform device. It will only match mdio devices, and the uevent
generation for that is via mdio_uevent() which is the function you
are changing.

> In default code. There are request_module to load phy driver, but as Russell
> King said that request_module doesn't garantee auto load will always work
> well, but udev mechanism can garantee it. and udev mechaism is more
> mainstream, otherwise mdio_uevent is useless. if use udev mechanism that my
> patch was needed. and if apply my patch it doesn't cause request_module
> mechaism work bad because I will add following change:

Please report back what the following command produces on your
problem system:

/sbin/modprobe -vn mdio:00000001010000010000110111010001

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
