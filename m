Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6995027EF7A
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbgI3Ql3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:41:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:42336 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgI3Ql2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:41:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 58E25AC8C;
        Wed, 30 Sep 2020 16:41:26 +0000 (UTC)
Date:   Wed, 30 Sep 2020 18:41:24 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org, linux-clk@vger.kernel.org
Subject: Re: RTL8402 stops working after hibernate/resume
Message-ID: <20200930184124.68a86b1d@ezekiel.suse.cz>
In-Reply-To: <8a82a023-e361-79db-7127-769e4f6e0d1b@gmail.com>
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
        <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
        <20200716105835.32852035@ezekiel.suse.cz>
        <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
        <20200903104122.1e90e03c@ezekiel.suse.cz>
        <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
        <20200924211444.3ba3874b@ezekiel.suse.cz>
        <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
        <20200925093037.0fac65b7@ezekiel.suse.cz>
        <20200925105455.50d4d1cc@ezekiel.suse.cz>
        <aa997635-a5b5-75e3-8a30-a77acb2adf35@gmail.com>
        <20200925115241.3709caf6@ezekiel.suse.cz>
        <20200925145608.66a89e73@ezekiel.suse.cz>
        <30969885-9611-06d8-d50a-577897fcab29@gmail.com>
        <20200929210737.7f4a6da7@ezekiel.suse.cz>
        <217ae37d-f2b0-1805-5696-11644b058819@redhat.com>
        <5f2d3d48-9d1d-e9fe-49bc-d1feeb8a92eb@gmail.com>
        <1c2d888a-5702-cca9-195c-23c3d0d936b9@redhat.com>
        <8a82a023-e361-79db-7127-769e4f6e0d1b@gmail.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/YsRJBXXuwKlNWxrj/EJ/fTX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/YsRJBXXuwKlNWxrj/EJ/fTX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

HI Heiner,

