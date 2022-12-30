Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF65A659911
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 14:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiL3N4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 08:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiL3N4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 08:56:43 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F99D26CD;
        Fri, 30 Dec 2022 05:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1672408566;
        bh=aJs5BUPNCDMpSf5qs/KCbFidrml10nfqVwtWIQ1rkgA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=t7JJNRwE+tvA2uQhm6nQ3NoCh3BMFOa5hSffsqFfwjDmcw1TVzMlq1SK/s+ZzvPN/
         lau/r8cws10FpD404hAslLQfAE+wmZ09CkKrIX7jb9HHLv3vp9SGHUH6nLDX1yBhY+
         XkZz1Szojzh6jK4XbC37Z8sf+4v8o7ZSH5MDpDoh83uaGVcbfsW6a1RB3jIAdCT3Uf
         ArTj0M6xRDv+FTgGGYj2BD3ayWHtrpjtAeQOdiCO/UC5yYPBC31ibpn7+oryrQEHBR
         a7kb71cRHjBRvZUkOosslfLKo3ciuKuqj/cFfbCOO5qzJqzaLS0umHHqM+6Q+nKOs8
         QHtc+aM3Kdl/Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.149.221] ([217.61.149.221]) by web-mail.gmx.net
 (3c-app-gmx-bap18.server.lan [172.19.172.88]) (via HTTP); Fri, 30 Dec 2022
 14:56:05 +0100
MIME-Version: 1.0
Message-ID: <trinity-ace28b50-2929-4af3-9dd2-765f848c4d99-1672408565903@3c-app-gmx-bap18>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Aw: Re:  [PATCH net v3 4/5] net: ethernet: mtk_eth_soc: drop
 generic vlan rx offload, only use DSA untagging
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 30 Dec 2022 14:56:05 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <82821d48-9259-9508-cc80-fc07f4d3ba14@nbd.name>
References: <20221230073145.53386-1-nbd@nbd.name>
 <20221230073145.53386-4-nbd@nbd.name>
 <trinity-a07d48f4-11cf-4a24-a797-03ad4b1150d9-1672400818371@3c-app-gmx-bap18>
 <82821d48-9259-9508-cc80-fc07f4d3ba14@nbd.name>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:VSKB0aOJvZj8WdlVQ/Wv7OV7QRJhYJiAqgbU2cJ8DqrrxhDAC/S0+uOdetEOp3ccvsqxM
 O1B+0MTl6JL1iPVk/wjn9/MB3Tir1jyVbd+xCIc0jpaEhxPuYfcAovrYl4KOPNC9Yq8ShNocvqgJ
 2IxvbA4rjuzYF3JIgIf0AXHvNXIPILqlg9uMUVYxW8InNAXZfjBZ/ikwjVlkOeSm1+LDB8LDmwny
 /Mo1ZoxAoNiOM1LQhgKlBIrnXEv0lFMMLVOWwaGOT7xTse0CU4i9RFzXeUW+2bcaCR5+RyZSYSES
 Ik=
UI-OutboundReport: notjunk:1;M01:P0:1bHAsnDX4ZQ=;d+eI2zwbQuOswYD5KZeTrQQ1AzI
 lFRKSgoaurWFBry3jR6s1YdA0L9Fa7mCdBRVSBw4iP9MiUu7VHxOYoLplArlXf3aMX0/olaFH
 KqvGaQ+LIxFUzFJ77HLXQhV1lZV/ZD43m9G10AGPyd+lARxS3IdAC35m7VqWsWErcs+NuOzwq
 sUEioiVmJ9/eqVzGeMnzCPAn3mQ2CXErPNEpKLPtMZWyVAZ8GA+Qa7gY8C0IskNquHE38ujVz
 CtOrW5+ZtF7aBpmdeVMlEHvurpUprvVBRP7z2PRHM24k/lHDDgyqZfsAU7wsCtLM/1WFUvSgQ
 etnwyMKAchYAgHcFPX7nxq+uSYNiX+KR3UGZCmMjjTiRSuWBtsviv/+N+1kNp16534jdsmMAa
 fEQRaINVFz1Os39shJTy6VLzvnjdSAPX7vXmJrelPjzNSzLkpVr4gG8kc95o1kzhE3Gudzk1C
 exAjqqLqTA38W04UDwFiH6j96P1etcTdw4RvVO5c+kW8Bh02rhtf1s65WDSpFYe5IkOmwifwC
 Bec5T47LsofEYSC8xcIeD6YOc8H3F4DbEl+ARmV+zk1DoKErEBj5gIHfsHsT5TbWA2WSI5HlQ
 1AoMWb4W5qTUCmr3JPfUezIaVKH6dI2KDx5akRLjq5hTlyCp2JeCQJ9dYBwu2taY+ChQLfD7M
 XAtkYrH30D6xtl6Qvlf7B85BLkDxSLG/9HQwoQTu2EZwMR4mmbUiSE+lQWkKKBOFPzc20WwII
 gTWS6kv5doWBCpy+qwFf4lxf43qwdnaroRoDJuczm4RyMSsxBSnNXAdFSsDaQOkFaZnVuU/9/
 rwcWtEEy7cWt2pJncw2rszMA==
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

