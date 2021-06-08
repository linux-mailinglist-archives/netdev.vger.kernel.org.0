Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4C63A0659
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbhFHVpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:45:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234298AbhFHVpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 17:45:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623188624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UO0J5rCgH7Iumd+lPo8k4Dl2OQ9K2Az34Q2U2WC1yms=;
        b=hdum4UuowKgSdbfhjeKLGKAHVxDijJTXOeOYr4qw6mHIlSbiPJ/WWjXemDveQa1YlSFyuX
        GN2/Ufqkdho7p8W17rA7fqLmg8FLMAYdnG6DLkxPXjzIN92VTchZPlQSzKCkKAeeDFCIPP
        K3Wg1agnQYqvngYXTsqyvsfTuna4sJY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-v7AXNx2oNBi8dy8epcsqpw-1; Tue, 08 Jun 2021 17:43:43 -0400
X-MC-Unique: v7AXNx2oNBi8dy8epcsqpw-1
Received: by mail-ed1-f69.google.com with SMTP id u21-20020aa7d5550000b02903937d876df1so4664122edr.20
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 14:43:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=UO0J5rCgH7Iumd+lPo8k4Dl2OQ9K2Az34Q2U2WC1yms=;
        b=rdRNaQZf+ggC0Lrp8C/X65lRhoN6Jh9C39XIOycX0ssJmG0sv4KtyUVSh1fMkdZAHq
         8ZO/xWhewa0XjwbgYTCB8bLFKhe8QQcxlU+LEvsWUebfA60jfrfV+wNX+L5aLWaTOdzY
         gNuwPCMX66P/jHZLlI5EjrO67G2zdL9qZFnVk2gtIZoK5XDq+g7ncHiN1XhBI1sz1GvC
         wK0EnLVEa9tGyvdsiN8eH4lEfR9EPSq/DzhDcOg0RX3EBy599v/FzwuJQ5h/V0UfaKYg
         L3dXD7pSK7wNZQK4j6ri0cG+QEsv2phdxFVkDkV6eDjmd0Btwh2b10orLRv2q6lSllIB
         5h0A==
X-Gm-Message-State: AOAM533B/Jnfc5MTLNPJSoXCWK+1w2ZNoQaazUHfrEJ+Nqit6zEUyltF
        ABHyqWeHsRuNqa5DPs4u1WcVC83MSUoE3DfcUIBRDqrwGDp0lPlb9rCFGACNw/s3wh+RdkvzTcs
        CjbfUCQ7u+VEIV3mT
X-Received: by 2002:a17:906:34d6:: with SMTP id h22mr25423356ejb.413.1623188622367;
        Tue, 08 Jun 2021 14:43:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz74lYJW7U76qPg3eEYhfqRk0CA1pV0lVlikeR1uu2uLrVEB8Lsoz/4glU3lp6X5rLyb8/SWA==
X-Received: by 2002:a17:906:34d6:: with SMTP id h22mr25423346ejb.413.1623188622228;
        Tue, 08 Jun 2021 14:43:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id bh3sm324394ejb.19.2021.06.08.14.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 14:43:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C1704180723; Tue,  8 Jun 2021 23:43:40 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com
Subject: Re: [PATCH intel-next 2/2] ice: introduce XDP Tx fallback path
In-Reply-To: <20210608121259.GA1971@ranger.igk.intel.com>
References: <20210601113236.42651-1-maciej.fijalkowski@intel.com>
 <20210601113236.42651-3-maciej.fijalkowski@intel.com>
 <87czt5dal0.fsf@toke.dk> <20210608121259.GA1971@ranger.igk.intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 08 Jun 2021 23:43:40 +0200
Message-ID: <87o8cgnib7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Tue, Jun 01, 2021 at 02:38:03PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>>=20
>> > Under rare circumstances there might be a situation where a requirement
>> > of having a XDP Tx queue per core could not be fulfilled and some of t=
he
>> > Tx resources would have to be shared between cores. This yields a need
>> > for placing accesses to xdp_rings array onto critical section protected
>> > by spinlock.
>> >
>> > Design of handling such scenario is to at first find out how many queu=
es
>> > are there that XDP could use. Any number that is not less than the half
>> > of a count of cores of platform is allowed. XDP queue count < cpu count
>> > is signalled via new VSI state ICE_VSI_XDP_FALLBACK which carries the
>> > information further down to Rx rings where new ICE_TX_XDP_LOCKED is set
>> > based on the mentioned VSI state. This ring flag indicates that locking
>> > variants for getting/putting xdp_ring need to be used in fast path.
>> >
>> > For XDP_REDIRECT the impact on standard case (one XDP ring per CPU) can
>> > be reduced a bit by providing a separate ndo_xdp_xmit and swap it at
>> > configuration time. However, due to the fact that net_device_ops struct
>> > is a const, it is not possible to replace a single ndo, so for the
>> > locking variant of ndo_xdp_xmit, whole net_device_ops needs to be
>> > replayed.
>> >
>> > It has an impact on performance (1-2 %) of a non-fallback path as
>> > branches are introduced.
>>=20
>> I generally feel this is the right approach, although the performance
>> impact is a bit unfortunately, obviously. Maybe it could be avoided by
>> the use of static_branch? I.e., keep a global refcount of how many
>> netdevs are using the locked path and only activate the check in the
>> fast path while that refcount is >0?
>
> This would be an ideal solution if we would be able to have it PF-scoped,
> which AFAICT is not possible as static key is per module, right?

Yeah, static_branch basically patches the kernel text when activated
(hence the low overhead), so it's a global switch...

> I checked that before the bank holiday here in Poland and indeed I was not
> observing perf drops. Only thing that is questionable is the fact that a
> single PF would affect all the others that ice driver is serving.
>
> OTOH I see that Jesper acked that work.
>
> Let me play with this a bit more as I'm in the middle of switching my HW
> lab, but I wanted to break the silence over here. I didn't manage to check
> that one fallback path will affect other PFs.
>
> Thanks Toke for that great idea :) any other opinions are more than
> welcome.

You're welcome! :)

-Toke

