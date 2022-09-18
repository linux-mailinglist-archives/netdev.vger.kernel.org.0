Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CF65BBDD0
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 14:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiIRMl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 08:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIRMl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 08:41:58 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A6B21800
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 05:41:57 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 34C7C5C017F;
        Sun, 18 Sep 2022 08:41:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 18 Sep 2022 08:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1663504914; x=1663591314; bh=bKbdWKvAtc
        oz9rUvoSebxEYZUmTL5GNyMUEKwzf4WLU=; b=t2tGHHdT6mR3Dzm45cLy2c0N45
        czn2DpDXwmJcUqdFxPZd4t0TIkVsTTjXw1k5CM1o4dB97ptpurCZM1fe04madBt0
        dJYJ+rPrN3Cg2J7MHaVgOOVckLWZr4Yo8cdqvS7Aq8fw/ataY+Shr1J0wiUMPzKO
        6kxhgXcdi1ijpPBlWMA0bALNWAC7wANzWdCQByS7kQKVdzVBI4LOtTJJejRLgIWF
        kWktJv9kvIj8O2bi1EGaaNG3kn/QnCRspS5WZqIMJSvKSTQ3afbtGeRGUVMD7gG6
        4pVZ4ZAr3DelTmLtflgguDEy8qTqKH5P773ObSac51Th+Mp9bwxL1im66bZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1663504914; x=
        1663591314; bh=bKbdWKvAtcoz9rUvoSebxEYZUmTL5GNyMUEKwzf4WLU=; b=g
        3+MCzkuB6BzFOCFNv6/H9boIdyDFvZf5lng7cUTn7MstVkeGcNVuZ9TKKy9xN0Eo
        IcIfNbjuU52hzERz1/ZCfKALGIgtQzS6PxnwIb1cSr4l1orvue77A8j5JvWT9d5H
        OMXZ7C4QE8VfsTP6ujbvSOFaP0Kt02ntQk0P0ecUw2kWrfWXFaiMo6rD8WuM7ctv
        6fiBvh/C1OkaOq2/rgAEIaVmeX1WerY2X//M/tr85/aqGpLlZsZIwushNzt6U7cx
        nA7DN8rLNkqI5XAP83GTJUHWszmOWL5YypbB8A296Vuof9/xHJREK9D9x2X/Mmz/
        MiN23exWXm3SEpcFU7Wag==
X-ME-Sender: <xms:ERInY2Z9dTsR1tZpfPpTgxARdHjLLQW1OUkBKOsP298vzc97mrEvzg>
    <xme:ERInY5YkrjV8xYjDD-cmtJztIJ1HiumFH_taeTypnczJ9e0Qr19B6HsNjoVsfYdMC
    Gwa5YaYrTCM7iQ>
X-ME-Received: <xmr:ERInYw-wrBW6Xd5L9zpYeMuI0N3hELUF_MZllh26uqPJaFBGiSNMQHq__dCo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvhedgheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfggtggusehgtderredttddvnecuhfhrohhmpeffvghmihcuofgr
    rhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgshhlrg
    gsrdgtohhmqeenucggtffrrghtthgvrhhnpedujefgjeeggeelhfevkeeltdekvdeuhfet
    iefffefhkeehhfevhefhkefgudegkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhgshhlrggs
    rdgtohhm
X-ME-Proxy: <xmx:ERInY4rca_VtXuXarR5BKJSF_8_sU7mrbpFlhNmCgpLpZO7zaopwzg>
    <xmx:ERInYxqnjJ5mZJ5Cy-lAqQtnjdkOiBB_KHw76zKCnFs6rVwmTh5xJg>
    <xmx:ERInY2Qe4_g3yC6u5sT7xn5Io7FoELy8ZbzVMZVQSk4uWE_9Vmzx4w>
    <xmx:EhInYzEUnverJp5ArUTZGBba0ELmg_qKAeoG4QA-XaHS30dGpo4iuA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 18 Sep 2022 08:41:53 -0400 (EDT)
Date:   Sun, 18 Sep 2022 08:41:25 -0400
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Xen developer discussion <xen-devel@lists.xenproject.org>,
        netdev@vger.kernel.org
Subject: Layer 3 (point-to-point) netfront and netback drivers
Message-ID: <YycSD/wJ9pL0VsFD@itl-email>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="abVE5BDavORpi+Qm"
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--abVE5BDavORpi+Qm
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Sun, 18 Sep 2022 08:41:25 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Xen developer discussion <xen-devel@lists.xenproject.org>,
	netdev@vger.kernel.org
Subject: Layer 3 (point-to-point) netfront and netback drivers

How difficult would it be to provide layer 3 (point-to-point) versions
of the existing netfront and netback drivers?  Ideally, these would
share almost all of the code with the existing drivers, with the only
difference being how they are registered with the kernel.  Advantages
compared to the existing drivers include less attack surface (since the
peer is no longer network-adjacent), slightly better performance, and no
need for ARP or NDP traffic.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--abVE5BDavORpi+Qm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmMnEg8ACgkQsoi1X/+c
IsFkEg/8CWRHrWImZE0hPlNZ9964WWkwqv1l9jOWxrPGFS06OEjgvaVqr7bgNPlm
S6tBi9Nh56qNDt6O5QIHtrnFF9oxr74LUq2d9onPQAsClpa655wuHohsEwN73iMg
nvuF9Z/4aCkaExU14U2xxVKbH0PNSf9nW0raUzhoE3DH4gXYT3xTCsVA2Nw4+rVc
p/DhtylzMs9A2Bk0HaYXIJUtpR7MRL17fi9CDStrXmAbP0naiwSnzHcKkccN/mox
cC/cZvGl0t6Y2ZPnfI0eBkmmW94tf4M8alJtAQyAwVYjHhwMjogIN4mbcJkqfhhW
pN3aT9RIhfI2EUUiKUmVTF8HFlgdRzn4GiemjnPYbQYTS39cQ0OZIxIvL1LGCfua
s2Hsdz8FH36kIamGnHioNocyu9/nZBJOQDGATGM0/1Vk+P7wfC1ZJE4t4cgqPEde
EdcSz4ck48dXH4LVRKpWAL5qI50ZHeNXzBF7lS7AurBDtEH1C1JVaA3puVd/TjAg
mQcBDemE3fqWhH5II3ITZdwnVbmbz35vMuwxAO4EzUqRwDv2M8SR9QLjxxPN0AdA
MM88y5yQcpOTSYh5kHgaokiSaQ+9ZUuYOpraJLiBlaxud+42cN1e4lZB23s+UPAz
VVIXnrvBZYuFRF2PMqNOMKolStQrL+xEk6MNOj1h+H//YW1imAE=
=b4ml
-----END PGP SIGNATURE-----

--abVE5BDavORpi+Qm--
