Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFDC18F39D
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 12:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgCWLYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 07:24:40 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:27048 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728116AbgCWLYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 07:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584962678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QgI+PwCNnY/iJ7pzahYSNmEUnhAWPtzlpXq1QEFnx24=;
        b=U1Jg96QNSdN3RtWLF5+bZUrrYBnm0HR7PvYbd556iOl4AN2PMzVc5j8ihdJEUJ8iGdHbN4
        pB6RGfy9mZkMWfuPzZSRX1GQZipu93vvz6kreJutrUmXRaiHvBbzfNk3N0Wb+FufG4FYYg
        VcTOZfy901VrKtMstmCi+pFfo9VjP5w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-p6CHPcL1Npyw7fzTIBUUow-1; Mon, 23 Mar 2020 07:24:37 -0400
X-MC-Unique: p6CHPcL1Npyw7fzTIBUUow-1
Received: by mail-wm1-f69.google.com with SMTP id n25so3877162wmi.5
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 04:24:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=QgI+PwCNnY/iJ7pzahYSNmEUnhAWPtzlpXq1QEFnx24=;
        b=X5RavN0ah3FIKlzOpZtkgxXjcOThzYZe93Z+cStF9vOVbXgPm9H3Qj2SdhuQisGW00
         mJFkOiiMGzrcWEreo3V3o3yhk6I+n6Zwp+zo78srxuh+5H8eRHafHKm8bPckoe7rtioF
         V6k1a13LkLGInlliLFLfjA9jWHxb7YERkbxmp5WTc8AJVEpK2SgO54UVMvwRUjKP09Y+
         VXYEcTPPcqPojYLWhpltmPh2j+9mmPG5G8kHGLCWjdFCva9N1LMMCZrkTPYjLQisebnR
         Uhz2HA8vZBA+iGkiuSj1XdiMbQlhb87Rp3GWJRYtaEf6VA25PgkUVSlxMfywrj2rAae2
         cMpA==
X-Gm-Message-State: ANhLgQ1Wl2AW0wwUvC404Aq4A2FCxItGmrkb666Q2+k01NufRnOrR1t5
        q0puIfWtVd/a/uhRqw5sHcuPFSimiZMQdumB1cbSno4/NfSxEg9AfSXzwOD9Mxs60aOcR1uGsSj
        fY3+J3HNVyBnBmQU2
X-Received: by 2002:a5d:4ac2:: with SMTP id y2mr29821907wrs.263.1584962675765;
        Mon, 23 Mar 2020 04:24:35 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvsBFND2+lwfGWtdfJ+rG0c/XYA0dfBYLsREfOPSbA7kA4s4iTgpKtJmBixk6uVfhQPyOx0jg==
X-Received: by 2002:a5d:4ac2:: with SMTP id y2mr29821870wrs.263.1584962675463;
        Mon, 23 Mar 2020 04:24:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w9sm374552wrk.18.2020.03.23.04.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 04:24:34 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3DE83180371; Mon, 23 Mar 2020 12:24:34 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk> <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN> <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN> <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch> <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 23 Mar 2020 12:24:34 +0100
Message-ID: <87tv2f48lp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Mar 20, 2020 at 11:31 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
>>
>> Jakub Kicinski wrote:
>> > On Fri, 20 Mar 2020 09:48:10 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote:
>> > > Jakub Kicinski <kuba@kernel.org> writes:
>> > > > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> > > >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> > > >>
>> > > >> While it is currently possible for userspace to specify that an e=
xisting
>> > > >> XDP program should not be replaced when attaching to an interface=
, there is
>> > > >> no mechanism to safely replace a specific XDP program with anothe=
r.
>> > > >>
>> > > >> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, wh=
ich can be
>> > > >> set along with IFLA_XDP_FD. If set, the kernel will check that th=
e program
>> > > >> currently loaded on the interface matches the expected one, and f=
ail the
>> > > >> operation if it does not. This corresponds to a 'cmpxchg' memory =
operation.
>> > > >>
>> > > >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to expli=
citly
>> > > >> request checking of the EXPECTED_FD attribute. This is needed for=
 userspace
>> > > >> to discover whether the kernel supports the new attribute.
>> > > >>
>> > > >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> > > >
>> > > > I didn't know we wanted to go ahead with this...
>> > >
>> > > Well, I'm aware of the bpf_link discussion, obviously. Not sure what=
's
>> > > happening with that, though. So since this is a straight-forward
>> > > extension of the existing API, that doesn't carry a high implementat=
ion
>> > > cost, I figured I'd just go ahead with this. Doesn't mean we can't h=
ave
>> > > something similar in bpf_link as well, of course.
>> >
>> > I'm not really in the loop, but from what I overheard - I think the
>> > bpf_link may be targeting something non-networking first.
>>
>> My preference is to avoid building two different APIs one for XDP and an=
other
>> for everything else. If we have userlands that already understand links =
and
>> pinning support is on the way imo lets use these APIs for networking as =
well.
>
> I agree here. And yes, I've been working on extending bpf_link into
> cgroup and then to XDP. We are still discussing some cgroup-specific
> details, but the patch is ready. I'm going to post it as an RFC to get
> the discussion started, before we do this for XDP.

Well, my reason for being skeptic about bpf_link and proposing the
netlink-based API is actually exactly this, but in reverse: With
bpf_link we will be in the situation that everything related to a netdev
is configured over netlink *except* XDP.

Other than that, I don't see any reason why the bpf_link API won't work.
So I guess that if no one else has any problem with BPF insisting on
being a special snowflake, I guess I can live with it as well... *shrugs* :)

-Toke

