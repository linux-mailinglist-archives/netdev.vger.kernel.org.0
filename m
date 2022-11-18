Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC59862F901
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242181AbiKRPM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241828AbiKRPMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:12:50 -0500
Received: from smtpweb146.aruba.it (smtpweb146.aruba.it [62.149.158.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19D9430F6B
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 07:12:44 -0800 (PST)
Received: from [192.168.1.212] ([213.215.163.55])
        by Aruba Outgoing Smtp  with ESMTPSA
        id w32mowAMd6tF6w32modf3L; Fri, 18 Nov 2022 16:12:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1668784363; bh=VDJVaX92E3gQVAvjOH+k999g8gO5VtIcEP0iaOfx2eE=;
        h=Subject:From:To:Date:Content-Type:MIME-Version;
        b=EQC2/a77j/3Lfh0rlg4pwgRVel1QJNOuC2/g612zQv2+ZQSPOD/JNEJykAzXuylX6
         /AQIbdUaQigcX5hc2DVeIEWNrvkRpiEaN9BUB7B1wJ5HU9nD0wmOyvsnDo+ejZzROc
         vGoaFeYSLTTwIUBNNV3f7mGEt2tNBX5odHAXNxzCfT6kw38yQ4Wf/0LSs/UnXmHytF
         1phrLxcEFBrohxCXr4miiZLkKsuzzrqL6AMwyptQM+rSLeE0eYbyR0SBQEp35FSCKr
         S0VywLv7TBGXNUCCd73UxRrOe9iWMvIRaBDwQrzEPZgnoHjH4idTiQ2UqrZCJMLEX2
         ILc6lK4obG8cA==
Message-ID: <a01fe547c052e861d47089d6767aba639250adda.camel@egluetechnologies.com>
Subject: Re: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr
 was already claimed
From:   Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        kbuild test robot <lkp@intel.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        Robin van der Gracht <robin@protonic.nl>,
        linux-kernel@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date:   Fri, 18 Nov 2022 16:12:40 +0100
In-Reply-To: <20221118134447.GG12278@pengutronix.de>
References: <20220511110649.21cc1f65@erd992>
         <baaf0b8b237a2e6a8f99faca60112919d79cf549.camel@egluetechnologies.com>
         <20220511162247.2cf3fb2e@erd992>
         <3566cba652c64641603fd0ad477e2c90cd77655b.camel@egluetechnologies.com>
         <e0f6b26e2c724439752f3c13b53af1a56a42a5bf.camel@egluetechnologies.com>
         <20221117162251.5e5933c1@erd992> <20221118060647.GE12278@pengutronix.de>
         <7b575cface09a2817ac53485507985a7fef7b835.camel@egluetechnologies.com>
         <20221118123013.GF12278@pengutronix.de>
         <1fd663d232c7fba5f956faf1ad45fb410a675086.camel@egluetechnologies.com>
         <20221118134447.GG12278@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-CMAE-Envelope: MS4xfF4kX13jAFgiVoob0DvrO6hc37B5lZS6dQq4nPQ0Mohuz7e8DAPiZwhV+R971xa3QZKgm0PtR+L/CeRC8Qhn0CmWn5PNaJPtYzTnuE5EiNQ6G3jHZo0s
 8+ZSgnscFaNGKQtNBJbBRG2vmF6TkDX5NOyyyy+WAwYv9BmKyehotiMTxMogp7h4z9s8+ZCyT/C/QCf/DsITVz4JURUn6I0I7yPVacWEary0L7U1b8djADPc
 OtbI83W7Gn+nekubRGffzR6Vm2APpFEBVH3NTLMteTCp27gK0JulaMWuuL336zkszY2Mew3MVIp90QOvgVghvotaZzNwxjZUxZsr2ibfdR1KNFNn60CB/6/O
 +VSeVxB/BOQM7WyseW8wqActbHJnTfAEcQ1oruC5VDn+pikZiBPOSzql8xP2oeLyCFI7XABLQ1tNLUiWjsejg/UCKPRDBS9ZzBPx5Sf2uuiO2Y4TFay4nQzA
 FtHWpFxdAGHCd0YCz7BuN6F5WRkgETfsDGKTHN/iE1pUblEo1QeeocuEAJn19j5cmjSZNEt9A/35oStCrrRZNIkxRa82h/WatpCHrpugAHYQhSPesluK0QEb
 /P5wfe8M8gTEtXlvdz7VfXjIBJEp6Gg3lO1x0ouaQYrVXqt2JzhM8sCeirjtLB7+jteFvv7AVSc6o0zI7YfOEMeaV26pH/iSGYCSyID2oyqVsqPI3UoM4VPK
 pl1yEkX8ZSU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-18 at 14:44 +0100, Oleksij Rempel wrote:
> On Fri, Nov 18, 2022 at 01:41:05PM +0100, Devid Antonio Filoni wrote:
> > On Fri, 2022-11-18 at 13:30 +0100, Oleksij Rempel wrote:
> > > On Fri, Nov 18, 2022 at 11:25:04AM +0100, Devid Antonio Filoni wrote:
> > > > On Fri, 2022-11-18 at 07:06 +0100, Oleksij Rempel wrote:
> > > > > On Thu, Nov 17, 2022 at 04:22:51PM +0100, David Jander wrote:
> > > > > > On Thu, 17 Nov 2022 15:08:20 +0100
> > > > > > Devid Antonio Filoni <devid.filoni@egluetechnologies.com> wrote=
:
> > > > > >=20
> > > > > > > On Fri, 2022-05-13 at 11:46 +0200, Devid Antonio Filoni wrote=
:
> > > > > > > > Hi David,
> > > > > > > >=20
> > > > > > > > On Wed, 2022-05-11 at 16:22 +0200, David Jander wrote: =20
> > > > > > > > > Hi Devid,
> > > > > > > > >=20
> > > > > > > > > On Wed, 11 May 2022 14:55:04 +0200
> > > > > > > > > Devid Antonio Filoni <
> > > > > > > > > devid.filoni@egluetechnologies.com =20
> > > > > > > > > > wrote: =20
> > > > > > > > >  =20
> > > > > > > > > > On Wed, 2022-05-11 at 11:06 +0200, David Jander wrote: =
=20
> > > > > > > > > > > Hi,
> > > > > > > > > > >=20
> > > > > > > > > > > On Wed, 11 May 2022 10:47:28 +0200
> > > > > > > > > > > Oleksij Rempel <
> > > > > > > > > > > o.rempel@pengutronix.de
> > > > > > > > > > >    =20
> > > > > > > > > > > > wrote:   =20
> > > > > > > > > > >=20
> > > > > > > > > > >    =20
> > > > > > > > > > > > Hi,
> > > > > > > > > > > >=20
> > > > > > > > > > > > i'll CC more J1939 users to the discussion.   =20
> > > > > > > > > > >=20
> > > > > > > > > > > Thanks for the CC.
> > > > > > > > > > >    =20
> > > > > > > > > > > > On Tue, May 10, 2022 at 01:00:41PM +0200, Devid Ant=
onio Filoni wrote:   =20
> > > > > > > > > > > > > Hi,
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > On Tue, 2022-05-10 at 06:26 +0200, Oleksij Rempel=
 wrote:     =20
> > > > > > > > > > > > > > Hi,
> > > > > > > > > > > > > >=20
> > > > > > > > > > > > > > On Mon, May 09, 2022 at 09:04:06PM +0200, Kurt =
Van Dijck wrote:     =20
> > > > > > > > > > > > > > > On ma, 09 mei 2022 19:03:03 +0200, Devid Anto=
nio Filoni wrote:     =20
> > > > > > > > > > > > > > > > This is not explicitly stated in SAE J1939-=
21 and some tools used for
> > > > > > > > > > > > > > > > ISO-11783 certification do not expect this =
wait.     =20
> > > > > > > > > > > > > >=20
> > > > > > > > > > > > > > It will be interesting to know which certificat=
ion tool do not expect it and
> > > > > > > > > > > > > > what explanation is used if it fails?
> > > > > > > > > > > > > >      =20
> > > > > > > > > > > > > > > IMHO, the current behaviour is not explicitel=
y stated, but nor is the opposite.
> > > > > > > > > > > > > > > And if I'm not mistaken, this introduces a 25=
0msec delay.
> > > > > > > > > > > > > > >=20
> > > > > > > > > > > > > > > 1. If you want to avoid the 250msec gap, you =
should avoid to contest the same address.
> > > > > > > > > > > > > > >=20
> > > > > > > > > > > > > > > 2. It's a balance between predictability and =
flexibility, but if you try to accomplish both,
> > > > > > > > > > > > > > > as your patch suggests, there is slight time-=
window until the current owner responds,
> > > > > > > > > > > > > > > in which it may be confusing which node has t=
he address. It depends on how much history
> > > > > > > > > > > > > > > you have collected on the bus.
> > > > > > > > > > > > > > >=20
> > > > > > > > > > > > > > > I'm sure that this problem decreases with inc=
reasing processing power on the nodes,
> > > > > > > > > > > > > > > but bigger internal queues also increase this=
 window.
> > > > > > > > > > > > > > >=20
> > > > > > > > > > > > > > > It would certainly help if you describe how t=
he current implementation fails.
> > > > > > > > > > > > > > >=20
> > > > > > > > > > > > > > > Would decreasing the dead time to 50msec help=
 in such case.
> > > > > > > > > > > > > > >=20
> > > > > > > > > > > > > > > Kind regards,
> > > > > > > > > > > > > > > Kurt
> > > > > > > > > > > > > > >      =20
> > > > > > > > > > > > > >=20
> > > > > > > > > > > > > >      =20
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > The test that is being executed during the ISOBUS=
 compliance is the
> > > > > > > > > > > > > following: after an address has been claimed by a=
 CF (#1), another CF
> > > > > > > > > > > > > (#2) sends a  message (other than address-claim) =
using the same address
> > > > > > > > > > > > > claimed by CF #1.
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > As per ISO11783-5 standard, if a CF receives a me=
ssage, other than the
> > > > > > > > > > > > > address-claimed message, which uses the CF's own =
SA, then the CF (#1):
> > > > > > > > > > > > > - shall send the address-claim message to the Glo=
bal address;
> > > > > > > > > > > > > - shall activate a diagnostic trouble code with S=
PN =3D 2000+SA and FMI =3D
> > > > > > > > > > > > > 31
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > After the address-claim message is sent by CF #1,=
 as per ISO11783-5
> > > > > > > > > > > > > standard:
> > > > > > > > > > > > > - If the name of the CF #1 has a lower priority t=
hen the one of the CF
> > > > > > > > > > > > > #2, the the CF #2 shall send its address-claim me=
ssage and thus the CF
> > > > > > > > > > > > > #1 shall send the cannot-claim-address message or=
 shall execute again
> > > > > > > > > > > > > the claim procedure with a new address
> > > > > > > > > > > > > - If the name of the CF #1 has higher priority th=
en the of the CF #2,
> > > > > > > > > > > > > then the CF #2 shall send the cannot-claim-addres=
s message or shall
> > > > > > > > > > > > > execute the claim procedure with a new address
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > Above conflict management is OK with current J193=
9 driver
> > > > > > > > > > > > > implementation, however, since the driver always =
waits 250ms after
> > > > > > > > > > > > > sending an address-claim message, the CF #1 canno=
t set the DTC. The DM1
> > > > > > > > > > > > > message which is expected to be sent each second =
(as per J1939-73
> > > > > > > > > > > > > standard) may not be sent.
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > Honestly, I don't know which company is doing the=
 ISOBUS compliance
> > > > > > > > > > > > > tests on our products and which tool they use as =
it was choosen by our
> > > > > > > > > > > > > customer, however they did send us some CAN trace=
s of previously
> > > > > > > > > > > > > performed tests and we noticed that the DM1 messa=
ge is sent 160ms after
> > > > > > > > > > > > > the address-claim message (but it may also be low=
er then that), and this
> > > > > > > > > > > > > is something that we cannot do because the driver=
 blocks the application
> > > > > > > > > > > > > from sending it.
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > 28401.127146 1  18E6FFF0x    Tx   d 8 FE 26 FF FF=
 FF FF FF FF  //Message
> > > > > > > > > > > > > with other CF's address
> > > > > > > > > > > > > 28401.167414 1  18EEFFF0x    Rx   d 8 15 76 D1 0B=
 00 86 00 A0  //Address
> > > > > > > > > > > > > Claim - SA =3D F0
> > > > > > > > > > > > > 28401.349214 1  18FECAF0x    Rx   d 8 FF FF C0 08=
 1F 01 FF FF  //DM1
> > > > > > > > > > > > > 28402.155774 1  18E6FFF0x    Tx   d 8 FE 26 FF FF=
 FF FF FF FF  //Message
> > > > > > > > > > > > > with other CF's address
> > > > > > > > > > > > > 28402.169455 1  18EEFFF0x    Rx   d 8 15 76 D1 0B=
 00 86 00 A0  //Address
> > > > > > > > > > > > > Claim - SA =3D F0
> > > > > > > > > > > > > 28402.348226 1  18FECAF0x    Rx   d 8 FF FF C0 08=
 1F 02 FF FF  //DM1
> > > > > > > > > > > > > 28403.182753 1  18E6FFF0x    Tx   d 8 FE 26 FF FF=
 FF FF FF FF  //Message
> > > > > > > > > > > > > with other CF's address
> > > > > > > > > > > > > 28403.188648 1  18EEFFF0x    Rx   d 8 15 76 D1 0B=
 00 86 00 A0  //Address
> > > > > > > > > > > > > Claim - SA =3D F0
> > > > > > > > > > > > > 28403.349328 1  18FECAF0x    Rx   d 8 FF FF C0 08=
 1F 03 FF FF  //DM1
> > > > > > > > > > > > > 28404.349406 1  18FECAF0x    Rx   d 8 FF FF C0 08=
 1F 03 FF FF  //DM1
> > > > > > > > > > > > > 28405.349740 1  18FECAF0x    Rx   d 8 FF FF C0 08=
 1F 03 FF FF  //DM1
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > Since the 250ms wait is not explicitly stated, IM=
HO it should be up to
> > > > > > > > > > > > > the user-space implementation to decide how to ma=
nage it.   =20
> > > > > > > > > > >=20
> > > > > > > > > > > I think this is not entirely correct. AFAICS the 250m=
s wait is indeed
> > > > > > > > > > > explicitly stated.
> > > > > > > > > > > The following is taken from ISO 11783-5:
> > > > > > > > > > >=20
> > > > > > > > > > > In "4.4.4.3 Address violation" it states that "If a C=
F receives a message,
> > > > > > > > > > > other than the address-claimed message, which uses th=
e CF=E2=80=99s own SA, then the
> > > > > > > > > > > CF [...] shall send the address-claim message to the =
Global address."
> > > > > > > > > > >=20
> > > > > > > > > > > So the CF shall claim its address again. But further =
down, in "4.5.2 Address
> > > > > > > > > > > claim requirements" it is stated that "...No CF shall=
 begin, or resume,
> > > > > > > > > > > transmission on the network until 250 ms after it has=
 successfully claimed an
> > > > > > > > > > > address".
> > > > > > > > > > >=20
> > > > > > > > > > > At this moment, the address is in dispute. The affect=
ed CFs are not allowed to
> > > > > > > > > > > send any other messages until this dispute is resolve=
d, and the standard
> > > > > > > > > > > requires a waiting time of 250ms which is minimally d=
eemed necessary to give
> > > > > > > > > > > all participants time to respond and eventually dispu=
te the address claim.
> > > > > > > > > > >=20
> > > > > > > > > > > If the offending CF ignores this dispute and keeps se=
nding incorrect messages
> > > > > > > > > > > faster than every 250ms, then effectively the other C=
F has no chance to ever
> > > > > > > > > > > resume normal operation because its address is still =
disputed.
> > > > > > > > > > >=20
> > > > > > > > > > > According to 4.4.4.3 it is also required to set a DTC=
, but it will not be
> > > > > > > > > > > allowed to send the DM1 message unless the address di=
spute is resolved.
> > > > > > > > > > >=20
> > > > > > > > > > > This effectively leads to the offending CF to DoS the=
 affected CF if it keeps
> > > > > > > > > > > sending offending messages. Unfortunately neither J19=
39 nor ISObus takes into
> > > > > > > > > > > account adversarial behavior on the CAN network, so w=
e cannot do anything
> > > > > > > > > > > about this.
> > > > > > > > > > >=20
> > > > > > > > > > > As for the ISObus compliance tool that is mentioned b=
y Devid, IMHO this
> > > > > > > > > > > compliance tool should be challenged and fixed, since=
 it is broken.
> > > > > > > > > > >=20
> > > > > > > > > > > The networking layer is prohibiting the DM1 message t=
o be sent, and the
> > > > > > > > > > > networking layer has precedence above all superior pr=
otocol layers, so the
> > > > > > > > > > > diagnostics layer is not able to operate at this mome=
nt.
> > > > > > > > > > >=20
> > > > > > > > > > > Best regards,
> > > > > > > > > > >=20
> > > > > > > > > > >    =20
> > > > > > > > > >=20
> > > > > > > > > > Hi David,
> > > > > > > > > >=20
> > > > > > > > > > I get your point but I'm not sure that it is the correc=
t interpretation
> > > > > > > > > > that should be applied in this particular case for the =
following
> > > > > > > > > > reasons:
> > > > > > > > > >=20
> > > > > > > > > > - In "4.5.2 Address claim requirements" it is explicitl=
y stated that
> > > > > > > > > > "The CF shall claim its own address when initializing a=
nd when
> > > > > > > > > > responding to a command to change its NAME or address" =
and this seems to =20
> > > > > > > > >=20
> > > > > > > > > The standard unfortunately has a track record of ignoring=
 a lot of scenarios
> > > > > > > > > and corner cases, like in this instance the fact that the=
re can appear new
> > > > > > > > > participants on the bus _after_ initialization has long f=
inished, and it would
> > > > > > > > > need to claim its address again in that case.
> > > > > > > > >=20
> > > > > > > > > But look at point d) of that same section: "No CF shall b=
egin, or resume,
> > > > > > > > > transmission on the network until 250 ms after it has suc=
cessfully claimed an
> > > > > > > > > address (Figure 4). This does not apply when responding t=
o a request for
> > > > > > > > > address claimed."
> > > > > > > > >=20
> > > > > > > > > So we basically have two situations when this will apply =
after the network is
> > > > > > > > > up and running and a new node suddenly appears:
> > > > > > > > >=20
> > > > > > > > >  1. The new node starts with a "Request for address claim=
ed" message, to
> > > > > > > > >  which your CF should respond with an "Address Claimed" m=
essage and NOT wait
> > > > > > > > >  250ms.
> > > > > > > > >=20
> > > > > > > > > or
> > > > > > > > >=20
> > > > > > > > >  2. The new node creates an addressing conflict either by=
 claiming its address
> > > > > > > > >  without first sending a "request for address claimed" me=
ssage or (and this is
> > > > > > > > >  your case) simply using its address without claiming it =
first.
> > > > > > > > >=20
> > > > > > > > > It is this second possibility where there is a conflict t=
hat must be resolved,
> > > > > > > > > and then you must wait 250ms after claiming the conflicti=
ng address for
> > > > > > > > > yourself.
> > > > > > > > >  =20
> > > > > > > > > > completely ignore the "4.4.4.3 Address violation" that =
states that the
> > > > > > > > > > address-claimed message shall be sent also when "the CF=
 receives a
> > > > > > > > > > message, other than the address-claimed message, which =
uses the CF's own
> > > > > > > > > > SA".
> > > > > > > > > > Please note that the address was already claimed by the=
 CF, so I think
> > > > > > > > > > that the initialization requirements should not apply i=
n this case since
> > > > > > > > > > all disputes were already resolved. =20
> > > > > > > > >=20
> > > > > > > > > Well, yes and no. The address was claimed before, yes, bu=
t then a new node came
> > > > > > > > > onto the bus and disputed that address. In that case the =
dispute needs to be
> > > > > > > > > resolved first. Imagine you would NOT wait 250ms, but the=
 other CF did
> > > > > > > > > correctly claim its address, but it was you who did not r=
eceive that message
> > > > > > > > > for some reason. Now also assume that your own NAME has a=
 lower priority than
> > > > > > > > > the other CF. In this case you can send a "claimed addres=
s" message to claim
> > > > > > > > > your address again, but it will be contested. If you don'=
t wait for the
> > > > > > > > > contestant, it is you who will be in violation of the pro=
tocol, because you
> > > > > > > > > should have changed your own address but failed to do so.
> > > > > > > > >  =20
> > > > > > > > > > - If the offending CF ignores the dispute, as you said,=
 then the other
> > > > > > > > > > CF has no chance to ever resume normal operation and so=
 the network
> > > > > > > > > > cannot be aware that the other CF is not working correc=
tly because the
> > > > > > > > > > offending CF is spoofing its own address. =20
> > > > > > > > >=20
> > > > > > > > > Correct. And like I said in my previous reply, this is un=
fortunately how CAN,
> > > > > > > > > J1939 and ISObus work. The whole network must cooperate a=
nd there is no
> > > > > > > > > consideration for malign or adversarial actors.
> > > > > > > > > There are also a lot of possible corner cases that these =
standards
> > > > > > > > > unfortunately do not take into account. Conformance test =
tools seem to be even
> > > > > > > > > more problematic and tend to have bugs quite often. I am =
still inclined to
> > > > > > > > > think this is the case with your test tool.
> > > > > > > > >  =20
> > > > > > > > > > This seems to make useless the
> > > > > > > > > > requirement that states to activate the DTC in "4.4.4.3=
 Address
> > > > > > > > > > violation". =20
> > > > > > > > >=20
> > > > > > > > > The requirement is not useless. You can still set and sto=
re the DTC, just not
> > > > > > > > > broadcast it to the network at that moment.
> > > > > > > > >=20
> > > > > > > > > Best regards,
> > > > > > > > >=20
> > > > > > > > >  =20
> > > > > > > >=20
> > > > > > > > Thank you for your feedback and explanation.
> > > > > > > > I asked the customer to contact the compliance company so t=
hat we can
> > > > > > > > verify with them this particular use-case. I want to unders=
tand if there
> > > > > > > > is an application note or exception that states how to mana=
ge it or if
> > > > > > > > they implemented the test basing it on their own interpreta=
tion and how
> > > > > > > > it really works: supposing that the test does not check the=
 DM1
> > > > > > > > presence, then the test could be passed even without sendin=
g the DM1
> > > > > > > > message during the 250ms after the adress-claimed message.
> > > > > > > >=20
> > > > > > > > Best regards,
> > > > > > > > Devid =20
> > > > > > >=20
> > > > > > > Hi David, all,
> > > > > > >=20
> > > > > > > I'm sorry for resuming this discussion after a long time but =
I noticed
> > > > > > > that the driver forces the 250 ms wait even when responding t=
o a request
> > > > > > > for address-claimed which is against point d) of ISO 11783-5 =
"4.5.2
> > > > > > > Address claim requirements":
> > > > > > >=20
> > > > > > > No CF shall begin, or resume, transmission on the network unt=
il 250 ms
> > > > > > > after it has successfully claimed  an  address  (see Figure 4=
), except
> > > > > > > when responding to a request for address-claimed.
> > > > > > >=20
> > > > > > > IMHO the driver shall be able to detect above condition or sh=
all not
> > > > > > > force the 250 ms wait which should then be implemented, depen=
ding on the
> > > > > > > case, on user-space application side.
> > > > > >=20
> > > > > > I am a bit out of the loop with this driver, but I think what y=
ou say is
> > > > > > correct. The J1939 stack should NOT unconditionally stay silent=
 for 250ms
> > > > > > after sending an Address Claimed message. It should specificall=
y NOT do so if
> > > > > > it is just responding to a Request for Address Claimed message.
> > > > > >=20
> > > > > > So if it is indeed so, that the J1939 stack will hold off sendi=
ng messages
> > > > > > forcibly after sending an Address Claimed message as a reply to=
 a Request for
> > > > > > Address Claimed, then I'd say this is a bug.
> > > > > >=20
> > > > > > @Oleksij, can you confirm this?
> > > > >=20
> > > > > I do not see any code path inside of the j1939 stack preventing s=
ending
> > > > > you anything by address. The only part which cares about address
> > > > > claiming is net/can/j1939/address-claim.c and it will just not be=
 able
> > > > > to resolve name to address, because address claiming was not fini=
shed
> > > > > jet. With other words, if you need to send responding to a reques=
t for
> > > > > address-claimed, then just send it by using address instead of na=
me.
> > > > >=20
> > > > > Regards,
> > > > > Oleksij
> > > >=20
> > > > Hi Oleksij,
> > > > I'm sorry but I think I don't understand your proposal.
> > > >=20
> > > > If I send an address-claimed message binding the socket without the=
 name
> > > > (can_addr.j1939.name =3D J1939_NO_NAME), then the driver returns er=
ror
> > > > EPROTO.
> > > > If I send the address-claimed message binding the socket with the n=
ame,
> > > > then the address-claimed message is sent successfully but other mes=
sages
> > > > sent within 250 ms are not sent (error EADDRNOTAVAIL).
> > >=20
> > > What kind of other messages are your trying to send?
> > >=20
> > > Regards,
> > > Oleksij
> >=20
> > Hi,
> > the application sends each second the DM1 (0xFECA), meanwhile it
> > receives an request for address-claimed message and it answers with the
> > address-claimed message.
> > If the DM1 is sent within 250 ms after the address-claimed message, the=
n
> > it is rejected with error EADDRNOTAVAIL.
> > Since the driver is performing the claim each time the address-claimed
> > message is sent (even if it is a response to a request for address-
> > claimed), the EADDRNOTAVAIL error is expected in the 250 ms time window=
.
> > So, when a request for address-claimed message is received:
> > - You cannot send an address-claimed message with the socket bound with
> > J1939_NO_NAME because it is rejected with error EPROTO
> > - You can send an address-claimed message with the socket bound with th=
e
> > name but you won't be able to send other messages within 250 ms because
> > they are rejected with error EADDRNOTAVAIL and this is against point d)
> > of ISO 11783-5 "4.5.2 Address claim requirements".
>=20
> Ok, finally I understood it.
>=20
> If I see it correctly, it is hard to fix second part of "ISO 11783-5
>  4.5.2 d)" without breaking first part of the same point.
>=20
> Haw can I see the difference between AC and AC send as response for RfAC?
> Wait 250ms? What if some system starts just in this time and will send
> plain AC?
>=20
> Regards,
> Oleksij

Hi Oleksij,

honestly I would apply proposed patch because it is the easier solution
and makes the driver compliant with the standard for the following
reasons:
- on the first claim, the kernel will wait 250 ms as stated by the
standard
+ on successive claims with the same name, the kernel will not wait
250ms, this implies:
  - it will not wait after sending the address-claimed message when the
claimed address has been spoofed, but the standard does not explicitly
states what to do in this case (see previous emails in this thread), so
it would be up to the application developer to decide how to manage the
conflict
  - it will not wait after sending the address-claimed message when a
request for address-claimed message has been received as stated by the
standard

Otherwise you will have to keep track of above cases and decide if the
wait is needed or not, but this is hard do accomplish because is the
application in charge of sending the address-claimed message, so you
would have to decide how much to keep track of the request for address-
claimed message thus adding more complexity to the code of the driver.

Another solution is to let the driver send the address-claimed message
waiting or without waiting 250 ms for successive messages depending on
the case.

Best Regards,
Devid

