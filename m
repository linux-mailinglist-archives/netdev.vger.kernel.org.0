Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F36E42BC37
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239169AbhJMJ5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237603AbhJMJ5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 05:57:17 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45D5C061570;
        Wed, 13 Oct 2021 02:55:14 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c4so1438270pls.6;
        Wed, 13 Oct 2021 02:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=gMtBH0FKznXn6S5/VxYELkocnCm68+UooPeAaK+EkUM=;
        b=LHMk7Fb30PrBJnIhN4xR6T8vveJgn62ywxX/TudQlPUizAQNsqf/7s5OM4tCwdRI8w
         kJ/py/Bx829Sq9L6fP57z5QUdzkYlrQxpW3JTA72KaOL7IPxtst8LTwyL4214ayurlm2
         dyKmq2zWETxp3+Wn81chvi+ruABQESEQJLyqx7m7dOUUGjfMTGTyVV6TrcORozHb3BtC
         cBA4cHvmcnZ1kw/8j5A8x8BdHfIo8qZn0UysvgaMW1biBncm0VyoHsAXcA3bGrc2brkl
         LOIHavvjsaofE38KlPTtRB0Gd0r1vrJd07HIVYH/2eO8AyYsfIKW7dO8IB5rgNOZmckY
         XptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=gMtBH0FKznXn6S5/VxYELkocnCm68+UooPeAaK+EkUM=;
        b=MPHsdyulK2Ik+x1gbCfhkHkNWfZLubx8zUwnDidxfVKKORsgws0wQLoeWUhYafM6T9
         DP4yVpJT1LTt6AEu24luty+UemGJ6D2ZnOibLikNVeKWW4dkaqTxnDm66oUQrji7fkQZ
         ceUH+pKnLWzKJyMt00N+Lvaj3tL87yhKypPPfY/55TGdLJgLpWd05gHhJNZmFakE7OBb
         QRTymgwC2eXPGByjJugXird0cV395uECGpQB0UM9HtaYI6bM2SkGT2FBQDlXHuvwJs1I
         nanYJVEPyYLK9ubnuxCrjDQ6NktZBQ8y4l1KHYGIyIhWPonEm16Cp+sEHTTr5KBEXBLx
         04Kg==
X-Gm-Message-State: AOAM531R7mwIyStiIba1OWyQy9jCmuQirG2PPLzsLvfuRz+LyASaE2ro
        glJlKCEZCjKKhOlfcN6nFbA=
X-Google-Smtp-Source: ABdhPJy33q2kxKjhMPEiClqtRXi+voWDnOZESMfd6cxgVLGHsWjCZ1U2dv0vRffmisfMFTT3XV/lrQ==
X-Received: by 2002:a17:90b:23c8:: with SMTP id md8mr12464157pjb.210.1634118914048;
        Wed, 13 Oct 2021 02:55:14 -0700 (PDT)
Received: from localhost.localdomain ([171.211.26.24])
        by smtp.gmail.com with ESMTPSA id e20sm13906053pfc.11.2021.10.13.02.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 02:55:13 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC
Date:   Wed, 13 Oct 2021 17:55:05 +0800
Message-Id: <20211013095505.55966-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012123557.3547280-6-alvin@pqrs.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk> <20211012123557.3547280-6-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 02:35:54PM +0200, Alvin Šipraga wrote:
> +/* Port mapping macros
> + *
> + * PORT_NUM_x2y: map a port number from domain x to domain y
> + * PORT_MASK_x2y: map a port mask from domain x to domain y
> + *
> + * L = logical port domain, i.e. dsa_port.index
> + * P = physical port domain, used by the Realtek ASIC for port indexing;
> + *     for ports with internal PHYs, this is also the PHY index
> + * E = extension port domain, used by the Realtek ASIC for managing EXT ports
> + *
> + * The terminology is borrowed from the vendor driver. The extension port domain
> + * is mostly used to navigate the labyrinthine layout of EXT port configuration
> + * registers and is not considered intuitive by the author.
> + *
> + * Unless a function is accessing chip registers, it should be using the logical
> + * port domain. Moreover, function arguments for port numbers and port masks
> + * must always be in the logical domain. The conversion must be done as close as
> + * possible to the register access to avoid chaos.
> + *
> + * The mappings vary between chips in the family supported by this driver. Here
> + * is an example of the mapping for the RTL8365MB-VC:
> + *
> + *    L | P | E | remark
> + *   ---+---+---+--------
> + *    0 | 0 |   | user port
> + *    1 | 1 |   | user port
> + *    2 | 2 |   | user port
> + *    3 | 3 |   | user port
> + *    4 | 6 | 1 | extension (CPU) port
> + *
> + * NOTE: Currently this is hardcoded for the RTL8365MB-VC. This will probably
> + * require a rework when adding support for other chips.
> + */
> +#define CPU_PORT_LOGICAL_NUM	4
> +#define CPU_PORT_LOGICAL_MASK	BIT(CPU_PORT_LOGICAL_NUM)
> +#define CPU_PORT_PHYSICAL_NUM	6
> +#define CPU_PORT_PHYSICAL_MASK	BIT(CPU_PORT_PHYSICAL_NUM)
> +#define CPU_PORT_EXTENSION_NUM	1
> +
> +static u32 rtl8365mb_port_num_l2p(u32 port)
> +{
> +	return port == CPU_PORT_LOGICAL_NUM ? CPU_PORT_PHYSICAL_NUM : port;
> +}
> +
> +static u32 rtl8365mb_port_mask_l2p(u32 mask)
> +{
> +	u32 phys_mask = mask & ~CPU_PORT_LOGICAL_MASK;
> +
> +	if (mask & CPU_PORT_LOGICAL_MASK)
> +		phys_mask |= CPU_PORT_PHYSICAL_MASK;
> +
> +	return phys_mask;
> +}
> +
> +static u32 rtl8365mb_port_mask_p2l(u32 phys_mask)
> +{
> +	u32 mask = phys_mask & ~CPU_PORT_PHYSICAL_MASK;
> +
> +	if (phys_mask & CPU_PORT_PHYSICAL_MASK)
> +		mask |= CPU_PORT_LOGICAL_MASK;
> +
> +	return mask;
> +}
> +
> +#define PORT_NUM_L2P(_p) (rtl8365mb_port_num_l2p(_p))
> +#define PORT_NUM_L2E(_p) (CPU_PORT_EXTENSION_NUM)
> +#define PORT_MASK_L2P(_m) (rtl8365mb_port_mask_l2p(_m))
> +#define PORT_MASK_P2L(_m) (rtl8365mb_port_mask_p2l(_m))

The whole port mapping thing can be avoided if you just use port 6 as the CPU
port.

> +
> +/* Chip-specific data and limits */
