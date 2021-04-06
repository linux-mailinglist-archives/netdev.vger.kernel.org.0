Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2495355578
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 15:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344628AbhDFNmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 09:42:55 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:49897 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229911AbhDFNmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 09:42:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 2E6231401
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 09:42:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Apr 2021 09:42:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=
        date:from:to:subject:message-id:mime-version:content-type; s=
        fm2; bh=9kNN3mgoUFPTThSZxzPeoVoiZE0YuE7oGNQUrds8CGY=; b=FOaS17g0
        M9Q2Ee9uY1DIMd5NzObvbTSQLmVZ/BvsubxD5kW6/rWh268utp8DolyS3toA7vLt
        JcPOWGPesgd6UN7OBiajOaOlILblljuOdJnjR0jepJ0vU0eHr68zTl0cSyeJUr2n
        2BRFtkmusU2pLh9CXJG5VZE02gW+FrvNTlIxdrixcXbt3RmjBc8AThe+A+zhPN9E
        GQ+OvTCusag4kcCriXDcgxodOjEDR5TTLL66mUrxh1r83EO3JBefl/ZGlCN3OzgD
        WAXHMVjV4bpN85rLEPPXQJxj55P7zyQPRwjLm6cHCCOhKqefMBMB7dBsNiSJ8wVD
        yffIMdEq0LNIOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=9kNN3mgoUFPTThSZxzPeoVoiZE0Yu
        E7oGNQUrds8CGY=; b=s3OagmSvhEVc7BaPyXUmvzJ/eHtrqZiP3z2VSmsSYc9TW
        GXp//J+7zni2d8RSz8XxGxkH8C8K+RIgMltIqu65ZUTiOnYK1VCXPHxjxCXTcTOE
        F/n59YP2ehMrzVoI/RJdNr0GAHPgyzQKExQ+wDI76LVmAC/VlHqWT08noYQG/H28
        V0yb5QCIdxB7FrYj52R6XIhIT/SBD1SQPjet6hDgKIlcHFjkQ0UzyTdrUl4exlxq
        bSJHx3RrosAtUhoIFyJ0mbiO2eE5aBVAfXQ+Lnig/3D2ViEzfOLwnaLTJWOigvg8
        4wpp8X5w2Zwn5PcZbTkT0IFz94PahG9yMfsK51nwA==
X-ME-Sender: <xms:U2VsYDIQd51llryFuX0cxwJR8d69i65yet0egQyD1H0PdQmLMifxFg>
    <xme:U2VsYHLtTJYWz6ifCoh6JV4cjdHroDYkPsyKnChwRRqXmNA7t8vl0rpViUF4-uKkr
    04tBqx54qfCCrvwJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejhedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkgggtugesghdttdertd
    dtvdenucfhrhhomheptehlhihsshgrucftohhsshcuoehhihesrghlhihsshgrrdhisheq
    necuggftrfgrthhtvghrnhepleelleffkeefueegheffkeekheetgfehtdejleeivdejhe
    duieelkeegleekhefhnecukfhppeekgedrudekuddrvdegjedrudduudenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehqhihlihhsshesvghvvg
    drqhihlhhishhsrdhnvght
X-ME-Proxy: <xmx:U2VsYLvdjdTpIXyN-et1K7Q2WC_-ngY3WX3hP-x6TOuOICtoYnAFdA>
    <xmx:U2VsYMbW5MxUoa5Og3HYWYmjmXt1CKdsp3C1JjK6YABsjZCchObNcw>
    <xmx:U2VsYKYaMcWs8L0MWNEuM6TNfBeg89qAxFZkx9RExIjKXM_KimqrtQ>
    <xmx:U2VsYDmP8jBJUor1Qi-u-1rfQwG8o2RspZOuRus_VCpHGgcLg9GXMg>
Received: from eve.qyliss.net (p54b5f76f.dip0.t-ipconnect.de [84.181.247.111])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67B9D24005B
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 09:42:43 -0400 (EDT)
Received: by eve.qyliss.net (Postfix, from userid 1000)
        id E72CE241; Tue,  6 Apr 2021 13:42:40 +0000 (UTC)
Date:   Tue, 6 Apr 2021 13:42:40 +0000
From:   Alyssa Ross <hi@alyssa.is>
To:     netdev@vger.kernel.org
Subject: [iproute2] finding the name of a TAP created with %d
Message-ID: <20210406134240.wwumpnrzfjbttnmd@eve.qyliss.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7w2ofzjmqsabqlra"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7w2ofzjmqsabqlra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

If I do

	ip tuntap add name tap%d mode tap

then a TAP device with a name like "tap0", "tap1", etc. will be created.
But there's no way for me to find out which name was chosen for the
device created by that command.

Perhaps ip should print the name of tuntap devices after they're
created?

I'd be interested in sending a patch, but I'd need some guidance on how
exactly it should work.  Would there be any harm in always printing it?
Should it be behind a flag?  Or just when the name contains a `%'?

--7w2ofzjmqsabqlra
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmBsZU8ACgkQ+dvtSFmy
ccAsIhAAh0kf3aYADnTlKrS0KW+zBXvC+OyueQ+IjBNzlJMqCaHhq1UuRs8QIzEc
Yrnj26zGxMGrRBlSPgd6u4J/x4LTQHHo1syOyIxWl66Sn1i+V4DvQ4nXCw8+7cG9
fHN2nGcP9win0Mht6xs4251XKGS3FW/s1cO1uea6uH4QYxd76DtkcnjobyR7hPI8
AnNGVcdFBQ3O67rcf3oXbgqWPrPD2gXU6wmayFcV0gaIu49dASih+h4ekwbIBxBJ
tEQcsvtbRw/BYDHr7FR6n8k9mM3i9wrKah+i6mGoZ7N+sQEygVzAqlcenvAV8Tzr
DcUx9/1EqSraYFHgAcTxGBZBDCjSjSrKdrF8uuXnM+ibBVkADCwT5/tMJoyoL74G
tyZlVOOKIv0vSYaSF5uvL7b6Yf/QqDpFddnKxGfD0gCeljmjeQmm1qVlTwmizx6L
wTKkZVXNnJiW7jMt6A1kZogCdOkdL3y5EtTVCxv/cT9SUV4ezWzlpdh6Te5XW0fo
atUwisauPPnLvgUh3CG00WXr5qw6nzljPOZt84KBunFIKv/xIK/SaHHfG3/HKrGF
HjjWWyGDZDBmWx7uNanxz3ckl9LrBVD0ELEVIXRhC3kUV2bU5t3I0B1E7wEGIWfy
+NZf54J/JhmfLlbPD67LZEfMjvIMd8oJMhZf4d/3hPQvRB+YDNY=
=+yRY
-----END PGP SIGNATURE-----

--7w2ofzjmqsabqlra--
