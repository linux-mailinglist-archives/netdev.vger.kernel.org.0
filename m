Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951F52CBA30
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 11:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388487AbgLBKIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 05:08:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388089AbgLBKIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 05:08:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606903639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sw7rKU2HDnQ1C3PKcK1bk+44GtKi7PTJ/Na9GIe7Z/g=;
        b=CI0KW0V30ZvY+UCTlFAfOzyysV2bmPRDN9weim2TN81K8vgnRKjWPt9C9KcV64AbhMpHUZ
        +su2GUxlFy7086lJ7rUUkh/CgUmSoGu466iFAVQETMmIAG18rKGKKt5sGr8LS3ffrbY8l/
        AtO8R8mk1svftyFNUaSQ6qg/OaCw5co=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-pDAlYnSJMZ-KMVTSTBiPOg-1; Wed, 02 Dec 2020 05:07:18 -0500
X-MC-Unique: pDAlYnSJMZ-KMVTSTBiPOg-1
Received: by mail-qv1-f71.google.com with SMTP id e13so809416qvl.19
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 02:07:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Sw7rKU2HDnQ1C3PKcK1bk+44GtKi7PTJ/Na9GIe7Z/g=;
        b=JdvKRI591cYWW3ELUwLjAMl+7ml4vwTKijvrOYw3jFZN9FS0T1CDHRWewiZteMVVue
         b9CtdSTIqWPkFHFPpgU3pVexD6od26SQ4SBvPdK20t32ZIfjqa7RoBxdhxuTD9po6eVl
         434mLr3uinTyPKcp3V4w2FFRnwdFEMqzrAgJ0tQhpWc4hVOZGylWtQqKtqrROiyZ/bt8
         veqnvNBn5sdpy6cmkbR59AywHXy9gE8+aFcHXMgbhGdEfBh+Eu0fPj9dsPgWh84JmgO3
         Gl67VbKMf6NaOh1WoQuFRZYkY6yJibUz3unYc1+TUg81bInPtMrjC7Kwk6M+BSdtIXIn
         L2bw==
X-Gm-Message-State: AOAM532/SvJ50u9mpcKHYu84JvL+W/sRPUwnPTHJKxj5SwGPCj9j9Wod
        J+DP0ajak638r7JGoCAhBnz/PqFPjEV/Z8ChDX0JgvtOIqixkqJQf+iUjby1pX1nmEcM40iwPBY
        LW7jOj6t55PYPoXDp
X-Received: by 2002:a37:66d4:: with SMTP id a203mr1669630qkc.362.1606903637772;
        Wed, 02 Dec 2020 02:07:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLSaeZiy2Da5/sHYL8+nLGe8hDvmE04TLrl5NfKr3q1rVUtRNFJ8s+4EAv50uGsv5AUcv5gg==
X-Received: by 2002:a37:66d4:: with SMTP id a203mr1669608qkc.362.1606903637525;
        Wed, 02 Dec 2020 02:07:17 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g70sm1186598qke.8.2020.12.02.02.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 02:07:16 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7E08E182EE9; Wed,  2 Dec 2020 11:07:15 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jonathan Morton <chromatix99@gmail.com>,
        Pete Heist <pete@heistp.net>
Subject: Re: [PATCH net] inet_ecn: Fix endianness of checksum update when
 setting ECT(1)
In-Reply-To: <20201201172442.2d8dca75@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201130183705.17540-1-toke@redhat.com>
 <20201201172442.2d8dca75@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Dec 2020 11:07:15 +0100
Message-ID: <87o8jccyi4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 30 Nov 2020 19:37:05 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> When adding support for propagating ECT(1) marking in IP headers it seem=
s I
>> suffered from endianness-confusion in the checksum update calculation: In
>> fact the ECN field is in the *lower* bits of the first 16-bit word of the
>> IP header when calculating in network byte order. This means that the
>> addition performed to update the checksum field was wrong; let's fix tha=
t.
>>=20
>> Fixes: b723748750ec ("tunnel: Propagate ECT(1) when decapsulating as rec=
ommended by RFC6040")
>> Reported-by: Jonathan Morton <chromatix99@gmail.com>
>> Tested-by: Pete Heist <pete@heistp.net>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Applied and queued, thanks!
>
>> diff --git a/include/net/inet_ecn.h b/include/net/inet_ecn.h
>> index e1eaf1780288..563457fec557 100644
>> --- a/include/net/inet_ecn.h
>> +++ b/include/net/inet_ecn.h
>> @@ -107,7 +107,7 @@ static inline int IP_ECN_set_ect1(struct iphdr *iph)
>>  	if ((iph->tos & INET_ECN_MASK) !=3D INET_ECN_ECT_0)
>>  		return 0;
>>=20=20
>> -	check +=3D (__force u16)htons(0x100);
>> +	check +=3D (__force u16)htons(0x1);
>>=20=20
>>  	iph->check =3D (__force __sum16)(check + (check>=3D0xFFFF));
>>  	iph->tos ^=3D INET_ECN_MASK;
>
> This seems to be open coding csum16_add() - is there a reason and if
> not perhaps worth following up in net-next?

Hmm, good point. I think I originally just copied this from
IP_ECN_set_ce(), which comes all the way back from the initial
Linux-2.6.12-rc2 commit in git. So I suppose it may just predate the
csum helpers? I'll wait for this patch to get propagated to net-next,
then follow up with a fix there :)

-Toke

