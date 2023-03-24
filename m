Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEBF6C78E7
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 08:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbjCXHda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 03:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjCXHd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 03:33:27 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B796F1DB84
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 00:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=UMmp/4EUKVt/cI0P7zFZbonTYH6N
        d78n8J7R0k7kAis=; b=XfF2TL6fJLwTKEZ5tQLscuX9Nscgb0lrA6M/tz6axdQV
        eKXuMN99HhbEZLI9wJBFdVTv75cSv9wbKhfSkWXFcXb6GFSnvvHCEK176Pfjl+Uo
        ekTtatL5st72fuCaFegIEurCuQ/ORs4jGtha1vQaNw9fbJaYRM1LW/eanHR6GNg=
Received: (qmail 2199740 invoked from network); 24 Mar 2023 08:33:21 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 24 Mar 2023 08:33:21 +0100
X-UD-Smtp-Session: l3s3148p1@qvRZaKD3susujnv6
Date:   Fri, 24 Mar 2023 08:33:20 +0100
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net v3 1/2] smsc911x: only update stats when interface is
 up
Message-ID: <ZB1SQCOpLp0kDkm3@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20230322071959.9101-1-wsa+renesas@sang-engineering.com>
 <20230322071959.9101-2-wsa+renesas@sang-engineering.com>
 <20230323113945.0915029d@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ppsRxTzobnLW8AvR"
Content-Disposition: inline
In-Reply-To: <20230323113945.0915029d@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ppsRxTzobnLW8AvR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jakub,

> Maybe we should add a false-negative version of netif_running() ?
> __LINK_STATE_START*ED* ?

Sounds very reasonable, yet I am missing subsystem details to really
judge it. I just hacked a quick coccinelle script and 14 more drivers
could be happy about such a change:

 drivers/net/ethernet/3com/3c515.c            | 2 +-
 drivers/net/ethernet/8390/axnet_cs.c         | 2 +-
 drivers/net/ethernet/8390/lib8390.c          | 2 +-
 drivers/net/ethernet/dec/tulip/de2104x.c     | 2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c  | 2 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c | 2 +-
 drivers/net/ethernet/fealnx.c                | 2 +-
 drivers/net/ethernet/natsemi/natsemi.c       | 2 +-
 drivers/net/ethernet/realtek/8139cp.c        | 2 +-
 drivers/net/ethernet/silan/sc92031.c         | 2 +-
 drivers/net/ethernet/smsc/epic100.c          | 2 +-
 drivers/net/ethernet/sun/sungem.c            | 2 +-
 drivers/net/ethernet/toshiba/tc35815.c       | 2 +-
 drivers/net/ethernet/via/via-velocity.c      | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

The script:

@@
identifier name, args;
@@

	static struct net_device_stats *name(struct net_device *args)
	{
		...
-		netif_running
+		netif_opened
		...
	}


Thanks and happy hacking,

   Wolfram


--ppsRxTzobnLW8AvR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQdUkAACgkQFA3kzBSg
KbYhLBAAksx0IU69Au8T6ye1eIY4TAy0Lbe5V2uTgeWUVXx27ad0qp05EIutXb1R
iO4D3ZoJwOeKl9E+tWfqBvYB2tLLJpfH7hMpF+KG99HFvU3Vbxq+P/hHDG9Dlhxq
4H0GyrPZgLblQWB7afJERBE9jrdkMhxFDPcumtahzvAWh7JeztLQrlzRjQeyE5Hj
LNhPE8Xs4IIXsxNFq0i07UIoSPfAoW00gu6Ja3+lqCyf3MlT3xs3BZiJ7u7Uy85M
Hsh99irH3FBhTLO6fePRUUgrsF3tYrtQA1Lj9Og9PlbU7+IIErZ4Fpx7agcDi9iy
YvhjwJCcEFyYsLYHMo5YCcZrw22iUivAh8zaxMd68Thre///kqgCgNYLFIu9TLgu
QI/9fm/LoWuHf15WLV7SGhMeRIfQhnEr2BHpiWqAvhs5eHdmFGI1Rf2L8lw/+ALq
vbxcwi7trQMR2jrdKyaUNB5dkWoehEzjIIM56DeEKBzfLuTRTWnMBJ7o6yofFD4S
kAJSnkc4X9In09zD7ByXlNeOeC/RGIGuycoewqhckfa445GM9RqyH6o8w57wEmho
+JWA9tW0bACYfcr9b3qeidKTo8uTKKLzAncam/GDHP/hsEFB7Mzi+rZcdZF0HGlG
S1n2E/HBzXG+MgtkPaHZkKiywgv5TF6g5LUeI35dQMoAKLsPusc=
=lDO1
-----END PGP SIGNATURE-----

--ppsRxTzobnLW8AvR--
