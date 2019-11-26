Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9D1B1099A9
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 08:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfKZHnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 02:43:43 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35258 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfKZHnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 02:43:43 -0500
Received: by mail-qt1-f195.google.com with SMTP id n4so20434702qte.2;
        Mon, 25 Nov 2019 23:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UHfKop594uevxqQ70kj1Se7dd51KQ27qul6vNyc+H8E=;
        b=CxmbG0zJ+WHtXeODvOJPuY01bOlEZCOkw+emQeJLJAdBiReutpEAkSiU9EHDWBr9vQ
         ptcsMmnuvz5oosD4Hn0v8QcuKUSX5be+0Xc/wCHdTbPfLnQCFK2FtOiFRaF+DTp0OS6M
         oiGZyRSRxqoJ0Cr13aK+i2x0ZLiEX9d8Q1tu+28/9tcgD38fBSUEXEddKiO89oZaZUMK
         AT0rLlHO1NlkNLyOOniGLtVWQN/jO8iCjv2hXOIWFNVYceMv+SPPnsvvR3bmhDdmbvyh
         LTTQGniZI7KyW8KGTXYVtyj5gbeGrKDK4UJtPRtl5OJE+ydmX2w9VwPEPj41paM3nLtq
         /fLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UHfKop594uevxqQ70kj1Se7dd51KQ27qul6vNyc+H8E=;
        b=pckRbcUh1Gck6LFg4AGffBPK1FANaKqDnbgPGDzGbMtGO0Cp+XMIJdYt+brTutmoAd
         yUL8wJzkq5fXuMoGWRfWx/D2E1VoMLm8fj25VZ/V7h95q+boq86mLLQBFprT1CU05S0K
         /rErZHVai06X6RqpdRU5bShEu7SQIvKF0dUtEL89qirmMtpqxI1FAQ1QjKcI4PAxlprJ
         vzfO+lH4k6Ag9vGUvmMyJY9qKwLLCxBoR0TrhgGChoyA0i+zAmF13L4O69sn8DELJyMK
         2uObrFLfTgAiAAy3Pum3+qXZIXtZW6ZWv/645Ciu/9vFRFXdpIhMQCnOb6g8+iCMMeHb
         /xSg==
X-Gm-Message-State: APjAAAVoSfhoVtbUvw5Ml44kZafWn3WB+cNnX0uyEeskiukqSmpjCuiX
        FgO1C+vz2RfWsdOn6BbCFa42EhAXcrLljmkfn2w=
X-Google-Smtp-Source: APXvYqyWItExhZaEXo74oRYlONO4SnlAkHRuCXsuDv2sj+K5KFfwdVU1WmoWv1fJxIlpLLRFxs9b+5fTwF5VX7Wbs1c=
X-Received: by 2002:ac8:6f57:: with SMTP id n23mr32760938qtv.46.1574754222222;
 Mon, 25 Nov 2019 23:43:42 -0800 (PST)
MIME-Version: 1.0
References: <20191123071226.6501-1-bjorn.topel@gmail.com> <20191123071226.6501-3-bjorn.topel@gmail.com>
 <875zj82ohw.fsf@toke.dk> <CAJ+HfNhFERV+xE7EUup-tu_nBTTqG=7L8bWm+W8h_Lzth4zuKQ@mail.gmail.com>
 <87d0dg0x17.fsf@toke.dk>
In-Reply-To: <87d0dg0x17.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 26 Nov 2019 08:43:31 +0100
Message-ID: <CAJ+HfNhSba7B=SFK0-zjYqFMfwjiq-AVY2Ar7E0P5Pw6gNqTJA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/6] xdp: introduce xdp_call
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Nov 2019 at 16:56, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>
> > On Mon, 25 Nov 2019 at 12:18, Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >>
> >> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
> >>
> >> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >> >
> >> > The xdp_call.h header wraps a more user-friendly API around the BPF
> >> > dispatcher. A user adds a trampoline/XDP caller using the
> >> > DEFINE_XDP_CALL macro, and updates the BPF dispatcher via
> >> > xdp_call_update(). The actual dispatch is done via xdp_call().
> >> >
> >> > Note that xdp_call() is only supported for builtin drivers. Module
> >> > builds will fallback to bpf_prog_run_xdp().
> >>
> >> I don't like this restriction. Distro kernels are not likely to start
> >> shipping all the network drivers builtin, so they won't benefit from t=
he
> >> performance benefits from this dispatcher.
> >>
> >> What is the reason these dispatcher blocks have to reside in the drive=
r?
> >> Couldn't we just allocate one system-wide, and then simply change
> >> bpf_prog_run_xdp() to make use of it transparently (from the driver
> >> PoV)? That would also remove the need to modify every driver...
> >>
> >
> > Good idea! I'll try that out. Thanks for the suggestion!
>
> Awesome! I guess the table may need to be a bit bigger if it's
> system-wide? But since you've already gone to all that trouble with the
> binary search, I guess that shouldn't have too much of a performance
> impact? Maybe the size could even be a config option so users/distros
> can make their own size tradeoff?
>

My bigger concern is not the dispatcher size, but that any XDP update
will be a system wide text-poke. OTOH, this is still the case even if
there are multiple dispatchers. No more "quickly swap XDP program in
one packet latency".

Still, definitely worth a try. And configurable dispatcher size might
be a good idea as well! Thanks!


Cheers,
Bj=C3=B6rn

> -Toke
>
