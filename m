Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA5624A7A8
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHSUWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:22:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43182 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725275AbgHSUWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:22:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597868551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=30pRxgpb/X5z76UuhoqOgt/D4/g/GAmm4SymKXd6j4g=;
        b=GYGQkQ9fruR9nEuRHTw9+r3ZhfSQt5zYeEuONfmwi6El4lDUGuDbAKEFwVnnpaB7906nOR
        xDd/tAQgNPNePwmLZFxR0VpXl/qraaKRj50s3Lt/M0Ime+EGsLavjWQpDlRAjn8egNz8NX
        nIQ2gvZ6RfOAvK356gPLsoKNlOHUwSA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-UcSMkTr1MmW-Byd5N3EGHA-1; Wed, 19 Aug 2020 16:22:29 -0400
X-MC-Unique: UcSMkTr1MmW-Byd5N3EGHA-1
Received: by mail-ej1-f70.google.com with SMTP id l7so8747860ejr.7
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 13:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=30pRxgpb/X5z76UuhoqOgt/D4/g/GAmm4SymKXd6j4g=;
        b=UdWljBiRcF6m4oXPL5Y212R2wnKptOdwQ7YpdP9g6vG71byCp50zAtHcr3CkgOrxxu
         Sd/CqzFIZ+VcbK4DzmoZlQHPxV23axik+MJBtWJM7U0P3CfuN4O4I4jJYejFIUEgK3Bh
         GeXHTRDSoUNvP1IbJUfwM1yRxHl2iQFKSTf3khtWZitKlJHsu0uBXwDQNI4SHchrW8Rz
         1xnGWRy+Es3pbK9Je8adH76wAOS+re+q1BdtjET3OgGJbbwbdQLxfSIX6qC4yJqdDjhu
         M6L4ICTBaC6b43fy1TSkMqXRcP46uCA/WHZgk45HCybRcx2vbKKu1xy4xOb/jTC+o1FA
         q0IA==
X-Gm-Message-State: AOAM531u/uebVt0on146PwsEtJI2xZJFn4+jg4kP2YR4Um26IqU24qzL
        fPn9GIfpCHIq35CdCvlAAbt0bABZBi5Xza6U8caj5CB1/ZB6l9wwAQlky+USalaPudeW6Tjo0jf
        ebO1A9qGQgcaehQgj
X-Received: by 2002:a17:906:c1c3:: with SMTP id bw3mr78713ejb.8.1597868548047;
        Wed, 19 Aug 2020 13:22:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyc3avTSjMLasP8V4G4UGGFPClYBfNVuDPI6MBIpYJaTZBOzHzeefmx7boqbsNu5nxkpm5U/g==
X-Received: by 2002:a17:906:c1c3:: with SMTP id bw3mr78699ejb.8.1597868547845;
        Wed, 19 Aug 2020 13:22:27 -0700 (PDT)
Received: from localhost ([151.48.139.80])
        by smtp.gmail.com with ESMTPSA id h10sm18183609eds.0.2020.08.19.13.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 13:22:27 -0700 (PDT)
Date:   Wed, 19 Aug 2020 22:22:23 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com
Subject: Re: [PATCH net-next 6/6] net: mvneta: enable jumbo frames for XDP
Message-ID: <20200819202223.GA179529@lore-desk>
References: <cover.1597842004.git.lorenzo@kernel.org>
 <3e0d98fafaf955868205272354e36f0eccc80430.1597842004.git.lorenzo@kernel.org>
 <20200819122328.0dab6a53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <20200819122328.0dab6a53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 19 Aug 2020 15:13:51 +0200 Lorenzo Bianconi wrote:
> > Enable the capability to receive jumbo frames even if the interface is
> > running in XDP mode
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> Hm, already? Is all the infra in place? Or does it not imply
> multi-buffer.
>=20

Hi Jakub,

with this series mvneta supports xdp multi-buff on both rx and tx sides (XD=
P_TX
and ndo_xpd_xmit()) so we can remove MTU limitation.

Regards,
Lorenzo

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXz2J/AAKCRA6cBh0uS2t
rBhfAQC+AqLFEiEDJqR1kuUxLxcP0xQr0httOlucio2HzQBAPwD+MnElkBxvQd19
zewpQ1Jodq11yTSnRDGNrzdlciSN5w8=
=IXWQ
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--

