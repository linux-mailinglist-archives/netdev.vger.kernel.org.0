Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26EE21F7E68
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 23:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgFLV20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 17:28:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46501 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726268AbgFLV20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 17:28:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591997304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TW2nx5WWXbFPBi4Mk8tz3cvBo7pFmy+AvbWf/yoODgA=;
        b=Tjbab+ynLo4KqZkK/U3Eje3idtaEYN+hkbCZ5HqiMI4eKAdN+vXlLXBW09+P/AGj2ZeEDi
        NmtyvONpdeeJ/hO5Aa8qilLwS1nWydFohMAaBSydoHGN7Z5kKbsrkFO3l+VAVf33NLJy9j
        lQb0L/NWEEwUiUGstZx5nm2bhevpRZU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-jo6PRzqlOquOmQ0YSTtz2w-1; Fri, 12 Jun 2020 17:28:22 -0400
X-MC-Unique: jo6PRzqlOquOmQ0YSTtz2w-1
Received: by mail-wm1-f71.google.com with SMTP id a7so2462884wmf.1
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 14:28:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TW2nx5WWXbFPBi4Mk8tz3cvBo7pFmy+AvbWf/yoODgA=;
        b=fiRuXQ9eRqU+cQUayse7KdTK1UEGOM9WFMuL7+3rJu+iAF2HhwMiXEELDIIWY4djEm
         3/PZCFdz4mnkpX5f4JWPZyU8pYClR+33pdJ2MoJyww4tPU+AtEwj4MAyn3FQ0TOsgANo
         Dd7H9qzPAHs/owF++ORlEEuKfdKjyy53D/dLq1u2niS97VUV00EjJHS2vuJE+P4PO50e
         OWH5dRgWYh6cOM/M5qaOIpds0abjCBdgsYV1tH95e0HB6RlQnPmV/24fKzTVhsfnRQNC
         7FgLHExADaBr7wdF9mSUmXJR4hl/emS8fl4J0joNQpi/9yUOatL87XwjXShAsjFMtpcW
         uY9Q==
X-Gm-Message-State: AOAM533RmDgTDIfu2tbKvfJJDcYZIPdI6GJAbzDupOLPpFH+DfLOGoPR
        Mecmj9huF1e5pG1GRUR8dqkZ7brHypGt0GCkLCA9Qn3DLlZ+8xL+bUa/p0sDpdJVH4eRzMGU61/
        69pf2JIS3ujV7DSbX
X-Received: by 2002:a1c:4008:: with SMTP id n8mr893846wma.118.1591997301168;
        Fri, 12 Jun 2020 14:28:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1wFg10X4H7zfzWI1nhrnpvtQgip/lXEddA0f+MCya6ZKaxFsHYQvd9EwRMYPxbWHDb6ukzA==
X-Received: by 2002:a1c:4008:: with SMTP id n8mr893841wma.118.1591997300926;
        Fri, 12 Jun 2020 14:28:20 -0700 (PDT)
Received: from localhost ([151.48.140.182])
        by smtp.gmail.com with ESMTPSA id t188sm10668408wmt.27.2020.06.12.14.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 14:28:19 -0700 (PDT)
Date:   Fri, 12 Jun 2020 23:28:16 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     lorenzo@kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com, brouer@redhat.com
Subject: Re: [PATCH net] net: mvneta: do not redirect frames during
 reconfiguration
Message-ID: <20200612212816.GB782829@localhost.localdomain>
References: <fd076dae0536d823e136ab4c114346602e02b6d7.1591653494.git.lorenzo@kernel.org>
 <20200609.142901.3888767961952002.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <20200609.142901.3888767961952002.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> From: Lorenzo Bianconi <lorenzo@kernel.org>
> Date: Tue,  9 Jun 2020 00:02:39 +0200
>=20
> > Disable frames injection in mvneta_xdp_xmit routine during hw
> > re-configuration in order to avoid hardware hangs
> >=20
> > Fixes: b0a43db9087a ("net: mvneta: add XDP_TX support")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> Looking around, I wonder if the fundamental difference from the normal
> TX path is that the XDP path doesn't use the TXQ enable/disable
> machinery and checks like the normal ndo_start_xmit() paths do.
>=20
> And that's why only the XDP path has this issue.

yes, I agree

>=20
> I'll apply this, so that the bug is fixed, but note that I consider
> this kind of change adding a new flags mask and one state bit to solve
> a problem to be ultimately inelegant and ususally pointing out a more
> fundamental issue.

I am completely fine to find a common solution since it seems a pattern used
even in other drivers (e.g. bnxt). Reviewing the code probably we need some
checks in __xdp_enqueue() since xdp_ok_fwd_dev() checks just IFF_UP flag.

Regards,
Lorenzo

>=20
> Thank you.
>=20

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXuPzbQAKCRA6cBh0uS2t
rDhlAP9cNTZhLxuzimBe9uhRXqIkZBpoSXQQlJ+eqs/3A6evYAD/cxSGfppBoNDy
Pqfpb4QALvxe2z75P7FiG/jfYqAH3Q8=
=l6SM
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--

