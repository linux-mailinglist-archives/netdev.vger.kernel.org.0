Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0B5B50E3
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 16:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbfIQO7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 10:59:17 -0400
Received: from kadath.azazel.net ([81.187.231.250]:50678 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbfIQO7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 10:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C8TQmvkPKAOAup0/mB2BEf4yrtgGv/WnkEAhPEPVr8g=; b=VEpq3EXKynSpDcVtK4UoA4wcCv
        hoEbEZmsb4FPXYyKe1ClB+clBkYSP+a9eMwxzBmExTKstbDO5dD3VTROPfxCbJJFnxBQhJRmEAcWZ
        sDkILC17JL106f2HCmj5HxvF1FkaKJSZd3mxHLnnu5Z9oCo1wdCMzVmLH1NRgxXGRP6yHX1x2gMVL
        Ztnjl7R/eK12IAvpH6bEIcrivpT5L2Rzou+D02ToI6jrzXyt0KyQiMQtvmjvaP7mSbT0dNEAOHQAt
        +5m53iLxT61OTkV2HYJZkZZVbV3ST9yoskXLuV1LYbb9121VCKnibraWSdPMP9oxmJEn/ySLGy/Ut
        FTueFv/A==;
Received: from pnakotus.dreamlands ([192.168.96.5] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iAEwe-0008LI-7J; Tue, 17 Sep 2019 15:59:08 +0100
Date:   Tue, 17 Sep 2019 15:59:08 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Adam Borowski <kilobyte@angband.pl>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: bridge: drop a broken include
Message-ID: <20190917145907.GA2241@azazel.net>
References: <20190916000517.45028-1-kilobyte@angband.pl>
 <20190916130811.GA29776@azazel.net>
 <20190917050946.kmzajvqh3kjr4ch5@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20190917050946.kmzajvqh3kjr4ch5@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.5
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-09-17, at 07:09:46 +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 16, 2019 at 02:08:12PM +0100, Jeremy Sowden wrote:
> > On 2019-09-16, at 02:05:16 +0200, Adam Borowski wrote:
> > > This caused a build failure if CONFIG_NF_CONNTRACK_BRIDGE is set
> > > but CONFIG_NF_TABLES=3Dn -- and appears to be unused anyway.
> [...]
> > There are already changes in the net-next tree that will fix it.
>
> If the fix needs to go to -stable 5.3 kernel release, then you have to
> point to the particular commit ID of this patch to fix this one.
> net-next contains 5.4-rc material. I'd appreciate also if you can help
> identify the patch with a Fixes: tag.

The commit in the mainline that needs fixing is:

  3c171f496ef5 ("netfilter: bridge: add connection tracking system")

The commit in net-next that fixes it is:

  47e640af2e49 ("netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check =
to header-file.")

I applied it to the mainline and compile-tested it to verify that it
does indeed fix the build failure.

=46rom my reading of stable-kernel-rules.rst and netdev-FAQ.rst, it
appears that the fix should come from the mainline, so I will wait for
it to get there.

J.

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2A9K8ACgkQ0Z7UzfnX
9sMMfg//UW4T21PuLvesjUcpNbOxecnpOHRVWY5SGHpeVpgW7aO+PLxxNswwNA8E
icSuIznj2J/EyHg9ZDeUrd6VqTxWxmQeqkhYJ3G9geLkI2bqDtxXW6dIuSD04FPB
wIQ24eC8phPjlvwWkraWET9reEq8WNgc+ekCaE+7+9WyQBPa8x0r1jEJlSvcfPiH
xDPiwecuoYaJSusZkkW888eF1tFPYML+QGIXrBT7bQOA7tO8PtrLqGnXGFlh8OIa
EwvYTsA47b6UvDR99UVXPvGsjDzCOBGF0tKRpO5ghgq/O9rnbUt9tvb+njHU10ff
/RJTvKNMNPaWTbjM/SCTnkCRXx6qgZhFk8DclJHJRLiYoiRkFwsMx18lGS/dzmd7
Yf9RXkKXFjixCwOJojUfKjDWc+JS8KOq1HlA6QCGffaqEaJQB+o2uEzxtrmIOr2I
nhly+fgfHTqvQoyWM0lLlibR/S/8sNm3gqOmsKrTNY9oZCx9zHFjPOsI7/GtGSQC
BRJbVWj7egsBMAQJP37hNcAoyvPbwpfkm3jt6n/yilKlmXvQkbU8+Pz5NrYx42xM
XKLw/lmmEXgWd1924Si31NWllVK1MVerquNWe/1JPkKV4EFAR08z2iNEXd6TLtAk
YII6g7O8yT2FwAGJfqy8kW/2SlEve4YE5pnxtnhoV3BWN0XaBVo=
=bzR5
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
