Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8EE22870D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbgGURQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbgGURQL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:16:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA8FD2065D;
        Tue, 21 Jul 2020 17:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595351770;
        bh=CqBBx0j/1cZPQlvwNKbaRiw+mFTny7apPHSHAWsZinc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=onyvPEZT8jFOA2IWqoa1ESMKSXCSm6WrqsUQ1wewAv3zS8a20Nhx3o7niM6S7HN1Q
         +bZipcoEH1Oesw3MP81t5CtgxfXRClrOutsnA6nd6DSTD4cYz4HICONu3x7BLv21ID
         2kIPL8uJcSsBM8zLku7/GAZrwUJC7dV4XsK0nwpU=
Date:   Tue, 21 Jul 2020 10:15:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        "kernel test robot" <lkp@intel.com>, <kbuild-all@lists.01.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 04/16] sfc_ef100: skeleton EF100 PF driver
Message-ID: <20200721101559.781cad27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <699dfdba-558b-7068-8ea7-d10d80369b6b@solarflare.com>
References: <f1a206ef-23a0-1d3e-9668-0ec33454c2a1@solarflare.com>
        <202007170155.nhtIpp5L%lkp@intel.com>
        <aa134db3-a860-534c-9ee2-d68cded37061@solarflare.com>
        <20200721094535.15df7245@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <699dfdba-558b-7068-8ea7-d10d80369b6b@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 18:09:13 +0100 Edward Cree wrote:
> On 21/07/2020 17:45, Jakub Kicinski wrote:
> > On Tue, 21 Jul 2020 15:48:00 +0100 Edward Cree wrote: =20
> >> Aaaaargh; does anyone have any bright ideas? =20
> > No bright ideas. Why do you want the driver to be modular in the first
> > place? =20
> Well, 'sfc' already is, and I'm not sure changing that is an option
> =C2=A0(wouldn't it break users' scripts?).=C2=A0 And I find development i=
s a lot
> =C2=A0easier if you can just rebuild a module and reload it rather than
> =C2=A0having to wait for LD to put together a whole new vmlinux.
>=20
> > Maybe I'm wrong, but I've never seen a reason to break up vendor drivers
> > for high performance NICs into multiple modules. =20
> So, what are you suggesting?

I was talking about option 2 below, yes.

> 1) both drivers are builtin-only
> 2) a single module containing both drivers
> 3) something else?
>=20
> Both (1) and (2) would allow replacing the linker trick with an if()
> =C2=A0on efx->revision or an efx->type-> function with INDIRECT_CALLABLE.
>=20
> I don't know for sure but I suspect we made the drivers separate
> =C2=A0modules simply because we could (or so we thought) and we didn't
> =C2=A0know for certain no-one would ever want the extra flexibility.
>=20
> I'll ask around and see if there's any reason we can't do (2).
>=20
> -ed

