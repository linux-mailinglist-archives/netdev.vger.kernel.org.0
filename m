Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E251E1271
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 18:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgEYQOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 12:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgEYQOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 12:14:46 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E91C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 09:14:45 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id l21so20973014eji.4
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 09:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Igi1wYPmbZ52ZF1zAmcPMzjwpBxx5YzQMcAAF6CJlZo=;
        b=Zs13VXhNBJdnwlMZP1yVYyNeQQwV3pboExTIYNnvMZjEqOS3y+wE8fjopk1VYL1ByL
         C6nmeKC/9d2QQu1+XzGRZuiOtCgg8+TvgJHWuBEj5qV89Gz2OD+9BAKyiRitoZTxIDla
         5c6ofxihVttOaVsuCfRUwR3a2cGD1xaYbnWbZg+Avzm0PJEfEmG4HGercsNuGksK3G+5
         vNP9tilLyNEOznQePxLKPRlZYI/GWpngNhNGhfhgX5K2en0fFvyJGeW2h334pVCzTDEG
         V0l01qVh8Ycxy9ZKYH9TbiQPwyELU+/DFF8cRCPaAoha6r/jCWv3Btxy2q4rC0PYZAwI
         AmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Igi1wYPmbZ52ZF1zAmcPMzjwpBxx5YzQMcAAF6CJlZo=;
        b=UWkUBpJhsZNg9acRSySLwuFJ4PLhf0ZDBsTDzPQzaL7zsrWo6kJ2qsM46d11mvLPqP
         moxpc/CX4Mty3p9RJLWgb6VuNfjCX43YliEiarffO/6ZzWsWRayb58g3n8whqGOOLYza
         SnNlYIe3qxIHuSkYZI9w+4Ub3nPAA3rX8brQx4535aZ9ZDcj5wJw0HNdbD/TwBy+n8CR
         wzIG4ebltNNXlbLQkh2YtCCiD2OssP0m99RlBPIrz+mxyUNrfQUGirRrGnzPVq7P6/Cb
         lCA+BCmo3Y6GEQwGPuXts/4k/e/xBM9vP3CREL6cgqVZus+RNWpXvmnIEJ0U8Lp1CDHA
         3hgg==
X-Gm-Message-State: AOAM530QhnZojGZt4/VXAfUU03M0U3kwqZ9L/O9HYKBoIWlhU4fF7SUc
        V2PO2VuXwc/YzGGBJ0vVak34kg0JXsPjVLqyWyM=
X-Google-Smtp-Source: ABdhPJy44BKr5kcSw2EuBc4EqadQm7YTP+IIkjov4KfwQUupPAkNe4ub2i5pZ44jpftjB7H3RKsZpZyKvCds3nh6Z4Q=
X-Received: by 2002:a17:906:4a8c:: with SMTP id x12mr19211332eju.279.1590423284233;
 Mon, 25 May 2020 09:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200524212251.3311546-1-olteanv@gmail.com> <AM6PR04MB39762C1D25DF9A1788C39DC5ECB30@AM6PR04MB3976.eurprd04.prod.outlook.com>
In-Reply-To: <AM6PR04MB39762C1D25DF9A1788C39DC5ECB30@AM6PR04MB3976.eurprd04.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 25 May 2020 19:14:33 +0300
Message-ID: <CA+h21hqUYMVt=tfP=x4y343gXFj8P1+-KFV2-YFOf5RY_ewQaw@mail.gmail.com>
Subject: Re: [PATCH] dpaa_eth: fix usage as DSA master, try 3
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Madalin,

On Mon, 25 May 2020 at 18:20, Madalin Bucur (OSS)
<madalin.bucur@oss.nxp.com> wrote:
>
> > -----Original Message-----
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Sent: Monday, May 25, 2020 12:23 AM
> > To: davem@davemloft.net
> > Cc: andrew@lunn.ch; f.fainelli@gmail.com; vivien.didelot@gmail.com;
> > Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>; netdev@vger.kernel.org
> > Subject: [PATCH] dpaa_eth: fix usage as DSA master, try 3
> >
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > The dpaa-eth driver probes on compatible string for the MAC node, and
> > the fman/mac.c driver allocates a dpaa-ethernet platform device that
> > triggers the probing of the dpaa-eth net device driver.
> >
> > All of this is fine, but the problem is that the struct device of the
> > dpaa_eth net_device is 2 parents away from the MAC which can be
> > referenced via of_node. So of_find_net_device_by_node can't find it, and
> > DSA switches won't be able to probe on top of FMan ports.
> >
> > It would be a bit silly to modify a core function
> > (of_find_net_device_by_node) to look for dev->parent->parent->of_node
> > just for one driver. We're just 1 step away from implementing full
> > recursion.
>
> Changing a netdevice parent to satisfy this DSA assumption can be regarded as
> being just as silly. How about changing the DSA assumption, not the generic
> of_find_net_device_by_node API?
>

