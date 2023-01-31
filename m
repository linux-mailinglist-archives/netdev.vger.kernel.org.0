Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F3C68327C
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjAaQYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjAaQYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:24:07 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1067013538;
        Tue, 31 Jan 2023 08:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1675182218;
        bh=OSza1V6wu4Mxn3GkTiNAS0BN4mhrkESEDlrHtdOGFlg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=hqgMWBTKiLE3mNjIPv9KUcIBtm+A4si4vAsqJs8xBIiWtl40TeOtAceLr04zH6+uM
         8OFmPFfI0Tr01OQfyu61szAUvsRTAzZAvvte5UL70BLFOvv85heI97lVBR1GaRBdO3
         Khbh8c3oWO5FX0zUcyH2u/cAAsE2g3+RgQFdPcxZEU7Xz7aKmZPM+Qcf3PfO2QDL3/
         GK0vmftlb9cNsdewfT+CkI4iCCt2XAH08hu2AwiTQWd+DwMiVSY4V5b36wVruDvVz5
         Qe3AjxDMoMHGhXGCRioHmtTm4dg7gQ/YHmumyxWOvTHR+cwCE7BZOvrCASWhPggNvV
         qAt+IRMh5NmKQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.157.42] ([217.61.157.42]) by web-mail.gmx.net
 (3c-app-gmx-bs58.server.lan [172.19.170.142]) (via HTTP); Tue, 31 Jan 2023
 17:23:38 +0100
MIME-Version: 1.0
Message-ID: <trinity-4103b9e0-48e7-4de5-8757-21670a613f64-1675182218246@3c-app-gmx-bs58>
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
Date:   Tue, 31 Jan 2023 17:23:38 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20230130125813.asx5qtm6ttuwdobo@skbuf>
References: <trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36>
 <20230120172132.rfo3kf4fmkxtw4cl@skbuf>
 <trinity-b0df6ff8-cceb-4aa5-a26f-41bc04dc289c-1674303103108@3c-app-gmx-bap60>
 <20230121122223.3kfcwxqtqm3b6po5@skbuf>
 <trinity-7c2af652-d3f8-4086-ba12-85cd18cd6a1a-1674304362789@3c-app-gmx-bap60>
 <20230121133549.vibz2infg5jwupdc@skbuf>
 <trinity-cbf3ad23-15c0-4c77-828b-94c76c1785a1-1674310370120@3c-app-gmx-bap60>
 <20230130125813.asx5qtm6ttuwdobo@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:jDlGDwdxY4brUTFinZEgfRfvreK5kdhvt8U+CNpUmi1/sOwKzDS0h3gCAfDLm4RO/H4pf
 u6+Oo7m1R7QodMNKIrDtUFN6h+X/JjzXixi2+JEyE/nc57SKrw/8Bq+A05GIL3pQbO5Fte9BWUe4
 zaVfZ5keCyHgsLyqHDjzD0wEaSKkM5PB4KsfbYq/bqee6OaDO5SvUfdEtZYbAZ6GIqEFgRbLRdtC
 pVRZ+V8rjkYI4GQms4R3z3rFNxb4q2vz0sn3eOV8F09eg2+qLAaaj4PHsFddvCz2P78u4tnUe5Da
 JQ=
UI-OutboundReport: notjunk:1;M01:P0:hPTymqTVVOc=;gz/JNCnWPEWc0QK708s3GwVmKaM
 CM39SFyjWPAeATXA+dcPHKDopGyQDw7xnx1tTFRD7A/aYHGBmyD9VcT/uUzrZqB7DlhJGKJfP
 wR69aAfrtp+NAZ5d9TRZd+QlhOgUhCiqJL96mG63MMy705h3DIN5KUaTH6j4g6qJnnraos9Uo
 Si9MwSBHarZLZOkUyMRkvOKaVnSOVw3AtQ7uJpS1YDeQTX1wArQi9wjLR2vQ7P033C2aAd5XG
 S/ExVQc4ojQjjB8NbO441jTnXpPMqEe4BlCIIUMz3lUBJFp+FGdaqnyG0xYOlJ32b+lveUbJz
 Q5KEhFGA9Jhjultfw6NpczvPBxTmtX1479wXqM6hX2V58LtVPkKh7KSfxCe48Y2fjhaoPdQXW
 tXIji20mY+SmFx/x9FtiVVOaC5uMUPItCSJaag5ih09/gG8pXjqIYXnRM6QywQ2PXjiTxVUQF
 iC6TAcnaJMwPQTaGhB0kdI2PNwYXHL4gIUp8KbKNgB8V0LPcQ/8gPe8iYMrPYhhacWoMHfPIx
 Ks0bVNpyLX+t7nvIppDCGieoWJKbQtd1rm/p5BmppaoOrx90J6E/zDFF6YgZSVdmykeoQ/S3H
 u8ieDAzy/h3ILSqAI1SoEadKb994W7Zu3Q0Am0g4eJ0Ob6uLEo4IXs1OnTuCusuMJfCTuxBOl
 2Gy6MyJe3vIsy2yvc+AO1kvFcScRfNfY3oiPlzhXDLTNHTWl4CBwoIvSFAgZ8ZZeXyWuV7sNK
 ZPgrXpfUH7u3G9ZighHWFeyjHgJGlJgTaunvnku6ATD7Cfa5IJK2IZFGltk1Q3wlM5H7cnF4Y
 lRorQT+HYRGVULk5Ri/JLJyA==
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

