Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE5D6766A7
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 15:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjAUONW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 09:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAUONV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 09:13:21 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5BA23138;
        Sat, 21 Jan 2023 06:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1674310370;
        bh=EXqz70GQPIQCYT1nLHB6JIEG5NSP4ByZ1ECB2Q4fYpw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=rOD0FoAf5W+titksYeICIuZ90QQUup8CZLJV/SN3Xfkx9c31OoL1jZZxq1/JSgoUD
         ofS9rgWEPxVpHh/zjG6rG5sGQ+94Y/WIKsOe/UrXecslxDLvVEI8qAb8yGoal7RBi7
         qWbiZ8kv39YKTiDXnV7zcEcgH/K0S+MkAXQJrLlTEV89J8EZZOl8HxrOIBSgt7qFAx
         5ZJfagH2X6hfd/IoklfjsYyCxMoNtwHrRi/f7Ox9syRRlGTvIyWPrKglXyQwTHL5fD
         J25fMNREOC+lGA9UbNazIRNShbL9B1+SlElU7aEPOG5LgAliSwsPJEqVnitOljCcUZ
         1L+bfOubsdaiQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.152.198] ([217.61.152.198]) by web-mail.gmx.net
 (3c-app-gmx-bap60.server.lan [172.19.172.130]) (via HTTP); Sat, 21 Jan 2023
 15:12:50 +0100
MIME-Version: 1.0
Message-ID: <trinity-cbf3ad23-15c0-4c77-828b-94c76c1785a1-1674310370120@3c-app-gmx-bap60>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Aw: Re: [BUG] vlan-aware bridge breaks vlan on another port on same
 gmac
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 21 Jan 2023 15:12:50 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20230121133549.vibz2infg5jwupdc@skbuf>
References: <trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36>
 <20230120172132.rfo3kf4fmkxtw4cl@skbuf>
 <trinity-b0df6ff8-cceb-4aa5-a26f-41bc04dc289c-1674303103108@3c-app-gmx-bap60>
 <20230121122223.3kfcwxqtqm3b6po5@skbuf>
 <trinity-7c2af652-d3f8-4086-ba12-85cd18cd6a1a-1674304362789@3c-app-gmx-bap60>
 <20230121133549.vibz2infg5jwupdc@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:75DkVLOdpXIMLqBIY7SOwUCzgXxZYPyfo5cKr/3xL8SwwUsNLdGtV6cws8oydF8bN9O1a
 YPw1N41mWmqnBoM4H1SLjvGf7wReEsOxIYJf7LxfpiLESsoD7BGx/mkxLXqS2HkFMOZjX7s5ErQo
 5OGa2YMcmXAyC6BsGBPdK9eKstyfaKte3eR2PDsLh0p6rl9qDgs3hISDKvYnj9Wr+taAKOuXPuGd
 QlQ27w8ODwRH5QHdKM0vzsp/+rxvPQxH87XdAvXoX7KQ0SIw1QGWUgYx/1CLa7KHXV6+3QuR12w2
 v4=
UI-OutboundReport: notjunk:1;M01:P0:wmk6B6aAZVQ=;J+QEXdqV5YCSowD2rT41GWI/15W
 ANNdU1r+EaPYx1m0uefzzmBGIPKHJ8krgl/s2qdQIcFTC3UwEykS2lHeSOxLBJjpTAUvNOaD7
 oZgGmnCwoj08Sf+uazEre6Op3RmL7bhVqbPrJecpBkFfVPRCO1LcmFrjEupzHybA1HtFWHbib
 KfIb3FWy9sRRqvM3qWvloTC+xY5AKH2T18aZ+pr0F+ii3s0WhIreTxwABm2O/yf7duSSF9dZC
 caYmieU1phDZWzJ9s5geiKPGl/dnkEihtAaKI/t5Foy5j02UuIp0vFUwlGF7BT6ja5qJ474t0
 jowKNArDRemdfGT5rGfXcc9jaRu6C64snaGRhAk8adoIquO1s5bg8sDaMNb3MlfN77Rbf3T1X
 TocKg/85mHUOhWKncnOw2bezKMhskj/pxjO1rfE4wr2dQ7Hl9Ww1h+1QQt/mmgQV2TFMMn2qR
 hJ3/0zbhWoC09Jgx+e2qL7U32TGEqvBoZHuTdy/rp8U7YmaekboldRp0HLcbtbCNGBDOUEot0
 QGdhldj+7pWUnFPyygfd6l8LcIMgcAEtlZP2d0dawdEyEStzKA9L+H6bcFdas7oik+O4eHQ2k
 748e/BNfea30yLLeOXmaObwi1dXz4wvtrRFVXYbqYfzEOTXeF8sg8X4cq+NP25qUMhCKDoprM
 VdAk+uyMduwnXOFBbxV4f5cebdvljoLuQPKn5P+MRf+UXPlceIkw9r41163MOrm5w/YiAT3/R
 cXxyl4O3YhrVT2PuAKizJ7uvngtNup6QuqDSdxsn9yxDW6jQ7RSV2XC4+NlCaJKwz9tTaMwBb
 r8gtt3JcGahtSdjjH4NwdkwQ==
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

> Gesendet: Samstag, 21. Januar 2023 um 14:35 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail.com>
> An: "Frank Wunderlich" <frank-w@public-files.de>
> Cc: "Andrew Lunn" <andrew@lunn.ch>, "Florian Fainelli" <f.fainelli@gmail=
.com>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@g=
oogle.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redh=
at.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Landen Cha=
o" <Landen.Chao@mediatek.com>, "Sean Wang" <sean.wang@mediatek.com>, "DENG=
 Qingfang" <dqfext@gmail.com>, "Matthias Brugger" <matthias.bgg@gmail.com>=
, "Daniel Golle" <daniel@makrotopia.org>
> Betreff: Re: [BUG] vlan-aware bridge breaks vlan on another port on same=
 gmac
>
> On Sat, Jan 21, 2023 at 01:32:42PM +0100, Frank Wunderlich wrote:
> > so first patch fixes the behaviour on bpi-r3 (mt7531)...but maybe mt75=
30 need the tagging on cpu-port
> >
> > > Can you try the second patch instead of the first one? Without diggi=
ng
> > > deeply into mt7530 hardware docs, that's the best chance of making
> > > things work without changing how the hardware operates.
> >
> > second patch works for wan, but vlan on bridge is broken, no packets r=
eceiving my laptop (also no untagged ones).
>
> It's hard for me to understand how applying only patch "tag_mtk only
> combine VLAN tag with MTK tag is user port is VLAN aware" can produce
> the results you describe... For packets sent to port lan0, nothing
> should have been changed by that patch, because dsa_port_is_vlan_filteri=
ng(dp)
> should return true.
>
> If you can confirm there isn't any mistake in the testing procedure,
> I'll take a look later today at the hardware documentation and try to
> figure out why the CPU port is configured the way it is.

ok, booted again the kernel with first patch ("mt7530 don't make the CPU p=
ort a VLAN user port")
and yes lan0-vlan is broken...
seems i need to reboot after each lan/wan test to at least clean arp-cache=
.

but patch2 ("tag_mtk only combine VLAN tag with MTK tag is user port is VL=
AN aware") still not
works on lanbridge vlan (no packet received on target).

regards Frank
