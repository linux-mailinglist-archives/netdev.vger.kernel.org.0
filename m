Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5721161DBB2
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 16:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiKEPeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 11:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiKEPeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 11:34:20 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC58CE0B
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 08:34:19 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id g12so10644720wrs.10
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 08:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=53VEzyonhxp5hKnNyrF1emmFs5kXRdl1g6WF0RXLI0E=;
        b=QfSR5Lx4sAZni0soMoTLsHzo5Z0lc/4uXBy7gUyQZj6GS2crQJklonC8jdJuKfDvw/
         K4IF7B4syTLb6I5LKZ7v4P9AQ1Uor7gNZaWOSmmYBmoT+RCUaLX/dg7ZDGFOlmZlAHnt
         jAIm1FuKAJ+idM5+dpD2XnfDY4IjqbksuOEchbdJkgw5+jN17hFib0WiMlPs6+8+Cm4n
         +t2rppnkq4/cN2mguw2zvkKSl5wlixpSyNFCWdKFLs5P0sC1rwHOMO987ViJo6TRghrt
         JCC8NS7LxgMtAyKSp/oDbjUYIMVb5Z8azLYp0xu/ro+e3PpeeC9+deaYe47f0EujW6rQ
         ndbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=53VEzyonhxp5hKnNyrF1emmFs5kXRdl1g6WF0RXLI0E=;
        b=f7Dv4psFR12HmB4pqFm8/8/84en/QKPCQ0ocT+Dl3pO29Z0A8+bUox4BQNGoNkqJoY
         YQupmzv6m2Y2QkuaocoxIDmeUJxUTCyOxkKrAs48HVWf8kR+NJlmm3FT0xKnQBvEEQ7k
         ugpJxvHbAVS5vFpHuOYUPribp0gkf077rZEyLwyZDHvf9HTvOTfHkFspu8k3ZkVXLqyh
         s/rZO65Dppl1NiQfj+4kflAO5OfIHFpHhQAELeNeWDD751s6zTwyj93iqp2KL2XZyzDL
         gZG/rbLaYiuImcrUpP4w6oU8AE2x/sv2pStOTJQPpJZ6i+bJ30rx5Xg32IuyNdwqVusN
         0j2g==
X-Gm-Message-State: ACrzQf00wNGpOIS301/uBEA/Bk3sIq30ACzlSxCydYsROSenPf2QzRbT
        eQSMdiNIwBv1ea1FK4/ofROwdIghlctUJg==
X-Google-Smtp-Source: AMsMyM5cGNM9yDzaV2LrPpe9CjzsXRgIGQY1Yr3+O4jkCcLftkuBHjfAgclpJeCvKle/gfkNwWxzuA==
X-Received: by 2002:adf:f482:0:b0:236:7a2f:69f with SMTP id l2-20020adff482000000b002367a2f069fmr26555333wro.115.1667662457554;
        Sat, 05 Nov 2022 08:34:17 -0700 (PDT)
Received: from zbpt9gl1 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id f17-20020a056000129100b002368a6deaf8sm2384799wrx.57.2022.11.05.08.34.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Nov 2022 08:34:16 -0700 (PDT)
From:   <piergiorgio.beruto@gmail.com>
To:     "'Vladimir Oltean'" <olteanv@gmail.com>
Cc:     <netdev@vger.kernel.org>
References: <022c01d8f111$6e6e2580$4b4a7080$@gmail.com> <20221105133443.jlschsx6zvkrqbph@skbuf>
In-Reply-To: <20221105133443.jlschsx6zvkrqbph@skbuf>
Subject: RE: Potential issue with PHYs connected to the same MDIO bus and different MACs
Date:   Sat, 5 Nov 2022 16:34:20 +0100
Message-ID: <024c01d8f12c$137ddba0$3a7992e0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGWsFLDOi30rVKqVG4E9amvaBZqWAHQK04OrqZy3tA=
Content-Language: en-us
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vladimir,
Sorry for sending more e-mails, but based on your observations I made some
progress and I think this might help in understanding the issue.

I've tried to make the following change to phy_device.c:

