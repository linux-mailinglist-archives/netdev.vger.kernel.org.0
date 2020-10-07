Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A1728626A
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgJGPo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgJGPo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 11:44:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE40CC061755;
        Wed,  7 Oct 2020 08:44:56 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ds1so1229160pjb.5;
        Wed, 07 Oct 2020 08:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OopvoL5bmYi+0qGhF3VP83b68UDgKQrkU07BBY2nqsU=;
        b=Ig/V6oAtwr/rda438Rz4wdMGeHF553yyGeIjxYz9QCthXwy0yvoevXQ6NpwmseSPuV
         CNlUq05As99tyk81B67xqF9YFCHxzedVnIssvfxH44QkoFOvs4xv/ykeQrf9AkZd7798
         JXXL6M8aO47whWXB2WV/GIPXPXMANYDolePAAFhSw9zQL8nvFG4AU8RcJVfiV9VLY2wK
         s8pmXOv2E0zj37KmflRfe8LhAxjJGc4iNlXAhlqa22NBs/kcwtkTbTEnuuFBiY+W06tv
         kv8Sd1jYdH/kWrRf+8R0MbJz+dRQB7z7NxXKTmHfKo0XdSQAPlmQvdNB2+p2coe+Z3M9
         T1kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OopvoL5bmYi+0qGhF3VP83b68UDgKQrkU07BBY2nqsU=;
        b=PDFae633qPyRC9VKlWUTkYGzVu/E7uL6Ub6qrJqKDp++n0GlYYeem7i2qkKynIPJ6h
         VXheR+Dec4AVxVZSVnbQvC1U2RaEqk02MUGqzxGtERHkgCsjWLLO3R0hXclnHk6qCpKB
         3RHh9H22+nFWylTch7RYp7YRyWo25udhEk44Le6f85ZJvwcF6xflFAEmcENQ/V61kPTR
         pqM2hEm8An0TlYpmo1iJ+1j5hLVeT8Sm4rdTNl65POhVp9GvmN9ANXbzofk62/Yy5ivZ
         I30zQkQNVzeLlwlucikr1cLiCRqnIzwF/hlvNXMgOQefI9tbpRs9XYmuh/+w/RgoKi0d
         icww==
X-Gm-Message-State: AOAM5301A/MhgOPPioknRmx246a5V+hwKtepd8E/IkpD6fulA5g+Z/MN
        OjQytV98jjubgODJmpxB3TR4rra4rG2qPQ==
X-Google-Smtp-Source: ABdhPJyi7dDLCLtbgKVzaWHV9rqYxTGP9mA6JVYSD9c0RBIUN12Z2wPgdGtKHPZfocfmjrL5dEwhmQ==
X-Received: by 2002:a17:90b:4b05:: with SMTP id lx5mr3263313pjb.42.1602085496169;
        Wed, 07 Oct 2020 08:44:56 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e8sm3745514pgj.8.2020.10.07.08.44.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 08:44:55 -0700 (PDT)
To:     Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>, Rob Herring <robh+dt@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        kernel@pengutronix.de, David Jander <david@protonic.nl>
References: <20201006080424.GA6988@pengutronix.de>
 <2cc5ea02-707e-dbb5-c081-4c5202bd5815@gmail.com>
 <42d4c4b2-d3ea-9130-ef7f-3d1955116fdc@denx.de>
 <0687984c-5768-7c71-5796-8e16169f5192@gmail.com>
 <20201007081410.jk5fi6x5w3ab3726@pengutronix.de>
 <7edb2e01-bec5-05b0-aa47-caf6e214e5a0@denx.de>
 <20201007090636.t5rsus3tnkwuekjj@pengutronix.de>
 <2b6a1616-beb8-fd12-9932-1e7d1ef04769@denx.de>
 <20201007104757.fntgjiwt4tst3w3f@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: PHY reset question
Message-ID: <c6bce70b-c97a-1696-2113-61bd3ba6ae99@gmail.com>
Date:   Wed, 7 Oct 2020 08:44:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201007104757.fntgjiwt4tst3w3f@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/7/2020 3:47 AM, Marco Felsch wrote:
> Florian did you send a new version of those patches?

I did not because we had a good conversation with Rob over IRC and the 
conclusion was that the only solution that scaled across drivers, 
subsystems and type of resources (regulators, clocks, resets, etc.) was 
to have a compatible string for the given device that contains the ID. 
For Ethernet PHY or MDIO device nodes that is "ethernet-phyAAAA.BBBB".

When the bus determines the presence of such a compatible string it 
needs to bypass the dynamic identification of the device and needs to 
bind the PHY driver and the device instance directly. MDIO does that, 
and so does I2C and SPI AFAICT with the modalias/compatible (there is 
not a standardized way to runtime detect an I2C or SPI client anyway), 
while PCI and USB do not, but arguably could in the future.

For the specific use case that I had which required turning on a clock 
to the Ethernet PHY, I ended up modifying the firmware to provide that 
compatible string "ethernetAAAA.BBBB" and have the driver request the 
clock from its probe function:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/drivers/net/phy/bcm7xxx.c?id=ba4ee3c053659119472135231dbef8f6880ce1fb
-- 
Florian
