Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D394676626
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 13:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjAUMMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 07:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAUMMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 07:12:08 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CA01A945;
        Sat, 21 Jan 2023 04:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1674303103;
        bh=KRAtAAjLJtxF73MZJDZykxdwPyWVj6jjnSXo06/zfCU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ICbr289n3BQwOocNqNMO/UsKtusWNMmHQfBkqyg5wsm5dX6wOtG7aoz9tqyDws+Tk
         Uf/Bfqv1hEPFCk/W28cpEQyLMXIPztMgWA6yyIHjZxlXY7GEHrweYWQdgYw3oJNnqy
         uxG85SrWfRDUR1CMrLp5NeP6NzOa/7iZP/4vs6z5kYffG8L1NqnTSUJ5oeLzIuYRoc
         3lXf/xFIhi3OfY6+4cJzZa3iouqeljTE3BOTeVkP0QYt43LAITdgcbpZq7oBwywYfT
         wYhV8BxoHH5p0SDmGkOtoxrLx31a42uwTbxxEVWPkx+z8UWlUdzE1F8K49I3/HI7Vo
         PHe5PoNGUOr+Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.152.198] ([217.61.152.198]) by web-mail.gmx.net
 (3c-app-gmx-bap60.server.lan [172.19.172.130]) (via HTTP); Sat, 21 Jan 2023
 13:11:43 +0100
MIME-Version: 1.0
Message-ID: <trinity-b0df6ff8-cceb-4aa5-a26f-41bc04dc289c-1674303103108@3c-app-gmx-bap60>
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
Date:   Sat, 21 Jan 2023 13:11:43 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20230120172132.rfo3kf4fmkxtw4cl@skbuf>
References: <trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36>
 <20230120172132.rfo3kf4fmkxtw4cl@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:TF1FcG15FRiaMm9gayChGGt2qh2MaY3kuYliJkhpIKUtr3D/NDs4Ah7dSL38r6oVvNlwP
 2Psx0CH3fN7k0tbyCYVqb8pNlDVnu/3A0IfScOTrSwciK+1mSsRwG9Gj2KqeXyx8iXzQZP0uoXws
 uTOqyuP7lpK42tCHB1ntKD2KO9Y2psSgOhn0cW3AHZYfLZeprySyrDeVSbiJPIGhI6SjrnewL6B3
 uIW9EeiyXoV4p0XYIXnXWft8K2WR/hCr4aHXUj0LLTBgny65Fkw6xgMs7ThzenzqkGSOy/s4cF3K
 iE=
UI-OutboundReport: notjunk:1;M01:P0:E33RKHT5Oa0=;nofjno+v7TdRfLP6l9Wsd7oJyv2
 8QfxXQtbeE0Z9L8ehi4mXLWJgTRYDeEMOxIqp7QZyR0MPuoxzqnL0ywqrcdyadJrjZitOCDew
 ZTKDlZQymu9oaLpUREDYaqNebyCmTEH9Xclmi8N/AYEcy7Ny9rH80aOaRRGNvoXrK7Uo6BDug
 TSVPoRnycPVCxRkhzREoxM9dAoZcfwte1v9i+y6ovyXHyUBn+YIxn0smhYsGwRWSGL9T/1wEq
 2rb+H2dZL7YrtAFmm00a4imS9j1kpL/r3adKznvNpKGuEEhjB7EhrcxW33IRLgEA+o1Ujb1k1
 i+RaotVxanSoZcVGiQ3UCjua3hkM/LuXdG8Uhe9jHAvj1MXNDRIX59h6YQgLrrzLm4VRWUpFg
 HTKM5JZRUzB7VrLFZpR5RnkaiCNsQk+O4Rt42xDDUyXGrN74hfFKKnVWCQvA05IJCPvsxHSzq
 ZGXnweFVq0Pw2ILFvC5W77nanPGkPfON8gq5QkVJmYfXeQcKTYWA31DheTvatjT+3MmwvWxGo
 gQ2QH/wuIb/lX/cSbO6QraT/oFONfPEglCT7wwuJWsUk9tARfwQ6TcuWAbziJNMjNmYzb7m6Z
 5gbbYYc6m0maoMz2zfYN8jKrMr368gxNs2ifVmNf31KZ+mIuqihuNNvFzJBq880VXPMT97Jbv
 DDuH/gOcsGO6rzI7OxUNJ8CJ3x8KIHounU70aTtkubt56Me354ZcxhNfcqxV+bTqqrpfk8Stq
 Kz1oPz23yObOcveIjxPj0EAfrQdPDAh3FKAeBx4X9he5ZLT/R+aLSEr+hrOF/IxEFZgAG6UXN
 n0VnPpyu0AhuUzP0gc1gdPSg==
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

