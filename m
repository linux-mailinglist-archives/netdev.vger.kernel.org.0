Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1551CDF34
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbgEKPio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727994AbgEKPio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:38:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66426C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:38:44 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jYAVu-0005nl-Uv; Mon, 11 May 2020 17:38:42 +0200
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jYAVq-0006g1-WD; Mon, 11 May 2020 17:38:39 +0200
Date:   Mon, 11 May 2020 17:38:38 +0200
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: Re: [PATCH v3 3/5] net: tag: ksz: Add KSZ8863 tag code
Message-ID: <20200511153838.GL20451@pengutronix.de>
References: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
 <20200508154343.6074-4-m.grzeschik@pengutronix.de>
 <20200509164105.GA362499@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="B92bTrfKjyax39gr"
Content-Disposition: inline
In-Reply-To: <20200509164105.GA362499@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:36:50 up 81 days, 23:07, 117 users,  load average: 0.23, 0.21,
 0.18
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--B92bTrfKjyax39gr
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 09, 2020 at 06:41:05PM +0200, Andrew Lunn wrote:
>> +/* For ingress (Host -> KSZ8863), 1 byte is added before FCS.
>> + * --------------------------------------------------------------------=
-------
>> + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(=
4bytes)
>> + * --------------------------------------------------------------------=
-------
>> + * tag0[1,0] : represents port
>> + *             (e.g. 0b00=3Daddr-lookup 0b01=3Dport1, 0b10=3Dport2, 0b1=
1=3Dport1+port2)
>> + * tag0[3,2] : bits two and three represent prioritization
>> + *             (e.g. 0b00xx=3Dprio0, 0b01xx=3Dprio1, 0b10xx=3Dprio2, 0b=
11xx=3Dprio3)
>> + *
>> + * For egress (KSZ8873 -> Host), 1 byte is added before FCS.
>> + * --------------------------------------------------------------------=
-------
>> + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
>> + * --------------------------------------------------------------------=
-------
>> + * tag0[0]   : zero-based value represents port
>> + *             (eg, 0b0=3Dport1, 0b1=3Dport2)
>> + */
>> +
>> +static struct sk_buff *ksz8863_xmit(struct sk_buff *skb,
>> +				    struct net_device *dev)
>> +{
>> +	struct dsa_port *dp =3D dsa_slave_to_port(dev);
>> +	struct sk_buff *nskb;
>> +	__be16 *tag;
>
>The comment says 1 byte is added. But tag is a u16?

You are absolutely right. I fixed it for v4.

Michael

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--B92bTrfKjyax39gr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAl65cXUACgkQC+njFXoe
LGQ5vg//eCR8R4Rf++y/KzEYRi5rKVQSUK4wOs466B99o/qywSmcZIXTxtDqimyw
LJkzE/byvG+TKvYc2MNNKNKyKo7qw7CHYIrdw2EhN3xbBSUrjjVI54cLF8vqHdDF
r74amFeeGfF4TgZMdgbnNXikkVlA+laMAZk4m0TFvErR+fBMABKI+D8VlOsanLm+
rFs/2O+pF0UccPBYf6Jg5pPdN9LHDuk4qw/iSt5vUT0dAJcjXBkB6C82hVudaUU+
1JA+8g0PzEzDuhL67QxbC83gi0NV+vmFLOafo09jsRbVwfZPudPr6Cunzf6iQ0Y2
w3nsmcdsq40Q27sC45/lwJgw3y3d+Hf16ODNK4fqHk5XtDFWI453G80e8fx3hALC
Cm0qp1Z85oKXs2s/poKXFaT6rFFEB7rfq0vgpoUUKFssBaksjDOFB6vsyBNFvzjH
rMQcfNn29URraUOQOmfboUVbEYfppfwiE4YxgUcYRarIMsnN7cSHS2lz1dtGlZHC
dcatNuS59qx8Wuu7O9Ju3ZR+2Z7DsxkQAfrW8wJgzD/t+KTcqAQEDJW7kjQX8VDt
a6/eyufQ2FONaTSbkjwMKOf2UGQi4SvFv02u7DG1H10ekuY6eFRJ9ue9XijP/eHQ
xG6A3PKKEfetYRfDWGSOcdgM7CDfP/4vvqaN9h/IgzP81fao+zo=
=cfUd
-----END PGP SIGNATURE-----

--B92bTrfKjyax39gr--
