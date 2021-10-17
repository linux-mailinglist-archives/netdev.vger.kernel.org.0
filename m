Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C4243089D
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 14:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245635AbhJQMUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 08:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245632AbhJQMUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 08:20:44 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A75DC061765
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 05:18:35 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id g8so3434658ljn.4
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 05:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Ams7n3RdF+fXSvGvFS6HBjzoePKPkXT/5ewtgnYm2/4=;
        b=dcHvLZuKFlIjp70b00a0Ctnjao9EvhnRf6FeqkEmTAZtQbiHNXkmmQswhADvOawrhJ
         b7oMrbrEOGlv10WUVBW55YXfJwX8bpSYWMBXtEB9nCLRixrmkwg8h523fyElkhvD1ULb
         XewgrxWCQMTiQG20NnMQzArMT8z0HEZA89LWU2nq3l4WLBwmds6YkqJeNjvw8TQUghte
         0RjbpLocObwI6MS41Lc8po1asnMQF4sWQcTU8PpGI3QSYWJZdEiMj60RciOy2YDeWoZi
         74XqxwLOKdZbbTHNJLSDHu9G3Veunk6KCHqywY7zS/dzeSOPI9s16ZF/4T8gAzJEssgq
         2SNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Ams7n3RdF+fXSvGvFS6HBjzoePKPkXT/5ewtgnYm2/4=;
        b=IchTBI1N/1ziYxeRxX3IE2FYuMJqShV+M1TWWcvILy1XoGwl/puQrpzV8mQTZ8K3Nr
         H0KoCi8fnlP47ftFlJ/e7FoXZNdkmcDYsHIb1tEHcYp2i8VPCvvuqvnJZQB/Rmz+hxVY
         JYVM8ViB6G8zjOMBY0W6J+A4RY5EsX4XfH2S3BwSJeSdjzELJZlz2YmipcCcHGC4ZtUo
         x3abXZoLKpHQrC2c/1AnSalkkrycE0h9CPbMhGGxrAZCJ+Luv8vlAdYo04QWEnHuNAqj
         e8DiDlaOEFDqlfsbf9kZec+SczE38HK/OMqvrDeU/1oag7cQR8ORKCj0UC+9CnaSLJ2Z
         SkSg==
X-Gm-Message-State: AOAM533tDwTs0vcvnValdjWNgPMPIW0/CRpylYf5nyQIc+ZnbEupDYHC
        ZOL0EZZZC/lvbBWr19v5ekY=
X-Google-Smtp-Source: ABdhPJwsnuuOEJ/BnqWwfYpITkwIdH+9GRI0WwKNk0HHc0Fd7a5QPoWxdwhG4kNjRlkDXztBtVIUKA==
X-Received: by 2002:a05:651c:1504:: with SMTP id e4mr25389127ljf.131.1634473113534;
        Sun, 17 Oct 2021 05:18:33 -0700 (PDT)
Received: from smtpclient.apple (176-93-88-52.bb.dnainternet.fi. [176.93.88.52])
        by smtp.gmail.com with ESMTPSA id u16sm1226356lfr.260.2021.10.17.05.18.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Oct 2021 05:18:33 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH net-next 2/2] fq_codel: implement L4S style
 ce_threshold_ect1 marking
From:   Jonathan Morton <chromatix99@gmail.com>
In-Reply-To: <9ad3a249-1950-c665-5996-e15352867924@bobbriscoe.net>
Date:   Sun, 17 Oct 2021 15:18:30 +0300
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>,
        =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A2749FBB-6963-4043-9A1D-E950AF4ACE62@gmail.com>
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
 <20211014175918.60188-3-eric.dumazet@gmail.com> <87wnmf1ixc.fsf@toke.dk>
 <CANn89iLbJL2Jzot5fy7m07xDhP_iCf8ro8SBzXx1hd0EYVvHcA@mail.gmail.com>
 <87mtnb196m.fsf@toke.dk> <308C88C6-D465-4D50-8038-416119A3535C@gmail.com>
 <9ad3a249-1950-c665-5996-e15352867924@bobbriscoe.net>
To:     Bob Briscoe <ietf@bobbriscoe.net>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 17 Oct, 2021, at 2:22 pm, Bob Briscoe <ietf@bobbriscoe.net> wrote:
>=20
>> I'll be blunter:
>>=20
>> In its original (and currently stable) form, fq_codel is =
RFC-compliant.  It conforms, in particular, to RFC-3168 (ECN).  There's =
a relatively low threshold for adding RFC-compliant network algorithms =
to Linux, and it is certainly not required to have a published RFC =
specifically describing each qdisc's operating principles before it can =
be upstreamed.  It just so happens that fq_codel (and some other notable =
algorithms such as CUBIC) proved sufficiently useful in practice to =
warrant post-hoc documentation in RFC form.
>>=20
>> However, this patch adds an option which, when enabled, makes =
fq_codel *non-compliant* with RFC-3168, specifically the requirement to =
treat ECT(0) and ECT(1) identically, unless conforming to another =
published RFC which permits different behaviour.
>>=20
>> There is a path via RFC-8311 to experiment with alternative ECN =
semantics in this way, but the way ECT(1) is used by L4S is specifically =
mentioned as requiring a published RFC for public deployments.  The L4S =
Internet Drafts have *just failed* an IETF WGLC, which means they are =
*not* advancing to publication as RFCs in their current form.
>=20
> [BB] Clarification of IETF process: A first Working Group Last Call =
(WGLC) is nearly always the beginning of the end of the IETF's RFC =
publication process. Usually the majority of detailed comments arrive =
during a WGLC. Then the draft has to be fixed, and then it goes either =
directly through to the next stage (in this case, an IETF-wide last =
call), or to another WGLC.

Further clarification: this is already the second WGLC for L4S.  The one =
two years previously (at Montreal) yielded a number of major technical =
objections, which remained unresolved as of this latest WGLC.

>> The primary reason for this failure is L4S' fundamental =
incompatibility with existing Internet traffic, despite its stated goal =
of general Internet deployment.
>=20
> [BB] s/The primary reason /JM's primary objection /
> There is no ranking of the reasons for more work being needed.  The WG =
had already developed a way to mitigate this objection. Otherwise, a =
WGLC would not have been started in the first place. Further work on =
this issue is now more likely to be wordsmithing.

Given that the objections cited by the TSVWG Chairs were technical in =
nature, and related specifically to the incompatibility between L4S and =
existing conventional traffic, it is clear to me that wordsmithing will =
*not* be sufficient to render L4S publishable in RFC form, nor =
deployable at Internet scale. =20

To quote David Black, one of the aforementioned Chairs and also an =
author of RFC-8311:

> Two overall conclusions are that a) the WGLC has been productive, and =
shows significant continuing support for L4S, and b) the L4S drafts =
should be revised to address the WGLC concerns raised.   The WG chairs =
strongly suggest that the revisions include limiting the scope and =
impact of initial L4S experiments on RFC 3168 functionality (both =
existing usage and potential deployment) to ensure that the L4S =
experiments are safe to perform on the Internet, paying particular =
attention to potential impacts on networks and users that are not =
participating in the L4S experiments.

It is my recommendation to netdev to stay out of this ongoing mess, by =
rejecting this patch.

 - Jonathan Morton=
