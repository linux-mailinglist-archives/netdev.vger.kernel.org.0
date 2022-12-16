Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DE764E589
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 02:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiLPBIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 20:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiLPBIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 20:08:12 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B778B59162;
        Thu, 15 Dec 2022 17:08:07 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id BE7163200926;
        Thu, 15 Dec 2022 20:08:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 15 Dec 2022 20:08:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pjd.dev; h=cc:cc
        :content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1671152884; x=
        1671239284; bh=blN/pt1VHUAedbxU0+7qmPGtXmOp01WbD8zdhO1Q+vg=; b=X
        BmJsQ3B4YJeZLvJsYTnYbbUolXtXKL837JUAnKSRqghmq6gAcI/KbAmXr2yA1YG9
        qzrYDqTYAHhM9T6BumHNNIVzWssJsm5U5hCZL+2iwUaSYjjQjNqfoDicZb74bFBk
        9sya4TZiQW0DqrI1u1Vx3bpYgHZMa6v0hkdzhx+k+1oouvK7rfjRO8mo5yB899fB
        tKaVMIBhMBDGsvGys/3plBRROHCmCTvAbiloaThq/4h3mj8r9qSFYOnxP9bu9jXr
        oEBGAmUcELN16VZOsUMLqb4Jb+AL/x4KrrQYZvkCWR2EfgwQGJvr64mclJog6WII
        5JpHx4h4IAF06RVccvTHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1671152884; x=
        1671239284; bh=blN/pt1VHUAedbxU0+7qmPGtXmOp01WbD8zdhO1Q+vg=; b=U
        IMOeI8t33HP/o1ziJ2fdHh+wSUPGjRV0OUQ0KCwm6yk9bdMxhelElGLoE5FYtLy8
        z4fzdF+lVuwTED6mVE5HCwI8Ml/mk+ECmYVZFNhpTsmjR5TfV0g69x/sjVPKWDkY
        vkQujQnUiNc93pj7UwBwQNw1Cot6d7Am2GHLKk5PODUrNxsXUI4NJkvbcJ68gjHV
        SOzJRULuWZ0zab3EZoUxhRd/TLditJVesjZM57KBWyaVXqeIdIFSGgnr43OTtDze
        VhVSiTtcFvpFwmcs6jl3rIOgiaxejTFzzKdLMcaFgPYLqX7oGS1rbtvnXABo0gLf
        vQDAPHp+kEizasLQPWfYg==
X-ME-Sender: <xms:9MSbY3lMt7IjuOkmGC25uSzlWpr6aVqRHDvLcWC8VEfJdMppNrze8w>
    <xme:9MSbY61hQnzh8UoA7q4eGoYA1nFFndizrQuLGOOXIQmIE3wjG7B9PeObniLWk-EfJ
    rI6bJsbHooKY8JA6T8>
X-ME-Received: <xmr:9MSbY9pc4ZRkn5eF5gA3idpkUfwgfDjADa3oYQE1XQkzzqPvTFa5cB9unu7knqDWfNietbU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeigddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuuhhsphgvtghtffhomhgrihhnucdlgeelmdenucfjughrpegtggfuhfgjffevgffkfhfv
    ofesthhqmhdthhdtjeenucfhrhhomheprfgvthgvrhcuffgvlhgvvhhorhihrghsuceoph
    gvthgvrhesphhjugdruggvvheqnecuggftrfgrthhtvghrnhepgeeghfduheeiuddvjeel
    udehhedttdetjeffhfdutddtueekhedtteefuefhgfejnecuffhomhgrihhnpehtihhnhi
    hurhhlrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepphgvthgvrhesphhjugdruggvvh
X-ME-Proxy: <xmx:9MSbY_nQO8f9FgrWH3HgeAy_0EkdNlCRBwBdnqlcjWoSrq1V3e5d8w>
    <xmx:9MSbY110B2KwadXmETPrpCTTRaMxwR9b34x6HHjzhmJMionQZLvtVA>
    <xmx:9MSbY-u1WtxPuctyiW6W02xpxASQ9kDmMYHAsM1PnC04s8NVZN9e-g>
    <xmx:9MSbYymxaybiTkAJtjfog675eLwAIshlymc5qf5PxCOevpO1SABq9Q>
