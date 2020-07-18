Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED7C22480F
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 04:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgGRChy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 22:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgGRChy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 22:37:54 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15949C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 19:37:54 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id s20so5826405vsq.5
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 19:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZlXeEq0Po5wjSbxjaxwWPWvTXIPXuQv8oUo6kiRmsxY=;
        b=ulFdiuLlkRuJQcpsZbExy7PlaeFUj99zBK26TxXsBJNa7mSe4mJjl/iztS0aUzAlOD
         qNzwPB3OI0WQFtdIPZVcXFYbviwC0xf4kG2X4OIkP5bykKXjXYSChCER6yBUfbksRShI
         gtz9wq0Nu53gH0pz2H6IbMgmvWmx7sVXGs1SWqJJ198MA9f1xqxfn6IJhTnOV97YSuxB
         ufBuYwDc8kyvZI8zWfMUuNOFGI37wmB7KCvvYg1dkcmdM3DuX0RSlrJeWx0KHQfkdl59
         X03B/BncywtqJtBZ94rdH8gUpOOkdr4aFrDXhVxBubIB8z3xeRklztD0rCwRFHHZirE1
         0nBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZlXeEq0Po5wjSbxjaxwWPWvTXIPXuQv8oUo6kiRmsxY=;
        b=KsjyLOfKGxjxLvugdCOSm6Atlg9dWQukZTFkFx3Lj4dJJyPDkSF1GPxAxUL/G+2zra
         BtpCSzUFhVlK9oA9KA/ub4KER5xXOZ2d01amet5F4zgu4+0mqGxwsLIo6cw1OGU+5uWd
         X8kxVaI21qKLpv+EDgdS6xT4qgRrCujmEhBMsf0A+3JPfjjF3nUb9rl8w91m20oBMoaY
         QBRJEYphYfGMhFtk5MnbvDGoYvUsxTnzuxsmF8+tEZeZqm6RAFDOPQ8KhY28GXvwCO1l
         bD9SLcfBpguuI2ybVXRdbwE8lTkSwo49CAk1Pvnf0rRP0agYqaWwPKxFdEzLeHwcKPk2
         QXHA==
X-Gm-Message-State: AOAM530GsvLQUA+WWZFvPcvmU6QEe/tyBa2EASiGvAZ41Usnn/xI4lq+
        T8fy+vebeGoA9i/04OSjonOGgQmyWA3dsJWPkQPlgdoACtE=
X-Google-Smtp-Source: ABdhPJysDbWkPObAPObt3w5TfufS33uAkHdY2xVxlwmDsZleaJuD/VGJ852cfOtBcTLdmlfn20vdpD6Q2cuUxa9SFhM=
X-Received: by 2002:a67:7ccd:: with SMTP id x196mr9673892vsc.224.1595039873206;
 Fri, 17 Jul 2020 19:37:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAOAjy5T63wDzDowikwZXPTC5fCnPL1QbH9P1v+MMOfydegV30w@mail.gmail.com>
 <20200711162349.GL1014141@lunn.ch> <20200711192255.GO1551@shell.armlinux.org.uk>
 <CAOAjy5TBOhovCRDF7NC-DWemA2k5as93tqq3gOT1chO4O0jpiA@mail.gmail.com>
 <20200712132554.GS1551@shell.armlinux.org.uk> <CAOAjy5T0oNJBsjru9r7MPu_oO8TSpY4PKDg7whq4yBJE12mPaA@mail.gmail.com>
 <20200717092153.GK1551@shell.armlinux.org.uk> <CAOAjy5RNz8mGi4XjP_8x-aZo5VhXRFF446R7NgcQGEKWVpUV1Q@mail.gmail.com>
 <20200717185119.GL1551@shell.armlinux.org.uk> <20200717194237.GE1339445@lunn.ch>
 <20200717212605.GM1551@shell.armlinux.org.uk>
