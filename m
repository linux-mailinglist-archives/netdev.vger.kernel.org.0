Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42ACE6B64C7
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 11:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjCLKPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 06:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjCLKPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 06:15:21 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7780034312;
        Sun, 12 Mar 2023 03:15:18 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id ay8so825121wmb.1;
        Sun, 12 Mar 2023 03:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678616117;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=asmlxdEeQZ+Mzc1CEzEJPScCCH3k/Xqn1dljqOOaOoM=;
        b=BG0WwH/QzxV8pCZWgfH4TcyopcMKDNdAyhA7DaO0nN4RPcl0FOaTM6XRmUT76px4G2
         CJZjRlLu3slHntSBAtO1Bbb3fUaijW3bh0bWaFsK1Y8W0bmCE7EPedWUCteoYqgKDvIK
         8Q9R6YP1uZ3Pec9TsRtU5EuJKAwC4DmhYHvxtU9BxHYWQjMJ91LMQixEIAmJ4qT61d+f
         gmaP85ZtV2KiMjmR6LiZ+tSkt4AXMHFUIyxwkf1GjS/1REMvLH0nrtitr+XoEqs2iTFy
         iD150bV26WOty/lxBhPYSF5i3kCJihnoA+rmlgq1AR4ctFGOcCkyIWc0URUmDXF0AdwK
         aHDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678616117;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=asmlxdEeQZ+Mzc1CEzEJPScCCH3k/Xqn1dljqOOaOoM=;
        b=Er8hgIqEk+QjidxeyPONgANP5RuDqryNAcAiylN8vFnbZXRUBlc+77/xB7/PSjT2H/
         pE8zFRGjASQpUZ2K4wHoR2b4eOWwqi8y9FLsxOgH280gWpeZCOEKzTu9gTBWOfp/D6w2
         jqY29wYInAmnK2Mu57DC6umB0GPXawucbGxo0vcV5RNbOV72ZnpujLUhq4hs1GEPjoM5
         DVEyuK4dWxoJKpRpTjmtwiHgXsjvw2mZLN+//LuZgblgMoPNxdAN3q0Bu9Pv+uLN6T8l
         LzGxvkAVj1HSoBfX2kZTgWnsRO7SJQ6Sa9iC+opx2EV+nGGyNZFtF0xyl4dojWM41Kpz
         YzNg==
X-Gm-Message-State: AO0yUKUGZLuxBMOcmQ1mhL03uYCOJC80gfEvNVkfU55+NIQciB78Nkr/
        5n740418Bzhxc6eOLQXBoHi0tQYcCcwTlw==
X-Google-Smtp-Source: AK7set9Q7C0M0F/2khN7TsfVBk1tDeUhkCWefT9qCjg3jY9arTNZIJCvUpTGJrvVrVcS4kn9L3cudQ==
X-Received: by 2002:a05:600c:35d2:b0:3eb:1d0c:ad71 with SMTP id r18-20020a05600c35d200b003eb1d0cad71mr8007524wmq.23.1678616116776;
        Sun, 12 Mar 2023 03:15:16 -0700 (PDT)
Received: from ?IPv6:2a02:168:6806:0:b020:289a:731d:fbb8? ([2a02:168:6806:0:b020:289a:731d:fbb8])
        by smtp.gmail.com with ESMTPSA id v7-20020a05600c444700b003e204fdb160sm5940830wmn.3.2023.03.12.03.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 03:15:16 -0700 (PDT)
Message-ID: <98315424312f6f6abca771d27a78b2e41dcb6d6a.camel@gmail.com>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: mv88e6xxx: move call to
 mv88e6xxx_mdios_register()
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 12 Mar 2023 11:15:15 +0100
In-Reply-To: <20230311224951.kqcihlralwehfvaj@skbuf>
References: <20230311203132.156467-1-klaus.kudielka@gmail.com>
         <20230311203132.156467-3-klaus.kudielka@gmail.com>
         <20230311224951.kqcihlralwehfvaj@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-03-12 at 00:49 +0200, Vladimir Oltean wrote:
