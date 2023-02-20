Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D1869CA13
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjBTLob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjBTLoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:44:30 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B18EC53;
        Mon, 20 Feb 2023 03:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676893467; x=1708429467;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZayuAzOXe/D7OzJt6Sr2ehYXR3td2/xneVeLxCWKj5Q=;
  b=fL227ETn1zShZvcKGh5WtpEL1D/7UydMCpq8O8SXpamWmsu/JuxpXh/e
   g5X/vggnHdfjMXCTRJECIM+Te58nUJbH0f5NPgFVnrcPYoViPL/ZOw56R
   SjuUQ3FAb3uahsvdA0eCC5v2Yux+I9qrNEGrm0ERkjWPwgp+OAsPrAEi/
   gW7NYhAtq7Uu7Zl1lRBHfH/QcTrEgrdw162dZ71/OpDse3/v0sWObStWi
   +5d9REaWjoL1ynbwBE5fYrkMHrkkxKnaIDHvRYDX1jgdvE2zvcRwenBF0
   fw8RH0/B/kUP+cbHNp1mjM3/OpOoebDPuJExyx+JSGFa3hDWEaWb9Pfhb
   g==;
X-IronPort-AV: E=Sophos;i="5.97,312,1669100400"; 
   d="asc'?scan'208";a="201419788"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Feb 2023 04:44:26 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 20 Feb 2023 04:44:25 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 20 Feb 2023 04:44:21 -0700
Date:   Mon, 20 Feb 2023 11:43:54 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Emil Renner Berthing <emil.renner.berthing@canonical.com>
CC:     Conor Dooley <conor@kernel.org>,
        Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        "Palmer Dabbelt" <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@collabora.com>,
        <daire.mcnamara@microchip.com>, <atishp@atishpatra.org>
Subject: Re: [PATCH 04/12] soc: sifive: ccache: Add non-coherent DMA handling
Message-ID: <Y/Nc+u2tP07zjdn5@wendy>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-5-cristian.ciocaltea@collabora.com>
 <Y+567t+kDjZI+fbo@spud>
 <CAJM55Z_poY3dVu9fQ1W1VQw3V=8VdVKc1+qUcdHduM1aAveJUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wykLVd+P9f03SVcb"
Content-Disposition: inline
In-Reply-To: <CAJM55Z_poY3dVu9fQ1W1VQw3V=8VdVKc1+qUcdHduM1aAveJUQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--wykLVd+P9f03SVcb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 19, 2023 at 10:32:52PM +0100, Emil Renner Berthing wrote:
> On Thu, 16 Feb 2023 at 19:51, Conor Dooley <conor@kernel.org> wrote:
> >
> > Emil,
> >
> > +CC Daire
> >
> > On Sat, Feb 11, 2023 at 05:18:13AM +0200, Cristian Ciocaltea wrote:
> > > From: Emil Renner Berthing <kernel@esmil.dk>
> > >
> > > Add functions to flush the caches and handle non-coherent DMA.
> > >
> > > Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> > > [replace <asm/cacheflush.h> with <linux/cacheflush.h>]
> > > Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
> > > ---
> >
> > > +void *sifive_ccache_set_uncached(void *addr, size_t size)
> > > +{
> > > +     phys_addr_t phys_addr =3D __pa(addr) + uncached_offset;
> > > +     void *mem_base;
> > > +
> > > +     mem_base =3D memremap(phys_addr, size, MEMREMAP_WT);
> > > +     if (!mem_base) {
> > > +             pr_err("%s memremap failed for addr %p\n", __func__, ad=
dr);
> > > +             return ERR_PTR(-EINVAL);
> > > +     }
> > > +
> > > +     return mem_base;
> > > +}
> >
> > The rest of this I either get b/c we did it, or will become moot so I
> > amn't worried about it, but can you please explain this, in particular
> > the memremap that you're doing here?
>=20
> No, I can't really. As we talked about it's also based on a prototype
> by Atish. I'm sure you know that the general idea is that we want to
> return a pointer that accesses the same physical memory, but through
> the uncached alias.

Yah, I follow all the rest of what's going on - it's just this bit of it
that I don't.

> I can't tell you exactly why it's done this way
> though, sorry.

I had a bit of a look on lore, but don't really see anything there that
contained any discussion of what was going on here.

Adding Atish in the off-chance that he remembers!

--wykLVd+P9f03SVcb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/Nc+gAKCRB4tDGHoIJi
0n3EAQC515OeaFPBk3H9xce8itMQVAnTfSS/l42S5WPB4nRjrgD/Yk2YSzjgst9w
Ar7d60/RFJU1Ww58YHGgX9z2WqxXHg0=
=+rbV
-----END PGP SIGNATURE-----

--wykLVd+P9f03SVcb--
