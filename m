Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D80015F793
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgBNURl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:17:41 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:36150 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgBNURl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1581711458; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a/zhSyvE1L0ykH8hxQYOmjimsDW2eODa3fdTJzm0SwY=;
        b=hYQs8qzDxPenmkK2cX6VNtIX8OrIrlFy7EBN5Rn4QmDVhf80D2NaqxBf6tpStHXHVKL+ko
        5jwCvieIXGTS5opGMZOshmoAfxqHWNyR1LPRyvkOKNlt7B+pUNzzBC0iRCBi8aTkrbm0NH
        HUAA4///ih5DGiEM7/ZBZwwJy3xJ07s=
Date:   Fri, 14 Feb 2020 17:17:21 -0300
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [Letux-kernel] [PATCH v2] net: davicom: dm9000: allow to pass MAC
 address through mac_addr module parameter
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Fontana <rfontana@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kernel@pyra-handheld.com,
        Petr =?UTF-8?b?xaB0ZXRpYXI=?= <ynezz@true.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Message-Id: <1581711441.3.11@crapouillou.net>
In-Reply-To: <85A043D6-118A-4940-9DB2-5C6517DBCC78@goldelico.com>
References: <0d6b4d383bb29ed5d4710e9706e5ad6c7f92d9da.1581696454.git.hns@goldelico.com>
        <1581706048.3.3@crapouillou.net>
        <996F2206-B261-46E3-9167-B48BA7D3C9FF@goldelico.com>
        <A686A3C7-09A4-4654-A265-2BDBEF41A7C4@goldelico.com>
        <85A043D6-118A-4940-9DB2-5C6517DBCC78@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le ven., f=E9vr. 14, 2020 at 21:05, H. Nikolaus Schaller=20
<hns@goldelico.com> a =E9crit :
>=20
>>  Am 14.02.2020 um 20:38 schrieb H. Nikolaus Schaller=20
>> <hns@goldelico.com>:
>>=20
>>=20
>>>  Am 14.02.2020 um 20:24 schrieb H. Nikolaus Schaller=20
>>> <hns@goldelico.com>:
>>>=20
>>>=20
>>>>  Am 14.02.2020 um 19:47 schrieb Paul Cercueil=20
>>>> <paul@crapouillou.net>:
>>>>=20
>>>>  Hi Nikolaus,
>>>>=20
>>>>  What I'd suggest is to write a NVMEM driver for the efuse and=20
>>>> retrieve the MAC address cleanly with nvmem_get_mac_address().
>>>>=20
>>>>  It shouldn't be hard to do (there's already code for it in the=20
>>>> non-upstream 3.18 kernel for the CI20) and you remove the=20
>>>> dependency on uboot.
>>>=20
>>>  Interesting approach. I have found this:
>>>=20
>>>  https://lore.kernel.org/patchwork/patch/868158/
>>>=20
>>>  but it looks as if it was never finished (I could not locate a V3=20
>>> or anything mainline?)
>>>  and and it tries to solve other problems as well.
>>>=20
>>>  And it looks to be much more complex than my "solution" to the=20
>>> immediate problem.
>>>=20
>>>  I have to study it to know if I can write a=20
>>> nvmem_get_mac_address().
>>=20
>>  Another question is how to link this very jz4780 specific code to=20
>> the generic davicom dm9000 driver?
>>  And where should the new code live. In some jz4780 specific file or=20
>> elsewhere?
>=20
> Ok, got it.
>=20
> nvmem_get_mac_address() is looking for a nvmem cell "mac-address".
>=20
> So some jz4780 specific driver must provide such cells.

No, the jz4780 specific driver should just provide the functionality.

The cells are provided in devicetree, just like in the two=20
documentation files I listed before.

-Paul

