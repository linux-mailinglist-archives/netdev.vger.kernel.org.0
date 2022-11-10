Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9AD8624679
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiKJQAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiKJQAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:00:42 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D282BB00
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 08:00:28 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 6D7E080FF4;
        Thu, 10 Nov 2022 17:00:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668096026;
        bh=XbPmBLmIONI5/jb6A+fWcy06LEIqQN1ycAYQX+9CMe8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ENboYeowxJawEPt0nzdXWg50GAxStSBp4shsKVT/JOrOYox2zdtW1G3Ve6U49xMg/
         UPvNNL1I7/WNOwRd975V+XvOdJcpWwCwdvcogMNuhF27Q3Q2xw+xiAQNHbvPUgCBnF
         ariu1rG+8HMXOoEGg/r7UcIsRAsrK1zD3x6xo7/RmsF2+zMVdIxwk5DAmYnxvUErhZ
         R6ldYwN0K4DcSSmDYmOmqEqUIDSstyAqeRAPF1hlyn4GoLjllNwNk8Ytdta34ntS+b
         mnllimxwojB25YFI82Akf+Alj9F6y/6JvIKKsFPgoO1c5+DBboENae+fl78kkO/L22
         jZ75DU4DbDp2g==
Date:   Thu, 10 Nov 2022 17:00:19 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] net: dsa: mv88e6071: Set .set_max_frame_size
 callback
Message-ID: <20221110170019.6005d9de@wsk>
In-Reply-To: <Y2phohBqYR5juqBn@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
        <20221108082330.2086671-10-lukma@denx.de>
        <Y2phohBqYR5juqBn@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4b.p4es1tM/7TFOF.xuSK76";
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

--Sig_/4b.p4es1tM/7TFOF.xuSK76
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Tue, Nov 08, 2022 at 09:23:30AM +0100, Lukasz Majewski wrote:
> > The .set_max_frame_size is now set to the
> > mv88e6185_g1_set_max_frame_size() function.
> >=20
> > The global switch control register (0x4 offset) used
> > as well as the bit (10) are the same.
> >=20
> > The only difference is the misleading suffix (1632)
> > as the mv88e6071/mv88e6020 supports 2048 bytes
> > as a maximal size of the frame. =20
>=20
> Are you really sure that different members of the 6250 family have
> different maximum frame sizes?
>=20
> Marvells GPL DSDT SDK has:
>=20
> #define G1_DEV_88ESPANNAK_FAMILY  (DEV_88E3020 | DEV_88E6020 |
> DEV_88E6070 | DEV_88E6071 | DEV_88E6220  | DEV_88E6250 )

=46rom the above list - all but 88E3020 are from the same IC "family"
(they are listed in the same documentation pdf). They all have the 2048
B max packet size.

I've re-used the mv88e6185_g1_set_max_frame_size, as it does the job

>=20
> The differences within a family tend to be the number of ports, if PTP
> is provided, if AVB is provided etc.
>=20
>    Andrew




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/4b.p4es1tM/7TFOF.xuSK76
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmNtIBMACgkQAR8vZIA0
zr2g3ggAzAzf5O85IEfWT/uPjxrjmcg5dr3QuY7UjfoWQd6w1zR4xklBNSwMuLFs
4rotPLXMckH0BrWHaHZBvGzvXZS3iMMusJVCIoXd3hd41VBqUHhYX1/p9DE3HIj0
R+1xD6pKJG9X69e6IBeVl3zphf8riU4QbctfjphOqo8mhXufITqWO2Ix6OXJwl4d
JxZ0ve4EPoAiRb8RU7EgEEJZ8jc0rkwbpXZL7zlX5iGaGHnEB8vwzvwKw1JE0ewh
dLnARTwGsPDrVt2h7yBAOs2NvN/y8fDw1i11jX2umKhGaDaDNtyddLrlIYuyP/8k
7QdIHBrMZzit+iiR+MWgmO3xLREq9g==
=qt2k
-----END PGP SIGNATURE-----

--Sig_/4b.p4es1tM/7TFOF.xuSK76--
