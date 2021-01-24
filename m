Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9406B301AF6
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 10:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbhAXJ6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 04:58:52 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:47197 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbhAXJ6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 04:58:44 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        by serv108.segi.ulg.ac.be (Postfix) with ESMTP id 27E4D200DF9F;
        Sun, 24 Jan 2021 10:57:46 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 27E4D200DF9F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1611482266;
        bh=P2P0U/RD3dqLKPghqKC9g6/acI4835uWRgrUH161iwM=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=HB/1OXUiTYvpniNfW9bYtLbbzAHw7rLfJpPhRaibAuuR0vJg2JAP0A+2VzNbn5Ruu
         NMr/flpYy/G8LXngYq75UvNGiaHkztQKVCfwk6jxyKwRA6I5ZygBZ1w1rkG5gHWc19
         mE4wjYZ6J6dgTWiJIi/bSFU9VpEC/IQWzYlPdO6OD7Rp99c/UwJo2tWQAFcO0sPRvQ
         mFT73rCJ4nGYkpiTpdeTjEXZeRCGyrm+Uktdc88AC5+rgjEf7pyT3q2LU+2WJT5wpU
         MQhi+OzHfQw7CUXZQB5MKJN6TFenWVYdYG82r5Rf5es6JX5YNCR37W9fzJE7JBoWF3
         IJWXDSJMx045A==
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 1CA54129EC68;
        Sun, 24 Jan 2021 10:57:46 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qlHqiHV7IDMn; Sun, 24 Jan 2021 10:57:46 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 04550129E9B1;
        Sun, 24 Jan 2021 10:57:46 +0100 (CET)
Date:   Sun, 24 Jan 2021 10:57:45 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        alex aring <alex.aring@gmail.com>
Message-ID: <55663307.1072450.1611482265804.JavaMail.zimbra@uliege.be>
In-Reply-To: <20210123205444.5e1df187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210121220044.22361-1-justin.iurman@uliege.be> <20210121220044.22361-2-justin.iurman@uliege.be> <20210123205444.5e1df187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH net 1/1] uapi: fix big endian definition of
 ipv6_rpl_sr_hdr
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [80.200.25.38]
X-Mailer: Zimbra 8.8.15_GA_3980 (ZimbraWebClient - FF84 (Linux)/8.8.15_GA_3980)
Thread-Topic: uapi: fix big endian definition of ipv6_rpl_sr_hdr
Thread-Index: mc2ODQcPVkkULg1Nn7dGBQfWruvijA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> De: "Jakub Kicinski" <kuba@kernel.org>
> =C3=80: "Justin Iurman" <justin.iurman@uliege.be>
> Cc: netdev@vger.kernel.org, davem@davemloft.net, "alex aring" <alex.aring=
@gmail.com>
> Envoy=C3=A9: Dimanche 24 Janvier 2021 05:54:44
> Objet: Re: [PATCH net 1/1] uapi: fix big endian definition of ipv6_rpl_sr=
_hdr

> On Thu, 21 Jan 2021 23:00:44 +0100 Justin Iurman wrote:
>> Following RFC 6554 [1], the current order of fields is wrong for big
>> endian definition. Indeed, here is how the header looks like:
>>=20
>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>> |  Next Header  |  Hdr Ext Len  | Routing Type  | Segments Left |
>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>> | CmprI | CmprE |  Pad  |               Reserved                |
>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>=20
>> This patch reorders fields so that big endian definition is now correct.
>>=20
>>   [1] https://tools.ietf.org/html/rfc6554#section-3
>>=20
>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
>=20
> Are you sure? This looks right to me.

AFAIK, yes. Did you mean the old (current) one looks right, or the new one?=
 If you meant the old/current one, well, I don't understand why the big end=
ian definition would look like this:

#elif defined(__BIG_ENDIAN_BITFIELD)
=09__u32=09reserved:20,
=09=09pad:4,
=09=09cmpri:4,
=09=09cmpre:4;

When the RFC defines the header as follows:

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| CmprI | CmprE |  Pad  |               Reserved                |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

The little endian definition looks fine. But, when it comes to big endian, =
you define fields as you see them on the wire with the same order, right? S=
o the current big endian definition makes no sense. It looks like it was a =
wrong mix with the little endian conversion.

>> diff --git a/include/uapi/linux/rpl.h b/include/uapi/linux/rpl.h
>> index 1dccb55cf8c6..708adddf9f13 100644
>> --- a/include/uapi/linux/rpl.h
>> +++ b/include/uapi/linux/rpl.h
>> @@ -28,10 +28,10 @@ struct ipv6_rpl_sr_hdr {
>>  =09=09pad:4,
>>  =09=09reserved1:16;
>>  #elif defined(__BIG_ENDIAN_BITFIELD)
>> -=09__u32=09reserved:20,
>> +=09__u32=09cmpri:4,
>> +=09=09cmpre:4,
>>  =09=09pad:4,
>> -=09=09cmpri:4,
>> -=09=09cmpre:4;
>> +=09=09reserved:20;
>>  #else
>>  #error  "Please fix <asm/byteorder.h>"
> >  #endif