>=20
> There aren't many examples but it appears as if=20
> arch/arm/mach-davinci/board-da830-evm.c
> defines and registers nvmem cells.
>=20
> But maybe it is not difficult to teach the 2018 driver to provide=20
> such cells.
>=20
> BR and thanks,
> Nikolaus
>=20
>=20
>>=20
>>>=20
>>>  BR,
>>>  Nikolaus
>>>=20
>>>>=20
>>>>  -Paul
>>>>=20
>>>>=20
>>>>  Le ven., f=E9vr. 14, 2020 at 17:07, H. Nikolaus Schaller=20
>>>> <hns@goldelico.com> a =E9crit :
>>>>>  The MIPS Ingenic CI20 board is shipped with a quite old u-boot
>>>>>  (ci20-v2013.10 see https://elinux.org/CI20_Dev_Zone). This passes
>>>>>  the MAC address through dm9000.mac_addr=3Dxx:xx:xx:xx:xx:xx
>>>>>  kernel module parameter to give the board a fixed MAC address.
>>>>>  This is not processed by the dm9000 driver which assigns a random
>>>>>  MAC address on each boot, making DHCP assign a new IP address
>>>>>  each time.
>>>>>  So we add a check for the mac_addr module parameter as a last
>>>>>  resort before assigning a random one. This mechanism can also
>>>>>  be used outside of u-boot to provide a value through modprobe
>>>>>  config.
>>>>>  To parse the MAC address in a new function get_mac_addr() we
>>>>>  use an copy adapted from the ksz884x.c driver which provides
>>>>>  the same functionality.
>>>>>  Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>>>>>  ---
>>>>>  drivers/net/ethernet/davicom/dm9000.c | 42=20
>>>>> +++++++++++++++++++++++++++
>>>>>  1 file changed, 42 insertions(+)
>>>>>  diff --git a/drivers/net/ethernet/davicom/dm9000.c=20
>>>>> b/drivers/net/ethernet/davicom/dm9000.c
>>>>>  index 1ea3372775e6..7402030b0352 100644
>>>>>  --- a/drivers/net/ethernet/davicom/dm9000.c
>>>>>  +++ b/drivers/net/ethernet/davicom/dm9000.c
>>>>>  @@ -1409,6 +1409,43 @@ static struct dm9000_plat_data=20
>>>>> *dm9000_parse_dt(struct device *dev)
>>>>>  	return pdata;
>>>>>  }
>>>>>  +static char *mac_addr =3D ":";
>>>>>  +module_param(mac_addr, charp, 0);
>>>>>  +MODULE_PARM_DESC(mac_addr, "MAC address");
>>>>>  +
>>>>>  +static void get_mac_addr(struct net_device *ndev, char *macaddr)
>>>>>  +{
>>>>>  +	int i =3D 0;
>>>>>  +	int j =3D 0;
>>>>>  +	int got_num =3D 0;
>>>>>  +	int num =3D 0;
>>>>>  +
>>>>>  +	while (j < ETH_ALEN) {
>>>>>  +		if (macaddr[i]) {
>>>>>  +			int digit;
>>>>>  +
>>>>>  +			got_num =3D 1;
>>>>>  +			digit =3D hex_to_bin(macaddr[i]);
>>>>>  +			if (digit >=3D 0)
>>>>>  +				num =3D num * 16 + digit;
>>>>>  +			else if (':' =3D=3D macaddr[i])
>>>>>  +				got_num =3D 2;
>>>>>  +			else
>>>>>  +				break;
>>>>>  +		} else if (got_num) {
>>>>>  +			got_num =3D 2;
>>>>>  +		} else {
>>>>>  +			break;
>>>>>  +		}
>>>>>  +		if (got_num =3D=3D 2) {
>>>>>  +			ndev->dev_addr[j++] =3D (u8)num;
>>>>>  +			num =3D 0;
>>>>>  +			got_num =3D 0;
>>>>>  +		}
>>>>>  +		i++;
>>>>>  +	}
>>>>>  +}
>>>>>  +
>>>>>  /*
>>>>>  * Search DM9000 board, allocate space and register it
>>>>>  */
>>>>>  @@ -1679,6 +1716,11 @@ dm9000_probe(struct platform_device *pdev)
>>>>>  			ndev->dev_addr[i] =3D ior(db, i+DM9000_PAR);
>>>>>  	}
>>>>>  +	if (!is_valid_ether_addr(ndev->dev_addr)) {
>>>>>  +		mac_src =3D "param";
>>>>>  +		get_mac_addr(ndev, mac_addr);
>>>>>  +	}
>>>>>  +
>>>>>  	if (!is_valid_ether_addr(ndev->dev_addr)) {
>>>>>  		inv_mac_addr =3D true;
>>>>>  		eth_hw_addr_random(ndev);
>>>>>  --
>>>>>  2.23.0
>>>>=20
>>>>=20
>>>=20
>>>  _______________________________________________
>>>  http://projects.goldelico.com/p/gta04-kernel/
>>>  Letux-kernel mailing list
>>>  Letux-kernel@openphoenux.org
>>>  http://lists.goldelico.com/mailman/listinfo.cgi/letux-kernel
>>=20
>>  _______________________________________________
>>  http://projects.goldelico.com/p/gta04-kernel/
>>  Letux-kernel mailing list
>>  Letux-kernel@openphoenux.org
>>  http://lists.goldelico.com/mailman/listinfo.cgi/letux-kernel
>=20

=

