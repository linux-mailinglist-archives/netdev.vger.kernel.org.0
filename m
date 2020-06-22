Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C594C203A0B
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgFVOxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:53:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21706 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729180AbgFVOxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 10:53:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592837625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P7taa7KigpgUZeLwSBQmyXWitMWaWACRV2B/k/C5al0=;
        b=gRStwUcLtw61tpAoCwUgIqKOCrQA4OKSb9xWCrKE8qnzqjz5H7e4XFay7W9ZwO79e4TNSf
        nTV64SA6n7zpvQ7+5shsboCatJyJgpI+0HvxqxvsGXIzeNsO4mI8rOa01P8Ep3voHo0zQx
        6Dva+E5yASxXfEz5gb7GYs42vltpcQA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-x3kqhM1OPwqBVW3GnBwKbg-1; Mon, 22 Jun 2020 10:53:43 -0400
X-MC-Unique: x3kqhM1OPwqBVW3GnBwKbg-1
Received: by mail-wr1-f69.google.com with SMTP id i12so2691020wrx.11
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 07:53:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P7taa7KigpgUZeLwSBQmyXWitMWaWACRV2B/k/C5al0=;
        b=A4HmkV9G4t45QFgMfWDmBTYmQfp1YxpVr9Zd4xC5gPy2d6jH86t7NKpG87U0mV4Bn0
         p5Mo1mW+QeCHlUk8X4YfG/kmgDTBJRQ/tdcx47Bc0Il+DJ/F/e46PvAsdl2v5OdiWYDS
         pUJaCnOdMB1hZOoBIy0GAQue5XRy5O1z3EJCnSLL+CbuzEEpe27aI9ONek5PgzIyEqJQ
         9D+no7qjiXG0ECVsV+CfqXgpuhxkYRxCZjtk6BL6GD1LjPDGeL8CwwYpXcT/nDQzCVJa
         bDxsJmZIsuE71Q368bxaNynrXGbdUVPvzjnS83X/aHgMr9HKvRSTD6vrSPW9fjVusGC1
         RqfA==
X-Gm-Message-State: AOAM533NR7NqrLDsnkUNc9vQ/DVXfN1TAEV4W49QS7rTNqfF4f+SQ/jv
        ZeGO2Ctr+u4vNG02cPw4qqWb1D+VihPmFf/n+yyOCYayeY0HrBqIu5YVADyhtnUfBUmAqjfrIFO
        FzcshaxSic794Dmdt
X-Received: by 2002:a5d:4e81:: with SMTP id e1mr5512126wru.22.1592837622435;
        Mon, 22 Jun 2020 07:53:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUuKsQy1lYYQH5S5wcZD53SekQyD8JGsIHp4PC0g4E/zNEVCx/JYFP61TwuMuJ4vKGweBlJw==
X-Received: by 2002:a5d:4e81:: with SMTP id e1mr5512094wru.22.1592837622169;
        Mon, 22 Jun 2020 07:53:42 -0700 (PDT)
Received: from localhost ([151.48.138.186])
        by smtp.gmail.com with ESMTPSA id e25sm19318997wrc.69.2020.06.22.07.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 07:53:41 -0700 (PDT)
Date:   Mon, 22 Jun 2020 16:53:38 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Oleksandr Natalenko <oleksandr@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mt7612 suspend/resume issue
Message-ID: <20200622145338.GB27892@localhost.localdomain>
References: <20200618090556.pepjdbnba2gqzcbe@butterfly.localdomain>
 <20200618111859.GC698688@lore-desk.lan>
 <20200619150132.2zrc3ojqhtbn432u@butterfly.localdomain>
 <20200621205412.GB271428@localhost.localdomain>
 <CAHcwAbR4govGK3RPyfKWRgFRhFanWtpJLrB_PEjcoiBDJ3_Adg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
In-Reply-To: <CAHcwAbR4govGK3RPyfKWRgFRhFanWtpJLrB_PEjcoiBDJ3_Adg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hello, Lorenzo.
>=20
> On Sun, Jun 21, 2020 at 10:54 PM Lorenzo Bianconi <lorenzo@kernel.org> wr=
ote:
> > > > +static int __maybe_unused
> > > > +mt76x2e_suspend(struct pci_dev *pdev, pm_message_t state)
> > > > +{
> > > > +   struct mt76_dev *mdev =3D pci_get_drvdata(pdev);
> > > > +   struct mt76x02_dev *dev =3D container_of(mdev, struct mt76x02_d=
ev, mt76);
> > > > +   int i, err;
> >
> > can you please double-check what is the PCI state requested during susp=
end?
>=20
> Do you mean ACPI S3 (this is the state the system enters)?  If not,
> what should I check and where?

yes, right. Just for debugging, can you please force the card in PCI_D0 dur=
ing the
suspend?

Regards,
Lorenzo

>=20
> Thanks.
>=20
> --=20
>   Best regards,
>     Oleksandr Natalenko (post-factum)
>     Principal Software Maintenance Engineer
>=20

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXvDF7wAKCRA6cBh0uS2t
rJ4uAP9lKuUy0QTisY2SFP33vemkDckUeiQV2JsSGBnBdJ4FIQD/Yo4wkX1kg1Dr
YM/2gw/OmT+M00BF1XWr3MJF0Tx7sQo=
=rEPw
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--