Feedback-ID: i9e814621:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Dec 2022 20:08:03 -0500 (EST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] net/ncsi: Always use unicast source MAC address
From:   Peter Delevoryas <peter@pjd.dev>
In-Reply-To: <ac48b381b11c875cf36a471002658edafe04d9b9.camel@gmail.com>
Date:   Thu, 15 Dec 2022 17:07:51 -0800
Cc:     Peter Delevoryas <peter@pjd.dev>, sam@mendozajonas.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7A3DBE8E-C13D-430D-B851-207779148A77@pjd.dev>
References: <20221213004754.2633429-1-peter@pjd.dev>
 <ac48b381b11c875cf36a471002658edafe04d9b9.camel@gmail.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_PDS_SHORTFWD_URISHRT_QP autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 13, 2022, at 8:41 AM, Alexander H Duyck =
<alexander.duyck@gmail.com> wrote:
>=20
> On Mon, 2022-12-12 at 16:47 -0800, Peter Delevoryas wrote:
>> I use QEMU for development, and I noticed that NC-SI packets get =
dropped by
>> the Linux software bridge[1] because we use a broadcast source MAC =
address
>> for the first few NC-SI packets.
>=20
> Normally NC-SI packets should never be seen by a bridge.

True, and it=E2=80=99s good to keep this in context. I=E2=80=99m trying =
to make this change
to support simulation environments, but any change in NC-SI could easily
result in the out-of-band network connection to BMC=E2=80=99s in real =
data centers
failing to come up, which can be really bad and usually impossible to
recover remotely.

> Isn't NC-SI
> really supposed to just be between the BMC and the NIC firmware?

Yep

> Depending on your setup it might make more sense to use something like
> macvtap or a socket connection to just bypass the need for the bridge
> entirely.

For unicast, yes, but I want to test multiple NIC=E2=80=99s sharing an =
RMII
link and verifying the broadcast behavior, and the failover behavior
when an RX or TX channel goes down.

The multicast UDP socket backend _does_ work, but I was getting some
recirculation problems or some kind of buffering thing. I managed
to get tap0 + tap1 + br0 working faster.

>=20
>> The spec requires that the destination MAC address is =
FF:FF:FF:FF:FF:FF,
>> but it doesn't require anything about the source MAC address as far =
as I
>> know. =46rom testing on a few different NC-SI NIC's (Broadcom 57502, =
Nvidia
>> CX4, CX6) I don't think it matters to the network card. I mean, Meta =
has
>> been using this in mass production with millions of BMC's [2].
>>=20
>> In general, I think it's probably just a good idea to use a unicast =
MAC.
>=20
> I'm not sure I agree there. What is the initial value of the address?

Ok so, to be honest, I thought that the BMC=E2=80=99s FTGMAC100 =
peripherals
came with addresses provisioned from the factory, and that we were just
discarding that value and using an address provisioned through the NIC,
because I hadn=E2=80=99t really dug into the FTGMAC100 datasheet fully. =
I see now
that the MAC address register I thought was a read-only manufacturing
value is actually 8 different MAC address r/w registers for filtering.
*facepalm*

It suddenly makes a lot more sense why all these OEM Get MAC Address
commands exist: the BMC chip doesn=E2=80=99t come with any MAC addresses =
from
manufacturing. It=E2=80=99s a necessity, not some convenience =
artifact/etc.

So, tracing some example systems to see what shows up:

One example:
INIT: Entering runlevel: 5
Configuring network interfaces... [   25.893118] 8021q: adding VLAN 0 to =
HW filter on device eth0
[   25.904809] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   25.917307] ftgmac100 1e660000.ethernet eth0: NCSI: Handler for =
packet type 0x82 returned -19
[   25.958096] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   25.978124] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   25.990559] ftgmac100 1e660000.ethernet eth0: NCSI: 'bad' packet =
ignored for type 0xd0
[   26.018180] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   26.030631] ftgmac100 1e660000.ethernet eth0: NCSI: 'bad' packet =
ignored for type 0xd0
[   26.046594] ftgmac100 1e660000.ethernet eth0: NCSI: transmit cmd 0x50 =
ncsi_oem_sma_mlx success during probe
[   26.168109] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   26.198101] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   26.238237] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   26.272011] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   26.308155] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   26.320504] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
done.
[   26.408094] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   26.438100] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   26.450537] ftgmac100 1e660000.ethernet eth0: NCSI: bcm_gmac16 MAC =
RE:DA:CT:ED:HE:HE
Starting random number generator[   26.472388] NCSI: =
source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
 daemon[   26.518241] NCSI: source=3Dff:ff:ff:ff:ff:ff =
