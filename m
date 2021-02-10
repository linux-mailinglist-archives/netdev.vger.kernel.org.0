Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01261316474
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhBJK7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:59:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhBJKzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:55:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612954437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QNdS4uaIcL7T8BO9ZPW9arckpg/ta/zEzSVdZa8TFqs=;
        b=cdaHsWvAFYW1AEhOhkTHnXN7dHpa9wL3FV6BM6p3r3K84QRuLPk+aE+H42ETIdXF+Ney9t
        aXQ/q9iRNHUI+PZRzUICpq6be1Gt96GkIGpDCa4I5KEDC2GyGv9i0QSbSEEX3XyeBc5yt1
        cjuYsxep85emjhC893L0R972A/foEJc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-VKw1MGZKNPCKCCUY1OuUvg-1; Wed, 10 Feb 2021 05:53:55 -0500
X-MC-Unique: VKw1MGZKNPCKCCUY1OuUvg-1
Received: by mail-ed1-f69.google.com with SMTP id x13so2209832edi.7
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 02:53:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=QNdS4uaIcL7T8BO9ZPW9arckpg/ta/zEzSVdZa8TFqs=;
        b=NlmLg/ytg48rj1Nt2Cw9cXp0rVreYXdRpsz5/Tge5NClpkjCSkNGQgT6MOELeejQeg
         pSnchD11QTLsmoz7OT192jzTUtAx0fhnvb41pYaWNX8BgDVwSFxb1x4SIIC6RJOlwatn
         SkqsS8TNJhHZTBKzq1+UdU9TQ4cUu7VAIpN+rL9RGBsrSGcDgnEv7LbaVMTODuPJfkHs
         0GFmt75VhLes11bremudiaHo7GvIPRwMFEY2JMfcw8Ju5c4+WWOTzLXvkwL7tXhcTBA6
         56Bn0QXX3J6dvOazZH+/3wnqijQULB71iWeVqgADgpMuhOBdZe+yQSmkPOFjoTx8lhMD
         KlVQ==
X-Gm-Message-State: AOAM532JtmWZWdRL5cJMhN5OtuJR2SM7Lpva3slK++osqZkuEL2wHUcc
        Tf52xBN/iKrDZe3R4YPOaH0gbO52vpzKuxUDoOgbkyHiqXrA9TA+iN4U8n7s4tS0lldQfe4Zy+r
        HbyzGn2IRcO423igg
X-Received: by 2002:a17:906:854f:: with SMTP id h15mr2314404ejy.2.1612954434536;
        Wed, 10 Feb 2021 02:53:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9kxjrkvs0lMRtZKb7eZ5+PmgxP+XOmQ4alp1vZxt2LBpsa3XZxhu0QXOHuBKYBoklVFBcjg==
X-Received: by 2002:a17:906:854f:: with SMTP id h15mr2314389ejy.2.1612954434350;
        Wed, 10 Feb 2021 02:53:54 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id c6sm694540edx.62.2021.02.10.02.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 02:53:53 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7B6561804EE; Wed, 10 Feb 2021 11:53:53 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, Marek Majtyka <alardam@gmail.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, David Ahern <dsahern@gmail.com>,
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
In-Reply-To: <20210203090232.4a259958@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
 <20201207230755.GB27205@ranger.igk.intel.com>
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
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 10 Feb 2021 11:53:53 +0100
Message-ID: <874kikry66.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 3 Feb 2021 13:50:59 +0100 Marek Majtyka wrote:
>> On Tue, Feb 2, 2021 at 8:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
>> > On Tue, 02 Feb 2021 13:05:34 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote:=20=20
>> > > Awesome! And sorry for not replying straight away - I hate it when I
>> > > send out something myself and receive no replies, so I suppose I sho=
uld
>> > > get better at not doing that myself :)
>> > >
>> > > As for the inclusion of the XDP_BASE / XDP_LIMITED_BASE sets (which I
>> > > just realised I didn't reply to), I am fine with defining XDP_BASE a=
s a
>> > > shortcut for TX/ABORTED/PASS/DROP, but think we should skip
>> > > XDP_LIMITED_BASE and instead require all new drivers to implement the
>> > > full XDP_BASE set straight away. As long as we're talking about
>> > > features *implemented* by the driver, at least; i.e., it should stil=
l be
>> > > possible to *deactivate* XDP_TX if you don't want to use the HW
>> > > resources, but I don't think there's much benefit from defining the
>> > > LIMITED_BASE set as a shortcut for this mode...=20=20
>> >
>> > I still have mixed feelings about these flags. The first step IMO
>> > should be adding validation tests. I bet^W pray every vendor has
>> > validation tests but since they are not unified we don't know what
>> > level of interoperability we're achieving in practice. That doesn't
>> > matter for trivial feature like base actions, but we'll inevitably
>> > move on to defining more advanced capabilities and the question of
>> > "what supporting X actually mean" will come up (3 years later, when
>> > we don't remember ourselves).=20=20
>>=20
>> I am a bit confused now. Did you mean validation tests of those XDP
>> flags, which I am working on or some other validation tests?
>> What should these tests verify? Can you please elaborate more on the
>> topic, please - just a few sentences how are you see it?
>
> Conformance tests can be written for all features, whether they have=20
> an explicit capability in the uAPI or not. But for those that do IMO
> the tests should be required.
>
> Let me give you an example. This set adds a bit that says Intel NICs=20
> can do XDP_TX and XDP_REDIRECT, yet we both know of the Tx queue
> shenanigans. So can i40e do XDP_REDIRECT or can it not?
>
> If we have exhaustive conformance tests we can confidently answer that
> question. And the answer may not be "yes" or "no", it may actually be
> "we need more options because many implementations fall in between".
>
> I think readable (IOW not written in some insane DSL) tests can also=20
> be useful for users who want to check which features their program /
> deployment will require.

While I do agree that that kind of conformance test would be great, I
don't think it has to hold up this series (the perfect being the enemy
of the good, and all that). We have a real problem today that userspace
can't tell if a given driver implements, say, XDP_REDIRECT, and so
people try to use it and spend days wondering which black hole their
packets disappear into. And for things like container migration we need
to be able to predict whether a given host supports a feature *before*
we start the migration and try to use it.

I view the feature flags as a list of features *implemented* by the
driver. Which should be pretty static in a given kernel, but may be
different than the features currently *enabled* on a given system (due
to, e.g., the TX queue stuff).

The simple way to expose the latter would be to just have a second set
of flags indicating the current configured state; and for that I guess
we should at least agree what "enabled" means; and a conformance test
would be a way to do this, of course.

I don't see why we can't do this in stages, though; start with the first
set of flags ('implemented'), move on to the second one ('enabled'), and
then to things like making the kernel react to the flags by rejecting
insertion into devmaps for invalid interfaces...

-Toke

