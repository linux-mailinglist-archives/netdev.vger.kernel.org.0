Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D4C6506BC
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 04:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbiLSDRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 22:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiLSDRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 22:17:11 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41EFB7E4;
        Sun, 18 Dec 2022 19:17:08 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7C7135C0097;
        Sun, 18 Dec 2022 22:17:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 18 Dec 2022 22:17:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pjd.dev; h=cc:cc
        :content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1671419826; x=
        1671506226; bh=aA+1FqT/IEAngGATjTakkPuD0t/W3DQcklCp78h4WN4=; b=h
        7O9oQFx1qvur6wFZZO+y5WHOfz3V+QPMDm05RqeRfipVQXC8IndthKQbmaMdtZ0Y
        9/XNjdawEkR63cZJXqvwrd1dd3xILL0wsVeipkiDCxPfyvpYSO/gK8X5dtrh+vjL
        0nR2oQJo162V1U+3FV8iZEgKGsIDQw2XZ/PoUPdEAFqT/UK0Tlb7tvADqNJ/ugck
        QqimQ3e5mxSsVljcDdhxs72KB8Cmb0ghP4OcZ48dXX243wx+3UlKciqyGSoG+Jl5
        wjdVFB5NmnDOelL0dGsNIs5QkIhjoY64QKR0J6Wu2IrYDabDpPWn5zoey0ej3w0J
        bb4lfkoiQwQ4lb0kmgX6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1671419826; x=
        1671506226; bh=aA+1FqT/IEAngGATjTakkPuD0t/W3DQcklCp78h4WN4=; b=p
        a7c9+OHkuKSnQCx45UQdG3SHIBveDrmHxkpDiVpaoK5cfFRf8RBtPo5bRGYAntpL
        1gNqtddMbm0fKG0i/BxdRKE2dcY610ocHwEsZWoFVP7FJcjRoXXkcYr7NPK8HUIA
        SfxROyR4b8ahPqLG9CNKM4+r0jmqtLolKit5ZWJvgcHKMsjdG0Lkn4MCeX0/hIfE
        HCYmol80BLef6i78OimWUDhHS6hZUHuTMtvZctLRYMm8EpXCCQpbrZvap6yvGVqe
        qkGTjCEbY//9iUa2Uk4ayvFczKdwqgwqQ5j3MhhA+jc5lCSnSirljCFfrG1KMY5C
        dBh17l6m4VnmAWQwiwS+A==
X-ME-Sender: <xms:stefY5JdRztGmeG-XiTEru8ltJNRURLVCKdweABC_xH22pj205l_dA>
    <xme:stefY1IfAoIyUEC8Rzw687r-woQEukuPPBj8SjN1zuZKsU9S2zq_DTeeHwvkdC4MD
    -vZ7HzDT_urn1lzlLE>
X-ME-Received: <xmr:stefYxtaAzYWVm98ShN0sblSnlsInKz1kg6nsLovX0ToGwsaQz0RJniTyuofCY7Uutdp>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedvgdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuuhhsphgvtghtffhomhgrihhnucdlgeelmdenucfjughrpegtggfuhfgjffevgffkfhfv
    ofesthhqmhdthhdtjeenucfhrhhomheprfgvthgvrhcuffgvlhgvvhhorhihrghsuceoph
    gvthgvrhesphhjugdruggvvheqnecuggftrfgrthhtvghrnhepgfevieekudeugeevueek
    gfdtudevtdefjeejgfeugeevheelueevudefffeiheejnecuffhomhgrihhnpehtihhnhi
    hurhhlrdgtohhmpdhgihhthhhusgdrtghomhdpfhgsrdgtohhmpdhmrggtrgguughrvghs
    shdrihhonecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epphgvthgvrhesphhjugdruggvvh