thanks for fast response

> Gesendet: Freitag, 30. Dezember 2022 um 13:56 Uhr
> Von: "Felix Fietkau" <nbd@nbd.name>
> An: "Frank Wunderlich" <frank-w@public-files.de>
> Cc: netdev@vger.kernel.org, "John Crispin" <john@phrozen.org>, "Sean Wan=
g" <sean.wang@mediatek.com>, "Mark Lee" <Mark-MC.Lee@mediatek.com>, "Loren=
zo Bianconi" <lorenzo@kernel.org>, "David S. Miller" <davem@davemloft.net>=
, "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>=
, "Paolo Abeni" <pabeni@redhat.com>, "Matthias Brugger" <matthias.bgg@gmai=
l.com>, "Russell King" <linux@armlinux.org.uk>, linux-arm-kernel@lists.inf=
radead.org, linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.o=
rg
> Betreff: Re: Aw: [PATCH net v3 4/5] net: ethernet: mtk_eth_soc: drop gen=
eric vlan rx offload, only use DSA untagging
>
> On 30.12.22 12:46, Frank Wunderlich wrote:
> > Hi,
> >
> > v2 or v3 seems to break vlan on mt7986 over eth0 (mt7531 switch). v1 w=
as working on next from end of November. But my rebased tree with v1 on 6.=
2-rc1 has same issue, so something after next 2711 was added which break v=
lan over mt7531.
> >
> > Directly over eth1 it works (was not working before).
> >
> > if i made no mistake there is still something wrong.
> >
> > btw. mt7622/r64 can also use second gmac (over vlan aware bridge with =
aux-port of switch to wan-port) it is only not default in mainline. But ma=
ybe this should not be used as decision for dropping "dsa-tag" (wrongly vl=
an-tag).
> >
> > regards Frank
> Thanks for reporting.
> Please try this patch on top of the series:
> ---
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -3218,10 +3218,8 @@ static int mtk_open(struct net_device *dev)
>   	phylink_start(mac->phylink);
>   	netif_tx_start_all_queues(dev);
>
> -	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
> -		return 0;
> -
> -	if (mtk_uses_dsa(dev) && !eth->prog) {
> +	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2) &&
> +	    mtk_uses_dsa(dev) && !eth->prog) {
>   		for (i =3D 0; i < ARRAY_SIZE(eth->dsa_meta); i++) {
>   			struct metadata_dst *md_dst =3D eth->dsa_meta[i];
>
> @@ -3244,10 +3242,6 @@ static int mtk_open(struct net_device *dev)
>   		val &=3D ~MTK_CDMP_STAG_EN;
>   		mtk_w32(eth, val, MTK_CDMP_IG_CTRL);
>
> -		val =3D mtk_r32(eth, MTK_CDMQ_IG_CTRL);
> -		val &=3D ~MTK_CDMQ_STAG_EN;
> -		mtk_w32(eth, val, MTK_CDMQ_IG_CTRL);
> -
>   		mtk_w32(eth, 0, MTK_CDMP_EG_CTRL);
>   	}
>
>
>

seems not helping...this is how i test it:

ip link set eth1 up
ip link add link eth1 name vlan500 type vlan id 500
ip link add link wan name vlan600 type vlan id 600
ip addr add 192.168.50.1/24 dev vlan500
ip addr add 192.168.60.1/24 dev vlan600
ip link set vlan500 up
ip link set wan up
ip link set vlan600 up

#do this on the other side:
#netif=3Denp3s0
#sudo ip link add link $netif name vlan500 type vlan id 500
#sudo ip link add link $netif name vlan600 type vlan id 600
#sudo ip link set vlan500 up
#sudo ip link set vlan600 up
#sudo ip addr add 192.168.50.2/24 dev vlan500
#sudo ip addr add 192.168.60.2/24 dev vlan600

verified all used ports on my switch are in trunk-mode with vlan-membershi=
p of these 2 vlan.



booted 6.1 and there is vlan on dsa-port broken too, so either my test-set=
up is broken or code...but wonder why 6.1 is broken too...

with tcp-dump on my laptop i see that some packets came in for both vlan, =
but they seem not valid, arp only for vlan 500 (eth1 on r3).

$ sudo tcpdump -i enp3s0 -nn -e  vlan
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on enp3s0, link-type EN10MB (Ethernet), snapshot length 262144 b=
ytes
14:49:09.548909 e4:b9:7a:f7:c4:8b > 33:33:00:00:83:84, ethertype 802.1Q (0=
x8100), length 524: vlan 500, p 0, ethertype IPv6 (0x86dd), fe80::e6b9:7af=
f:fef7:c48b.34177 > ff12::8384.21027: UDP, length 458
14:49:09.548929 e4:b9:7a:f7:c4:8b > 33:33:00:00:83:84, ethertype 802.1Q (0=
x8100), length 524: vlan 600, p 0, ethertype IPv6 (0x86dd), fe80::e6b9:7af=
f:fef7:c48b.34177 > ff12::8384.21027: UDP, length 458
14:49:09.549470 e4:b9:7a:f7:c4:8b > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0=
x8100), length 504: vlan 500, p 0, ethertype IPv4 (0x0800), 192.168.50.2.3=
3050 > 192.168.50.255.21027: UDP, length 458
14:49:09.549522 e4:b9:7a:f7:c4:8b > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0=
x8100), length 504: vlan 600, p 0, ethertype IPv4 (0x0800), 192.168.60.2.3=
3050 > 192.168.60.255.21027: UDP, length 458
14:49:26.324503 92:65:f3:ec:b0:19 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0=
x8100), length 60: vlan 500, p 0, ethertype ARP (0x0806), Request who-has =
192.168.50.2 tell 192.168.50.1, length 42
14:49:26.324525 e4:b9:7a:f7:c4:8b > 92:65:f3:ec:b0:19, ethertype 802.1Q (0=
x8100), length 46: vlan 500, p 0, ethertype ARP (0x0806), Reply 192.168.50=
.2 is-at e4:b9:7a:f7:c4:8b, length 28
14:49:26.325091 92:65:f3:ec:b0:19 > e4:b9:7a:f7:c4:8b, ethertype 802.1Q (0=
x8100), length 102: vlan 500, p 0, ethertype IPv4 (0x0800), 192.168.50.1 >=
 192.168.50.2: ICMP echo request, id 44246, seq 1, length 64
