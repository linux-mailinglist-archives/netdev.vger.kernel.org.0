Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3EC6B400E
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 14:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjCJNRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 08:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCJNRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 08:17:32 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5B4E6802;
        Fri, 10 Mar 2023 05:17:28 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 38BEF85ED8;
        Fri, 10 Mar 2023 14:17:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678454246;
        bh=z8e39Z2m9RmVZ/gnozL45YCA1NcqURt5oKlvzpRqhfw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O/IxIhnlNnEVh3P56tf7MCvPHPzWAO2K1j4V8CsheLlXdQcJvbahqLIyXv45iRWBy
         OCwCj+XocA6jsR0krBwG8eb+LAQNOlodl0ltC36ao5YAl2D7lEjvTM1XRjZ1+8xgxw
         XpoJDmhCsTURkqcZ5LWFmVesL6CjbIcF2auZ2HX2VrrY8ke6KeagWj4tpDRJGqdxhc
         F3sDVeCcRttyxSxbxFt2IlWB0rfXJj/NDG5q+haTOlSgIxG2aqoee8v1ZejGXt0Rar
         RuFSCyOH7+X5X6FOe7vyrpJmFBVNSEBu9u13nSUY4xVGGn+yTFgccQ+EvEWMQhH2fP
         aVpo6YsouYV5A==
Date:   Fri, 10 Mar 2023 14:17:19 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] dsa: marvell: Provide per device information about
 max frame size
Message-ID: <20230310141719.7f691b45@wsk>
In-Reply-To: <20230310120235.2cjxauvqxyei45li@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
        <20230309125421.3900962-2-lukma@denx.de>
        <20230310120235.2cjxauvqxyei45li@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qXIdGWVOW9yJZ=Pp=py5OPe";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/qXIdGWVOW9yJZ=Pp=py5OPe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Thu, Mar 09, 2023 at 01:54:15PM +0100, Lukasz Majewski wrote:
> > Different Marvell DSA switches support different size of max frame
> > bytes to be sent. This value corresponds to the memory allocated
> > in switch to store single frame.
> >=20
> > For example mv88e6185 supports max 1632 bytes, which is now
> > in-driver standard value. =20
>=20
> What is the criterion based on which 1632 is the "in-driver standard
> value"?

It comes from the documentation I suppose. Moreover, this might be the
the "first" used value when set_max_mtu callback was introduced.

>=20
> > On the other hand - mv88e6250 supports 2048 bytes. =20
>=20
> What you mean to suggest here is that, using the current
> classification from mv88e6xxx_get_max_mtu(), mv88e6250 falls into the
> "none of the above" bucket, for which the driver returns 1522 -
> VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN // 1492. But it truly
> supports a maximum frame length of 2048, per your research.
>=20

And this cannot be easily fixed.

I could just provide callback to .set_max_frame_size in mv88e6250_ops
and the mv88e6250 would use 1632 bytes which would prevent errors.

However, when I dig deeper - it turned out that this value is larger.
And hence I wanted to do it in "right way".

> The problem is that I needed to spend 30 minutes to understand this,
> and the true motivation for this patch.
>=20

The motivation is correctly stated in the commit message. There is a
bug - mv88e6250 and friends use 2048 max frame size value.

> > To be more interesting - devices supporting jumbo frames - use yet
> > another value (10240 bytes) =20
>=20
> What's interesting about this?
>=20
> >=20
> > As this value is internal and may be different for each switch IC,
> > new entry in struct mv88e6xxx_info has been added to store it. =20
>=20
> You need to provide a justification for why the existing code
> structure is not good enough.

It is clearly stated in patch 3/7 where the existing scheme is replaced
with this one.

