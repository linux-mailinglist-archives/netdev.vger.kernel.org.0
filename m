Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E586610F149
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 21:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbfLBUDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 15:03:44 -0500
Received: from mail-qt1-f170.google.com ([209.85.160.170]:45195 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbfLBUDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 15:03:44 -0500
Received: by mail-qt1-f170.google.com with SMTP id p5so1028602qtq.12
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 12:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=snz8MnymXe049hNs6HmvHzYg3B4PQYGrZuq4bJV8UMs=;
        b=FUKfrmXqt8iVM3i+kxKVysNNtgOxgZ4IWuW59nim/h/5fM7XMohw9YP1vtbhlxFS3e
         vXbAVsyymNygkeoYzKNwEUUcTu9k24O2IJbxwsdBMMMjvBLmQBQBP9IjtGsshXuTsULS
         Cesuo3l+jvPZg1rz+MEZwfyQtq4HtAfSDuiWPL4begw52Sbip2fng5MdFBSnxZUh/sXN
         s6FJj2MqEC8AaseA4VFrzTCEMaRNWRe0x/naxlGu6OpG9vj6rUJOM3EwkGEWRXM1KAfa
         iBDXbeReiGhhizGIYRrZpKsCt1YjselvxHa0K8T5ufG7WVOLgHkpCYq9Cixg6jfmpRWQ
         gCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=snz8MnymXe049hNs6HmvHzYg3B4PQYGrZuq4bJV8UMs=;
        b=E9kuOvTYkbfTsLe9HAJSLZHTpNe0Gm9duWfgUraEEYkXyxt3Irv2vvA7cvA1ndSm5v
         p6lh5A/NzOJUryJo8KqHSowJ8ZPeWcQa5La4oYWonk5hDLNqRkL8T9qMp6/a4lcWDbiz
         Pel1klAxiYd7ATnfEQ14Ntkq+kN21uapys5MP6UMBZPLazF4gLr0dISRKZQCF5Pek5m5
         Z62R+ue7O7QYc5oNBiAwoLhx+wwswIX+ruMkc0zaxxDmRkSgN66JW4zYDSJ7AmDj6uIc
         C3kMO7161cXgDaRAzHyuTjz/ukRq0ZakAXakrLS3ChgWNLjfuhuBsGiiSyRIQiur9xzV
         EIzw==
X-Gm-Message-State: APjAAAVH2j4kpwGUp2XS2TkR79snCiRWhQuGpps1Hm5FBP4rwPzeCied
        cJVtM519gqfsJOUkzP0MR3C7W0ZPafJFRJi8wzo=
X-Google-Smtp-Source: APXvYqzRqAj6HtFodC1pp22JwargNv7OaQQwQfd+uJoQy3n2AmQDDx469bLMIPslpvwM8dzT8GsA6uJh/qHORfnugFI=
X-Received: by 2002:ac8:7a83:: with SMTP id x3mr1238241qtr.141.1575317022805;
 Mon, 02 Dec 2019 12:03:42 -0800 (PST)
MIME-Version: 1.0
References: <20191128170837.2236713b@carbon> <CAEf4BzY3jp=cw9N23dBJnEsMXys6ZtjW5LVHquq4kF9avaPKcg@mail.gmail.com>
 <87pnhbulxf.fsf@toke.dk>
In-Reply-To: <87pnhbulxf.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Dec 2019 12:03:31 -0800
Message-ID: <CAEf4BzYg-eM-di=GZOEaTMpgbqjuByY-hXjWpnRyBGyy-AkQYA@mail.gmail.com>
Subject: Re: Better ways to validate map via BTF?
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 29, 2019 at 12:27 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Thu, Nov 28, 2019 at 8:08 AM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> >>
> >> Hi Andrii,
> >
> >
> > Hey, Jesper! Sorry for late reply, I'm on vacation for few days, so my
> > availability is irregular at best :)
> >
> >>
> >> Is there are better way to validate that a userspace BPF-program uses
> >> the correct map via BTF?
> >>
> >> Below and in attached patch, I'm using bpf_obj_get_info_by_fd() to get
> >> some map-info, and check info.value_size and info.max_entries match
> >> what I expect.  What I really want, is to check that "map-value" have
> >> same struct layout as:
> >>
> >>  struct config {
> >>         __u32 action;
> >>         int ifindex;
> >>         __u32 options;
> >>  };
> >
> > Well, there is no existing magical way to do this, but it is doable by
> > comparing BTFs of two maps. It's not too hard to compare all the
> > members of a struct, their names, sizes, types, etc (and do that
> > recursively, if necessary), but it's a bunch of code requiring due
> > diligence. Libbpf doesn't provide that in a ready-to-use form (it does
> > implement equivalence checks between two type graphs for dedup, but
> > it's quite coupled with and specific to BTF deduplication algorithm).
> > Keep in mind, when Toke implemented map pinning support in libbpf, we
> > decided to not check BTF for now, and just check key/value size,
> > flags, type, max_elements, etc.
>
> Yeah. Probably a good idea to provide convenience functions for this in
> libbpf (split out the existing code and make it more general?). Then we
> can also use that for the test in the map pinning code :)

As I said, type graph equivalence for btf_dedup() is very specific to
dedup. It does deep (i.e., structs that are referenced by pointer only
also have to match exactly) and strict (const, volatile, typedefs, all
that matters **and** has to come in exactly the same order)
equivalence checks. In addition, it does forward declaration
resolution into concrete struct/union. So no, it can't be reused or
generalized.

It has to be a new code, but even then I'm hesitant to provide
something "generic", because it's again not clear what the right
semantics is for all the cases. E.g., should we ignore
const/volatile/restrict? Or, if some typedef is used, which ultimately
resolves to the same underlying type -- should we ignore such
differences? Also, should we follow and check types that are
referenced through pointers only? I think in different cases users
might be want to be strict or more lenient about such cases, which
suggests that we shouldn't have a generic API (at least yet, until we
see 2, 3, 4, real-life use cases). And there are more potential
differences in semantics without a clear answer of which one should be
used. So we can code it up for map pinning case (after having a
discussion of what two maps should be considered compatible), but I
don't think we should go all the way to exposing it as an API.


>
> -Toke
>
