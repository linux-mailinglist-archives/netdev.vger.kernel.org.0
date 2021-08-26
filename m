Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018E83F8216
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 07:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbhHZFd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 01:33:26 -0400
Received: from home.keithp.com ([63.227.221.253]:59102 "EHLO elaine.keithp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235822AbhHZFdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 01:33:25 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Aug 2021 01:33:24 EDT
Received: from localhost (localhost [127.0.0.1])
        by elaine.keithp.com (Postfix) with ESMTP id 5899F3F3072E;
        Wed, 25 Aug 2021 22:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=keithp.com; s=mail;
        t=1629955441; bh=9PZ6q0rR03ga0cJLlX7wkSjnkm2X7nPpg5xxJCy9RtY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=V8ZHAWsNxg4cKzN6mnE+JjdKstvoz5QndsaHqm/0JKqtYHx7qf+sik19WnSbpeZ6Q
         AjEX1Klqm4x12oAgQH8lJrLC6u/4pXIci4EaQ4RxiiP5jw2kJ+Wr1BlcxY8C2Wy4Fb
         jWWcjACtFjQ8oJwH37HJ6c1VpqU7hCwsS5ybTnP5lAV/3zY5d1sdDagmQ9vi3jIuy+
         +aNC6ttZBX0IIhNSuXRK8/CLxra6k3qQh4vmIkuBLdI1dM2E+Madd2GgJ1+vrteow/
         mf12Ssnv9TySnCx3Kuw4vVdulBma/XNZ1AJsO0j9bHMsWffgJiNgYOkatDiua0iEHW
         KwBc5Fi629JHw==
X-Virus-Scanned: Debian amavisd-new at keithp.com
Received: from elaine.keithp.com ([127.0.0.1])
        by localhost (elaine.keithp.com [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id d8LHxscT6hWs; Wed, 25 Aug 2021 22:23:56 -0700 (PDT)
Received: from keithp.com (koto.keithp.com [192.168.11.2])
        by elaine.keithp.com (Postfix) with ESMTPSA id C066C3F3072D;
        Wed, 25 Aug 2021 22:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=keithp.com; s=mail;
        t=1629955436; bh=9PZ6q0rR03ga0cJLlX7wkSjnkm2X7nPpg5xxJCy9RtY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=oucPIc+p1TEr9jHm30BEh6nsSTrl/DjfKsV2qOrmVf1DMQG6349VUmW+3mP9GkPUL
         I83NAfeJdVNAQulPEjD7Ix9GtzkxVOtuCnS0CPRIYVo9SJp4x3PsZAV1p6NNDeHXq/
         Pvkro7bsTJKioLnocCmT9z4E0ITr88YmjIXCsx4OjlbFg31K5rB1VNwJFPKdtbo5B+
         wgAwhV3gKYrPc9G+VvgOJO5hAdM4ZTbw91d0PzSsU+T1k5fE3VrZWyO/aC9xvXNFSi
         KVrT1uAFAENSHmXt2n1lMtYd2RbyVO6pV2gORcBCJ0iIFawEM3Cwmy0/lQqQH6aom9
         27qjOJbYQhByQ==
Received: by keithp.com (Postfix, from userid 1000)
        id E3F3E1E6011A; Wed, 25 Aug 2021 22:24:18 -0700 (PDT)
From:   Keith Packard <keithp@keithp.com>
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Phillip Potter <phil@philpotter.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        Ross Schmidt <ross.schm.dev@gmail.com>,
        Marco Cesati <marcocesati@gmail.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-staging@lists.linux.dev,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        clang-built-linux@googlegroups.com, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 3/5] treewide: Replace 0-element memcpy()
 destinations with flexible arrays
In-Reply-To: <20210826050458.1540622-4-keescook@chromium.org>
References: <20210826050458.1540622-1-keescook@chromium.org>
 <20210826050458.1540622-4-keescook@chromium.org>
Date:   Wed, 25 Aug 2021 22:24:18 -0700
Message-ID: <87r1egpym5.fsf@keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Kees Cook <keescook@chromium.org> writes:

> In some cases, use of the flex_array() helper is needed when a flexible
> array is part of a union.

The code below seems to show that the helper is also needed when the
flexible array is the only member of a struct? Or is this just an
extension of the 'part of a union' clause?

> @@ -160,7 +160,7 @@ struct bmi_cmd {
>=20=20
>  union bmi_resp {
>  	struct {
> -		u8 payload[0];
> +		DECLARE_FLEX_ARRAY(u8, payload);
>  	} read_mem;
>  	struct {
>  		__le32 result;

=2D-=20
=2Dkeith

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw4O3eCVWE9/bQJ2R2yIaaQAAABEFAmEnJYIACgkQ2yIaaQAA
ABFJwg/9HnuEf5sIRlyVndEk8XKVsPy1mM63I9dwsOPTB031099GdKund7uEfybJ
1kjf3GQv9nMAM0Cq3Uoiqfqv2liuTW2dGKBY2wHAVOtWjQXyTiN3NP3iNx1kVd7X
txLF08RakTjjbca72QM9P47VuaJMHchiiYQfGrUxaQY9/lUuyR1DawpZLomXT9kV
fUuBUpYUO/Xta1zs/e6IudCJRL0h6Hlk2nLqV+zrjTNsbEhI+Ztd0Lv40VrIVfUJ
ZXMCNHomviUCwybnTodcUdtWYU5JqokjGWqYZawyErshiEew6AiM1e5CHkl0fDQU
OUSteni1sY0nJ32L74MN0A2vjPcOeY3lzE8FTxeY7BzbAorxELYD4jBXhopA0+MW
CPXS0xfn6crMm2vyFH+6YB2udPlLr1+n0qfxaYr36Tr+dZ81D0lJ5g5UjX4J6q3G
nqx/vxHjWYvTQpHVZCstuABCHad/J/0X9SRS4xwu4983bMwDOCfKCkF+RNitHfpO
/m+mzWJYEQokqKtj/V8i1PDUYhpWO9Kx7G2zQZ31le75zrcfKmBccid3m65Z0OAD
e0w8NfJ1NDwSFTl4duKB8gE5gNKuppuzLlDBQWhrqIK+5mKCapZ0sCjSqJjVxNjK
Q41Bm6/blVaF0IaP2fnjEbyQYhy9tbuVEwYZ630P5ctqCHxsZ40=
=cojg
-----END PGP SIGNATURE-----
--=-=-=--
