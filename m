Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D540F428182
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 15:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbhJJNYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 09:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbhJJNYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 09:24:52 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA54C061570;
        Sun, 10 Oct 2021 06:22:53 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id p13so56876920edw.0;
        Sun, 10 Oct 2021 06:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6Jp8EcCzmVl4X3iovCH6ikD8+A4Xfin1iJCFLQfmdW4=;
        b=gOXGAJRH8qY0a84OaEFiCmc/fM5JWXMhcYsJZfbRQWUCdc+EWaIQ2bBIjSBWciAQmz
         3i06QDU+/6lDsZ8NkjfaKTMaHmbfcS/iC6AsRyb3D0/gpyVD+bllU9pDN0AsZjSIWq0G
         MpTYsGFD6BotfVyCdCumYLn5g4JiZ9Wsmyzv6vm7PCNlzpwOqYshKerkIbhZHrhqKC6h
         wlkD7jLbwKs2M4nuuvpO3qFSbgc9HmZos0bPCc/AUbdvKbXfGfqLbByA0UkZT+MC6cRW
         FcqUVWmb12Gtu/wXvYGe3dD1BL+etaaBE/FQT+piqRZx4glpvaQ0Lk2u90+5yONrNhU+
         OPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Jp8EcCzmVl4X3iovCH6ikD8+A4Xfin1iJCFLQfmdW4=;
        b=CCsxFCvoXHU9DXfqsrQ/1L5It9BFcVzgRt/WhlXQcaOLjW9tfjCJdj/FWPQp4oPQGG
         HqQtRI+zkT94VQ6KCx0BwH5ysGq0B4NeCS6ig7qrOgxAHMVsBWTpm4XQzXMqJAOHggyE
         QYF/njY99HasYNswlIb3Myu1GlOj9FQ4gUqHfO1fnS2bCW+zYDjEEE9Loko8uJlzyAxM
         IwZzavCFpMEW0BZHNbja78gHagagQF6cXfO/fl4BXJrVibrc+7Rtxbx9LaK/l4jV67wy
         0iSecKBZMCvb2cilDSOsqfYVL542mw0eDiPXPDj8HChqFY8Hbe4a/81LvPoTgrTgM4w/
         vJZw==
X-Gm-Message-State: AOAM530BM/xrJLnbhddNer77BS5iDWMJI8qvnR+YyXcvZ4LeSeVzs93q
        qtVwZlyRIza9S3GoJmfWoc973TY7c3I=
X-Google-Smtp-Source: ABdhPJxdLMmK/8PuuArOBM+e6joPjXNYbQ24oGl8PBsG5KCFhVwuqDqDj887F6RO57V6LYAnKZ7AQw==
X-Received: by 2002:a17:906:fb08:: with SMTP id lz8mr18673190ejb.45.1633872172138;
        Sun, 10 Oct 2021 06:22:52 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id p6sm2527554edi.18.2021.10.10.06.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 06:22:51 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:22:49 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan McDowell <noodles@earth.li>
Subject: Re: [net-next PATCH v4 04/13] drivers: net: dsa: qca8k: add support
 for cpu port 6
Message-ID: <YWLpKRaz0dQ4Y+Nn@Ansuel-xps.localdomain>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-5-ansuelsmth@gmail.com>
 <20211010124243.lhbh46pkwribztrl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010124243.lhbh46pkwribztrl@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 03:42:43PM +0300, Vladimir Oltean wrote:
> On Sun, Oct 10, 2021 at 01:15:47PM +0200, Ansuel Smith wrote:
> > Currently CPU port is always hardcoded to port 0. This switch have 2 CPU
> > port. The original intention of this driver seems to be use the
> > mac06_exchange bit to swap MAC0 with MAC6 in the strange configuration
> > where device have connected only the CPU port 6. To skip the
> > introduction of a new binding, rework the driver to address the
> > secondary CPU port as primary and drop any reference of hardcoded port.
> > With configuration of mac06 exchange, just skip the definition of port0
> > and define the CPU port as a secondary. The driver will autoconfigure
> > the switch to use that as the primary CPU port.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> 
> Does this really work? What about GLOBAL_FW_CTRL0 bit 10 (CPU_PORT_EN),
> which this patch leaves alone, and whose description is:
> 0 = No CPU connect to switch
> 1 = CPU is connected to port0
> If this bit is set to 1, HEAD_EN of MAC0 is set to 1
>

I tested this with my Netgear r7800 that has a qca8337. I commented cpu
port0 and the switch works correctly.
I think the CPU_PORT_EN enabled cpu port0 that can only be a CPU port
and cpu port6 if it's set in that mode (there are some regs to set it to
CPU mode, PHY mode or BASE-X)

> I see all of PORT0_HEADER_CTRL - PORT6_HEADER_CTRL have the option of
> setting RX_HEADER_MODE and TX_HEADER_MODE.
> I just have this doubt: what is port 0 supposed to do when the CPU port
> is port 6? Can it be used as a regular user port, attached to an RGMII PHY?
> 

Port 0 can only be used as CPU port, nothing else.

> Isn't that use case broken anyway, due to qca8k.c's broken
> interpretation of RGMII delay device tree bindings (it always applies
> RGMII delays on "rgmii-id", and the PHY will apply them too)?
> 

Actually we have dedicated regs for port0 and port6 to set internal
delay. Only qca8337 require additional delay for port1-2-3-4-5 using the
PAD5 reg.

> If I were to trust the documentation, that DSA headers are enabled on
> port 0 when the driver does this:
> 
> 	/* Enable CPU Port */
> 	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
> 			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
> 
> doesn't that mean that using port 0 as a user port is double-broken,
> since this would implicitly enable DSA headers on it?
> 
> Or is the idea of using port 6 as the CPU port to be able to use SGMII,
> which is not available on port 0? Jonathan McDowell did some SGMII
> configuration for the CPU port in commit f6dadd559886 ("net: dsa: qca8k:
> Improve SGMII interface handling"). If the driver supports only port 0
> as CPU port, and SGMII is only available on port 6, how did he do it?
> 

I think the dotted thing in the diagram about sgmii is about the fact
that you can use sgmii for both port0 or port6. (the switch configuration
support only ONE sgmii) We have device that have such configuration
(port0 set to sgmii) without the mac06 exchange bit set.

> On the boards that you have with port 6 as CPU port, what is port 0 used
> for? Can port 0 and 6 be CPU ports simultaneously?

Yes and that's the actual common configuration. 2 CPU port. First
assigned to lan port 1-2-3-4 and second assigned to wan port 5.
DSA currently doesn't support this so everything is handled by cpu port0
(and with this now it can be handled by cpu port6)

> 
> I also want to understand what's the use case of this port swap. In the
> QCA8337 block diagram I see a dotted-line connection between Port 0 and
> the SerDes, presumably this is due to the port swap. But I don't see any
> dotted line between the Port 6 and the first GMII/RGMII/MII/RMII MAC.
> So what will happen to what software believes is port 6, with the swap
> in place?

I'm starting to think that mac swap it's really something used to treat
case where port0 is disconnected and only port6 is connected. They set
the bit to swap them and then everything else will see port6 as port0.
Also the original driver (and from Documentation some specific regs)
looks to be hardcoded to port0 so that can be the user case. But again I
tested with my qca8337 device and a configuration with port6 looks like
to work.
If mac06 exchange is not supported on qca8327 we can safely assume that
such configuration is not supported (port0 MUST be always connected) and
return error on such configuration.
Again with mac swap you would declare everything using port0 so from dsa
side they all see that as port0 and it won't be wrong to treat it like
it's port 0.

-- 
	Ansuel
