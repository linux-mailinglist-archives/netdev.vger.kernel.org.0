Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0974E216ADE
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 12:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgGGK6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 06:58:00 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36180 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726911AbgGGK6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 06:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594119478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H2LYwh1VdKHxkxER4SLeQdN4bGqkhcDbcHO7KIziy8U=;
        b=LdMSznuL9PU9ovObn7bV+NwOh38hWmt8ewZnsgSrwYQlBNQGHqNR3AsCfYJ1E4X8U0U95L
        JmH4bGWLXu5l/ASjyPKO8BIVZ5eJnO5+/2ozvDRjaC7tDEpNorttqGitRibIP3Hr3dk/Rz
        lCquc9NzjeVL0cgmzFSeuT2SZKPIRME=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-81E0NFXRN0GPoW5jcwPDfA-1; Tue, 07 Jul 2020 06:57:55 -0400
X-MC-Unique: 81E0NFXRN0GPoW5jcwPDfA-1
Received: by mail-pf1-f197.google.com with SMTP id h75so12484754pfe.23
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 03:57:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=H2LYwh1VdKHxkxER4SLeQdN4bGqkhcDbcHO7KIziy8U=;
        b=j/fYuWQYNMsvz2nQCjTUvoXKwEB7nwct4QXsj2xM7qsfAn6jtl9AWvAIYh0aZjpZHG
         kZ38yMP4YAhlm12SkbKVLMI9tjBrlyrE5YMzrUkAPrZds1raAf3dRi6Fppsa6kzZi3QB
         EvpI7iiaV76XZQt5pTwMMiwgz4EWEvI8Te+wiS/r32et2XOyRi8Fh1SJofFGOnh58j/1
         2SVnbs9qo+WPcUJMHQbUC/RpqYguUE337jyubrWHJiSTA1H+2+Zo5oHkbH1itTqsVIPC
         9s3ua0wI+uy9nTJvkQ5Uq5XSdcczVnQhbUGZmlmEiEnV7ay7CvSS1odLTuVTivpx4BiA
         3h4g==
X-Gm-Message-State: AOAM533gD0LNOnVOiNrgk6hkd1rQHuXiHNvwjX6wgHyvE2/TstznGMOU
        JcIrQP++2dCgwVhlK/77MXc8dxASQ3RHYCWk2KXV7DZMyxZiYpFO30O8D1eznI0epckGc38DtMw
        XqNeMZNnw65PEHOBG
X-Received: by 2002:a65:6416:: with SMTP id a22mr19519037pgv.392.1594119473587;
        Tue, 07 Jul 2020 03:57:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/9IIl501a1fdtLWVOnvj8Zt0/yDhup0dmp5XfHtfzAaK6AUC7ght54TQiL5R5uxU3hdneyQ==
X-Received: by 2002:a65:6416:: with SMTP id a22mr19518985pgv.392.1594119472610;
        Tue, 07 Jul 2020 03:57:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k189sm21462268pfd.175.2020.07.07.03.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 03:57:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 83CC11804ED; Tue,  7 Jul 2020 12:57:47 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH net] vlan: consolidate VLAN parsing code and limit max parsing depth
In-Reply-To: <234d54c2-5b34-7651-5e57-490bee9920ae@gmail.com>
References: <20200706122951.48142-1-toke@redhat.com> <234d54c2-5b34-7651-5e57-490bee9920ae@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 07 Jul 2020 12:57:47 +0200
Message-ID: <87d057lhhw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita <toshiaki.makita1@gmail.com> writes:

> On 2020/07/06 21:29, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
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
> ...
>> @@ -623,13 +597,12 @@ static inline __be16 __vlan_get_protocol(struct sk=
_buff *skb, __be16 type,
>>   			vlan_depth =3D ETH_HLEN;
>>   		}
>>   		do {
>> -			struct vlan_hdr *vh;
>> +			struct vlan_hdr vhdr, *vh;
>>=20=20=20
>> -			if (unlikely(!pskb_may_pull(skb,
>> -						    vlan_depth + VLAN_HLEN)))
>> +			vh =3D skb_header_pointer(skb, vlan_depth, sizeof(vhdr), &vhdr);
>
> Some drivers which use vlan_get_protocol to get IP protocol for checksum =
offload discards
> packets when it cannot get the protocol.
> I guess for such users this function should try to get protocol even if i=
t is not in skb header?
> I'm not sure such a case can happen, but since you care about this, you k=
now real cases where
> vlan tag can be in skb frags?

skb_header_pointer() will still succeed in reading the data, it'll just
do so by copying it into the buffer on the stack (vhdr) instead of
moving the SKB data itself around...

-Toke