diff -urNa linux-5.19.12.orig/drivers/net/phy/phy_device.c
linux-5.19.12/drivers/net/phy/phy_device.c
--- linux-5.19.12.orig/drivers/net/phy/phy_device.c	2022-11-05
16:19:45.049827674 +0100
+++ linux-5.19.12/drivers/net/phy/phy_device.c	2022-11-05
16:21:27.181831665 +0100
@@ -1402,7 +1402,7 @@
 	 * our own module->refcnt here, otherwise we would not be able to
 	 * unload later on.
 	 */
-	if (dev)
+	if (dev && dev->dev.parent->driver)
 		ndev_owner = dev->dev.parent->driver->owner;
 	if (ndev_owner != bus->owner && !try_module_get(bus->owner)) {
 		phydev_err(phydev, "failed to get the bus module\n");
@@ -1785,7 +1785,7 @@
 	bus = phydev->mdio.bus;
 
 	put_device(&phydev->mdio.dev);
-	if (dev)
+	if (dev && dev->dev.parent->driver)
 		ndev_owner = dev->dev.parent->driver->owner;
 	if (ndev_owner != bus->owner)
 		module_put(bus->owner);

The result is that now it WORKS! I can access the PHY and the MAC seems to
function properly.
Although, I suspect this is not really a fix, rather a workaround... this is
what I see when I bringup my network interface:

/root # insmod onsemi-tmac.ko
[   23.181201] onsemi_tmac: loading out-of-tree module taints kernel.
[   23.189175] onsemi_tmac ff200380.tmac: using random MAC address
a6:c1:c7:0d:15:bd

/root # ifconfig eth1 up
[   29.131266] platform c0000000.bridge (unnamed net_device)
(uninitialized): PHY [stmmac-0:09] driver [NCN26000] (irq=50)
[   29.143316] platform c0000000.bridge (unnamed net_device)
(uninitialized): configuring for phy/mii link mode
[   29.153536] platform c0000000.bridge (unnamed net_device)
(uninitialized): Link is Up - 10Mbps/Half - flow control off

The "platform c0000000.bridge" and the " unnamed net_device" makes me think
there is something wrong still.

Looking in the DTS, the c0000000.bridge is the container of the network
device:

soc {
      hps_lw_bridge: bridge@c0000000 {
         #address-cells = <2>;
         #size-cells = <1>;

         compatible = "altr,bridge-21.1", "simple-bus";
         reg = <0xc0000000 0x20000000>,
               <0xff200000 0x00200000>;
         
         reg-names = "axi_h2f", "axi_h2f_lw";
			
         ranges = <0x00000001 0x00000080 0xff200200 0x00000200>,
 	          <0x00000001 0x00000000 0xff200000 0x00000008>,
                         <0x00000001 0x00000010 0xff200010 0x00000010>,
                         <0x00000001 0x00000020 0xff200020 0x00000020>;

        tmac0: tmac@100000200 {
      	compatible = "onsemi,tmac-1.0", "onsemi,tmac";
      	reg = <0x00000001 0x00000200 0x00000200>;
      	interrupt-parent = <&intc>;
      	interrupts = <0 40 4>;
      	status = "okay";

      	phy-handle = <&phy3>;
      	phy-mode = "mii";
         };
      }; //end bridge@0xc0000000 (hps_bridges)
   };

I've tried to debug further but I'm getting lost at some point.
I was wondering if this rings a bell to you?

Thanks,
Piergiorgio

-----Original Message-----
From: Vladimir Oltean <olteanv@gmail.com> 
Sent: 5 November, 2022 14:35
To: piergiorgio.beruto@gmail.com
Cc: netdev@vger.kernel.org
Subject: Re: Potential issue with PHYs connected to the same MDIO bus and
different MACs

Hi Piergiorgio,

On Sat, Nov 05, 2022 at 01:23:36PM +0100, piergiorgio.beruto@gmail.com
wrote:
> Now, to use the third PHY I added a MAC IP in the FPGA (Altera Triple 
> Speed
> MAC) for which a Linux driver already exists (altera_tse). However, 
> unless I connect the PHY to the dedicated TSE mdio bus (which requires 
> HW modifications), I get an error saying that the driver could not 
> connect to the PHY. I assumed this could be a conflict between the 
> phylink interface (used by STMMAC) and the "plain" PHY of APIs used by 
> the TSE driver (which seems a bit old).

Can you share exactly what error message you get?
Also, btw, the tse driver was also converted to phylink in net-next, see
commit fef2998203e1 ("net: altera: tse: convert to phylink"). Maybe it would
be a good idea to retry with that.

> I then decided to use a different MAC IP for which I'm writing a 
> driver using the phylink interface.
> I got stuck at a point where the function "phy_attach_direct" in 
> phy_device.c gives an Oops (see log below).
>
> Doing some debug, it seems that the NULL pointer comes from
> dev->dev.parent->driver.
> The "parent" pointer seems to reference the SoC BUS which the MAC IP 
> belongs to.
>
> Any clue of what I might be doing wrong? I also think it is possible 
> that the problem I saw with the altera_tse driver could have something 
> in common with this?

Not clear what problem you were seeing with the altera_tse driver...

> The MAC would be located inside the bus as well.
>
> My DTS looks like this (just listing the relevant parts):
>
> {
>    SoC {
>         gmac1 {
>            // This is the stmmac which has all the PHYs attached.
>            phy-handle=<&phy1>
>             ...
>            mdio {
>               phy1 {
>                  ...
>               }
>
>               phy2 {
>                  ...
>               }
>
>               phy3 {
>                  .
>               }
>          } // mdio
>       } // gmac1
>
>       gmac0 {
>          phy-handle=<&phy2>
>          ...
>       }
>
>       bridge {
>           ...
>          myMAC {
>             phy-handle=<&phy3>
>             ...
>          }
>       }
>    } // Soc
> }

Device tree looks more or less okay (not sure what's the "bridge"
though, this is potentially irrelevant).

>
> One more information: I can clearly see from the log my PHYs being 
> scanned and enumerated. So again, I don't think the problem relates to the
PHYs.
>
> This is the Oops log.
>
> 8<--- cut here ---
> [ 36.823689] Unable to handle kernel NULL pointer dereference at 
> virtual address 00000008 [ 36.835783] Internal error: Oops: 5 [#1] 
> PREEMPT SMP ARM [ 36.841090] Modules linked in: onsemi_tmac(O) [ 
> 36.845452] CPU: 0 PID: 240 Comm: ifconfig Tainted: G O 
> 5.19.12-centurion3-1.0.3.0 #10 [ 36.854646] Hardware name: Altera 
> SOCFPGA [ 36.858644] PC is at phy_attach_direct+0x98/0x328 [ 
> 36.863357] LR is at phy_attach_direct+0x8c/0x328 [ 36.868057] pc : 
> [<c051f218>] lr : [<c051f20c>] psr: 600d0013 [ 36.874304] sp : 
> d0eedd58 ip : 00000000 fp : d0eede78 [ 36.992376] Process ifconfig 
> (pid: 240, stack limit = 0xa94bafcf) [ 36.998455] Stack: (0xd0eedd58 
> to 0xd0eee000) [ 37.182221] phy_attach_direct from 
> phylink_fwnode_phy_connect+0xa4/0xdc
> [ 37.188932] phylink_fwnode_phy_connect from tmac_open+0x44/0x9c 
> [onsemi_tmac] [ 37.196160] tmac_open [onsemi_tmac] from 
> __dev_open+0x110/0x128 [ 37.202180] __dev_open from 
> __dev_change_flags+0x168/0x17c [ 37.207758] __dev_change_flags from 
> dev_change_flags+0x14/0x44 [ 37.213680] dev_change_flags from 
> devinet_ioctl+0x2ac/0x5fc [ 37.219349] devinet_ioctl from 
> inet_ioctl+0x1ec/0x214

In phy_attach_direct() we currently have this in net-next (didn't check
5.19):

int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
		      u32 flags, phy_interface_t interface) {
	/* For Ethernet device drivers that register their own MDIO bus, we
	 * will have bus->owner match ndev_mod, so we do not want to
increment
	 * our own module->refcnt here, otherwise we would not be able to
	 * unload later on.
	 */
	if (dev)
		ndev_owner = dev->dev.parent->driver->owner;
	if (ndev_owner != bus->owner && !try_module_get(bus->owner)) {
		phydev_err(phydev, "failed to get the bus module\n");
		return -EIO;
	}

I think the (out-of-tree?!) driver you're writing needs to make a call to
SET_NETDEV_DEV() in order for the dev->dev.parent to be set. Also, a bunch
of other stuff relies on this. Is your driver making that call?

