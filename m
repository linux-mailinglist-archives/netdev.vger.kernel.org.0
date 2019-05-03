Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0790F12D25
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 14:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfECMHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 08:07:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42989 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfECMHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 08:07:11 -0400
Received: from 1.general.smb.uk.vpn ([10.172.193.28])
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <stefan.bader@canonical.com>)
        id 1hMWy4-0006oZ-P3; Fri, 03 May 2019 12:07:08 +0000
Subject: Re: Possible refcount bug in ip6_expire_frag_queue()?
To:     Eric Dumazet <edumazet@google.com>,
        Peter Oskolkov <posk@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
References: <20190503091732.19452-1-stefan.bader@canonical.com>
 <CANn89iLjw2bvXO-N-JUhQLZtnWhQey8Hy9KiizMq0=4=CEonGA@mail.gmail.com>
 <CANn89iKm2wLKCMZnp+brgD+1W4r-9rd2xvVL8-=nEhqVdMX7+A@mail.gmail.com>
 <CANn89iJ_exBE2NcrfAKoDRYP+tQXmbGpR1=omwS+89MBhijaqw@mail.gmail.com>
From:   Stefan Bader <stefan.bader@canonical.com>
Openpgp: preference=signencrypt
Autocrypt: addr=stefan.bader@canonical.com; prefer-encrypt=mutual; keydata=
 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
 a/xox1VK9s1EK3Ny6Pj9DekR+8E=
Message-ID: <052c350a-5076-283b-9679-eec21a827b54@canonical.com>
Date:   Fri, 3 May 2019 14:07:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CANn89iJ_exBE2NcrfAKoDRYP+tQXmbGpR1=omwS+89MBhijaqw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="ZpGnsoBW3AumxQtEvSWCJ4Ks46fOeAkj9"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZpGnsoBW3AumxQtEvSWCJ4Ks46fOeAkj9
Content-Type: multipart/mixed; boundary="5XDfd4j7dPExCZpNZqDEWIOmnQUlQ18I8";
 protected-headers="v1"
From: Stefan Bader <stefan.bader@canonical.com>
To: Eric Dumazet <edumazet@google.com>, Peter Oskolkov <posk@google.com>
Cc: netdev <netdev@vger.kernel.org>,
 Ben Hutchings <ben.hutchings@codethink.co.uk>
Message-ID: <052c350a-5076-283b-9679-eec21a827b54@canonical.com>
Subject: Re: Possible refcount bug in ip6_expire_frag_queue()?
References: <20190503091732.19452-1-stefan.bader@canonical.com>
 <CANn89iLjw2bvXO-N-JUhQLZtnWhQey8Hy9KiizMq0=4=CEonGA@mail.gmail.com>
 <CANn89iKm2wLKCMZnp+brgD+1W4r-9rd2xvVL8-=nEhqVdMX7+A@mail.gmail.com>
 <CANn89iJ_exBE2NcrfAKoDRYP+tQXmbGpR1=omwS+89MBhijaqw@mail.gmail.com>
In-Reply-To: <CANn89iJ_exBE2NcrfAKoDRYP+tQXmbGpR1=omwS+89MBhijaqw@mail.gmail.com>

--5XDfd4j7dPExCZpNZqDEWIOmnQUlQ18I8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 03.05.19 13:49, Eric Dumazet wrote:
> On Fri, May 3, 2019 at 7:17 AM Eric Dumazet <edumazet@google.com> wrote=
:
>>
>> On Fri, May 3, 2019 at 7:12 AM Eric Dumazet <edumazet@google.com> wrot=
e:
>>>
>=20
>>> I will send the following fix
>>>
>>> diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
>>> index 28aa9b30aeceac9a86ee6754e4b5809be115e947..d3152811b8962705a508b=
3fd31d2157dd19ae8e5
>>> 100644
>>> --- a/include/net/ipv6_frag.h
>>> +++ b/include/net/ipv6_frag.h
>>> @@ -94,11 +94,9 @@ ip6frag_expire_frag_queue(struct net *net, struct
>>> frag_queue *fq)
>>>                 goto out;
>>>
>>>         head->dev =3D dev;
>>> -       skb_get(head);
>>>         spin_unlock(&fq->q.lock);
>>>
>>>         icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0)=
;
>>> -       kfree_skb(head);
>>
>> Oh well, we want to keep the kfree_skb() of course.
>>
>> Only the skb_get(head) needs to be removed (this would fix memory leak=

>> I presume...  :/ )
>=20
> Official submission :
>=20
> https://patchwork.ozlabs.org/patch/1094854/ ip6: fix skb leak in
> ip6frag_expire_frag_queue()
>=20
> Thanks a lot Stefan for bringing up this issue to our attention !
>=20
Thank you Eric for the quick response.

-Stefan


--5XDfd4j7dPExCZpNZqDEWIOmnQUlQ18I8--

--ZpGnsoBW3AumxQtEvSWCJ4Ks46fOeAkj9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE2118yvOZTjOV2k0+6Gdd7svuzqMFAlzMLuQACgkQ6Gdd7svu
zqMu+BAAoytaY0aqLzHGkLbemsYH1o5tdkySiD62yUt0MoEyCCKy5bf84pJhe3Mp
W9vBugh3xr9g6UmsZwQuDd7FpXePn/tzb3Cfe41KrgBCJ55Lc2i3r7La5m+6Ho5r
Khj9MwFegzvFloVTx5KqRRcSkxUOCmtBns066LI6hRu/CHM6zBRQtElyJ3B/5Dt3
ng5nRCPvgc4f04Fuq+FcsmRUGbfq9Y3EpYG6Nm5TU1w4OmASgQxyDm2QZh1vLqpp
METS+8Yt4rk/rQv2m6c9UrJQLlOB3WYmLMaaSTPXrlMkPfG7/lX6RFWN21WXvuuJ
RqqD9K7lZDZN6biOH4OImrMp+wO58VbdA2nrmgxhVxmRynFvWYQUEZcvnDyj73az
whY/DHf8HvgT/TscuzLh1i/7GLjCIk8JHArp+Q14EKqWPqNcP4exmU/4BvqDaRqs
4xtGvDr8C+myforUr5TBf6lSKcBvvs6EgkLUunegirNlBK9NfMKZfT7NGP3X4IJC
TdEPdONpFXqJsGwqfbLrQIAZGfEG8k1tUeh7UL3N8sRYJewzYnH5isXO4IToXRYV
LXWUgBPybme7OgFK1n/REXtPPV1srDFkhU93hSPPgy8tjV6Nh07D63mmeuRP2UWz
o6cFA5HVhkThtsymGQ+KVl/M7QMuCuF3RJdke36wnFt2x23hv+k=
=0Bm8
-----END PGP SIGNATURE-----

--ZpGnsoBW3AumxQtEvSWCJ4Ks46fOeAkj9--
