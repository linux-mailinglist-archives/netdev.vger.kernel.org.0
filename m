Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287EF21FC11
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731349AbgGNTGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731233AbgGNTGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 15:06:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F99CC061755;
        Tue, 14 Jul 2020 12:06:18 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l63so7980844pge.12;
        Tue, 14 Jul 2020 12:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dis2Axh8nu/LnXyOn1Ig81p6hiXGxYYhmbDB5/bqa9w=;
        b=nKnjztoWW4r5dgyFftcVgr2qDuqoyMbVCh+vDcHreHYO05UJkttOF5A7NuNDKpa4C8
         DSFnU//iJjr828MdzBm0tdpt8Ar6E14VSRAkFkDHiIMH/XuudRk4IcFudlrf6F6PvFTh
         mkb0GWbhraZTis1rBSs5F4Oe5rDmRopimuXRRqdMsLpsjtB0/tB7wk44dqWI/v/2rZD/
         jjCStVgn8SH3UaiH1DjAc+oPXR2lRyCpLtWxjnZFifovkQhXEs2keYMSE0diaWCnMoDE
         TPrNuHxK+7svBNbIN23M47HPiwb3YWj3fyhs/iyHaHZJfxnt24P4enIvQm4a3rsFFiXa
         o/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dis2Axh8nu/LnXyOn1Ig81p6hiXGxYYhmbDB5/bqa9w=;
        b=Y3Sg/MgMRqXLz41Q+eNvUEIYKKMr4+AD+JwSh52iX9lsYQlV7jydh4lMeNAfOyCZdJ
         QqSy9WviAXjzGf4FB6M/y1c7efomexw7xju8xCr3FdL/G0Zj+08v6pSc+mFkgB9LDQL2
         o/hXP2KxhdF9FAZ9ZHBHgBJDToUrNNe8IpPDK7bEKwKpssy2cUSClO3cJN0Sqzp0SJWg
         hzOuJpNdOiBNBgwKg4TVtpU0NDkUM2lFJmV5RiyMrDRPgHUOhF1dWw30/Ng2/WcvdLyc
         7GeeuHWmo73StXeMIHWxmhlVQgKAlnrNq1AfbDGHr4puwtpsS15a4yhHd1qQ+rxGwm9s
         wlWA==
X-Gm-Message-State: AOAM5337tnk6XLBQ54FT8Xma3jtf7pxNC9pQGuVqO5DvBlYoBqPLvJ+2
        umbxOHghTpOLOypdxgvd0FE=
X-Google-Smtp-Source: ABdhPJzqOc25KQxV/43xB8LSAgishkvk4CxWlYfUS+MOK2vGNvUKObcXldECjTPHSs23wB/S8JIzuw==
X-Received: by 2002:a63:1007:: with SMTP id f7mr4428174pgl.147.1594753577662;
        Tue, 14 Jul 2020 12:06:17 -0700 (PDT)
Received: from blackclown ([103.88.82.145])
        by smtp.gmail.com with ESMTPSA id s131sm16775422pgc.30.2020.07.14.12.06.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jul 2020 12:06:16 -0700 (PDT)
Date:   Wed, 15 Jul 2020 00:36:02 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     Joe Perches <joe@perches.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] staging: qlge: qlge_ethtool: Remove one byte memset.
Message-ID: <20200714190602.GA14742@blackclown>
References: <cover.1594642213.git.usuraj35@gmail.com>
 <b5eb87576cef4bf1b968481d6341013e6c7e9650.1594642213.git.usuraj35@gmail.com>
 <20200713141749.GU2549@kadam>
 <a323c1e47e8de871ff7bb72289740cb0bc2d27f8.camel@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <a323c1e47e8de871ff7bb72289740cb0bc2d27f8.camel@perches.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14, 2020 at 11:57:23AM -0700, Joe Perches wrote:
