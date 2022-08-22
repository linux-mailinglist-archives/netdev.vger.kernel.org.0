Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F3359BBC6
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbiHVIh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiHVIh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:37:56 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE4E2CDDC
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=hsUU+M8inv09Ir/zuanJetA2licV
        zhMzd31+/Qc062w=; b=NVkwDgOPZ1Hr4Lbbc5MAOnCaS0237NRp8x6WfbIHtqB6
        tl44Pm5GFRZr3iwYxwD6MBg46TVQZADvJvH9nadaBmGhcAbsZbvFABrrQApeM7q9
        Ilo+UPZEiN0fsmswdxOcBBzTYUz3EXlL03V1LD1WWsL5CdmMChnOQUgfdWbFTUw=
Received: (qmail 1214028 invoked from network); 22 Aug 2022 10:37:47 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 22 Aug 2022 10:37:47 +0200
X-UD-Smtp-Session: l3s3148p1@MiDDXNDmnOkgAwDPXxw3AFlguiwjsjwa
Date:   Mon, 22 Aug 2022 10:37:47 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] s390: move from strlcpy with unused retval to strscpy
Message-ID: <YwNAW2Zp6o7Z//Y2@shikoro>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-kernel@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220818210102.7301-1-wsa+renesas@sang-engineering.com>
 <YwM4y78boN4s1VNo@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ABC3aCasbFWYlJHr"
Content-Disposition: inline
In-Reply-To: <YwM4y78boN4s1VNo@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ABC3aCasbFWYlJHr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Alexander,

> Could you please explain why you skipped strlcpy() usage in
> drivers/s390/char/diag_ftp.c and drivers/s390/char/sclp_ftp.c?

Sure. It is a bit hidden in $subject, but the key is to convert strlcpy
instances for now which do not check the return value. This is the
low-hanging fruit.

Converting the other uses checking the return value needs to be done
manually and much more carfully. I wanted to this as a second step, but
if you prefer to have everything converted in one go, I can give your
subsystem a priority boost. Would you prefer that?

Thanks and happy hacking,

   Wolfram


--ABC3aCasbFWYlJHr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmMDQFsACgkQFA3kzBSg
Kbbcew/9EjjU46h1Hw7hn47Z8s7LOJ86qovV0HqE8I6JiZmPknoKxmBppnvrlG/5
sGdJVtiWUpHmedA5M+DQYLFO2ZxeGeluaQOg22nsMbGmb7V7W0LosiZUm/Er7pOd
qbXdLrgVnDzWIRfDVEh0HvJT3RNrc8WhmrW5MeBW4Dnhvwccn6kxCnVVAb66lnQ5
m5qwdFjHgrCsf4QhNCZ1o8g/dwGjirIJjT7svqFirSMB81q3tNA/yNr2XLarOuDb
kCtKyKHOHr4Vzy4uxi6HnpvYz8nYE+tF04rB+nqNYLeCoEM8R42zz3kuaA95vQYg
3mcCYr3tZIGDZV6kdCYrFq2e9iQf2w3XmdrlSe31CBUGugL/jx89DOfNaOCUba1k
lWNdmUJDUmicmcBeR6Yv/arWqMnkmBLABURl9WmXmrbl6ya9Dh/bM3vjSV+WoJVv
GhiUgQKgEdi3pWhrRBYoRk//OtgEu5fxFIGs90DYlrXGLdsCQk3L0Ng/IR/MZ/jG
jZjkD/4arMVqz+EPOI9nhxflWh70q/oKgdvejgmsGIEz8EIxEyukvi61Ea/VDuJf
C96kGPeR6A0F2RiG0wtesUZM9PAE3TKr3LNDM4UNZ5/BgBVzD4XFCq3BKYHsHv/0
SMHb42lEJze4FeBTAJ+R+AjL1Ckgz4MzNG816dblvKDHfU5B24E=
=183G
-----END PGP SIGNATURE-----

--ABC3aCasbFWYlJHr--
