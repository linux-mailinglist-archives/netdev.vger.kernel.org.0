Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A0A21BA00
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 17:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgGJPu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 11:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgGJPu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 11:50:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7EAF20720;
        Fri, 10 Jul 2020 15:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594396258;
        bh=Yx9JX9RFWYc1ihGffCUzZCZOndU+VTdYgQo0UHVe01g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=z+X3vaxA8J8ZmLiS4Y7CP4mKS2S2CxhxEvqsFrks0DJdjLxr8D+6bpCPC3wkL6Xo7
         whowKugX9FZEwuY/cEQ946S7xfYRx2IpZGRTMM5eobaDPrA6983yxuDdBhWsLSclHL
         skxffECdWcWTYF+/zd7QClgOyAzq+jMImsW+kTjQ=
Date:   Fri, 10 Jul 2020 08:50:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhi Li <lizhi01@loongson.cn>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lixuefeng@loongson.cn,
        chenhc@lemote.com, jiaxun.yang@flygoat.com, yangtiezhu@loongson.cn,
        Hongbin Li <lihongbin@loongson.cn>
Subject: Re: [PATCH] stmmac: pci: Add support for LS7A bridge chip
Message-ID: <20200710085056.6deb411a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594371110-7580-1-git-send-email-lizhi01@loongson.cn>
References: <1594371110-7580-1-git-send-email-lizhi01@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jul 2020 16:51:50 +0800 Zhi Li wrote:
> Add gmac platform data to support LS7A bridge chip.
>=20
> Co-developed-by: Hongbin Li <lihongbin@loongson.cn>
> Signed-off-by: Hongbin Li <lihongbin@loongson.cn>
> Signed-off-by: Zhi Li <lizhi01@loongson.cn>

This appears to not build with allmodconfig:

../drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c:22:62: note: expected =
=E2=80=98struct plat_stmmacenet_data *=E2=80=99 but argument is of type =E2=
=80=98struct plat_stmmacenent_data *=E2=80=99
   22 | static void common_default_data(struct plat_stmmacenet_data *plat)
      |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
../drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c:145:6: error: invalid u=
se of undefined type =E2=80=98struct plat_stmmacenent_data=E2=80=99
  145 |  plat->bus_id =3D pci_dev_id(pdev);
      |      ^~
../drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c:146:6: error: invalid u=
se of undefined type =E2=80=98struct plat_stmmacenent_data=E2=80=99
  146 |  plat->phy_addr =3D 0;
      |      ^~
../drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c:147:6: error: invalid u=
se of undefined type =E2=80=98struct plat_stmmacenent_data=E2=80=99
  147 |  plat->interface =3D PHY_INTERFACE_MODE_GMII;
      |      ^~
../drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c:149:6: error: invalid u=
se of undefined type =E2=80=98struct plat_stmmacenent_data=E2=80=99
  149 |  plat->dma_cfg->pbl =3D 32;
      |      ^~
../drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c:150:6: error: invalid u=
se of undefined type =E2=80=98struct plat_stmmacenent_data=E2=80=99
  150 |  plat->dma_cfg->pblx8 =3D true;
      |      ^~
../drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c: At top level:
../drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c:156:11: error: initiali=
zation of =E2=80=98int (*)(struct pci_dev *, struct plat_stmmacenet_data *)=
=E2=80=99 from incompatible pointer type =E2=80=98int (*)(struct pci_dev *,=
 struct plat_stmmacenent_data *)=E2=80=99 [-Werror=3Dincompatible-pointer-t=
ypes]
  156 |  .setup =3D loongson_default_data;
      |           ^~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c:156:11: note: (near ini=
tialization for =E2=80=98loongson_pci_info.setup=E2=80=99)
../drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c:156:32: error: expected=
 =E2=80=98}=E2=80=99 before =E2=80=98;=E2=80=99 token
  156 |  .setup =3D loongson_default_data;
      |                                ^
../drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c:155:51: note: to match =
this =E2=80=98{=E2=80=99
  155 | static struct stmmac_pci_info loongson_pci_info =3D {
      |                                                   ^
cc1: some warnings being treated as errors
make[6]: *** [drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o] Error 1
make[5]: *** [drivers/net/ethernet/stmicro/stmmac] Error 2
make[4]: *** [drivers/net/ethernet/stmicro] Error 2
make[3]: *** [drivers/net/ethernet] Error 2
make[2]: *** [drivers/net] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers] Error 2
make: *** [__sub-make] Error 2