> While testing this, I've noticed the following behavior change:
>=20
> Before:
>=20
> [root@mox:~] # echo d0032004.mdio-mii:10 > /sys/bus/mdio_bus/drivers/mv88=
e6085/unbind
...
> [root@mox:~] # echo d0032004.mdio-mii:10 > /sys/bus/mdio_bus/drivers/mv88=
e6085/bind
> [=C2=A0=C2=A0 45.726662] mv88e6085 d0032004.mdio-mii:10: switch 0x3900 de=
tected: Marvell 88E6390, revision 1
...
> [=C2=A0=C2=A0 55.068103] DSA: tree 0 setup
>=20
> After:
>=20
> [root@mox:~] # echo d0032004.mdio-mii:10 > /sys/bus/mdio_bus/drivers/mv88=
e6085/unbind
...
> [root@mox:~] # echo d0032004.mdio-mii:10 > /sys/bus/mdio_bus/drivers/mv88=
e6085/bind
> [=C2=A0=C2=A0 46.422669] mv88e6085 d0032004.mdio-mii:10: switch 0x3900 de=
tected: Marvell 88E6390, revision 1
...
> [=C2=A0=C2=A0 51.351383] mv88e6085 d0032004.mdio-mii:11 lan9 (uninitializ=
ed): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:01] driver=
 [Marvell 88E6390 Family] (irq=3D0)
> [=C2=A0=C2=A0 51.366620] Marvell 88E6390 Family !soc!internal-regs@d00000=
00!mdio@32004!switch1@11!mdio:01: Error -22 requesting IRQ 0, falling back =
to polling
...
> [=C2=A0=C2=A0 56.197980] DSA: tree 0 setup
>=20
> instead I am noticing that the internal PHYs of switch d0032004.mdio-mii:=
11 and
> d0032004.mdio-mii:12 are failing in phy_request_interrupt() - request_thr=
eaded_irq()
> returns -EINVAL.
>=20
> I haven't studied yet why that is. This happens with arch/arm64/boot/dts/=
marvell/armada-3720-turris-mox.dts,
> which doesn't describe the switch PHY interrupts in the DTS. I don't know=
 more yet.
>=20
> There's nothing worth mentioning in the boot log prior to my unbind/bind =
commands.

Just trying to reproduce this on the Omnia (with the whole series applied, =
plus some
*** debug *** messages concerning timing). But all seems to be good here:

