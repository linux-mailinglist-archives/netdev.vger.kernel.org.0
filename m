Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2B861DB08
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 15:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiKEOmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 10:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKEOmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 10:42:36 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FFCDFF9
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 07:42:35 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id a11-20020a05600c2d4b00b003cf6f5fd9f1so4755615wmg.2
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 07:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=McVXNXHmqBpMuqY46K2hzpjDTE0BbwErhSVH4KujPv4=;
        b=jG2Zr5SS9FGh8c3boNZZVWxLUNuvAe+uwNsn8tz9Wx2TtifykL4Xq3jKjirm60dj+Q
         Z2yDnqwxG96UJsZMdnSLFnyMxULEM3KU1ZS0Qcg9EUEBtJxrNcFMWsOrGKmMa4kW+sxA
         lfU2ddeYi5rWKXMaHV37olXu3k6mdaNlxmWEd9/9w4/oLt7v7jwBJtX6n3KJj1otcZ2Q
         R2uhUX6R8d/78u10+O9MyFv+RZixJTZnbFLW4BhZIz4tMneD0fS7GQ5OQslrQxjHMltm
         FL02OWmiUSIGl6D5hLwUwB5TBirIYcF5SWk+bIML65D39YwzsfXrKiJNMaykQ70ogIek
         1+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=McVXNXHmqBpMuqY46K2hzpjDTE0BbwErhSVH4KujPv4=;
        b=vrTh/RDSDt2WTiAYg0WOGC7zAMuHdP63h7meJUIiwmURCCT4QLTs6bKFm//7U1P7Yb
         2TSgZ62vzg0Jif/N6DnPtYIJoW+EEClvU/y1Z28whnbDnv4UgvPTSYrFEwd7hND33o/Q
         cg9JB3VoPoCj8Kit+FVZug/mYACX9/d76ctmXd+dgKi6vbdf0R42a8EubNd7mb8myPgC
         J87oiYv9p4LKw/5J0eNjkQo3dddTItLXP8PH5Ots+8gv/uTowxEeob22hRAoKv7T2BVr
         +/bMcqvURcMjNeMUvyuXwmbCJJxcibra6jK3qN9Pn4/qsOrE1UcRPi3avVZoKJfKat9t
         bgwg==
X-Gm-Message-State: ACrzQf33nIOZSYXdO7iYfTvo3SB9vY6k3wWjTzCB6OeoEY64KBSQ7CMd
        acEb42S6HgLAbxyAk/G+1c27Ysl5woNrDg==
X-Google-Smtp-Source: AMsMyM5X++DxHb/ayL4i7pKCSPaBg0cWNBgPgrpp5SQExJfnHhaPXQe3Ku9k2g4PuNGbwcWnzF890A==
X-Received: by 2002:a1c:790d:0:b0:3cf:a1cd:6431 with SMTP id l13-20020a1c790d000000b003cfa1cd6431mr1791344wme.134.1667659353628;
        Sat, 05 Nov 2022 07:42:33 -0700 (PDT)
Received: from zbpt9gl1 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id c16-20020a5d5290000000b0022e36c1113fsm2321965wrv.13.2022.11.05.07.42.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Nov 2022 07:42:33 -0700 (PDT)
From:   <piergiorgio.beruto@gmail.com>
To:     "'Vladimir Oltean'" <olteanv@gmail.com>
Cc:     <netdev@vger.kernel.org>
References: <022c01d8f111$6e6e2580$4b4a7080$@gmail.com> <20221105133443.jlschsx6zvkrqbph@skbuf> <024601d8f124$5c797510$156c5f30$@gmail.com>
In-Reply-To: <024601d8f124$5c797510$156c5f30$@gmail.com>
Subject: RE: Potential issue with PHYs connected to the same MDIO bus and different MACs
Date:   Sat, 5 Nov 2022 15:42:37 +0100
Message-ID: <024801d8f124$d9877700$8c966500$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGWsFLDOi30rVKqVG4E9amvaBZqWAHQK04OAdXThfWul7ipAA==
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

Ah, sorry! I copied & paste the wrong code for tmac_open (that was just a
test).
This is the actual code:

static int tmac_open(struct net_device *dev) {
   struct tmac_info *priv = netdev_priv(dev);
   int ret;

   if(request_irq(dev->irq, &tmac_interrupt, 0, dev->name, dev))
      return -EAGAIN;

   // this is the function that gives that Oops
   ret = phylink_of_phy_connect(priv->phylink, priv->dev->of_node, 0);
   
   // other initialization stuff
}

Regards,
Piergiorgio

-----Original Message-----
From: piergiorgio.beruto@gmail.com <piergiorgio.beruto@gmail.com> 
Sent: 5 November, 2022 15:39
To: 'Vladimir Oltean' <olteanv@gmail.com>
Cc: netdev@vger.kernel.org
Subject: RE: Potential issue with PHYs connected to the same MDIO bus and
different MACs

Hello Vladimir,
Thank you very much for your kind reply.

It'll take me some time to reproduce the problem with the altera_tse but I
will certainly try the new version as you suggested.
In the meantime, I wish to continue writing my own driver. It is in fact out
of tree for the only reason that the MAC IP has not been released yet and it
is still experimental. The plan is to merge it into the main tree as soon as
it is stable.

This is what my driver does (I'm omitting the details, just focusing on the
PHY attach).

static int tmac_probe(struct platform_device *pdev) {
   struct device_node *np = pdev->dev.of_node;
   struct phylink *phylink;
   struct net_device *ndev;
   struct tmac_info *priv;
   
   phy_interface_t phy_mode;
   int ret = 0;

   // allocate device and related private data
   ndev = alloc_etherdev(sizeof(struct tmac_info));

   // .... check for errors ...   

   SET_NETDEV_DEV(ndev, &pdev->dev);

   // .. initialize private data, map registers and IRQs, configure DMAs...

   ret = of_get_phy_mode(np, &phy_mode);
   if (ret) {
      dev_err(priv->dev, "incorrect phy-mode\n");
      goto err_no_phy;
   }

   priv->phylink_config.dev = &pdev->dev;
   priv->phylink_config.type = PHYLINK_NETDEV;

   phylink = phylink_create(&priv->phylink_config, pdev->dev.fwnode,
phy_mode, &tmac_phylink_mac_ops);
   
   // ... check for errors ....

   priv->phylink = phylink;

   // ... initialize the MAC registers ...

   ndev->netdev_ops = &tmac_netdev_ops;
   ndev->ethtool_ops = &tmac_ethtool_ops;

   platform_set_drvdata(pdev, ndev);

   ret = register_netdev(ndev);
   if(ret) {
      dev_err(&pdev->dev, "failed to register the T-MAC device\n");
      ret = -ENODEV;
      
      goto err_netdev_register;
   }

   // success
   return 0;
}

static int tmac_open(struct net_device *dev) {
   struct tmac_info *priv = netdev_priv(dev);
   struct device_node *np; 
   int ret;

   if(request_irq(dev->irq, &tmac_interrupt, 0, dev->name, dev))
      return -EAGAIN;

   // this is the function that gives that Oops
   ret = phylink_of_phy_connect(priv->phylink, np, 0);

   // other initialization stuff
}

Do you see anything wrong with this?

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
> scanned and enumerated. So again, I don't think the problem relates to 
> the
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


