Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3092FE16C
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbhAUFRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbhAUFKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 00:10:01 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5745FC0613CF
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 21:09:21 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id be12so628080plb.4
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 21:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kSY/5AYG8hX3UgtzLkIjesTomZUwXKTeEa+6qnqVrs8=;
        b=s7Rtr5nwBtYAZt8fYawITENLODoNnnV1EYJcNXyLaiU5xVtZkETPk3E+wY2jDdRm3p
         vl1g3bghEQUzVVRDKijI8NOv28yUumHoY/S133+1JnQQNOD+6t/ECsOBGAuAKxFc0VnT
         qz5H2ILxWmTDpUzQsbkmbqTwztYApkddWwR6FWb2pMrVEcdLSEC2sUhBa+qmIAa28enh
         +wLm4ypSW/+nDjGa2IIj+Fyg25WZGlU8q0HRJZV+Jv/IffpXGITW5f9Y9NwRh+p7XRZs
         U6ZAy8jo4dJLMSBl2qOfc6w+50F4uqR4XmFYifHOm/1e7vM8Ap/dsXYCqeUxJCF0LZ0s
         Vh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kSY/5AYG8hX3UgtzLkIjesTomZUwXKTeEa+6qnqVrs8=;
        b=FzLQCLEAb925/Yki7Xrpkr2yz/mdNx/DnnLXQ28BaID4RvAyWiXqlG7Q5H5ioRbiM9
         GxhFN3VTqbYsSZ8CGq53dAkXfQ7fzSK1+b7GQXdnlpITxDp61fJtHhKnjcBDejNWMx5Z
         LjLthrgwNKmeRlGmJxwvKSsIwQO9JNsmOw3LnkkWvwWUGb329L8JaNP/3yy8E1ElCJaG
         YkeDCaHt3gcLXljieo4tOnXEAUptkjEBxRsT4yx7Ev+twnVA1547w7Pqx2BnJuINqzi2
         V5ST7dx3jCROae6nBGRIF/NL3DUpM0hrdx+0RwnaKOP2iy0ayJAHSNNjwpk87ciYwOPu
         chag==
X-Gm-Message-State: AOAM530ynEKIFcAxg7XawAnJsC8HsLCGhKg4+tsDxY5P0GVj4ljXZrKD
        v8L49o7L/McnVdyFJPL8SaE=
X-Google-Smtp-Source: ABdhPJwfUB4GPV400a7shEzl3NhZYmRPEobvybjGzA9ib4BGMif7LTx+lmtFzZffEEpct6pmTUO0QQ==
X-Received: by 2002:a17:90a:b296:: with SMTP id c22mr9592498pjr.91.1611205760913;
        Wed, 20 Jan 2021 21:09:20 -0800 (PST)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id fy20sm4352771pjb.54.2021.01.20.21.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 21:09:19 -0800 (PST)
Date:   Thu, 21 Jan 2021 13:09:10 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     sundeep.lkml@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, gakula@marvell.com, hkelam@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH] Revert "octeontx2-pf: Use the napi_alloc_frag() to alloc
 the pool buffers"
Message-ID: <20210121050910.GB442272@pek-khao-d2.corp.ad.wrs.com>
References: <1611118955-13146-1-git-send-email-sundeep.lkml@gmail.com>
 <20210121042035.GA442272@pek-khao-d2.corp.ad.wrs.com>
 <20210120205914.4d382e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
In-Reply-To: <20210120205914.4d382e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 20, 2021 at 08:59:14PM -0800, Jakub Kicinski wrote:
> On Thu, 21 Jan 2021 12:20:35 +0800 Kevin Hao wrote:
> > Hmm, why not?
> >   buf =3D napi_alloc_frag(pool->rbsize + 128);
> >   buf =3D PTR_ALIGN(buf, 128);
>=20
> I'd keep the aligning in the driver until there are more users
> needing this but yes, I agree, aligning the page frag buffers=20
> seems like a much better fix.

It seems that the DPAA2 driver also need this (drivers/net/ethernet/freesca=
le/dpaa2/dpaa2-eth.c):
	/* Prepare the HW SGT structure */
	sgt_buf_size =3D priv->tx_data_offset +
		       sizeof(struct dpaa2_sg_entry) *  num_dma_bufs;
	sgt_buf =3D napi_alloc_frag(sgt_buf_size + DPAA2_ETH_TX_BUF_ALIGN);
	if (unlikely(!sgt_buf)) {
		err =3D -ENOMEM;
		goto sgt_buf_alloc_failed;
	}
	sgt_buf =3D PTR_ALIGN(sgt_buf, DPAA2_ETH_TX_BUF_ALIGN);

Thanks,
Kevin

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAmAJDHYACgkQk1jtMN6u
sXFD5wf+NDBEf+EmxJVEN/FmBoXcFzUlfcufyoniDtXxyOcjoD3QdNfXWYud/3+S
dgQ9yDWVRrEL7txqNd/NzETl/e6FfJCpTJKgxKsjDskqBxZByZymBF4lAdtSYxpc
TwmRig0X04fmrQOJ+ep8fcbvQUi3sEASmEy3/IsmiU8oP5KhLIFx7wQUswSw4pRd
7wNR9FRL0KMawT0W9p3X5MV4zeEoUWTJB56xhDWBwY8/0rnHGTjTgnM0z+BQfufN
8HSmIw2y712V4XYWgtDMT2+vlAtsjKxdaOyGB3Bl0MLA5TM5uWZRXSA2cI+D9+27
fcwcFWCnPjB6KMzvmWVJXINa1YZbgg==
=xyti
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
