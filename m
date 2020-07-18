Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49960224A66
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 11:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGRJoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 05:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgGRJn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 05:43:59 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3DAC0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 02:43:59 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id k7so6097451vso.2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 02:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6OgUv9ELc/MIYC3ZBTw8Yfh37bf1H9xo4qYjNC3iQPc=;
        b=gvmG5FlACK88JgzA7FCKQzuV745VC6sQZfaSQqANtt/pl1IGXcTEQWynuyrpTGed5m
         wzdmqcBosMseynISk4eJaniNtAri6SfAsbA7tvp5MdojizN7msHreMFKiiW7dS5jcgWc
         J5WYzVbby0xrbh7tkDl8MLNJfomk0zkLed4mKWjDnuA/vzgQFadZlPvcbiXFRfcO/Qlo
         228TH48ojQYrONrZWBPJKDbu1tB67E/6oE+KYi6eyrB1XeJ7c9K0245nyw0ihiYN5jIQ
         3Y8jlvQxL4kdlNBitq7k+dmh0D64jpFc5FmSXziFHl/KWVixvXpa7jXC1VbCklre9pO0
         rCBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6OgUv9ELc/MIYC3ZBTw8Yfh37bf1H9xo4qYjNC3iQPc=;
        b=V3M8pj4HMHy2uCw7+DG3vHbQqiiPb2Ppe+ZFqaS/IyPVCUS+5kzs5UvyViVrCHq/di
         OWOdsmFROCeBmsjiYsJP9qJre13bW9Ftjr4nwDY9vSQBwm/vXLb1JldAGm1ylpRDleU0
         GgedByFA4tdN2eD6NvUU00/cZtJvpSWh00EmW4dCMMnHlaSiI/e2sy3SDnan5e/SaBQZ
         NhAxnOIW5A0yVzbT8cWSck3+rFu9K/bTEhhJTABnMa4o+e7SYZUa0ci4D2ojfrk1XfF2
         /CycMnSOcI5aIAp9rKSPQhVjJjc6ImQahNHxK1w7RQBMJKUq3PqI7J9udrjDW0ybjyZV
         fdOA==
X-Gm-Message-State: AOAM533+9C0ztsbFrAQH7fA76C1IjQ+YN+MCPQ5An4bDToe6DVcfyjOU
        hKA8J8P/MMAq1xrBUqofsXSfO5vTfOHgy+hpr1E=
X-Google-Smtp-Source: ABdhPJw3JBWhrBcdeVRsM0mvSF+7zOKazjm0TB0FhdPtTGDc0/dY0EB6q5tcbpmuJXuC3HUoGedl05LyK2dbfGdubD4=
X-Received: by 2002:a05:6102:3188:: with SMTP id c8mr10625134vsh.61.1595065438764;
 Sat, 18 Jul 2020 02:43:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200711192255.GO1551@shell.armlinux.org.uk> <CAOAjy5TBOhovCRDF7NC-DWemA2k5as93tqq3gOT1chO4O0jpiA@mail.gmail.com>
 <20200712132554.GS1551@shell.armlinux.org.uk> <CAOAjy5T0oNJBsjru9r7MPu_oO8TSpY4PKDg7whq4yBJE12mPaA@mail.gmail.com>
 <20200717092153.GK1551@shell.armlinux.org.uk> <CAOAjy5RNz8mGi4XjP_8x-aZo5VhXRFF446R7NgcQGEKWVpUV1Q@mail.gmail.com>
 <20200717185119.GL1551@shell.armlinux.org.uk> <20200717194237.GE1339445@lunn.ch>
 <20200717212605.GM1551@shell.armlinux.org.uk> <CAOAjy5Q-OdMhSG-EKAnAgwoQzF+C6zuYD9=a9Rm4zVVVWfMf6w@mail.gmail.com>
 <20200718085028.GN1551@shell.armlinux.org.uk>
In-Reply-To: <20200718085028.GN1551@shell.armlinux.org.uk>
From:   Martin Rowe <martin.p.rowe@gmail.com>
Date:   Sat, 18 Jul 2020 09:43:47 +0000
Message-ID: <CAOAjy5SewXHQVnywzin-2LiqWyPcjTvG9zzaiVRtwfCG=jU1Kw@mail.gmail.com>
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

On Sat, 18 Jul 2020 at 08:50, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
> Sorry, it should have been ``managed = "in-band-status";'' rather than
> just "in-band".

Below are the outputs with "in-band-status". It functions the same as
not reverting the patch; interface comes up, when bridged the two
physical machines connected can ping each other, but nothing can tx or
rx from the GT 8K.

$ dmesg |grep f4000000
mvpp2 f4000000.ethernet: using 8 per-cpu buffers
mvpp2 f4000000.ethernet eth1: Using firmware node mac address d0:63:b4:01:00:00
mvpp2 f4000000.ethernet eth2: Using firmware node mac address d0:63:b4:01:00:02
mvpp2 f4000000.ethernet eth2: configuring for inband/2500base-x link mode
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
mvpp2 f4000000.ethernet eth2: configuring for inband/2500base-x link mode
mvpp2 f4000000.ethernet eth2: configuring for inband/2500base-x link mode
mvpp2 f4000000.ethernet eth2: Link is Up - 2.5Gbps/Full - flow control rx/tx
mvpp2 f4000000.ethernet eth1: Link is Up - 1Gbps/Full - flow control rx/tx

$ cat /sys/kernel/debug/mv88e6xxx.0/regs
    GLOBAL GLOBAL2 SERDES     0    1    2    3    4    5
 0:  c801       0    ffff  9e07 9e5f 100f 100f 9e6f 170b
 1:     0    803e    ffff     3    3    3    3    3 201f
 2:     0       0    ffff  ff00    0    0    0    0    0
 3:     0       0    ffff  3400 3400 3400 3400 3400 3400
 4:  40a8     258    ffff    7c  43f  43c  43c  43f 373f
 5:  1000     4f0    ffff     0    0    0    0    0    0
 6:     0    1f0f    ffff    7e   7c   7a   76   6e   5f
 7:     0    703f    ffff     1    0    0    0    0    0
 8:     0    7800    ffff  2080 2080 2080 2080 2080 2080
 9:     0    1500    ffff     1    1    1    1    1    1
 a:   509       0    ffff  8000    0    0    0    0    0
 b:  3000    31ff    ffff     1    2    4    8   10    0
 c:   207       0    ffff     0    0    0    0    0    0
 d:  3333     529    ffff     0    0    0    0    0    0
 e:     1       6    ffff     0    0    0    0    0    0
 f:     3     f00    ffff  9100 9100 9100 9100 9100 dada
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
1b:   16b    110f    ffff  8000 8000 8000 8000 8092 8000
1c:   7c0       0    ffff     0    0    0    0    0    0
1d:  1400       0    ffff     0    0    0    0    0    0
1e:     0       0    ffff  f000 f000 f000 f000 f000 f000
1f:     0       0    ffff     0   bf    0    0   f2    0
