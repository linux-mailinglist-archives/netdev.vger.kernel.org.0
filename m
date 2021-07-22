Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371D83D1D14
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 06:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhGVDwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 23:52:36 -0400
Received: from ozlabs.org ([203.11.71.1]:51835 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229905AbhGVDwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 23:52:35 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GVfhM4qPHz9sXM;
        Thu, 22 Jul 2021 14:33:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1626928390;
        bh=Vzi7mqkU5zcj91egSNfnsIYg80io1ZM7W7/i8splPIM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SydseObja7No1RP/9nNNr83o49PStyFgC1Kb0gKtKCfEfmzpUir6W3X64OoDD4zDD
         Exrv3lis0SYnCCga3zmJPuICFDxT1TP9yvOnylE5Uj7DfO+IEqIHa2anoQKyzyqhMa
         1LDdolWAe59U0mazm5P+vb9JPrR4OFHPNCFgdtPwqFiSupQa5RmSMor0f0jtW0pp30
         7T1tBiuczt1KXPAbEjFsN3N8libSs6CkNb5A0ZeuPLxpx9pARHQQGvR/GZOnirFqzu
         c6II7xbzVS03AdcSa/PmzJR1FwYW+QYo9n4kwGWaW8VKVlxR1kHcYSncI6OpXaWwyE
         hWBaBPZeKpDOw==
Date:   Thu, 22 Jul 2021 14:33:06 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Richard Laing <richard.laing@alliedtelesis.co.nz>
Subject: Re: linux-next: manual merge of the mhi tree with the net-next tree
Message-ID: <20210722143306.305aed6f@canb.auug.org.au>
In-Reply-To: <20210716133738.0d163701@canb.auug.org.au>
References: <20210716133738.0d163701@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/P5CLjLME1KnvvnMgvlYF5Ay";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/P5CLjLME1KnvvnMgvlYF5Ay
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 16 Jul 2021 13:37:38 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the mhi tree got a conflict in:
>=20
>   drivers/bus/mhi/pci_generic.c
>=20
> between commit:
>=20
>   5c2c85315948 ("bus: mhi: pci-generic: configurable network interface MR=
U")
>=20
> from the net-next tree and commit:
>=20
>   156ffb7fb7eb ("bus: mhi: pci_generic: Apply no-op for wake using sideba=
nd wake boolean")
>=20
> from the mhi tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
>=20
> diff --cc drivers/bus/mhi/pci_generic.c
> index 19413daa0917,8bc6149249e3..000000000000
> --- a/drivers/bus/mhi/pci_generic.c
> +++ b/drivers/bus/mhi/pci_generic.c
> @@@ -32,7 -32,8 +32,9 @@@
>    * @edl: emergency download mode firmware path (if any)
>    * @bar_num: PCI base address register to use for MHI MMIO register spa=
ce
>    * @dma_data_width: DMA transfer word size (32 or 64 bits)
>  + * @mru_default: default MRU size for MBIM network packets
> +  * @sideband_wake: Devices using dedicated sideband GPIO for wakeup ins=
tead
> +  *		   of inband wake support (such as sdx24)
>    */
>   struct mhi_pci_dev_info {
>   	const struct mhi_controller_config *config;
> @@@ -41,7 -42,7 +43,8 @@@
>   	const char *edl;
>   	unsigned int bar_num;
>   	unsigned int dma_data_width;
>  +	unsigned int mru_default;
> + 	bool sideband_wake;
>   };
>  =20
>   #define MHI_CHANNEL_CONFIG_UL(ch_num, ch_name, el_count, ev_ring) \
> @@@ -254,7 -256,7 +258,8 @@@ static const struct mhi_pci_dev_info mh
>   	.config =3D &modem_qcom_v1_mhiv_config,
>   	.bar_num =3D MHI_PCI_DEFAULT_BAR_NUM,
>   	.dma_data_width =3D 32,
>  +	.mru_default =3D 32768
> + 	.sideband_wake =3D false,
>   };
>  =20
>   static const struct mhi_pci_dev_info mhi_qcom_sdx24_info =3D {
> @@@ -643,11 -686,13 +689,14 @@@ static int mhi_pci_probe(struct pci_de
>   	mhi_cntrl->status_cb =3D mhi_pci_status_cb;
>   	mhi_cntrl->runtime_get =3D mhi_pci_runtime_get;
>   	mhi_cntrl->runtime_put =3D mhi_pci_runtime_put;
> - 	mhi_cntrl->wake_get =3D mhi_pci_wake_get_nop;
> - 	mhi_cntrl->wake_put =3D mhi_pci_wake_put_nop;
> - 	mhi_cntrl->wake_toggle =3D mhi_pci_wake_toggle_nop;
>  +	mhi_cntrl->mru =3D info->mru_default;
>  =20
> + 	if (info->sideband_wake) {
> + 		mhi_cntrl->wake_get =3D mhi_pci_wake_get_nop;
> + 		mhi_cntrl->wake_put =3D mhi_pci_wake_put_nop;
> + 		mhi_cntrl->wake_toggle =3D mhi_pci_wake_toggle_nop;
> + 	}
> +=20
>   	err =3D mhi_pci_claim(mhi_cntrl, info->bar_num, DMA_BIT_MASK(info->dma=
_data_width));
>   	if (err)
>   		return err;

This is now a conflict between the char-misc.current tree (where commit
156ffb7fb7eb is now 56f6f4c4eb2a) and the net-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/P5CLjLME1KnvvnMgvlYF5Ay
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmD49QIACgkQAVBC80lX
0GylKgf/WQy3QWDT3SqsE3a3iYJ7wR/39A9yfNaEd3ffA3X/kCdHrm9zsZBwnjHK
/1sLKy2L4fQLtTI4p8N/a4vixfeQEJLIwqzaBHr9aajyI6aZ3uIC7zr1JEZeXv3u
SOOlTS3KfdDvukLtqZvInQPU6kBIOXJCIgVzekKu5VwcguIWE1RIY8mWln/9Hw82
X/myO9SwvKZHNInKlpv60T+gvNbc8wy5U+k9l6lgpXPcQmy0SFeKh1ib16gKU1Lq
aIF4Gy9JFgBToSGDEUmaeFpfPz6NBDYeTdNOYvEZRj1RFiexMt/0tHZuNruTm1Xi
DZPVDGWi2TkOFsZujLrKx8/kW9HePA==
=GaFk
-----END PGP SIGNATURE-----

--Sig_/P5CLjLME1KnvvnMgvlYF5Ay--
