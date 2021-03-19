Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D646341D5E
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 13:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhCSMuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 08:50:51 -0400
Received: from mout.gmx.net ([212.227.17.20]:42783 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230131AbhCSMuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 08:50:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1616158048;
        bh=ot4zJ0YuFv09BC6CagdPaeT+OYONcIZl47TymXx88oU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=f2qapYJzSWlVnyvJLaAEjGu/FV4sjedoiWHftbP1ZK7Gk+ZUs8z8bM8PryEAa2t91
         RqC617lRde/Mx/5xQ1AKL7fIewqxAd1AerVJiZaMNiZww69TJYDMSzT8yfhLnF1l49
         K61lNQomEGcuP7B61+1TmanY8gFp6JVCWz14WRl4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.73.76] ([80.245.73.76]) by web-mail.gmx.net
 (3c-app-gmx-bs45.server.lan [172.19.170.97]) (via HTTP); Fri, 19 Mar 2021
 13:47:28 +0100
MIME-Version: 1.0
Message-ID: <trinity-9ff2d2c2-6be1-415f-bf29-a04849cb74dc-1616158048677@3c-app-gmx-bs45>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        sander@svanheule.net, tsbogend@alpha.franken.de, john@phrozen.org
Subject: Aw: Re: [PATCH net,v2] net: dsa: mt7530: setup core clock even in
 TRGMII mode
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 19 Mar 2021 13:47:28 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210319102555.Horde.jeA-oYm4tfkVqKj-gnqxRoo@www.vdorst.com>
References: <20210311012108.7190-1-ilya.lipnitskiy@gmail.com>
 <20210312080703.63281-1-ilya.lipnitskiy@gmail.com>
 <20210319102555.Horde.jeA-oYm4tfkVqKj-gnqxRoo@www.vdorst.com>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:/JAMS70hSO9E7auBQoy+PTUBMdwWO0tyCT8wAfsetNDbfDHgPvU7tbc0r0PIuEcowSMgT
 xTdjSvHjU16y6W89NE74x/aTprgLupH69qoBxMeFaV3fxUz6dPgECWZIcSwrYEqaGVQjhUIGgen2
 yZoxPW6KanP0jFrsJLWk94/LB83i9oL+xiqbnHmQYvsypCj3IQQsSf5QC2NU6iwACnAsqG2e8wVI
 p+RgMx9cCprlXwfE25xKX5WMS0jqdqbZC6yO6g2ixNbmmFMxWFGT0YLl4n0j0p9jwObtc5FwJHID
 dE=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jOGlQcFy+kU=:0RPXl9xNbwbLzaRkWYWvlA
 iHmSaOHaEx/n24sZPVQK+3za81nbBWRMt8bL4GfZWl0fTSpbdwap1u15g4enG+fDzOwZL+2im
 JndOB1gK5wOCV96G5RbNjJfkxwtmfuTRJWpOBt9Ry2hLQzvsH5HwdnssvCwXHN44skvdAtfkT
 urZf+luh5EpSOYjDoub+pYUvWgB3fZq130rHtN2zdBjYEJpZfmsP5MOAWo0H+XKS/7ZGxbU4t
 DH9mcwqE1O00ZiKFhCSRsfpOOAAEm5h74nv1d9GA8wi8oLVgz5wAvExSGeIY7rWUq3RKQIKkR
 gX7RvqY1U7ieBtl4f5KAnUyfvqNv8im/zWMHCM3ZkXn4LPyyVv06gYBfwBy5Y7sGvUEqT7AIB
 QrMKBHQyzV8OOVLSk+9ox7TbwODwajKYf1xg3XdTLTxnYTTiGkruLkCli4vOZoi1J4CqCVWyd
 M5Mtp8U4NSI/nLTwPOcvXs0HPQidXhU9O+iC5TonQUTQdVQcKKQyJwfATy7Ia+gPU9HfdkWeq
 95VZ6WhTnMAFoeCF7MjIBsRhLihKFzRusKsL/5xcpRhpv0rwXPnIJoa6ya7pgiYfJ6RJiTPVx
 sfvJUiNdRLfVWJ0UwuiFA2o1qaoTpzRzjKyXaHWN9wNM9NlU24UUCxbJrA4RuXO31dpyr7JI7
 6uEr0ZfyG+5f+1iyMGL3PXWcRPj9uwRDFuewZf4Kxgf/7GGNsHNXGmzB5IbMz4u+YMPMZoVjl
 dN+XI5nrO9T7PJ8zK7OpDDQ6e3VzBN52hAIeB+tcyYsJ0zsXUqrdhzOe09EOd+hYTIi75XHJQ
 WIp6lUDrdtvDUUkwOcHK4nrzpUsXFb0r9lsO/YY63KrNiKf9m5ILXKZ7G/tQwbFEqkYg3/exk
 p6agWNQx4yb8Nt6WbZ5ZJVYPy1Z3r3HACdF4c+Dul+s7mp3nosQ+9pCthjXjHPIm4aOdVDeFf
 JbYlzXRD9tw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ren=C3=A9,Ilya

> Gesendet: Freitag, 19=2E M=C3=A4rz 2021 um 11:25 Uhr
> Von: "Ren=C3=A9 van Dorst" <opensource@vdorst=2Ecom>
> Hi Ilya,
>=20
> Thanks for fixing this issue=2E
>=20
> I remember that Frank also had an issue with TRGMII on his MT7623 ARM bo=
ard=2E
> I never found why it did not work but this may be also fix his issue =20
> on the MT7623 devices=2E
>=20
> Added Frank to CC=2E

thanks for pointing me here=2E my issue was after getting trgmii working w=
ith phylink-patches (5=2E3) that i only got only 940Mbit over the switch/gm=
ac0 (using multiple clients to one iperf3-server), trgmii afair supports ~2=
=2E1 Gbit/s, so nearly twice bandwidth possible in theory=2E this maybe can=
 clock-related

I'm not sure if it is the same issue ilya fixes here, but i try to test th=
is on my bananapi-r2

regards Frank