X-ME-Proxy: <xmx:stefY6YLKcKGo3LDLn-NX8_fnuSW0_Wtiiv1uMAxkgsdMbEZ1JI6PQ>
    <xmx:stefYwbePHlGm_yAHWaoLlaCR7AvYsIWMbeegJMf-XvSlD95n_nkew>
    <xmx:stefY-CI0rC8bm44L9spzPFoyZixeig74YRzkvJZvI_jadPUqUDy5Q>
    <xmx:stefYw4iWupXd_YsnlDpVG-2Keq8G_TMUTA2C-drPU4CsMREwhywsQ>
Feedback-ID: i9e814621:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 18 Dec 2022 22:17:04 -0500 (EST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] net/ncsi: Always use unicast source MAC address
From:   Peter Delevoryas <peter@pjd.dev>
In-Reply-To: <CAKgT0UfOnJGf+n_PTizCyq77H+ZvWMU4i=D=GW3o13RNqWf-Gg@mail.gmail.com>
Date:   Sun, 18 Dec 2022 19:16:54 -0800
Cc:     Peter Delevoryas <peter@pjd.dev>, sam@mendozajonas.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B38CC11A-18E4-440F-8DE1-EF80C6C9A1DB@pjd.dev>
References: <20221213004754.2633429-1-peter@pjd.dev>
 <ac48b381b11c875cf36a471002658edafe04d9b9.camel@gmail.com>
 <7A3DBE8E-C13D-430D-B851-207779148A77@pjd.dev>
 <CAKgT0Uf-9XwvJJTZOD0EHby6Lr0R-tMYGiR_2og3k=d_eTBPAw@mail.gmail.com>
 <09CDE7FD-2C7D-4A0B-B085-E877472FA997@pjd.dev>
 <CAKgT0UfOnJGf+n_PTizCyq77H+ZvWMU4i=D=GW3o13RNqWf-Gg@mail.gmail.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FSL_HAS_TINYURL,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 17, 2022, at 12:57 PM, Alexander Duyck =
