Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0420575B35
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 01:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfGYX0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 19:26:07 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:47002 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfGYX0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 19:26:07 -0400
Received: by mail-lf1-f65.google.com with SMTP id z15so31473951lfh.13;
        Thu, 25 Jul 2019 16:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9l3baTsqWUqUoLsmlugit8t4Kk96ZWT3/jwqQOX2+aM=;
        b=M22/OEs3jSuHhxuGfvjid3m6tR0t3Rv1gyvbMFbTdjzpPbX4zLaNv7tL4aaBpb/1hm
         m+7eZBTvMaCWebMUDMOSYHBdbBZBq3M+x9gl3Rr2cpj4F7lL3hUZJKWoJD1xpdUxcqQI
         aCBZ6oJm/MVTGh2WA3JL/n9Adb1tBYG1aO+4iKNzpGmMSmXzXkq5BRg8jb4Hx/ZrfwVf
         a5hJK2iAGvChJrbOrcBI9Uxp9SHPmbk/UA7iGElyxjjHKsmTewSbnETvKTUzJ+wac3+6
         8ZZnLMRfgE6lM9ozd9c7wiSFheu2Sc06uvOgLtHuE/JwCb4T4Ew3zkRkZihlbWXTeA1G
         4YsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9l3baTsqWUqUoLsmlugit8t4Kk96ZWT3/jwqQOX2+aM=;
        b=mQj6Jt0Ucpc+iwIfn61jpnm2zQyw6Xvjs7Szawwz3Ag9YmaWfJI9CuYZZ/ZHiT9n67
         idsJ1DuhVGGwrwuc9HiA0Jzm187U67r2mGdu8zF4EajGuteoBuptlAnEJXtTIa+m2qAZ
         nggmtK+3tKfF9ggyUUTgMnyrrCd1MrJX7JhmJIwrAQ8wZ9C7U81vTXlal0Pfytr/NtgE
         5UxuyyVDqqgiQorHA8Bma4GRSUX5ouZ//8k3RlJ0yLUc2iAHTCUAHssB9PrmzTaBoGHM
         +LVJV2NQJ/o0XT1dn1d7JydApAK/6bQ4VgzBhNanzbwuhNrKJ+exp0YZEXdT9cHaagtT
         EgkQ==
X-Gm-Message-State: APjAAAWAFnHNnssPu7tdH/1SRqUxNchOIg7rctUzvQTbej/8Hr2RTZc0
        +HksYerOtwCsKAj3CxlbCLkh0qqxVEVJ9wPWhFk=
X-Google-Smtp-Source: APXvYqxCZuHwcONq22zcljkmr7iT8iGQQQa8JIdlK9raO9TTtd3P9XwdESY0pGx6lC3boLAXhcsdZMpqLIzigttHn+k=
X-Received: by 2002:a05:6512:21c:: with SMTP id a28mr2351025lfo.14.1564097165009;
 Thu, 25 Jul 2019 16:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-3-brianvv@google.com>
 <CAPhsuW4HPjXE+zZGmPM9GVPgnVieRr0WOuXfM0W6ec3SB4imDw@mail.gmail.com>
 <CABCgpaXz4hO=iGoswdqYBECWE5eu2AdUgms=hyfKnqz7E+ZgNg@mail.gmail.com> <CAPhsuW5NzzeDmNmgqRh0kwHnoQfaD90L44NJ9AbydG_tGJkKiQ@mail.gmail.com>
In-Reply-To: <CAPhsuW5NzzeDmNmgqRh0kwHnoQfaD90L44NJ9AbydG_tGJkKiQ@mail.gmail.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Thu, 25 Jul 2019 16:25:53 -0700
Message-ID: <CABCgpaV7mj5DhFqh44rUNVj5XMAyP+n79LrMobW_=DfvEaS4BQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > If prev_key is deleted before map_get_next_key(), we get the first key
> > > again. This is pretty weird.
> >
> > Yes, I know. But note that the current scenario happens even for the
> > old interface (imagine you are walking a map from userspace and you
> > tried get_next_key the prev_key was removed, you will start again from
> > the beginning without noticing it).
> > I tried to sent a patch in the past but I was missing some context:
> > before NULL was used to get the very first_key the interface relied in
> > a random (non existent) key to retrieve the first_key in the map, and
> > I was told what we still have to support that scenario.
>
> BPF_MAP_DUMP is slightly different, as you may return the first key
> multiple times in the same call. Also, BPF_MAP_DUMP is new, so we
> don't have to support legacy scenarios.
>
> Since BPF_MAP_DUMP keeps a list of elements. It is possible to try
> to look up previous keys. Would something down this direction work?

I've been thinking about it and I think first we need a way to detect
that since key was not present we got the first_key instead:

- One solution I had in mind was to explicitly asked for the first key
with map_get_next_key(map, NULL, first_key) and while walking the map
check that map_get_next_key(map, prev_key, key) doesn't return the
same key. This could be done using memcmp.
- Discussing with Stan, he mentioned that another option is to support
a flag in map_get_next_key to let it know that we want an error
instead of the first_key.

After detecting the problem we also need to define what we want to do,
here some options:

a) Return the error to the caller
b) Try with previous keys if any (which be limited to the keys that we
have traversed so far in this dump call)
c) continue with next entries in the map. array is easy just get the
next valid key (starting on i+1), but hmap might be difficult since
starting on the next bucket could potentially skip some keys that were
concurrently added to the same bucket where key used to be, and
starting on the same bucket could lead us to return repeated elements.

Or maybe we could support those 3 cases via flags and let the caller
decide which one to use?

Let me know what are your thoughts.

Thanks,
Brian
