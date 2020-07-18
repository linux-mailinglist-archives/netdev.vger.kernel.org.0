Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D892224AEC
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 13:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgGRLVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 07:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgGRLVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 07:21:39 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4917CC0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 04:21:39 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id b205so2687199vkb.8
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 04:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=twguqexeRVd3avw9S5VXaqbbsGzTmU7wsW6IQLEa0Jg=;
        b=eNt0dddp9Z917VVzLlhHs7D6avib8R22eyOV8uIzlPEX0PTLHza2Yp+o0dg23NHgBy
         NAGAKqWrzlAtVCbMPKUAoVLLvw6dRDbo1FPtbL09QGBzwJSzGL2RTYlXEmfIzHN5rFiY
         GVPz5uEM6p3nv4FvzbTPNN4Cvld4e+8INB0NVVoDM8tnYx3knNClD8+pm5Jrj4YQTrzU
         kR9YSfSjkHmIkVvMwqs38qq4aibpGF4ZD0vyJgDzYtw/WQ7ULr2cYLAJAxCMAmNp8DAS
         aqyx26VQfO2L5Ai6hNNj3wTcyDUutFt8jPNFGXXlKQtO/b64THnIKEjzbV4JQUR46BB7
         RN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=twguqexeRVd3avw9S5VXaqbbsGzTmU7wsW6IQLEa0Jg=;
        b=dCn+gj9eILp1+Bf8MsmEdRPmQ60pWafq98HkU+CWaWJ61qMgmUkcTx4/qtkHy/ckrR
         iAVfO5mm46IYld0aKxLYynMEpO7aQc+X8wRcClTxUgJaKQ5kasC5GrS770Q7CQbYlSEX
         sbbsxd7wh1zULZY4czKP/huWgfkt20HRdMfB8WMf5VC1H6ON7a0wYfIgftZK7qv752Nd
         Wy1SrTcV435PxZheytORgUju0NddfOqLTlFmDsjIoLGG2P3j2btAKyzSpWk8cbwkKUwr
         CzswemVrt8Fx2s95AyVwFt7YNw6sM1EQaXR9nhNSjN/8zQeQ0vgqttJkUZiYsXLME+bk
         kGTw==
X-Gm-Message-State: AOAM532SyCBaLcdfseQCgOdScgkbUSqGKKv5A3YbMG8uyWEGJT82LKio
        JcS+Gi1NwBkw/AE31coasFclNIU8h3eIDN2euoY=
X-Google-Smtp-Source: ABdhPJzhvVHFmNnZRWEf1QXvcufCytLvdAgUUv3Ovyndt2FiCjxc6CzE4Ucntgd9bVVMENK0MDdYvCIlB5ueLl7vyvg=
X-Received: by 2002:a1f:d642:: with SMTP id n63mr10182847vkg.77.1595071298192;
 Sat, 18 Jul 2020 04:21:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200712132554.GS1551@shell.armlinux.org.uk> <CAOAjy5T0oNJBsjru9r7MPu_oO8TSpY4PKDg7whq4yBJE12mPaA@mail.gmail.com>
 <20200717092153.GK1551@shell.armlinux.org.uk> <CAOAjy5RNz8mGi4XjP_8x-aZo5VhXRFF446R7NgcQGEKWVpUV1Q@mail.gmail.com>
 <20200717185119.GL1551@shell.armlinux.org.uk> <20200717194237.GE1339445@lunn.ch>
 <20200717212605.GM1551@shell.armlinux.org.uk> <CAOAjy5Q-OdMhSG-EKAnAgwoQzF+C6zuYD9=a9Rm4zVVVWfMf6w@mail.gmail.com>
 <20200718085028.GN1551@shell.armlinux.org.uk> <CAOAjy5SewXHQVnywzin-2LiqWyPcjTvG9zzaiVRtwfCG=jU1Kw@mail.gmail.com>
 <20200718101259.GO1551@shell.armlinux.org.uk>
In-Reply-To: <20200718101259.GO1551@shell.armlinux.org.uk>
From:   Martin Rowe <martin.p.rowe@gmail.com>
Date:   Sat, 18 Jul 2020 11:21:26 +0000
Message-ID: <CAOAjy5SDgAeF7=mQWByGTFUsctkuAUpwhbaTzNWcsebbyof+gQ@mail.gmail.com>
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

On Sat, 18 Jul 2020 at 10:13, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
> Okay, on top of those changes, please also add this:

"in-band-status" plus your chip.c patch works; I can now ping from the GT 8K.

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
mvpp2 f4000000.ethernet eth2: Link is Up - 2.5Gbps/Full - flow control rx/tx
mvpp2 f4000000.ethernet eth2: Link is Down
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
 0:  c801       0    ffff  9e07 9e4f 100f 100f 9e4f 9f0b
 1:     0    803e    ffff     3    3    3    3    3 200f
 2:     0       0    ffff  ff00    0    0    0    0    0
 3:     0       0    ffff  3400 3400 3400 3400 3400 3400
 4:  40a8     258    ffff    7c  43d  43c  43c  43f 373f
 5:  1000     4f0    ffff     0    0    0    0    0    0
 6:     0    1f0f    ffff    7e   7c   7a   76   6e   5f
 7:     0    703f    ffff     1    0    0    0    0    0
 8:     0    7800    ffff  2080 2080 2080 2080 2080 2080
 9:     0    1500    ffff     1    1    1    1    1    1
 a:   509       0    ffff  8000    0    0    0    0    0
 b:  3000    31ff    ffff     1    2    4    8   10    0
 c:     0       0    ffff     0    0    0    0    0    0
 d:  3333     59b    ffff     0    0    0    0    0    0
 e:  ff5b       3    ffff     0    0    0    0    0    0
 f:  6cff     f00    ffff  9100 9100 9100 9100 9100 dada
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
1b:   1fc    110f    ffff  8000 8000 8000 8000 8000 8000
1c:   7c0       0    ffff     0    0    0    0    0    0
1d:  1400       0    ffff     0    0    0    0    0    0
1e:     0       0    ffff  f000 f000 f000 f000 f000 f000
1f:     0       0    ffff     0   fe    0    0   e7   52
