Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBB923F2F8
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 21:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgHGTId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 15:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgHGTId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 15:08:33 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB78EC061757
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 12:08:32 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 2so1361326pjx.5
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 12:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=FBUcKSFFHXVM2zlsMD6DE1aiFK2VINTd6Vk4iTZMejM=;
        b=dis+r40effbdQgReX9NDOGfY+a6TNUFbGqBOuGct0BdMfZaNHXH2q5I3LrgefhJtKM
         0c4o9S8/8TQTVP00P/wX8a4ylpk7SsYUL1KoB0T6f5vhPFFH9EeKX3Vg/iRPmoLrGhOp
         G6Yp5Lf81NfuOHOg5GybHqfnYqrRc+chJEvorUlkaxeJvh7j7WgHK0zgSOZzhTQCx1DY
         r47x45lF1CxnlfxXHdsNfX/9iF5VJkAFUahj3zkLH0KpWe0DfApj9dR9ePymviO5fpp7
         kePMqNW1AKUSlx+e04mLzIXwowlXQpW6RAebg6FGbIolxACEIiaknSQM4fzlnfaGxRvy
         US/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=FBUcKSFFHXVM2zlsMD6DE1aiFK2VINTd6Vk4iTZMejM=;
        b=kP3PXeA4SMefoVRLI9PTIaQPXZeZdhQ1mC90xAfb2ztd2WxcHwERQnIj2tATn846V4
         rFVjkmOug/J8okjdTd9Iq7ldh3ediGFimfaw2s/WS1TOs2SXN1y3x+qAXCaQCHjz208S
         0SS6LBby5sd9AtvICjDtxiX0Jn6LvuzMprrs9xXRkmNoCqouiWaC4zng12tFSROL8x6K
         otMGxzs0PI7C5XaWzABvdMJ5qHunMMGvTfOgeHe/90umy31ptIjtlPWSkX8j9W9CH8I5
         ADmndx6/DTp55DLqdAYeUEQPJ5I67C+e3Zi7MzbUMkgpGqLpkPdkeQ2/hOM7vLfNSr7t
         /N3w==
X-Gm-Message-State: AOAM5307gq7zpZBX7+b/ClI5/5cUuBwALpivrbkf6abEZnh6gnL3RKPP
        5z3yeIkK6ih+sjZHFr9VyeuX+V/5Cww=
X-Google-Smtp-Source: ABdhPJwGkBcqMhaAxKihlsaJymF2LKhZQfPjDrEJ7ct7QDI7431NUkQcjjATYy3Hn+QF8tARUvyG0g==
X-Received: by 2002:a17:90a:1546:: with SMTP id y6mr6040347pja.93.1596827310430;
        Fri, 07 Aug 2020 12:08:30 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:431:59:d011:24a4? ([2601:646:c200:1ef2:431:59:d011:24a4])
        by smtp.gmail.com with ESMTPSA id z3sm10799123pgk.49.2020.08.07.12.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 12:08:29 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
Date:   Fri, 7 Aug 2020 12:08:27 -0700
Message-Id: <940D743C-4FDD-43B5-A129-840CFEBBD2F7@amacapital.net>
References: <CAHk-=wj4p3wCZpD2QU-d_RPTAsGiAUWHMiiVUv6N3qxx4w9f7A@mail.gmail.com>
Cc:     Willy Tarreau <w@1wt.eu>, Marc Plumb <lkml.mplumb@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
In-Reply-To: <CAHk-=wj4p3wCZpD2QU-d_RPTAsGiAUWHMiiVUv6N3qxx4w9f7A@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: iPhone Mail (17G68)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 7, 2020, at 11:10 AM, Linus Torvalds <torvalds@linux-foundation.org=
> wrote:
>=20
> =EF=BB=BFOn Fri, Aug 7, 2020 at 10:55 AM Andy Lutomirski <luto@amacapital.=
net> wrote:
>>=20
>> I think the real random.c can run plenty fast. It=E2=80=99s ChaCha20 plus=
 ludicrous overhead right now.
>=20
> I doubt it.
>=20
> I tried something very much like that in user space to just see how
> many cycles it ended up being.
>=20
> I made a "just raw ChaCha20", and it was already much too slow for
> what some of the networking people claim to want.

Do you remember the numbers?

Certainly a full ChaCha20 per random number is too much, but AFAICT the netw=
ork folks want 16 or 32 bits at a time, which is 1/16 or 1/8 of a ChaCha20. D=
JB claims 4 cycles per byte on Core 2, and it had better be faster now, alth=
ough we can=E2=80=99t usefully use XMM regs, so I don=E2=80=99t know the rea=
l timings.

But with the current code, the actual crypto will be lost in the noise.  Tha=
t=E2=80=99s what I=E2=80=99m trying to fix.
>=20
> Now, what *might* be acceptable is to not do ChaCha20, but simply do a
> single double-round of it.

We can certainly have a parallel RNG seeded by the main RNG that runs fewer r=
ounds. I=E2=80=99ll do that if benchmarks say I=E2=80=99m still too slow.

All of this is trivial except the locking. If I=E2=80=99m writing this code,=
 I personally refuse to use  the =E2=80=9Craces just make it more random=E2=80=
=9D strategy. I=E2=80=99m going to do it without data races, and this will t=
ake a bit of work.

