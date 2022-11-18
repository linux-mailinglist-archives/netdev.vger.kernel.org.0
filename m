Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09E362F52C
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241947AbiKRMlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241934AbiKRMlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:41:17 -0500
Received: from smtpweb147.aruba.it (smtpweb147.aruba.it [62.149.158.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 691E08CFD1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 04:41:09 -0800 (PST)
Received: from [192.168.1.212] ([213.215.163.55])
        by Aruba Outgoing Smtp  with ESMTPSA
        id w0g6ou7bH6tF6w0g6obq5p; Fri, 18 Nov 2022 13:41:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1668775268; bh=eIwlHoEQl9IgIYdRWwsKfMQcgKOOJVN8kc4hA9T9nE8=;
        h=Subject:From:To:Date:Content-Type:MIME-Version;
        b=BnNsRAIMKiLy32FYLyOIhK5sJX0Nj3uaGeINcZE65DiYdM5rkykjtrNlDvrpAR5C2
         ytAfhuyEbq6DsKfGAx7C3+KpB917BRGh5Wq6MNymlq1ctohKuLORUf5Qvbtb7gbWCC
         KF4XCbqHI6kv5+mbY3FKfUpb5PkmRkbDv0+7Y6WEOWTz23oBQOrC32zj6FHkeTyUGi
         oe+JfSaHy+lXDy3lFxTAR87VP5H5wCpbIbXERt1JFiCWaoEcIwMnznRLEMf2yyCDrw
         8/3W3FvCIciawBExNj9ZwbnCbDBaVQZdKUW001uMxKrND0yapdJ73f3aJsBffYbgX9
         QMAJGrXpQI+5A==
Message-ID: <1fd663d232c7fba5f956faf1ad45fb410a675086.camel@egluetechnologies.com>
Subject: Re: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr
 was already claimed
From:   Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     David Jander <david@protonic.nl>,
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
Date:   Fri, 18 Nov 2022 13:41:05 +0100
In-Reply-To: <20221118123013.GF12278@pengutronix.de>
References: <ce7da10389fe448efee86d788dd5282b8022f92e.camel@egluetechnologies.com>
         <20220511084728.GD10669@pengutronix.de> <20220511110649.21cc1f65@erd992>
         <baaf0b8b237a2e6a8f99faca60112919d79cf549.camel@egluetechnologies.com>
         <20220511162247.2cf3fb2e@erd992>
         <3566cba652c64641603fd0ad477e2c90cd77655b.camel@egluetechnologies.com>
         <e0f6b26e2c724439752f3c13b53af1a56a42a5bf.camel@egluetechnologies.com>
         <20221117162251.5e5933c1@erd992> <20221118060647.GE12278@pengutronix.de>
         <7b575cface09a2817ac53485507985a7fef7b835.camel@egluetechnologies.com>
         <20221118123013.GF12278@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-CMAE-Envelope: MS4xfASIxw+FOER1kKjGLbepsd5KAhupyDuNOxtvbHMo9LWrA0BsKcGQMiZWppG8ylvQB78co+JLFA8opDhkzvcdzaZQJpYwhylwbl4b+uryyXHUAb+Rylxj
 6hhmzLhLpn7GSex+APZLtoJfWC2I5ue2EPMBAstiWS4VVUt8NQ+1YdKQKvlQpgo6tG7upBBgIs7+ctbACX03NEtA8mJKuB5krWLrFSeGZB7SvNkDirLyQ2E4
 nQeX06pGAOySi7pQ7BCZXOqeLpFHHpim+lc1SE9eCTGEwA1bRnSxkhaD43ck4wFnFjk+gRmyEVRjDJ8zWjeoJW2iH97JlmPL5BJHN76qwSsYod+QJHIIAbBs
 Azp0Lpyi0FQ7BCs5Q1f7TG3Iudu860Vq1pRJWKwFAtQRk2dEWgnENM4xLQTqcMs/lPOhDVhRS5/mLEX6HFXwsbLmtUAw3jBp0A1IDPwEqZ1K9+WukZ5iXYch
 tKcWGY+ggBqtW36sVqtFRL+9KITL4jhHLJfP8Jh1qe2Wo1ZnxuOoHC5/bhsTOPdeUcSixhu/jqrjP+4Szq0U8dyf/3R2AUZzv6n0H7Tn/9WzK2BTXnT7wZEK
 3Gi0PRjBAcO2wZxvMhV+WIVCKezCfJQoewahYeUcThE0fkMFZWEzJqqXkvhwP0Wm0JtTY9IdiApTxPPsHHjGYtr0F1ViOZkL9RzBX2BMsbWV+CC9DzBummrG
 weFrwKEnZwk=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-18 at 13:30 +0100, Oleksij Rempel wrote:
> On Fri, Nov 18, 2022 at 11:25:04AM +0100, Devid Antonio Filoni wrote:
> > On Fri, 2022-11-18 at 07:06 +0100, Oleksij Rempel wrote:
> > > On Thu, Nov 17, 2022 at 04:22:51PM +0100, David Jander wrote:
> > > > On Thu, 17 Nov 2022 15:08:20 +0100
> > > > Devid Antonio Filoni <devid.filoni@egluetechnologies.com> wrote:
> > > >=20
> > > > > On Fri, 2022-05-13 at 11:46 +0200, Devid Antonio Filoni wrote:
> > > > > > Hi David,
> > > > > >=20
> > > > > > On Wed, 2022-05-11 at 16:22 +0200, David Jander wrote: =20
> > > > > > > Hi Devid,
> > > > > > >=20
> > > > > > > On Wed, 11 May 2022 14:55:04 +0200
> > > > > > > Devid Antonio Filoni <
> > > > > > > devid.filoni@egluetechnologies.com =20
> > > > > > > > wrote: =20
> > > > > > >  =20
> > > > > > > > On Wed, 2022-05-11 at 11:06 +0200, David Jander wrote: =20
> > > > > > > > > Hi,
> > > > > > > > >=20
> > > > > > > > > On Wed, 11 May 2022 10:47:28 +0200
> > > > > > > > > Oleksij Rempel <
> > > > > > > > > o.rempel@pengutronix.de
> > > > > > > > >    =20
> > > > > > > > > > wrote:   =20
> > > > > > > > >=20
> > > > > > > > >    =20
> > > > > > > > > > Hi,
> > > > > > > > > >=20
> > > > > > > > > > i'll CC more J1939 users to the discussion.   =20
> > > > > > > > >=20
> > > > > > > > > Thanks for the CC.
> > > > > > > > >    =20
> > > > > > > > > > On Tue, May 10, 2022 at 01:00:41PM +0200, Devid Antonio=
 Filoni wrote:   =20
> > > > > > > > > > > Hi,
> > > > > > > > > > >=20
> > > > > > > > > > > On Tue, 2022-05-10 at 06:26 +0200, Oleksij Rempel wro=
te:     =20
> > > > > > > > > > > > Hi,
> > > > > > > > > > > >=20
> > > > > > > > > > > > On Mon, May 09, 2022 at 09:04:06PM +0200, Kurt Van =
Dijck wrote:     =20
> > > > > > > > > > > > > On ma, 09 mei 2022 19:03:03 +0200, Devid Antonio =
Filoni wrote:     =20
> > > > > > > > > > > > > > This is not explicitly stated in SAE J1939-21 a=
nd some tools used for
> > > > > > > > > > > > > > ISO-11783 certification do not expect this wait=
.     =20
> > > > > > > > > > > >=20
> > > > > > > > > > > > It will be interesting to know which certification =
tool do not expect it and
> > > > > > > > > > > > what explanation is used if it fails?
> > > > > > > > > > > >      =20
> > > > > > > > > > > > > IMHO, the current behaviour is not explicitely st=
ated, but nor is the opposite.
> > > > > > > > > > > > > And if I'm not mistaken, this introduces a 250mse=
c delay.
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > 1. If you want to avoid the 250msec gap, you shou=
ld avoid to contest the same address.
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > 2. It's a balance between predictability and flex=
ibility, but if you try to accomplish both,
> > > > > > > > > > > > > as your patch suggests, there is slight time-wind=
ow until the current owner responds,
> > > > > > > > > > > > > in which it may be confusing which node has the a=
ddress. It depends on how much history
> > > > > > > > > > > > > you have collected on the bus.
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > I'm sure that this problem decreases with increas=
ing processing power on the nodes,
> > > > > > > > > > > > > but bigger internal queues also increase this win=
dow.
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > It would certainly help if you describe how the c=
urrent implementation fails.
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > Would decreasing the dead time to 50msec help in =
such case.
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > Kind regards,
> > > > > > > > > > > > > Kurt
> > > > > > > > > > > > >      =20
> > > > > > > > > > > >=20
> > > > > > > > > > > >      =20
> > > > > > > > > > >=20
> > > > > > > > > > > The test that is being executed during the ISOBUS com=
pliance is the
> > > > > > > > > > > following: after an address has been claimed by a CF =
(#1), another CF
> > > > > > > > > > > (#2) sends a  message (other than address-claim) usin=
g the same address
> > > > > > > > > > > claimed by CF #1.
> > > > > > > > > > >=20
> > > > > > > > > > > As per ISO11783-5 standard, if a CF receives a messag=
e, other than the
> > > > > > > > > > > address-claimed message, which uses the CF's own SA, =
then the CF (#1):
> > > > > > > > > > > - shall send the address-claim message to the Global =
address;
> > > > > > > > > > > - shall activate a diagnostic trouble code with SPN =
=3D 2000+SA and FMI =3D
> > > > > > > > > > > 31
> > > > > > > > > > >=20
> > > > > > > > > > > After the address-claim message is sent by CF #1, as =
per ISO11783-5
> > > > > > > > > > > standard:
> > > > > > > > > > > - If the name of the CF #1 has a lower priority then =
the one of the CF
> > > > > > > > > > > #2, the the CF #2 shall send its address-claim messag=
e and thus the CF
> > > > > > > > > > > #1 shall send the cannot-claim-address message or sha=
ll execute again
> > > > > > > > > > > the claim procedure with a new address
> > > > > > > > > > > - If the name of the CF #1 has higher priority then t=
he of the CF #2,
> > > > > > > > > > > then the CF #2 shall send the cannot-claim-address me=
ssage or shall
> > > > > > > > > > > execute the claim procedure with a new address
> > > > > > > > > > >=20
> > > > > > > > > > > Above conflict management is OK with current J1939 dr=
iver
> > > > > > > > > > > implementation, however, since the driver always wait=
s 250ms after
> > > > > > > > > > > sending an address-claim message, the CF #1 cannot se=
t the DTC. The DM1
> > > > > > > > > > > message which is expected to be sent each second (as =
per J1939-73
> > > > > > > > > > > standard) may not be sent.
> > > > > > > > > > >=20
> > > > > > > > > > > Honestly, I don't know which company is doing the ISO=
BUS compliance
> > > > > > > > > > > tests on our products and which tool they use as it w=
as choosen by our
> > > > > > > > > > > customer, however they did send us some CAN traces of=
 previously
> > > > > > > > > > > performed tests and we noticed that the DM1 message i=
s sent 160ms after
> > > > > > > > > > > the address-claim message (but it may also be lower t=
hen that), and this
> > > > > > > > > > > is something that we cannot do because the driver blo=
cks the application
> > > > > > > > > > > from sending it.
> > > > > > > > > > >=20
> > > > > > > > > > > 28401.127146 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF =
FF FF FF  //Message
> > > > > > > > > > > with other CF's address
> > > > > > > > > > > 28401.167414 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 =
86 00 A0  //Address
> > > > > > > > > > > Claim - SA =3D F0
> > > > > > > > > > > 28401.349214 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F =
01 FF FF  //DM1
> > > > > > > > > > > 28402.155774 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF =
FF FF FF  //Message
> > > > > > > > > > > with other CF's address
> > > > > > > > > > > 28402.169455 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 =
86 00 A0  //Address
> > > > > > > > > > > Claim - SA =3D F0
> > > > > > > > > > > 28402.348226 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F =
02 FF FF  //DM1
> > > > > > > > > > > 28403.182753 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF =
FF FF FF  //Message
> > > > > > > > > > > with other CF's address
> > > > > > > > > > > 28403.188648 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 =
86 00 A0  //Address
> > > > > > > > > > > Claim - SA =3D F0
> > > > > > > > > > > 28403.349328 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F =
03 FF FF  //DM1
> > > > > > > > > > > 28404.349406 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F =
03 FF FF  //DM1
> > > > > > > > > > > 28405.349740 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F =
03 FF FF  //DM1
> > > > > > > > > > >=20
> > > > > > > > > > > Since the 250ms wait is not explicitly stated, IMHO i=
t should be up to
> > > > > > > > > > > the user-space implementation to decide how to manage=
 it.   =20
> > > > > > > > >=20
> > > > > > > > > I think this is not entirely correct. AFAICS the 250ms wa=
it is indeed
> > > > > > > > > explicitly stated.
> > > > > > > > > The following is taken from ISO 11783-5:
> > > > > > > > >=20
> > > > > > > > > In "4.4.4.3 Address violation" it states that "If a CF re=
ceives a message,
> > > > > > > > > other than the address-claimed message, which uses the CF=
=E2=80=99s own SA, then the
> > > > > > > > > CF [...] shall send the address-claim message to the Glob=
al address."
> > > > > > > > >=20
> > > > > > > > > So the CF shall claim its address again. But further down=
, in "4.5.2 Address
> > > > > > > > > claim requirements" it is stated that "...No CF shall beg=
in, or resume,
> > > > > > > > > transmission on the network until 250 ms after it has suc=
cessfully claimed an
> > > > > > > > > address".
> > > > > > > > >=20
> > > > > > > > > At this moment, the address is in dispute. The affected C=
Fs are not allowed to
> > > > > > > > > send any other messages until this dispute is resolved, a=
nd the standard
> > > > > > > > > requires a waiting time of 250ms which is minimally deeme=
d necessary to give
> > > > > > > > > all participants time to respond and eventually dispute t=
he address claim.
> > > > > > > > >=20
> > > > > > > > > If the offending CF ignores this dispute and keeps sendin=
g incorrect messages
> > > > > > > > > faster than every 250ms, then effectively the other CF ha=
s no chance to ever
> > > > > > > > > resume normal operation because its address is still disp=
uted.
> > > > > > > > >=20
> > > > > > > > > According to 4.4.4.3 it is also required to set a DTC, bu=
t it will not be
> > > > > > > > > allowed to send the DM1 message unless the address disput=
e is resolved.
> > > > > > > > >=20
> > > > > > > > > This effectively leads to the offending CF to DoS the aff=
ected CF if it keeps
> > > > > > > > > sending offending messages. Unfortunately neither J1939 n=
or ISObus takes into
> > > > > > > > > account adversarial behavior on the CAN network, so we ca=
nnot do anything
> > > > > > > > > about this.
> > > > > > > > >=20
> > > > > > > > > As for the ISObus compliance tool that is mentioned by De=
vid, IMHO this
> > > > > > > > > compliance tool should be challenged and fixed, since it =
is broken.
> > > > > > > > >=20
> > > > > > > > > The networking layer is prohibiting the DM1 message to be=
 sent, and the
> > > > > > > > > networking layer has precedence above all superior protoc=
ol layers, so the
> > > > > > > > > diagnostics layer is not able to operate at this moment.
> > > > > > > > >=20
> > > > > > > > > Best regards,
> > > > > > > > >=20
> > > > > > > > >    =20
> > > > > > > >=20
> > > > > > > > Hi David,
> > > > > > > >=20
> > > > > > > > I get your point but I'm not sure that it is the correct in=
terpretation
> > > > > > > > that should be applied in this particular case for the foll=
owing
> > > > > > > > reasons:
> > > > > > > >=20
> > > > > > > > - In "4.5.2 Address claim requirements" it is explicitly st=
ated that
> > > > > > > > "The CF shall claim its own address when initializing and w=
hen
> > > > > > > > responding to a command to change its NAME or address" and =
this seems to =20
> > > > > > >=20
> > > > > > > The standard unfortunately has a track record of ignoring a l=
ot of scenarios
> > > > > > > and corner cases, like in this instance the fact that there c=
an appear new
> > > > > > > participants on the bus _after_ initialization has long finis=
hed, and it would
> > > > > > > need to claim its address again in that case.
> > > > > > >=20
> > > > > > > But look at point d) of that same section: "No CF shall begin=
, or resume,
> > > > > > > transmission on the network until 250 ms after it has success=
fully claimed an
> > > > > > > address (Figure 4). This does not apply when responding to a =
request for
> > > > > > > address claimed."
> > > > > > >=20
> > > > > > > So we basically have two situations when this will apply afte=
r the network is
> > > > > > > up and running and a new node suddenly appears:
> > > > > > >=20
> > > > > > >  1. The new node starts with a "Request for address claimed" =
message, to
> > > > > > >  which your CF should respond with an "Address Claimed" messa=
ge and NOT wait
> > > > > > >  250ms.
> > > > > > >=20
> > > > > > > or
> > > > > > >=20
> > > > > > >  2. The new node creates an addressing conflict either by cla=
iming its address
> > > > > > >  without first sending a "request for address claimed" messag=
e or (and this is
> > > > > > >  your case) simply using its address without claiming it firs=
t.
> > > > > > >=20
> > > > > > > It is this second possibility where there is a conflict that =
must be resolved,
> > > > > > > and then you must wait 250ms after claiming the conflicting a=
ddress for
> > > > > > > yourself.
> > > > > > >  =20
> > > > > > > > completely ignore the "4.4.4.3 Address violation" that stat=
es that the
> > > > > > > > address-claimed message shall be sent also when "the CF rec=
eives a
> > > > > > > > message, other than the address-claimed message, which uses=
 the CF's own
> > > > > > > > SA".
> > > > > > > > Please note that the address was already claimed by the CF,=
 so I think
> > > > > > > > that the initialization requirements should not apply in th=
is case since
> > > > > > > > all disputes were already resolved. =20
> > > > > > >=20
> > > > > > > Well, yes and no. The address was claimed before, yes, but th=
en a new node came
> > > > > > > onto the bus and disputed that address. In that case the disp=
ute needs to be
> > > > > > > resolved first. Imagine you would NOT wait 250ms, but the oth=
er CF did
> > > > > > > correctly claim its address, but it was you who did not recei=
ve that message
> > > > > > > for some reason. Now also assume that your own NAME has a low=
er priority than
> > > > > > > the other CF. In this case you can send a "claimed address" m=
essage to claim
> > > > > > > your address again, but it will be contested. If you don't wa=
it for the
> > > > > > > contestant, it is you who will be in violation of the protoco=
l, because you
> > > > > > > should have changed your own address but failed to do so.
> > > > > > >  =20
> > > > > > > > - If the offending CF ignores the dispute, as you said, the=
n the other
> > > > > > > > CF has no chance to ever resume normal operation and so the=
 network
> > > > > > > > cannot be aware that the other CF is not working correctly =
because the
> > > > > > > > offending CF is spoofing its own address. =20
> > > > > > >=20
> > > > > > > Correct. And like I said in my previous reply, this is unfort=
unately how CAN,
> > > > > > > J1939 and ISObus work. The whole network must cooperate and t=
here is no
> > > > > > > consideration for malign or adversarial actors.
> > > > > > > There are also a lot of possible corner cases that these stan=
dards
> > > > > > > unfortunately do not take into account. Conformance test tool=
s seem to be even
> > > > > > > more problematic and tend to have bugs quite often. I am stil=
l inclined to
> > > > > > > think this is the case with your test tool.
> > > > > > >  =20
> > > > > > > > This seems to make useless the
> > > > > > > > requirement that states to activate the DTC in "4.4.4.3 Add=
ress
> > > > > > > > violation". =20
> > > > > > >=20
> > > > > > > The requirement is not useless. You can still set and store t=
he DTC, just not
> > > > > > > broadcast it to the network at that moment.
> > > > > > >=20
> > > > > > > Best regards,
> > > > > > >=20
> > > > > > >  =20
> > > > > >=20
> > > > > > Thank you for your feedback and explanation.
> > > > > > I asked the customer to contact the compliance company so that =
we can
> > > > > > verify with them this particular use-case. I want to understand=
 if there
> > > > > > is an application note or exception that states how to manage i=
t or if
> > > > > > they implemented the test basing it on their own interpretation=
 and how
> > > > > > it really works: supposing that the test does not check the DM1
> > > > > > presence, then the test could be passed even without sending th=
e DM1
> > > > > > message during the 250ms after the adress-claimed message.
> > > > > >=20
> > > > > > Best regards,
> > > > > > Devid =20
> > > > >=20
> > > > > Hi David, all,
> > > > >=20
> > > > > I'm sorry for resuming this discussion after a long time but I no=
ticed
> > > > > that the driver forces the 250 ms wait even when responding to a =
request
> > > > > for address-claimed which is against point d) of ISO 11783-5 "4.5=
.2
> > > > > Address claim requirements":
> > > > >=20
> > > > > No CF shall begin, or resume, transmission on the network until 2=
50 ms
> > > > > after it has successfully claimed  an  address  (see Figure 4), e=
xcept
> > > > > when responding to a request for address-claimed.
> > > > >=20
> > > > > IMHO the driver shall be able to detect above condition or shall =
not
> > > > > force the 250 ms wait which should then be implemented, depending=
 on the
> > > > > case, on user-space application side.
> > > >=20
> > > > I am a bit out of the loop with this driver, but I think what you s=
ay is
> > > > correct. The J1939 stack should NOT unconditionally stay silent for=
 250ms
> > > > after sending an Address Claimed message. It should specifically NO=
T do so if
> > > > it is just responding to a Request for Address Claimed message.
> > > >=20
> > > > So if it is indeed so, that the J1939 stack will hold off sending m=
essages
> > > > forcibly after sending an Address Claimed message as a reply to a R=
equest for
> > > > Address Claimed, then I'd say this is a bug.
> > > >=20
> > > > @Oleksij, can you confirm this?
> > >=20
> > > I do not see any code path inside of the j1939 stack preventing sendi=
ng
> > > you anything by address. The only part which cares about address
> > > claiming is net/can/j1939/address-claim.c and it will just not be abl=
e
> > > to resolve name to address, because address claiming was not finished
> > > jet. With other words, if you need to send responding to a request fo=
r
> > > address-claimed, then just send it by using address instead of name.
> > >=20
> > > Regards,
> > > Oleksij
> >=20
> > Hi Oleksij,
> > I'm sorry but I think I don't understand your proposal.
> >=20
> > If I send an address-claimed message binding the socket without the nam=
e
> > (can_addr.j1939.name =3D J1939_NO_NAME), then the driver returns error
> > EPROTO.
> > If I send the address-claimed message binding the socket with the name,
> > then the address-claimed message is sent successfully but other message=
s
> > sent within 250 ms are not sent (error EADDRNOTAVAIL).
>=20
> What kind of other messages are your trying to send?
>=20
> Regards,
> Oleksij

Hi,
the application sends each second the DM1 (0xFECA), meanwhile it
receives an request for address-claimed message and it answers with the
address-claimed message.
If the DM1 is sent within 250 ms after the address-claimed message, then
it is rejected with error EADDRNOTAVAIL.
Since the driver is performing the claim each time the address-claimed
message is sent (even if it is a response to a request for address-
claimed), the EADDRNOTAVAIL error is expected in the 250 ms time window.
So, when a request for address-claimed message is received:
- You cannot send an address-claimed message with the socket bound with
J1939_NO_NAME because it is rejected with error EPROTO
- You can send an address-claimed message with the socket bound with the
name but you won't be able to send other messages within 250 ms because
they are rejected with error EADDRNOTAVAIL and this is against point d)
of ISO 11783-5 "4.5.2 Address claim requirements".

Best Regards,
Devid



