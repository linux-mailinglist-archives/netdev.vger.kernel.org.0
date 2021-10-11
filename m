Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0208428D86
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 15:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbhJKNIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236773AbhJKNH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 09:07:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44C8660F14;
        Mon, 11 Oct 2021 13:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633957559;
        bh=In4E+6cr9Be2j6eAW/yVU6t5z71IM4HG2jmgL8Vx968=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KT/8aS1asO8uz7YoJ8RY7DdJrB3iDczlOc3W2QvlJFSxGk3yxJPfrAloNi2BBeD11
         zUEd6+GB7aAjvAH9WzeQGhIdEqCwCOqbODEs29U8c9DUIeTif1tNBvPvX7wOU+1Gva
         UD3x/WtbmOn/lzZGULCO3dE4sewlq/jsLNCK8WA8uY31akdAHYC7kYK/qzhWbQ8wqu
         7pWIclIEGp/39GLyGLnibrt557Qe6IofKZXUKUF3rmpnHvhDERj7fIQhWdTCB7SCRK
         pp8fUlWw9p8giQIgkT63xzY47PXBkD25jhIiFgr4e6jR6uLA+ApiTsgVWccIFwu+Xm
         8V9qRKeO3rziQ==
Date:   Mon, 11 Oct 2021 06:05:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] ethernet: tulip: remove direct
 netdev->dev_addr writes
Message-ID: <20211011060558.3af0422f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ad38b125c5a95d283ce8787c245a4c19f3aa3492.camel@perches.com>
References: <20211008175913.3754184-1-kuba@kernel.org>
        <20211008175913.3754184-4-kuba@kernel.org>
        <ad38b125c5a95d283ce8787c245a4c19f3aa3492.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 08 Oct 2021 19:35:11 -0700 Joe Perches wrote:
> > @@ -1821,8 +1823,7 @@ static void de21041_get_srom_info(struct de_priva=
te *de)
> > =C2=A0#endif
> >=20
> > =C2=A0	/* store MAC address */
> > -	for (i =3D 0; i < 6; i ++)
> > -		de->dev->dev_addr[i] =3D ee_data[i + sa_offset];
> > +	eth_hw_addr_set(de->dev, &ee_data[i + sa_offset]); =20
>=20
> what is the content of i here?
>=20
> Perhaps you want
>=20
> 	eth_hw_addr_set(de->dev, &ee_data[sa_offset]);
>=20
>=20
> > diff --git a/drivers/net/ethernet/dec/tulip/dmfe.c b/drivers/net/ethern=
et/dec/tulip/dmfe.c =20
> []
> > @@ -476,8 +476,7 @@ static int dmfe_init_one(struct pci_dev *pdev, cons=
t struct pci_device_id *ent)
> > =C2=A0	}
> > =C2=A0
> >=20
> > =C2=A0	/* Set Node address */
> > -	for (i =3D 0; i < 6; i++)
> > -		dev->dev_addr[i] =3D db->srom[20 + i];
> > +	eth_hw_addr_set(dev, &db->srom[20 + i]); =20
>=20
> here too

Good catch, thanks.
