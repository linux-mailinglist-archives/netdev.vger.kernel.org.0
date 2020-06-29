Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A010320D774
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732799AbgF2TaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:30:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21565 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732679AbgF2TaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593459003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z6+oaXja9HYNA11D8Y9elA5ILqWARmH2B/IS+reKTJ4=;
        b=cg+sRQp35lVu+lgV3/K7SZevPzgoOj9RIu8jFAcvlSmhUN5AMGH1lITgddZoHwsuPte2hz
        VlHXUFDqSzBMPcWmwTQbcad8c7lMPSGUQelc9S6kdJLIcksOYf376DuQpSMNie/P/0crjB
        e6YccVzyYuC7fDuzwA1xi1TvXzN/llU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-4Z-W0ZT4P1qE24rKjqm3kA-1; Mon, 29 Jun 2020 06:27:31 -0400
X-MC-Unique: 4Z-W0ZT4P1qE24rKjqm3kA-1
Received: by mail-qv1-f70.google.com with SMTP id g17so9744824qvw.0
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 03:27:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Z6+oaXja9HYNA11D8Y9elA5ILqWARmH2B/IS+reKTJ4=;
        b=U0quJmNt+KLkNCX9M2mH8MgbmVZhAneI4OvOsEq9TS6lLwcbQhz9YvhbxClyXZ2Bxy
         c123sR6C2wubcEodtE75ElzL4Ebtep5F7TDwtVybFG7oaH59b5d0ChNxF621E1ZvyPUy
         Gmjn2mh3NuwTHsSWD61lJ+fIBBM5JOKFyxwg5abdmaB6MeeLxrTC0RDu4Gs8BOcDKHBL
         RgHafVb3kxvwYp9/jok+sTPN7JPquqaudcPbNU02/VPegxmR5C2yui3oeb5PZfWANclv
         Nyjircp+xzd9SNuEFmoOmZANrCCEU/pdev8Mn4X47bL3408OnPm9z+6hkntsy/Z6yyAS
         wPZA==
X-Gm-Message-State: AOAM533zaSapKrVKfvVrBEXIHD/O/3cERQ2P0r1MMOz5tTr2vjsyg17P
        ZvgGhD7hCkt8Gy7GC7fhv9UvOczNqM6Q4lNYptvKONgfOQkQRvPIelv+CeeAhPM4VzlN0fiixX4
        CuyVgntAR388uO0Un
X-Received: by 2002:a37:58c7:: with SMTP id m190mr14610523qkb.265.1593426450264;
        Mon, 29 Jun 2020 03:27:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmy/bG4Pg09Mn1EgRJbvvGviGUF7K/UsQIiuG7K5ejVVvqgIpuZqmUtdT3N2oGlbmIw1r+iQ==
X-Received: by 2002:a37:58c7:: with SMTP id m190mr14610504qkb.265.1593426449922;
        Mon, 29 Jun 2020 03:27:29 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s128sm3829995qkd.108.2020.06.29.03.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 03:27:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B7D8D1808CF; Mon, 29 Jun 2020 12:27:27 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     cake@lists.bufferbloat.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [Cake] [PATCH net-next 1/5] sch_cake: fix IP protocol handling in the presence of VLAN tags
In-Reply-To: <ee1936f7382461fda0e3e7f03f7dd12cf506891c.camel@redhat.com>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk> <159308610390.190211.17831843954243284203.stgit@toke.dk> <20200625.122945.321093402617646704.davem@davemloft.net> <87k0zuj50u.fsf@toke.dk> <240fc14da96a6212a98dd9ef43b4777a9f28f250.camel@redhat.com> <87h7uyhtuz.fsf@toke.dk> <ee1936f7382461fda0e3e7f03f7dd12cf506891c.camel@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 29 Jun 2020 12:27:27 +0200
Message-ID: <87zh8mgoa8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Davide Caratti <dcaratti@redhat.com> writes:

> hi Toke,
>
> thanks for answering.
>
> On Fri, 2020-06-26 at 14:52 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Davide Caratti <dcaratti@redhat.com> writes:
>
> [...]
>
>> >=20
>> > >  I guess I can trying going through them all and figuring out if
>> > > there's a more generic solution.
>> >=20
>> > For sch_cake, I think that the qdisc shouldn't look at the IP header w=
hen
>> > it schedules packets having a VLAN tag.
>> >=20
>> > Probably, when tc_skb_protocol() returns ETH_P_8021Q or ETH_P_8021AD, =
we
>> > should look at the VLAN priority (PCP) bits (and that's something that
>> > cake doesn't do currently - but I have a small patch in my stash that
>> > implements this: please let me know if you are interested in seeing it=
 :)
