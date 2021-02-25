Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45D73251F3
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhBYPGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 10:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhBYPGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 10:06:18 -0500
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1C7C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 07:05:38 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id m25so1229551vkk.6
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 07:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=++c9LR7OEVADjAkS9WlLwf8od77hhnNitoym0buouPg=;
        b=g8QKluWQl1CFU89v25UJFd3vhtPpEGMFVfsJrFsw/+NaIL60vJVvPE9wkXd/b1AYq0
         sEp/jDPUOxq3VcPXTTQnRqTJuPQ5uXbdwJqHV5lOCwWtzXOa7bknhI5Zee7n5W0emUJr
         zG8e/UYD7sOj26m2XzSwCUK2eG1teOlT8DLNhlqV0h+sYxel3Ki923ayZr/TIkiXLXyj
         3YvbJvyXorU0LmWNYxSxoSdEdQdzE0BUhcWQ6S91OHKkAOMxwmHs4g9gPV9spxGIfMLL
         R8tzjLZigLAphk6c5NE+NtvA0h5jwpQpGxCtVWZVWz88eHaNe5Woz4/3MLOFY3BQsjl6
         s7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=++c9LR7OEVADjAkS9WlLwf8od77hhnNitoym0buouPg=;
        b=nWl3SGiIhFPZj5SNw4vK5/ZkvGuzmTdMTk0V9jsiFfMSyFU+Zn2v2CkAr3EBVVuBLG
         a8IVCVpfDavh0oQ5cz4ztacnGcVVfu8/mLt9WoNC/2VL4Bxb6pJK+iFnT5qsCIeL6Hcn
         C423uDv56hPdeQQay1byO+yZ0G5n7ttWkFFjdD55aSX7Rtz1Uo/Ec6oqoHItCjS2zAZX
         IJItazIKlXq7CYvrA6Zl54lSvCmAkSWP43jFqHu2Rt7Oe1v/h8kGgTxzYGC95pd0ckBk
         zyC4xUAJqIgp6hwESERENBHicKK/ugbnzKi5Yf9WN5LDE1YhKJtLPRYTiqHfn1ap8U+a
         aCJw==
X-Gm-Message-State: AOAM530FttSHuyo+puHbzZDbSh652P6il2HAlhtnkCxAiqJe5ur/VV4K
        n9SMtIPYI7dRYmzOBB9muneHO0x3bBW4wRTwIXA3mg==
X-Google-Smtp-Source: ABdhPJxR5L4JaOygDlRBYXPj0chpMgMIB7nertutBRqtwf/xrx9SpoBOQ5sB0ORvcFcdsUQlbnVc/84tOTR93Zj8P0o=
X-Received: by 2002:a1f:df06:: with SMTP id w6mr1761226vkg.18.1614265537078;
 Thu, 25 Feb 2021 07:05:37 -0800 (PST)
MIME-Version: 1.0
References: <35A4DDAA-7E8D-43CB-A1F5-D1E46A4ED42E@gmail.com>
 <CADVnQy=G=GU1USyEcGA_faJg5L-wLO6jS4EUocrVsjqkaGbvYw@mail.gmail.com>
 <C5332AE4-DFAF-4127-91D1-A9108877507A@gmail.com> <CADVnQynP40vvvTV3VY0fvYwEcSGQ=Y=F53FU8sEc-Bc=mzij5g@mail.gmail.com>
 <93A31D2F-1CDE-4042-9D00-A7E1E49A99A9@gmail.com>
