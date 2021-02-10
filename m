Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EDC3173B9
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhBJWyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:54:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232279AbhBJWyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 17:54:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612997563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MTOZimiXv3MyLyighqxuqoNvd3oB6X1OJT8JBba17+s=;
        b=f7q1sMwXvBqKp/rDEKHVVat/P/7oqh1tVcl9ttCa7fGtHMa4qFSNeoAwe2fv1aXImZAB1o
        o0UN85zEDy7PvTQfHYDPeijBl3OIan/G9F6gn3gxNaF9Z9QuYtm3wesGK/7e9blQC5Wcas
        TMxipYCCoqdVxXy0By8LmacJa9SiHxs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-fUfRgmW3Pye20kEHh6Qs-w-1; Wed, 10 Feb 2021 17:52:41 -0500
X-MC-Unique: fUfRgmW3Pye20kEHh6Qs-w-1
Received: by mail-ej1-f70.google.com with SMTP id ce9so3796172ejc.17
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:52:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=MTOZimiXv3MyLyighqxuqoNvd3oB6X1OJT8JBba17+s=;
        b=VjKTzVlxnozV0uhp0KZBQSKGWOW2TEKTJVFNa4HpmawEGRwi8YW7e8Ht5rOkG8mjqT
         jwhsLdLxd7Dcil0X9+BT2+AXrJAFBBu0akxHyHUOkSt2W5XutDM3TFDNMv4QQunaqKCj
         dVVKJ7rM3qrVbUdydOxgnGl5khqwjIL9ysEaJMnzTixfppP4cQ7dtfmp9JVEM6mRVpvQ
         SoDZRfCPXrYTOyGkVLmnHTR01t/kAc6ra19LRDTKGomOIAoxzkuMxiBRKHf2KwakKilb
         uJ1MeXeJh+XLwtHIVmNwGGefE8Mox0fthHHL949+6Y/h10EcoWR7q6na/lnhU+g1Z/st
         A0fw==
X-Gm-Message-State: AOAM5310BA+s5oQxrMmbI+/to+gMr7R5J/C1RZEVw3fTScSriyu/bc6L
        IhCFFKC1hqqdP/uh+/t1UIrWbTUNvJPkHM2G00aFT++H5b81I9/Q/E3370KLtdxvbQ07vcU0xgK
        y1Ru9/C0oeybQ9srh
X-Received: by 2002:a17:906:a0c:: with SMTP id w12mr5179870ejf.211.1612997560399;
        Wed, 10 Feb 2021 14:52:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy8nXTYHN0PCcWqPkgUGMEtcSutowI+G41weA+o2ITB6saJfOw+D+6Caievxf13dP+9zOcQRA==
X-Received: by 2002:a17:906:a0c:: with SMTP id w12mr5179858ejf.211.1612997560224;
        Wed, 10 Feb 2021 14:52:40 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id hy24sm2423526ejc.40.2021.02.10.14.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 14:52:39 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 563011804EE; Wed, 10 Feb 2021 23:52:39 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marek Majtyka <alardam@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, hawk@kernel.org,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
In-Reply-To: <20210210103135.38921f85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
 <20201209095454.GA36812@ranger.igk.intel.com>
 <20201209125223.49096d50@carbon>
 <e1573338-17c0-48f4-b4cd-28eeb7ce699a@gmail.com>
 <1e5e044c8382a68a8a547a1892b48fb21d53dbb9.camel@kernel.org>
 <cb6b6f50-7cf1-6519-a87a-6b0750c24029@gmail.com>
 <f4eb614ac91ee7623d13ea77ff3c005f678c512b.camel@kernel.org>
 <d5be0627-6a11-9c1f-8507-cc1a1421dade@gmail.com>
 <6f8c23d4ac60525830399754b4891c12943b63ac.camel@kernel.org>
 <CAAOQfrHN1-oHmbOksDv-BKWv4gDF2zHZ5dTew6R_QTh6s_1abg@mail.gmail.com>
 <87h7mvsr0e.fsf@toke.dk>
 <CAAOQfrHA+-BsikeQzXYcK_32BZMbm54x5p5YhAiBj==uaZvG1w@mail.gmail.com>
 <87bld2smi9.fsf@toke.dk>
 <20210202113456.30cfe21e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAOQfrGqcsn3wu5oxzHYxtE8iK3=gFdTka5HSh5Fe9Hc6HWRWA@mail.gmail.com>
 <20210203090232.4a259958@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <874kikry66.fsf@toke.dk>
 <20210210103135.38921f85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 10 Feb 2021 23:52:39 +0100