In-Reply-To: <20200717212605.GM1551@shell.armlinux.org.uk>
From:   Martin Rowe <martin.p.rowe@gmail.com>
Date:   Sat, 18 Jul 2020 02:37:41 +0000
Message-ID: <CAOAjy5Q-OdMhSG-EKAnAgwoQzF+C6zuYD9=a9Rm4zVVVWfMf6w@mail.gmail.com>
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, vivien.didelot@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 at 21:26, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
> Both ends really need to agree, and I'd suggest cp1_eth2 needs to drop
> the fixed-link stanza and instead use ``managed = "in-band";'' to be
> in agreement with the configuration at the switch.
>
> Martin, can you modify
> arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts to test
> that please?

eth2 now doesn't come up
$ ip link set eth2 up
RTNETLINK answers: No such device
$ dmesg
...
mvpp2 f4000000.ethernet eth2: could not attach PHY (-19)
...

A working dmesg looks like:
$ dmesg |grep f4000000
mvpp2 f4000000.ethernet: using 8 per-cpu buffers
mvpp2 f4000000.ethernet eth1: Using firmware node mac address d0:63:b4:01:00:00
mvpp2 f4000000.ethernet eth2: Using firmware node mac address d0:63:b4:01:00:02
mvpp2 f4000000.ethernet eth2: configuring for fixed/2500base-x link mode
mvpp2 f4000000.ethernet eth2: Link is Up - 2.5Gbps/Full - flow control off
mvpp2 f4000000.ethernet eth1: PHY [f412a200.mdio-mii:00] driver
[Marvell 88E1510] (irq=POLL)
mvpp2 f4000000.ethernet eth1: configuring for phy/sgmii link mode
mv88e6085 f412a200.mdio-mii:04 lan2 (uninitialized): PHY
[!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:11] driver
[Marvell 88E6390] (irq=72)
mv88e6085 f412a200.mdio-mii:04 lan1 (uninitialized): PHY
[!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:12] driver
[Marvell 88E6390] (irq=73)
mv88e6085 f412a200.mdio-mii:04 lan4 (uninitialized): PHY
[!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:13] driver
[Marvell 88E6390] (irq=74)
mv88e6085 f412a200.mdio-mii:04 lan3 (uninitialized): PHY
[!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:14] driver
[Marvell 88E6390] (irq=75)
mvpp2 f4000000.ethernet: all ports have a low MTU, switching to per-cpu buffers
mvpp2 f4000000.ethernet eth2: Link is Down
mvpp2 f4000000.ethernet: using 8 per-cpu buffers
mvpp2 f4000000.ethernet eth1: PHY [f412a200.mdio-mii:00] driver
[Marvell 88E1510] (irq=POLL)
mvpp2 f4000000.ethernet eth1: configuring for phy/sgmii link mode
mvpp2 f4000000.ethernet eth2: configuring for fixed/2500base-x link mode
mvpp2 f4000000.ethernet eth2: Link is Up - 2.5Gbps/Full - flow control off
mvpp2 f4000000.ethernet eth2: Link is Down
mvpp2 f4000000.ethernet eth2: configuring for fixed/2500base-x link mode
mvpp2 f4000000.ethernet eth2: Link is Up - 2.5Gbps/Full - flow control off
mvpp2 f4000000.ethernet eth1: Link is Up - 1Gbps/Full - flow control rx/tx

