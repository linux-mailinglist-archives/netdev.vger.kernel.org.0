Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEADC6C971D
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 19:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCZRKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 13:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCZRKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 13:10:09 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B909729D
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 10:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1679850603; i=frank-w@public-files.de;
        bh=j/v297AGQXLFScntmdMhOjj46ggLYZEfJmV2thw44UY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=tanA+CVPTO3x/Lpe9ik/krl6uFohoV8YTMWYjs2VdycFa2LEjLtnqIaFsrwxQJ3Ea
         8+d5MPVRmTKh8tULRz5J2+Odp+WpCXxLuj9jCZjV/8iF45nV+7eKyqAhYcV77WIuAc
         Asn7i1c7mzOFDmzwqodBbqEy8wYNjZrIERB6CwA2nUkoprkNkSOCPiC+wpUQCFD4Kn
         XxJf6CZmTWIgMJL9/Z29ts2J0WchUVh0oJWzTnJVentQVC5iIqyoGnfmAFoHETttnV
         G/3A61cneVV/Hmy9DFfE4qUmr6BXcTXvd1sCndgQ0njCnRF1hqFSCLqg+IPLmWvl4s
         RIH9wVOFIlo9Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [80.245.78.73] ([80.245.78.73]) by web-mail.gmx.net
 (3c-app-gmx-bap64.server.lan [172.19.172.134]) (via HTTP); Sun, 26 Mar 2023
 19:10:03 +0200
MIME-Version: 1.0
Message-ID: <trinity-30bf2ced-ef19-4ce1-9738-07015a93dede-1679850603745@3c-app-gmx-bap64>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
Subject: Aw: Re:  [PATCH net] net: ethernet: mtk_eth_soc: fix tx throughput
 regression with direct 1G links
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 26 Mar 2023 19:10:03 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <2e7464a7-a020-f270-4bc7-c8ef47188dcd@nbd.name>
References: <20230324140404.95745-1-nbd@nbd.name>
 <trinity-84b79570-2de7-496a-870e-a9678a55f4a4-1679736481816@3c-app-gmx-bap48>
 <2e7464a7-a020-f270-4bc7-c8ef47188dcd@nbd.name>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:rbSICYLPJ69h30kT7hArBtDMVKrH0zGw59MAkw6pe+OvWxAEtO7KtWFdbyjQZiifl5H1G
 X7DKhopF0HmAQ6J2Ys7ukbiv+EAEWDmnJwN4klafkjh+AVZDOeZ956aaWM27c+0nPcqurM2cuuiN
 58Tj30w5T1C/A1ScKNRKlbHLzD+wQ9QIM9OsLXy7nyTS2gJOjPJJ7SP0JXAvDhm36Q27tRjd9gW3
 96U7iYSVbW70/5ZRzQJ58VXOd7py9vu2RlqeaENoUkr0Lk2wZCnpdlxlMmtGQlqDw9aE9bpKplCh
 gQ=
