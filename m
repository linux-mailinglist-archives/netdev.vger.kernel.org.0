Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64632439EE3
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhJYTEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbhJYTEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 15:04:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0427FC061767
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 12:02:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mf5Dm-00010z-7d; Mon, 25 Oct 2021 21:01:22 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-e094-d8e8-b5aa-4a00.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:e094:d8e8:b5aa:4a00])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2ED6D69DAD3;
        Mon, 25 Oct 2021 19:01:16 +0000 (UTC)
Date:   Mon, 25 Oct 2021 21:01:14 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Guangbin Huang <huangguangbin2@huawei.com>, davem@davemloft.net,
        mkubecek@suse.cz, andrew@lunn.ch, amitc@mellanox.com,
        idosch@idosch.org, danieller@nvidia.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        netanel@amazon.com, akiyano@amazon.com, saeedb@amazon.com,
        chris.snook@gmail.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, jeroendb@google.com, csully@google.com,
        awogbemila@google.com, jdmason@kudzu.us, rain.1986.08.12@gmail.com,
        zyjzyj2000@gmail.com, kys@microsoft.com, haiyangz@microsoft.com,
        mst@redhat.com, jasowang@redhat.com, doshir@vmware.com,
        pv-drivers@vmware.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH V4 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
Message-ID: <20211025190114.zbqgzsfiv7zav7aq@pengutronix.de>
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
 <20211014113943.16231-5-huangguangbin2@huawei.com>
 <20211025131149.ya42sw64vkh7zrcr@pengutronix.de>
 <20211025132718.5wtos3oxjhzjhymr@pengutronix.de>
 <20211025104505.43461b53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tsachftpl2w422kb"
Content-Disposition: inline
In-Reply-To: <20211025104505.43461b53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tsachftpl2w422kb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.10.2021 10:45:05, Jakub Kicinski wrote:
> > The approach Andrew suggested is two-fold. First introduce a "struct
> > ethtool_kringparam" that's only used inside the kernel, as "struct
> > ethtool_ringparam" is ABI. Then extend "struct ethtool_kringparam" as
> > needed.
>=20
> Indeed, there are different ways to extend the API for drivers,
> I think it comes down to personal taste. I find the "inheritance"=20
> models in C (kstruct usually contains the old struct as some "base")
> awkward.
>=20
> I don't think we have agreed-on best practice in the area.

=46rom my point of view, if there already is an extension mainline:

| https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3Df3ccfda19319

I'm more in the flavor for modeling other extensions the same way. Would
be more consistent to name the new struct "kernel_"ethtool_ringparam,
following the coalescing example:

| struct kernel_ethtool_ringparam {
|        __u32   rx_buf_len;
| };

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--tsachftpl2w422kb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF2/vgACgkQqclaivrt
76nIzAf/ew+QcoVunJ7n3YtQOE87/Pm9xz0d87FykWZTcmxFJ0h+HtzXuma7LYPh
swmGDwvdCA6iGv3NG4lhsXHCNFaqaj+vERZnjNIJjbns8bJ8JmqzvYFABTE3LaPY
i51d5d82npzuIEyrcWJuB52V8ZoA/n4gak7trEEe5q4mRy+86qjveIAoLju9vR9E
QtFkd3CaXHrLwSaiTJE5vc4RgXkKwDgGB6elo6U2aXhc2DQuwrHKfJrxAOROVxuX
pqH3usxLLMEfFLNp6+yL6g3AWDSeRc2zTMo404j1H1blNMqS5Cqd9QrxzvjALUtO
wDAy/KhQcx7nJ1NSoq3MOFwrHCnwSg==
=ZA5r
-----END PGP SIGNATURE-----

--tsachftpl2w422kb--
