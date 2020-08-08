Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD71123F8A7
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 21:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgHHTte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 15:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgHHTte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 15:49:34 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00559C061756
        for <netdev@vger.kernel.org>; Sat,  8 Aug 2020 12:49:33 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id c10so7450644pjn.1
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 12:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=lRah3f4ZJxya/lq5T/gQ0Av6zsw0I59Oe0BSHHsVeS0=;
        b=fjU/t4DAZUeQJszsb9aXJUa7943dBGuhIeXXaici94bxRv1uJU4DA4OrGsels+A2nC
         8z9DDJu9O3orLR6C4cDLskjdn7o8Jz4fMdDqWGZJI6+fVPVd0gciFyrNC++tTppL2ov9
         zbTqp9iHjsSd2Gj9J5xOHn49GUYrHgScjHLWeZtQycFjQnkCtR9nGpuIXkIglLo8n1Oi
         AevchnQMbsJKGP9BsDi4uBE0Hc5+Sa/M7s1ORJXQQxqd4/2xLWTobEXdyW/bHe/DAxFr
         ib5mxZH0MejD8csTtEJS5DqvyOjYmUOaj9HroOiKhuk+GfWRUnOxa7CG9R6DX5ox5Kh0
         96Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=lRah3f4ZJxya/lq5T/gQ0Av6zsw0I59Oe0BSHHsVeS0=;
        b=VsYjQnjiyL21W+32iGbptUInxjYwMCjr905l3VqbW7wQwVUkBzCb8JSCxXumC89oHk
         S+iiMnx5szgKnbGLS7E3nJccsIvrQni9J4I0hrQHhkj6GRvDl3GnD5YVj38EsXCH54qa
         gKJXaPsuHqKWJk+EGSTjiGE+JOdZlrb1r74kN3yX1/UGMjUrerjuqkZeArE9GtQhAYbX
         QvDxqfg4GpBRn21Hf+7Gm7OYGXTOFumjgYDsWhN3iy4cFG4yMpOjUB3yPTImssBMNVFS
         t+E5OX7KwDB6jNnzD1J5AJxjF3aKfVshdiHk9ASRXe+IV/xOVNcDQhlZc3z6CFEosJj9
         LMyA==
X-Gm-Message-State: AOAM533MUsC5wt+KHlKZUJ8w+qnvurSGsuxFeKAa/D7s8j6oGutsvXQS
        DstEpOqCm9M52BrAxO5YLqMhJQ==
X-Google-Smtp-Source: ABdhPJxz/hIoBNNCpQcNStHCa9tyIz5cLYZ4va9tUepynuySgTy/N6TNJZUadsUFxl8gJscqB74X7w==
X-Received: by 2002:a17:902:ac87:: with SMTP id h7mr18541561plr.238.1596916173245;
        Sat, 08 Aug 2020 12:49:33 -0700 (PDT)
Received: from ?IPv6:2600:1010:b06c:4273:8c0a:a3e2:67f6:6db4? ([2600:1010:b06c:4273:8c0a:a3e2:67f6:6db4])
        by smtp.gmail.com with ESMTPSA id a16sm17960867pfr.45.2020.08.08.12.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 12:49:32 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
Date:   Sat, 8 Aug 2020 12:49:30 -0700
Message-Id: <A92CFD64-176B-4DC2-9BF2-257F4EBBE901@amacapital.net>
References: <20200808190343.GB27941@SDF.ORG>
Cc:     netdev@vger.kernel.org, w@1wt.eu, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org
In-Reply-To: <20200808190343.GB27941@SDF.ORG>
To:     George Spelvin <lkml@sdf.org>
X-Mailer: iPhone Mail (17G68)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Aug 8, 2020, at 12:03 PM, George Spelvin <lkml@sdf.org> wrote:
>=20
> =EF=BB=BFOn Sat, Aug 08, 2020 at 10:07:51AM -0700, Andy Lutomirski wrote:
>>>   - Cryptographically strong ChaCha, batched
>>>   - Cryptographically strong ChaCha, with anti-backtracking.
>>=20
>> I think we should just anti-backtrack everything.  With the "fast key=20
>> erasure" construction, already implemented in my patchset for the=20
>> buffered bytes, this is extremely fast.
>=20
> The problem is that this is really *amorized* key erasure, and
> requires large buffers to amortize the cost down to a reasonable
> level.
>=20
> E,g, if using 256-bit (32-byte) keys, 5% overhead would require generating=

> 640 bytes at a time.
>=20
> Are we okay with ~1K per core for this?  Which we might have to
> throw away occasionally to incorporate fresh seed material?

I don=E2=80=99t care about throwing this stuff away. My plan (not quite impl=
emented yet) is to have a percpu RNG stream and to never to anything resembl=
ing mixing anything in. The stream is periodically discarded and reinitializ=
ed from the global =E2=80=9Cprimary=E2=80=9D pool instead.  The primary pool=
 has a global lock. We do some vaguely clever trickery to arrange for all th=
e percpu pools to reseed from the primary pool at different times.

Meanwhile the primary pool gets reseeded by the input pool on a schedule for=
 catastrophic reseeding.

5% overhead to make a fresh ChaCha20 key each time sounds totally fine to me=
. The real issue is that the bigger we make this thing, the bigger the laten=
cy spike each time we run it.

Do we really need 256 bits of key erasure?  I suppose if we only replace hal=
f the key each time, we=E2=80=99re just asking for some cryptographer to run=
 the numbers on a break-one-of-many attack and come up with something vaguel=
y alarming.

I wonder if we get good performance by spreading out the work. We could, for=
 example, have a 320 byte output buffer that get_random_bytes() uses and a 3=
20+32 byte =E2=80=9Cnext=E2=80=9D buffer that is generated as the output buf=
fer is used. When we finish the output buffer, the first 320 bytes of the ne=
xt buffer becomes the current buffer and the extra 32 bytes becomes the new k=
ey (or nonce).  This will have lower worst case latency, but it will hit the=
 cache lines more often, potentially hurting throughout.

