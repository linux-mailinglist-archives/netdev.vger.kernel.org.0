Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688D615F6F7
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 20:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388382AbgBNTjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 14:39:05 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:31202 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387557AbgBNTjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 14:39:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581709143;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=3/3pr6TTlfArYBb96BTohy3TZX45DflCmc3yt/TKopU=;
        b=YVd1HDpTJatEjIP4nd/4m1B3+vCwBIxiNEsmE/7xxFg/GfUUh2F29+3yeoHlnmSizl
        kWIUsDnhGvioVlOHIIl6UT/V4CXi8aW7zAJ7Aw4QZz4e80Y0vBr5JCWsm5aCOuhJ0y8I
        qIB8BNliwj+5RD+vQ45stC5ZEkTisS/qyCfqchLECjLjNwc/zaHpEz+SBE/0btgyrsiG
        hI5rvrTdjRj0IfsWO4qp8xWoYwNXmgdyaZRaxFmrWopRe6UEmhufhSxIKAr0L4ULaEfN
        2dMy6r9fOBeUTvB7/JSNmfI6ggWeAB+UlpbOVJzDwJv1n1PmrhQe/aKIjJxiInyceYvZ
        jSeQ==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGH/PuwDOspHA="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id U06217w1EJcgGEj
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Fri, 14 Feb 2020 20:38:42 +0100 (CET)
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [Letux-kernel] [PATCH v2] net: davicom: dm9000: allow to pass MAC address through mac_addr module parameter
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <996F2206-B261-46E3-9167-B48BA7D3C9FF@goldelico.com>
Date:   Fri, 14 Feb 2020 20:38:41 +0100
Cc:     Paul Cercueil <paul@crapouillou.net>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Richard Fontana <rfontana@redhat.com>,
        kernel@pyra-handheld.com,
        =?utf-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A686A3C7-09A4-4654-A265-2BDBEF41A7C4@goldelico.com>
References: <0d6b4d383bb29ed5d4710e9706e5ad6c7f92d9da.1581696454.git.hns@goldelico.com> <1581706048.3.3@crapouillou.net> <996F2206-B261-46E3-9167-B48BA7D3C9FF@goldelico.com>
To:     Discussions about the Letux Kernel <letux-kernel@openphoenux.org>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Am 14.02.2020 um 20:24 schrieb H. Nikolaus Schaller =
<hns@goldelico.com>:
>=20
>=20
>> Am 14.02.2020 um 19:47 schrieb Paul Cercueil <paul@crapouillou.net>:
>>=20
>> Hi Nikolaus,
>>=20
>> What I'd suggest is to write a NVMEM driver for the efuse and =
retrieve the MAC address cleanly with nvmem_get_mac_address().
>>=20
>> It shouldn't be hard to do (there's already code for it in the =
non-upstream 3.18 kernel for the CI20) and you remove the dependency on =
uboot.
>=20
> Interesting approach. I have found this:
>=20
> https://lore.kernel.org/patchwork/patch/868158/
>=20
> but it looks as if it was never finished (I could not locate a V3 or =
anything mainline?)
> and and it tries to solve other problems as well.
>=20
> And it looks to be much more complex than my "solution" to the =
immediate problem.
>=20
> I have to study it to know if I can write a nvmem_get_mac_address().

Another question is how to link this very jz4780 specific code to the =
generic davicom dm9000 driver?
And where should the new code live. In some jz4780 specific file or =
elsewhere?

>=20
> BR,
> Nikolaus
>=20
>>=20
>> -Paul
>>=20
>>=20
>> Le ven., f=E9vr. 14, 2020 at 17:07, H. Nikolaus Schaller =
<hns@goldelico.com> a =E9crit :
>>> The MIPS Ingenic CI20 board is shipped with a quite old u-boot
>>> (ci20-v2013.10 see https://elinux.org/CI20_Dev_Zone). This passes
>>> the MAC address through dm9000.mac_addr=3Dxx:xx:xx:xx:xx:xx
>>> kernel module parameter to give the board a fixed MAC address.
>>> This is not processed by the dm9000 driver which assigns a random
>>> MAC address on each boot, making DHCP assign a new IP address
>>> each time.
>>> So we add a check for the mac_addr module parameter as a last
>>> resort before assigning a random one. This mechanism can also
>>> be used outside of u-boot to provide a value through modprobe
>>> config.
>>> To parse the MAC address in a new function get_mac_addr() we
>>> use an copy adapted from the ksz884x.c driver which provides
>>> the same functionality.
>>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>>> ---
>>> drivers/net/ethernet/davicom/dm9000.c | 42 =
+++++++++++++++++++++++++++
>>> 1 file changed, 42 insertions(+)
>>> diff --git a/drivers/net/ethernet/davicom/dm9000.c =
b/drivers/net/ethernet/davicom/dm9000.c
>>> index 1ea3372775e6..7402030b0352 100644
>>> --- a/drivers/net/ethernet/davicom/dm9000.c
>>> +++ b/drivers/net/ethernet/davicom/dm9000.c
>>> @@ -1409,6 +1409,43 @@ static struct dm9000_plat_data =
*dm9000_parse_dt(struct device *dev)
>>> 	return pdata;
>>> }
>>> +static char *mac_addr =3D ":";
>>> +module_param(mac_addr, charp, 0);
>>> +MODULE_PARM_DESC(mac_addr, "MAC address");
>>> +
>>> +static void get_mac_addr(struct net_device *ndev, char *macaddr)
>>> +{
>>> +	int i =3D 0;
>>> +	int j =3D 0;
>>> +	int got_num =3D 0;
>>> +	int num =3D 0;
>>> +
>>> +	while (j < ETH_ALEN) {
>>> +		if (macaddr[i]) {
>>> +			int digit;
>>> +
>>> +			got_num =3D 1;
>>> +			digit =3D hex_to_bin(macaddr[i]);
>>> +			if (digit >=3D 0)
>>> +				num =3D num * 16 + digit;
>>> +			else if (':' =3D=3D macaddr[i])
>>> +				got_num =3D 2;
>>> +			else
>>> +				break;
>>> +		} else if (got_num) {
>>> +			got_num =3D 2;
>>> +		} else {
>>> +			break;
>>> +		}
>>> +		if (got_num =3D=3D 2) {
>>> +			ndev->dev_addr[j++] =3D (u8)num;
>>> +			num =3D 0;
>>> +			got_num =3D 0;
>>> +		}
>>> +		i++;
>>> +	}
>>> +}
>>> +
>>> /*
>>> * Search DM9000 board, allocate space and register it
>>> */
>>> @@ -1679,6 +1716,11 @@ dm9000_probe(struct platform_device *pdev)
>>> 			ndev->dev_addr[i] =3D ior(db, i+DM9000_PAR);
>>> 	}
>>> +	if (!is_valid_ether_addr(ndev->dev_addr)) {
>>> +		mac_src =3D "param";
>>> +		get_mac_addr(ndev, mac_addr);
>>> +	}
>>> +
>>> 	if (!is_valid_ether_addr(ndev->dev_addr)) {
>>> 		inv_mac_addr =3D true;
>>> 		eth_hw_addr_random(ndev);
>>> --
>>> 2.23.0
>>=20
>>=20
>=20
> _______________________________________________
> http://projects.goldelico.com/p/gta04-kernel/
> Letux-kernel mailing list
> Letux-kernel@openphoenux.org
> http://lists.goldelico.com/mailman/listinfo.cgi/letux-kernel

