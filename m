Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954F02CF40E
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbgLDS2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:28:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbgLDS2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 13:28:34 -0500
Date:   Fri, 4 Dec 2020 10:27:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607106474;
        bh=7QObN262lN7U2H2PbSCYY4+ZzUd87AL0IMmRt7dNZDA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=ECF6oIUCmzXtNAnIrA38lCryDwEWhqCGEOayiMZlK4u98JnrMB8l5R9t11oHcgf6M
         EsraJgTO2dhqi+Ngq177KtVqsQsOh2XNeU+ZFhomDlT7HcxPhvmexd1+DHmEemNqzA
         wbNR8Y+MP5mKNb13bVZcwDxWG6E9POEaC5Z8rmQM15gRa79gtGWzOhkad3f4hyYcAK
         Dj2p2SwcMys0a6qu01STum9RzmjwVk+1rKJkrJ+QtKHH/9GJp0aFwMVrKSvyEUkznu
         zodKh4CM1OkJ1hhl+mVefx4MI0HnwqkV8T81ECDmBGX6Ai76/sNnHn4UCHl73SRuIm
         KMNCEcAgF0Aqg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Anders Roxell <anders.roxell@linaro.org>, madalin.bucur@nxp.com,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] dpaa_eth: fix build errorr in dpaa_fq_init
Message-ID: <20201204102752.4bfac75d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAJ+HfNg97HtDciv_z8F6Gs5Yncuua2Gx27HLxCYBNmA9Bk1jxg@mail.gmail.com>
References: <20201203144343.790719-1-anders.roxell@linaro.org>
        <CAJ+HfNg97HtDciv_z8F6Gs5Yncuua2Gx27HLxCYBNmA9Bk1jxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 15:49:21 +0100 Bj=C3=B6rn T=C3=B6pel wrote:
> On Thu, 3 Dec 2020 at 15:46, Anders Roxell <anders.roxell@linaro.org> wro=
te:
> >
> > When building FSL_DPAA_ETH the following build error shows up:
> >
> > /tmp/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c: In function =E2=80=
=98dpaa_fq_init=E2=80=99:
> > /tmp/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:1135:9: error: too =
few arguments to function =E2=80=98xdp_rxq_info_reg=E2=80=99
> >  1135 |   err =3D xdp_rxq_info_reg(&dpaa_fq->xdp_rxq, dpaa_fq->net_dev,
> >       |         ^~~~~~~~~~~~~~~~
> >
> > Commit b02e5a0ebb17 ("xsk: Propagate napi_id to XDP socket Rx path")
> > added an extra argument to function xdp_rxq_info_reg and commit
> > d57e57d0cd04 ("dpaa_eth: add XDP_TX support") didn't know about that
> > extra argument.
> >
> > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> > ---
> >
> > I think this issue is seen since both patches went in at the same time
> > to bpf-next and net-next.
> > =20
>=20
> Thanks Anders!
>=20
> Indeed, when bpf-next is pulled into net-next this needs to be applied.
>=20
> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Applied, thanks!

Looks like there is a mention of this function in an
example in Documentation/ that may need updating, too.
