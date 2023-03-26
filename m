Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6E46C9748
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 19:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjCZRtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 13:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCZRte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 13:49:34 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A819A44A7
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1679852967; i=frank-w@public-files.de;
        bh=fmRqx/aHBpxSPSll07gmzufHtWDWb9QPF2e7HiI51fw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=kIT/aGDC4eKyl0fqVJR8N2p0+NsBIfN5oJIVpv2w2pAabGzXgtJDEYqgHhD0pouJg
         DA8GFTr0CCMeK68H7MdalDIczFBWRZ5JeyRtPX4cFX4H7VfT81yREhod0v8rMZhLX+
         B0VkyGAbe6unM6SiaZkGYZvjCLW0yMdXmSFfBNB9dMXKBz6UGKX39kc8HLvOS+yOU7
         1MltdsKxXjxn9onLu8YDteooA/WkV639xKQYwxKV2d9ybLqX+qN7vrUxFDu+zmlWuZ
         KbUX/nd7M549mKOhous0Pjm/g+bmavBrBLw5K/HwiOWisgqfnwBuEalA6U82Bwoylp
         r8UmmALvkTNUQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [80.245.78.73] ([80.245.78.73]) by web-mail.gmx.net
 (3c-app-gmx-bap64.server.lan [172.19.172.134]) (via HTTP); Sun, 26 Mar 2023
 19:49:26 +0200
MIME-Version: 1.0
Message-ID: <trinity-6b2ecbe5-7ad8-4740-b691-8b9868fae223-1679852966887@3c-app-gmx-bap64>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
Subject: Aw: Re:  Re: [PATCH net] net: ethernet: mtk_eth_soc: fix tx
 throughput regression with direct 1G links
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 26 Mar 2023 19:49:26 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <4a67ee73-f4ee-2099-1b5b-8d6b74acf429@nbd.name>
References: <20230324140404.95745-1-nbd@nbd.name>
 <trinity-84b79570-2de7-496a-870e-a9678a55f4a4-1679736481816@3c-app-gmx-bap48>
 <2e7464a7-a020-f270-4bc7-c8ef47188dcd@nbd.name>
 <trinity-30bf2ced-ef19-4ce1-9738-07015a93dede-1679850603745@3c-app-gmx-bap64>
 <4a67ee73-f4ee-2099-1b5b-8d6b74acf429@nbd.name>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:6jgXRk2Q2ZQE4mThz9N1PjzzQgqB/tBaf9mifKHCcawxoPYqs5HPnjd3wFdQG4M+2VAlB
 3ykJ+dNc+1RH1di79o/Y1mjhFerR/3SO53WjeLFKkfejEisGustvo2Weot8Imn1Hh73P1Pf22lZx
 cUKWBED3KNym/qsX+LvcBUVhv83P05RXZajylLQCl8DLSKeO1ZRVfVZ9KTc9hpOCqArHQiIKZhVO
 RXFRvYLa7QQxspD2vaMRdgxBSKkErd3D0q5ZEF6QT/v8kfXCk6z0owRPBDTikGPNNChhAc/ikp2L
 CY=
