Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB87F62F282
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 11:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241678AbiKRK0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 05:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbiKRK0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 05:26:13 -0500
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Nov 2022 02:26:08 PST
Received: from smtpcmd0757.aruba.it (smtpcmd0757.aruba.it [62.149.156.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECFF1748EE
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 02:26:08 -0800 (PST)
Received: from [192.168.1.212] ([213.215.163.55])
        by Aruba Outgoing Smtp  with ESMTPSA
        id vyYSoWJZbsCm6vyYToNwps; Fri, 18 Nov 2022 11:25:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1668767106; bh=lmcTkQjzYi2JgWFLL0LIn8V2DLjqxk4o6DivU+mgee8=;
        h=Subject:From:To:Date:Content-Type:MIME-Version;
        b=JGqvX7ducLJ5yAAncjRAu0wfWE7+6uvZoHg8Kt46/cP2bPJdjBw70woiKcVVoOanz
         YZaxT6qz6nt7erI7DIVNTQcKuoh15qK1ZAdBBfP0nTfuRZCVOyQ7pc9eBYxcXig7vZ
         heEScmzrA32vV84W1cAC9nTmrIv7PZKLyOM82bgJlwppzZlRk6lndabTPmX4gq0672
         kYkd0of+990J+KT2eUTuMUEt/8g6R9xLHPPV/uiapS5SnuDOUS6v8xXu2quskQLwlC
         p4lf161wmlunZW5fzzzbyO1ifaN/+1kqsC2I2Dqw0nMesludLPhIbgnVlTimKWcbAt
         Tn4/9XqWhkinw==
Message-ID: <7b575cface09a2817ac53485507985a7fef7b835.camel@egluetechnologies.com>
Subject: Re: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr
 was already claimed
From:   Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>
Cc:     Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
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
Date:   Fri, 18 Nov 2022 11:25:04 +0100
In-Reply-To: <20221118060647.GE12278@pengutronix.de>
References: <YnllpntZ8V5CD07v@x1.vandijck-laurijssen.be>
         <20220510042609.GA10669@pengutronix.de>
         <ce7da10389fe448efee86d788dd5282b8022f92e.camel@egluetechnologies.com>
         <20220511084728.GD10669@pengutronix.de> <20220511110649.21cc1f65@erd992>
         <baaf0b8b237a2e6a8f99faca60112919d79cf549.camel@egluetechnologies.com>
         <20220511162247.2cf3fb2e@erd992>
         <3566cba652c64641603fd0ad477e2c90cd77655b.camel@egluetechnologies.com>
         <e0f6b26e2c724439752f3c13b53af1a56a42a5bf.camel@egluetechnologies.com>
         <20221117162251.5e5933c1@erd992> <20221118060647.GE12278@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-CMAE-Envelope: MS4xfIU1zxwt0YEAcTZc6jcgue46NlY/s2Vjxeir3e1o8nzz/Pk/AHEPUaKRkPDTLjJODUheCLc/+Bo3LWOpmTWHPYF93GMrkneJXNjZnTTq6jC0q9Bpb9WG
 q1Lek/jgb1IdIleZ06K8gYIFIVxYT9YafSpoHDKj0d8Yt/fGqx16iNeRf/ENwGnJXVoL7DBSAsZBG24fQcH3QNuEu47ZOiGckm5l8YpV5RBGzryLYzm4RNe7
 NLPvxJe1u/ZtStoXP+e7C9z+dREAJJxVtbdRUd96MIg21pywUa4n7HQqq5kT2ntVu0LOouN5g+UWnxYJuuQ7FgCWqgoeazeb0c672yIgvqZVxCcVQKiSMsm8
 XvObM36rnUyilaYZKKjkF1IcDfrbiDX8r+8n8AkQuWqQpyJMHPmxEHO9NrA49P0OP818OauOuv1kGPFvetlm5PL7+z75BsyF3P51r3KDSv4aAWSGAULBB2gO
 Y+sD/KeYbbixmTm1RxAbckVBef/PsvzcDhPjPgWzt0XdpbozA9OmSxG9PHQfz4NEt0A4CIYm1hzzThxpoj1B7ImP4RHveJp5nkau4D3HvdUJrmhk9Y0fA/Em
 9wx2M2d0Ls1cI/MYBoohST07aC3d01Yuy/EJoBJ42o+7Hcanld4rDI5Hv5k3HmmfabHA3G7nvwEqamdcv6GFLpchUuybRvksrDecqTG1BPIMfrkyvJlDSIQk
 8WrNoNWq9j8=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-18 at 07:06 +0100, Oleksij Rempel wrote:
> On Thu, Nov 17, 2022 at 04:22:51PM +0100, David Jander wrote:
> > On Thu, 17 Nov 2022 15:08:20 +0100
> > Devid Antonio Filoni <devid.filoni@egluetechnologies.com> wrote:
> >=20
> > > On Fri, 2022-05-13 at 11:46 +0200, Devid Antonio Filoni wrote:
> > > > Hi David,
> > > >=20
> > > > On Wed, 2022-05-11 at 16:22 +0200, David Jander wrote: =20
> > > > > Hi Devid,
> > > > >=20
> > > > > On Wed, 11 May 2022 14:55:04 +0200
> > > > > Devid Antonio Filoni <
> > > > > devid.filoni@egluetechnologies.com =20
> > > > > > wrote: =20
> > > > >  =20
> > > > > > On Wed, 2022-05-11 at 11:06 +0200, David Jander wrote: =20
> > > > > > > Hi,
> > > > > > >=20
> > > > > > > On Wed, 11 May 2022 10:47:28 +0200
> > > > > > > Oleksij Rempel <
> > > > > > > o.rempel@pengutronix.de
> > > > > > >    =20
> > > > > > > > wrote:   =20
> > > > > > >=20
> > > > > > >    =20
> > > > > > > > Hi,
> > > > > > > >=20
> > > > > > > > i'll CC more J1939 users to the discussion.   =20
> > > > > > >=20
> > > > > > > Thanks for the CC.
> > > > > > >    =20
> > > > > > > > On Tue, May 10, 2022 at 01:00:41PM +0200, Devid Antonio Fil=
oni wrote:   =20
> > > > > > > > > Hi,
> > > > > > > > >=20
> > > > > > > > > On Tue, 2022-05-10 at 06:26 +0200, Oleksij Rempel wrote: =
    =20
> > > > > > > > > > Hi,
> > > > > > > > > >=20
> > > > > > > > > > On Mon, May 09, 2022 at 09:04:06PM +0200, Kurt Van Dijc=
k wrote:     =20
> > > > > > > > > > > On ma, 09 mei 2022 19:03:03 +0200, Devid Antonio Filo=
ni wrote:     =20
> > > > > > > > > > > > This is not explicitly stated in SAE J1939-21 and s=
ome tools used for
> > > > > > > > > > > > ISO-11783 certification do not expect this wait.   =
  =20
> > > > > > > > > >=20
> > > > > > > > > > It will be interesting to know which certification tool=
 do not expect it and
> > > > > > > > > > what explanation is used if it fails?
> > > > > > > > > >      =20
> > > > > > > > > > > IMHO, the current behaviour is not explicitely stated=
, but nor is the opposite.
> > > > > > > > > > > And if I'm not mistaken, this introduces a 250msec de=
lay.
> > > > > > > > > > >=20
> > > > > > > > > > > 1. If you want to avoid the 250msec gap, you should a=
void to contest the same address.
> > > > > > > > > > >=20
> > > > > > > > > > > 2. It's a balance between predictability and flexibil=
ity, but if you try to accomplish both,
> > > > > > > > > > > as your patch suggests, there is slight time-window u=
ntil the current owner responds,
> > > > > > > > > > > in which it may be confusing which node has the addre=
ss. It depends on how much history
> > > > > > > > > > > you have collected on the bus.
> > > > > > > > > > >=20
> > > > > > > > > > > I'm sure that this problem decreases with increasing =
processing power on the nodes,
> > > > > > > > > > > but bigger internal queues also increase this window.
> > > > > > > > > > >=20
> > > > > > > > > > > It would certainly help if you describe how the curre=
nt implementation fails.
> > > > > > > > > > >=20
> > > > > > > > > > > Would decreasing the dead time to 50msec help in such=
 case.
> > > > > > > > > > >=20
> > > > > > > > > > > Kind regards,
> > > > > > > > > > > Kurt
> > > > > > > > > > >      =20
> > > > > > > > > >=20
> > > > > > > > > >      =20
> > > > > > > > >=20
> > > > > > > > > The test that is being executed during the ISOBUS complia=
nce is the
> > > > > > > > > following: after an address has been claimed by a CF (#1)=
, another CF
> > > > > > > > > (#2) sends a  message (other than address-claim) using th=
e same address
> > > > > > > > > claimed by CF #1.
> > > > > > > > >=20
> > > > > > > > > As per ISO11783-5 standard, if a CF receives a message, o=
ther than the
> > > > > > > > > address-claimed message, which uses the CF's own SA, then=
 the CF (#1):
> > > > > > > > > - shall send the address-claim message to the Global addr=
ess;
> > > > > > > > > - shall activate a diagnostic trouble code with SPN =3D 2=
000+SA and FMI =3D
> > > > > > > > > 31
> > > > > > > > >=20
> > > > > > > > > After the address-claim message is sent by CF #1, as per =
ISO11783-5
> > > > > > > > > standard:
> > > > > > > > > - If the name of the CF #1 has a lower priority then the =
one of the CF
> > > > > > > > > #2, the the CF #2 shall send its address-claim message an=
d thus the CF
> > > > > > > > > #1 shall send the cannot-claim-address message or shall e=
xecute again
> > > > > > > > > the claim procedure with a new address
> > > > > > > > > - If the name of the CF #1 has higher priority then the o=
f the CF #2,
> > > > > > > > > then the CF #2 shall send the cannot-claim-address messag=
e or shall
> > > > > > > > > execute the claim procedure with a new address
> > > > > > > > >=20
> > > > > > > > > Above conflict management is OK with current J1939 driver
> > > > > > > > > implementation, however, since the driver always waits 25=
0ms after
> > > > > > > > > sending an address-claim message, the CF #1 cannot set th=
e DTC. The DM1
> > > > > > > > > message which is expected to be sent each second (as per =
J1939-73
> > > > > > > > > standard) may not be sent.
> > > > > > > > >=20
> > > > > > > > > Honestly, I don't know which company is doing the ISOBUS =
compliance
> > > > > > > > > tests on our products and which tool they use as it was c=
hoosen by our
> > > > > > > > > customer, however they did send us some CAN traces of pre=
viously
> > > > > > > > > performed tests and we noticed that the DM1 message is se=
nt 160ms after
> > > > > > > > > the address-claim message (but it may also be lower then =
that), and this
> > > > > > > > > is something that we cannot do because the driver blocks =
the application
> > > > > > > > > from sending it.
> > > > > > > > >=20
> > > > > > > > > 28401.127146 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF F=
F FF  //Message
> > > > > > > > > with other CF's address
> > > > > > > > > 28401.167414 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 0=
0 A0  //Address
> > > > > > > > > Claim - SA =3D F0
> > > > > > > > > 28401.349214 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 01 F=
F FF  //DM1
> > > > > > > > > 28402.155774 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF F=
F FF  //Message
> > > > > > > > > with other CF's address
> > > > > > > > > 28402.169455 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 0=
0 A0  //Address
> > > > > > > > > Claim - SA =3D F0
> > > > > > > > > 28402.348226 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 02 F=
F FF  //DM1
> > > > > > > > > 28403.182753 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF F=
F FF  //Message
> > > > > > > > > with other CF's address
> > > > > > > > > 28403.188648 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 0=
0 A0  //Address
> > > > > > > > > Claim - SA =3D F0
> > > > > > > > > 28403.349328 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 F=
F FF  //DM1
> > > > > > > > > 28404.349406 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 F=
F FF  //DM1
> > > > > > > > > 28405.349740 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 F=
F FF  //DM1
> > > > > > > > >=20
> > > > > > > > > Since the 250ms wait is not explicitly stated, IMHO it sh=
ould be up to
> > > > > > > > > the user-space implementation to decide how to manage it.=
   =20
> > > > > > >=20
> > > > > > > I think this is not entirely correct. AFAICS the 250ms wait i=
s indeed
> > > > > > > explicitly stated.
> > > > > > > The following is taken from ISO 11783-5:
> > > > > > >=20
> > > > > > > In "4.4.4.3 Address violation" it states that "If a CF receiv=
es a message,
> > > > > > > other than the address-claimed message, which uses the CF=E2=
=80=99s own SA, then the
> > > > > > > CF [...] shall send the address-claim message to the Global a=
ddress."
> > > > > > >=20
> > > > > > > So the CF shall claim its address again. But further down, in=
 "4.5.2 Address
> > > > > > > claim requirements" it is stated that "...No CF shall begin, =
or resume,
> > > > > > > transmission on the network until 250 ms after it has success=
fully claimed an
> > > > > > > address".
> > > > > > >=20
> > > > > > > At this moment, the address is in dispute. The affected CFs a=
re not allowed to
> > > > > > > send any other messages until this dispute is resolved, and t=
he standard
> > > > > > > requires a waiting time of 250ms which is minimally deemed ne=
cessary to give
> > > > > > > all participants time to respond and eventually dispute the a=
ddress claim.
> > > > > > >=20
> > > > > > > If the offending CF ignores this dispute and keeps sending in=
correct messages
> > > > > > > faster than every 250ms, then effectively the other CF has no=
 chance to ever
> > > > > > > resume normal operation because its address is still disputed=
.
> > > > > > >=20
> > > > > > > According to 4.4.4.3 it is also required to set a DTC, but it=
 will not be
> > > > > > > allowed to send the DM1 message unless the address dispute is=
 resolved.
> > > > > > >=20
> > > > > > > This effectively leads to the offending CF to DoS the affecte=
d CF if it keeps
> > > > > > > sending offending messages. Unfortunately neither J1939 nor I=
SObus takes into
> > > > > > > account adversarial behavior on the CAN network, so we cannot=
 do anything
> > > > > > > about this.
> > > > > > >=20
> > > > > > > As for the ISObus compliance tool that is mentioned by Devid,=
 IMHO this
> > > > > > > compliance tool should be challenged and fixed, since it is b=
roken.
> > > > > > >=20
> > > > > > > The networking layer is prohibiting the DM1 message to be sen=
t, and the
> > > > > > > networking layer has precedence above all superior protocol l=
ayers, so the
> > > > > > > diagnostics layer is not able to operate at this moment.
> > > > > > >=20
> > > > > > > Best regards,
> > > > > > >=20
> > > > > > >    =20
> > > > > >=20
> > > > > > Hi David,
> > > > > >=20
> > > > > > I get your point but I'm not sure that it is the correct interp=
retation
> > > > > > that should be applied in this particular case for the followin=
g
> > > > > > reasons:
> > > > > >=20
> > > > > > - In "4.5.2 Address claim requirements" it is explicitly stated=
 that
> > > > > > "The CF shall claim its own address when initializing and when
> > > > > > responding to a command to change its NAME or address" and this=
 seems to =20
> > > > >=20
> > > > > The standard unfortunately has a track record of ignoring a lot o=
f scenarios
> > > > > and corner cases, like in this instance the fact that there can a=
ppear new
> > > > > participants on the bus _after_ initialization has long finished,=
 and it would
> > > > > need to claim its address again in that case.
> > > > >=20
> > > > > But look at point d) of that same section: "No CF shall begin, or=
 resume,
> > > > > transmission on the network until 250 ms after it has successfull=
y claimed an
> > > > > address (Figure 4). This does not apply when responding to a requ=
est for
> > > > > address claimed."
> > > > >=20
> > > > > So we basically have two situations when this will apply after th=
e network is
> > > > > up and running and a new node suddenly appears:
> > > > >=20
> > > > >  1. The new node starts with a "Request for address claimed" mess=
age, to
> > > > >  which your CF should respond with an "Address Claimed" message a=
nd NOT wait
> > > > >  250ms.
> > > > >=20
> > > > > or
> > > > >=20
> > > > >  2. The new node creates an addressing conflict either by claimin=
g its address
> > > > >  without first sending a "request for address claimed" message or=
 (and this is
> > > > >  your case) simply using its address without claiming it first.
> > > > >=20
> > > > > It is this second possibility where there is a conflict that must=
 be resolved,
> > > > > and then you must wait 250ms after claiming the conflicting addre=
ss for
> > > > > yourself.
> > > > >  =20
> > > > > > completely ignore the "4.4.4.3 Address violation" that states t=
hat the
> > > > > > address-claimed message shall be sent also when "the CF receive=
s a
> > > > > > message, other than the address-claimed message, which uses the=
 CF's own
> > > > > > SA".
> > > > > > Please note that the address was already claimed by the CF, so =
I think
> > > > > > that the initialization requirements should not apply in this c=
ase since
> > > > > > all disputes were already resolved. =20
> > > > >=20
> > > > > Well, yes and no. The address was claimed before, yes, but then a=
 new node came
> > > > > onto the bus and disputed that address. In that case the dispute =
needs to be
> > > > > resolved first. Imagine you would NOT wait 250ms, but the other C=
F did
> > > > > correctly claim its address, but it was you who did not receive t=
hat message
> > > > > for some reason. Now also assume that your own NAME has a lower p=
riority than
> > > > > the other CF. In this case you can send a "claimed address" messa=
ge to claim
> > > > > your address again, but it will be contested. If you don't wait f=
or the
> > > > > contestant, it is you who will be in violation of the protocol, b=
ecause you
> > > > > should have changed your own address but failed to do so.
> > > > >  =20
> > > > > > - If the offending CF ignores the dispute, as you said, then th=
e other
> > > > > > CF has no chance to ever resume normal operation and so the net=
work
> > > > > > cannot be aware that the other CF is not working correctly beca=
use the
> > > > > > offending CF is spoofing its own address. =20
> > > > >=20
> > > > > Correct. And like I said in my previous reply, this is unfortunat=
ely how CAN,
> > > > > J1939 and ISObus work. The whole network must cooperate and there=
 is no
> > > > > consideration for malign or adversarial actors.
> > > > > There are also a lot of possible corner cases that these standard=
s
> > > > > unfortunately do not take into account. Conformance test tools se=
em to be even
> > > > > more problematic and tend to have bugs quite often. I am still in=
clined to
> > > > > think this is the case with your test tool.
> > > > >  =20
> > > > > > This seems to make useless the
> > > > > > requirement that states to activate the DTC in "4.4.4.3 Address
> > > > > > violation". =20
> > > > >=20
> > > > > The requirement is not useless. You can still set and store the D=
TC, just not
> > > > > broadcast it to the network at that moment.
> > > > >=20
> > > > > Best regards,
> > > > >=20
> > > > >  =20
> > > >=20
> > > > Thank you for your feedback and explanation.
> > > > I asked the customer to contact the compliance company so that we c=
an
> > > > verify with them this particular use-case. I want to understand if =
there
> > > > is an application note or exception that states how to manage it or=
 if
> > > > they implemented the test basing it on their own interpretation and=
 how
> > > > it really works: supposing that the test does not check the DM1
> > > > presence, then the test could be passed even without sending the DM=
1
> > > > message during the 250ms after the adress-claimed message.
> > > >=20
> > > > Best regards,
> > > > Devid =20
> > >=20
> > > Hi David, all,
> > >=20
> > > I'm sorry for resuming this discussion after a long time but I notice=
d
> > > that the driver forces the 250 ms wait even when responding to a requ=
est
> > > for address-claimed which is against point d) of ISO 11783-5 "4.5.2
> > > Address claim requirements":
> > >=20
> > > No CF shall begin, or resume, transmission on the network until 250 m=
s
> > > after it has successfully claimed  an  address  (see Figure 4), excep=
t
> > > when responding to a request for address-claimed.
> > >=20
> > > IMHO the driver shall be able to detect above condition or shall not
> > > force the 250 ms wait which should then be implemented, depending on =
the
> > > case, on user-space application side.
> >=20
> > I am a bit out of the loop with this driver, but I think what you say i=
s
> > correct. The J1939 stack should NOT unconditionally stay silent for 250=
ms
> > after sending an Address Claimed message. It should specifically NOT do=
 so if
> > it is just responding to a Request for Address Claimed message.
> >=20
> > So if it is indeed so, that the J1939 stack will hold off sending messa=
ges
> > forcibly after sending an Address Claimed message as a reply to a Reque=
st for
> > Address Claimed, then I'd say this is a bug.
> >=20
> > @Oleksij, can you confirm this?
>=20
> I do not see any code path inside of the j1939 stack preventing sending
> you anything by address. The only part which cares about address
> claiming is net/can/j1939/address-claim.c and it will just not be able
> to resolve name to address, because address claiming was not finished
> jet. With other words, if you need to send responding to a request for
> address-claimed, then just send it by using address instead of name.
>=20
> Regards,
> Oleksij

Hi Oleksij,
I'm sorry but I think I don't understand your proposal.

If I send an address-claimed message binding the socket without the name
(can_addr.j1939.name =3D J1939_NO_NAME), then the driver returns error
EPROTO.
If I send the address-claimed message binding the socket with the name,
then the address-claimed message is sent successfully but other messages
sent within 250 ms are not sent (error EADDRNOTAVAIL).

Thank you,
Devid

