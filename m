Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B58485049
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 10:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239010AbiAEJnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 04:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239006AbiAEJnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 04:43:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9FCC061761;
        Wed,  5 Jan 2022 01:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZaE1nZoIRZ8RsL/zqQhiX34X1YHI1WzxoWwTLAVoaXs=; b=RHwwnnVQTc2A8yyMkR/W97VLaM
        lA8T5tNII7hwH17NG5euI/p71k8E5Yhr4XlF8FbCMPz5t4ROw8TOlIeD9xImnsKPDgozRDBE83Sxm
        NWdnbiqTq8gLI3z/DSSPSR4iQ8s7w6XkcF2nL+WW8LIRdqnkJohsAiMCXVN3ZZ5sJBwxrQ/7lS5go
        O/mWkgSHd+9xUV9zXKeT0FdhspBX3yAqBIOs6Z9c+envfmY3VQqaipAN09p5R/hrqFNLyaS7FwHPv
        PH8tVnSWNsStJ5owGXTRGiH08Mz4smB99JBhXRmZWwILy1dIcMtb7GlQW1E7M3MLpww2qG3wEwpkk
        51shjz0g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56586)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n52or-0007uC-Hm; Wed, 05 Jan 2022 09:42:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n52om-0008KD-9Y; Wed, 05 Jan 2022 09:42:52 +0000
Date:   Wed, 5 Jan 2022 09:42:52 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     zhuyinbo <zhuyinbo@loongson.cn>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        ndesaulniers@google.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled
 code in modules.alias
Message-ID: <YdVoHMZIAsv2rAu8@shell.armlinux.org.uk>
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
 <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
 <YaYPMOJ/+OXIWcnj@shell.armlinux.org.uk>
 <YabEHd+Z5SPAhAT5@lunn.ch>
 <f91f4fff-8bdf-663b-68f5-b8ccbd0c187a@loongson.cn>
 <257a0fbf-941e-2d9e-50b4-6e34d7061405@loongson.cn>
 <ba055ee6-9d81-3088-f395-8e4e1d9ba136@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba055ee6-9d81-3088-f395-8e4e1d9ba136@loongson.cn>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:33:52AM +0800, zhuyinbo wrote:
