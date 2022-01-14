Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2F948E33C
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 05:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239139AbiANEVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 23:21:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41228 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239137AbiANEVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 23:21:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E8A3B823EC
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 04:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF287C36AEA;
        Fri, 14 Jan 2022 04:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642134112;
        bh=fYIpZfdKm77yChqSoDkJtqXppTzLoylo7TRrCRzc6K4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fcdh+lEc0kmoBOoBXsCchdptPrKYwcSnnC0MrqYiX1GBjlERbPVveFdtGv6vG1ERh
         la5lLWpjHd/kjMtqbcMfW7aulYLHCt6b+dYiFttdshpaADVhsY7+MOoxeBkrFEHlOr
         6PdcJW5SfQalDZRYYEld9ye1caFH1V4dSpuDhrb+AFOTH1snkLqS48UVkuHr1HIawH
         ypU+R0BKOZQzSNeNDqFSAik5DEuH0ofsc/GGbFiCdr5wYY8wA7HKo01L3r5eTNp4xv
         Nmm+vSABot0i99QDAUk+rL5UGKQRE9fEI+8RqjsmE0dKwJ9PkL6YSHL8YRejQIZbJG
         rdlf/TWLxow6Q==
Date:   Thu, 13 Jan 2022 20:21:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] net: apple: bmac: Fix build since dev_addr
 constification
Message-ID: <20220113202150.3a241d71@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220114031316.2419293-1-mpe@ellerman.id.au>
References: <20220114031316.2419293-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022 14:13:16 +1100 Michael Ellerman wrote:
> Since commit adeef3e32146 ("net: constify netdev->dev_addr") the bmac
> driver no longer builds with the following errors (pmac32_defconfig):
>=20
>   linux/drivers/net/ethernet/apple/bmac.c: In function =E2=80=98bmac_prob=
e=E2=80=99:
>   linux/drivers/net/ethernet/apple/bmac.c:1287:20: error: assignment of r=
ead-only location =E2=80=98*(dev->dev_addr + (sizetype)j)=E2=80=99
>    1287 |   dev->dev_addr[j] =3D rev ? bitrev8(addr[j]): addr[j];
>         |                    ^
>=20
> Fix it by making the modifications to a local macaddr variable and then
> passing that to eth_hw_addr_set().
>=20
> We don't use the existing addr variable because the bitrev8() would
> mutate it, but it is already used unreversed later in the function.
>=20
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thank you!
