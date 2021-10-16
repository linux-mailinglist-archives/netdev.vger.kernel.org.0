Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C0D4300E0
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 09:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243790AbhJPHlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 03:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243775AbhJPHla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 03:41:30 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87CAC061570
        for <netdev@vger.kernel.org>; Sat, 16 Oct 2021 00:39:22 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id j21so52244630lfe.0
        for <netdev@vger.kernel.org>; Sat, 16 Oct 2021 00:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SAUMuzplIw24Aq1hrAdp67LAOpth5eUm5UcKI5vG9RA=;
        b=Z9N6Zh9MG/klTksko7MzrgWIcYTylxOI1658VMBemJZHZLMEKB2FmOQnH7jPkuj+Lv
         ILjn25i9r6R1/saewWbKvpS2V24noCwX+4hxbcIk4TyVFvUQTyA9OsQO/zHU0QuwImoe
         0P2pLmbXpwdN3v9oZkloVAvmhn6kRgUUHLbJUs8f2JRoDlnqVykXxegCB6RjweMS9wfd
         ho4Yo8HvjqqaK5QKHB8mkUHrPVnzeKgE+kFDdqY5oGjtxTBpRlYzwWAgU7kM1XvkFbCu
         ykvWMHUVozGtsCZprcD3/tvG58chnQkzsVXhDm1aQ8BpowKjPqIuiGPmOXG2nhXMX5Im
         HbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SAUMuzplIw24Aq1hrAdp67LAOpth5eUm5UcKI5vG9RA=;
        b=nuAMk5RyHWokJLmLAwjRbk4I3oPT0UXWhi7v4zld1vt4Mz4A5ZsfasAFpqUsbBQF28
         0ILw+kleiwIDDxCRu8JkpvWeLC8IW8YSpnwQ2w4plCMZMU2gA0a1fYjUNAADuqL0SQCJ
         KWb89hZSizOgrWAx5hP9KnugeWBI9YFqopFL4mJy/LZeoKhMBJYs4jFWbxdOcgxICshO
         Xu/naGMjTYMyjvf2ORuQHcbfNrg2MDdYVasImw6AuEQUwKceY6jYyAkJoddJgu/NVKJ4
         Lqfgh0f46NttSYjC0crSNZu9bzMBs6qjgJkxyJ2QQ1tl0h75kNK435V5XQqwwpsIIjBZ
         L2Hw==
X-Gm-Message-State: AOAM532DUK3yvOZhapc5Ce7YguGh9ACgG0kAGeq/IjCrEhtsWbejDZtA
        r4vuqkeCsEMy1evyKd3LXYo=
X-Google-Smtp-Source: ABdhPJzMayLQ5dBXi3FoqzjOAYpkM9cNzBlH8FsJCmuhb/Us1KczbUNCx2TuhoHd+4xW8qRRk/Tybw==
X-Received: by 2002:a05:6512:230b:: with SMTP id o11mr15316069lfu.51.1634369961123;
        Sat, 16 Oct 2021 00:39:21 -0700 (PDT)
Received: from smtpclient.apple (176-93-88-52.bb.dnainternet.fi. [176.93.88.52])
        by smtp.gmail.com with ESMTPSA id z20sm767804lfh.306.2021.10.16.00.39.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Oct 2021 00:39:20 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH net-next 2/2] fq_codel: implement L4S style
 ce_threshold_ect1 marking
From:   Jonathan Morton <chromatix99@gmail.com>
In-Reply-To: <87mtnb196m.fsf@toke.dk>
Date:   Sat, 16 Oct 2021 10:39:19 +0300
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>, Bob Briscoe <in@bobbriscoe.net>
Content-Transfer-Encoding: quoted-printable
Message-Id: <308C88C6-D465-4D50-8038-416119A3535C@gmail.com>
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
 <20211014175918.60188-3-eric.dumazet@gmail.com> <87wnmf1ixc.fsf@toke.dk>
 <CANn89iLbJL2Jzot5fy7m07xDhP_iCf8ro8SBzXx1hd0EYVvHcA@mail.gmail.com>
 <87mtnb196m.fsf@toke.dk>
To:     =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 15 Oct, 2021, at 2:24 am, Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote:
>=20
>>>> Add TCA_FQ_CODEL_CE_THRESHOLD_ECT1 boolean option to select Low =
Latency,
>>>> Low Loss, Scalable Throughput (L4S) style marking, along with =
ce_threshold.
>>>>=20
>>>> If enabled, only packets with ECT(1) can be transformed to CE
>>>> if their sojourn time is above the ce_threshold.
>>>>=20
>>>> Note that this new option does not change rules for codel law.
>>>> In particular, if TCA_FQ_CODEL_ECN is left enabled (this is
>>>> the default when fq_codel qdisc is created), ECT(0) packets can
>>>> still get CE if codel law (as governed by limit/target) decides so.
>>>=20
>>> The ability to have certain packets receive a shallow marking =
threshold
>>> and others regular ECN semantics is no doubt useful. However, given =
that
>>> it is by no means certain how the L4S experiment will pan out (and I =
for
>>> one remain sceptical that the real-world benefits will turn out to =
match
>>> the tech demos), I think it's premature to bake the ECT(1) semantics
>>> into UAPI.
>>=20
>> Chicken and egg problem.
>> We had fq_codel in linux kernel years before RFC after all :)
>=20
> Sure, but fq_codel is a self-contained algorithm, it doesn't add new
> meanings to bits of the IP header... :)

I'll be blunter:

In its original (and currently stable) form, fq_codel is RFC-compliant.  =
It conforms, in particular, to RFC-3168 (ECN).  There's a relatively low =
threshold for adding RFC-compliant network algorithms to Linux, and it =
is certainly not required to have a published RFC specifically =
describing each qdisc's operating principles before it can be =
upstreamed.  It just so happens that fq_codel (and some other notable =
algorithms such as CUBIC) proved sufficiently useful in practice to =
warrant post-hoc documentation in RFC form.

However, this patch adds an option which, when enabled, makes fq_codel =
*non-compliant* with RFC-3168, specifically the requirement to treat =
ECT(0) and ECT(1) identically, unless conforming to another published =
RFC which permits different behaviour.

There is a path via RFC-8311 to experiment with alternative ECN =
semantics in this way, but the way ECT(1) is used by L4S is specifically =
mentioned as requiring a published RFC for public deployments.  The L4S =
Internet Drafts have *just failed* an IETF WGLC, which means they are =
*not* advancing to publication as RFCs in their current form.  The =
primary reason for this failure is L4S' fundamental incompatibility with =
existing Internet traffic, despite its stated goal of general Internet =
deployment.  It is my considered opinion, indeed, that moving *away* =
from ECT(1) as the L4S identifier is the best option for improving that =
compatibility.

I believe there is a much higher threshold required for adding such =
things to publicly maintained versions of Linux (as opposed to privately =
maintained experimental versions).

- Jonathan Morton=
