Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25AB61358E
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiJaMOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiJaMOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:14:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FAB6444;
        Mon, 31 Oct 2022 05:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667218483; x=1698754483;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=FfH3YyomTtiV6CZCxtx4p5AvyzV8pgB31R9vnRwEWDU=;
  b=d/NK3XLeWjhtXnaJTsKmEPyqXWBq4gGY94bb0uTDShGdwEV2fQoHJ78i
   0pVwMqRgsXPobQ+6euxUfYSKRFyAjsdXuMdamB+AfrCBODsQX5e4xUzJd
   lo8d+urRojZVNU5xhFiuAT50OVhPFU+tHMD2bW567TBblAaBEBCPohAWA
   lEQsCz9bPPuU0WMm4hcZ0cWS/SmUm4si/HFW8vqdCg8XxULwgkT+ACC+c
   hjGn5Vb2MXA/umB2QIa4O953X30eqb3ZQJfOJB0eYtCADst8bAzi2Y4A5
   5eesI0QXUAlFq7YxL1vZNXRa4Y7S9Ni+XqQ0vDKbeCYJHecEqOUC/u7uO
   A==;
X-IronPort-AV: E=Sophos;i="5.95,227,1661842800"; 
   d="scan'208";a="186956810"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Oct 2022 05:14:42 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 31 Oct 2022 05:14:37 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 31 Oct 2022 05:14:34 -0700
Message-ID: <51622bfd3fe718139cece38493946c2860ebdf77.camel@microchip.com>
Subject: Re: [PATCH net-next v2 2/5] net: microchip: sparx5: Adding more tc
 flower keys for the IS2 VCAP
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "Wan Jiabing" <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Mon, 31 Oct 2022 13:14:33 +0100
In-Reply-To: <20221031103747.uk76tudphqdo6uto@wse-c0155>
References: <20221028144540.3344995-1-steen.hegelund@microchip.com>
         <20221028144540.3344995-3-steen.hegelund@microchip.com>
         <20221031103747.uk76tudphqdo6uto@wse-c0155>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Casper,

First of all thanks for the testing effort (as usual).  This is most welcom=
e.

On Mon, 2022-10-31 at 11:44 +0100, Casper Andersson wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> Hi Steen,
>=20
> On 2022-10-28 16:45, Steen Hegelund wrote:
> > - IPv4 Addresses
> > =C2=A0=C2=A0=C2=A0 tc filter add dev eth12 ingress chain 8000000 prio 1=
2 handle 12 \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 protocol ip flower skip_sw d=
st_ip 1.0.1.1 src_ip 2.0.2.2=C2=A0=C2=A0=C2=A0 \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action trap
>=20
> I'm not able to get this working on PCB135. I tested the VLAN tags and
> did not work either (did not test the rest). The example from the
> previous patch series doesn't work either after applying this series.


Yes I did not really explain this part (and I will update the series with a=
n explanation).

1) The rule example in the previous series will no longer work as expected =
as the changes to the
port keyset configuration now requires a non-ip frame to generate the MAC_E=
TYPE keyset.

So to test the MAC_ETYPE case your rule must be non-ip and not use "protoco=
l all" which is not
supported yet. =C2=A0

Here is an example using the "protocol 0xbeef":

tc qdisc add dev eth3 clsact
tc filter add dev eth3 ingress chain 8000000 prio 10 handle 10 \
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 protocol 0xbeef flower skip_sw \
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dst_mac 0a:0b:0c:0d:0e:0f \
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 src_mac 2:0:0:0:0:1 \
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action trap

And send a frame like this (using EasyFrame):

ef tx eth_fiber1 rep 10 eth dmac 0a:0b:0c:0d:0e:0f smac 2::1 et 0xbeef data=
 repeat 50 0x61

I am not sure what went wrong when you tested the ipv4 rule, but if I creat=
e the rule that you
quoted above the rule is activated when I send frames like this:

ef tx eth_fiber1 rep 10 eth dmac 0a:0b:0c:0d:0e:0f smac 2::2 ipv4 dip 1.0.1=
.1 sip 2.0.2.2  data
repeat 50 0x61=20

Note that the smac is changed to avoid hitting the first rule.

2) As for the VLAN based rules, the VLAN information used by IS2 is the cla=
ssified VID and PCP, so
you need to create a bridge and add the VID to the bridge and the ports to =
see this in action.

IS0 uses the VLAN tags in the frames directly: this is one of the differenc=
es between IS0 and IS2.

This is how I set up a bridge on my PCB134 when I do the testing:

ip link add name br5 type bridge
ip link set dev br5 up
ip link set eth12 master br5
ip link set eth13 master br5
ip link set eth14 master br5
ip link set eth15 master br5
sysctl -w net.ipv6.conf.eth12.disable_ipv6=3D1
sysctl -w net.ipv6.conf.eth13.disable_ipv6=3D1
sysctl -w net.ipv6.conf.eth14.disable_ipv6=3D1
sysctl -w net.ipv6.conf.eth15.disable_ipv6=3D1
sysctl -w net.ipv6.conf.br5.disable_ipv6=3D1
ip link set dev br5 type bridge vlan_filtering 1
bridge vlan add dev eth12 vid 600
bridge vlan add dev eth13 vid 600
bridge vlan add dev eth14 vid 600
bridge vlan add dev eth15 vid 600
bridge vlan add dev br5 vid 600 self

This should now allow you to use the classified VLAN information in IS2 on =
these four ports.

>=20
> This example was provided in your last patch series and worked earlier.
>=20
> My setup is PC-eth0 -> PCB135-eth3 and I use the following EasyFrames
> command to send packets:
>=20
> ef tx eth0 rep 50 eth smac 02:00:00:00:00:01 dmac 0a:0b:0c:0d:0e:0f
>=20
> IPv4:
> tc qdisc add dev eth3 clsact
> tc filter add dev eth3 ingress chain 8000000 prio 12 handle 12 \
> =C2=A0=C2=A0=C2=A0 protocol ip flower skip_sw dst_ip 1.0.1.1 src_ip 2.0.2=
.2=C2=A0=C2=A0=C2=A0 \
> =C2=A0=C2=A0=C2=A0 action trap
>=20
> ef tx eth0 rep 50 eth smac 02:00:00:00:00:01 dmac 0a:0b:0c:0d:0e:0f ipv4 =
dip 1.0.1.1 sip 2.0.2.2
>=20
> Same setup as above and I can't get this to work either.

Maybe you are hitting the first rule here, so changing the smac to avoid th=
at, should help.

>=20
> I'm using tcpdump to watch the interface to see if the packets are being
> trapped or not. Changing the packets' dmac to broadcast lets me see the
> packets so I don't have any issue with the setup.
>=20
> BR,
> Casper
>=20

Best Regards
Steen