>=20
> >=20
> > This commit doesn't change the code functionality - it just provides
> > the max frame size value explicitly - up till now it has been
> > assigned depending on the callback provided by the switch driver
> > (e.g. .set_max_frame_size, .port_set_jumbo_size).
> >=20
> > Signed-off-by: Lukasz Majewski <lukma@denx.de>
> >=20
> > ---
> > Changes for v2:
> > - Define max_frame_size with default value of 1632 bytes,
> > - Set proper value for the mv88e6250 switch SoC (linkstreet) family
> >=20
> > Changes for v3:
> > - Add default value for 1632B of the max frame size (to avoid
> > problems with not defined values)
> >=20
> > Changes for v4:
> > - Rework the mv88e6xxx_get_max_mtu() by using per device defined
> >   max_frame_size value
> >=20
> > - Add WARN_ON_ONCE() when max_frame_size is not defined
> >=20
> > - Add description for the new 'max_frame_size' member of
> > mv88e6xxx_info
> >=20
> > Changes for v5:
> > - Move some code fragments (like get_mtu callback changes) to
> > separate patches =20
>=20
> you have change log up to v5, but your subject prefix is [PATCH 1/7]
> which implies v1?

My mistake - I've forgotten to add proper subject-prefix parameter.

>=20
> > ---
> >  drivers/net/dsa/mv88e6xxx/chip.c | 31
> > +++++++++++++++++++++++++++++++ drivers/net/dsa/mv88e6xxx/chip.h |
> > 6 ++++++ 2 files changed, 37 insertions(+)
> >=20
> > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c
> > b/drivers/net/dsa/mv88e6xxx/chip.c index 0a5d6c7bb128..c097a0b19ba6
> > 100644 --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > +++ b/drivers/net/dsa/mv88e6xxx/chip.c =20
>=20
> It would be good if the commit message contained the procedure based
> on which you had made these changes - and preferably they were
> mechanical. Having a small C program written would be absolutely
> ideal. This is so that reviewers wouldn't have to do it in parallel...
>=20
> My analysis has determined the following 3 categories:
>=20
> static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
> {
> 	struct mv88e6xxx_chip *chip =3D ds->priv;
>=20
> 	if (chip->info->ops->port_set_jumbo_size)
> 		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN -
> ETH_FCS_LEN; // 10210 else if (chip->info->ops->set_max_frame_size)
> 		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN -
> ETH_FCS_LEN; // 1602 return 1522 - VLAN_ETH_HLEN - EDSA_HLEN -
> ETH_FCS_LEN; // 1492 }
>=20
> By ops:
>=20
> port_set_jumbo_size:
> static const struct mv88e6xxx_ops mv88e6131_ops =3D {
> static const struct mv88e6xxx_ops mv88e6141_ops =3D {
> static const struct mv88e6xxx_ops mv88e6171_ops =3D {
> static const struct mv88e6xxx_ops mv88e6172_ops =3D {
> static const struct mv88e6xxx_ops mv88e6175_ops =3D {
> static const struct mv88e6xxx_ops mv88e6176_ops =3D {
> static const struct mv88e6xxx_ops mv88e6190_ops =3D {
> static const struct mv88e6xxx_ops mv88e6190x_ops =3D {
> static const struct mv88e6xxx_ops mv88e6240_ops =3D {
> static const struct mv88e6xxx_ops mv88e6320_ops =3D {
> static const struct mv88e6xxx_ops mv88e6321_ops =3D {
> static const struct mv88e6xxx_ops mv88e6341_ops =3D {
> static const struct mv88e6xxx_ops mv88e6350_ops =3D {
> static const struct mv88e6xxx_ops mv88e6351_ops =3D {
> static const struct mv88e6xxx_ops mv88e6352_ops =3D {
> static const struct mv88e6xxx_ops mv88e6390_ops =3D {
> static const struct mv88e6xxx_ops mv88e6390x_ops =3D {
> static const struct mv88e6xxx_ops mv88e6393x_ops =3D {
>=20
> set_max_frame_size:
> static const struct mv88e6xxx_ops mv88e6085_ops =3D {
> static const struct mv88e6xxx_ops mv88e6095_ops =3D {
> static const struct mv88e6xxx_ops mv88e6097_ops =3D {
> static const struct mv88e6xxx_ops mv88e6123_ops =3D {
> static const struct mv88e6xxx_ops mv88e6161_ops =3D {
> static const struct mv88e6xxx_ops mv88e6185_ops =3D {
>=20
> none of the above:
> static const struct mv88e6xxx_ops mv88e6165_ops =3D {
> static const struct mv88e6xxx_ops mv88e6191_ops =3D {
> static const struct mv88e6xxx_ops mv88e6250_ops =3D {
> static const struct mv88e6xxx_ops mv88e6290_ops =3D {
>=20
>=20
> By info:
>=20
> port_set_jumbo_size (10240):
> 	[MV88E6131] =3D {
> 	[MV88E6141] =3D {
> 	[MV88E6171] =3D {
> 	[MV88E6172] =3D {
> 	[MV88E6175] =3D {
> 	[MV88E6176] =3D {
> 	[MV88E6190] =3D {
> 	[MV88E6190X] =3D {
> 	[MV88E6240] =3D {
> 	[MV88E6320] =3D {
> 	[MV88E6321] =3D {
> 	[MV88E6341] =3D {
> 	[MV88E6350] =3D {
> 	[MV88E6351] =3D {
> 	[MV88E6352] =3D {
> 	[MV88E6390] =3D {
> 	[MV88E6390X] =3D {
> 	[MV88E6191X] =3D {
> 	[MV88E6193X] =3D {
> 	[MV88E6393X] =3D {
>=20
> set_max_frame_size (1632):
> 	[MV88E6085] =3D {
> 	[MV88E6095] =3D {
> 	[MV88E6097] =3D {
> 	[MV88E6123] =3D {
> 	[MV88E6161] =3D {
> 	[MV88E6185] =3D {
>=20
> none of the above (1522):
> 	[MV88E6165] =3D {
> 	[MV88E6191] =3D {
> 	[MV88E6220] =3D {
> 	[MV88E6250] =3D {
> 	[MV88E6290] =3D {
>=20
>=20
> Whereas your analysis seems to have determined this:
>=20
> port_set_jumbo_size (10240):
> 	[MV88E6131] =3D {
> 	[MV88E6141] =3D {
> 	[MV88E6171] =3D {
> 	[MV88E6172] =3D {
> 	[MV88E6175] =3D {
> 	[MV88E6176] =3D {
> 	[MV88E6190] =3D {
> 	[MV88E6240] =3D {
> 	[MV88E6320] =3D {
> 	[MV88E6321] =3D {
> 	[MV88E6341] =3D {
> 	[MV88E6350] =3D {
> 	[MV88E6351] =3D {
> 	[MV88E6352] =3D {
> 	[MV88E6390] =3D {
> 	[MV88E6390X] =3D {
> 	[MV88E6393X] =3D {
>=20
> set_max_frame_size (1632):
> 	[MV88E6095] =3D {
> 	[MV88E6097] =3D {
> 	[MV88E6123] =3D {
> 	[MV88E6161] =3D {
> 	[MV88E6165] =3D {
> 	[MV88E6185] =3D {
>=20
> none of the above (1522):
> 	[MV88E6085] =3D {
> 	[MV88E6190X] =3D {
> 	[MV88E6191] =3D {
> 	[MV88E6191X] =3D {
> 	[MV88E6193X] =3D {
> 	[MV88E6290] =3D {
>=20
> what's up with these?! (no max_frame_size)
> 	[MV88E6220] =3D {
> 	[MV88E6250] =3D {
>=20
>=20
> So our analysis differs for:
>=20
> MV88E6190X (I say 10240, you say 1522)
> MV88E6191X (I say 10240, you say 1522)
> MV88E6193X (I say 10240, you say 1522)
> MV88E6085 (I say 1632, you say 1522)
> MV88E6165 (I say 1522, you say 1632)
> MV88E6220 (I say 1522, not clear what you say)
> MV88E6250 (I say 1522, not clear what you say)
>=20
> Double-checking with the code, I believe my analysis to be the
> correct one...
>=20

This is explained and provided in the following commits as advised by
Russel.

>=20
> I have also noticed that you have not acted upon my previous review
> comment:
> https://patchwork.kernel.org/project/netdevbpf/patch/20230106101651.11377=
55-1-lukma@denx.de/
>=20
> | 1522 - 30 =3D 1492.
> |=20
> | I don't believe that there are switches which don't support the
> standard | MTU of 1500 ?!
> |=20
> | >  		.port_base_addr =3D 0x10,
> | >  		.phy_base_addr =3D 0x0,
> | >  		.global1_addr =3D 0x1b,
> |=20
> | Note that I see this behavior isn't new. But I've simulated it, and
> it | will produce the following messages on probe:
> |=20
> | [    7.425752] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY
> [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=3DPOLL) | [
>   7.437516] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU
> to 1500 on port 0 | [    7.588585] mscc_felix 0000:00:00.5 swp1
> (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE VSC8514
> SyncE] (irq=3DPOLL) | [    7.600433] mscc_felix 0000:00:00.5: nonfatal
> error -34 setting MTU to 1500 on port 1 | [    7.752613] mscc_felix
> 0000:00:00.5 swp2 (uninitialized): PHY [0000:00:00.3:12] driver
> [Microsemi GE VSC8514 SyncE] (irq=3DPOLL) | [    7.764457] mscc_felix
> 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 2 | [
> 7.900771] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY
> [0000:00:00.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=3DPOLL) | [
>   7.912501] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU
> to 1500 on port 3 | | I wonder, shouldn't we first fix that, and
> apply this patch set afterwards?
>=20
> I guess I will have to fix this now, since you haven't done it.
>=20

I do agree with Russel's reply here.

Moreover, as 6250 and 6220 also have max frame size equal to 2048
bytes, this would be fixed in v6 after getting the "validation"
function run.

This is the "patch 4" in the comment sent by Russel (to fix stuff which
is already broken, but it has been visible after running the validation
code):

https://lists.openwall.net/netdev/2023/03/09/233

> > diff --git a/drivers/net/dsa/mv88e6xxx/chip.h
> > b/drivers/net/dsa/mv88e6xxx/chip.h index da6e1339f809..e2b88f1f8376
> > 100644 --- a/drivers/net/dsa/mv88e6xxx/chip.h
> > +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> > @@ -132,6 +132,12 @@ struct mv88e6xxx_info {
> >  	unsigned int num_gpio;
> >  	unsigned int max_vid;
> >  	unsigned int max_sid;
> > +
> > +	/* Max Frame Size.
> > +	 * This value corresponds to the memory allocated in
> > switch internal
> > +	 * memory to store single frame.
> > +	 */ =20
>=20
> What is the source of this definition?
>=20
> I'm asking because I know of other switches where the internal memory
> allocation scheme has nothing to do with the frame size. Instead,
> there are SRAM cells of fixed and small size (say 60 octets) chained
> together.
>=20
> > +	unsigned int max_frame_size;
> >  	unsigned int port_base_addr;
> >  	unsigned int phy_base_addr;
> >  	unsigned int global1_addr;
> > --=20
> > 2.20.1
> >  =20




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/qXIdGWVOW9yJZ=Pp=py5OPe
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmQLLd8ACgkQAR8vZIA0
zr3hVAgAkFDfpDxbabBmwYi77mw5fqpTUf0ZeHXpCXIqUWftsMhnlaalQFFxPZo6
nfHzDVztlNC/MShu13Hcy2RmeW4i7Q3KSQdQW9qwutO5yzycCt4os8pM6FgnG6dL
tEq1x1OUOVfmw+0yz0fiNEzO7Rd+We/3vOcg2q3AIA6fF+u77KKbMQWSAXoQfywA
R8glYRcCpSmfJ6Mn6qrNTP0qLU/zmU1F+2d4VvDnoPrsbD5QVJE0u9V663Xtl6Ti
ei7B/vAYnSpiTqF49CgRqBwa8F9FB6IsUOmVZsTeQpW+EkULD0a/MWXEGxNZkAps
NM+Oo+ma1V2w9FZ3EfAZN2iRkEFwjA==
=u63v
-----END PGP SIGNATURE-----

--Sig_/qXIdGWVOW9yJZ=Pp=py5OPe--
