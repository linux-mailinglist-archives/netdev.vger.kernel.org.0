Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882DD216AD1
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 12:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgGGKzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 06:55:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56817 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726540AbgGGKzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 06:55:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594119306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u2CpusvBd4Nq44OvXUCk8t7JsvuTA+1iP5kw9pC+33g=;
        b=DO0WXXNUsDWe+lMJ0vqE90le/pin8JGoPtKMBoEqzuvclOk1ZUlx9eyxFEjeGc+vbOWuMH
        HEd35BFv+v8R6Fgt1MyqSNxLvHARwex79jIHGlTnm/P+t/HfMJaeKaeqAGbZqPxLCLxoLr
        89+/dBX2WJc2HaGtkegfUzIvYhB1eu4=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-Ojg3JzKcNyymZNbvuPXfhw-1; Tue, 07 Jul 2020 06:55:02 -0400
X-MC-Unique: Ojg3JzKcNyymZNbvuPXfhw-1
Received: by mail-pf1-f200.google.com with SMTP id d67so26364363pfd.4
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 03:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=u2CpusvBd4Nq44OvXUCk8t7JsvuTA+1iP5kw9pC+33g=;
        b=TTMgMH2uwRHZEZUA1IfUKoQYJdTDtE+EahM6RCOhL12pbaDsd4KrNBKf9L8aEIDu74
         qZQn5WE2B/w19yDQ093ywimbN9XikbLVW5n/AdpEgvwMnwJ6+WrYY+M39OK4hnjEunBy
         hLVJX+6lAqO8DLF25vRhiDHHTvh4qtibknxbrQWmyBJxKyRQpfr1jzIaZIL0HxtDo+/T
         hklnom5uAbJp3CGJE47SXhJJLLSe3wNnZuNI43K51NIAJFcCrBBgPJ/kYJVr5C+nDwwB
         Py4i+qn7A0lUxJ9TL1DPf9X7yW/kmXRrm99NXr4CsS2GvD+3i7vYY0txTJjL9YTJytuf
         dIog==
X-Gm-Message-State: AOAM530dnDJubUKB0rXMwiINFXpKWGedR7YqKpx9rMk0lLzRsdfHINe7
        mzr0e46+cChi/bH/oDAFwS6Q3zOmNERaglNpt4jNf3/Y1+OGX7UR7zdg+sMQRUk0XzCaqg0KpJd
        IkNJ1PGI6D0Jverl7
X-Received: by 2002:a17:90b:2285:: with SMTP id kx5mr3959944pjb.83.1594119301857;
        Tue, 07 Jul 2020 03:55:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4JnOZBOCNfPhTFsfcp37K6iWRLJmt2TprWvUWBb8ar5C8YzMvfLEqXGkT97on2VKu3EKivA==
X-Received: by 2002:a17:90b:2285:: with SMTP id kx5mr3959922pjb.83.1594119301619;
        Tue, 07 Jul 2020 03:55:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id e20sm5506830pfl.212.2020.07.07.03.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 03:55:00 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0BB4F1804ED; Tue,  7 Jul 2020 12:54:56 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net] vlan: consolidate VLAN parsing code and limit max parsing depth
In-Reply-To: <934a694b-ae3f-8247-c979-3d062b9804e4@gmail.com>
References: <20200706122951.48142-1-toke@redhat.com> <4f7b2b71-8b2a-3aea-637d-52b148af1802@iogearbox.net> <87lfjwl0w7.fsf@toke.dk> <934a694b-ae3f-8247-c979-3d062b9804e4@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 07 Jul 2020 12:54:56 +0200
Message-ID: <87fta3lhmn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita <toshiaki.makita1@gmail.com> writes:

> On 2020/07/07 7:44, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>> On 7/6/20 2:29 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Toshiaki pointed out that we now have two very similar functions to ex=
tract
>>>> the L3 protocol number in the presence of VLAN tags. And Daniel pointe=
d out
>>>> that the unbounded parsing loop makes it possible for maliciously craf=
ted
>>>> packets to loop through potentially hundreds of tags.
>>>>
>>>> Fix both of these issues by consolidating the two parsing functions and
>>>> limiting the VLAN tag parsing to an arbitrarily-chosen, but hopefully
>>>> conservative, max depth of 32 tags. As part of this, switch over
>>>> __vlan_get_protocol() to use skb_header_pointer() instead of
>>>> pskb_may_pull(), to avoid the possible side effects of the latter and =
keep
>>>> the skb pointer 'const' through all the parsing functions.
>>>>
>>>> Reported-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>>>> Reported-by: Daniel Borkmann <daniel@iogearbox.net>
>>>> Fixes: d7bf2ebebc2b ("sched: consistently handle layer3 header accesse=
s in the presence of VLANs")
>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>> ---
>>>>    include/linux/if_vlan.h | 57 ++++++++++++++++----------------------=
---
>>>>    1 file changed, 22 insertions(+), 35 deletions(-)
>>>>
>>>> diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
>>>> index 427a5b8597c2..855d16192e6a 100644
>>>> --- a/include/linux/if_vlan.h
>>>> +++ b/include/linux/if_vlan.h
>>>> @@ -25,6 +25,8 @@
>>>>    #define VLAN_ETH_DATA_LEN	1500	/* Max. octets in payload	 */
>>>>    #define VLAN_ETH_FRAME_LEN	1518	/* Max. octets in frame sans FCS */
>>>>=20=20=20=20
>>>> +#define VLAN_MAX_DEPTH	32		/* Max. number of nested VLAN tags parsed =
*/
>>>> +
>>>
>>> Any insight on limits of nesting wrt QinQ, maybe from spec side?
>>=20
>> Don't think so. Wikipedia says this:
>>=20
>>   802.1ad is upward compatible with 802.1Q. Although 802.1ad is limited
>>   to two tags, there is no ceiling on the standard limiting a single
>>   frame to more than two tags, allowing for growth in the protocol. In
>>   practice Service Provider topologies often anticipate and utilize
>>   frames having more than two tags.
>>=20
>>> Why not 8 as max, for example (I'd probably even consider a depth like
>>> this as utterly broken setup ..)?
>>=20
>> I originally went with 8, but chickened out after seeing how many places
>> call the parsing function. While I do agree that eight tags is... somewh=
at
>> excessive... I was trying to make absolutely sure no one would hit this
>> limit in normal use. See also https://xkcd.com/1172/ :)
>
> Considering that XMIT_RECURSION_LIMIT is 8, I also think 8 is sufficient.

Alright, fair enough, I'll send a v2 with a limit of 8 :)

-Toke

