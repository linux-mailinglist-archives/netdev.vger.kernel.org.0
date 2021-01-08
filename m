Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CF62EEEB3
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 09:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727396AbhAHIlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 03:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:60478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbhAHIli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 03:41:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6873207C5;
        Fri,  8 Jan 2021 08:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610095258;
        bh=5RQMeUGl57mxmrnguXkd+pVtTieQ6mOXiWDV0BKtvgk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nubctBwA9jjzjEHNXuXUdtrvvYfvj8AR3LI3SU9qrdiu1PBM5xIsJYFzMj+YAphSy
         rRvs6IKtz/In63FZrEvEkryv6wwNbRiA6DUKu4yH+sRhbYevbP2Uw9pRBFixuw46TY
         eOPnDaWEhYvFCwDP4dDNQAOYTB2mrDqSDotpGmi1CrEeZA+gJFhlksgg8GM87Vhdxp
         LWz4W83SRXpchUaAs0QfeJlDjnOkceraFXAXX1ubwsuqULRt2rRtG5a7gtKswskQuD
         4MUPXACG+j0z3V2YmBNcAWneOIeyNo6Vl8carmTUwtOLESkAzAc+QYYvwwCRthGPYe
         6V3mpKkVuWXRA==
Date:   Fri, 8 Jan 2021 09:40:51 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: Re: question about i2c_transfer() function (regarding mdio-i2c on
 RollBall SFPs)
Message-ID: <20210108084051.GA1223@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        linux-i2c@vger.kernel.org
References: <20210107192500.54d2d0f0@nic.cz>
 <20210107210248.GA894@kunai>
 <20210107224211.4f01c055@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20210107224211.4f01c055@nic.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I thought as much, but maybe there is some driver which can offload
> whole i2c_transfer to HW, and has to pass the addresses of the buffers
> to the HW, and the HW can have problems if the buffers overlap
> somewhere...

Well, sure, you can never know what crazy HW is out there :) But that
shouldn't prevent us from doing legit I2C transfers. The likeliness of
such HW is low enough; They must process the whole transfer in one go
(rare) AND have the limitiation with the buffer pointers (at least I
don't know one) AND have no possibility of a fallback to a simpler mode
where they can handle the transfer per message. If such a controller
exists, it would need a new quirk flag, I'd say, and reject the
transfer. But that shouldn't stop you from fixing your issue.

Thanks for thinking thoroughly about drawbacks! Much appreciated.


--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl/4Go8ACgkQFA3kzBSg
KbZ/3RAAgpG2/2xH0qgj69NHKAWmrAt7x5TgdEMpjxJeD/ZKf7qAd0RY3q0bY9fF
JpNrBbFerpnZ375i8o9ikRSXCvf2q+ZSWqp4L6esLRNZgL3YUQqg+q7KA2Zj+YTA
BHBy11ncdVbKsb2X46hfuVAslfzTg6gDPs1kElNHtkIgGfw1eWlFPDi/svz72sl7
Btz5tZ04zRPUFaIMhVFvbJB03MH1wLhEOaC+ygG9OEQHoSs6THybZhi+G6sU1L09
gYrnvtdNqbHDp3An7NVVWLvhWS7JXRSbO1y5+eyB5W266+/wtCgwWlMOJxVgVShm
nmdCNAb+XapPWPINJlXCyWdLWXRCc5Cw1oL0xt57b9WwNyDLS1xkwPDBhQl5FTjK
4GFaUDlkk8X4QzokUtcp+stT/X9VOFKpfs85iZLsAee6H3Td6G/W+hZ+NQcglHKD
mY28kuTRlAR/pLNvD4CYSafjKhrALz/ELetpF7Y+GzcNODDqQxit3m7ZYRGZoQ06
gQhFsaXvkrTDfBYKu1Do5CIYNUvW7hW8TkIv9bIm85YfOJQw5pIOCmiPSmw+z0mF
jt04pHInwp1VzCxFXkgdqWAz7ONI4uNoLHrSMb02P3tnooall1ZDbeGg8JSyeAqq
7WNVsJH5ONFSLOWM/y+SrRk5JpyJD2l0O9FV9BqxfYz8Ab1dpiM=
=8etp
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
