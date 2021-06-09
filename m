Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501D43A18C2
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhFIPO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:14:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230306AbhFIPOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 11:14:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623251543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9YaeZIMyQxtcpyjkUij4G1l5WZpuzj3dtoky0a3If40=;
        b=WeVM1B/Dm70EcKAuHPn9ft5xZzC4TE6fhGXptZGGaTjEU9kOa7cUCYBGt8SCgPdpVCVYpi
        hCh6ZqOw64tWGIWA+LFHz2mQHwu17bLgHtrcpOgAXYaJf6kYl9/NANfNiAxsk1wObWeEDP
        mVP01/gfxUkHLeqn6fbX5X17t+gaaeE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-fgZf8hOTOfiQLTJm921FFQ-1; Wed, 09 Jun 2021 11:12:21 -0400
X-MC-Unique: fgZf8hOTOfiQLTJm921FFQ-1
Received: by mail-wr1-f72.google.com with SMTP id m27-20020a056000025bb0290114d19822edso10904575wrz.21
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 08:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9YaeZIMyQxtcpyjkUij4G1l5WZpuzj3dtoky0a3If40=;
        b=Pnz9/x+E5MzTKOSBolXHaipHqwSPBXw18eMphg1gHTi+qzmIjvKCNiCmh8xX/Ka6t7
         UhjmjROcvHwqmscNz42WW5gAfPGOSiO4GoRzCMnWa9sJUcPSYBirh0nt9PTg/cDbpPyL
         dwnUBIjvW2G7uroi0hGP/rNwDvc6ARjZXZokXCTrfiG3FjRSbqpHI+qY/JiZE5FS3Lpb
         7r0FOVSK6cgtKOv+Q4qmZhmvZMgQzwzOCy0gOK9vKuCb70Hbi6ftAEmOEG6uWm4WbBw/
         PK6bRAxhRWXe8513fIVgZO8zjNoYrZSy/dOhLlu6CExTThIUMKsJ76+Mx2Nmhb/nN/dz
         LWfg==
X-Gm-Message-State: AOAM532wi8xJMIh8D3btI0y9ZfEX12iTi/d2OW2Rf2sJagkoNb50MomR
        1ohKu1n0dfussB3BLCgjjnEO4WYYnDlpAQPKpNdPeeL0KIuA5EU7HO4Yi89EMhJMKyEZcIutdDf
        bV8qBkiQNh1sobY0c
X-Received: by 2002:a05:600c:4148:: with SMTP id h8mr10251390wmm.176.1623251539921;
        Wed, 09 Jun 2021 08:12:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6m9O6G5/N2G6o4RM/fcpSx0DbTIqAvv9jWej7QLohnQTSBez1Kq1Ez7Anc94MrZG1KZfJCg==
X-Received: by 2002:a05:600c:4148:: with SMTP id h8mr10251378wmm.176.1623251539780;
        Wed, 09 Jun 2021 08:12:19 -0700 (PDT)
Received: from localhost (net-47-53-237-43.cust.vodafonedsl.it. [47.53.237.43])
        by smtp.gmail.com with ESMTPSA id 62sm300180wrm.1.2021.06.09.08.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 08:12:19 -0700 (PDT)
Date:   Wed, 9 Jun 2021 17:12:16 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [RFT net-next] net: ti: add pp skb recycling support
Message-ID: <YMDaUHrpniXOQ4ib@lore-desk>
References: <ef808c4d8447ee8cf832821a985ba68939455461.1623239847.git.lorenzo@kernel.org>
 <CAFnufp11ANN3MRNDAWBN5AifJbfKMPrVD+6THhZHtuyqZCUmqg@mail.gmail.com>
 <e2ac36df-42a7-37d8-3101-ff03fd40510a@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="es89WqdzKxuvZOp2"
Content-Disposition: inline
In-Reply-To: <e2ac36df-42a7-37d8-3101-ff03fd40510a@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--es89WqdzKxuvZOp2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> hi
>=20
> On 09/06/2021 15:20, Matteo Croce wrote:
> > On Wed, Jun 9, 2021 at 2:01 PM Lorenzo Bianconi <lorenzo@kernel.org> wr=
ote:
> > >=20
> > > As already done for mvneta and mvpp2, enable skb recycling for ti
> > > ethernet drivers
> > >=20
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >=20
> > Looks good! If someone with the HW could provide a with and without
> > the patch, that would be nice!
> >=20
>=20
> What test would you recommend to run?

Hi Grygorii,

Just pass the skb to the stack, so I think regular XDP_PASS use case is eno=
ugh.

Regards,
Lorenzo

>=20
> --=20
> Best regards,
> grygorii
>=20

--es89WqdzKxuvZOp2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYMDaTAAKCRA6cBh0uS2t
rKXUAP9/FuZ6t5h6zY/GgVaAxG6OcVeaG0DYPdx7P6iXLPfusQEA/ftma4O3dckN
uIm+c4YG8qn6ATcUkeslsMx0NxIiXQI=
=7q3T
-----END PGP SIGNATURE-----

--es89WqdzKxuvZOp2--