UI-OutboundReport: notjunk:1;M01:P0:u3PmI7sSDSU=;RNyIIZJzhGnqPB600TZKv1lLAvy
 SwpK3nBky9QlKlIYpcsseTaE8CdtybKRO0iEo7Fegrh+mfyfLYFixfqF3Qi+oZrsq5PCyIjdB
 BhSZUKSrvQtZA57SSkvGj0nOijB5ozqNHPCIxMzEfL+PNpSIVVfpKjPNCIl0Hkxcc3WSUWCz0
 7dHXzSH3dw0YFGVYIDMJF///YZAX1UYM5vFKyeNbJf219SFdjgEH+GNYnNYRnY9+N/MpWqIFN
 L6XhLYhC9sRzWq9xKYc/wNJkYTU1a9ZF8ZBetDBaxxW6iVWk7fZLnmFFVYFgsOgioz4kHKeL6
 ZQnEB2i7hJA+B3LcTWwelJ7UfWONd1+5DT/SKebeJNRMwaNCyZfM6tLiJkLtwY7ZmneYWAw0F
 7F5qBY2/P5elnggQfbvzMRZ7t6I5DKmcGwGdoFdTnH+JoxjTjTyFHlktfPSUL+6MddQGVJnzv
 bhqMN+89WaPXwKzR3Gw9OjD81BSDCCfj74iebV/wlnsCOFKcNQxxD/qULeAhNYthT5t9BdUxR
 gNGccDBus8LdPzpWrLXWKgtCimF/oQgiHKvbMjw4Efh+8SuVOdRUqgbgF80oQKC9c96tNAW1k
 Ec4AxwRfXw3zcFmTecgET86IdK+hHTmY69BvbxPWEUlDWwXQnN/DxN7WJw1LGUgDCNGp6ilGZ
 fvpFwFd4c+t5eWhe502R3gcFKzW/6rqbPVCol6go8k0anWkmsiyjgf7SwVDJYN9xsdCy1C0/V
 7C1KKzCcg5c6JSzvmDyMSUmHksxdNm/bNXkTpmrk9gnv/9DkckSAT1V+gHCnhRllfwDBvhBRL
 mEIMdqd+ZHDwNYhs62YXUf/p9pSfCPL2rrVLkav/+QBBw=
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Sonntag, 26=2E M=C3=A4rz 2023 um 19:27 Uhr
> Von: "Felix Fietkau" <nbd@nbd=2Ename>
> An: "Frank Wunderlich" <frank-w@public-files=2Ede>
> Cc: netdev@vger=2Ekernel=2Eorg, "Daniel Golle" <daniel@makrotopia=2Eorg>
> Betreff: Re: Aw: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix tx thro=
ughput regression with direct 1G links
>
> On 26=2E03=2E23 19:10, Frank Wunderlich wrote:
> >> Gesendet: Sonntag, 26=2E M=C3=A4rz 2023 um 17:56 Uhr
> >> Von: "Felix Fietkau" <nbd@nbd=2Ename>
> >> An: "Frank Wunderlich" <frank-w@public-files=2Ede>
> >> Cc: netdev@vger=2Ekernel=2Eorg, "Daniel Golle" <daniel@makrotopia=2Eo=
rg>
> >> Betreff: Re: Aw: [PATCH net] net: ethernet: mtk_eth_soc: fix tx throu=
ghput regression with direct 1G links
> >>
> >> On 25=2E03=2E23 10:28, Frank Wunderlich wrote:
> >> >> Gesendet: Freitag, 24=2E M=C3=A4rz 2023 um 15:04 Uhr
> >> >> Von: "Felix Fietkau" <nbd@nbd=2Ename>
> >> >> An: netdev@vger=2Ekernel=2Eorg
> >> >> Cc: "Frank Wunderlich" <frank-w@public-files=2Ede>, "Daniel Golle"=
 <daniel@makrotopia=2Eorg>
> >> >> Betreff: [PATCH net] net: ethernet: mtk_eth_soc: fix tx throughput=
 regression with direct 1G links
