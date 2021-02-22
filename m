Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8850321443
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 11:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhBVKjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 05:39:48 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6494 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhBVKjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 05:39:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603389cb0000>; Mon, 22 Feb 2021 02:39:07 -0800
Received: from [172.27.13.143] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 10:39:05 +0000
Subject: Re: [PATCH iproute2 v4 1/1] build: Fix link errors on some systems
From:   Roi Dayan <roid@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>
References: <20210112103317.978952-1-roid@nvidia.com>
 <87h7nm73db.fsf@nvidia.com> <482304af-beef-3703-2309-71e6611acec6@nvidia.com>
Message-ID: <c916c62c-c67e-bfcc-8e42-bd7bc0e8c145@nvidia.com>
Date:   Mon, 22 Feb 2021 12:39:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <482304af-beef-3703-2309-71e6611acec6@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613990347; bh=2tOa+HoO6SlhrO7bpBVypx/x3zd6nUsl/t9eBat0ZgM=;
        h=Subject:From:To:CC:References:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=VbJZM9BzRLx1hy2CgcswW2tq2WV9TJcM/SeJb9CEoaMvlxZKAkDAiH10KajEPsG/f
         6rhc9eM4i10r9BaPRuDNajnGYuOurGc57i0XBQ/o4gKS6NI68f2gUlirNcSJ1PWxnI
         1d6TnYZTYjrQEpzKlvcklCFA2wCMVAZtu4kxzO8J1Vxz1hNI7DsbYwCMSnOrHRlbke
         ONBJtXTKAmuxGPA7joZ/IsyPxi8e65vnKPwQi4YM7yTNFSJEZuDk5o3+lY6Td6zr2a
         Zb4YNzMyOE+LX8zPM8TTY89l3END+GK6UmKxEvVVamyMNOQHxiyhSYM4Hm3fr55XSF
         /nqBlX9blak9w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-02-22 12:36 PM, Roi Dayan wrote:
>=20
>=20
> On 2021-01-12 2:21 PM, Petr Machata wrote:
>>
>> Roi Dayan <roid@nvidia.com> writes:
>>
>>> Since moving get_rate() and get_size() from tc to lib, on some
>>> systems we fail to link because of missing math lib.
>>> Move the functions that require math lib to their own c file
>>> and add -lm to dcb that now use those functions.
>>>
>>> ../lib/libutil.a(utils.o): In function `get_rate':
>>> utils.c:(.text+0x10dc): undefined reference to `floor'
>>> ../lib/libutil.a(utils.o): In function `get_size':
>>> utils.c:(.text+0x1394): undefined reference to `floor'
>>> ../lib/libutil.a(json_print.o): In function `sprint_size':
>>> json_print.c:(.text+0x14c0): undefined reference to `rint'
>>> json_print.c:(.text+0x14f4): undefined reference to `rint'
>>> json_print.c:(.text+0x157c): undefined reference to `rint'
>>>
>>> Fixes: f3be0e6366ac ("lib: Move get_rate(), get_rate64() from tc here")
>>> Fixes: 44396bdfcc0a ("lib: Move get_size() from tc here")
>>> Fixes: adbe5de96662 ("lib: Move sprint_size() from tc here, add=20
>>> print_size()")
>>>
>>> Signed-off-by: Roi Dayan <roid@nvidia.com>
>>
>> Looking good:
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 $ ldd ip/ip | grep libm.so
>> =C2=A0=C2=A0=C2=A0=C2=A0 $ ldd dcb/dcb | grep libm.so
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 libm.so.6 =3D> /lib64/libm.so.6 (0x00007f204d0c2000)
>>
>> Reviewed-by: Petr Machata <petrm@nvidia.com>
>> Tested-by: Petr Machata <petrm@nvidia.com>
>>
>=20
> Hi,
>=20
> Pinging about this commit. I noticed it was not taken.
> anything you want me to update? push again?
>=20
> Thanks,
> Roi

sorry, my mistake. wrong git clone :)
