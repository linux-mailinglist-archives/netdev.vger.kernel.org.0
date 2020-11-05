Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0409F2A75BF
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 03:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388433AbgKECse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 21:48:34 -0500
Received: from mout.gmx.net ([212.227.15.19]:47897 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729344AbgKECsd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 21:48:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1604544511;
        bh=MZKPct/jrxlZUKRKeNpglKhWeqGZXAs4shumBfU3evw=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=e2jJCdC+/p3kpYs87tpbVCa9yodkbeK8Dv07sLWvV5+1QKmClrJrkx/IqDIiKqB0K
         Q89+8CZe+kCxDn85JK0YJtF57FF734CZEmBdT5hhJpiCytqb3uWlSr80hTaV4KgZoC
         QWjZCxaIOkaO//lqG00zkZwkB7MeWPA+jEIXqj7s=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MLiCo-1ks2Aw3612-00HcRW; Thu, 05
 Nov 2020 03:48:31 +0100
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Very slow realtek 8169 ethernet performance, but only one interface,
 on ThinkPad T14.
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAU4EEwEIADgCGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCXZw1oQAKCRDC
 PZHzoSX+qCY6CACd+mWu3okGwRKXju6bou+7VkqCaHTdyXwWFTsr+/0ly5nUdDtT3yEVggPJ
 3VP70wjlrxUjNjFb6iIvGYxiPOrop1NGwGYvQktgRhaIhALG6rPoSSAhGNjwGVRw0km0PlIN
 D29BTj/lYEk+jVM1YL0QLgAE1AI3krihg/lp/fQT53wLhR8YZIF8ETXbClQG1vJ0cllPuEEv
 efKxRyiTSjB+PsozSvYWhXsPeJ+KKjFen7ebE5reQTPFzSHctCdPnoR/4jSPlnTlnEvLeqcD
 ZTuKfQe1gWrPeevQzgCtgBF/WjIOeJs41klnYzC3DymuQlmFubss0jShLOW8eSOOWhLRuQEN
 BFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcgaCbPEwhLj
 1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj/IrRUUka
 68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fNGSsRb+pK
 EKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0q1eW4Jrv
 0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEvABEBAAGJ
 ATwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCXZw1rgUJCWpOfwAKCRDCPZHz
 oSX+qFcEB/95cs8cM1OQdE/GgOfCGxwgckMeWyzOR7bkAWW0lDVp2hpgJuxBW/gyfmtBnUai
 fnggx3EE3ev8HTysZU9q0h+TJwwJKGv6sUc8qcTGFDtavnnl+r6xDUY7A6GvXEsSoCEEynby
 72byGeSovfq/4AWGNPBG1L61Exl+gbqfvbECP3ziXnob009+z9I4qXodHSYINfAkZkA523JG
 ap12LndJeLk3gfWNZfXEWyGnuciRGbqESkhIRav8ootsCIops/SqXm0/k+Kcl4gGUO/iD/T5
 oagaDh0QtOd8RWSMwLxwn8uIhpH84Q4X1LadJ5NCgGa6xPP5qqRuiC+9gZqbq4Nj
Message-ID: <57f16fe7-2052-72cc-6628-bbb04f146ce0@gmx.com>
Date:   Thu, 5 Nov 2020 10:48:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="a3VSOni5fJ63UEFwquRHRlxQ7ZzMMmvJb"
X-Provags-ID: V03:K1:bSl7cYK7D2AgdikTqSoAUfsYMxhid79fRDCG/GYHAM4MD4aoWvW
 UWujJMQEOl+/q94EqA1IoSUNVGLaiH8SvxYZ4DnZPoloB8goIyiTopEU88voaHUnpgsdlPE
 rET+8SY8UCrVM8NRN7o0iVTcuofIOXAVLgSfsCrb1t0COEOHuXs8oM5HRxR8083HbUCZl2G
 wsST9SMrTDdlLzrH1rRiw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7p/rAkW210A=:S11DgrnpBhZqSUVd25xPDW
 X5t4pnCKkZ23e6Myce+xMmbC2iqdR/QOomTcYNqsMEDlNojPJUy/+rbbzDRYnBN+N4yxpGgay
 7s6k9Yf2ESAy3FEOTNZ4fF+ELQpqTXY9c+jHDD/4Lgv5S9QIA4citVFDb8g5WRKuNjn4eISCx
 gQ6X7we/DMLGIBGFRUT/sd2GmEEyr+8xlpCoiTELvpMmbsSA7ZF9YHz01BP9YRLndC3yt4Xk4
 COpo/pLTmIq39Yv4ffnd1DYKYjZl6DJxMI6vF6Y6pYDJoxg3GlVrK1uu6qJT7tvGEB2m919he
 yb7nZXjNy+eXpPgexQ34AMkdbBbbF5T2i1tKEBu+QKWWGXu6oloS10NrjVq1SxeQ3p9DMxVEM
 Tz604EbKVKtlxqU2Fv0/cAvivRwEd68Ru9dfHT+oBsvNEECvKbdJ3Tatfz72DI1vpgQreOdQV
 7nMW8FAq4kHhbRKwxlmuvP+4wZwF0oSAAMdNwZpydmMvLw3SKDMKNBjk/hNO+0ruojLpyfz5z
 klUJGG22nluFmG6yuBmiJ4D+Sf0bG676UB5EAJ2b7hGE+Cq9WHG76RXWPtwZLw2J3ygjJOSMI
 hJ2guJPJW0yBlSzzPbnmrac7upEioGR6YXpH/G8HlDwfS3A71NvQTSEmFCvYGHM8fOt/sXFZy
 sbfSIy9smkrZwBcU2qeUMqM5xPhdq8qkMdTW3kV89NADORz41tvSQpyGhE5+SV1L2hUBPQMcJ
 4P3sV6zWMFSF0UX9YgJ0RGp4iAMnpulZHvVg9BqOei8DFkrwwMeeqiHcMNvUVskmZzhrjWomO
 3YFX9EUc4pqVHL36ZkJYeTRVvCTVHS8JFjIZL/Si/e6O35vEUfWthwzB/yGFDURR6sru0+kYm
 RiWqaAwTHFQCwY8rpdsw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--a3VSOni5fJ63UEFwquRHRlxQ7ZzMMmvJb
Content-Type: multipart/mixed; boundary="rtPLaeqT6jQv4NKDBSnScJdGTzEOaRCBJ"

--rtPLaeqT6jQv4NKDBSnScJdGTzEOaRCBJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

Not sure if this is a regression or not, but just find out that after upg=
rading to v5.9 kernel, one of my ethernet port on my ThinkPad T14 (ryzen =
version) becomes very slow.

Only *2~3* Mbps.

The laptop has two ethernet interfaces, one needs a passive adapter, the =
other one is a standard RJ45.

The offending one is the one which needs the adapter (eth0).
While the RJ45 one is completely fine.

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168=
/8411 PCI Express Gigabit Ethernet Controller (rev 0e)
05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168=
/8411 PCI Express Gigabit Ethernet Controller (rev 15)

The 02:00.0 one is the affected one.

The related dmesgs are:
[   38.110293] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have AS=
PM control
[   38.126069] libphy: r8169: probed
[   38.126250] r8169 0000:02:00.0 eth0: RTL8168ep/8111ep, 00:2b:67:b3:d9:=
20, XID 502, IRQ 105
[   38.126252] r8169 0000:02:00.0 eth0: jumbo features [frames: 9194 byte=
s, tx checksumming: ko]
[   38.126294] r8169 0000:05:00.0: can't disable ASPM; OS doesn't have AS=
PM control
[   38.126300] r8169 0000:05:00.0: enabling device (0000 -> 0003)
[   38.139355] libphy: r8169: probed
[   38.139523] r8169 0000:05:00.0 eth1: RTL8168h/8111h, 00:2b:67:b3:d9:1f=
, XID 541, IRQ 107
[   38.139525] r8169 0000:05:00.0 eth1: jumbo features [frames: 9194 byte=
s, tx checksumming: ko]
[   42.120935] Generic FE-GE Realtek PHY r8169-200:00: attached PHY drive=
r [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=3Dr8169-200:00, irq=3DIGN=
ORE)
[   42.247646] r8169 0000:02:00.0 eth0: Link is Down
[   42.280799] Generic FE-GE Realtek PHY r8169-500:00: attached PHY drive=
r [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=3Dr8169-500:00, irq=3DIGN=
ORE)
[   42.477616] r8169 0000:05:00.0 eth1: Link is Down
[   76.479569] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow co=
ntrol rx/tx
[   91.271894] r8169 0000:02:00.0 eth0: Link is Down
[   99.873390] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow co=
ntrol rx/tx
[   99.878938] r8169 0000:02:00.0 eth0: Link is Down
[  102.579290] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow co=
ntrol rx/tx
[  185.086002] r8169 0000:02:00.0 eth0: Link is Down
[  392.884584] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow co=
ntrol rx/tx
[  392.891208] r8169 0000:02:00.0 eth0: Link is Down
[  395.889047] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow co=
ntrol rx/tx
[  406.670738] r8169 0000:02:00.0 eth0: Link is Down

Really nothing strange, even it negotiates to 1Gbps.

But during iperf3, it only goes up to miserable 3Mbps.

Is this some known bug or something special related to the passive adapte=
r?

Since the adapter is passive, and hasn't experience anything wrong for a =
long time, I really doubt that.

Thanks,
Qu



--rtPLaeqT6jQv4NKDBSnScJdGTzEOaRCBJ--

--a3VSOni5fJ63UEFwquRHRlxQ7ZzMMmvJb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAl+jZ/wACgkQwj2R86El
/qiISwf+LGm9iL029t/gv20VN8HurqnXRz/nfbUTvxeyFunAfuhT+p8GsXQr/aTU
n2bZR5JQJT4QRLlkPh0TUpkAwGEafzGMGzGY7tXnrN6zrPzv6pKUxsPgyXHOE9UH
idUIJaT33B8U0WZvvvEZ8BznyxhNxmi5joD6exez6bXryFuS/wiUtc23dzco6FDu
HWOep6LWKdxOzGgxyO/9swFIr+YB761Pfqi27tKEyFSLhu//iiexFRkdweZm48lm
pkchl/ncJnbKWmomAUvHn3wQM/AgsC8dLykWQsWl04w+dN2DO/9opO4O7Bwd2Mo1
aiqfEiaHm2G5xDfzYCQ02Ok/FWy2VA==
=ZnVq
-----END PGP SIGNATURE-----

--a3VSOni5fJ63UEFwquRHRlxQ7ZzMMmvJb--