root@spare:/sys/bus/mdio_bus/drivers/mv88e6085# echo f1072004.mdio-mii:10 >=
unbind
[ 3735.983144] mvneta f1030000.ethernet eth1: Link is Down
[ 3735.987548] mvneta f1030000.ethernet eth1: configuring for fixed/rgmii l=
ink mode
[ 3735.988464] mvneta f1070000.ethernet eth0: left promiscuous mode
[ 3735.988544] mvneta f1030000.ethernet eth1: Link is Up - 1Gbps/Full - flo=
w control off
[ 3735.990900] br0: port 5(lan0) entered disabled state
[ 3735.992379] mv88e6085 f1072004.mdio-mii:10 lan0 (unregistering): left al=
lmulticast mode
[ 3735.992392] mv88e6085 f1072004.mdio-mii:10 lan0 (unregistering): left pr=
omiscuous mode
[ 3735.992438] br0: port 5(lan0) entered disabled state
[ 3736.054036] br0: port 4(lan1) entered disabled state
[ 3736.054239] mv88e6085 f1072004.mdio-mii:10 lan1 (unregistering): left al=
lmulticast mode
[ 3736.054248] mv88e6085 f1072004.mdio-mii:10 lan1 (unregistering): left pr=
omiscuous mode
[ 3736.054275] br0: port 4(lan1) entered disabled state
[ 3736.107691] br0: port 3(lan2) entered disabled state
[ 3736.107894] mv88e6085 f1072004.mdio-mii:10 lan2 (unregistering): left al=
lmulticast mode
[ 3736.107903] mv88e6085 f1072004.mdio-mii:10 lan2 (unregistering): left pr=
omiscuous mode
[ 3736.107929] br0: port 3(lan2) entered disabled state
[ 3736.155780] br0: port 2(lan3) entered disabled state
[ 3736.155974] mv88e6085 f1072004.mdio-mii:10 lan3 (unregistering): left al=
lmulticast mode
[ 3736.155983] mv88e6085 f1072004.mdio-mii:10 lan3 (unregistering): left pr=
omiscuous mode
[ 3736.156011] br0: port 2(lan3) entered disabled state
[ 3736.211477] br0: port 1(lan4) entered disabled state
[ 3736.211787] mv88e6085 f1072004.mdio-mii:10 lan4 (unregistering): left al=
lmulticast mode
[ 3736.211797] mvneta f1030000.ethernet eth1: left allmulticast mode
[ 3736.211811] mv88e6085 f1072004.mdio-mii:10 lan4 (unregistering): left pr=
omiscuous mode
[ 3736.211816] mvneta f1030000.ethernet eth1: left promiscuous mode
[ 3736.211865] br0: port 1(lan4) entered disabled state
[ 3736.282416] mv88e6085 f1072004.mdio-mii:10: Link is Down
[ 3736.283704] mv88e6085 f1072004.mdio-mii:10: Link is Down
[ 3736.284864] DSA: tree 0 torn down