On Wed, 30 Sep 2020 17:47:15 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 30.09.2020 11:04, Hans de Goede wrote:
> > Hi,
> >=20
> > On 9/29/20 10:35 PM, Heiner Kallweit wrote: =20
> >> On 29.09.2020 22:08, Hans de Goede wrote: =20
> >=20
> > <snip>
> >  =20
> >>> Also some remarks about this while I'm being a bit grumpy about
> >>> all this anyways (sorry):
> >>>
> >>> 1. 9f0b54cd167219 ("r8169: move switching optional clock on/off
> >>> to pll power functions") commit's message does not seem to really
> >>> explain why this change was made...
> >>>
> >>> 2. If a git blame would have been done to find the commit adding
> >>> the clk support: commit c2f6f3ee7f22 ("r8169: Get and enable optional=
 ether_clk clock")
> >>> then you could have known that the clk in question is an external
> >>> clock for the entire chip, the commit message pretty clearly states
> >>> this (although "the entire" part is implied only) :
> >>>
> >>> "On some boards a platform clock is used as clock for the r8169 chip,
> >>> this commit adds support for getting and enabling this clock (assuming
> >>> it has an "ether_clk" alias set on it).
> >>> =20
> >> Even if the missing clock would stop the network chip completely,
> >> this shouldn't freeze the system as described by Petr.
> >> In some old RTL8169S spec an external 25MHz clock is mentioned,
> >> what matches the MII bus frequency. Therefore I'm not 100% convinced
> >> that the clock is needed for basic chip operation, but due to
> >> Realtek not releasing datasheets I can't verify this. =20
> >=20
> > Well if that 25 MHz is the only clock the chip has, then it basically
> > has to be on all the time since all clocked digital ASICs cannot work
> > without a clock.=C2=A0 Now pci-e is a packet-switched point-to-point bu=
s,
> > so the ethernet chip not working should not freeze the entire system,
> > but I'm not really surprised that even though it should not do that,
> > that it still does.
> >  =20
> >> But yes, if reverting this change avoids the issue on Petr's system,
> >> then we should do it. A simple mechanical revert wouldn't work because
> >> source file structure has changed since then, so I'll prepare a patch
> >> that effectively reverts the change. =20
> >=20
> > Great, thank you.
> >=20
> > Regards,
> >=20
> > Hans
> >  =20
>=20
> Petr,
> in the following I send two patches. First one is supposed to fix the fre=
eze.
> It also fixes another issue that existed before my ether_clk change:
> ether_clk was disabled on suspend even if WoL is enabled. And the network
> chip most likely needs the clock to check for WoL packets.

Should I also check whether WoL works? Plus, it would be probably good
if I could check whether it indeed didn't work before the change. ;-)

> Please let me know whether it fixes the freeze, then I'll add your Tested=
-by.

Will do.

> Second patch is a re-send of the one I sent before, it should fix
> the rx issues after resume from suspend for you.

All right, going to rebuild the kernel and see how it goes.

Stay tuned,
Petr T


> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethe=
rnet/realtek/r8169_main.c
> index 6c7c004c2..72351c5b0 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2236,14 +2236,10 @@ static void rtl_pll_power_down(struct rtl8169_pri=
vate *tp)
>  	default:
>  		break;
>  	}
> -
> -	clk_disable_unprepare(tp->clk);
>  }
> =20
>  static void rtl_pll_power_up(struct rtl8169_private *tp)
>  {
> -	clk_prepare_enable(tp->clk);
> -
>  	switch (tp->mac_version) {
>  	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_33:
>  	case RTL_GIGA_MAC_VER_37:
> @@ -4820,29 +4816,39 @@ static void rtl8169_net_suspend(struct rtl8169_pr=
ivate *tp)
> =20
>  #ifdef CONFIG_PM
> =20
> +static int rtl8169_net_resume(struct rtl8169_private *tp)
> +{
> +	rtl_rar_set(tp, tp->dev->dev_addr);
> +
> +	if (tp->TxDescArray)
> +		rtl8169_up(tp);
> +
> +	netif_device_attach(tp->dev);
> +
> +	return 0;
> +}
> +
>  static int __maybe_unused rtl8169_suspend(struct device *device)
>  {
>  	struct rtl8169_private *tp =3D dev_get_drvdata(device);
> =20
>  	rtnl_lock();
>  	rtl8169_net_suspend(tp);
> +	if (!device_may_wakeup(tp_to_dev(tp)))
> +		clk_disable_unprepare(tp->clk);
>  	rtnl_unlock();
> =20
>  	return 0;
>  }
> =20
> -static int rtl8169_resume(struct device *device)
> +static int __maybe_unused rtl8169_resume(struct device *device)
>  {
>  	struct rtl8169_private *tp =3D dev_get_drvdata(device);
> =20
> -	rtl_rar_set(tp, tp->dev->dev_addr);
> -
> -	if (tp->TxDescArray)
> -		rtl8169_up(tp);
> +	if (!device_may_wakeup(tp_to_dev(tp)))
> +		clk_prepare_enable(tp->clk);
> =20
> -	netif_device_attach(tp->dev);
> -
> -	return 0;
> +	return rtl8169_net_resume(tp);
>  }
> =20
>  static int rtl8169_runtime_suspend(struct device *device)
> @@ -4868,7 +4874,7 @@ static int rtl8169_runtime_resume(struct device *de=
vice)
> =20
>  	__rtl8169_set_wol(tp, tp->saved_wolopts);
> =20
> -	return rtl8169_resume(device);
> +	return rtl8169_net_resume(tp);
>  }
> =20
>  static int rtl8169_runtime_idle(struct device *device)


--Sig_/YsRJBXXuwKlNWxrj/EJ/fTX
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl90tTUACgkQqlA7ya4P
R6fH1Af/fUb63uyXtxjkIGzRiZAbzcMl4uiGS8vNgUuPSjI5FYKzCYK8/KLOi8D4
k8Au9t3X788EMvxQEPy8BEWECFGWAc7NAer8TdoDLtgEgc9+haAtmPnjeG+6TB2+
3+fX2fr75Ynny/rC2ilCc1OOYTxg1i563r8u0056hO1wXXFXbyEOGbsYGGTwxCKG
emxx/5awcl2EQHXerxTbnQucxv9ulWb5hQpEMd9oQjPQMAHndYUqxa/P0CSZ5xI9
IgKsBWwkHv41aS2g7wBJ6mNZofTEgDF2mb4H1WZRuGILbp7J/Z5Kl8wRofERVQUn
jlCrYiZaSKtSon6/KqvCZ+MeK63xvg==
=qnNU
-----END PGP SIGNATURE-----

--Sig_/YsRJBXXuwKlNWxrj/EJ/fTX--