> On Mon, 2020-07-13 at 17:17 +0300, Dan Carpenter wrote:
> > On Mon, Jul 13, 2020 at 05:52:22PM +0530, Suraj Upadhyay wrote:
> > > Use direct assignment instead of using memset with just one byte as an
> > > argument.
> > > Issue found by checkpatch.pl.
> > >=20
> > > Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
> > > ---
> > > Hii Maintainers,
> > > 	Please correct me if I am wrong here.
> > > ---
> > >=20
> > >  drivers/staging/qlge/qlge_ethtool.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/ql=
ge/qlge_ethtool.c
> > > index 16fcdefa9687..d44b2dae9213 100644
> > > --- a/drivers/staging/qlge/qlge_ethtool.c
> > > +++ b/drivers/staging/qlge/qlge_ethtool.c
> > > @@ -516,8 +516,8 @@ static void ql_create_lb_frame(struct sk_buff *sk=
b,
> > >  	memset(skb->data, 0xFF, frame_size);
> > >  	frame_size &=3D ~1;
> > >  	memset(&skb->data[frame_size / 2], 0xAA, frame_size / 2 - 1);
> > > -	memset(&skb->data[frame_size / 2 + 10], 0xBE, 1);
> > > -	memset(&skb->data[frame_size / 2 + 12], 0xAF, 1);
> > > +	skb->data[frame_size / 2 + 10] =3D (unsigned char)0xBE;
> > > +	skb->data[frame_size / 2 + 12] =3D (unsigned char)0xAF;
> >=20
> > Remove the casting.
> >=20
> > I guess this is better than the original because now it looks like
> > ql_check_lb_frame().  It's still really weird looking though.
>=20
> There are several of these in the intel drivers too:
>=20
> drivers/net/ethernet/intel/e1000/e1000_ethtool.c:       memset(&skb->data=
[frame_size / 2 + 10], 0xBE, 1);
> drivers/net/ethernet/intel/e1000/e1000_ethtool.c:       memset(&skb->data=
[frame_size / 2 + 12], 0xAF, 1);
> drivers/net/ethernet/intel/e1000e/ethtool.c:    memset(&skb->data[frame_s=
ize / 2 + 10], 0xBE, 1);
> drivers/net/ethernet/intel/e1000e/ethtool.c:    memset(&skb->data[frame_s=
ize / 2 + 12], 0xAF, 1);
> drivers/net/ethernet/intel/igb/igb_ethtool.c:   memset(&skb->data[frame_s=
ize + 10], 0xBE, 1);
> drivers/net/ethernet/intel/igb/igb_ethtool.c:   memset(&skb->data[frame_s=
ize + 12], 0xAF, 1);
> drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c:       memset(&skb->data=
[frame_size + 10], 0xBE, 1);
> drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c:       memset(&skb->data=
[frame_size + 12], 0xAF, 1);
> drivers/staging/qlge/qlge_ethtool.c:    memset(&skb->data[frame_size / 2 =
+ 10], 0xBE, 1);
> drivers/staging/qlge/qlge_ethtool.c:    memset(&skb->data[frame_size / 2 =
+ 12], 0xAF, 1);

Thanks to point this out,
	I will be sending a patchset for that soon.

Thanks,

Suraj Upadhyay.


--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8OAhIACgkQ+gRsbIfe
747ELBAAs7FgNTJ7W3h+3hC9u3/hxXbKnaUFn2p3NN9jueyMmRLgluBEOL2QrAg0
N7P6fqH88bOdPlD/j0qWnQphByOOc2/9JybZX3SSO/3xW8EikjguS51TAvL9KqII
rq4j9p1YbTkldB/Tv45oi3d1XRG49yKZJVufuMj8IFs7KGaiLpoZORIEeCprPrto
XGGch3crDCjqqDWf5Fb1EAVpDVvhlvLrBN2N25ZBklJ+45mS0/LlxapYcRX7uuDr
tqrXRNCjjOmwgBunvdgnmFEtXpcPevtCuSVjOmxH+r416yATcd9aGA1nii6OV1xo
p+vuoxeKxH0XMuQHkp+dY1pYyQTXrHpag4WnU8kZfVaml1sapsl87EYWM947iRR2
wILTcwjeTTGfwuVcNCLJx4NbuoEU7NbDJTkfu1FViQjInjBFSd4+jeTiFDxHKwQ+
J2JnJDRH/qTABra3zFpm4fTcMg6FxkF7MRZvCqtYhX18rVSWT6e8cWxmXiMelAlw
7RASpBrGF06kcLch/ML9kLdPrcvDMNYUHqPYlQPIfnv2KW2PWOalw1SvvTwwYL86
JE+AIa8cMVStylKFoEyNdfIadSjBRp5TtZcJpKBBL2A4eUlyF2P0KopArMgEdjVb
vHZhqJ1Gx3SlYewwRCNo31gxrGy83ol+/+6UsJY/j18ooV3AnQs=
=ZTrI
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
