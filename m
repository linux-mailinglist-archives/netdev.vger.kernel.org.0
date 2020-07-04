Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DF2214529
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 13:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgGDL2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 07:28:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32643 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726452AbgGDL2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 07:28:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593862130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c1wCfKnVDpe0dEjK4URgb65tlwRZLWw1AKcquMUamB0=;
        b=f9EpCgzGs5UcHePhiW357+ViIDa6cDXAzUtOMkJKGlxuI25/1pX4eP1CKIccZN55w+EBOC
        kUrTdFGMqdNQ4q2vMGf/jTwQpd8FlOb7cs22z3mEtfUqySC1UTw1ykO5lviTxFISSBJxoJ
        1yn4DW6gMBBWoQFAFn5myMjJV51P7C4=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-RP2uFLCmNT2X5wPayuvymg-1; Sat, 04 Jul 2020 07:28:48 -0400
X-MC-Unique: RP2uFLCmNT2X5wPayuvymg-1
Received: by mail-pg1-f200.google.com with SMTP id u16so25241788pgj.17
        for <netdev@vger.kernel.org>; Sat, 04 Jul 2020 04:28:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=c1wCfKnVDpe0dEjK4URgb65tlwRZLWw1AKcquMUamB0=;
        b=Emuu4i+N7jryJSSv7rHII+Z2XZRnzwReN/B69dMY5YisaFCTKRLi72TTmw9daLp1EB
         pe9nM8PK/rh4U3aNHCtBGanneGQfeHUM1OfxXL4w3UZBDwx2gIKqItUaXC0caCkbXtSa
         jCS1ANbaMtEcZ47vIWwdUikjC8eDwDOV5KXUJPRXUbq5FMDRAHUu9HIAjauUltsCWRRF
         ARYsh2K5XJ2OLjWGb9BVs9uqeje+79mRkJG+yekyLAOnWf8e/lgfrJBSTbBNqq86cSpY
         8e4R2meVMDDdUp+s2MEzWPaKKixFIEu0jE8OcJJRbpQrDUXUwWZQtm/RjnNt85fAiwqh
         5kEg==
X-Gm-Message-State: AOAM532ioOYw8vMu35I1oi4xr7T7/pqHqhVZCgGZ+N9EWRWxo0XMscWF
        2yhmAq8qnlRpllWcsqPS1PGoA+uGlOgPD23q02Pn/vEGWLXp6HJTnc/lVgxW+m20MZKC1e5diRq
        lRDiq4ofmrl/XQ8On
X-Received: by 2002:a17:90b:b0a:: with SMTP id bf10mr1420553pjb.220.1593862127376;
        Sat, 04 Jul 2020 04:28:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzz8Mnd3qM4HLLyqY66AiUqb25L+nmbvskZglZl3eBMgbSUyB/rVthDE92BcdVmL9eFJ4UTUQ==
X-Received: by 2002:a17:90b:b0a:: with SMTP id bf10mr1420530pjb.220.1593862127081;
        Sat, 04 Jul 2020 04:28:47 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x22sm14613433pfr.11.2020.07.04.04.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2020 04:28:46 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B16721804A8; Sat,  4 Jul 2020 13:28:40 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        cake@lists.bufferbloat.net, Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>, kafai@fb.com,
        alexei.starovoitov@gmail.com, edumazet@google.com
