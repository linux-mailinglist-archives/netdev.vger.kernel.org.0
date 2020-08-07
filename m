Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6561423F3A5
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 22:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgHGUQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 16:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgHGUQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 16:16:24 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BC6C061757
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 13:16:23 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id d19so1496736pgl.10
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 13:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=fHFtBYCexj4BTZ6Y1duEdpJc2jxlS5kQFzTI7bYy0g0=;
        b=ZoiOg1BcUV1vC31wWklIDX8vWaYA8yKQvsHwTMtIPX2Tv/+0Zf+DLEQYBJ/3KOa+vJ
         Dt/N4ivAO7QN76a/KSK4EYdeHg9KpRHzSjqBr73StK4ERdm91cLa51ltxVctnGmE0QDc
         M+a456Nxb15G2L05ayRolTeCFW0FJfkoZYIj03urtCujBfEMeRZO8nAGnrXL/u7LgJQP
         NY2CBhcRZQ4Yhp/n7i+mva0hM1/84beD70Noc7gGQfZNF8/Yy7NiQIVJG6EemXP2CkTM
         ++Y5/YAAVy39rGGGuygVzHn2XtrFtbNEKV4K3Gdp7mD3P6D0Twvw3fXvf1Gc4HL6DOz5
         +gGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=fHFtBYCexj4BTZ6Y1duEdpJc2jxlS5kQFzTI7bYy0g0=;
        b=fSCHr4UyxqyuLydQOPpduUXdpXIqTahMuYfAYO30kyewrikd29Q1ubixovtsRWqm9T
         Y7w9jHkYGlo7oWrY3hHqRmrB+5r2zZVEbRMIT/IhXm9AHf3OV7x6mwhOX/wsI/K7Ca+9
         bG1LVbcV5DhHhELOXaqvnFUSnd96OAAdcKrx4sKQQhHp9aGNvsYxYyLzNgFN3KU6RrZS
         a8eoNMqLbfLtKWEVs3Z/8z/6SLs0qDnI7QeuC9CcdYlZpnNi5jClCssG1P24ABCH+iq4
         S9icKHpR4TvZOVhdmexYKefE7jRz8T6LguDu0IIGv1wv2AIJyOexxxhAW9yQ0OV453Ox
         VM+A==
X-Gm-Message-State: AOAM5326lyTfhJ4KCaP8uPQCX9SDn/jRuCKXBPNTrsPWpAvelT3TwA5h
        KF3+VpnZg7wrOpLER0LZo7IG/E9j244=
X-Google-Smtp-Source: ABdhPJy+gNQx1Nl4qUpu13pz7V/+o8pmrs5auDLurGg+1uV2K7unGLFfSz4my0BkpLwLY513K4PlsQ==
X-Received: by 2002:aa7:8398:: with SMTP id u24mr14302059pfm.107.1596831383021;
        Fri, 07 Aug 2020 13:16:23 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:f4fb:685d:a35f:e88c? ([2601:646:c200:1ef2:f4fb:685d:a35f:e88c])
        by smtp.gmail.com with ESMTPSA id z189sm13521576pfb.178.2020.08.07.13.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 13:16:22 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
Date:   Fri, 7 Aug 2020 13:16:20 -0700
Message-Id: <57399571-280E-48CF-8F72-516F7178748C@amacapital.net>
References: <CAHk-=whPgKZRfK_Kfo6Oo+Aek-Z_U_Dxv9Y3HuNuHb5t=jLbcA@mail.gmail.com>
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
In-Reply-To: <CAHk-=whPgKZRfK_Kfo6Oo+Aek-Z_U_Dxv9Y3HuNuHb5t=jLbcA@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: iPhone Mail (17G68)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 7, 2020, at 12:57 PM, Linus Torvalds <torvalds@linux-foundation.org=
> wrote:
>=20
> =EF=BB=BFOn Fri, Aug 7, 2020 at 12:33 PM Andy Lutomirski <luto@amacapital.=
net> wrote:
>>=20
>> No one said we have to do only one ChaCha20 block per slow path hit.
>=20
> Sure, doing more might be better for amortizing the cost.
>=20
> But you have to be very careful about latency spikes. I would be
> *really* nervous about doing a whole page at a time, when this is
> called from routines that literally expect it to be less than 50
> cycles.
>=20
> So I would seriously suggest you look at a much smaller buffer. Maybe
> not a single block, but definitely not multiple kB either.
>=20
> Maybe something like 2 cachelines might be ok, but there's a reason
> the current code only works with 16 bytes (or whatever) and only does
> simple operations with no looping.
>=20
> That's why I think you might look at a single double-round ChaCha20
> instead. Maybe do it for two blocks - by the time you wrap around,
> you'll have done more than a full ChaCaa20.
>=20
> That would imnsho *much* better than doing some big block, and have
> huge latency spikes and flush a large portion of your L1 when they
> happen. Nasty nasty behavior.
>=20
> I really think the whole "we can amortize it with bigger blocks" is
> complete and utter garbage. It's classic "benchmarketing" crap.
>=20

I think this will come down to actual measurements :). If the cost of one bl=
ock of cache-cold ChaCha20 is 100 cycles of actual computation and 200 cycle=
s of various cache misses, then let=E2=80=99s do more than one block.

I=E2=80=99ll get something working and we=E2=80=99ll see.=20=
