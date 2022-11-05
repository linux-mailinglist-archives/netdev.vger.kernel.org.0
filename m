Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745F661DAA0
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 14:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiKENeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 09:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKENes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 09:34:48 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771DDF033
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 06:34:47 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id b2so19749604eja.6
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 06:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cucCIpuZCnI1IITqIWrjc3ZK6vwihe/XXiONDuTut6I=;
        b=Ys1xu28tU+NCp5I2WRGdQ1hpWZXuxyKKileejLYtum3fn8SMxDT4rdcC70+CE4KO7n
         Jk9ES+WHexymcIX7bfEyo2FuHRtDwzzoMSduKycJvyaLCOyXVaUYE0PIeN50CufA/c6P
         K/rjDM0WeLY/Ho1WzpJmNfY3BhPAWKLAJbejUhda2yUNPTiAJsuvboumwGW4IQ35KTiI
         jIIOJB0v0Wr7fvlDhurwrQHKlmS/fGkjOivyiSgL9wooPTV9XMm/jOLvfdinh11453L7
         OQ9SKggOR3YX1gJZ38dfGdy0BN0Gz2GKHh6OeSa4NCI2g3ZLBkwaaNyUV36NV+zKUr7c
         D7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cucCIpuZCnI1IITqIWrjc3ZK6vwihe/XXiONDuTut6I=;
        b=lz60e7XNUddgznyVKQ/qvpnhLdXO/nL4cG5LN8yYfM5em5VGriGgVs14FSD663E3wi
         RBouXsaznQ0c5OwY0YMQHkwJDb4AlrmlYFr97NEMW34wdbEVuFVvFejCInrlij9sCcSQ
         rAGfUtxajMx1uZetZwI2tLJhK4NQoFVkx7SkAyfmLLWEwq+jKQuh223cUHs5lEl3tFtw
         FyKVjADeUneWKxmUprseZ9NAXc5/tprIuaWYCEJ5A+nmognENbREAv+1cVPUoroQs7I9
         TplGdu5plZ6638cO+sEjJXFDDsPNb5xNm6rp24BVW1HShTtcOlVEQ50PzdsVyqU4o5vv
         C8Tg==
X-Gm-Message-State: ACrzQf0j4X+AEaYkCujIVwyCiIZPSiL+u5HUKGYETQLR6HFMrOqEFETk
        X5M6DcZIFXvLJC4UYsI7sW0mci+DxpMcfQ==
X-Google-Smtp-Source: AMsMyM4HdaqXlZbACKpKpU0I0dMpKQ/hFq0nu5UOwuDo7Yf++7IqY4mF1LbyFpjyUYFtjkc47YAROw==
X-Received: by 2002:a17:907:968e:b0:7a4:bd01:d7f with SMTP id hd14-20020a170907968e00b007a4bd010d7fmr37502270ejc.542.1667655285786;
        Sat, 05 Nov 2022 06:34:45 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id ky14-20020a170907778e00b0073c8d4c9f38sm921227ejc.177.2022.11.05.06.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 06:34:45 -0700 (PDT)
Date:   Sat, 5 Nov 2022 15:34:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     piergiorgio.beruto@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: Potential issue with PHYs connected to the same MDIO bus and
 different MACs
Message-ID: <20221105133443.jlschsx6zvkrqbph@skbuf>
References: <022c01d8f111$6e6e2580$4b4a7080$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <022c01d8f111$6e6e2580$4b4a7080$@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Piergiorgio,

On Sat, Nov 05, 2022 at 01:23:36PM +0100, piergiorgio.beruto@gmail.com wrote:
> Now, to use the third PHY I added a MAC IP in the FPGA (Altera Triple Speed
> MAC) for which a Linux driver already exists (altera_tse). However, unless I
> connect the PHY to the dedicated TSE mdio bus (which requires HW
> modifications), I get an error saying that the driver could not connect to
> the PHY. I assumed this could be a conflict between the phylink interface
> (used by STMMAC) and the "plain" PHY of APIs used by the TSE driver (which
> seems a bit old).

Can you share exactly what error message you get?
Also, btw, the tse driver was also converted to phylink in net-next, see
commit fef2998203e1 ("net: altera: tse: convert to phylink"). Maybe it
would be a good idea to retry with that.

> I then decided to use a different MAC IP for which I'm writing a driver
> using the phylink interface.
> I got stuck at a point where the function "phy_attach_direct" in
> phy_device.c gives an Oops (see log below).
>
> Doing some debug, it seems that the NULL pointer comes from
> dev->dev.parent->driver.
> The "parent" pointer seems to reference the SoC BUS which the MAC IP belongs
> to.
>
> Any clue of what I might be doing wrong? I also think it is possible that
> the problem I saw with the altera_tse driver could have something in common
> with this?

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
> One more information: I can clearly see from the log my PHYs being scanned
> and enumerated. So again, I don't think the problem relates to the PHYs.
>
> This is the Oops log.
>
> 8<--- cut here ---
> [ 36.823689] Unable to handle kernel NULL pointer dereference at virtual address 00000008
> [ 36.835783] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> [ 36.841090] Modules linked in: onsemi_tmac(O)
> [ 36.845452] CPU: 0 PID: 240 Comm: ifconfig Tainted: G O 5.19.12-centurion3-1.0.3.0 #10
> [ 36.854646] Hardware name: Altera SOCFPGA
> [ 36.858644] PC is at phy_attach_direct+0x98/0x328
> [ 36.863357] LR is at phy_attach_direct+0x8c/0x328
> [ 36.868057] pc : [<c051f218>] lr : [<c051f20c>] psr: 600d0013
> [ 36.874304] sp : d0eedd58 ip : 00000000 fp : d0eede78
> [ 36.992376] Process ifconfig (pid: 240, stack limit = 0xa94bafcf)
> [ 36.998455] Stack: (0xd0eedd58 to 0xd0eee000)
> [ 37.182221] phy_attach_direct from phylink_fwnode_phy_connect+0xa4/0xdc
> [ 37.188932] phylink_fwnode_phy_connect from tmac_open+0x44/0x9c [onsemi_tmac]
> [ 37.196160] tmac_open [onsemi_tmac] from __dev_open+0x110/0x128
> [ 37.202180] __dev_open from __dev_change_flags+0x168/0x17c
> [ 37.207758] __dev_change_flags from dev_change_flags+0x14/0x44
> [ 37.213680] dev_change_flags from devinet_ioctl+0x2ac/0x5fc
> [ 37.219349] devinet_ioctl from inet_ioctl+0x1ec/0x214

In phy_attach_direct() we currently have this in net-next (didn't check 5.19):

int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
		      u32 flags, phy_interface_t interface)
{
	/* For Ethernet device drivers that register their own MDIO bus, we
	 * will have bus->owner match ndev_mod, so we do not want to increment
	 * our own module->refcnt here, otherwise we would not be able to
	 * unload later on.
	 */
	if (dev)
		ndev_owner = dev->dev.parent->driver->owner;
	if (ndev_owner != bus->owner && !try_module_get(bus->owner)) {
		phydev_err(phydev, "failed to get the bus module\n");
		return -EIO;
	}

I think the (out-of-tree?!) driver you're writing needs to make a call
to SET_NETDEV_DEV() in order for the dev->dev.parent to be set. Also, a
bunch of other stuff relies on this. Is your driver making that call?
