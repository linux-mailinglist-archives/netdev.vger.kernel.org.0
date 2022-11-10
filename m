Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96ECA624612
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 16:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiKJPgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 10:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiKJPgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 10:36:40 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADFE5F55
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 07:36:39 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id ECB0D84BD8;
        Thu, 10 Nov 2022 16:36:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668094598;
        bh=c8LTq/I3KfN5d9D6btcSyHA06uUPRzZkB2Urc+atxYM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QCXk6rHOHicQ0QbbZ7dXLYVhXBtVy4SQjwUctO9sNWmK+izbOncUx21QhHovecl0/
         k7awBkxFVJ+2NhmUVf+fe3lGUnPDSF3eAYxGTftFHQs38NlWMpGLHl1THnb5JOyO5q
         VAsQGncRn2g3DDn2KiTNjvIpbgchJuZ8qCZ/N2B9VE7m9LsN+lQ8bgwtNl/k31Dg69
         Pt1FCRmGi4VTCB9d3bI84J01OkfnG7a2Fu9jhMyqsrH7nSxmS7nuXXQsbWbNolYhS4
         md24SKEH6S6Jv6kFN5LKr9eFidie+mX3yTlrouiapVzj44+EdcdPK02VsiDIes25tQ
         PbCBKsr9HJyGw==
Date:   Thu, 10 Nov 2022 16:36:37 +0100
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
Message-ID: <20221110163637.69a8490e@wsk>
In-Reply-To: <Y2pd9CFMzI5UZSiD@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
        <20221108082330.2086671-7-lukma@denx.de>
        <Y2pd9CFMzI5UZSiD@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WRub9QqFH2pvg3ipIpTlYts";
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

--Sig_/WRub9QqFH2pvg3ipIpTlYts
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Tue, Nov 08, 2022 at 09:23:27AM +0100, Lukasz Majewski wrote:
> > Different Marvell DSA switches support different size of max frame
> > bytes to be sent.
> >=20
> > For example mv88e6185 supports max 1632B, which is now in-driver
> > standard value. On the other hand - mv88e6071 supports 2048 bytes.
> >=20
> > As this value is internal and may be different for each switch IC
> > new entry in struct mv88e6xxx_info has been added to store it.
> >=20
> > When the 'max_frame_size' is not defined (and hence zeroed by
> > the kvzalloc()) the default of 1632 bytes is used. =20
>=20
> I would prefer every entry states the value.

You mean to add it explicitly (i.e. for each supported switch version)
to the struct mv88e6xxx_ops ?

> That both simplifies the
> code, and probably reduces the likelihood of somebody forgetting to
> set it when adding a new chip.

Ok.

>=20
>     Andrew


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/WRub9QqFH2pvg3ipIpTlYts
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmNtGoUACgkQAR8vZIA0
zr2blwf/UXILsQhsHvJI1Ksiz4OyoxKnYq4yJH3Q1f+nFxIBHUTeBRc8Hh1u3MKE
sztKvPDNsJnKneAACtTZZ8xErt2j8TaVz921R0fZAsIS26ptgqVyY4mIGRmvyLOn
/q4DMfAqZ0WmYAclnpaDd98h20qCxCf871IjHjmJN1cfgHlP5/emoinfO2aftwTp
TZYb+2ojoKL72muKMj4QvaNtNLArJqYAvZzaeMsJFf9lhIz34RfNqNU+rHTck95D
TsFEpr0ucHWyGWi+U29Fm8KxTeZjWhc4waNbCYVXb5uaUh7HK+JYptozpSZSvOY1
51dO7M68tUpgqvtSIEtumT+8M/Q1mg==
=2y49
-----END PGP SIGNATURE-----

--Sig_/WRub9QqFH2pvg3ipIpTlYts--
