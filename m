Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB6B2161A9
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 00:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGFWoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 18:44:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26464 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726491AbgGFWoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 18:44:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594075458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lADiN9digWx1yABnbEC/NhleCjcMB30P02hQYoJI214=;
        b=bzrPd4/81rBc4W0zu2beOVs2gOID8v+WMowMTqvkni1uAyDNylh+SforV48x9Os9nvKQi9
        1p7q3bT8C4KVDyJgG/ABFAspKmmo6PXDA++yM0YokQfeDo3M2Q3ODZDoYQ79IhXnmsltLm
        xC9ZpK5jAD1iLyeacdlH3zOewQgl81M=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-OEDWru19Oem6N9AzktzBnA-1; Mon, 06 Jul 2020 18:44:15 -0400
X-MC-Unique: OEDWru19Oem6N9AzktzBnA-1
Received: by mail-pj1-f70.google.com with SMTP id k4so5704705pjs.1
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 15:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=lADiN9digWx1yABnbEC/NhleCjcMB30P02hQYoJI214=;
        b=BOJoNiXJsH8L8YIvfK0xlu1iTf1cb1ezA+clD2Pa0IHPWVMW+VJtZQ+pCYAmF9a13g
         /DVL8hoTvYmd1qRko9DTkgroYk8HK5CIqBPcBMI81CPwoJxrW9Pe8HUfPXtrcYllEzRW
         jIMp+UcwZWNQbyGLF+Xw25TdkkKZBiP93UodzWTvH2YnMnNFhHqX3JWud2qhFR9d4gWo
         pXmsCAa26AdNnHJ47EfKHAsw7CI/jgi70+RH+YeazXrW+ZUKYwyHLwZO81m8N96g09Jq
         XasYY9KnpHF6R+lm1qbXYffQQmU6N+LvrSQG3mw8IYRSirMnmf8qlaQceA4M9Le3Ojtl
         lqJg==
X-Gm-Message-State: AOAM532eJ9y6n80556y/HzQx6SazNxdL+cuaIGh9IjPixU/NIew8pVjE
        ERnMAqLxdhJkrBryscMnBGn9dkdx6+n8l0orj/wKS0lH+WVcSCWGIEVEnOvjCmux6G3iHRdElOx
        Bnfs4NyYK8rCmyjpP
X-Received: by 2002:a17:902:bb81:: with SMTP id m1mr42577208pls.134.1594075454290;
        Mon, 06 Jul 2020 15:44:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKlDUILrNhEZOu4t20bsIU72SPNfPkiSMv6ptgB8+VNWOgOwWU1av6fzMV5gPPxVbpsQ1m2A==
X-Received: by 2002:a17:902:bb81:: with SMTP id m1mr42577202pls.134.1594075453960;
        Mon, 06 Jul 2020 15:44:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v11sm10277248pfc.108.2020.07.06.15.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 15:44:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 58C6B1804ED; Tue,  7 Jul 2020 00:44:08 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>
Subject: Re: [PATCH net] vlan: consolidate VLAN parsing code and limit max parsing depth
In-Reply-To: <4f7b2b71-8b2a-3aea-637d-52b148af1802@iogearbox.net>
References: <20200706122951.48142-1-toke@redhat.com> <4f7b2b71-8b2a-3aea-637d-52b148af1802@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 07 Jul 2020 00:44:08 +0200
Message-ID: <87lfjwl0w7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 7/6/20 2:29 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Toshiaki pointed out that we now have two very similar functions to extr=
act
>> the L3 protocol number in the presence of VLAN tags. And Daniel pointed =
out
>> that the unbounded parsing loop makes it possible for maliciously crafted
>> packets to loop through potentially hundreds of tags.
>>=20
>> Fix both of these issues by consolidating the two parsing functions and
>> limiting the VLAN tag parsing to an arbitrarily-chosen, but hopefully
>> conservative, max depth of 32 tags. As part of this, switch over
>> __vlan_get_protocol() to use skb_header_pointer() instead of
>> pskb_may_pull(), to avoid the possible side effects of the latter and ke=
ep
>> the skb pointer 'const' through all the parsing functions.
>>=20
>> Reported-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>> Reported-by: Daniel Borkmann <daniel@iogearbox.net>
>> Fixes: d7bf2ebebc2b ("sched: consistently handle layer3 header accesses =
in the presence of VLANs")
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>   include/linux/if_vlan.h | 57 ++++++++++++++++-------------------------
>>   1 file changed, 22 insertions(+), 35 deletions(-)
>>=20
>> diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
>> index 427a5b8597c2..855d16192e6a 100644
>> --- a/include/linux/if_vlan.h
>> +++ b/include/linux/if_vlan.h
>> @@ -25,6 +25,8 @@
>>   #define VLAN_ETH_DATA_LEN	1500	/* Max. octets in payload	 */
>>   #define VLAN_ETH_FRAME_LEN	1518	/* Max. octets in frame sans FCS */
>>=20=20=20
>> +#define VLAN_MAX_DEPTH	32		/* Max. number of nested VLAN tags parsed */
>> +
>
> Any insight on limits of nesting wrt QinQ, maybe from spec side?

Don't think so. Wikipedia says this:

 802.1ad is upward compatible with 802.1Q. Although 802.1ad is limited
 to two tags, there is no ceiling on the standard limiting a single
 frame to more than two tags, allowing for growth in the protocol. In
 practice Service Provider topologies often anticipate and utilize
 frames having more than two tags.

> Why not 8 as max, for example (I'd probably even consider a depth like
> this as utterly broken setup ..)?

I originally went with 8, but chickened out after seeing how many places
call the parsing function. While I do agree that eight tags is... somewhat
excessive... I was trying to make absolutely sure no one would hit this
limit in normal use. See also https://xkcd.com/1172/ :)

-Toke

