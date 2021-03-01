Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4430432A2BB
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349457AbhCBI1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239237AbhCAXYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 18:24:11 -0500
Received: from orthanc.universe-factory.net (orthanc.universe-factory.net [IPv6:2001:19f0:6c01:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106CAC061756;
        Mon,  1 Mar 2021 15:23:31 -0800 (PST)
Received: from [IPv6:2001:19f0:6c01:100::2] (unknown [IPv6:2001:19f0:6c01:100::2])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by orthanc.universe-factory.net (Postfix) with ESMTPSA id D0F961F5DB;
        Tue,  2 Mar 2021 00:23:28 +0100 (CET)
Subject: Re: [PATCH net] net: l2tp: reduce log level when passing up invalid
 packets
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <f2a482212eed80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>
 <20210219201201.GA4974@katalix.com>
 <2e75a78b-afa2-3776-2695-f9f6ac93eb67@universe-factory.net>
 <20210222114907.GA4943@katalix.com>
 <ec0f874e-b5af-1007-5a83-e3de7399ef29@universe-factory.net>
 <20210222143138.5711048a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210223094722.GB12377@katalix.com>
From:   Matthias Schiffer <mschiffer@universe-factory.net>
Message-ID: <1b888cc7-cbc8-c241-6546-7f2e4c85a7e3@universe-factory.net>
Date:   Tue, 2 Mar 2021 00:23:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210223094722.GB12377@katalix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WXBx5OLeOMPUXGDnEaDL67IJbN95HpVXl"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WXBx5OLeOMPUXGDnEaDL67IJbN95HpVXl
Content-Type: multipart/mixed; boundary="8aTJfq8uzBavlPLVP83iT26qV9zzZLGPx";
 protected-headers="v1"
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: Tom Parkin <tparkin@katalix.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Message-ID: <1b888cc7-cbc8-c241-6546-7f2e4c85a7e3@universe-factory.net>
Subject: Re: [PATCH net] net: l2tp: reduce log level when passing up invalid
 packets
References: <f2a482212eed80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>
 <20210219201201.GA4974@katalix.com>
 <2e75a78b-afa2-3776-2695-f9f6ac93eb67@universe-factory.net>
 <20210222114907.GA4943@katalix.com>
 <ec0f874e-b5af-1007-5a83-e3de7399ef29@universe-factory.net>
 <20210222143138.5711048a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210223094722.GB12377@katalix.com>
In-Reply-To: <20210223094722.GB12377@katalix.com>

--8aTJfq8uzBavlPLVP83iT26qV9zzZLGPx
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: quoted-printable

On 2/23/21 10:47 AM, Tom Parkin wrote:
> On  Mon, Feb 22, 2021 at 14:31:38 -0800, Jakub Kicinski wrote:
>> On Mon, 22 Feb 2021 17:40:16 +0100 Matthias Schiffer wrote:
>>>>> This will not be sufficient for my usecase: To stay compatible with=
 older
>>>>> versions of fastd, I can't set the T flag in the first packet of th=
e
>>>>> handshake, as it won't be known whether the peer has a new enough f=
astd
>>>>> version to understand packets that have this bit set. Luckily, the =
second
>>>>> handshake byte is always 0 in fastd's protocol, so these packets fa=
il the
>>>>> tunnel version check and are passed to userspace regardless.
>>>>>
>>>>> I'm aware that this usecase is far outside of the original intentio=
ns of the
>>>>> code and can only be described as a hack, but I still consider this=
 a
>>>>> regression in the kernel, as it was working fine in the past, witho=
ut
>>>>> visible warnings.
>>>>>  =20
>>>>
>>>> I'm sorry, but for the reasons stated above I disagree about it bein=
g
>>>> a regression.
>>>
>>> Hmm, is it common for protocol implementations in the kernel to warn =
about
>>> invalid packets they receive? While L2TP uses connected sockets and t=
hus
>>> usually no unrelated packets end up in the socket, a simple UDP port =
scan
>>> originating from the configured remote address/port will trigger the =
"short
>>> packet" warning now (nmap uses a zero-length payload for UDP scans by=

>>> default). Log spam caused by a malicous party might also be a concern=
=2E
>>
>> Indeed, seems like appropriate counters would be a good fit here?
>> The prints are both potentially problematic for security and lossy.
>=20
> Yes, I agree with this argument.
>=20

Sounds good, I'll send an updated patch adding a counter for invalid pack=
ets.

By now I've found another project affected by the kernel warnings:
https://github.com/wlanslovenija/tunneldigger/issues/160


--8aTJfq8uzBavlPLVP83iT26qV9zzZLGPx--

--WXBx5OLeOMPUXGDnEaDL67IJbN95HpVXl
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEZmTnvaa2aYgexS51Fu8/ZMsgHZwFAmA9d28FAwAAAAAACgkQFu8/ZMsgHZyn
Nw/+K4qRCu8QWJi31cn9WSDjU2xt5V2/0Ag59MvWnrg3aVJJaxsRZC/od2fBih22K3aqpYhpsSEh
GwXzejjeij8ehOqoLtQkA4yfYXNCuOnpslOsGGS+1McTfO9t7GTZpGjjXycX3DvlsW7orTarq0HS
fV1cpEFJU828WN2yLB2vQneguTQXYzELDbKwAHwrDi6GtUK6T0C9EUiDkdGey+Z66bO26TRDIPMc
S6dJmKxJnDPnwuX9fv51OuDhrhyz1Z9fLA91qX4edT3LavTGxaF3O9Eh8XZkmXzux0fiwXEEsrr6
jI5vJWnVskNr9qqk4eiQB4NghaSD94M8xKoYo2rEAWD+Be5cXg8KDAzOK5YnsyqdXXTCgZSSu/e1
3sjokjBJHo5WejFiL049YwM3FHNYYk1XErOMXKkfe/EGIl0YrjP30rl4A2wtCj/1Q++uoKGjXgVm
44lrUPIhx89ydM7VHdqaEy1wM+7GhQc4sC5mUjUGfEd62k9M+Ztk9OyRf7CfMBF8ppZQEbUhu4bD
GZ4tpOtZBOfN1FEcZ4Yl69X5BcPWoKss/Wgc2uW521vqBIJJt5YqSEY7CMNS/9iMLADorvzCU6/A
++mupxmimNDTwiIhZKqmPBvkJPGwtGBgLoZhfZZyCmsn/9oq34jNJx9ic00RmPCMLDkO20zVXv/0
Oo4=
=BxHj
-----END PGP SIGNATURE-----

--WXBx5OLeOMPUXGDnEaDL67IJbN95HpVXl--