>> > ).
>> >=20
>> > Then, to ensure that the IP precedence is respected, even with differe=
nt
>> > VLAN tags, users should explicitly configure TC filters that "map" the
>> > DSCP value to a PCP value. This would ensure that configured priority =
is
>> > respected by the scheduler, and would also be flexible enough to allow
>> > different "mappings".
>>=20
>> I think you have this the wrong way around :)
>>=20
>> I.e., classifying based on VLAN priority is even more esoteric than
>> using diffserv markings,
>
> is it so uncommon? I knew that almost every wifi card did something
> similar with 802.11 'access categories'. More generally, I'm not sure if
> it's ok to ignore any QoS information present in the L2 header. Anyway,
>
>> so that should not be the default. Making it
>> the default would also make the behaviour change for the same traffic if
>> there's a VLAN tag present, which is bound to confuse people. I suppose
>> it could be an option, but not really sure that's needed, since as you
>> say you could just implement it with your own TC filters...
>
> you caught me :) ,
>
> I wrote that patch in my stash to fix cake on my home router, where voice
> and data are encapsulated in IP over PPPoE over VLANs, and different
> services go over different VLAN ids (one VLAN dedicated for voice, the
> other one for data) [1]. The quickest thing I did was: to prioritize
> packets having VLAN id equal to 1035.
>
> Now that I look at cake code again (where again means: after almost 1
> year) it would be probably better to assign skb->priority using flower +
> act_skbedit, and then prioritize in the qdisc: if I read the code well,
> this would avoid voice and data falling into the same traffic class (that
> was my original problem).
>
> please note: I didn't try this patch - but I think that even with this
> code I would have voice and data mixed together, because there is PPPoE
> between VLAN and IP.
>
>> > Sure, my proposal does not cover the problem of mangling the CE bit
>> > inside VLAN-tagged packets, i.e. if we should understand if qdiscs
>> > should allow it or not.
>>=20
>> Hmm, yeah, that's the rub, isn't it? I think this is related to this
>> commit, which first introduced tc_skb_protocol():
>>=20
>> d8b9605d2697 ("net: sched: fix skb->protocol use in case of accelerated =
vlan path")
>>=20
>> That commit at least made the behaviour consistent across
>> accelerated/non-accelerated VLANs. However, the patch description
>> asserts that 'tc code .. expects vlan protocol type [in skb->protocol]'.
>> Looking at the various callers, I'm not actually sure that's true, in
>> the sense that most of the callers don't handle VLAN ethertypes at all,
>> but expects to find an IP header. This is the case for at least:
>>=20
>> - act_ctinfo
>> - act_skbedit
>> - cls_flow
>> - em_ipset
>> - em_ipt
>> - sch_cake
>> - sch_dsmark
>
> sure, I'm not saying it's not possible to look inside IP headers. What I
> understood from Cong's replies [2], and he sort-of convinced me, was: when
> I have IP and one or more VLAN tags, no matter whether it is accelerated
> or not, it should be sufficient to access the IP header daisy-chaining
> 'act_vlan pop actions' -> access to the IP header -> ' act_vlan push
> actions (in the reversed order).
>
> oh well, that's still not sufficient in my home router because of PPPoE. I
> should practice with cls_bpf more seriously :-)=20
>
> or write act_pppoe.c :D
>
>> In fact the only caller that explicitly handles a VLAN ethertype seems
>> to be act_csum; and that handles it in a way that also just skips the
>> VLAN headers, albeit by skb_pull()'ing the header.
>
>
>> cls_api, em_meta and sch_teql don't explicitly handle it; but returning
>> the VLAN ethertypes to those does seem to make sense, since they just
>> pass the value somewhere else.
>>=20
>> So my suggestion would be to add a new helper that skips the VLAN tags
>> and finds the L3 ethertype (i.e., basically cake_skb_proto() as
>> introduced in this patch), then switch all the callers listed above, as
>> well as the INET_ECN_set_ce() over to using that. Maybe something like
>> 'skb_l3_protocol()' which could go into skbuff.h itself, so the ECN code
>> can also find it?
>
> for setting the CE bit, that's understandable - in one way or the other,
> the behaviour should be made consistent.
>
>> Any objections to this? It's not actually clear to me how the discussion
>> you quoted above landed; but this will at least make things consistent
>> across all the different actions/etc.
>
> well, it just didn't "land". But I agree, inconsistency here can make some
> TC configurations "unreliable" (i.e., they don't do the job they were
> configured for).

Right, I'll send a patch to try to make all this consistent :)

-Toke