<alexander.duyck@gmail.com> wrote:
>=20
> On Fri, Dec 16, 2022 at 8:20 PM Peter Delevoryas <peter@pjd.dev> =
wrote:
>>=20
>>=20
>>=20
>>> On Dec 16, 2022, at 10:29 AM, Alexander Duyck =
<alexander.duyck@gmail.com> wrote:
>>>=20
>>> On Thu, Dec 15, 2022 at 5:08 PM Peter Delevoryas <peter@pjd.dev> =
wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Dec 13, 2022, at 8:41 AM, Alexander H Duyck =
<alexander.duyck@gmail.com> wrote:
>>>>>=20
>>>>> On Mon, 2022-12-12 at 16:47 -0800, Peter Delevoryas wrote:
>=20
> <...>
>=20
>>>=20
>>>>> My main
>>>>> concern would be that the dev_addr is not initialized for those =
first
>>>>> few messages so you may be leaking information.
>>>>>=20
>>>>>> This might have the effect of causing the NIC to learn 2 MAC =
addresses from
>>>>>> an NC-SI link if the BMC uses OEM Get MAC Address commands to =
change its
>>>>>> initial MAC address, but it shouldn't really matter. Who knows if =
NIC's
>>>>>> even have MAC learning enabled from the out-of-band BMC link, =
lol.
>>>>>>=20
>>>>>> [1]: https://tinyurl.com/4933mhaj
>>>>>> [2]: https://tinyurl.com/mr3tyadb
>>>>>=20
>>>>> The thing is the OpenBMC approach initializes the value themselves =
to
>>>>> broadcast[3]. As a result the two code bases are essentially doing =
the
>>>>> same thing since mac_addr is defaulted to the broadcast address =
when
>>>>> the ncsi interface is registered.
>>>>=20
>>>> That=E2=80=99s a very good point, thanks for pointing that out, I =
hadn=E2=80=99t
>>>> even noticed that!
>>>>=20
>>>> Anyways, let me know what you think of the traces I added above.
>>>> Sorry for the delay, I=E2=80=99ve just been busy with some other =
stuff,
>>>> but I do really actually care about upstreaming this (and several
>>>> other NC-SI changes I=E2=80=99ll submit after this one, which are =
unrelated
>>>> but more useful).
>>>>=20
>>>> Thanks,
>>>> Peter
>>>=20
>>> So the NC-SI spec says any value can be used for the source MAC and
>>> that broadcast "may" be used. I would say there are some debugging
>>> advantages to using broadcast that will be obvious in a packet =
trace.
>>=20
>> Ehhhhh yeah I guess, but the ethertype is what I filter for. But =
sure,
>> a broadcast source MAC is pretty unique too.
>>=20
>>> I wonder if we couldn't look at doing something like requiring
>>> broadcast or LAA if the gma_flag isn't set.
>>=20
>> What is LAA? I=E2=80=99m out of the loop
>=20
> Locally administered MAC address[4]. Basically it is a MAC address
> that is generated locally such as your random MAC address. Assuming
> the other end of the NC-SI link is using a MAC address with a vendor
> OUI there should be no risk of collisions on a point-to-point link.
> Essentially if you wanted to you could probably just generate a random
> MAC address for the NCSI protocol and then use that in place of the
> broadcast address.
>=20
>> But also: aren=E2=80=99t we already using broadcast if the gma_flag =
isn=E2=80=99t set?
>>=20
>> -       if (nca->ndp->gma_flag =3D=3D 1)
>> -               memcpy(eh->h_source, nca->ndp->ndev.dev->dev_addr, =
ETH_ALEN);
>> -       else
>> -               eth_broadcast_addr(eh->h_source);
>> +       memcpy(eh->h_source, nca->ndp->ndev.dev->dev_addr, ETH_ALEN);
>=20
> That I am not sure about. You were using this kernel without your
> patch right? With your patch it would make sense to see that behavior,
> but without I am not sure why you would see that address for any NC-SI
> commands before the gma_flag is set.
>=20
>>=20
>>> With that we could at
>>> least advertise that we don't expect this packet to be going out in =
a
>>> real network as we cannot guarantee the MAC is unique.
>>=20
>> Yeah, but it probably wouldn=E2=80=99t help my simulation scenario.
>>=20
>> I guess it sounds like this patch is not a good idea, which to be =
fair,
>> is totally reasonable.
>>=20
>> I can just add some iptables rules to tunnel these packets with a =
different
>> source MAC, or fix the multicast socket issue I was having. It=E2=80=99=
s really
>> not a big deal, and like you=E2=80=99re saying, we probably don=E2=80=99=
t want to make
>> it harder to maintain _forever_.
>=20
> Like I said before I would be good with either a Broadcast address OR
> a LAA address. The one thing we need to watch out for though is any
> sort of leak. One possible concern would be if for example you had 4
> ports using 4 different MAC addresses but one BMC. You don't want to
> accidently leak the MAC address from one port onto the other one. With
> a LAA address if it were to leak and screw up ARP tables somewhere it
> wouldn't be a big deal since it isn't expected to be switched in the
> first place.
>=20
>> I would just suggest praying for the next guy that tries to test =
NC-SI
>> stuff with QEMU and finds out NC-SI traffic gets dropped by bridges.
>> I had to resort to reading the source code and printing stuff with
>> BPF to identify this. Maybe it=E2=80=99s more obvious to other people =
this wouldn=E2=80=99t
>> work though.
>=20
> Well it seems like NC-SI isn't meant to be bridged based on the fact
> that it is using a broadcast MAC address as a source. If nothing else
> I suppose you could try to work with the standards committee on that
> to see what can be done to make the protocol more portable.. :-)

Well, I started preparing some of my other patches to send, and while
digging up the history for that, I happened to notice this commit
completely by chance while browsing Github:

=
https://github.com/facebook/openbmc-linux/commit/933b5bd024d28f48a6359e6a9=
db631f778ba9ea7

[openbmc.quanta][PR] FBAL:Fixed NCSI can't work when import BR function