Subject: Re: [PATCH net v3] sched: consistently handle layer3 header accesses in the presence of VLANs
In-Reply-To: <003ff65d-fc24-cd25-9e46-95e7ca2aa31f@iogearbox.net>
References: <20200703202643.12919-1-toke@redhat.com> <003ff65d-fc24-cd25-9e46-95e7ca2aa31f@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 04 Jul 2020 13:28:40 +0200
Message-ID: <87blkvmsd3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 7/3/20 10:26 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> There are a couple of places in net/sched/ that check skb->protocol and =
act
>> on the value there. However, in the presence of VLAN tags, the value sto=
red
>> in skb->protocol can be inconsistent based on whether VLAN acceleration =
is
>> enabled. The commit quoted in the Fixes tag below fixed the users of
>> skb->protocol to use a helper that will always see the VLAN ethertype.
>>=20
>> However, most of the callers don't actually handle the VLAN ethertype, b=
ut
>> expect to find the IP header type in the protocol field. This means that
>> things like changing the ECN field, or parsing diffserv values, stops
>> working if there's a VLAN tag, or if there are multiple nested VLAN
>> tags (QinQ).
>>=20
>> To fix this, change the helper to take an argument that indicates whether
>> the caller wants to skip the VLAN tags or not. When skipping VLAN tags, =
we
>> make sure to skip all of them, so behaviour is consistent even in QinQ
>> mode.
>>=20
>> To make the helper usable from the ECN code, move it to if_vlan.h instead
>> of pkt_sched.h.
>>=20
>> v3:
>> - Remove empty lines
>> - Move vlan variable definitions inside loop in skb_protocol()
>> - Also use skb_protocol() helper in IP{,6}_ECN_decapsulate() and
>>    bpf_skb_ecn_set_ce()
>>=20
>> v2:
>> - Use eth_type_vlan() helper in skb_protocol()
>> - Also fix code that reads skb->protocol directly
>> - Change a couple of 'if/else if' statements to switch constructs to avo=
id
>>    calling the helper twice
>>=20
>> Reported-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
>> Fixes: d8b9605d2697 ("net: sched: fix skb->protocol use in case of accel=
erated vlan path")
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>   include/linux/if_vlan.h  | 28 ++++++++++++++++++++++++++++
>>   include/net/inet_ecn.h   | 25 +++++++++++++++++--------
>>   include/net/pkt_sched.h  | 11 -----------
>>   net/core/filter.c        | 10 +++++++---
>>   net/sched/act_connmark.c |  9 ++++++---
>>   net/sched/act_csum.c     |  2 +-
>>   net/sched/act_ct.c       |  9 ++++-----
>>   net/sched/act_ctinfo.c   |  9 ++++++---
>>   net/sched/act_mpls.c     |  2 +-
>>   net/sched/act_skbedit.c  |  2 +-
>>   net/sched/cls_api.c      |  2 +-
>>   net/sched/cls_flow.c     |  8 ++++----
>>   net/sched/cls_flower.c   |  2 +-
>>   net/sched/em_ipset.c     |  2 +-
>>   net/sched/em_ipt.c       |  2 +-
>>   net/sched/em_meta.c      |  2 +-
>>   net/sched/sch_cake.c     |  4 ++--
>>   net/sched/sch_dsmark.c   |  6 +++---
>>   net/sched/sch_teql.c     |  2 +-
>>   19 files changed, 86 insertions(+), 51 deletions(-)
>>=20
>> diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
>> index b05e855f1ddd..427a5b8597c2 100644
>> --- a/include/linux/if_vlan.h
>> +++ b/include/linux/if_vlan.h
>> @@ -308,6 +308,34 @@ static inline bool eth_type_vlan(__be16 ethertype)
>>   	}
>>   }
>>=20=20=20
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
> Hm, why is the while loop 'unbounded'? Does it even make sense to have
> a packet with hundreds of vlan hdrs in there what you'd end up
> walking? What if an attacker crafts a max sized packet with only
> vlan_hdr forcing exorbitant looping in fast-path here (e.g. via
> af_packet)?

Hmm, I guess you're right that could theoretically happen. But on the
other hand, a lot of drivers seem to be cheerfully calling
vlan_get_protocol() on incoming packets, which doesn't have a limit on
the depth either.

I guess I could add a depth limit, but in that case I suppose that
should also be added to vlan_get_protocol() (or the two should be
consolidated). WDYT?

> Did you validate that skb_mac_offset() is always valid for the
> call-sites you converted? (We have a skb_mac_header_was_set() test to
> probe for whether skb->mac_header is set to ~0.)

Not extensively; I kinda assumed it would always be valid at those call
sites, since the callers go on to call ip_hdr() or something similar
right afterwards.

I guess Toshiaki's suggestion to use vlan_get_protocol() could be a way
around this, as that seems to deal with skb->mac_len being 0.

-Toke

