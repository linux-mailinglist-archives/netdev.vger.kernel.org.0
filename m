Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5AC64D5C1
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 05:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLOEAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 23:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiLOEAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 23:00:48 -0500
X-Greylist: delayed 1821 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 14 Dec 2022 20:00:44 PST
Received: from m126.mail.126.com (m126.mail.126.com [123.126.96.241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 106D6B90;
        Wed, 14 Dec 2022 20:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Mime-Version:Subject:From:Date:Message-Id; bh=fgped
        /cHY+dSCJhZH72zP6+DNg6zWat/eyqSI8C99U8=; b=RI7OXGTtZj/TPZa7LqA82
        0L//hPckXaHMhJIiASbCgvU65yQ90VGunrqtEqi0yv9vK4yGXwm1rRMkjekePX7T
        eVrq8j/H6GKqIlBs0x5XZb+pWaOW/wB8djhtDnk2WX3XduyljCs/xbSeWBhxKMUd
        BBK1JJdxUjRXqmxasOofmI=
Received: from smtpclient.apple (unknown [117.136.79.109])
        by smtp14 (Coremail) with SMTP id fuRpCgDH5+OHk5pjy9VfAg--.45741S3;
        Thu, 15 Dec 2022 11:24:57 +0800 (CST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in case
 of invalid one
From:   =?utf-8?B?5qKB56S85a2m?= <lianglixuehao@126.com>
In-Reply-To: <CAKgT0UdZUmFD8qYdF6k47ZmRgB0jS-graOYgB5Se+y+4fKqW8w@mail.gmail.com>
Date:   Thu, 15 Dec 2022 11:24:54 +0800
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2D8AD99A-E29B-40CC-AFEC-3D9D4AC80C14@126.com>
References: <20221213074726.51756-1-lianglixuehao@126.com>
 <Y5l5pUKBW9DvHJAW@unreal> <20221214085106.42a88df1@kernel.org>
 <Y5obql8TVeYEsRw8@unreal> <20221214125016.5a23c32a@kernel.org>
 <4576ee79-1040-1998-6d91-7ef836ae123b@gmail.com>
 <CAKgT0UdZUmFD8qYdF6k47ZmRgB0jS-graOYgB5Se+y+4fKqW8w@mail.gmail.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-CM-TRANSID: fuRpCgDH5+OHk5pjy9VfAg--.45741S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFykZr1xCw17urWfXF17GFg_yoWrJw4xpa
        y3Kay7Kr1DJr4jkr4vqr48XFyYva93Ja15uryrtw1I9wn09rW2kFy7KF1Y9FW8Gwn7AF1j
        vFWaqFy7ua4DAaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UbqXLUUUUU=
X-Originating-IP: [117.136.79.109]
X-CM-SenderInfo: xold0w5ol03vxkdrqiyswou0bp/1tbi5grYFmIxk4+BTwAAsj
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The module parameter method does bring some inconvenience to the user,=20=

especially the parameter needs to be specified when the module is =
loaded.=20
But as alexander said, if the net device is not successfully registered,=20=

the user has no chance to modify the invalid MAC address in the current =
EEPROM.=20
At present, the read/write of EEPROM is bundled with the net driver.=20
I am not sure if there is any other way to complete the modification of =
EEPROM=20
independently of the network driver;

Is it necessary to bind the registration of net device to the judgment =
of invalid MAC?
I personally think that MAC configuration is not the capability or =
function of the device,=20
this should not affect the registration of the device;
Can the invalid MAC be judged in the up stage of the network device?=20
In this way, the net driver can continue to be loaded successfully,=20
and the MAC can be changed using ethtool, and it will not increase the =
difficulty of debugging for users.

Thanks

> 2022=E5=B9=B412=E6=9C=8815=E6=97=A5 07:17=EF=BC=8CAlexander Duyck =
<alexander.duyck@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Wed, Dec 14, 2022 at 1:43 PM Heiner Kallweit <hkallweit1@gmail.com> =
wrote:
>>=20
>> On 14.12.2022 21:50, Jakub Kicinski wrote:
>>> On Wed, 14 Dec 2022 20:53:30 +0200 Leon Romanovsky wrote:
>>>> On Wed, Dec 14, 2022 at 08:51:06AM -0800, Jakub Kicinski wrote:
>>>>> On Wed, 14 Dec 2022 09:22:13 +0200 Leon Romanovsky wrote:
>>>>>> NAK to any module driver parameter. If it is applicable to all =
drivers,
>>>>>> please find a way to configure it to more user-friendly. If it is =
not,
>>>>>> try to do the same as other drivers do.
>>>>>=20
>>>>> I think this one may be fine. Configuration which has to be set =
before
>>>>> device probing can't really be per-device.
>>>>=20
>>>> This configuration can be different between multiple devices
>>>> which use same igb module. Module parameters doesn't allow such
>>>> separation.
>>>=20
>>> Configuration of the device, sure, but this module param is more of
>>> a system policy. BTW the name of the param is not great, we're =
allowing
>>> the use of random address, not an invalid address.
>>>=20
>>>> Also, as a user, I despise random module parameters which I need
>>>> to set after every HW update/replacement.
>>>=20
>>> Agreed, IIUC the concern was alerting users to incorrect EEPROM =
values.
>>> I thought falling back to a random address was relatively common, =
but
>>> I haven't done the research.
>>=20
>> My 2ct, because I once added the fallback to a random MAC address to =
r8169:
>> Question is whether there's any scenario where you would prefer =
bailing out
>> in case of invalid MAC address over assigning a random MAC address =
(that the
>> user may manually change later) plus a warning.
>> I'm not aware of such a scenario. Therefore I decided to hardcode =
this
>> fallback in the driver.
>=20
> I've seen issues with such a solution in the past. In addition it is
> very easy for the user to miss the warning and when the EEPROM is
> corrupted on the Intel NICs it has other side effects. That is one of
> the reasons why the MAC address is used as a requirement for us to
> spawn a netdev.
>=20
> As far as the discussion for module parameter vs something else. The
> problem with the driver is that it is monolithic so it isn't as if
> there is a devlink interface to configure a per-network parameter
> before the network portion is loaded. The module parameter is a
> compromise that should only be used to enable the workaround so that
> the driver can be loaded so that the EEPROM can then be edited. If
> anything, tying the EEPROM to ethtool is the issue. If somebody wants
> to look at providing an option to edit the EEPROM via devlink that
> would solve the issue as then the driver could expose the devlink
> interface to edit the EEPROM without having to allocate and register a
> netdev.