Summary:
As title.
Pull Request resolved: =
https://github.com/facebookexternal/openbmc.quanta/pull/1668
GitHub Author: Peter <peter.yin@quantatw.com>

diff --git =
a/meta-aspeed/recipes-kernel/linux/files/linux-aspeed-5.0/net/bridge/br_in=
put.c =
b/meta-aspeed/recipes-kernel/linux/files/linux-aspeed-5.0/net/bridge/br_in=
put.c
index 5ea7e56119c1..8ef0b627f5ec 100644
--- =
a/meta-aspeed/recipes-kernel/linux/files/linux-aspeed-5.0/net/bridge/br_in=
put.c
+++ =
b/meta-aspeed/recipes-kernel/linux/files/linux-aspeed-5.0/net/bridge/br_in=
put.c
@@ -220,6 +220,9 @@ rx_handler_result_t br_handle_frame(struct sk_buff =
**pskb)
        if (unlikely(skb->pkt_type =3D=3D PACKET_LOOPBACK))
                return RX_HANDLER_PASS;

+       if (skb->protocol =3D=3D cpu_to_be16(ETH_P_NCSI))
+               return RX_HANDLER_PASS;
+
        if (!is_valid_ether_addr(eth_hdr(skb)->h_source))
                goto drop;

Which is accomplishing the same thing I suggested in my patch, except
that it=E2=80=99s modifying the Linux bridge code instead of changing =
the NC-SI
packets=E2=80=99 source MAC address.

To explain what I *think* this person was doing...

Meta has a system called Zion that=E2=80=99s described here:

=
https://engineering.fb.com/2019/03/14/data-center-engineering/accelerating=
-infrastructure/

It consists of two chassis, =E2=80=9CAngel's Landing=E2=80=9D and =
=E2=80=9CEmerald Pools=E2=80=9D.

Together, it=E2=80=99s kinda like an Nvidia DGX A100 system, but with =
generic
PCIe switches, and =E2=80=9COCP Accelerators=E2=80=9D. There=E2=80=99s =
like an AMD GPU or an
Intel accelerator that can fit there. Maybe an A100 can fit too? I=E2=80=99=
m
not really completely clear on how its being used compared to =
GrandTeton,
announced at OCP 2022, which is even closer to the DGX architecture,
but yeah.

Angel=E2=80=99s Landing is 4 dual-socket boards stacked together, each =
board
with a BMC and NIC supporting NC-SI. I think in practice we reduced
this to 1-2 dual-socket boards, each with 2 NIC=E2=80=99s (presumably =
cause
we don't need that many CPU's but still need the network bandwidth).

Emerald Pools is a single board and 8 accelerator modules, and
the board has a BMC on it. To get network connectivity to the BMC,
there=E2=80=99s a USB from Emerald Pools to one of the Angel=E2=80=99s =
Landing BMC's
and the Angel=E2=80=99s Landing BMC bridges Emerald Pools traffic =
through
its NIC. If this doesn=E2=80=99t make sense, I think this is the whole =
setup
(Omitting the device tree and some MAC filtering stuff):

On an Angel=E2=80=99s Landing BMC:

$ ip link add br0 type bridge
$ ip link set eth0 master br0
$ ip link set eth1 master br0
$ ip link set usb0 master br0

And on the Emerald Pools BMC, there=E2=80=99s just a usb net intf:

$ ifconfig
lo        =E2=80=A6.

usb0      Link encap:Ethernet  HWaddr xxxxxxxxxxx
          inet6 addr: xxxxxx Scope:Link
          inet6 addr: xxxxxx Scope:Global
          inet6 addr: xxxxxx Scope:Global
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:999332 errors:0 dropped:0 overruns:0 frame:0
          TX packets:594253 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:211829527 (202.0 MiB)  TX bytes:150569888 (143.5 MiB)

Anyways, so then my question was: is Zion actually relying on NC-SI
packets traversing a bridge?