UI-OutboundReport: notjunk:1;M01:P0:geEcyOpNdSE=;jyMvdTXniRdyvn3dd/fT5ookhwP
 c0yIL+Zo6ZkOrFpKdRrca5qYMS3ihRchsIJUhvFZvrjrYASAsW7GWZ0lRWwA0BM6R7ZUxSsYH
 ODvEahza+o5fMjNjcUenmKwxZsp/5UNUG4lCZGm3Rj9RJalH5Ph4kngFVg4DyPMdZ8ypYKzYZ
 FaX/f/Nf/JAb8c+5TBuCf2XrRmgfyVgEcJpVhUA6gldDLxspN3XAL+ZHLkjBZUh8zGBgvPX2m
 P5eCXxm3Ss7bElaoHbyJIJKWlP66CMNgx4MgrFVho1Pl+7yaU1VmImr7sju1X1TtrCsuNBlWq
 49sNkA4fnH0xTegkCitooilsjHKKCCVc7CEZtwAzdRDJu8OsTRrk+sRU2xrTsIKZdx5d3jtDf
 SbaoY2Tno5VL0vrge+FrXX6oubspp8mexNtRzAmfF8xbn71Eoz/5bHZzsvy7X4JRP7B/WES/+
 D9oVzKS56zUhR0NXbj6p3xz5ECnwpveDfUEmqukry+dLR4UjAIN7WIieXe5hOJ76g2z3aOqcu
 6kdRk8YUgTUODJcZ4+IUrgLxVNptF4nOKIUGePGbW5nxuK2WdeUAQJ0zpmp77XK3fSSNlzLPv
 nf6eK07sCk//BCY1sEEfZJn6lxsoInBWMCG8OllqW6CCs/vmuNJ40fjH4eQcCi+2pIenP31wK
 Mt6lDq6qGTyKzEyf1bc9Iz+h/vLOQg+QvmY3AJVZUuCfnkHb8uFPjsnOKN5aKEvw0AVWwxZhb
 J6i8qJEhQnP5Np98CYBU0LGoi5AvAasVhnDfDnXVi4+MEH9hVIj7v5fZlQAZxr/NHU8ZYAYaI
 ZXwK91w7pYxwyejOncgvOSiA==
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Sonntag, 26=2E M=C3=A4rz 2023 um 17:56 Uhr
> Von: "Felix Fietkau" <nbd@nbd=2Ename>
> An: "Frank Wunderlich" <frank-w@public-files=2Ede>
> Cc: netdev@vger=2Ekernel=2Eorg, "Daniel Golle" <daniel@makrotopia=2Eorg>
> Betreff: Re: Aw: [PATCH net] net: ethernet: mtk_eth_soc: fix tx throughp=
ut regression with direct 1G links
>
> On 25=2E03=2E23 10:28, Frank Wunderlich wrote:
> >> Gesendet: Freitag, 24=2E M=C3=A4rz 2023 um 15:04 Uhr
> >> Von: "Felix Fietkau" <nbd@nbd=2Ename>
> >> An: netdev@vger=2Ekernel=2Eorg
> >> Cc: "Frank Wunderlich" <frank-w@public-files=2Ede>, "Daniel Golle" <d=
aniel@makrotopia=2Eorg>
> >> Betreff: [PATCH net] net: ethernet: mtk_eth_soc: fix tx throughput re=
gression with direct 1G links
> >>
> >> Using the QDMA tx scheduler to throttle tx to line speed works fine f=
or
> >> switch ports, but apparently caused a regression on non-switch ports=
=2E
> >>=20
> >> Based on a number of tests, it seems that this throttling can be safe=
ly
> >> dropped without re-introducing the issues on switch ports that the
> >> tx scheduling changes resolved=2E
> >>=20
> >> Link: https://lore=2Ekernel=2Eorg/netdev/trinity-92c3826f-c2c8-40af-8=
339-bc6d0d3ffea4-1678213958520@3c-app-gmx-bs16/
> >> Fixes: f63959c7eec3 ("net: ethernet: mtk_eth_soc: implement multi-que=
ue support for per-port queues")
> >> Reported-by: Frank Wunderlich <frank-w@public-files=2Ede>
> >> Reported-by: Daniel Golle <daniel@makrotopia=2Eorg>
> >> Tested-by: Daniel Golle <daniel@makrotopia=2Eorg>
> >> Signed-off-by: Felix Fietkau <nbd@nbd=2Ename>
> >> ---
> >>  drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec | 2 --
> >>  1 file changed, 2 deletions(-)
> >>=20
> >> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec b/drivers/=
net/ethernet/mediatek/mtk_eth_soc=2Ec
> >> index a94aa08515af=2E=2E282f9435d5ff 100644
> >> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec
> >> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc=2Ec
> >> @@ -763,8 +763,6 @@ static void mtk_mac_link_up(struct phylink_config=
 *config,
> >>  		break;
> >>  	}
> >> =20
> >> -	mtk_set_queue_speed(mac->hw, mac->id, speed);
> >> -
> >>  	/* Configure duplex */
> >>  	if (duplex =3D=3D DUPLEX_FULL)
> >>  		mcr |=3D MAC_MCR_FORCE_DPX;
> >=20
> > thx for the fix, as daniel already checked it on mt7986/bpi-r3 i teste=
d bpi-r2/mt7623
> >=20
> > but unfortunately it does not fix issue on bpi-r2 where the gmac0/mt75=
30 part is affected=2E
> >=20
> > maybe it needs a special handling like you do for mt7621? maybe it is =
because the trgmii mode used on this path?
> Could you please test if making it use the MT7621 codepath brings back=
=20
> performance? I don't have any MT7623 hardware for testing right now=2E

Hi,

this seems to make the CPU stall (after kernel is loaded completely when u=
serspace begins to start):

-       if (IS_ENABLED(CONFIG_SOC_MT7621)) {
+       if (IS_ENABLED(CONFIG_SOC_MT7621) || IS_ENABLED(CONFIG_SOC_MT7623)=
) {

[   27=2E252672] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:      =
       =20
[   27=2E258618] rcu:     2-=2E=2E=2E0: (0 ticks this GP) idle=3D54c4/1/0x=
40000000 softir8
[   27=2E266973] rcu:     (detected by 1, t=3D2102 jiffies, g=3D-891, q=3D=
7 ncpus=3D4)   =20
[   27=2E273499] Sending NMI from CPU 1 to CPUs 2:                        =
       =20
                                                                          =
     =20
[USBD] USB PRB0 LineState: 0                                              =
     =20

wonder why this happens=2E=2E=2Ei expected some kind of tranmit queue erro=
s with trace=2E=2E=2E

full log here
https://pastebin=2Ecom/de4dZDt4

but i've found no error there (sorry for cutting on the right side=2E=2E=
=2Emy terminal window was to small)

regards Frank

