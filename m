Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E349F6FEE
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 09:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfKKIxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 03:53:00 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45065 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfKKIxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 03:53:00 -0500
Received: by mail-qt1-f195.google.com with SMTP id 30so14865764qtz.12
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 00:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ez6gUZUBAox7+sGcE/qxPISl+Otu5N+7pyqvxm7yHUs=;
        b=hy8Xk9ooyie09slw+2ANJnXNtc6w3Iwd97L2UoA4bmI8LBKQNLeDz37sgbhktei6wQ
         Yf7qsNoVGEB+EQFz4XlE9+PGbHIJevKgKQKfCfsJZNxK/jef4ObJdiR0naLH4SlWBAEl
         D0u+yxwWyd14TckZlVKtz/R3QBlUIMtjMY/H0Hzeos1yW8DwjULax3kAEbeeLnbg1yBz
         BO/EKcmBvGwSayN/leQHv+KVL+bx1iD59UdUqM6cAThSskzwbd+M3/yuR5QwYqYriRYz
         JkTEzoEh5JuG7BRzqVx3nV8+zmsZk/qR5YxS9FU8URFDLVvBF9UUqepOq1r9wXhyXOmS
         CVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ez6gUZUBAox7+sGcE/qxPISl+Otu5N+7pyqvxm7yHUs=;
        b=JIvH8QB4QJx7VhKvKvF8k7mIQLFtnXMj2mgt+mas13G47ghux31/za6uuTLfo7hpJK
         X3gdISldix+aeHiCsoubDFMAF/myDSq/RTl6yj5AizW/3iai+Wkry2eLkTmDdEE1mlJd
         q0p8Ka7ef24GEx4rKZugjtqTa1NKR9nrfhwgYl7zIehwcmmlQoBTUJXQi94WY+w0oQGD
         /neln3TWgMKVEBG+UwWaYrQW+TJ2EoOL0ULJlZYj9oV3DW9ufBLYCgfeVVeDOPRLM0wm
         0hcX6l8bLWEGknWOwfSrPBx6iTqGnGWgPO/tUPFG9//uB+UxccHXCuxiBmz0CGS2XrPe
         /Tqg==
X-Gm-Message-State: APjAAAVrpjuqCeXccFkGlRyKXmAMrJceur3O2cVCN0dlHj38WYsScLEY
        Oiku3oP9nhrnbTC1yub7hlXpX3efS/Re7PHYjHixvg==
X-Google-Smtp-Source: APXvYqx0sWToWcRXWeo6Lp+l/oxX8qASeB52JTXwDEsuSF6S9Sz32sPXynrz1LPahra+V2fUX+iMiRYUNRDUph7/iXc=
X-Received: by 2002:ac8:53c1:: with SMTP id c1mr24420169qtq.328.1573462379090;
 Mon, 11 Nov 2019 00:52:59 -0800 (PST)
MIME-Version: 1.0
References: <20191101173219.18631-1-edumazet@google.com> <20191101.145923.2168876543627475825.davem@davemloft.net>
 <CAC=O2+SdhuLmsDEUsNQS3hbEH_Puy07gxsN98dQzTNsF0qx2UA@mail.gmail.com> <CANn89iJUVcpbknBsKn5aJLhJP6DkhErZBcEh3P_uwGs4ZJbMYQ@mail.gmail.com>
In-Reply-To: <CANn89iJUVcpbknBsKn5aJLhJP6DkhErZBcEh3P_uwGs4ZJbMYQ@mail.gmail.com>
From:   Thiemo Nagel <tnagel@google.com>
Date:   Mon, 11 Nov 2019 09:52:46 +0100
Message-ID: <CAC=O2+R3gHT6RtqL6RPiWsyuptpa+vrSQsxdN=DW1LaD1B-vGw@mail.gmail.com>
Subject: Re: [PATCH net] inet: stop leaking jiffies on the wire
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Eric,

I've been thinking about this some more. The prandom_u32() description
says: "This algorithm is NOT considered safe for cryptographic use."
-- Afaiu this implies that an attacker could deduce internal state by
looking at a sequence of random numbers. Consequently, I believe that
we shouldn't use prandom_* for data that gets sent over the wire.
Instead get_random_* should be used which is described as
cryptographically secure.

Kind regards,
Thiemo

From /drivers/char/random.c:

[About get_random_*:]
 * Besides the obvious cryptographic uses, these numbers are also good
 * for seeding TCP sequence numbers, and other places where it is
 * desirable to have numbers which are not only random, but hard to
 * predict by an attacker.
[...]
 * It *is* safe to expose get_random_int() output to attackers (e.g. as
 * network cookies); given outputs 1..n, it's not feasible to predict
 * outputs 0 or n+1.
[...]

 * prandom_u32()
 * -------------
 *
 * For even weaker applications, see the pseudorandom generator
 * prandom_u32(), prandom_max(), and prandom_bytes().  If the random
 * numbers aren't security-critical at all, these are *far* cheaper.
 * Useful for self-tests, random error simulation, randomized backoffs,
 * and any other application where you trust that nobody is trying to
 * maliciously mess with you by guessing the "random" numbers.


On Mon, Nov 4, 2019 at 4:50 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Nov 4, 2019 at 7:24 AM Thiemo Nagel <tnagel@google.com> wrote:
> >
> > Thanks a lot, Eric!
> >
> > Grepping through the source, it seems to me there are two more
> > occurrences of jiffies in inet_id:
> >
> > https://github.com/torvalds/linux/blob/v5.3/net/dccp/ipv4.c#L120
> > https://github.com/torvalds/linux/blob/v5.3/net/dccp/ipv4.c#L419
> >
>
> Indeed.
>
> The one in dccp_v4_connect() has been handled in my patch.
> I missed it in dccp_v4_request_recv_sock()
>
> Thanks.
>
> > Kind regards,
> > Thiemo



--=20

Thiemo Nagel

Software Engineer


Google Germany GmbH, Erika-Mann-Stra=C3=9Fe 33, 80686 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado

Registergericht und -nummer: Hamburg, HRB 86891

Sitz der Gesellschaft: Hamburg
