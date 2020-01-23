Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB8B146F23
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgAWRFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:05:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbgAWRFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 12:05:19 -0500
Received: from cakuba (unknown [199.201.64.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 068332071E;
        Thu, 23 Jan 2020 17:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579799118;
        bh=JmMkTCIRnF5m69kGwc57CEow6KknTGv6pkc+iBzaYJU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aAAPQcgVy8D/Yvvt02cbcfyopXorA+f1VwSPLRXwa+0k25xeIlbRguxJBCE6TR22+
         8AQ2tH2UI4QcYEXyHX4CKv7HUZMjIEIuDtzB0e2ze/Knuj+zf7jVJRqR8FR4GLWgV7
         2pyvLjhWJ7aHvbOqnx3nK6DPy8gBF3zlJu9rCb7A=
Date:   Thu, 23 Jan 2020 09:05:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH v2] mvneta driver disallow XDP program on hardware
 buffer management
Message-ID: <20200123090506.1b053a92@cakuba>
In-Reply-To: <D1D78C6F-B2B2-4E55-8350-74DCBDB1EE01@voleatech.de>
References: <D1D78C6F-B2B2-4E55-8350-74DCBDB1EE01@voleatech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jan 2020 08:16:55 +0000, Sven Auhagen wrote:
> Recently XDP Support was added to the mvneta driver
> for software buffer management only.
> It is still possible to attach an XDP program if
> hardware buffer management is used.
> It is not doing anything at that point.
>=20
> The patch disallows attaching XDP programs to mvneta
> if hardware buffer management is used.
>=20
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Your patches keep getting corrupted by your email client or server.

> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet=
/marvell/mvneta.c
> index 71a872d46bc4..96593b9fbd9b 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -4225,6 +4225,12 @@ static int mvneta_xdp_setup(struct net_device *dev=
, struct bpf_prog *prog,
>  return -EOPNOTSUPP;
>  }
>=20
> +if (pp->bm_priv) {
> +NL_SET_ERR_MSG_MOD(extack,
> +   "Hardware Buffer Management not supported on XDP");
> +return -EOPNOTSUPP;
> +}

This is white space corrupted

>  need_update =3D !!pp->xdp_prog !=3D !!prog;
>  if (running && need_update)
>  mvneta_stop(dev);
>=20
>=20
> +++ Voleatech auf der E-World, 11. bis 13. Februar 2020, Halle 5, Stand 5=
21 +++
>=20
> Beste Gr=C3=BC=C3=9Fe/Best regards
>=20
> Sven Auhagen
> Dipl. Math. oec., M.Sc.
> Voleatech GmbH
> HRB: B 754643
> USTID: DE303643180
> Grathwohlstr. 5
> 72762 Reutlingen
> Tel: +49 7121539550
> Fax: +49 7121539551
> E-Mail: sven.auhagen@voleatech.de
> www.voleatech.de<https://www.voleatech.de>
> Diese Information ist ausschlie=C3=9Flich f=C3=BCr den Adressaten bestimm=
t und kann vertraulich oder gesetzlich gesch=C3=BCtzte Informationen enthal=
ten. Wenn Sie nicht der bestimmungsgem=C3=A4=C3=9Fe Adressat sind, unterric=
hten Sie bitte den Absender und vernichten Sie diese Mail. Anderen als dem =
bestimmungsgem=C3=A4=C3=9Fen Adressaten ist es untersagt, diese E-Mail zu l=
esen, zu speichern, weiterzuleiten oder ihren Inhalt auf welche Weise auch =
immer zu verwenden. F=C3=BCr den Adressaten sind die Informationen in diese=
r Mail nur zum pers=C3=B6nlichen Gebrauch. Eine Weiterleitung darf nur nach=
 R=C3=BCcksprache mit dem Absender erfolgen. Wir verwenden aktuelle Virensc=
hutzprogramme. F=C3=BCr Sch=C3=A4den, die dem Empf=C3=A4nger gleichwohl dur=
ch von uns zugesandte mit Viren befallene E-Mails entstehen, schlie=C3=9Fen=
 wir jede Haftung aus.

Something inserts this footer.

Please try git-send-email for sending patches. If it's the server you
need to find a different one.