> >> >>
> >> >> Using the QDMA tx scheduler to throttle tx to line speed works fin=
e for
> >> >> switch ports, but apparently caused a regression on non-switch por=
ts=2E
> >> >>=20
> >> >> Based on a number of tests, it seems that this throttling can be s=
afely
> >> >> dropped without re-introducing the issues on switch ports that the
> >> >> tx scheduling changes resolved=2E
> >> >>=20
> >> >> Link: https://lore=2Ekernel=2Eorg/netdev/trinity-92c3826f-c2c8-40a=
f-8339-bc6d0d3ffea4-1678213958520@3c-app-gmx-bs16/
> >> >> Fixes: f63959c7eec3 ("net: ethernet: mtk_eth_soc: implement multi-=
queue support for per-port queues")
> >> >> Reported-by: Frank Wunderlich <frank-w@public-files=2Ede>
> >> >> Reported-by: Daniel Golle <daniel@makrotopia=2Eorg>
> >> >> Tested-by: Daniel Golle <daniel@makrotopia=2Eorg>
> >> >> Signed-off-by: Felix Fietkau <nbd@nbd=2Ename>
> >> >> ---
> >> >>  drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec | 2 --
> >> >>  1 file changed, 2 deletions(-)
> >> >>=20
> >> >> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec b/drive=
rs/net/ethernet/mediatek/mtk_eth_soc=2Ec
> >> >> index a94aa08515af=2E=2E282f9435d5ff 100644
> >> >> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec
> >> >> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec
> >> >> @@ -763,8 +763,6 @@ static void mtk_mac_link_up(struct phylink_con=
fig *config,
> >> >>  		break;
> >> >>  	}
> >> >> =20
> >> >> -	mtk_set_queue_speed(mac->hw, mac->id, speed);
> >> >> -
> >> >>  	/* Configure duplex */
> >> >>  	if (duplex =3D=3D DUPLEX_FULL)
> >> >>  		mcr |=3D MAC_MCR_FORCE_DPX;
> >> >=20
> >> > thx for the fix, as daniel already checked it on mt7986/bpi-r3 i te=
sted bpi-r2/mt7623
> >> >=20
> >> > but unfortunately it does not fix issue on bpi-r2 where the gmac0/m=
t7530 part is affected=2E
> >> >=20
> >> > maybe it needs a special handling like you do for mt7621? maybe it =
is because the trgmii mode used on this path?
> >> Could you please test if making it use the MT7621 codepath brings bac=
k=20
> >> performance? I don't have any MT7623 hardware for testing right now=
=2E
> >=20
> > Hi,
> >=20
> > this seems to make the CPU stall (after kernel is loaded completely wh=
en userspace begins to start):
> >=20
> > -       if (IS_ENABLED(CONFIG_SOC_MT7621)) {
> > +       if (IS_ENABLED(CONFIG_SOC_MT7621) || IS_ENABLED(CONFIG_SOC_MT7=
623)) {
> >=20
> > [   27=2E252672] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> > [   27=2E258618] rcu:     2-=2E=2E=2E0: (0 ticks this GP) idle=3D54c4/=
1/0x40000000 softir8
> > [   27=2E266973] rcu:     (detected by 1, t=3D2102 jiffies, g=3D-891, =
q=3D7 ncpus=3D4)
> > [   27=2E273499] Sending NMI from CPU 1 to CPUs 2:
> >                                                                       =
          =20
> > [USBD] USB PRB0 LineState: 0
> >=20
> > wonder why this happens=2E=2E=2Ei expected some kind of tranmit queue =
erros with trace=2E=2E=2E
> >=20
> > full log here
> > https://pastebin=2Ecom/de4dZDt4
> >=20
> > but i've found no error there (sorry for cutting on the right side=2E=
=2E=2Emy terminal window was to small)
> The change you made has no effect, because CONFIG_SOC_MT7623 does not=20
> exist, so there must be something else that broke your system=2E
> Try CONFIG_MACH_MT7623 instead, once you've resolved the system hang=2E

it was exactly this change above=2E=2E=2Edropping it fixed it

do not know why i did no compile-error, looked into implementation of IS_E=
NABLED which is passed through different defines till

include/linux/kconfig=2Eh:42:#define ___is_defined(val)		____is_defined(__=
ARG_PLACEHOLDER_##val)
include/linux/kconfig=2Eh:43:#define ____is_defined(arg1_or_junk)	__take_s=
econd_arg(arg1_or_junk 1, 0)
include/linux/kconfig=2Eh:14:#define __take_second_arg(__ignored, val, =2E=
=2E=2E) val

i do not expect that there is anything wrong, just wonder why this stalls=
=2E=2E=2E

used the CONFIG_MACH_MT7623 (which is set in my config) boots up fine, but=
 did not fix the 622Mbit-tx-issue

and i'm not sure i have tested it before=2E=2E=2Eall ports of mt7531 are a=
ffected, not only wan (i remembered you asked for this)

regards Frank