Message-ID: <87czx7r0w8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 10 Feb 2021 11:53:53 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >> I am a bit confused now. Did you mean validation tests of those XDP
>> >> flags, which I am working on or some other validation tests?
>> >> What should these tests verify? Can you please elaborate more on the
>> >> topic, please - just a few sentences how are you see it?=20=20
>> >
>> > Conformance tests can be written for all features, whether they have=20
>> > an explicit capability in the uAPI or not. But for those that do IMO
>> > the tests should be required.
>> >
>> > Let me give you an example. This set adds a bit that says Intel NICs=20
>> > can do XDP_TX and XDP_REDIRECT, yet we both know of the Tx queue
>> > shenanigans. So can i40e do XDP_REDIRECT or can it not?
>> >
>> > If we have exhaustive conformance tests we can confidently answer that
>> > question. And the answer may not be "yes" or "no", it may actually be
>> > "we need more options because many implementations fall in between".
>> >
>> > I think readable (IOW not written in some insane DSL) tests can also=20
>> > be useful for users who want to check which features their program /
>> > deployment will require.=20=20
>>=20
>> While I do agree that that kind of conformance test would be great, I
>> don't think it has to hold up this series (the perfect being the enemy
>> of the good, and all that). We have a real problem today that userspace
>> can't tell if a given driver implements, say, XDP_REDIRECT, and so
>> people try to use it and spend days wondering which black hole their
>> packets disappear into. And for things like container migration we need
>> to be able to predict whether a given host supports a feature *before*
>> we start the migration and try to use it.
>
> Unless you have a strong definition of what XDP_REDIRECT means the flag
> itself is not worth much. We're not talking about normal ethtool feature
> flags which are primarily stack-driven, XDP is implemented mostly by
> the driver, each vendor can do their own thing. Maybe I've seen one
> vendor incompatibility too many at my day job to hope for the best...

I'm totally on board with documenting what a feature means. E.g., for
XDP_REDIRECT, whether it's acceptable to fail the redirect in some
situations even when it's active, or if there should always be a
slow-path fallback.

But I disagree that the flag is worthless without it. People are running
into real issues with trying to run XDP_REDIRECT programs on a driver
that doesn't support it at all, and it's incredibly confusing. The
latest example popped up literally yesterday:

https://lore.kernel.org/xdp-newbies/CAM-scZPPeu44FeCPGO=3DQz=3D03CrhhfB1GdJ=
8FNEpPqP_G27c6mQ@mail.gmail.com/

>> I view the feature flags as a list of features *implemented* by the
>> driver. Which should be pretty static in a given kernel, but may be
>> different than the features currently *enabled* on a given system (due
>> to, e.g., the TX queue stuff).
>
> Hm, maybe I'm not being clear enough. The way XDP_REDIRECT (your
> example) is implemented across drivers differs in a meaningful ways.=20
> Hence the need for conformance testing. We don't have a golden SW
> standard to fall back on, like we do with HW offloads.

I'm not disagreeing that we need to harmonise what "implementing a
feature" means. Maybe I'm just not sure what you mean by "conformance
testing"? What would that look like, specifically? A script in selftest
that sets up a redirect between two interfaces that we tell people to
run? Or what? How would you catch, say, that issue where if a machine
has more CPUs than the NIC has TXQs things start falling apart?

> Also IDK why those tests are considered such a huge ask. As I said most
> vendors probably already have them, and so I'd guess do good distros.
> So let's work together.

I guess what I'm afraid of is that this will end up delaying or stalling
a fix for a long-standing issue (which is what I consider this series as
shown by the example above). Maybe you can alleviate that by expanding a
bit on what you mean?

-Toke

