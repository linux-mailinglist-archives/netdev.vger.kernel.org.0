Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD7553E6EB
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239951AbiFFOlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 10:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239854AbiFFOl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 10:41:28 -0400
Received: from m15111.mail.126.com (m15111.mail.126.com [220.181.15.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CDAC2941FA
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 07:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Mime-Version:Subject:From:Date:Message-Id; bh=+j7I1
        ANOmEKl+mgVzb1Ui/TPSkwl2RERC54Siy1QUVw=; b=PCL8L0rl1QYU446YnN+AE
        dcDZJPV4hSTpUNoi+xdQAngDiPV9iraDZYuhLRk1ybHBIcklp8BiB0hVjP/i93k7
        xRFFIPar5bxfbzIYxgQC4rN9RvdIYkNsoTAbVVY4xF/2y+PMGhfU1ettHPDUyWXF
        4Cj3qvZ9GSf32DA5ao5gqw=
Received: from smtpclient.apple (unknown [120.229.65.48])
        by smtp1 (Coremail) with SMTP id C8mowACXdd6aEJ5izOPPDQ--.38245S2;
        Mon, 06 Jun 2022 22:35:08 +0800 (CST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH v4] igb: Assign random MAC address instead of fail in case
 of invalid one
From:   =?utf-8?B?5qKB56S85a2m?= <lianglixuehao@126.com>
In-Reply-To: <f16ef33a4b12cebae2e2300a509014cd5de4a0d2.camel@gmail.com>
Date:   Mon, 6 Jun 2022 22:35:07 +0800
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, lianglixue@greatwall.com.cn
Content-Transfer-Encoding: quoted-printable
Message-Id: <0362CDDC-AE9B-448C-BE7C-D563B12D5A61@126.com>
References: <20220601150428.33945-1-lianglixuehao@126.com>
 <f16ef33a4b12cebae2e2300a509014cd5de4a0d2.camel@gmail.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-CM-TRANSID: C8mowACXdd6aEJ5izOPPDQ--.38245S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3XFW8Gw15AFW8JFyUKF48JFb_yoW7CF1xpF
        Z3Ka17KFykJr4jk3ykXw48XFyF9Fs5Jay5Gr90yw1F9Fn8Wr9rAr48K345C34rJrZ7G3W2
        vF43ZF4Du3Z0yaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UP5rxUUUUU=
X-Originating-IP: [120.229.65.48]
X-CM-SenderInfo: xold0w5ol03vxkdrqiyswou0bp/1tbi3B0YFlpEDpwWUwAAsG
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
thank you very much for your suggestion.

As you said, the way to cause =E2=80=98Invalid MAC address=E2=80=99 is =
not only through igb_set_eeprom,
but also some pre-production or uninitialized boards.

But if set by module parameters, especially in the case of CONFIG_IGB=3Dy,=

The situation may be more troublesome, because for most users, if the =
system does not properly load and generate=20
the network card device, they can only ask the host supplier for =
help.But,

(1) If the invalid mac address is caused by igb_set_eeprom, it is =
relatively more convenient for most operations engineers=20
to change the invalid mac address to the mac address they think should =
be valid by ethtool, which may still be Invalid.
At this time,assigned random MAC address which is valid by the driver =
enables the network card driver to continue to complete the loading.
As for what you mentioned, in this case if the user does not notice that =
the driver had used a random mac address,
it may lead to other problems.but the fact is that if the user =
deliberately sets a customized mac address,=20
the user should pay attention to whether the mac address is successfully =
changed, and also pay attention to the=20
expected result after changing the mac address.When users find that the =
custom mac address cannot=20
be successfully changed to the customized one, they can continue =
debugging, which is easier than looking for=20
the host supplier=E2=80=99s support from the very first time of =
=E2=80=9CInvalid MAC address=E2=80=9D.

(2) If the invalid mac address is caused during pre-production or =
initialization of the board, it is even more necessary=20
to use a random mac address to complete the loading of the network card, =
because the user only cares about whether=20
the network card is loaded, not what the valid MAC address is.

And I also noticed that ixgbvef_sw_init also uses a random valid mac =
address to continue loading the driver when=20
the address is invalid. In addition, network card drivers such as =
marvell, broadcom, realtek, etc., when an invalid=20
MAC address is detected, it also does not directly exit the driver =
loading, but uses a random valid MAC address.

> 2022=E5=B9=B46=E6=9C=882=E6=97=A5 23:57=EF=BC=8CAlexander H Duyck =
<alexander.duyck@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Wed, 2022-06-01 at 15:04 +0000, Lixue Liang wrote:
>> From: Lixue Liang <lianglixue@greatwall.com.cn>
>>=20
>> In some cases, when the user uses igb_set_eeprom to modify the MAC
>> address to be invalid, the igb driver will fail to load. If there is =
no
>> network card device, the user must modify it to a valid MAC address =
by
>> other means.
>>=20
>> Since the MAC address can be modified, then add a random valid MAC =
address
>> to replace the invalid MAC address in the driver can be workable, it =
can
>> continue to finish the loading, and output the relevant log reminder.
>>=20
>> Signed-off-by: Lixue Liang <lianglixue@greatwall.com.cn>
>> ---
>> Changelog:
>> * v4:
>> - Change the igb_mian in the title to igb
>> - Fix dev_err message: replace "already assigned random MAC address"=20=

>>  with "Invalid MAC address. Assigned random MAC address"=20
>> Suggested-by Tony <anthony.l.nguyen@intel.com>
>>=20
>> * v3:
>> - Add space after comma in commit message=20
>> - Correct spelling of MAC address
>> Suggested-by Paul <pmenzel@molgen.mpg.de>
>>=20
>> * v2:
>> - Change memcpy to ether_addr_copy
>> - Change dev_info to dev_err
>> - Fix the description of the commit message
>> - Change eth_random_addr to eth_hw_addr_random
>> Reported-by: kernel test robot <lkp@intel.com>
>>=20
>> drivers/net/ethernet/intel/igb/igb_main.c | 7 ++++---
>> 1 file changed, 4 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c =
b/drivers/net/ethernet/intel/igb/igb_main.c
>> index 34b33b21e0dc..5e3b162e50ac 100644
>> --- a/drivers/net/ethernet/intel/igb/igb_main.c
>> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
>> @@ -3359,9 +3359,10 @@ static int igb_probe(struct pci_dev *pdev, =
const struct pci_device_id *ent)
>> 	eth_hw_addr_set(netdev, hw->mac.addr);
>>=20
>> 	if (!is_valid_ether_addr(netdev->dev_addr)) {
>> -		dev_err(&pdev->dev, "Invalid MAC Address\n");
>> -		err =3D -EIO;
>> -		goto err_eeprom;
>> +		eth_hw_addr_random(netdev);
>> +		ether_addr_copy(hw->mac.addr, netdev->dev_addr);
>> +		dev_err(&pdev->dev,
>> +			"Invalid MAC address. Assigned random MAC =
address\n");
>> 	}
>>=20
>> 	igb_set_default_mac_filter(adapter);
>=20
> Losing the MAC address is one of the least destructive things you can
> do by poking the EEPROM manually. There are settings in there for =
other
> parts of the EEPROM for the NIC that can just as easily prevent the
> driver from loading, or worse yet even prevent it from appearing on =
the
> PCIe bus in some cases. So I don't see the user induced EEPROM
> corruption as a good justification for this patch as the user =
shouldn't
> be poking the EEPROM if they cannot do so without breaking things.
>=20
> With that said I would be okay with adding this with the provision =
that
> there is a module parameter to turn on this funcitonality. The
> justification would be that the user is expecting to have a corrupted
> EEPROM because they are working with some pre-production board or
> uninitialized sample. This way if somebody is wanting to update the
> EEPROM on a bad board they can use the kernel to do it, but they have
> to explicitly enable this mode and not just have the fact that their
> EEPROM is corrupted hidden as error messages don't necessarily get
> peoples attention unless they are seeing some other issue.

