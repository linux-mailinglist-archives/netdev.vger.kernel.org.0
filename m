Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827E93A4F78
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 17:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhFLPQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 11:16:47 -0400
Received: from mail-ed1-f43.google.com ([209.85.208.43]:41645 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLPQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 11:16:45 -0400
Received: by mail-ed1-f43.google.com with SMTP id g18so38644613edq.8;
        Sat, 12 Jun 2021 08:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AOS+6E45S4HFlEAHfUqlAx96+7qdQmswXk2G8O9G+yg=;
        b=BKKFAex71wFiloEQA5nApi9o7oz3J/7uxJQTmlOv8vZJBD1mw0088i/RB4Ts4bWeXI
         MvdGd43slkg5C91If7iZ+4a/W974bi4fYWCRroZ5259ByS58WnaIo+fHlwX2pjfh2GQ/
         FcydXJbJW/ElntWx0voiAxrxzbS6cf+U1xvljMrzoxnmluF+cK+ogR66vI60VmNTPfrQ
         5Lmmxdql798BNc0WxLlsH/zxv1eL5QZX/3n9ySHNyggAp0Zrl6qgdCOEFxMHK6372+mw
         +zOCh/LhLLjp3YKJDBlXhDo1mQ1ZexgTbhsd7NjtD90vYGTYTTS4PnnUx4icQ/jGzGTa
         pK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AOS+6E45S4HFlEAHfUqlAx96+7qdQmswXk2G8O9G+yg=;
        b=Wfggs9w2ovxqN5IHAnOAeEjQrSUX2hL8VDtDWHsf5TcGw7hE9Ec271hiMDGIg07VNu
         uHLif8if2yMOdY2K1l7oUWaFtV7NaMofg5MNKUMosPYuLvBNZHgwwi+JszdeLOXiuwuz
         Jet2EGsxtQQbKPF9rV+XQyo1H7tLrj+FfVo2CkyDt8fUnlZBqMa1gmbDNEWfOl3BfEHB
         DfQgjDo5LTQ+4ODAN1aRHCbzxQcdHjyxxaLB5VA+gFSZFQ57KAw2bz9713O+M4vk2px/
         5qTgly0kZnFYGYXcvAXmvX+QYfLGKLKc9mpDRFRYawq0dp9gY6x2w/FPtiOPKmEdrXtL
         PNlQ==
X-Gm-Message-State: AOAM530Smpe+vGViqonS/TE3uy9Tsh3PeQYDhcOpa8kZi0xeGnWj9nEt
        PTk+9sUUMUjPqNBhE3rJK9s=
X-Google-Smtp-Source: ABdhPJz82KCcENI3Zmz+OCSBgrBu4f30Zfb941T9pVoUYwD7a86n0Lt8V09ZsCEd6/CdI61w19v67w==
X-Received: by 2002:a05:6402:1644:: with SMTP id s4mr8989433edx.190.1623510812559;
        Sat, 12 Jun 2021 08:13:32 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r2sm3209162ejc.78.2021.06.12.08.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jun 2021 08:13:31 -0700 (PDT)
Date:   Sat, 12 Jun 2021 18:13:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 4/9] net: phy: micrel: apply resume errata
 workaround for ksz8873 and ksz8863
Message-ID: <20210612151330.nvin5ldcx6xunexx@skbuf>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-5-o.rempel@pengutronix.de>
 <20210611192010.ptmblzpj6ilt24ly@skbuf>
 <20210612042639.bgsloltuqoipmwtk@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210612042639.bgsloltuqoipmwtk@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 12, 2021 at 06:26:39AM +0200, Oleksij Rempel wrote:
> On Fri, Jun 11, 2021 at 10:20:10PM +0300, Vladimir Oltean wrote:
> > On Fri, Jun 11, 2021 at 09:15:22AM +0200, Oleksij Rempel wrote:
> > > The ksz8873 and ksz8863 switches are affected by following errata:
> > > 
> > > | "Receiver error in 100BASE-TX mode following Soft Power Down"
> > > |
> > > | Some KSZ8873 devices may exhibit receiver errors after transitioning
> > > | from Soft Power Down mode to Normal mode, as controlled by register 195
> > > | (0xC3) bits [1:0]. When exiting Soft Power Down mode, the receiver
> > > | blocks may not start up properly, causing the PHY to miss data and
> > > | exhibit erratic behavior. The problem may appear on either port 1 or
> > > | port 2, or both ports. The problem occurs only for 100BASE-TX, not
> > > | 10BASE-T.
> > > |
> > > | END USER IMPLICATIONS
> > > | When the failure occurs, the following symptoms are seen on the affected
> > > | port(s):
> > > | - The port is able to link
> > > | - LED0 blinks, even when there is no traffic
> > > | - The MIB counters indicate receive errors (Rx Fragments, Rx Symbol
> > > |   Errors, Rx CRC Errors, Rx Alignment Errors)
> > > | - Only a small fraction of packets is correctly received and forwarded
> > > |   through the switch. Most packets are dropped due to receive errors.
> > > |
> > > | The failing condition cannot be corrected by the following:
> > > | - Removing and reconnecting the cable
> > > | - Hardware reset
> > > | - Software Reset and PCS Reset bits in register 67 (0x43)
> > > |
> > > | Work around:
> > > | The problem can be corrected by setting and then clearing the Port Power
> > > | Down bits (registers 29 (0x1D) and 45 (0x2D), bit 3). This must be done
> > > | separately for each affected port after returning from Soft Power Down
> > > | Mode to Normal Mode. The following procedure will ensure no further
> > > | issues due to this erratum. To enter Soft Power Down Mode, set register
> > > | 195 (0xC3), bits [1:0] = 10.
> > > |
> > > | To exit Soft Power Down Mode, follow these steps:
> > > | 1. Set register 195 (0xC3), bits [1:0] = 00 // Exit soft power down mode
> > > | 2. Wait 1ms minimum
> > > | 3. Set register 29 (0x1D), bit [3] = 1 // Enter PHY port 1 power down mode
> > > | 4. Set register 29 (0x1D), bit [3] = 0 // Exit PHY port 1 power down mode
> > > | 5. Set register 45 (0x2D), bit [3] = 1 // Enter PHY port 2 power down mode
> > > | 6. Set register 45 (0x2D), bit [3] = 0 // Exit PHY port 2 power down mode
> > > 
> > > This patch implements steps 2...6 of the suggested workaround. During
> > > (initial) switch power up, step 1 is executed by the dsa/ksz8795
> > > driver's probe function.
> > > 
> > > Note: In this workaround we toggle the MII_BMCR register's BMCR_PDOWN
> > > bit, this is translated to the actual register and bit (as mentioned in
> > > the arratum) by the ksz8_r_phy()/ksz8_w_phy() functions.
> > 
> > s/arratum/erratum/
> > 
> > Also, the commit message is still missing this piece of information you
> > gave in the previous thread:
> > 
> > | this issue was seen  at some early point of development (back in 2019)
> > | reproducible on system start. Where switch was in some default state or
> > | on a state configured by the bootloader. I didn't tried to reproduce it
> > | now.
> > 
> > Years from now, some poor souls might struggle to understand why this
> > patch was done this way. If it is indeed the case that the issue is only
> > seen during the handover between bootloader and kernel, there is really
> > no reason to implement the ERR workaround in phy_resume instead of doing
> > it once at probe time.
> 
> Ok, i'll drop this patch for now.

I mean, you don't have to drop it, you just have to provide a competent
explanation for how the patch addresses the ERR as described by Microchip.
Do you still have a board with this switch?
