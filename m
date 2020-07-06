Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092322155DF
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 12:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgGFKxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 06:53:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29671 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728530AbgGFKxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 06:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594032802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NNn4lPIzDwTEM2THr/KH6JkSvVcflXvGyR2W59aQaSk=;
        b=di6FouQwaf6KaYYfphQ0uFIffbannccAMY1nUdYG5JhOLR7cm2Baez+lIYb6c//u8HnElu
        UjMuSvGk75eHosvN8yfkvHrAnu2uyx2ohOxS2CBkk+H1dBRQvkEZDbAFx1yQqHZWR5+P1Q
        HInNYhGkjUHh+VOsQnoSUaUTe95GEDo=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-q4GWfPdCOuW16ZvZb91bww-1; Mon, 06 Jul 2020 06:53:19 -0400
X-MC-Unique: q4GWfPdCOuW16ZvZb91bww-1
Received: by mail-pl1-f200.google.com with SMTP id x1so893986pla.10
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 03:53:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=NNn4lPIzDwTEM2THr/KH6JkSvVcflXvGyR2W59aQaSk=;
        b=VKeMSMhrIyPEs5SxqKqCQur1rXSrSwJ8ZmXUZbSjJLCONsyTMXAcUqU2F85eauwmRp
         MeoYa447/wUw+Gq/NQ9FdJAFY2p7G/LvI1UsT3qIkslg+C4rwvOGH+1Q3t/rrQZp9zRh
         Quk7bts7lRF2Wd9j5RQOCBPUBn94/63r8aDlvrp2/mUuU+GlxnKsCamdqXRn8pzKM2bj
         RYJG1bk1syg4vQuwvnAWjpt8AjDwtrL0u3IzACT7kVD/Q5n3ZqlsLc64UkGVX425kuWn
         WEI+rjexk6jz5X0Y5hhK73rIymw+1TigVGA/h9tx0i3S4cIJoVkLJC6G03xXbG1r4XIt
         avvQ==
X-Gm-Message-State: AOAM533fUXy0M+9wjWkkwWwn2dijgjYVqBGutEqHxg7Bqbbo4gyU7fmS
        RGLYgEMT6Sa2kVjINCoJWFPXx0PcnKTQ/LwV6tUzO65smPLH8UiMeWBHnCDn/dUNQYmFxka6nsd
        Jyms6mQe8D0VWm8xL
X-Received: by 2002:a63:e50a:: with SMTP id r10mr39164231pgh.285.1594032798189;
        Mon, 06 Jul 2020 03:53:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxn2BPP8PHjBIuh7k4X2AXIL7g+wnqUI3sZsXOl6bg0fevLnkJSHbnf7UrOH01FWX607jY0EA==
X-Received: by 2002:a63:e50a:: with SMTP id r10mr39164213pgh.285.1594032797866;
        Mon, 06 Jul 2020 03:53:17 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k4sm17925318pjt.16.2020.07.06.03.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 03:53:17 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 748F91804EB; Mon,  6 Jul 2020 12:53:12 +0200 (CEST)
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
In-Reply-To: <b62fcd67-1b0a-ab7f-850d-22e62faf3a23@gmail.com>
References: <20200703202643.12919-1-toke@redhat.com> <ada37763-16cd-7b51-f9ce-41e8d313bf96@gmail.com> <878sfzms4p.fsf@toke.dk> <b62fcd67-1b0a-ab7f-850d-22e62faf3a23@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 06 Jul 2020 12:53:12 +0200
Message-ID: <875zb0ncdj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita <toshiaki.makita1@gmail.com> writes:

> On 2020/07/04 20:33, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>> On 2020/07/04 5:26, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> ...
>>>> +/* A getter for the SKB protocol field which will handle VLAN tags co=
nsistently
>>>> + * whether VLAN acceleration is enabled or not.
>>>> + */
>>>> +static inline __be16 skb_protocol(const struct sk_buff *skb, bool ski=
p_vlan)
>>>> +{
>>>> +	unsigned int offset =3D skb_mac_offset(skb) + sizeof(struct ethhdr);
>>>> +	__be16 proto =3D skb->protocol;
>>>> +
>>>> +	if (!skip_vlan)
>>>> +		/* VLAN acceleration strips the VLAN header from the skb and
>>>> +		 * moves it to skb->vlan_proto
>>>> +		 */
>>>> +		return skb_vlan_tag_present(skb) ? skb->vlan_proto : proto;
>>>> +
>>>> +	while (eth_type_vlan(proto)) {
>>>> +		struct vlan_hdr vhdr, *vh;
>>>> +
>>>> +		vh =3D skb_header_pointer(skb, offset, sizeof(vhdr), &vhdr);
>>>> +		if (!vh)
>>>> +			break;
>>>> +
>>>> +		proto =3D vh->h_vlan_encapsulated_proto;
>>>> +		offset +=3D sizeof(vhdr);
>>>> +	}
>>>
>>> Why don't you use __vlan_get_protocol() here? It looks quite similar.
>>> Is there any problem with using that?
>>=20
>> TBH, I completely missed that helper. It seems to have side effects,
>> though (pskb_may_pull()), which is one of the things the original patch
>> to sch_cake that initiated all of this was trying to avoid.
>
> Sorry for not completely following the discussion...
> Pulling data is wrong for cake or other schedulers?

This was not explicit in the current thread, but the reason I started
looking into this in the first place was a pull request on the
out-of-tree version of sch_cake that noticed that there are drivers that
will allocate SKBs in such a way that accessing the packet header causes
it to be reallocated: https://github.com/dtaht/sch_cake/pull/136

I'm not entirely positive that this applies to just reading the header
through pskb_may_pull(), or if it was only on skb_try_make_writable();
but in any case it seems to me that it's better for a helper like
__vlan_get_protocol() to not have side effects.

>> I guess I could just fix that, though, and switch __vlan_get_protocol()
>> over to using skb_header_pointer(). Will send a follow-up to do that.
>>=20
>> Any opinion on whether it's a good idea to limit the max parse depth
>> while I'm at it (see Daniel's reply)?
>
> The logic was originally introduced by skb_network_protocol() back in
> v3.10, and I have never heard of security report about that. But yes,
> I guess it potentially can be used for DoS attack.

Right, I'll add the limit as well, then :)

-Toke

