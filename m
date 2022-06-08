Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAF45423AC
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbiFHGBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 02:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348838AbiFHF6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:58:34 -0400
Received: from m15111.mail.126.com (m15111.mail.126.com [220.181.15.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FA753D6739
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 21:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Mime-Version:Subject:From:Date:Message-Id; bh=WxyPW
        EOB1JMmC5Tz2pZg2DeAuPERJR4vSk4T6uboS7g=; b=YJe4XGYjQdu07v7Qzwi2x
        JGOaleLLFktzSA/dnL2I0ojAYEQZr4YRmVqmf0w9v4fb99uHFgrpwvKEq6mfprb+
        grHnPaIr5WNyyLVFBJ1J9aubq9PU4J6cjOEBXrFxZcQ2Rz12G48C4x1louuY+9OB
        rXqFESqEMIEwdtTBqPKIRs=
Received: from smtpclient.apple (unknown [223.104.66.113])
        by smtp1 (Coremail) with SMTP id C8mowABnRd56JaBid61oDg--.23726S2;
        Wed, 08 Jun 2022 12:28:43 +0800 (CST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH v4] igb: Assign random MAC address instead of fail in case
 of invalid one
From:   =?utf-8?B?5qKB56S85a2m?= <lianglixuehao@126.com>
In-Reply-To: <83e2fd08cabc0227d105c80d8e0538f546754cc7.camel@gmail.com>
Date:   Wed, 8 Jun 2022 12:28:42 +0800
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, lianglixue@greatwall.com.cn
Content-Transfer-Encoding: quoted-printable
Message-Id: <8186B505-91E9-42A8-AED5-2CC54B9813B5@126.com>
References: <20220601150428.33945-1-lianglixuehao@126.com>
 <f16ef33a4b12cebae2e2300a509014cd5de4a0d2.camel@gmail.com>
 <0362CDDC-AE9B-448C-BE7C-D563B12D5A61@126.com>
 <83e2fd08cabc0227d105c80d8e0538f546754cc7.camel@gmail.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-CM-TRANSID: C8mowABnRd56JaBid61oDg--.23726S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFWrZFW7uw1ftw17ArWkJFb_yoWruFW3pF
        ZYgFWakryDJr409ws7Xr48XFWF9Fn5Jay5Gr98J3sa9wn8ur1xZF40kw45u34UJwn3A3W2
        vFW7Z34DCF90yaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Un6pQUUUUU=
X-Originating-IP: [223.104.66.113]
X-CM-SenderInfo: xold0w5ol03vxkdrqiyswou0bp/1tbiog8aFlx5hmFvUgAAse
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
   Thank you very much for your analysis and explanation, What you said =
is indeed very reasonable,=20
and lead me to further understanding of these scenarios.=20

I will provide a new patch based on your suggestion.

Kind regards,

Lixue

> 2022=E5=B9=B46=E6=9C=887=E6=97=A5 01:04=EF=BC=8CAlexander H Duyck =
<alexander.duyck@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, 2022-06-06 at 22:35 +0800, =E6=A2=81=E7=A4=BC=E5=AD=A6 wrote:
>> Hi,
>> thank you very much for your suggestion.
>>=20
>> As you said, the way to cause =E2=80=98Invalid MAC address=E2=80=99 =
is not only through igb_set_eeprom,
>> but also some pre-production or uninitialized boards.
>>=20
>> But if set by module parameters, especially in the case of =
CONFIG_IGB=3Dy,
>> The situation may be more troublesome, because for most users, if the =
system does not properly load and generate=20
>> the network card device, they can only ask the host supplier for =
help.But,
>=20
> A module parameter can be passed as a part of the kernel command line
> in the case of CONFIG_IGB=3Dy. So it is still something that can be =
dealt
> with via module parameters.
>=20
>> (1) If the invalid mac address is caused by igb_set_eeprom, it is =
relatively more convenient for most operations engineers=20
>> to change the invalid mac address to the mac address they think =
should be valid by ethtool, which may still be Invalid.
>> At this time,assigned random MAC address which is valid by the driver =
enables the network card driver to continue to complete the loading.
>> As for what you mentioned, in this case if the user does not notice =
that the driver had used a random mac address,
>> it may lead to other problems.but the fact is that if the user =
deliberately sets a customized mac address,=20
>> the user should pay attention to whether the mac address is =
successfully changed, and also pay attention to the=20
>> expected result after changing the mac address.When users find that =
the custom mac address cannot=20
>> be successfully changed to the customized one, they can continue =
debugging, which is easier than looking for=20
>> the host supplier=E2=80=99s support from the very first time of =
=E2=80=9CInvalid MAC address=E2=80=9D.
>=20
> The problem is, having a random MAC address automatically assigned
> makes it less likely to detect issues caused by (1). What I have seen
> in the past is people program EEPROMs and overwrite things like a MAC
> address to all 0s. This causes an obvious problem with the current
> driver. If it is changed to just default to using a random MAC address
> when this occurs the issue can be easily overlooked and will likely
> lead to more difficulty in trying to maintain the device as it becomes
> harder to identify if there may be EEPROM issues.
>=20
>> (2) If the invalid mac address is caused during pre-production or =
initialization of the board, it is even more necessary=20
>> to use a random mac address to complete the loading of the network =
card, because the user only cares about whether=20
>> the network card is loaded, not what the valid MAC address is.
>=20
> This isn't necessarily true. What I was getting at is that in the pre-
> production case there may not be an EEPROM even loaded and as one of
> the initial steps it will be necessary to put one together for the
> device.
>=20
> The user could either make the module parameter permenant and have it
> used for every boot, or they might just have to set it once in order =
to
> load a valid EEPROM image on the system.
>=20
>> And I also noticed that ixgbvef_sw_init also uses a random valid mac =
address to continue loading the driver when=20
>> the address is invalid. In addition, network card drivers such as =
marvell, broadcom, realtek, etc., when an invalid=20
>> MAC address is detected, it also does not directly exit the driver =
loading, but uses a random valid MAC address.
>=20
> The VF drivers assign a random MAC address due to more historic =
reasons
> than anything else. In addition generally the use of the random MAC
> address is more-or-less frowned upon. There is logic in ixgbevf that
> will cause the PF to reject the VF MAC address and overwrite the MAC
> address from the PF side.
>=20
> As far as the other drivers they have their reasons. In many cases I
> suspect the driver is intended for an embedded environment where the
> user might not be able to reach the device if the NIC doesn't come up.
>=20
> The igb driver is meant to typically be used in a desktop environment.
> Catching a malformed MAC address is important as a part of that as it
> is one of the health checks for the device. That is why I am open to
> supporting it by default, but only if it is via a module parameter to
> specify the behavior. Otherwise we are changing a key piece of driver
> behavior and will be potentially masking EEPROM issues.

