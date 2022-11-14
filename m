Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCCC627827
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbiKNIwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbiKNIwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:52:32 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53711B9CA
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:52:30 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 55A91816BD;
        Mon, 14 Nov 2022 09:52:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668415949;
        bh=kGBGQO+hFbTh5/ugooVRbi02zGtgiK2XcowUlTr3LVw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gvzqwQTYvvaPMZm/zYKDSPCIJDgFApE/MjKdsRcfXr6vBmc1LUAXhq9O1vCiJAuPH
         WYkbLw7VR7PrKZQg9o4jEvPsJPdEblUk3A7K99rtNf3nneCv9Ld6+DVcEz0pJC0AYh
         Fci7RPK1sOUmc5Du4AgGIGyo97CId5cljxCAADImrbdq9Y1dT2MXVa31HBJg/rhtaJ
         +4MoKMpcC5w00PJG+D5Q8+x9GW/n67/IrcPMvKrYORd/YzyMYOMTqpgUEbtIF2wy43
         L21j3izsArTiP6lFQJhTGUtWVODJyFVtKBuUK2Aw6IMC5e1PE3lC04tJZwbEy7Gr4C
         0q9mwpbLTYHRg==
Date:   Mon, 14 Nov 2022 09:52:28 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 6/9] net: dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20221114095228.6de479ec@wsk>
In-Reply-To: <Y2120XvGIZvP+TxM@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
        <20221108082330.2086671-7-lukma@denx.de>
        <Y2pd9CFMzI5UZSiD@lunn.ch>
        <20221110163637.69a8490e@wsk>
        <Y2120XvGIZvP+TxM@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/l14PNeyKmTEvMw_=QVprXka";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/l14PNeyKmTEvMw_=QVprXka
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Thu, Nov 10, 2022 at 04:36:37PM +0100, Lukasz Majewski wrote:
> > Hi Andrew,
> >  =20
> > > On Tue, Nov 08, 2022 at 09:23:27AM +0100, Lukasz Majewski wrote: =20
> > > > Different Marvell DSA switches support different size of max
> > > > frame bytes to be sent.
> > > >=20
> > > > For example mv88e6185 supports max 1632B, which is now in-driver
> > > > standard value. On the other hand - mv88e6071 supports 2048
> > > > bytes.
> > > >=20
> > > > As this value is internal and may be different for each switch
> > > > IC new entry in struct mv88e6xxx_info has been added to store
> > > > it.
> > > >=20
> > > > When the 'max_frame_size' is not defined (and hence zeroed by
> > > > the kvzalloc()) the default of 1632 bytes is used.   =20
> > >=20
> > > I would prefer every entry states the value. =20
> >=20
> > You mean to add it explicitly (i.e. for each supported switch
> > version) to the struct mv88e6xxx_ops ? =20
>=20
> To the info structure. You added it for just your devices and left it
> to 0 for the rest. Rather than special case 0, always set the value
> and remove the special case. Maybe even -EINVAL if you find a 0 there.
>=20

Ok.

>    Andrew


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/l14PNeyKmTEvMw_=QVprXka
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmNyAcwACgkQAR8vZIA0
zr0l1wgA0+hmqJ4WWRVrgACweNr571Tje+tvYhPSX0hoW55puJ2oMJEFpMfpfFGN
gREOX2anNoVOGaQu/uJiEMlb2QFou4KwDEEZrzHX3n/eOdzrXqyfWHim8Y27zZr1
T13EckEwbsF9azPhYo0OTeDYNUAcybaFE6fjufrzo/+i0ZxyXLN+SrsGvJcselGn
8Cb7Dj6TuEXyv4yH0XwSc63QpKy42q6ZhB95tfy3csFSfvngEBUOP8TIxdWB0l7l
p8nmGOqwtqz2beYBtn9Y5AcrIdsli9hRbWaCeldVOlZ2j/5vjjxcEDFcJx48DxgV
ASYFZBJYGOUBBX1NM331aTDN9SZsqg==
=S1OQ
-----END PGP SIGNATURE-----

--Sig_/l14PNeyKmTEvMw_=QVprXka--
