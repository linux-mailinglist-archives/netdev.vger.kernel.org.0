Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA552676637
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 13:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjAUMdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 07:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjAUMdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 07:33:10 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5379465BA;
        Sat, 21 Jan 2023 04:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1674304362;
        bh=vBtVxlBQTKRdLfDfHoFiPbklR+U2cvnnBHmUhpztInY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=YnqJ8Seu+ykWRJA+ac59p+aaj2Av66jeGglWuxtCKgbodlqWgylu+r3YagsyTzHp6
         v60HE8zl+f2KPOf1pHfjAg42HeAtwBRhVQ9cWhHlM5E/zJpzUVUQgl0ANbsmB38SHR
         HRuh7QhUULQ/PKxqSQErnPZ3fZIC7KikaO9+CmwGNyy2Oc8d1cT6Oi54InyPlGgkbe
         PYNEoySHswi41seK97o9FndJJv79JnTb8tk3VwC3MCxID7s9ordc2PXdE5AHVwXxlt
         fnKpAVY8MCxsQyvrZnvwDhOrrr+YKFcjMuUo4w3afScJfwFZ5LBaVXkAMOd5xjdgc4
         yq/+Fyiw7MlXg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.152.198] ([217.61.152.198]) by web-mail.gmx.net
 (3c-app-gmx-bap60.server.lan [172.19.172.130]) (via HTTP); Sat, 21 Jan 2023
 13:32:42 +0100
MIME-Version: 1.0
Message-ID: <trinity-7c2af652-d3f8-4086-ba12-85cd18cd6a1a-1674304362789@3c-app-gmx-bap60>
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
Date:   Sat, 21 Jan 2023 13:32:42 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20230121122223.3kfcwxqtqm3b6po5@skbuf>
References: <trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36>
 <20230120172132.rfo3kf4fmkxtw4cl@skbuf>
 <trinity-b0df6ff8-cceb-4aa5-a26f-41bc04dc289c-1674303103108@3c-app-gmx-bap60>
 <20230121122223.3kfcwxqtqm3b6po5@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:AOWOCB8Mr75GGlwxuVkL2eoESjRi85AN23FMrWIwDLrwQIIx86jAdlRSEfnTQq3r3i6zo
 TUSjbpYThtSjGONxtkMeXOsJ1wLQBLCZKW2sswBqZi6ccc25bV7scoKHPz2KwP69O/coCL1QkbL1
 qmhpuafh4JFn1d0DFxMccEIZPyyHyAfECpDz8Aq7GIlfNdarxcqvovXZ23UBOHaZqEis7x6LrK+x
 S2w+yF2oMqqkXohzvfGMZqOFLENBeHnGQeqzQ5Z4EyGgEKz3JgZT4CFekagw3YjBlFkdYfQKjBOu
 kE=
UI-OutboundReport: notjunk:1;M01:P0:V7elQmlp5QU=;Bo6zAsBDpPtn0ABb8sb5fe/C81J
 SUbn0TQ0eG18/+HqKhoJ2pmfUfgVkhAl23msUNARujaiixteOO6YAreNBX1QfV6tlgnjWQ33M
 4FiZHBgNbnzle7YLPmqtBPy1PcSbykfK5Vbh1K0fpUgCnWEfEeiHv4gB6o3vJQVwZT0NG8HWJ
 e2k4RcNlYglnMZa5MgNgdoOioNTvDV7SQi8cVXKi8AdvJMq953bPvERbed5Hvlz1lWb7RTaj6
 W2D01jgLNbOuSoCXiFfcyV0TSW5LkYZ3OgM2mefUZJ0njEj4cdNqnzl7xmPI6gZ3UFLoI+D/s
 rzro4/SBr8V9DAeWazrBaYAm+pAvL+4joPYqpyN5+TevioZrG36c31ZaFppXEBnp6A5hzmyyg
 Sp2z1hA9ifgq+J90RAw6MO78o3lrApjIOZI9wHEVoh8EXUwKXCjuB8vIC+MKZop9M8Fn6KEsK
 Uv1ZhcCnxTdY51PS601T+B1p4MGgHteq//EGdvivnsBGGxkBf3tDlaXclpwM80vPZ42/BR/tU
 Esrg6G+IyEeGP9tSbjF7X6P9hDTDMwbM85oxqpq8oeYqyiHYQOOCpaOrSJetiW0ZFiFfG/NJB
 YKSh0BZJce8EYlEFyC+phvmGmeo3kK21mkNZW4ckXSYXgf/s0TATSUAbmnojQoRW0D0aOvU6d
 Uxyutb8xNJ/WRcmr+4a5wZOsLsXaIQG/vxVCdmZHcyUxTEhNqrITm24mLaZR0pdzzOv7AivYm
 pSQiYUWjFpZh7AUnuj2q44Zg31daeZoBflw8vuBgZ/EO2xPNSGBsVFyNEFQYeu1JTqSSMUhuW
 ovwESZEH4dDFMnSDMenFMfjcyl7dVHSziYEXNS1s0Wdpk=
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

