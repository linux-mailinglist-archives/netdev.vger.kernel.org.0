Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61A22C2FE2
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 19:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390896AbgKXSU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 13:20:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:47078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390824AbgKXSUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 13:20:25 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA105206D5;
        Tue, 24 Nov 2020 18:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606242024;
        bh=lOXjqWp/EDocUOsHP0psXVvpJIskpYJTvzKYdVMCdtg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vst+HhGN7iL5UenlTFysw1eusW9jH8Xax/gzhxICa8NjweLOyvWFzLZNdH9kOjAGr
         Ij7vfEkoNGkG0xy1uUCQMz1Agv9yjJX+knDS6zLeB/sq3DfFEsJwC/eXvv7HALqRGK
         5gCZMNiCWVrWaa/2ateZuxRp+bG566FTQyEw+ncE=
Date:   Tue, 24 Nov 2020 10:20:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antonio Borneo <antonio.borneo@st.com>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>, kuba@kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        has <has@pengutronix.de>
Subject: Re: [PATCH] net: stmmac: add flexible PPS to dwmac 4.10a
Message-ID: <20201124102022.1a6e6085@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e2b2b623700401538fe91e70495c348c08b5d2e3.camel@st.com>
References: <20191007154306.95827-1-antonio.borneo@st.com>
        <20191007154306.95827-5-antonio.borneo@st.com>
        <20191009152618.33b45c2d@cakuba.netronome.com>
        <42960ede-9355-1277-9a6f-4eac3c22365c@pengutronix.de>
        <e2b2b623700401538fe91e70495c348c08b5d2e3.camel@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 15:23:27 +0100 Antonio Borneo wrote:
> On Tue, 2020-11-24 at 15:15 +0100, Ahmad Fatoum wrote:
> > On 10.10.19 00:26, Jakub Kicinski wrote: =20
> > > On Mon, 7 Oct 2019 17:43:06 +0200, Antonio Borneo wrote: =20
> > > > All the registers and the functionalities used in the callback
> > > > dwmac5_flex_pps_config() are common between dwmac 4.10a [1] and
> > > > 5.00a [2].
> > > >=20
> > > > Reuse the same callback for dwmac 4.10a too.
> > > >=20
> > > > Tested on STM32MP15x, based on dwmac 4.10a.
> > > >=20
> > > > [1] DWC Ethernet QoS Databook 4.10a October 2014
> > > > [2] DWC Ethernet QoS Databook 5.00a September 2017
> > > >=20
> > > > Signed-off-by: Antonio Borneo <antonio.borneo@st.com> =20
> > >=20
> > > Applied to net-next. =20
> >=20
> > This patch seems to have been fuzzily applied at the wrong location.
> > The diff describes extension of dwmac 4.10a and so does the @@ line:
> >=20
> > =C2=A0=C2=A0@@ -864,6 +864,7 @@ const struct stmmac_ops dwmac410_ops =
=3D {
> >=20
> > The patch was applied mainline as 757926247836 ("net: stmmac: add
> > flexible PPS to dwmac 4.10a"), but it extends dwmac4_ops instead:
> >=20
> > =C2=A0=C2=A0@@ -938,6 +938,7 @@ const struct stmmac_ops dwmac4_ops =3D {
> >=20
> > I don't know if dwmac4 actually supports FlexPPS, so I think it's
> > better to be on the safe side and revert 757926247836 and add the
> > change for the correct variant. =20
>=20
> Agree,
> the patch get applied to the wrong place!

:-o

This happens sometimes with stable backports but I've never seen it
happen working on "current" branches.

Sorry about that!

Would you mind sending the appropriate patches? I can do the revert if
you prefer, but since you need to send the fix anyway..