In-Reply-To: <93A31D2F-1CDE-4042-9D00-A7E1E49A99A9@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 25 Feb 2021 10:05:20 -0500
Message-ID: <CADVnQyn5jrkPC7HJAkMOFN-FBZjwtCw8ns-3Yx7q=-S57PdC6w@mail.gmail.com>
Subject: Re: TCP stall issue
To:     Gil Pedersen <kanongil@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 10:36 AM Gil Pedersen <kanongil@gmail.com> wrote:
>
>
> > On 24 Feb 2021, at 15.55, Neal Cardwell <ncardwell@google.com> wrote:
> >
> > On Wed, Feb 24, 2021 at 5:03 AM Gil Pedersen <kanongil@gmail.com> wrote=
:
> >> Sure, I attached a trace from the server that should illustrate the is=
sue.
> >>
> >> The trace is cut from a longer flow with the server at 188.120.85.11 a=
nd a client window scaling factor of 256.
> >>
> >> Packet 78 is a TLP, followed by a delayed DUPACK with a SACK from the =
client.
> >> The SACK triggers a single segment fast re-transmit with an ignored?? =
D-SACK in packet 81.
> >> The first RTO happens at packet 82.
> >
> > Thanks for the trace! That is very helpful. I have attached a plot and
> > my notes on the trace, for discussion.
> >
> > AFAICT the client appears to be badly misbehaving, and misrepresenting
> > what has happened.  At each point where the client sends a DSACK,
> > there is an apparent contradiction. Either the client has received
> > that data before, or it hasn't. If the client *has* already received
> > that data, then it should have already cumulatively ACKed it. If the
> > client has *not* already received that data, then it shouldn't send a
> > DSACK for it.
> >
> > Given that, from the server's perspective, the client is
> > misbehaving/lying, it's not clear what inferences the server can
> > safely make. Though I agree it's probably possible to do much better
> > than the current server behavior.
> >
> > A few questions.
> >
> > (a) is there a middlebox (firewall, NAT, etc) in the path?
> >
> > (b) is it possible to capture a client-side trace, to help
> > disambiguate whether there is a client-side Linux bug or a middlebox
> > bug?
>
> Yes, this sounds like a sound analysis, and matches my observation. The c=
lient is confused about whether it has the data or not.
>
> Unfortunately I only have that (un-rooted) device available, so I can't d=
o traces on it. The connection path is Client -> Wi-Fi -> NAT -> NAT -> Int=
ernet -> Server (which has a basic UFW firewall).
> I will try to do a trace on the first NAT router.
>
> My first priority is to make the server behave better in this case, but I=
 understand that you would like to investigate the client / connection issu=
e as well? From the server POV, this is clearly an edge case, but a fast re=
-transmit does seem more appropriate.

Regarding improving the server's retransmit behavior and having it use
a fast retransmit here.

I don't think this is a bug in RACK, because the DSACK clearly
indicates that the retransmission was spurious, so all the packets
already marked lost by RACK are thus unmarked.

I guess the questions are:

(a) How would we craft a general heuristic that would cause a fast
retransmit here in the misbehaving receiver case, without causing lots
of spurious retransmits for well-behaved receivers? Do you have a
suggestion?

(b) Do we want to add the new complexity for this heuristic, given
that this is a misbehaving receiver and we don't yet have an
indication that it's a widespread bug?

> Btw. the "client SACKs TLP retransmit" note is not correct. This is an ol=
d ACK, which can be seen from the ecr value.

I believe your analysis of the ECR value here is incorrect. The TS ecr
value in ACKs with SACK blocks will generally not match the TS val of
the SACKed segment due to the rules of RFC 7323, specifically rule (2)
on page 17 in section 4.3 (
https://tools.ietf.org/html/rfc7323#section-4.3 ), which says:

   (2)  If:

            SEG.TSval >=3D TS.Recent and SEG.SEQ <=3D Last.ACK.sent

        then SEG.TSval is copied to TS.Recent; otherwise, it is ignored.

Because the sequence number on the SACKed TLP retransmit is >
Last.ACK.sent, SEG.TSval is *not* copied to TS.Recent, and so the TS
ecr value does not reflect the TS val of the TLP retransmit.

So AFAICT this is not an old ACK, but is indeed a SACK of the TLP retransmi=
t.

best,
neal
