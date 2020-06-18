Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6050A1FF635
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731207AbgFRPIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgFRPIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 11:08:45 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006FCC06174E;
        Thu, 18 Jun 2020 08:08:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id m2so2807527pjv.2;
        Thu, 18 Jun 2020 08:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Uz50xEzOGukPJL2T8FGXWSOAM4ralSHvFnEldUgfbS4=;
        b=mwErFNYjou9o7fMW/VDgLs+pA24zJAtlFHZ4nK65wWXDVmw7FIual2UZ+eMy7f/lQP
         ooHFfRNuDu6Fxnn5sEF6aHvFTjTXXiHl+d2kkMpwUQsxEOrvFzF/LQQvLEkXFTZcoak7
         e9nxh+wP3vMSkxJRXxw9g95TSb8cpsBgB/aGMkwmD8tkwuHKpRUxUOBvcKyqubZQblzc
         aqOgl7oN2nybuvqcNVapIet/cFjppj48YVJnibvA7jOokU4rTU755vFT8qIyCqT3Mt+s
         uMOlC+PeZCFExwrlLATpm2Bl1VkgdZDtiWeOrurqKGf0voxuFQEp7OdNZEOjjtbVuogW
         Xpzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Uz50xEzOGukPJL2T8FGXWSOAM4ralSHvFnEldUgfbS4=;
        b=rYufioUCzfaeVyGAllTv1u2inX/gMBClCHB2IJONpY/m0CIbVjmiAPVrlM4nXu4S4b
         RxC7P8iPHWdp83AgfAjPvu/2LsBkiMARYcV30uph3rEmXX3WTgrZ57F8bN3xqrm78KEs
         DXyEjVf3UfSWA+9ikKla3bjerU1nByKAtmKKnbiS0bT+eZv8sPz6erePx2mjVXFTjDet
         M0lmbYPNGVnS2RBHxpD3jMiwOGWfdOkSJh8m1uZ/iqBGjBnxv15G7cJmjjv9Wnlp/AUj
         9AO27sgZ60K059BqJ1VGSLuvZlXEIxNq+S03MD7dT+Not2aOOtak7fDlVYhkJG2v60Vt
         uhxA==
X-Gm-Message-State: AOAM532nhNoyoVQSX/nWWzcvyBfBRnMguPa0bnWhYTTnze8GIdUzZjkN
        Oan09eISyr89w0YfKihUgII=
X-Google-Smtp-Source: ABdhPJyCxws7l7NtktmAvHTvzvQ4w8U5UdQG7aMGHhpEkSEEQpa6v4utPNOe2eVHjRmVGVGXHqYFIw==
X-Received: by 2002:a17:902:26f:: with SMTP id 102mr3979508plc.226.1592492923453;
        Thu, 18 Jun 2020 08:08:43 -0700 (PDT)
Received: from localhost ([144.34.193.30])
        by smtp.gmail.com with ESMTPSA id q13sm3432257pfk.8.2020.06.18.08.08.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Jun 2020 08:08:42 -0700 (PDT)
Date:   Thu, 18 Jun 2020 23:08:32 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kevin Groeneveld <kgroeneveld@gmail.com>
Subject: Re: [PATCH net v1] net: phy: smsc: fix printing too many logs
Message-ID: <20200618150832.GA25889@nuc8i5>
References: <20200617153340.17371-1-zhengdejin5@gmail.com>
 <20200617161925.GE205574@lunn.ch>
 <20200617175039.GA18631@nuc8i5>
 <20200617184334.GA240559@lunn.ch>
 <20200617202450.GX1551@shell.armlinux.org.uk>
 <20200617213642.GE240559@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617213642.GE240559@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 11:36:42PM +0200, Andrew Lunn wrote:
> On Wed, Jun 17, 2020 at 09:24:50PM +0100, Russell King - ARM Linux admin wrote:
> > On Wed, Jun 17, 2020 at 08:43:34PM +0200, Andrew Lunn wrote:
> > > You have explained what the change does. But not why it is
> > > needed. What exactly is happening. To me, the key thing is
> > > understanding why we get -110, and why it is not an actual error we
> > > should be reporting as an error. That is what needs explaining.
> > 
> > The patch author really ought to be explaining this... but let me
> > have a go.  It's worth pointing out that the comments in the file
> > aren't good English either, so don't really describe what is going
> > on.
> > 
> > When this PHY is in EDPD mode, it doesn't always detect a connected
> > cable.  The workaround for it involves, when the link is down, and
> > at each read_status() call:
> > 
> > - disable EDPD mode, forcing the PHY out of low-power mode
> > - waiting 640ms to see if we have any energy detected from the media
> > - re-enable entry to EDPD mode
> > 
> > This is presumably enough to allow the PHY to notice that a cable is
> > connected, and resume normal operations to negotiate with the partner.
> > 
> > The problem is that when no media is detected, the 640ms wait times
> > out (as it should, we don't want to wait forever) and the kernel
> > prints a warning.
> 
> Hi Russell
> 
> Yes, that is what i was thinking. 
> 
> There probably should be a comment added just to prevent somebody
> swapping it back to phy_read_poll_timeout(). It is not clear that
> -ETIMEOUT is expected under some conditions.
> 
> 	  Andrew

Hi Andrew and Russell,

First of all, thanks very much for your comment!

I did not understand Andrew's comments correctly in the previous email,
sorry for my bad English. I found something in the commit 776829de90c597
("net: phy: workaround for buggy cable detection by LAN8700 after cable
plugging") about why it is not an actual error when get a timeout error
in this driver. the commit's link is here:

https://lore.kernel.org/patchwork/patch/590285/

As Russell said, it just for fix a hardware bug on LAN8700 device by wait
640ms, so it should not as an actual error when got timeout.

The following is my understanding:

It leads to unstable detection of plugging in Ethernet cable when LAN87xx
is in Energy Detect Power-Down mode. Because the ENERGYON bit is not set.

For fix this issue, it will disables Energy Detect Power-Down mode and
check ENERGYON bit to waiting for response on link pulses to detect
presence of plugged Ethernet cable in the 640ms. if got the ENERGYON bit
is set, I guess the cable plug-in event was detected and will report an
interrupt after exit lan87xx_read_status() funtion, if the ENERGYON bit
is not set, the plug-in event was not detected. after that, entry Energy
Detect Power-Down mode again.

it will re-call lan87xx_read_status() funtion by interrupt when got the
ENERGYON bit is set. and check link status again. then, It will get a
stable link status for LAN87xx device.

So the timeout for wait 640ms should not as an actual error.

Thanks!

Dejin



