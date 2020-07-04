Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F8321454C
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 13:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgGDLdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 07:33:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35598 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726621AbgGDLdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 07:33:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593862432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4HB36sjhmx4bYypIIg0QrKY9T+pJQwvtAds11G9bSlA=;
        b=RksJ4xDNqNKYAh9GVr5BsUiRlT+sBZQV4qOqcWfORf+cvw1XmVRrrMPMPlcj8FrMmOqn0Z
        FnJOhfXQKAFviqFuns+CLlmgCpIX7Tb842oBIqc5dZpsdbY+BGNYfwNJQLoIv51I0J47f2
        j+wOUuWQWCe6nFrS2CrAn0PNuC7M/aU=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-NEdG-ldeNMG3cFqajSeyLg-1; Sat, 04 Jul 2020 07:33:50 -0400
X-MC-Unique: NEdG-ldeNMG3cFqajSeyLg-1
Received: by mail-pg1-f198.google.com with SMTP id e22so25328454pgl.6
        for <netdev@vger.kernel.org>; Sat, 04 Jul 2020 04:33:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=4HB36sjhmx4bYypIIg0QrKY9T+pJQwvtAds11G9bSlA=;
        b=Mso/s58aVZP008iwb4/+bIoZPNtTLHVnXK0gemAUT8FM0/HVmX3c7ip/0kJ/C1kbZ2
         1MpxPHKuok11sQ04C0Xb3HR6hRORKbh0kDPtCi0gSORU2vuimiL7M5Gqj34xZ4ldRQc6
         kOX+/xrde0ueGXfuDEHNOh/DEfoZ9wyWkGvQ/wc2SJeU+yDXEJOx1MpPALIzRluOcoM6
         ySs0HAAJr+/aPfJd/KcryhEvnXdpar5kte6lAvL4tce1BXuQimsY2dsmHGz2OmhL3RrY
         QMJfgfJJOAi51/GtWN8CW44Mb4hRy02eN5jhFy9u6T24Z482KwM4RquOsjV7NZoqXn5e
         qIlQ==
X-Gm-Message-State: AOAM530k9d33g0vzdGem6FJoK9/rM+7TPzDXANGqoB5drmYtf/y5aMwe
        tB6M7nYLwXQw1wLmT/SPozbILhogsKoHsX+MhR7rZJBvGI1lYP0g0MPywwCp6JTcsXBHzQ5dkAf
        Y3ryQLZQHpSog3E3J
X-Received: by 2002:a17:902:a515:: with SMTP id s21mr26753046plq.192.1593862428097;
        Sat, 04 Jul 2020 04:33:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0K4ul/+ya1hBFl7f4gxJwUZBehZNesHyGf1bbzBMtCiOpFmsnFFSkDnlXDOVgqHCF/Oj8fA==
X-Received: by 2002:a17:902:a515:: with SMTP id s21mr26753021plq.192.1593862427886;
        Sat, 04 Jul 2020 04:33:47 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id np5sm13817593pjb.43.2020.07.04.04.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2020 04:33:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4DA2B1804A8; Sat,  4 Jul 2020 13:33:42 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        cake@lists.bufferbloat.net, Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>
Subject: Re: [PATCH net v3] sched: consistently handle layer3 header accesses in the presence of VLANs
In-Reply-To: <ada37763-16cd-7b51-f9ce-41e8d313bf96@gmail.com>
References: <20200703202643.12919-1-toke@redhat.com> <ada37763-16cd-7b51-f9ce-41e8d313bf96@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 04 Jul 2020 13:33:42 +0200
Message-ID: <878sfzms4p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita <toshiaki.makita1@gmail.com> writes:

> On 2020/07/04 5:26, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> ...
>> +/* A getter for the SKB protocol field which will handle VLAN tags cons=
istently
>> + * whether VLAN acceleration is enabled or not.
>> + */
>> +static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_=
vlan)
>> +{
>> +	unsigned int offset =3D skb_mac_offset(skb) + sizeof(struct ethhdr);
>> +	__be16 proto =3D skb->protocol;
>> +
>> +	if (!skip_vlan)
>> +		/* VLAN acceleration strips the VLAN header from the skb and
>> +		 * moves it to skb->vlan_proto
>> +		 */
>> +		return skb_vlan_tag_present(skb) ? skb->vlan_proto : proto;
>> +
>> +	while (eth_type_vlan(proto)) {
>> +		struct vlan_hdr vhdr, *vh;
>> +
>> +		vh =3D skb_header_pointer(skb, offset, sizeof(vhdr), &vhdr);
>> +		if (!vh)
>> +			break;
>> +
>> +		proto =3D vh->h_vlan_encapsulated_proto;
>> +		offset +=3D sizeof(vhdr);
>> +	}
>
> Why don't you use __vlan_get_protocol() here? It looks quite similar.
> Is there any problem with using that?

TBH, I completely missed that helper. It seems to have side effects,
though (pskb_may_pull()), which is one of the things the original patch
to sch_cake that initiated all of this was trying to avoid.

I guess I could just fix that, though, and switch __vlan_get_protocol()
over to using skb_header_pointer(). Will send a follow-up to do that.

Any opinion on whether it's a good idea to limit the max parse depth
while I'm at it (see Daniel's reply)?

-Toke

