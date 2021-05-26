Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40A2391C1A
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhEZPgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhEZPgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:36:23 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92204C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 08:34:50 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id i13so2034225edb.9
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 08:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eSlloe5Sv5AEHSnLUDEGoxHPHBkPGv5RoUHh5gAj1Yg=;
        b=nhIpD2JWaYiaoaa2+BhJk4WXExe/W0tgL0hBSQ7NV5ynRdFsLOUOVq2do9jrM0JwWT
         lVMOv2bS05pVF88dRXzkjoorgZ+DnQFgWbMfed1aKdUnYvWlmVVKm2MIv4u4zu1T5DxP
         W4M4oksIoYzR11RRrvoLe+I05JD802LHnOZoymCOAH8Uqf0CT/zrrSSYrLHkWeatuli2
         lvqrI9cI2nASyZMgnipgQzqQk85tOEw5xXaU6e2p7hTO4t0QHIrWN3pEaIr2b12dADdF
         Fya4OLKnMCgN2Nd18dpHzt7eXmnliVMbo9/+DxCBzXyk2nEMD7j5EP0QZxqGjHGkrXp8
         2frQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eSlloe5Sv5AEHSnLUDEGoxHPHBkPGv5RoUHh5gAj1Yg=;
        b=ILO5+ypHjrMxcl+bF6CaN/1VwDC7L+X5+wUqwWkiPGNHXgix5p5ndgiunMMZuYhzfg
         Lz2InepTZh1/USEKslUYKD6keu1n9GesLVirXJAY6nx0PffnVZEl053HG1ubbYpUNS8o
         UXQMmOsxmK60PPfcq72ek2BCzl73Fykw4403A7bNMRQkBSAh4VT+4UaYHMckvix0BCWD
         1TZwtqDECs/Ownrnx/tio/x1ZRstESCeLRj0xUMwYYiVtOYzNGzTS/mCudIhOt1KBdDp
         rSAhGkaq0zt0jr0CsTajNgC2eTpQy0xI1+I2ek0blLzES069MHfH42p4MjspsZeTW0bW
         jU8g==
X-Gm-Message-State: AOAM530+htl/ohCcTHIEUwbCLxi2+4DA7SeUB2uYoEGwM5N/KgS7Y2hK
        UUz6DErZfdsPqQ2jfGg9opo=
X-Google-Smtp-Source: ABdhPJz4U3iwBVMl9Vx5hJ6Mw5mnz5aca1KJB0ShVvkIF2GrwcOfyYTO+UeT70gt9aSzEIiE1jpJ5Q==
X-Received: by 2002:aa7:c0c4:: with SMTP id j4mr37989693edp.168.1622043289192;
        Wed, 26 May 2021 08:34:49 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id x10sm12646759edd.30.2021.05.26.08.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 08:34:48 -0700 (PDT)
Date:   Wed, 26 May 2021 18:34:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH v2 linux-next 03/14] net: dsa: sja1105: the 0x1F0000
 SGMII "base address" is actually MDIO_MMD_VEND2
Message-ID: <20210526153447.yjgbj5uhxxnvxvbs@skbuf>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
 <20210526135535.2515123-4-vladimir.oltean@nxp.com>
 <20210526152454.GG30436@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526152454.GG30436@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Wed, May 26, 2021 at 04:24:54PM +0100, Russell King (Oracle) wrote:
> On Wed, May 26, 2021 at 04:55:24PM +0300, Vladimir Oltean wrote:
> > -	const struct sja1105_regs *regs = priv->info->regs;
> > +	u64 addr = (mmd << 16) | pcs_reg;
> 
> What is the reason for using "u64" here. pcs_reg is 16-bits, and mmd is
> five bits, which is well below 32 bits. So, why not u32?

The "addr" variable holds a SPI address, and in the sja1105 driver, the
SPI addresses are universally held in u64 variables, mainly because of
the packing() API (Documentation/core-api/packing.rst).

In this case, the "addr" is passed to the "u64 reg_addr" parameter of
sja1105_xfer_u32, which ends up being packed into bits 24:4 of the SPI
message header in sja1105_spi_message_pack().

You might ask: is the SPI address simply derived from (mmd << 16 | pcs_reg)?
The answer is yes, I'm a bit surprised by that too. The PCS doesn't
overlap with other SPI memory regions because only 2 MMDs are implemented
(this is explained in the commit message).

I would probably reconsider some things if I were to write the driver
again, including some accessors which are more streamlined than packing(),
but currently this is what we have.