dest=3Dff:ff:ff:ff:ff:ff
[   26.559504] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
.
[   26.608229] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
Setup dhclient for IPv6... done.
[   26.681879] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   26.730523] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   26.808191] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
[   26.855689] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff

Oddly, due to that code you mentioned, all NC-SI packets are using
a broadcast source MAC address, even after the Get MAC Address sequence
gets the MAC provisioned for the BMC from the Broadcom NIC.

root@bmc-oob:~# ifconfig
eth0      Link encap:Ethernet  HWaddr RE:DA:CT:ED:HE:HE
          inet addr:XXXXXXX  Bcast:XXXXXXXX  Mask:XXXXXXXX
          inet6 addr: XXXXXXXX Scope:Global
          inet6 addr: XXXXXXXX Scope:Link
          inet6 addr: XXXXXXXX Scope:Global
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:2965 errors:0 dropped:0 overruns:0 frame:0
          TX packets:637 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:872759 (852.3 KiB)  TX bytes:59936 (58.5 KiB)
          Interrupt:19

But, that=E2=80=99s a system using the 5.0 kernel with lots of old hacks
on top. A system using a 5.15 kernel with this change included:

INIT: Entering runlevel: 5
Configuring network interfaces... [    6.596537] 8021q: adding VLAN 0 to =
HW filter on device eth0
[    6.609264] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
[    6.622913] ftgmac100 1e690000.ftgmac eth0: NCSI: Handler for packet =
type 0x82 returned -19
[    6.641447] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
[    6.662543] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
[    6.680454] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
[    6.694114] ftgmac100 1e690000.ftgmac eth0: NCSI: transmit cmd 0x50 =
ncsi_oem_sma_mlx success during probe
[    6.715722] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
done.
[    6.741372] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
[    6.741451] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
[    6.768714] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
Starting random [    6.782599] NCSI: source=3DRE:DA:CT:ED:AD:DR =
dest=3Dff:ff:ff:ff:ff:ff
number generator[    6.799321] NCSI: source=3DRE:DA:CT:ED:AD:DR =
dest=3Dff:ff:ff:ff:ff:ff
 daemon[    6.815680] NCSI: source=3DRE:DA:CT:ED:AD:DR =
dest=3Dff:ff:ff:ff:ff:ff
[    6.831388] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
.
[    6.846921] ftgmac100 1e690000.ftgmac eth0: NCSI: Network controller =
supports NC-SI 1.1, querying MAC address through OEM(0x8119) command
Setup dhclient for IPv6... done.
[    6.908921] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
reloading rsyslo[    6.933085] NCSI: source=3DRE:DA:CT:ED:AD:DR =
dest=3Dff:ff:ff:ff:ff:ff

So, this BMC already had the provisioned MAC address somehow,
even before the Nvidia Get MAC Address command towards the bottom.

Adding tracing to ftgmac100:

[    2.018672] ftgmac100_initial_mac
[    2.026090] Read MAC address from FTGMAC100 register: =
RE:DA:CT:ED:AD:DR
[    2.040771] ftgmac100 1e690000.ftgmac: Read MAC address =
RE:DA:CT:ED:AD:DR from chip
[    2.057774] ftgmac100 1e690000.ftgmac: Using NCSI interface
[    2.070957] ftgmac100 1e690000.ftgmac eth0: irq 33, mapped at =
(ptrval)

Now, after rewriting the FTGMAC100 register to fa:ce:b0:0c:20:22 and =
rebooting:

root@dhcp6-2620-10d-c0b9-4b08-0-0-0-e4e:~# devmem 0x1e690008 32 =
0x0000face
root@dhcp6-2620-10d-c0b9-4b08-0-0-0-e4e:~# devmem 0x1e690008
0x0000FACE
root@dhcp6-2620-10d-c0b9-4b08-0-0-0-e4e:~# devmem 0x1e69000c 32 =
0xb00c2022
root@dhcp6-2620-10d-c0b9-4b08-0-0-0-e4e:~# devmem 0x1e69000c
0xB00C2022

[    2.001304] ftgmac100_initial_mac
[    2.008727] Read MAC address from FTGMAC100 register: =
fa:ce:b0:0c:20:22
[    2.023373] ftgmac100 1e690000.ftgmac: Read MAC address =
fa:ce:b0:0c:20:22 from chip
[    2.040367] ftgmac100 1e690000.ftgmac: Using NCSI interface