root@spare:/sys/bus/mdio_bus/drivers/mv88e6085# echo f1072004.mdio-mii:10 >=
bind
[ 3812.564891] mv88e6085 f1072004.mdio-mii:10: *** mv88e6xxx_probe call ***
[ 3812.565234] mv88e6085 f1072004.mdio-mii:10: switch 0x1760 detected: Marv=
ell 88E6176, revision 1
[ 3812.587468] mdio_bus mv88e6xxx-1: *** mdiobus_scan_bus_c22 call ***
[ 3812.685412] mdio_bus mv88e6xxx-1: *** mdiobus_scan_bus_c22 return ***
[ 3812.685424] mdio_bus mv88e6xxx-1: *** mdiobus_scan_bus_c45 call ***
[ 3812.877792] mdio_bus mv88e6xxx-1: *** mdiobus_scan_bus_c45 return ***
[ 3813.539320] mv88e6085 f1072004.mdio-mii:10: configuring for fixed/rgmii-=
id link mode
[ 3813.541571] mv88e6085 f1072004.mdio-mii:10: configuring for fixed/rgmii-=
id link mode
[ 3813.542825] mv88e6085 f1072004.mdio-mii:10: Link is Up - 1Gbps/Full - fl=
ow control off
[ 3813.547546] mv88e6085 f1072004.mdio-mii:10: Link is Up - 1Gbps/Full - fl=
ow control off
[ 3813.588899] mv88e6085 f1072004.mdio-mii:10 lan0 (uninitialized): PHY [mv=
88e6xxx-1:00] driver [Marvell 88E1540] (irq=3D68)
[ 3813.593875] mvneta f1030000.ethernet eth1: Link is Down
[ 3813.598298] mvneta f1030000.ethernet eth1: configuring for fixed/rgmii l=
ink mode
[ 3813.598402] mvneta f1030000.ethernet eth1: Link is Up - 1Gbps/Full - flo=
w control off
[ 3813.642980] br0: port 1(lan0) entered blocking state
[ 3813.642996] br0: port 1(lan0) entered disabled state
[ 3813.643022] mv88e6085 f1072004.mdio-mii:10 lan0: entered allmulticast mo=
de
[ 3813.643031] mvneta f1030000.ethernet eth1: entered allmulticast mode
[ 3813.694319] mv88e6085 f1072004.mdio-mii:10 lan0: entered promiscuous mod=
e
[ 3813.694329] mvneta f1030000.ethernet eth1: entered promiscuous mode
[ 3813.695964] mv88e6085 f1072004.mdio-mii:10 lan1 (uninitialized): PHY [mv=
88e6xxx-1:01] driver [Marvell 88E1540] (irq=3D69)
[ 3813.704931] mv88e6085 f1072004.mdio-mii:10 lan0: configuring for phy/gmi=
i link mode
[ 3813.756527] br0: port 2(lan1) entered blocking state
[ 3813.756539] br0: port 2(lan1) entered disabled state
[ 3813.756560] mv88e6085 f1072004.mdio-mii:10 lan1: entered allmulticast mo=
de
[ 3813.763061] mv88e6085 f1072004.mdio-mii:10 lan2 (uninitialized): PHY [mv=
88e6xxx-1:02] driver [Marvell 88E1540] (irq=3D70)
[ 3813.791552] mv88e6085 f1072004.mdio-mii:10 lan1: entered promiscuous mod=
e
[ 3813.797391] mv88e6085 f1072004.mdio-mii:10 lan1: configuring for phy/gmi=
i link mode
[ 3813.839969] br0: port 3(lan2) entered blocking state
[ 3813.839982] br0: port 3(lan2) entered disabled state
[ 3813.840003] mv88e6085 f1072004.mdio-mii:10 lan2: entered allmulticast mo=
de
[ 3813.870495] mv88e6085 f1072004.mdio-mii:10 lan2: entered promiscuous mod=
e
[ 3813.871911] mv88e6085 f1072004.mdio-mii:10 lan2: configuring for phy/gmi=
i link mode
[ 3813.889652] mv88e6085 f1072004.mdio-mii:10 lan3 (uninitialized): PHY [mv=
88e6xxx-1:03] driver [Marvell 88E1540] (irq=3D71)
[ 3813.940164] br0: port 4(lan3) entered blocking state
[ 3813.940176] br0: port 4(lan3) entered disabled state
[ 3813.940198] mv88e6085 f1072004.mdio-mii:10 lan3: entered allmulticast mo=
de
[ 3813.971126] mv88e6085 f1072004.mdio-mii:10 lan3: entered promiscuous mod=
e
[ 3813.972540] mv88e6085 f1072004.mdio-mii:10 lan3: configuring for phy/gmi=
i link mode
[ 3813.989835] mv88e6085 f1072004.mdio-mii:10 lan4 (uninitialized): PHY [mv=
88e6xxx-1:04] driver [Marvell 88E1540] (irq=3D72)
[ 3813.999680] mvneta f1070000.ethernet eth0: entered promiscuous mode
[ 3813.999719] DSA: tree 0 setup
[ 3813.999727] mv88e6085 f1072004.mdio-mii:10: *** mv88e6xxx_probe return 0=
 ***
[ 3814.043574] br0: port 5(lan4) entered blocking state
[ 3814.043587] br0: port 5(lan4) entered disabled state
[ 3814.043610] mv88e6085 f1072004.mdio-mii:10 lan4: entered allmulticast mo=
de
[ 3814.073902] mv88e6085 f1072004.mdio-mii:10 lan4: entered promiscuous mod=
e
[ 3814.075319] mv88e6085 f1072004.mdio-mii:10 lan4: configuring for phy/gmi=
i link mode
[ 3817.139771] mv88e6085 f1072004.mdio-mii:10 lan3: Link is Up - 1Gbps/Full=
 - flow control rx/tx
[ 3817.139793] IPv6: ADDRCONF(NETDEV_CHANGE): lan3: link becomes ready
[ 3817.139854] br0: port 4(lan3) entered blocking state
[ 3817.139862] br0: port 4(lan3) entered forwarding state

Best regards, Klaus