Changing of_find_net_device_by_node to do what, exactly? Actually the
check for dev->parent is there for PCI device drivers which don't
require OF to probe but may have OF bindings nonetheless, for things
like phy-handle etc. We use that for LS1028A, and it works both ways:
the Ocelot/Felix switch (a PCI function) can find the host ENETC port
(another PCI function) via DT, and a cascaded switch (a SPI device)
can use the Ocelot/Felix switch again via DT.

If there is good enough justification to make
of_find_net_device_by_node look at dev->parent->parent, then ok, we
can do that, but I thought that changing the parent is clean and
unintrusive enough. Users trying to follow the device hierarchy are
probably wondering what's with that dpaa-ethernet.0 device anyway,
what does it correspond to. I don't know all the ways in which people
are using dpaa-eth, but I don't know what useful information can be
gathered from having dpaa-ethernet.0 as parent for the net-device
(information which this patch would be losing).

> ACPI support is in the making for these platforms, is DSA going to work
> with that?
>

I don't know anything about ACPI.

> > Actually there have already been at least 2 previous attempts to make
> > this work:
> > - Commit a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
> > - One or more of the patches in "[v3,0/6] adapt DPAA drivers for DSA":
> >   https://patchwork.ozlabs.org/project/netdev/cover/1508178970-28945-1-
> > git-send-email-madalin.bucur@nxp.com/
> >   (I couldn't really figure out which one was supposed to solve the
> >   problem and how).
>
> The prior changes were made without access to a DSA setup. Has this patch been
> tested working on such a setup?
>
> > Point being, it looks like this is still pretty much a problem today.
> > On T1040, the /sys/class/net/eth0 symlink currently points to
> >
> > ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/dpa
> > a-ethernet.0/net/eth0
> >
> > which pretty much illustrates the problem. The closest of_node we've got
> > is the "fsl,fman-memac" at /soc@ffe000000/fman@400000/ethernet@e6000,
> > which is what we'd like to be able to reference from DSA as host port.
> >
> > For of_find_net_device_by_node to find the eth0 port, we would need the
> > parent of the eth0 net_device to not be the "dpaa-ethernet" platform
> > device, but to point 1 level higher, aka the "fsl,fman-memac" node
> > directly. The new sysfs path would look like this:
> >
> > ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net
> > /eth0
> >
> > And this is exactly what SET_NETDEV_DEV does. It sets the parent of the
> > net_device. The new parent has an of_node associated with it, and
> > of_dev_node_match already checks for the of_node of the device or of its
> > parent.
> >
> > Fixes: a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
> > Fixes: c6e26ea8c893 ("dpaa_eth: change device used")
>
> If this is picked up in stable trees, we may need to make sure some other
> changes are there to keep things working, i.e. this one may matter:
>
> commit 060ad66f97954fa93ad495542c8a4f1b6c45aa34
> Author: Madalin Bucur <madalin.bucur@nxp.com>
> Date:   Wed Oct 23 12:08:44 2019 +0300
>
>     dpaa_eth: change DMA device
>
>     The DPAA Ethernet driver is using the FMan MAC as the device for DMA
>     mapping. This is not actually correct, as the real DMA device is the
>     FMan port (the FMan Rx port for reception and the FMan Tx port for
>     transmission). Changing the device used for DMA mapping to the Fman
>     Rx and Tx port devices.
>

The top-most Fixes: tag points to this commit precisely. No one will
backport it beyond that.
That being said, it's pretty clear to me that no mainline user so far
has been affected by this, so I'm also ok with targeting this patch
for net-next

> On each target code base one needs to review the impact.
> Speaking of impact, does this change keep the existing udev rules functional?
>

Yup.
Responding to this, as well as to ''Has this patch been tested working
on such a setup?":

[root@T1040 ~] # ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state
UNKNOWN mode DEFAULT group default qlen 1000
    link/ether e2:4f:d3:fb:ff:7a brd ff:ff:ff:ff:ff:ff