first thanks for the really fast and detailed answer.

> Gesendet: Freitag, 20. Januar 2023 um 18:21 Uhr
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
> Hi Frank,
>
> On Fri, Jan 20, 2023 at 05:45:35PM +0100, Frank Wunderlich wrote:
> > Hi,
> >
> > noticed a bug while testing systemd, but it is reproducable with iprou=
te2
> >
> > tested on bananapi-r2 with kernel 5.15.80 and bananapi-r3 with kernel =
6.2-rc1,
> > both use mt7530 dsa driver but different configs (mt7530 vs. mt7531).
> > have no other devices to test.
> >
> > first create vlan on wan-port (wan and lan0 are dsa-user-ports on same=
 gmac)
> >
> > netif=3Dwan
> > ip link set $netif up
> > ip link add link $netif name vlan110 type vlan id 110
> > ip link set vlan110 up
> > ip addr add 192.168.110.1/24 dev vlan110
> >
> > vlan works now, other side pingable, vlan-tagged packets visible in tc=
pdump on both sides
>
> VLAN 110 is a software VLAN, it is never committed to hardware in the
> switch.
>
> > now create the vlan-sware bridge (without vlan_filtering it works in m=
y test)
> >
> > BRIDGE=3Dlanbr0
> > ip link add name ${BRIDGE} type bridge vlan_filtering 1 vlan_default_p=
vid 1
> > ip link set ${BRIDGE} up
> > ip link set lan0 master ${BRIDGE}
> > ip link set lan0 up
> >
> > takes some time before it is applied and ping got lost
> >
> > packets are received by other end but without vlan-tag
>
> What happens in mt7530_port_vlan_filtering() is that the user port (lan0=
)
> *and* the CPU port become VLAN aware. I guess it is the change on the
> CPU port that affects the traffic to "wan".

interesting, and funny to see that vlan_aware on gmac is added, but not re=
moved in else branch :p

> But I don't see yet why this
> affects the traffic in the way you mention (the CPU port strips the tag
> instead of dropping packets with VLAN 110).

i find it strange that packets will find the way to my laptop (maybe becau=
se mac was cached from tests without the bridge and mac is same for mac an=
d vlan there). Have not verified packets are ok, only grepped output of tc=
pdump for the vlan-ip as tcpdump with vlan-option does not show anything w=
ith bridge.

have posted the dumps in systemd-issue as i thought it is a systemd proble=
m.

https://github.com/systemd/systemd/issues/25970

> I have 2 random things to suggest you try.
>
> First is this
>
> From 2991f704e6f341bd81296e91fbb4381f528f8c7f Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Fri, 20 Jan 2023 19:17:16 +0200
> Subject: [PATCH] mt7530 don't make the CPU port a VLAN user port
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/mt7530.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 616b21c90d05..7265c120c767 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1524,7 +1524,7 @@ mt7530_port_vlan_filtering(struct dsa_switch *ds, =
int port, bool vlan_filtering,
>  		 * for becoming a VLAN-aware port.
>  		 */
>  		mt7530_port_set_vlan_aware(ds, port);
> -		mt7530_port_set_vlan_aware(ds, cpu_dp->index);
> +//		mt7530_port_set_vlan_aware(ds, cpu_dp->index);
>  	} else {
>  		mt7530_port_set_vlan_unaware(ds, port);
>  	}
>
> If this works, I expect it will break VLAN tagged traffic over lan0 now =
:)
> So I would then like you to remove the first patch and try the next one

tried first patch, and wan stays working, now i try to figure out how i ca=
n access the vlan in the bridge to set ip-address..

ip link del vlan110 #delete vlan-interface from wan to have clean routing
bridge vlan add vid 110 dev lan0
bridge vlan add vid 110 dev lanbr0 self

how can i now set ip-address to the vlan110 (imho need to extract the vlan=
 as separate netdev) for testing that lan0 still works?

regards Frank