[    6.581239] ftgmac100_reset_mac
[    6.589193] ftgmac100_reset_mac
[    6.596727] 8021q: adding VLAN 0 to HW filter on device eth0
[    6.609462] NCSI: source=3Dfa:ce:b0:0c:20:22 dest=3Dff:ff:ff:ff:ff:ff
[    6.623117] ftgmac100 1e690000.ftgmac eth0: NCSI: Handler for packet =
type 0x82 returned -19
[    6.641647] NCSI: source=3Dfa:ce:b0:0c:20:22 dest=3Dff:ff:ff:ff:ff:ff
[    6.662398] NCSI: source=3Dfa:ce:b0:0c:20:22 dest=3Dff:ff:ff:ff:ff:ff
[    6.680380] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
[    6.694000] ftgmac100 1e690000.ftgmac eth0: NCSI: transmit cmd 0x50 =
ncsi_oem_sma_mlx success during probe
[    6.715700] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
[    6.729528] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff

So, it looks like whatever is initialized in ftgmac100_initial_mac =
becomes
the address we use for the NCSI queries initially.

The Aspeed datasheet says the FTGMAC100 MAC address registers are =
initialized to zero,
and in that case the ftgmac100 driver initializes it to something random
with eth_hw_addr_random().

So, I mean correct me if I=E2=80=99m wrong, but I think it all seems =
fine?

On a hard power cycle (instead of just resetting the ARM cores, which =
doesn=E2=80=99t seem to
have reset the peripherals), maybe it would actually be zero, and get =
initialized
to the random value. I=E2=80=99ll test that, need to do some more debug =
image building to do it
remotely.

> If I am not mistaken the gma_flag is used to indicate that the MAC
> address has been acquired isn't it?

That=E2=80=99s correct.

> If using the broadcast is an issue
> the maybe an all 0's MAC address might be more appropriate.

Possibly yeah, although that would also be dropped by the Linux bridge =
lol,
so it wouldn=E2=80=99t solve my simulation problem.

> My main
> concern would be that the dev_addr is not initialized for those first
> few messages so you may be leaking information.
>=20
>> This might have the effect of causing the NIC to learn 2 MAC =
addresses from
>> an NC-SI link if the BMC uses OEM Get MAC Address commands to change =
its
>> initial MAC address, but it shouldn't really matter. Who knows if =
NIC's
>> even have MAC learning enabled from the out-of-band BMC link, lol.
>>=20
>> [1]: https://tinyurl.com/4933mhaj
>> [2]: https://tinyurl.com/mr3tyadb
>=20
> The thing is the OpenBMC approach initializes the value themselves to
> broadcast[3]. As a result the two code bases are essentially doing the
> same thing since mac_addr is defaulted to the broadcast address when
> the ncsi interface is registered.

That=E2=80=99s a very good point, thanks for pointing that out, I =
hadn=E2=80=99t
even noticed that!

Anyways, let me know what you think of the traces I added above.
Sorry for the delay, I=E2=80=99ve just been busy with some other stuff,
but I do really actually care about upstreaming this (and several
other NC-SI changes I=E2=80=99ll submit after this one, which are =
unrelated
but more useful).

Thanks,
Peter

>=20
> [3]: tinyurl.com/mr3cxf3b
>=20
>>=20
>> Signed-off-by: Peter Delevoryas <peter@pjd.dev>
>> ---
>> net/ncsi/ncsi-cmd.c | 10 +---------
>> 1 file changed, 1 insertion(+), 9 deletions(-)
>>=20
>> diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
>> index dda8b76b7798..fd090156cf0d 100644
>> --- a/net/ncsi/ncsi-cmd.c
>> +++ b/net/ncsi/ncsi-cmd.c
>> @@ -377,15 +377,7 @@ int ncsi_xmit_cmd(struct ncsi_cmd_arg *nca)
>> eh =3D skb_push(nr->cmd, sizeof(*eh));
>> eh->h_proto =3D htons(ETH_P_NCSI);
>> eth_broadcast_addr(eh->h_dest);
>> -
>> - /* If mac address received from device then use it for
>> - * source address as unicast address else use broadcast
>> - * address as source address
>> - */
>> - if (nca->ndp->gma_flag =3D=3D 1)
>> - memcpy(eh->h_source, nca->ndp->ndev.dev->dev_addr, ETH_ALEN);
>> - else
>> - eth_broadcast_addr(eh->h_source);
>> + memcpy(eh->h_source, nca->ndp->ndev.dev->dev_addr, ETH_ALEN);
>>=20
>> /* Start the timer for the request that might not have
>> * corresponding response. Given NCSI is an internal
>=20