> Gesendet: Samstag, 21. Januar 2023 um 13:22 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail.com>
>
> On Sat, Jan 21, 2023 at 01:11:43PM +0100, Frank Wunderlich wrote:
> > > What happens in mt7530_port_vlan_filtering() is that the user port (=
lan0)
> > > *and* the CPU port become VLAN aware. I guess it is the change on th=
e
> > > CPU port that affects the traffic to "wan".
> >
> > interesting, and funny to see that vlan_aware on gmac is added, but no=
t removed in else branch :p
>
> it is... see "if (all_user_ports_removed)" in mt7530_port_set_vlan_unawa=
re().
>
> > > If this works, I expect it will break VLAN tagged traffic over lan0 =
now :)
> > > So I would then like you to remove the first patch and try the next =
one
> >
> > tried first patch, and wan stays working, now i try to figure out how =
i can access the vlan in the bridge to set ip-address..
> >
> > ip link del vlan110 #delete vlan-interface from wan to have clean rout=
ing
> > bridge vlan add vid 110 dev lan0
> > bridge vlan add vid 110 dev lanbr0 self
> >
> > how can i now set ip-address to the vlan110 (imho need to extract the =
vlan as separate netdev) for testing that lan0 still works?
>
> ip link add link lanbr0 name lanbr0.110 type vlan id 110

thanks found it already ;)

found out how to get access to the vlan from the bridge and it is still wo=
rking

> If this works, I expect it will break VLAN tagged traffic over lan0 now =
:)
> So I would then like you to remove the first patch and try the next one

> tried first patch, and wan stays working, now i try to figure out how i =
can access the vlan in the bridge to set ip-address..

> ip link del vlan110 #delete vlan-interface from wan to have clean routin=
g
> bridge vlan add vid 110 dev lan0
> bridge vlan add vid 110 dev lanbr0 self

> how can i now set ip-address to the vlan110 (imho need to extract the vl=
an as separate netdev) for testing that lan0 still works?

root@bpi-r3:~# ip link add link lanbr0 name lanbr0.100 type vlan id 110
root@bpi-r3:~# ip a a 192.168.110.5/24 dev lanbr0.100
root@bpi-r3:~# ip link set lanbr0.100 up

did "ping" and look at the remote side

root@frank-G5:~# tcpdump -i enp3s0 -nn -e vlan
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on enp3s0, link-type EN10MB (Ethernet), snapshot length 262144 b=
ytes
13:20:39.908845 96:3f:c5:84:65:f0 > e4:b9:7a:f7:c4:8b, ethertype 802.1Q (0=
x8100), length 102: vlan 110, p 0, ethertype IPv4 (0x0800), 192.168.110.5 =
> 192.168.110.3: ICMP echo request, id 48077, seq 1, length 64
13:20:39.908878 e4:b9:7a:f7:c4:8b > 96:3f:c5:84:65:f0, ethertype 802.1Q (0=
x8100), length 102: vlan 110, p 0, ethertype IPv4 (0x0800), 192.168.110.3 =
> 192.168.110.5: ICMP echo reply, id 48077, seq 1, length 64

so first patch fixes the behaviour on bpi-r3 (mt7531)...but maybe mt7530 n=
eed the tagging on cpu-port

> Can you try the second patch instead of the first one? Without digging
> deeply into mt7530 hardware docs, that's the best chance of making
> things work without changing how the hardware operates.

second patch works for wan, but vlan on bridge is broken, no packets recei=
ving my laptop (also no untagged ones).

regards Frank