Hi Vladimir,


> Gesendet: Montag, 30. Januar 2023 um 13:58 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail.com>
> Hi Frank,
> Sorry for the delay and thanks again for testing.
>
> I simply didn't have time to sit down with the hardware documentation
> and (re)understand the concepts governing this switch.

no problem, same here...not have every day time to dive into it :)

> I now have the patch below which should have everything working. Would
> you mind testing it?

thanks for your Patch, but unfortunately it looks like does not change beh=
aviour (have reverted all prevously applied patches,
only have felix series in).

i can ping over software-vlan on wan-port (and see tagged packets on other=
 side), till the point i setup the vlan-aware bridge over lan-ports. ping =
works some time (imho till arp-cache is cleared) and i see untagged packet=
s leaving wan-port (seen on other end) which should be tagged (wan.110).

and before anything ask: yes, i have set different mac to wan-port (and it=
s vlan-interfaces) and lanbr0

15: lanbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue sta=
te DOWN group default qlen 1000
    link/ether 96:3f:c5:84:65:f0 brd ff:ff:ff:ff:ff:ff
17: wan.140@wan: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue =
state UP group default qlen 1000
    link/ether 02:11:02:03:01:40 brd ff:ff:ff:ff:ff:ff
    inet 192.168.140.1/24 brd 192.168.140.255 scope global wan.140
       valid_lft forever preferred_lft forever
    inet6 fe80::11:2ff:fe03:140/64 scope link
       valid_lft forever preferred_lft forever
18: wan.110@wan: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue =
state UP group default qlen 1000
    link/ether 02:11:02:03:01:10 brd ff:ff:ff:ff:ff:ff
    inet 192.168.110.1/24 brd 192.168.110.255 scope global wan.110
       valid_lft forever preferred_lft forever
    inet6 fe80::11:2ff:fe03:110/64 scope link
       valid_lft forever preferred_lft forever

have not yet defined any vlans in the bridge...only set vlan_awareness...m=
aybe i need to add the wan-vlan
to the lan bridge too to pass filtering?

i'm unsure if tcpdump on the host interface should see vlan-traffic too (b=
ut do not show the vlan itself)...
in working state i see icmp in both tcpdump modes (pinging the full time w=
ithout the bridge enabled only
changed tcpdump on the other side):

# tcpdump -nni lanbr0 | grep '\.110\.'

17:13:36.071047 IP 192.168.110.1 > 192.168.110.3: ICMP echo request, id 16=
17, seq 47, length 64
17:13:36.071290 IP 192.168.110.3 > 192.168.110.1: ICMP echo reply, id 1617=
, seq 47, length 64

and

tcpdump -nni lanbr0 -e vlan | grep '\.110\.'

17:16:35.032417 02:11:02:03:01:10 > 08:02:00:00:00:10, ethertype 802.1Q (0=
x8100), length 102: vlan 110, p 0, ethertype IPv4, 192.168.110.1 > 192.168=
.110.3: ICMP echo request, id 1617, seq 219, length 64
17:16:35.032609 08:02:00:00:00:10 > 02:11:02:03:01:10, ethertype 802.1Q (0=
x8100), length 102: vlan 110, p 0, ethertype IPv4, 192.168.110.3 > 192.168=
.110.1: ICMP echo reply, id 1617, seq 219, length 64

after the vlan_aware bridge goes up i see packets in the non-vlan-mode

if needed here is my current codebase:
https://github.com/frank-w/BPI-Router-Linux/commits/6.2-rc

regards Frank
