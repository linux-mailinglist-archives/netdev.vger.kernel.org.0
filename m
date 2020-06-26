Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA08A20B1BF
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 14:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgFZMwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 08:52:43 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60722 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725853AbgFZMwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 08:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593175960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/iHDgfiY8TDh3EPNTgzupA4JBUtTDmY+m7kSnSwNTKo=;
        b=XP5O3TUQRcXq8uAz8w6OctmhtBKy4ao+jMc5ju7JqhNcqZS6Q+YMkoWGekTv3k9q7ak7MD
        +5TRJXhL2mmm46fZwfSi2CS9AkKqRc3+SZMdlVtDsFKQPfP8ekyKlQl/NLMe9zYDcocqv7
        PS1za3A+1S8WPT+ouhT98jQEjx7Lhtc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-Bq4NGyqJOKGROgvZoNfyrw-1; Fri, 26 Jun 2020 08:52:38 -0400
X-MC-Unique: Bq4NGyqJOKGROgvZoNfyrw-1
Received: by mail-ed1-f72.google.com with SMTP id m12so6229714edv.3
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 05:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/iHDgfiY8TDh3EPNTgzupA4JBUtTDmY+m7kSnSwNTKo=;
        b=JCkH2eSAkUqdNSbsCpPTmuow3DjCem1wpy+N/l+d+3oD2G74Gcfm5hrdJO9dzgduc6
         KMZ3QITIiKm1lrZtX1v5r5Wrh7m1CBlfd+dPb5Xz+/2PhMclM7iZVJ6NGn+uE7KUZdkY
         r9JLGX04tZJIpfD1GtQRREeY1Ps8IFJbrZmdf5kYGtlZR0igtG1PW4BMKGgHrADVr0DK
         XKTmhlPgjfOqJW1NMfFkDmU3cJqwIf9F4siIoZCqrWxhtejLBlIqgpUcJUsOnLlfuVm6
         n4Mumyh3YbKFhXM80OHUOZrNnkiRxP/FYxdRx2SM90sk5C59zHGQCZjQuhZcQpgGsG/E
         XItA==
X-Gm-Message-State: AOAM530Apqy0kKM20+UgV3GhoW9kH4BRZf3XVIgtdctNarWhYv0aIHL6
        L2lK9RsI8mftwr4aTEHFyKqnQPRgz8A2fTwDpgPaKWvhuveEmQNZuV0YlGteZ3Fh2IQJYcLY05v
        qO5tlADM3a7SgbWU8
X-Received: by 2002:a17:906:6a4f:: with SMTP id n15mr2350260ejs.378.1593175957584;
        Fri, 26 Jun 2020 05:52:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3UPQSYD18e7LtAU1xQDYajPQGgJdas4L4X0+hY7qoM0GoqUwJwTAhxcLFtToqZitlTRnD7w==
X-Received: by 2002:a17:906:6a4f:: with SMTP id n15mr2350245ejs.378.1593175957307;
        Fri, 26 Jun 2020 05:52:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o17sm10814176ejb.105.2020.06.26.05.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 05:52:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 116EC1808CF; Fri, 26 Jun 2020 14:52:36 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     cake@lists.bufferbloat.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [Cake] [PATCH net-next 1/5] sch_cake: fix IP protocol handling in the presence of VLAN tags
In-Reply-To: <240fc14da96a6212a98dd9ef43b4777a9f28f250.camel@redhat.com>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk> <159308610390.190211.17831843954243284203.stgit@toke.dk> <20200625.122945.321093402617646704.davem@davemloft.net> <87k0zuj50u.fsf@toke.dk> <240fc14da96a6212a98dd9ef43b4777a9f28f250.camel@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 26 Jun 2020 14:52:36 +0200
Message-ID: <87h7uyhtuz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Davide Caratti <dcaratti@redhat.com> writes:

> hello,
>
> my 2 cents:
>
> On Thu, 2020-06-25 at 21:53 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> I think it depends a little on the use case; some callers actually care
>> about the VLAN tags themselves and handle that specially (e.g.,
>> act_csum).
>
> I remember taht something similar was discussed about 1 year ago [1].

Ah, thank you for the pointer!

>> Whereas others (e.g., sch_dsmark) probably will have the same
>> issue.
>
> I'd say that the issue "propagates" to all qdiscs that mangle the ECN-CE
> bit (i.e., calling INET_ECN_set_ce() [2]), most notably all the RED
> variants and "codel/fq_codel".

Yeah, I think we should fix INET_ECN_set_ce() instead of re-implementing
it in CAKE. See below, though.

>>  I guess I can trying going through them all and figuring out if
>> there's a more generic solution.
>
> For sch_cake, I think that the qdisc shouldn't look at the IP header when
> it schedules packets having a VLAN tag.
>
> Probably, when tc_skb_protocol() returns ETH_P_8021Q or ETH_P_8021AD, we
> should look at the VLAN priority (PCP) bits (and that's something that
> cake doesn't do currently - but I have a small patch in my stash that
> implements this: please let me know if you are interested in seeing it :)
> ).
>
> Then, to ensure that the IP precedence is respected, even with different
> VLAN tags, users should explicitly configure TC filters that "map" the
> DSCP value to a PCP value. This would ensure that configured priority is
> respected by the scheduler, and would also be flexible enough to allow
> different "mappings".

I think you have this the wrong way around :)

I.e., classifying based on VLAN priority is even more esoteric than
using diffserv markings, so that should not be the default. Making it
the default would also make the behaviour change for the same traffic if
there's a VLAN tag present, which is bound to confuse people. I suppose
it could be an option, but not really sure that's needed, since as you
say you could just implement it with your own TC filters...

> Sure, my proposal does not cover the problem of mangling the CE bit
> inside VLAN-tagged packets, i.e. if we should understand if qdiscs
> should allow it or not.

Hmm, yeah, that's the rub, isn't it? I think this is related to this
commit, which first introduced tc_skb_protocol():

d8b9605d2697 ("net: sched: fix skb->protocol use in case of accelerated vla=
n path")

That commit at least made the behaviour consistent across
accelerated/non-accelerated VLANs. However, the patch description
asserts that 'tc code .. expects vlan protocol type [in skb->protocol]'.
Looking at the various callers, I'm not actually sure that's true, in
the sense that most of the callers don't handle VLAN ethertypes at all,
but expects to find an IP header. This is the case for at least:

- act_ctinfo
- act_skbedit
- cls_flow
- em_ipset
- em_ipt
- sch_cake
- sch_dsmark

In fact the only caller that explicitly handles a VLAN ethertype seems
to be act_csum; and that handles it in a way that also just skips the
VLAN headers, albeit by skb_pull()'ing the header.

cls_api, em_meta and sch_teql don't explicitly handle it; but returning
the VLAN ethertypes to those does seem to make sense, since they just
pass the value somewhere else.

So my suggestion would be to add a new helper that skips the VLAN tags
and finds the L3 ethertype (i.e., basically cake_skb_proto() as
introduced in this patch), then switch all the callers listed above, as
well as the INET_ECN_set_ce() over to using that. Maybe something like
'skb_l3_protocol()' which could go into skbuff.h itself, so the ECN code
can also find it?

Any objections to this? It's not actually clear to me how the discussion
you quoted above landed; but this will at least make things consistent
across all the different actions/etc.

Adding in Jiri and Jamal as well since they were involved in the patch I
quoted above.

-Toke

