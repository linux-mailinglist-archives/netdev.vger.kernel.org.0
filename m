Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3402E9873
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 16:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbhADPZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 10:25:09 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1918 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbhADPZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 10:25:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff333290000>; Mon, 04 Jan 2021 07:24:25 -0800
Received: from [10.21.240.71] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan
 2021 15:24:14 +0000
Subject: Re: [PATCH net-next v2 0/2] Add support for DSFP transceiver type
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Moshe Shemesh <moshe@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "Moshe Shemesh" <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        <vladyslavt@nvidia.com>
References: <20201124131608.1b884063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <98319caa-de5f-6f5e-9c9e-ee680e5abdc0@nvidia.com>
 <20201125141822.GI2075216@lunn.ch>
 <a9835ab6-70a1-5a15-194e-977ff9c859ec@nvidia.com>
 <20201126152113.GM2073444@lunn.ch>
 <6a9bbcb0-c0c4-92fe-f3c1-581408d1e7da@nvidia.com>
 <20201127155637.GS2073444@lunn.ch>
 <0f021f89-35d4-4d99-b0b1-451f09636e58@nvidia.com> <X+tYamjmow0MfFxz@lunn.ch>
 <45a1b5c6-d348-cc62-681d-b2f257b578f9@nvidia.com> <X+yehiw/6DYUyPzy@lunn.ch>
From:   Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Message-ID: <3c4a5b4f-86bd-19df-c40c-db1452ac43b2@nvidia.com>
Date:   Mon, 4 Jan 2021 17:24:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <X+yehiw/6DYUyPzy@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609773865; bh=rmg9qkVCVN1p0onlKBS0AE/28BEURFbEu0F0txZ4Y60=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=hACISUuBYlODcxn/h8Kl7+ehESYO91FDCHrylEKr+Gc1qrQqBZCCOhT+Oh5Fy24KC
         d9tMsvAF275jQ0YHly4aX5Fr2tyJb2bj/yf2p3PbhrJ+DwB5pcP5yiu05/cA9ldpsB
         HU+EKWe+0eLzQvLyBSrhoob0WC/JinA15tmbNrehmaBPafXjnS4vS4+o64Sz6bW5UX
         9stouYD8d8VinJygSYjMl6l5Z6oMutEAJvZFS4r0hS89es7y5tPhRF9jXU9rErcq/G
         kK7phzYjiKA7sWp5dgkX+8RTWjNrrnxT1biUZYSxBoSR3dA7efuxPx/F+PdCZVHSEe
         ETNUvCuYIaLYg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 30-Dec-20 17:36, Andrew Lunn wrote:
> On Wed, Dec 30, 2020 at 03:55:02PM +0200, Vladyslav Tarasiuk wrote:
>> On 29-Dec-20 18:25, Andrew Lunn wrote:
>>>> Hi Andrew,
>>>>
>>>> Following this conversation, I wrote some pseudocode checking if I'm o=
n
>>>> right path here.
>>>> Please review:
>>>>
>>>> struct eeprom_page {
>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 page_number;
>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 bank_number;
>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 offset;
>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 data_length;
>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 *data;
>>>> }
>>> I'm wondering about offset and data_length, in this context. I would
>>> expect you always ask the kernel for the full page, not part of
>>> it. Even when user space asks for just part of a page. That keeps you
>>> cache management simpler.
>> As far as I know, there may be bytes, which may change on read.
>> For example, clear on read values in CMIS 4.0.
> Ah, i did not know there were such bits. I will go read the spec. But
> it should not really matter. If the SFP driver is interested in these
> bits, it will have to intercept the read and act on the values.

But in case user requests a few bytes from a page with clear-on-read
values, reading full page will clear all such bytesfrom user perspective
even if they were not requested. Driver may intercept the read, but for
user it will look like those bytes were not set.

Current user interface allows arbitrary reads, so I wanted to keep this
behavior pretty much exactly like it is now - request specific part of
a page, get this part without any extra data.

>> I wasn't aware of that. It complicates things a bit, should we add a
>> parameter of i2c address? So in this case page 0 will be with i2c
>> address A0h. And if user needs page 0 from i2c address A2h, he will
>> specify it in command line.
> Not on the command line. You should be able to determine from reading
> page 0 at A0h is the diagnostics are at A2h or a page of A0h. That is
> the whole point of this API, we decode the first page, and that tells
> us what other pages should be available. So adding the i2c address to
> the netlink message would be sensible. And i would not be too
> surprised if there are SFPs with proprietary registers on other
> addresses, which could be interesting to dump, if you can get access
> to the needed datasheets.
Without command line argument user will not be able to request a single
A2h page, for example. He will see it only in some kind of general dump -
with human-readable decoder usage or multiple page dump.

And same goes forpages on other i2c addresses. How to know what to dump,
if user does not provide i2c address and there is no way to know what to
request from proprietary SFPs?

Thanks,
Vlad

