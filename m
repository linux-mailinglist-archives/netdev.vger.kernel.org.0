Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5DF3A4967
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhFKTXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:23:11 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:35788 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhFKTXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:23:11 -0400
Received: by mail-ed1-f42.google.com with SMTP id ba2so36568298edb.2;
        Fri, 11 Jun 2021 12:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=221FOVBCglcDVKzwrUJUqE/qmM310NL3h0+XzvQXUnI=;
        b=KBY82r13x3ey7ilP+Oog00PZeOdpxF4lHJi8/xczpp4+Bc5HOjhUZ5VaJ/7wTCjKoc
         6mB+z5oZI6IAjWDodng9XGF/a2VV6WkVxIwtoewb0FvdNTQQns46/oEEvEY6AiS5eYB4
         mzCxNekOJQIIeGAcY8lLt8CFncoObWJBdgdljNQfWzV9jpTAFBns+g4EI4JHKtTJq/uY
         LO4OBQLsZQzUTo1sGrInEK7V7hTd5CZe62I+LbM57mTV0H/M4B9CHoWUmZ4G9BVcwMnf
         nmLymTOnkKWyJkzhdd4C0HiU94TxqdIvA2KSgwZEBG/YgkI1+DKHhuz1RywrQyFt8mC2
         yDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=221FOVBCglcDVKzwrUJUqE/qmM310NL3h0+XzvQXUnI=;
        b=bAFL+mfyZsdHHR0EaRQwDobdCBKUtt6jco//fGAzcJKN1O6xberx1PqDWu03J4b5B1
         LqRmElk/jAW7z1LeOZF6ueCdbT698Je4fFXbxrHthCk4q4bAbBF6wedIhNwvwMBbGf9A
         ZxD4LE1RoINcsbtFa0+KjXDu7O/tb9fnhRXcDSp79km8zwsrkbfPraLNKYtSNsnlVvAE
         OhdrcPMKfo5DKFHpXMO8Z+Q6hXoFcfcUsf8R8okUZS2hWH1XwWq9PDMWWrg5yCKdN8uI
         CXuURsytLFReFLszZFD3JGbj2QCdwimaMG/lhxT7E59+9wCzW+xzqKuB8Kuddagr7LNJ
         xnHw==
X-Gm-Message-State: AOAM530n55rkpVS27llfrK3cpRvULxmK9IQFvOkpPO6BFerWldToDyvC
        9ULXe/KBq/fP1waOIc8yxB4=
X-Google-Smtp-Source: ABdhPJxQpyO+PGSsUxFqyIvTUes/rBOp4kFn9B/7HMyRDUl5DDLL2lca2gjPNY7iCHcd4NzJ5xHjCA==
X-Received: by 2002:a05:6402:2378:: with SMTP id a24mr5200643eda.161.1623439211921;
        Fri, 11 Jun 2021 12:20:11 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id wq10sm2355744ejb.79.2021.06.11.12.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:20:11 -0700 (PDT)
Date:   Fri, 11 Jun 2021 22:20:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v4 4/9] net: phy: micrel: apply resume errata
 workaround for ksz8873 and ksz8863
Message-ID: <20210611192010.ptmblzpj6ilt24ly@skbuf>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611071527.9333-5-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 09:15:22AM +0200, Oleksij Rempel wrote:
> The ksz8873 and ksz8863 switches are affected by following errata:
> 
> | "Receiver error in 100BASE-TX mode following Soft Power Down"
> |
> | Some KSZ8873 devices may exhibit receiver errors after transitioning
> | from Soft Power Down mode to Normal mode, as controlled by register 195
> | (0xC3) bits [1:0]. When exiting Soft Power Down mode, the receiver
> | blocks may not start up properly, causing the PHY to miss data and
> | exhibit erratic behavior. The problem may appear on either port 1 or
> | port 2, or both ports. The problem occurs only for 100BASE-TX, not
> | 10BASE-T.
> |
> | END USER IMPLICATIONS
> | When the failure occurs, the following symptoms are seen on the affected
> | port(s):
> | - The port is able to link
> | - LED0 blinks, even when there is no traffic
> | - The MIB counters indicate receive errors (Rx Fragments, Rx Symbol
> |   Errors, Rx CRC Errors, Rx Alignment Errors)
> | - Only a small fraction of packets is correctly received and forwarded
> |   through the switch. Most packets are dropped due to receive errors.
> |
> | The failing condition cannot be corrected by the following:
> | - Removing and reconnecting the cable
> | - Hardware reset
> | - Software Reset and PCS Reset bits in register 67 (0x43)
> |
> | Work around:
> | The problem can be corrected by setting and then clearing the Port Power
> | Down bits (registers 29 (0x1D) and 45 (0x2D), bit 3). This must be done
> | separately for each affected port after returning from Soft Power Down
> | Mode to Normal Mode. The following procedure will ensure no further
> | issues due to this erratum. To enter Soft Power Down Mode, set register
> | 195 (0xC3), bits [1:0] = 10.
> |
> | To exit Soft Power Down Mode, follow these steps:
> | 1. Set register 195 (0xC3), bits [1:0] = 00 // Exit soft power down mode
> | 2. Wait 1ms minimum
> | 3. Set register 29 (0x1D), bit [3] = 1 // Enter PHY port 1 power down mode
> | 4. Set register 29 (0x1D), bit [3] = 0 // Exit PHY port 1 power down mode
> | 5. Set register 45 (0x2D), bit [3] = 1 // Enter PHY port 2 power down mode
> | 6. Set register 45 (0x2D), bit [3] = 0 // Exit PHY port 2 power down mode
> 
> This patch implements steps 2...6 of the suggested workaround. During
> (initial) switch power up, step 1 is executed by the dsa/ksz8795
> driver's probe function.
> 
> Note: In this workaround we toggle the MII_BMCR register's BMCR_PDOWN
> bit, this is translated to the actual register and bit (as mentioned in
> the arratum) by the ksz8_r_phy()/ksz8_w_phy() functions.

s/arratum/erratum/

Also, the commit message is still missing this piece of information you
gave in the previous thread:

| this issue was seen  at some early point of development (back in 2019)
| reproducible on system start. Where switch was in some default state or
| on a state configured by the bootloader. I didn't tried to reproduce it
| now.

Years from now, some poor souls might struggle to understand why this
patch was done this way. If it is indeed the case that the issue is only
seen during the handover between bootloader and kernel, there is really
no reason to implement the ERR workaround in phy_resume instead of doing
it once at probe time.

> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
