Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6FA1A2454
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 16:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgDHOto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 10:49:44 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:38874 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbgDHOto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 10:49:44 -0400
Received: by mail-il1-f194.google.com with SMTP id n13so6953787ilm.5
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 07:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=wR8J2b+VadqJ7co3OXe203kY2wp7FcU9y3rU2x1X2Lc=;
        b=Q+okMJOrmu46BVJ4W897WB0ETPT3t230J2V2WVuN1/vb7TaiudSsP+hEQ/JozXtrOW
         R1ztXk5Cw3tZTb3XoHG1FR0jjl8KxjUPbb5BNvT2T7HOJEu9zrwzLv0M0dgTuxuHyqJ0
         jJEdM3BAsaFEppMhxtx44mFHxADRksXNpTLBbOAyTc15ilmMjkeb5qoKAcN4684MpcQq
         tKwWbtlxJ9HWA1FEGDmdvTMBIxXl7+z5fu83MOOEqkX/LwR5g480QdV580w9qOu00m2k
         yVd2bbtESxEQYeD97+4DAOIN5FPh1qqljXORgyvC1CbFN1mJV1LmxR3ZJXTFNKvxuwIs
         0L8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=wR8J2b+VadqJ7co3OXe203kY2wp7FcU9y3rU2x1X2Lc=;
        b=H466+XT+yb89MI53hjgwVYKK5HJRqnNkGZs7J4NRYbYHAxKxeDhDzhSkbdW0zEgVLX
         RZnZiwThskKyONl/X582HNSTwo3BlS8kc4WZhBEh4YqmsyjsBJ6DTmhqIKPzk+rTWucs
         3EClVYGxoLH0s5zuWu9Zc070ISsNGiI5RyejOY6ge47rzm4blqLrL7cK4qZf2VXrfww3
         J2nX1o8NInbJmo/WwpT5tPAtgod7T9sLdZHkOscdbiLsstfxTK05RK3W5rtaVO64BHzL
         hhgQq6wVVf5Q/KE/oBzC5TB33PiBy//RMxoC8kHi/UKwsVY6g+z2s0peY7xD0NOKFqFB
         dmMQ==
X-Gm-Message-State: AGi0PuZB+EiHgNYVVD0/WWqnbBjcsUJd4Ml1I9BpBthLJ0C6PfaWNp3B
        SVArV9VOoSw/S2FGPMWz1U7FLbV63T0miWV8tyY=
X-Google-Smtp-Source: APiQypJTukjCEgjULDIFs6A7jB6rTECx/YYSMuVLIZxT5C2Nr1PoDVcbeJGiz6RbTEHkbww7NSGEWi6jO1USaLjjOtU=
X-Received: by 2002:a92:3c56:: with SMTP id j83mr1986756ila.37.1586357382979;
 Wed, 08 Apr 2020 07:49:42 -0700 (PDT)
MIME-Version: 1.0
From:   "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date:   Wed, 8 Apr 2020 17:49:31 +0300
Message-ID: <CAJs94EYHsjEoqydJX6hYFg_Y=T7nVKjpJ5n85mvhazb6xNSg0g@mail.gmail.com>
Subject: zynq-zturn: macb: Could not attach PHY
To:     linux@armlinux.org.uk, Michal Simek <michal.simek@xilinx.com>,
        nicolas.ferre@microchip.com, Anton Gerasimov <tossel@gmail.com>,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am running Linux 5.6 on MYIR Z-turn board and see the following issue:

[   38.485960] macb e000b000.ethernet eth0: Cadence GEM rev 0x00020118
at 0xe000b000 irq 28 (a6:78:9c:86:65:d3)
[   42.990885] macb e000b000.ethernet eth0: Could not attach PHY (-19)

Setting 0x3 for ethernet-phy address in zynq-zturn.dts fixes this issue:

[   23.445231] macb e000b000.ethernet eth0: Cadence GEM rev 0x00020118
at 0xe000b000 irq 28 (5a:77:b7:82:c4:b3)
[   27.843706] macb e000b000.ethernet eth0: PHY
[e000b000.ethernet-ffffffff:03] driver [Micrel KSZ9031 Gigabit PHY]
(irq=POLL)
[   27.843726] macb e000b000.ethernet eth0: configuring for
phy/rgmii-id link mod

However, I've found that there are at least two Z-turn board
revisions. The first one has v4 schematics as described in
http://www.myirtech.com/download/Zynq7000/Z-TURNBOARD_schematic.pdf
The second one has v5 schematics. I've found v5 schematics PDF file at
DVD disk supplied with my board. I am not sure whether I am allowed to
attach it here.
My board seems to be v5 schematics. The only described difference
between board revisions is that v4 has Atheros AR8035 PHY at 0b000
address, and v5 has Micrel KSZ9031 PHY at 0b011 address.

What should be preferred fix for this issue? I have not found a way to
specify a list of PHY addresses to probe in DTS file.
u-boot has similar issue with this board [1]. While it can be
workarounded by PHY auto scan for u-boot, in Linux
drivers/of/of_mdio.c, I see that auto scan is generally not
encouraged.

[1] https://lists.denx.de/pipermail/u-boot/2020-April/405605.html

-- 
With best regards,
Matwey V. Kornilov