The Emerald Pools BMC doesn=E2=80=99t have NC-SI enabled at all, not =
even a
userspace daemon or utility of any kind.

NC-SI *is* enabled and used on the Angel's Landing BMC, so I checked
to see if they traverse the bridge (in QEMU, I didn=E2=80=99t check on a =
real
system):

root@bmc-oob:~# tcpdump -i br0 -v "ether proto 0x88f8" &
[1] 12045
root@bmc-oob:~# [ 1434.520314] device br0 entered promiscuous mode
tcpdump: listening on br0, link-type EN10MB (Ethernet), snapshot length =
262144 bytes
ifconfig eth0 down
[ 1442.863305] br0: port 1(eth0) entered disabled state
root@bmc-oob:~# ifconfig eth0 up
[ 1445.978424] br0: port 1(eth0) entered blocking state
[ 1445.978743] br0: port 1(eth0) entered forwarding state
[ 1445.979131] 8021q: adding VLAN 0 to HW filter on device eth0
[ 1445.979814] ftgmac100 1e660000.ethernet eth0: NCSI: Handler for =
packet type 0x82 returned -19
root@bmc-oob:~# tcpdump -i eth0 -v "ether proto 0x88f8" &
[2] 12258
root@bmc-oob:~# tcpdump: listening on eth0, link-type EN10MB (Ethernet), =
snapshot length 262144 bytes
ifcon04:58:49.464810 fa:ce:b0:02:20:22 (oui Unknown) > Broadcast, =
ethertype Unknown (0x88f8), length 60:
        0x0000:  0001 0068 0a00 0000 0000 0000 0000 0000  =
...h............
        0x0010:  ffff f597 0000 0000 0000 0000 0000 0000  =
................
        0x0020:  0000 0000 0000 0000 0000 0000 0000       ..............
04:58:49.465099 Broadcast > Broadcast, ethertype Unknown (0x88f8), =
length 64:
        0x0000:  0001 0068 8a00 0010 0000 0000 0000 0000  =
...h............
        0x0010:  0000 0000 0000 0001 0000 0000 0000 0000  =
................
        0x0020:  ffff 7586 0000 0000 0000 0000 0000 d8cd  =
..u.............
        0x0030:  c6bc                                     ..
04:58:49.471206 fa:ce:b0:02:20:22 (oui Unknown) > Broadcast, ethertype =
Unknown (0x88f8), length 60:
        0x0000:  0001 0069 1500 0000 0000 0000 0000 0000  =
...i............
        0x0010:  ffff ea96 0000 0000 0000 0000 0000 0000  =
................
        0x0020:  0000 0000 0000 0000 0000 0000 0000       ..............
04:58:49.471432 Broadcast > Broadcast, ethertype Unknown (0x88f8), =
length 78:
        0x0000:  0001 0069 9500 0028 0000 0000 0000 0000  =
...i...(........
        0x0010:  0000 0000 f1f0 f000 0000 0000 0000 0000  =
................
        0x0020:  0000 0000 0000 0000 0000 0000 0000 0000  =
................
        0x0030:  0000 0000 0000 8119 fffd 0765 84e0 9fa4  =
...........e=E2=80=A6.

So, I=E2=80=99m able to see packets on eth0, but so far I haven=E2=80=99t =
really seen
anything hitting the bridge. =C2=AF\_(=E3=83=84)_/=C2=AF

Perhaps if there=E2=80=99s some cross-interface NC-SI traffic (eth0 <-> =
eth1), then
yes this would occur. But I don=E2=80=99t know why that would even =
happen? Regular
NC-SI failover or bonding (eth0, eth1) would be the actual solution? not =
sure.

The original commit was very vague, so perhaps I=E2=80=99ll follow up =
with
the author and reviewer to see if this patch was actually necessary.

>=20
> [4]: =
https://macaddress.io/faq/what-are-a-universal-address-and-a-local-adminis=
tered-address