> 在 2022/1/4 下午9:11, zhuyinbo 写道:
> > 在 2021/12/7 下午5:41, zhuyinbo 写道:
> > > 在 2021/12/1 上午8:38, Andrew Lunn 写道:
> > > > > However, this won't work for PHY devices created _before_ the kernel
> > > > > has mounted the rootfs, whether or not they end up being used. So,
> > > > > every PHY mentioned in DT will be created before the rootfs is mounted,
> > > > > and none of these PHYs will have their modules loaded.
> > > > 
> > > > Hi Russell
> > > > 
> > > > I think what you are saying here is, if the MAC or MDIO bus driver is
> > > > built in, the PHY driver also needs to be built in?
> > > > 
> > > > If the MAC or MDIO bus driver is a module, it means the rootfs has
> > > > already been mounted in order to get these modules. And so the PHY
> > > > driver as a module will also work.
> > > > 
> > > > > I believe this is the root cause of Yinbo Zhu's issue.
> > > 
> > > I think you should be right and I had did lots of test but use
> > > rquest_module it doesn't load marvell module, and dts does't include
> > > any phy node. even though I was use "marvell" as input's args of
> > > request_module.
> > > > 
> > > > You are speculating that in Yinbo Zhu case, the MAC driver is built
> > > > in, the PHY is a module. The initial request for the firmware fails.
> > > > Yinbo Zhu would like udev to try again later when the modules are
> > > > available.
> > > > 
> > > > > What we _could_ do is review all device trees and PHY drivers to see
> > > > > whether DT modaliases are ever used for module loading. If they aren't,
> > > > > then we _could_ make the modalias published by the kernel conditional
> > > > > on the type of mdio device - continue with the DT approach for non-PHY
> > > > > devices, and switch to the mdio: scheme for PHY devices. I repeat, this
> > > > > can only happen if no PHY drivers match using the DT scheme, otherwise
> > > > > making this change _will_ cause a regression.
> > > > 
> > > 
> > > > Take a look at
> > > > drivers/net/mdio/of_mdio.c:whitelist_phys[] and the comment above it.
> > > > 
> > > > So there are some DT blobs out there with compatible strings for
> > > > PHYs. I've no idea if they actually load that way, or the standard PHY
> > > > mechanism is used.
> > > > 
> > > >     Andrew
> > > > 
> > > 
> > > 
> > >  > That is not true universally for all MDIO though - as
> > >  > xilinx_gmii2rgmii.c clearly shows. That is a MDIO driver which uses DT
> > >  > the compatible string to do the module load. So, we have proof there
> > >  > that Yinbo Zhu's change will definitely cause a regression which we
> > >  > can not allow.
> > > 
> > > I don't understand that what you said about regression.  My patch
> > > doesn't cause  xilinx_gmii2rgmii.c driver load fail, in this time
> > > that do_of_table and platform_uevent will be responsible "of" type
> > > driver auto load and my patch was responsible for "mdio" type driver
> > > auto load,
> > > In default code. There are request_module to load phy driver, but as
> > > Russell King said that request_module doesn't garantee auto load
> > > will always work well, but udev mechanism can garantee it. and udev
> > > mechaism is more mainstream, otherwise mdio_uevent is useless. if
> > > use udev mechanism that my patch was needed. and if apply my patch
> > > it doesn't cause request_module mechaism work bad because I will add
> > > following change:
> > > 
> > > 
> > > 
> > > -       ret = request_module(MDIO_MODULE_PREFIX MDIO_ID_FMT,
> > > -                            MDIO_ID_ARGS(phy_id));
> > > +       ret = request_module(MDIO_MODULE_PREFIX MDIO_ID_FMT, phy_id);
> > >          /* We only check for failures in executing the usermode binary,
> > >           * not whether a PHY driver module exists for the PHY ID.
> > >           * Accept -ENOENT because this may occur in case no
> > > initramfs exists,
> > > diff --git a/include/linux/mod_devicetable.h
> > > b/include/linux/mod_devicetable.h
> > > index 7bd23bf..bc6ea0d 100644
> > > --- a/include/linux/mod_devicetable.h
> > > +++ b/include/linux/mod_devicetable.h
> > > @@ -600,16 +600,7 @@ struct platform_device_id {
> > >   #define MDIO_NAME_SIZE         32
> > >   #define MDIO_MODULE_PREFIX     "mdio:"
> > > 
> > > -#define MDIO_ID_FMT
> > > "%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u"
> > > -#define MDIO_ID_ARGS(_id) \
> > > -       ((_id)>>31) & 1, ((_id)>>30) & 1, ((_id)>>29) & 1,
> > > ((_id)>>28) & 1, \
> > > -       ((_id)>>27) & 1, ((_id)>>26) & 1, ((_id)>>25) & 1,
> > > ((_id)>>24) & 1, \
> > > -       ((_id)>>23) & 1, ((_id)>>22) & 1, ((_id)>>21) & 1,
> > > ((_id)>>20) & 1, \
> > > -       ((_id)>>19) & 1, ((_id)>>18) & 1, ((_id)>>17) & 1,
> > > ((_id)>>16) & 1, \
> > > -       ((_id)>>15) & 1, ((_id)>>14) & 1, ((_id)>>13) & 1,
> > > ((_id)>>12) & 1, \
> > > -       ((_id)>>11) & 1, ((_id)>>10) & 1, ((_id)>>9) & 1, ((_id)>>8)
> > > & 1, \
> > > -       ((_id)>>7) & 1, ((_id)>>6) & 1, ((_id)>>5) & 1, ((_id)>>4) & 1, \
> > > -       ((_id)>>3) & 1, ((_id)>>2) & 1, ((_id)>>1) & 1, (_id) & 1
> > > +#define MDIO_ID_FMT "p%08x"
> > > 
> > > 
> > > 
> > 
> >  > > > > However, this won't work for PHY devices created _before_ the
> > kernel
> >  > > > > has mounted the rootfs, whether or not they end up being used. So,
> >  > > > > every PHY mentioned in DT will be created before the rootfs is
> > mounted,
> >  > > > > and none of these PHYs will have their modules loaded.
> >  > > >
> >  > > > Hi Russell
> >  > > >
> >  > > > I think what you are saying here is, if the MAC or MDIO bus
> > driver is
> >  > > > built in, the PHY driver also needs to be built in?
> >  > > >
> >  > > > If the MAC or MDIO bus driver is a module, it means the rootfs has
> >  > > > already been mounted in order to get these modules. And so the PHY
> >  > > > driver as a module will also work.
> >  > > >
> >  > > > > I believe this is the root cause of Yinbo Zhu's issue.
> >  > >
> >  > > I think you should be right and I had did lots of test but use
> > rquest_module
> >  > > it doesn't load marvell module, and dts does't include any phy
> > node. even
> >  > > though I was use "marvell" as input's args of request_module.
> > 
> >  > Please can you report the contents of /proc/sys/kernel/modprobe, and
> >  > the kernel configuration of CONFIG_MODPROBE_PATH. I wonder if your
> >  > userspace has that module loading mechanism disabled, or your kernel
> >  > has CONFIG_MODPROBE_PATH as an empty string.
> > 
> >  > If the module is not present by the time this call is made, then
> >  > even if you load the appropriate driver module later, that module
> >  > will not be used - the PHY will end up being driven by the generic
> >  > clause 22 driver.
> > 
> >  > > > That is not true universally for all MDIO though - as
> >  > > > xilinx_gmii2rgmii.c clearly shows. That is a MDIO driver which
> > uses DT
> >  > > > the compatible string to do the module load. So, we have proof there
> >  > > > that Yinbo Zhu's change will definitely cause a regression which we
> >  > > > can not allow.
> >  > >
> >  > > I don't understand that what you said about regression.  My patch
> > doesn't
> >  > > cause  xilinx_gmii2rgmii.c driver load fail, in this time that
> > do_of_table
> >  > >and platform_uevent will be responsible "of" type driver auto load
> > and my
> >  > > patch was responsible for "mdio" type driver auto load,
> > 
> >  > xilinx_gmii2rgmii is not a platform driver. It is a mdio driver:
> > 
> >  > static struct mdio_driver xgmiitorgmii_driver = {
> >                ^^^^^^^^^^^
> > 
> >  > Therefore, platform_uevent() is irrelevant since this will never match
> >  > a platform device. It will only match mdio devices, and the uevent
> >  > generation for that is via mdio_uevent() which is the function you
> >  > are changing.
> > 
> > 
> > static const struct of_device_id xgmiitorgmii_of_match[] = {
> >          { .compatible = "xlnx,gmii-to-rgmii-1.0" },
> >          {},
> > };
> > MODULE_DEVICE_TABLE(of, xgmiitorgmii_of_match);
> > 
> > static struct mdio_driver xgmiitorgmii_driver = {
> >          .probe  = xgmiitorgmii_probe,
> >          .mdiodrv.driver = {
> >                  .name = "xgmiitorgmii",
> >                  .of_match_table = xgmiitorgmii_of_match,
> >          },
> > };
> >  From the present point of view, no matter what the situation, my
> > supplement can cover udev or request_module for auto load module.
> > 
> > if that phy driver isn't platform driver my patch cover it I think there
> > is no doubt, if phy driver is platform driver and platform driver udev
> > will cover it. My only requestion is the request_module not work well.
> > 
> > about xgmiitorgmii_of_match that it belongs to platform driver load,
> > please you note. and about your doubt usepace whether disable module
> > load that module load function is okay becuase other device driver auto
> > load is okay.
> > 
> >  > > In default code. There are request_module to load phy driver, but
> > as > Russell
> >  > > King said that request_module doesn't garantee auto load will
> > always work
> >  > > well, but udev mechanism can garantee it. and udev mechaism is more
> >  > > mainstream, otherwise mdio_uevent is useless. if use udev mechanism
> > that my
> >  > > patch was needed. and if apply my patch it doesn't cause
> > request_module
> >  > > mechaism work bad because I will add following change:
> > 
> >  > Please report back what the following command produces on your
> >  > problem system:
> > 
> >  > /sbin/modprobe -vn mdio:00000001010000010000110111010001
> > 
> >  > Thanks.
> > 
> > [root@localhost ~]# lsmod | grep marvell
> > [root@localhost ~]# ls
> > /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
> > /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
> > [root@localhost ~]# /sbin/modprobe -vn
> > mdio:00000001010000010000110111010001
> > insmod /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
> > insmod /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
> > [root@localhost ~]#
> > [root@localhost ~]# cat /proc/sys/kernel/modprobe
> > /sbin/modprobe
> > 
> > BRs,
> > Yinbo
> 
> > On Tue, Jan 04, 2022 at 09:11:56PM +0800, zhuyinbo wrote:
> > > From the present point of view, no matter what the situation, my
> supplement
> > > can cover udev or request_module for auto load module.
> > >
> > > if that phy driver isn't platform driver my patch cover it I think there
> is
> > > no doubt, if phy driver is platform driver and platform driver udev will
> > > cover it. My only requestion is the request_module not work well.
> > >
> > > about xgmiitorgmii_of_match that it belongs to platform driver load,
> please
> > > you note. and about your doubt usepace whether disable module load that
> > > module load function is okay becuase other device driver auto load is
> okay.
> 
> > xgmiitorgmii is *not* a platform driver.
> 
> For the module loading function, you need to focus on the first args "of" in
> function MODULE_ DEVICE_TABLE, not the definition type of this driver.  for
> "of" type that must platform covert it !

Total garbage. You have no idea.

> > > [root@localhost ~]# lsmod | grep marvell
> > > [root@localhost ~]# ls
> > > /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
> > > /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
> > > [root@localhost ~]# /sbin/modprobe -vn
> >mdio:00000001010000010000110111010001
> > > insmod /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
> > > insmod /lib/modules/4.19.190+/kernel/drivers/net/phy/marvell.ko
> > > [root@localhost ~]#
> > > [root@localhost ~]# cat /proc/sys/kernel/modprobe
> > > /sbin/modprobe
> 
> > Great, so the current scheme using "mdio:<binary digits>" works
> > perfectly for you. What is missing is having that modalias in the
> > uevent file.
> No, "lsmod | grep marvel" is NULL, so "mdio:<binary digits>" doesn't work
> well.

[removed the rest of the irrelevant claptrap]

Wrong. Your test proved that module loading using the current scheme
_works_ _for_ _you_.

What doesn't work for you is udev based loading, which is an entirely
different issue. There is NOTHING WRONG WITH THE CURRENT SCHEME OF
USING BINARY DIGITS. THERE IS NO NEED TO CHANGE THIS.

So you can stop posting your stupid patches.

> > So, my patch on the 4th December should cause the marvell module to
> > be loaded at boot time. Please test that patch ASAP, which I have
> > already asked you to do. I'll include it again in this email so you
> > don't have to hunt for it.
> 
> > 8<===
> > From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
> > Subject: [PATCH] net: phy: generate PHY mdio modalias
> 
> > The modalias string provided in the uevent sysfs file does not conform
> > to the format used in PHY driver modules. One of the reasons is that
> > udev loading of PHY driver modules has not been an expected use case.
> 
> > This patch changes the MODALIAS entry for only PHY devices from:
> >         MODALIAS=of:Nethernet-phyT(null)
> > to:
> >         MODALIAS=mdio:00000000001000100001010100010011
> 
> > Other MDIO devices (such as DSA) remain as before.
> 
> > However, having udev automatically load the module has the advantage
> > of making use of existing functionality to have the module loaded
> > before the device is bound to the driver, thus taking advantage of
> > multithreaded boot systems, potentially decreasing the boot time.
> 
> > However, this patch will not solve any issues with the driver module
> > not being loaded prior to the network device needing to use the PHY.
> > This is something that is completely out of control of any patch to
> > change the uevent mechanism.
> 
> > Reported-by: Yinbo Zhu <zhuyinbo@loongson.cn>
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> > drivers/net/phy/mdio_bus.c   |  8 ++++++++
> > drivers/net/phy/phy_device.c | 14 ++++++++++++++
> > include/linux/mdio.h         |  2 ++
> > 3 files changed, 24 insertions(+)
> 
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index 4638d7375943..663bd98760fb 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -1010,8 +1010,16 @@ static int mdio_bus_match(struct device *dev, > >
> struct device_driver *drv)
> 
> >  static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
>  > {
> > +	struct mdio_device *mdio = to_mdio_device(dev);
> > 	int rc;
> >
> > +	/* Use the device-specific uevent if specified */
> > +	if (mdio->bus_uevent) {
> > +		rc = mdio->bus_uevent(mdio, env);
> > +		if (rc != -ENODEV)
> > +			return rc;
> > +	}
> > +
> > 	/* Some devices have extra OF data and an OF-style MODALIAS */
> >  	rc = of_device_uevent_modalias(dev, env);
> > 	if (rc != -ENODEV)
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 23667658b9c6..f4c2057f0202 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -563,6 +563,19 @@ static int phy_request_driver_module(struct
> phy_device *dev, u32 phy_id)
> >  	return 0;
> >  }
> 
> > +static int phy_bus_uevent(struct mdio_device *mdiodev,
> > +			  struct kobj_uevent_env *env)
> > +{
> > +	struct phy_device *phydev;
> > +
> > +	phydev = container_of(mdiodev, struct phy_device, mdio);
> > +
> > +	add_uevent_var(env, "MODALIAS=" MDIO_MODULE_PREFIX MDIO_ID_FMT,
> > +		       MDIO_ID_ARGS(phydev->phy_id));
> > +
> > +	return 0;
> > +}
> > +
> >  struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32
> phy_id,
> >  				     bool is_c45,
> >  				     struct phy_c45_device_ids *c45_ids)
> > @@ -582,6 +595,7 @@ struct phy_device *phy_device_create(struct mii_bus
> *bus, int addr, u32 phy_id,
> >  	mdiodev->dev.type = &mdio_bus_phy_type;
> >  	mdiodev->bus = bus;
> > 	mdiodev->bus_match = phy_bus_match;
> > +	mdiodev->bus_uevent = phy_bus_uevent;
> > 	mdiodev->addr = addr;
> > 	mdiodev->flags = MDIO_DEVICE_FLAG_PHY;
> > 	mdiodev->device_free = phy_mdio_device_free;
> > diff --git a/include/linux/mdio.h b/include/linux/mdio.h
> > index df9c96e56907..5c6676d3de23 100644
> > --- a/include/linux/mdio.h
> > +++ b/include/linux/mdio.h
> > @@ -38,6 +38,8 @@ struct mdio_device {
> >  	char modalias[MDIO_NAME_SIZE];
> 
> >  	int (*bus_match)(struct device *dev, struct device_driver *drv);
> > +	int (*bus_uevent)(struct mdio_device *mdiodev,
> > +			  struct kobj_uevent_env *env);
> > 	void (*device_free)(struct mdio_device *mdiodev);
> > 	void (*device_remove)(struct mdio_device *mdiodev);
> your patch I have a try and it can make marvel driver auto-load. However,
> you need to evaluate the above compatibility issues !
> in addition, if phy id register work bad or other case, you dont' read phy
> id from phy.  your patch will not work well. so you shoud definition a
> any_phy_id, of course, The most critical issue is the above driver
> compatibility, please you note.

You don't make sense, sorry.

> in additon, I have never received your email before. I have to check
> patchwork every time, so if you have a advice that could you send a mail to
> zhuyinbo@loongson.cn .

It was sent to you. Lore has it.

https://lore.kernel.org/all/YavYM2cs0RuY0JdM@shell.armlinux.org.uk/

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
