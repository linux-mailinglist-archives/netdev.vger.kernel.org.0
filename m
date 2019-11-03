Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433CDED2BF
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 10:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfKCJeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 04:34:46 -0500
Received: from mout.gmx.net ([212.227.17.22]:38193 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbfKCJeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Nov 2019 04:34:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1572773654;
        bh=JDudkfcLPlmic6l/Jq8in0aJVqg42HYoE+FBfr8EspE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=U0tGWWB1CCXG69FCpLlBPzNWRsUIvuWq0jeQhPCBRzj3jSqGmvaHKwCQKRIOleW7a
         XnLTDoLYIT9bMwvtWQoQwEA1Zx7Kpl22UNFkvvtO6qXCqUH5S1EFJEc4VYC+wdmRpo
         ChykDebyHU/wB7K5kpd+cUAqEhXaSzOm+9PnBagk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.112]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MAfYm-1iGDvS0u9Q-00B0AS; Sun, 03
 Nov 2019 10:34:14 +0100
Subject: Re: [PATCH RFC V2 5/6] net: bcmgenet: Add RGMII_RXID and RGMII_ID
 support
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        Eric Anholt <eric@anholt.net>,
        bcm-kernel-feedback-list@broadcom.com,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        linux-arm-kernel@lists.infradead.org
References: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
 <1572702093-18261-6-git-send-email-wahrenst@gmx.net>
 <b1b998af-c28f-f037-647d-63c4fb52fe95@gmail.com>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <aa43630e-1816-3023-5b6a-11c71fe4a258@gmx.net>
Date:   Sun, 3 Nov 2019 10:34:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <b1b998af-c28f-f037-647d-63c4fb52fe95@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:bFXIRqBd2zkQgCI4V54naT2Sza6rLEiWuqjZZKTD2Tq9udKfs0h
 3avxGzGgZmE+uZKDvxGszNYIRPjMuZqI6n8qxYRnJm4UCdCHnYM+/UCJSEUHY/aaRhp3ODN
 +QvhE37EuAlWelBmVOZn9/iyrFZIPY4AprMcI15yA8e3qLSbrVYK4aRWSi88J8OmJNRKrMg
 LtTkS+cjSbXSDkfvK1kIw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Mh8oxiu88A0=:GwBN3mdTNB86sq3Cp7XE9P
 SKSIYUw16xxmA8p5OEW33OAU8PifSGiJiCPuE1c86yqr1lyjysSqpXyPdI0QmNMyD0alMPbKa
 KAd0eM5YLukggUgrVLgock+UEcYshoyGJ8vnBFvA05idTudk9717AW9rR0uRmdseEkrgloqbM
 P1PVAXxeuOvtJeCxHwlxcs9cmnIEu7KzJkSHEWEVMm//uGL4OVhMERI8xNucOhHLOi7xRmRtU
 Y33gV9oZLR26fb3yebS3QnDk90D++j6w9C0oB/oEHAzZe/5Og92J20MI3VHcqJlKltMaUWDxs
 9kxuBlEm0UwBsPqwJqT2vT39i3zPjUZtoOtSvzfXFKE6XmzdLCeKMFUnKCAjFmpp6Qj+D1hD2
 6Ro2pqx04/HO6poLqbgDezr4l3MKtPh9UmzycML9Cu862e2jn4S6vQCMk8jmbWAvg27jLv3Yh
 +ikl5S/XmmKibxxY166n6c6+n6kJSAHZbYYmRErX8ojoj5jmXaRaQrQxuM0zRY2N3sN82Tl5B
 u2EC3hlS8CAnzpE+AETC38lycVNz3h1F7OCbpK2qEnkvTYdnJNyTPq/plQ+m2APD2opni8h8X
 tyJXNp58i26FEw/qIF1HH8aps+tpLqjPmvmNnaD6QFNbIiyBESHQqGg93eUfaHPfNeBd13g+6
 W6TMxeRzeN85MLk2hMYCHENI6xXykmxKpnqd4dUqmYZXHM0ZTvinz55UUG2mFffqMeb875Hs8
 H7eoPB+Qx1h294qtKnpibz5sXTcbIWEWGC24mW5koQTyFip9lZfRbFMe72AvBgia09cHpIPA6
 1NKMsYftvEc6EIHBUvFAmymc+dYMQtEBnMNSqjUfVhvFfwVBUn11YBbQ0RYUQykUPPZ+mxnsA
 ZHS6yhJqN+qPzxT+GrQga+hqEM2SIfEb6hjwRbj4+pvwPyS1ChNqoJNLRnc5f2WKRA6HFXwnB
 uZJqviydSyOEe7+JOh6DZQLHLSjobU3psCtBLxYZ6vhVlEN/pvsasGRnDwwtEnlRRzZ43Pvk6
 lzqEz9Do2V7wUrC4ub+q7XnOLBbyy28wuluuEhOZqoauE7oySp5kWpDo55JS/5kl1UGNA0WBM
 CVYFU7EtHF5M33QMKrgzmigY/HmVlp6zK7BEhVDzIRueFLW3FfzpaiTwyFUrIHALQa1J7iOx8
 G+cTHpY1BZQbYghAZ2hiNArGeqTHqDFOUFexobFQHG8NjKrK4dbn4OMslvRTyV5kBHiwpslQp
 Z2xGyfHv8IoRl+CHH/XQZkojj0TaQJ/++enhNXJXfAUh11P4iSn2D5IH3R6s=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 02.11.19 um 21:00 schrieb Florian Fainelli:
>
> On 11/2/2019 6:41 AM, Stefan Wahren wrote:
>> This adds the missing support for the PHY modes RGMII_RXID and
>> RGMII_ID. This is necessary for the Raspberry Pi 4.
> Are both used?
Sorry, the wording was a little bit unlucky. Only the RGMII_RXID is used.
>  Your next patch only uses "rgmii-rxid". Can you remind me
> of the GTXC and RXC skew setting the PHY you are using comes up with?

I dumped the following register values before bcm54xx_config_clock_delay
tries to change the values:
SHDWSEL_MISC: 0x71E7
SHD_CLK_CTL: 0x0100

https://github.com/raspberrypi/linux/issues/3101#issuecomment-544266615

> And this was tested with Broadcom PHY (drivers/net/phy/broadcom.c)
> driver or with the Generic PHY driver?

After applying the series i'm getting the following output:

[=C2=A0=C2=A0=C2=A0 5.431262] bcmgenet fd580000.ethernet: failed to get en=
et clock
[=C2=A0=C2=A0=C2=A0 5.431271] bcmgenet fd580000.ethernet: GENET 5.0 EPHY: =
0x0000
[=C2=A0=C2=A0=C2=A0 5.431283] bcmgenet fd580000.ethernet: failed to get en=
et-wol clock
[=C2=A0=C2=A0=C2=A0 5.431294] bcmgenet fd580000.ethernet: failed to get en=
et-eee clock
[=C2=A0=C2=A0=C2=A0 5.880660] libphy: bcmgenet MII bus: probed
[=C2=A0=C2=A0=C2=A0 5.970751] unimac-mdio unimac-mdio.-19: Broadcom UniMAC=
 MDIO bus
[=C2=A0=C2=A0 11.570672] bcmgenet fd580000.ethernet: configuring instance =
for
external RGMII (RX delay)
[=C2=A0=C2=A0 11.583231] bcmgenet fd580000.ethernet eth0: Link is Down
[=C2=A0=C2=A0 16.811045] bcmgenet fd580000.ethernet eth0: Link is Up - 1Gb=
ps/Full
- flow control rx/tx

So i assume it's the Broadcom PHY.

Regards
Stefan