With the DTS patch it looks like:
$ dmesg |grep f4000000
mvpp2 f4000000.ethernet: using 8 per-cpu buffers
mvpp2 f4000000.ethernet eth1: Using firmware node mac address d0:63:b4:01:00:00
mvpp2 f4000000.ethernet eth2: Using firmware node mac address d0:63:b4:01:00:02
mvpp2 f4000000.ethernet eth2: could not attach PHY (-19)
mvpp2 f4000000.ethernet eth1: PHY [f412a200.mdio-mii:00] driver
[Marvell 88E1510] (irq=POLL)
mvpp2 f4000000.ethernet eth1: configuring for phy/sgmii link mode
mv88e6085 f412a200.mdio-mii:04 lan2 (uninitialized): PHY
[!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:11] driver
[Marvell 88E6390] (irq=72)
mv88e6085 f412a200.mdio-mii:04 lan1 (uninitialized): PHY
[!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:12] driver
[Marvell 88E6390] (irq=73)
mv88e6085 f412a200.mdio-mii:04 lan4 (uninitialized): PHY
[!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:13] driver
[Marvell 88E6390] (irq=74)
mv88e6085 f412a200.mdio-mii:04 lan3 (uninitialized): PHY
[!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:14] driver
[Marvell 88E6390] (irq=75)
mvpp2 f4000000.ethernet: all ports have a low MTU, switching to per-cpu buffers
mvpp2 f4000000.ethernet: using 8 per-cpu buffers
mvpp2 f4000000.ethernet eth1: PHY [f412a200.mdio-mii:00] driver
[Marvell 88E1510] (irq=POLL)
mvpp2 f4000000.ethernet eth1: configuring for phy/sgmii link mode
mvpp2 f4000000.ethernet eth1: Link is Up - 1Gbps/Full - flow control rx/tx

Output from regs just in case it helps:
$ cat /sys/kernel/debug/mv88e6xxx.0/regs
    GLOBAL GLOBAL2 SERDES     0    1    2    3    4    5
 0:  c801       0    ffff  9e07 1e4f 100f 100f 1e4f 170b
 1:     0    803e    ffff     3    3    3    3    3 201f
 2:     0       0    ffff  ff00    0    0    0    0    0
 3:     0       0    ffff  3400 3400 3400 3400 3400 3400
 4:  40a8     258    ffff    7c  43c  43c  43c  43c 373f
 5:  1000     4f0    ffff     0    0    0    0    0    0
 6:     0    1f0f    ffff    7e   7c   7a   76   6e   5f
 7:     0    703f    ffff     1    0    0    0    0    0
 8:     0    7800    ffff  2080 2080 2080 2080 2080 2080
 9:     0    1500    ffff     1    1    1    1    1    1
 a:   509       0    ffff  8000    0    0    0    0    0
 b:  3000    31ff    ffff     1    2    4    8   10    0
 c:   3f7       0    ffff     0    0    0    0    0    0
 d:  ffff     555    ffff     0    0    0    0    0    0
 e:  ffff       1    ffff     0    0    0    0    0    0
 f:  ffff     f00    ffff  9100 9100 9100 9100 9100 dada
10:     0       0    ffff     0    0    0    0    0    0
11:     0       0    ffff     0    0    0    0    0    0
12:  5555       0    ffff     0    0    0    0    0    0
13:  5555     303    ffff     0    0    0    0    0    0
14:  aaaa       0    ffff     0    0    0    0    0    0
15:  aaaa       0    ffff     0    0    0    0    0    0
16:  ffff       0       0     0   33   33   33   33    0
17:  ffff       0    ffff     0    0    0    0    0    0
18:  fa41    15f6    ffff  3210 3210 3210 3210 3210 3210
19:     0       0    ffff  7654 7654 7654 7654 7654 7654
1a:   3ff       0    ffff     0    0    0    0 1ea0 a100
1b:   200    110f    ffff  8000 8000 8000 8000 8000 8000
1c:   7c0       0    ffff     0    0    0    0    0    0
1d:  1400       0    ffff     0    0    0    0    0    0
1e:     0       0    ffff  f000 f000 f000 f000 f000 f000
1f:     0       0    ffff     0    0    0    0    0    0

I also tried "in-band-status", which has a "working" dmesg but doesn't
tx or rx packets; so basically the same as mainline without patching
the DTS.

Just to make sure I applied the right change, here is the diff:
diff --git a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
index c8243da71041..957ca7e69c1a 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
+++ b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
@@ -454,10 +454,7 @@ &cp1_eth2 {
        status = "okay";
        phy-mode = "2500base-x";
        phys = <&cp1_comphy5 2>;
-       fixed-link {
-               speed = <2500>;
-               full-duplex;
-       };
+       managed = "in-band";
 };

 &cp1_spi1 {
