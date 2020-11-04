Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539512A709B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732496AbgKDWfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:35:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732488AbgKDWfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 17:35:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604529332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6qmg4K8tetI9M8iqdDkZ+4lcPzNEbl4E68EXXwLlL98=;
        b=D8RmK36Diz/P7n3QOxbVRbA0jC5BlqROMeSs+ZKoGPS03DwbaItkcvcPnypoGmRepZK8Y6
        ZrblcOLt+hVj9mswGcuj90yvQGEne3JNyYncKola19JbrE6vVqPwSRQAbNDxKn+IyjwE/b
        1VV5YAqmiiYZHKPhK4X5W/RZgQsNxCo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-VSWvQ2lRP06dl8l5_e1Wmw-1; Wed, 04 Nov 2020 17:35:30 -0500
X-MC-Unique: VSWvQ2lRP06dl8l5_e1Wmw-1
Received: by mail-qt1-f197.google.com with SMTP id y14so11319054qtw.19
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 14:35:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6qmg4K8tetI9M8iqdDkZ+4lcPzNEbl4E68EXXwLlL98=;
        b=gv+vCgyLYafJNb3Jon1Nva6cz+UT1Xc4CNDR2PSWZ45v28nFmSguvNFAdatM5Clilx
         3zULr5sq3onSFH/9aQh0D2hCBPMj9Wf2KZ3cFakY7BxlYcsvyE8ICSDaIJx4Gp+Wm4Ry
         /u1yGtW219QcR0G16reCwMNppVtSYZmycbzjUsqQfbvpbxgLuFM7/Ltw+s3BYeddxYIU
         PgbES3/ziddOPsLbwyRQyMMSTJVEEnxMGQO6Hjp4V1jvBFr5WZw8cpO+pFp31oWbTJWV
         PrmM7xTzaVVgbxgvrk9PlX9qvVGbNvp9pCThqJHUYCAaJK9tyviWFU2UwG8KpccML6M+
         JsoA==
X-Gm-Message-State: AOAM533fahzxYe4wHd0yayMIwXHkujX9dSni2huYMomuYcaVW2rHqsU9
        QUJjuQUsr/LYkOW7DBe53WzzSS5fidgfMrU/BWhv9Ud9f1I0gMX4ITiM54U71yZ6Qhpn5ROWuOl
        lr3IrV2Ln+9WW3TLN
X-Received: by 2002:ac8:5bc5:: with SMTP id b5mr314136qtb.268.1604529329975;
        Wed, 04 Nov 2020 14:35:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywcfl5diuip9PFzyDFnEZdRHQngTaAfLLjfEMPJxUt9x8AkUEKQUlT38iGIu4UTKvoAkqjWw==
X-Received: by 2002:ac8:5bc5:: with SMTP id b5mr314108qtb.268.1604529329402;
        Wed, 04 Nov 2020 14:35:29 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x11sm1262488qtr.94.2020.11.04.14.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 14:35:28 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EC58B181CED; Wed,  4 Nov 2020 23:35:26 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Cc:     Hangbin Liu <haliu@redhat.com>, David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
In-Reply-To: <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
 <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com>
 <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 04 Nov 2020 23:35:26 +0100
Message-ID: <87d00svjgx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Nov 4, 2020 at 1:16 PM Edward Cree <ecree@solarflare.com> wrote:
>>
>> On 04/11/2020 03:11, Alexei Starovoitov wrote:
>> > The user will do 'tc -V'. Does version mean anything from bpf loading pov?
>> > It's not. The user will do "ldd `which tc`" and then what?
>> Is it beyond the wit of man for 'tc -V' to output somethingabout
>>  libbpf version?
>> Other libraries seem to solve these problems all the time, I
>>  haven't seen anyone explain what makes libbpf so special that it
>>  has to be different.
>
> slow vger? Please see Daniel and Andrii detailed explanations.
>
> libbpf is not your traditional library.
> Looking through the installed libraries on my devserver in /lib64/ directory
> I think the closest is libbfd.so
> Then think why gdb always statically links it.

The distinguishing feature is the tool, not the library. For a tool that
intimately depends detailed behaviour, sure it makes sense to statically
link to know exactly which version you have. But for BPF, that is
bpftool, not iproute2.

For iproute2, libbpf serves a very simple function: load a BPF program
from an object file and turn it into an fd that can be attached. For
that, dynamic linking is the right thing to do so library upgrades can
bring in new support without touching the tool itself.

Daniel's example from upthread illustrates it:

bpftool prog load | tc attach

i.e., decoupling load from attach. Which is *exactly* what dynamic
linking in iproute2 would mean, except using ld(1) instead of a pipe!

-Toke