3: fm1-gb3: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq
state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:e0:0c:00:82:03 brd ff:ff:ff:ff:ff:ff
4: fm1-gb4: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq
state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:e0:0c:00:82:04 brd ff:ff:ff:ff:ff:ff
5: fm1-gb0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1532 qdisc mq state
UP mode DEFAULT group default qlen 1000
    link/ether 00:e0:0c:00:82:00 brd ff:ff:ff:ff:ff:ff
6: fm1-gb1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state
UP mode DEFAULT group default qlen 1000
    link/ether 00:e0:0c:00:82:01 brd ff:ff:ff:ff:ff:ff
7: fm1-gb2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state
UP mode DEFAULT group default qlen 1000
    link/ether 00:e0:0c:00:82:02 brd ff:ff:ff:ff:ff:ff
8: enP1p1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc
pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 68:05:ca:12:88:d9 brd ff:ff:ff:ff:ff:ff
9: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT
group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
10: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT
group default qlen 1000
    link/sit 0.0.0.0 brd 0.0.0.0
11: swp0@fm1-gb0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc
noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 00:e0:0c:00:82:00 brd ff:ff:ff:ff:ff:ff
12: swp1@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:e0:0c:00:82:00 brd ff:ff:ff:ff:ff:ff
13: swp2@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:e0:0c:00:82:00 brd ff:ff:ff:ff:ff:ff
14: swp3@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:e0:0c:00:82:00 brd ff:ff:ff:ff:ff:ff
15: swp4@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:e0:0c:00:82:00 brd ff:ff:ff:ff:ff:ff
16: swp5@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:e0:0c:00:82:00 brd ff:ff:ff:ff:ff:ff
17: swp6@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:e0:0c:00:82:00 brd ff:ff:ff:ff:ff:ff
18: swp7@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:e0:0c:00:82:00 brd ff:ff:ff:ff:ff:ff
[root@T1040 ~] # ip link set dev swp0 down
[  841.482839] mscc_seville ffe800000.ethernet-switch swp0: Link is Down
[root@T1040 ~] # ip link set dev swp0 up
[  853.245566] mscc_seville ffe800000.ethernet-switch swp0:
configuring for inband/qsgmii link mode
[  853.255228] 8021q: adding VLAN 0 to HW filter on device swp0
[  856.323253] mscc_seville ffe800000.ethernet-switch swp0: Link is Up
- Unknown/Unknown - flow control rx/tx
[  856.333001] IPv6: ADDRCONF(NETDEV_CHANGE): swp0: link becomes ready

fm1-gb0 is DSA master for the embeded Vitesse/Microsemi/Microchip
Seville switch on NXP T1040. The "fm1-gb0" etc net device names are
coming from the following rules which I haven't modified:

[root@T1040 ~] # cat /etc/udev/rules.d/71-fsl-dpaa-persistent-networking.rules
# Rules for handling naming the DPAA FMan ethernet ports in a consistent way
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ffe4e0000",
NAME="fm1-gb0"
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ffe4e2000",
NAME="fm1-gb1"
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ffe4e4000",
NAME="fm1-gb2"
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ffe4e6000",
NAME="fm1-gb3"
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ffe4e8000",
NAME="fm1-gb4"
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ffe4f0000",
NAME="fm1-10g"
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ffe5e0000",
NAME="fm2-gb0"
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ffe5e2000",
NAME="fm2-gb1"
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ffe5e4000",
NAME="fm2-gb2"
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ffe5e6000",
NAME="fm2-gb3"
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ffe5e8000",
NAME="fm2-gb4"
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ffe5f0000",
NAME="fm2-10g"

# P1023 has its Fman @ different offsets
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ff7e0000",
NAME="fm1-gb0"
SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="ff7e2000",
NAME="fm1-gb1"

# Rename macless0 port to "macless0"
SUBSYSTEM=="net", ATTR{device_type}=="macless0", NAME="macless0"

and the net device names are coming from the "label" device tree
properties of each individual seville port.

> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > index 2cd1f8efdfa3..6bfa7575af94 100644
> > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > @@ -2914,7 +2914,7 @@ static int dpaa_eth_probe(struct platform_device
> > *pdev)
> >       }
> >
> >       /* Do this here, so we can be verbose early */
> > -     SET_NETDEV_DEV(net_dev, dev);
> > +     SET_NETDEV_DEV(net_dev, dev->parent);
> >       dev_set_drvdata(dev, net_dev);
> >
> >       priv = netdev_priv(net_dev);
> > --
> > 2.25.1
>

Regards,
-Vladimir
