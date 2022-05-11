Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8B152354E
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244534AbiEKOW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiEKOWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:22:55 -0400
Received: from smtp15.bhosted.nl (smtp15.bhosted.nl [IPv6:2a02:9e0:8000::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A110A633A0
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 07:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=protonic.nl; s=202111;
        h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
         message-id:subject:cc:to:from:date:from;
        bh=7gWMwVMh7LPXq16z47wa6WzSkRF5sQdQRUfx5IDLaeg=;
        b=rm2eSfQIaijQXb0LYrpJzG7TQdI+JewADI1jE+oljLS4v1wacbBm25ee67+XFJSk9PqJ/CDuw7XuI
         9Vd+Cb6Q9mN8/kvHXmT3q2AFmc9J76/bt7SyPP1VwnTOoKXlzLtJPAkmAzStNAc3y6vGC/ongmxPVA
         gleeY4e+LIPahPYLP7B/gOh7KzAqFUXI7g1EU4mSm8NqWAD/+R35jitr6SXGnOFFhp5o78niqxzrLX
         3cu8rB/NhVQnxFa2bMjIJooB4WZjbO+EQuZq0GTm+EmCdEyDvYwi98udZN91QkFwSnhKvxL7/HsCwg
         gG8KuQYVMBNcfjOQoQRfYU1iRlRwSfg==
X-MSG-ID: d554787d-d135-11ec-b450-0050569d3a82
Date:   Wed, 11 May 2022 16:22:47 +0200
From:   David Jander <david@protonic.nl>
To:     Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Robin van der Gracht <robin@protonic.nl>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr
 was already claimed
Message-ID: <20220511162247.2cf3fb2e@erd992>
In-Reply-To: <baaf0b8b237a2e6a8f99faca60112919d79cf549.camel@egluetechnologies.com>
References: <20220509170303.29370-1-devid.filoni@egluetechnologies.com>
        <YnllpntZ8V5CD07v@x1.vandijck-laurijssen.be>
        <20220510042609.GA10669@pengutronix.de>
        <ce7da10389fe448efee86d788dd5282b8022f92e.camel@egluetechnologies.com>
        <20220511084728.GD10669@pengutronix.de>
        <20220511110649.21cc1f65@erd992>
        <baaf0b8b237a2e6a8f99faca60112919d79cf549.camel@egluetechnologies.com>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Devid,

On Wed, 11 May 2022 14:55:04 +0200
Devid Antonio Filoni <devid.filoni@egluetechnologies.com> wrote:

> On Wed, 2022-05-11 at 11:06 +0200, David Jander wrote:
> > Hi,
> >=20
> > On Wed, 11 May 2022 10:47:28 +0200
> > Oleksij Rempel <
> > o.rempel@pengutronix.de =20
> > > wrote: =20
> >  =20
> > > Hi,
> > >=20
> > > i'll CC more J1939 users to the discussion. =20
> >=20
> > Thanks for the CC.
> >  =20
> > > On Tue, May 10, 2022 at 01:00:41PM +0200, Devid Antonio Filoni wrote:=
 =20
> > > > Hi,
> > > >=20
> > > > On Tue, 2022-05-10 at 06:26 +0200, Oleksij Rempel wrote:   =20
> > > > > Hi,
> > > > >=20
> > > > > On Mon, May 09, 2022 at 09:04:06PM +0200, Kurt Van Dijck wrote:  =
 =20
> > > > > > On ma, 09 mei 2022 19:03:03 +0200, Devid Antonio Filoni wrote: =
  =20
> > > > > > > This is not explicitly stated in SAE J1939-21 and some tools =
used for
> > > > > > > ISO-11783 certification do not expect this wait.   =20
> > > > >=20
> > > > > It will be interesting to know which certification tool do not ex=
pect it and
> > > > > what explanation is used if it fails?
> > > > >    =20
> > > > > > IMHO, the current behaviour is not explicitely stated, but nor =
is the opposite.
> > > > > > And if I'm not mistaken, this introduces a 250msec delay.
> > > > > >=20
> > > > > > 1. If you want to avoid the 250msec gap, you should avoid to co=
ntest the same address.
> > > > > >=20
> > > > > > 2. It's a balance between predictability and flexibility, but i=
f you try to accomplish both,
> > > > > > as your patch suggests, there is slight time-window until the c=
urrent owner responds,
> > > > > > in which it may be confusing which node has the address. It dep=
ends on how much history
> > > > > > you have collected on the bus.
> > > > > >=20
> > > > > > I'm sure that this problem decreases with increasing processing=
 power on the nodes,
> > > > > > but bigger internal queues also increase this window.
> > > > > >=20
> > > > > > It would certainly help if you describe how the current impleme=
ntation fails.
> > > > > >=20
> > > > > > Would decreasing the dead time to 50msec help in such case.
> > > > > >=20
> > > > > > Kind regards,
> > > > > > Kurt
> > > > > >    =20
> > > > >=20
> > > > >    =20
> > > >=20
> > > > The test that is being executed during the ISOBUS compliance is the
> > > > following: after an address has been claimed by a CF (#1), another =
CF
> > > > (#2) sends a  message (other than address-claim) using the same add=
ress
> > > > claimed by CF #1.
> > > >=20
> > > > As per ISO11783-5 standard, if a CF receives a message, other than =
the
> > > > address-claimed message, which uses the CF's own SA, then the CF (#=
1):
> > > > - shall send the address-claim message to the Global address;
> > > > - shall activate a diagnostic trouble code with SPN =3D 2000+SA and=
 FMI =3D
> > > > 31
> > > >=20
> > > > After the address-claim message is sent by CF #1, as per ISO11783-5
> > > > standard:
> > > > - If the name of the CF #1 has a lower priority then the one of the=
 CF
> > > > #2, the the CF #2 shall send its address-claim message and thus the=
 CF
> > > > #1 shall send the cannot-claim-address message or shall execute aga=
in
> > > > the claim procedure with a new address
> > > > - If the name of the CF #1 has higher priority then the of the CF #=
2,
> > > > then the CF #2 shall send the cannot-claim-address message or shall
> > > > execute the claim procedure with a new address
> > > >=20
> > > > Above conflict management is OK with current J1939 driver
> > > > implementation, however, since the driver always waits 250ms after
> > > > sending an address-claim message, the CF #1 cannot set the DTC. The=
 DM1
> > > > message which is expected to be sent each second (as per J1939-73
> > > > standard) may not be sent.
> > > >=20
> > > > Honestly, I don't know which company is doing the ISOBUS compliance
> > > > tests on our products and which tool they use as it was choosen by =
our
> > > > customer, however they did send us some CAN traces of previously
> > > > performed tests and we noticed that the DM1 message is sent 160ms a=
fter
> > > > the address-claim message (but it may also be lower then that), and=
 this
> > > > is something that we cannot do because the driver blocks the applic=
ation
> > > > from sending it.
> > > >=20
> > > > 28401.127146 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Me=
ssage
> > > > with other CF's address
> > > > 28401.167414 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Ad=
dress
> > > > Claim - SA =3D F0
> > > > 28401.349214 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 01 FF FF  //DM1
> > > > 28402.155774 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Me=
ssage
> > > > with other CF's address
> > > > 28402.169455 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Ad=
dress
> > > > Claim - SA =3D F0
> > > > 28402.348226 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 02 FF FF  //DM1
> > > > 28403.182753 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Me=
ssage
> > > > with other CF's address
> > > > 28403.188648 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Ad=
dress
> > > > Claim - SA =3D F0
> > > > 28403.349328 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> > > > 28404.349406 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> > > > 28405.349740 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> > > >=20
> > > > Since the 250ms wait is not explicitly stated, IMHO it should be up=
 to
> > > > the user-space implementation to decide how to manage it. =20
> >=20
> > I think this is not entirely correct. AFAICS the 250ms wait is indeed
> > explicitly stated.
> > The following is taken from ISO 11783-5:
> >=20
> > In "4.4.4.3 Address violation" it states that "If a CF receives a messa=
ge,
> > other than the address-claimed message, which uses the CF=E2=80=99s own=
 SA, then the
> > CF [...] shall send the address-claim message to the Global address."
> >=20
> > So the CF shall claim its address again. But further down, in "4.5.2 Ad=
dress
> > claim requirements" it is stated that "...No CF shall begin, or resume,
> > transmission on the network until 250 ms after it has successfully clai=
med an
> > address".
> >=20
> > At this moment, the address is in dispute. The affected CFs are not all=
owed to
> > send any other messages until this dispute is resolved, and the standard
> > requires a waiting time of 250ms which is minimally deemed necessary to=
 give
> > all participants time to respond and eventually dispute the address cla=
im.
> >=20
> > If the offending CF ignores this dispute and keeps sending incorrect me=
ssages
> > faster than every 250ms, then effectively the other CF has no chance to=
 ever
> > resume normal operation because its address is still disputed.
> >=20
> > According to 4.4.4.3 it is also required to set a DTC, but it will not =
be
> > allowed to send the DM1 message unless the address dispute is resolved.
> >=20
> > This effectively leads to the offending CF to DoS the affected CF if it=
 keeps
> > sending offending messages. Unfortunately neither J1939 nor ISObus take=
s into
> > account adversarial behavior on the CAN network, so we cannot do anythi=
ng
> > about this.
> >=20
> > As for the ISObus compliance tool that is mentioned by Devid, IMHO this
> > compliance tool should be challenged and fixed, since it is broken.
> >=20
> > The networking layer is prohibiting the DM1 message to be sent, and the
> > networking layer has precedence above all superior protocol layers, so =
the
> > diagnostics layer is not able to operate at this moment.
> >=20
> > Best regards,
> >=20
> >  =20
>=20
> Hi David,
>=20
> I get your point but I'm not sure that it is the correct interpretation
> that should be applied in this particular case for the following
> reasons:
>=20
> - In "4.5.2 Address claim requirements" it is explicitly stated that
> "The CF shall claim its own address when initializing and when
> responding to a command to change its NAME or address" and this seems to

The standard unfortunately has a track record of ignoring a lot of scenarios
and corner cases, like in this instance the fact that there can appear new
participants on the bus _after_ initialization has long finished, and it wo=
uld
need to claim its address again in that case.

But look at point d) of that same section: "No CF shall begin, or resume,
transmission on the network until 250 ms after it has successfully claimed =
an
address (Figure 4). This does not apply when responding to a request for
address claimed."

So we basically have two situations when this will apply after the network =
is
up and running and a new node suddenly appears:

 1. The new node starts with a "Request for address claimed" message, to
 which your CF should respond with an "Address Claimed" message and NOT wait
 250ms.

or

 2. The new node creates an addressing conflict either by claiming its addr=
ess
 without first sending a "request for address claimed" message or (and this=
 is
 your case) simply using its address without claiming it first.

It is this second possibility where there is a conflict that must be resolv=
ed,
and then you must wait 250ms after claiming the conflicting address for
yourself.

> completely ignore the "4.4.4.3 Address violation" that states that the
> address-claimed message shall be sent also when "the CF receives a
> message, other than the address-claimed message, which uses the CF's own
> SA".
> Please note that the address was already claimed by the CF, so I think
> that the initialization requirements should not apply in this case since
> all disputes were already resolved.

Well, yes and no. The address was claimed before, yes, but then a new node =
came
onto the bus and disputed that address. In that case the dispute needs to be
resolved first. Imagine you would NOT wait 250ms, but the other CF did
correctly claim its address, but it was you who did not receive that message
for some reason. Now also assume that your own NAME has a lower priority th=
an
the other CF. In this case you can send a "claimed address" message to claim
your address again, but it will be contested. If you don't wait for the
contestant, it is you who will be in violation of the protocol, because you
should have changed your own address but failed to do so.

> - If the offending CF ignores the dispute, as you said, then the other
> CF has no chance to ever resume normal operation and so the network
> cannot be aware that the other CF is not working correctly because the
> offending CF is spoofing its own address.

Correct. And like I said in my previous reply, this is unfortunately how CA=
N,
J1939 and ISObus work. The whole network must cooperate and there is no
consideration for malign or adversarial actors.
There are also a lot of possible corner cases that these standards
unfortunately do not take into account. Conformance test tools seem to be e=
ven
more problematic and tend to have bugs quite often. I am still inclined to
think this is the case with your test tool.

> This seems to make useless the
> requirement that states to activate the DTC in "4.4.4.3 Address
> violation".

The requirement is not useless. You can still set and store the DTC, just n=
ot
broadcast it to the network at that moment.

Best regards,

--=20
David Jander
Protonic Holland.