14:49:26.325158 e4:b9:7a:f7:c4:8b > 92:65:f3:ec:b0:19, ethertype 802.1Q (0=
x8100), length 102: vlan 500, p 0, ethertype IPv4 (0x0800), 192.168.50.2 >=
 192.168.50.1: ICMP echo reply, id 44246, seq 1, length 64

on r3 i see these packets going out (so far it looks good):

root@bpi-r3:~# ping 192.168.60.2
PING 192.168.60.2 (192.168.60.2) 56(84) bytes of data.
13:30:29.782003 08:22:33:44:55:77 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0=
x8100), length 46: vlan 600, p 0, ethertype ARP (0x0806),
 Request who-has 192.168.60.2 tell 192.168.60.1, length 28
13:30:30.788175 08:22:33:44:55:77 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0=
x8100), length 46: vlan 600, p 0, ethertype ARP (0x0806),
 Request who-has 192.168.60.2 tell 192.168.60.1, length 28
13:30:31.828181 08:22:33:44:55:77 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0=
x8100), length 46: vlan 600, p 0, ethertype ARP (0x0806),
 Request who-has 192.168.60.2 tell 192.168.60.1, length 28
=46rom 192.168.60.1 icmp_seq=3D1 Destination Host Unreachable
13:30:32.868205 08:22:33:44:55:77 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0=
x8100), length 46: vlan 600, p 0, ethertype ARP (0x0806),
 Request who-has 192.168.60.2 tell 192.168.60.1, length 28
13:30:33.908171 08:22:33:44:55:77 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0=
x8100), length 46: vlan 600, p 0, ethertype ARP (0x0806),
 Request who-has 192.168.60.2 tell 192.168.60.1, length 28

HTH, maybe daniel or anyone other can confirm this

regards Frank

