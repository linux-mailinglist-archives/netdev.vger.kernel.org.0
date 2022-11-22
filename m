Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D367A63430E
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbiKVRzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbiKVRyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:54:35 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8878DFE;
        Tue, 22 Nov 2022 09:52:36 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9BF001C0004;
        Tue, 22 Nov 2022 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669139555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LlhTz4hZ6khVI5ivLTLmhvJIL86V0Pr/7JrsMu5aav0=;
        b=SMMCzrs0uEnKUmCsxVv/pVCvICUZCNmuXWZZXL23JO+6908+SKZxVrD1vJ5PGEahS1Ec7L
        3jcXg8WpBne2CPMdi5l/I7JwAMrKwGpCzn2v9eeRDHPID4/v29t5XCNreDV8ZWFh55vtEa
        IeGzEEha0XsOXpZzsUf1PfaU6A8cM8SgQ2ca9Wl/epKakpeeGCOwMPFfcJtqn9ob3cg/Vd
        g3UwGMZYxk69xBvXoXb2vf4ObcCw9BK4hB0stTFZ8XkukCVFpyl3hoFeImcKW7Qj9wWeMc
        fVFn9KMrmkRJ7en2XXVf3rp9StoYggUdwYTrHHFOeVNIf2m7+JI9N0Q7vnzbUA==
Date:   Tue, 22 Nov 2022 18:52:31 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 6/6] net: mvpp2: Consider NVMEM cells as
 possible MAC address source
Message-ID: <20221122185231.6302874a@xps-13>
In-Reply-To: <CAPv3WKds1gUN1V-AkdhPJ7W_G285Q4PmAbS0_nApPgU+3RK+fA@mail.gmail.com>
References: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
        <20221117215557.1277033-7-miquel.raynal@bootlin.com>
        <CAPv3WKdZ+tsW-jRJt_n=KqT+oEe+5QAEFOWKrXsTjHCBBzEh0A@mail.gmail.com>
        <20221121102928.7b190296@xps-13>
        <CAPv3WKds1gUN1V-AkdhPJ7W_G285Q4PmAbS0_nApPgU+3RK+fA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin,

mw@semihalf.com wrote on Mon, 21 Nov 2022 15:46:44 +0100:

> pon., 21 lis 2022 o 10:29 Miquel Raynal <miquel.raynal@bootlin.com> napis=
a=C5=82(a):
> >
> > Hi Marcin,
> >
> > mw@semihalf.com wrote on Sat, 19 Nov 2022 09:18:34 +0100:
> > =20
> > > Hi Miquel,
> > >
> > >
> > > czw., 17 lis 2022 o 22:56 Miquel Raynal <miquel.raynal@bootlin.com> n=
apisa=C5=82(a): =20
> > > >
> > > > The ONIE standard describes the organization of tlv (type-length-va=
lue)
> > > > arrays commonly stored within NVMEM devices on common networking
> > > > hardware.
> > > >
> > > > Several drivers already make use of NVMEM cells for purposes like
> > > > retrieving a default MAC address provided by the manufacturer.
> > > >
> > > > What made ONIE tables unusable so far was the fact that the informa=
tion
> > > > where "dynamically" located within the table depending on the
> > > > manufacturer wishes, while Linux NVMEM support only allowed statica=
lly
> > > > defined NVMEM cells. Fortunately, this limitation was eventually ta=
ckled
> > > > with the introduction of discoverable cells through the use of NVMEM
> > > > layouts, making it possible to extract and consistently use the con=
tent
> > > > of tables like ONIE's tlv arrays.
> > > >
> > > > Parsing this table at runtime in order to get various information i=
s now
> > > > possible. So, because many Marvell networking switches already foll=
ow
> > > > this standard, let's consider using NVMEM cells as a new valid sour=
ce of
> > > > information when looking for a base MAC address, which is one of the
> > > > primary uses of these new fields. Indeed, manufacturers following t=
he
> > > > ONIE standard are encouraged to provide a default MAC address there=
, so
> > > > let's eventually use it if no other MAC address has been found usin=
g the
> > > > existing methods.
> > > >
> > > > Link: https://opencomputeproject.github.io/onie/design-spec/hw_requ=
irements.html =20
> > >
> > > Thanks for the patch. Did you manage to test in on a real HW? I am cu=
rious about =20
> >
> > Yes, I have a Replica switch on which the commercial ports use the
> > replica PCI IP while the config "OOB" port is running with mvpp2:
> > [   16.737759] mvpp2 f2000000.ethernet eth52: Using nvmem cell mac addr=
ess 18:be:92:13:9a:00
> > =20
>=20
> Nice. Do you have a DT snippet that can possibly be shared? I'd like
> to recreate this locally and eventually leverage EDK2 firmware to
> expose that.

Yes of course, the DT is public on Sartura's Github, but here is the
exact file I used showing the diff cleaning the Armada 7040 TN48M DT
eeprom description and its use as an nvmem-cell provider):
https://github.com/miquelraynal/linux/commit/230ee68728799454e2f07f61792e11=
724e731d6d

>=20
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >
> > > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/driv=
ers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > index eb0fb8128096..7c8c323f4411 100644
> > > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > @@ -6104,6 +6104,12 @@ static void mvpp2_port_copy_mac_addr(struct =
net_device *dev, struct mvpp2 *priv,
> > > >                 }
> > > >         }
> > > >
> > > > +       if (!of_get_mac_address(to_of_node(fwnode), hw_mac_addr)) {=
 =20
> > >
> > > Unfortunately, nvmem cells seem to be not supported with ACPI yet, so
> > > we cannot extend fwnode_get_mac_address - I think it should be,
> > > however, an end solution. =20
> >
> > Agreed.
> > =20
> > > As of now, I'd prefer to use of_get_mac_addr_nvmem directly, to avoid
> > > parsing the DT again (after fwnode_get_mac_address) and relying
> > > implicitly on falling back to nvmem stuff (currently, without any
> > > comment it is not obvious). =20
> >
> > I did not do that in the first place because of_get_mac_addr_nvmem()
> > was not exported, but I agree it would be the cleanest (and quickest)
> > approach, so I'll attempt to export the function first, and then use it
> > directly from the driver.
> > =20
>=20
> That would be great, thank you. Please add one-comment in the
> mvpp2_main.c, that this is valid for now only in DT world.

Ack.

Thanks,
Miqu=C3=A8l
