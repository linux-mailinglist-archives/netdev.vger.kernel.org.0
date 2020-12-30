Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB432E79D6
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 14:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgL3Nz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 08:55:58 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15936 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgL3Nz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 08:55:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fec86c50000>; Wed, 30 Dec 2020 05:55:17 -0800
Received: from [10.21.241.246] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Dec
 2020 13:55:05 +0000
Subject: Re: [PATCH net-next v2 0/2] Add support for DSFP transceiver type
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Moshe Shemesh <moshe@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "Moshe Shemesh" <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        <vladyslavt@nvidia.com>
References: <1606123198-6230-1-git-send-email-moshe@mellanox.com>
 <20201124011459.GD2031446@lunn.ch>
 <20201124131608.1b884063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <98319caa-de5f-6f5e-9c9e-ee680e5abdc0@nvidia.com>
 <20201125141822.GI2075216@lunn.ch>
 <a9835ab6-70a1-5a15-194e-977ff9c859ec@nvidia.com>
 <20201126152113.GM2073444@lunn.ch>
 <6a9bbcb0-c0c4-92fe-f3c1-581408d1e7da@nvidia.com>
 <20201127155637.GS2073444@lunn.ch>
 <0f021f89-35d4-4d99-b0b1-451f09636e58@nvidia.com> <X+tYamjmow0MfFxz@lunn.ch>
From:   Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Message-ID: <45a1b5c6-d348-cc62-681d-b2f257b578f9@nvidia.com>
Date:   Wed, 30 Dec 2020 15:55:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <X+tYamjmow0MfFxz@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609336517; bh=ah5dsQ+EA0GVJcSoyk30vOiB1baIgccfNjPyR6DfmAc=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=WanRR4SHJ5sRUzJxgLf82HXYEHsRuBIaAIQKqeknSvHlFH5Evm2Y1pEyGFu5lErcy
         I1gRhLYiZ55ry0O5iDz/L7izKxla5EcbZgXndyjj5O/XNshFpkhZ6F5RUoW27xnxsB
         ofUWBRHv9iT3wNLqJWTpGvgOPxBMpHxzCtPqONaEvG++8LAyPBVvmHyAyOb+TUmeFH
         +p48Tq7/y4bl2ecLfNdY0dCYOHN79/twDpUa9UEc0TlYS3x35rPyG0zd2M9vXY90cI
         PgUWH8Nij00f3mB6iQr4yJBBPkDyDA3VHz7xluxJNhUAPTuLyQsFt/s+hRGpfRvwOG
         4FW2gtz+451LQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29-Dec-20 18:25, Andrew Lunn wrote:
>> Hi Andrew,
>>
>> Following this conversation, I wrote some pseudocode checking if I'm on
>> right path here.
>> Please review:
>>
>> struct eeprom_page {
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 page_number;
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 bank_number;
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 offset;
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 data_length;
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 *data;
>> }
> I'm wondering about offset and data_length, in this context. I would
> expect you always ask the kernel for the full page, not part of
> it. Even when user space asks for just part of a page. That keeps you
> cache management simpler.
As far as I know, there may be bytes, which may change on read.
For example, clear on read values in CMIS 4.0.
Then, retrieving whole page every time may be incorrect.
So I kept these for cases, when user asks for specific few bytes.
> But maybe some indicator of low/high is
> needed, since many pages are actually 1/2 pages?
I was planning to use offset and data_length fields to indicate the
available page. For example, high page will have offset 128 and
data_length 128.
> The other thing to consider is SFF-8472 and its use of two different
> i2c addresses, A0h and A2h. These are different to pages and banks.

I wasn't aware of that. It complicates things a bit, should we add a
parameter of i2c address? So in this case page 0 will be with i2c
address A0h. And if user needs page 0 from i2c address A2h, he will
specify it in command line. And for other specs, this parameter will
not be supported.

>> print_human_readable()
>> {
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spec_id =3D cache_get_page(0=
, 0, 0, 128)->data[0];
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (spec_id) {
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case sff_xxxx:
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 print_sff_xxxx();
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case cmis_y:
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 print_cmis_y();
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 default:
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 print_hex();
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> }
> You want to keep as much of the existing ethtool code as you can, but
> the basic idea looks O.K.
Yes, under print_sff_xxxx(), for example, I meant using existing functions.
Either as is, or refactoring according to cache requirements.
>> getmodule_reply_cb()
>> {
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (offset || hex || bank_nu=
mber || page number)
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 print_hex();
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 // if _human_readable() decoder needs more than page =
00, it
>> will
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 // fetch it on demand
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 print_human_readable();
>> }
> Things get interesting here. Say this is page 0, and
> print_human_readable() finds a bit indicating page 1 is valid. So it
> requests page 1. We go recursive. While deep down in
> print_human_readable(), we send the next netlink message and call
> getmodule_reply_cb() when the answer appears. I've had problems with
> some of the netlink code not liking recursive calls.
>
> So i suggest you try to find a different structure for the code. Try
> to complete the netlink call before doing the decoding. So add the
> page to the cache and then return. Do the decode after
> nlsock_sendmsg() has returned.
I'm thinking about a standard-specific function, which will prefetch pages
needed by print_human_readable(). It will check the standard ID, and go=20
request
pages and add them to the cache. Then, decoder kicks with already cached
pages. This will eliminate recursive netlink calls.
>> Driver
>> It is required to implement get_module_eeprom_page() ndo, where it queri=
es
>> its EEPROM and copies to u8 *data array allocated by the kernel previous=
ly.
>> The ndo has the following prototype:
>> int get_module_eeprom_page(struct net_device *, u16 offset, u16 length,
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 u8 page_number, u8 bank_number, u8 *data);
>
> I would include extack here, so we can get better error messages.

OK, I will add extack.

Thanks,
Vlad

