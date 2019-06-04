Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05ED6351A3
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfFDVHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:07:13 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40500 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfFDVHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:07:12 -0400
Received: by mail-pf1-f196.google.com with SMTP id u17so13430855pfn.7
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AVNzuJ16OlOt4Vvvv/aqtbS0TAayMNqKXRIgbNicTgk=;
        b=hNom/jwSwV6l3jYiFNsE9F2XTqDdeaGPCv2lIEpqA0UT7JmGDDrdwLPsPJrEGpRY9c
         t4y9vUkamRrGLrNJ+lbFbm31eZyc/Rr8smNBmu3u1VEVOEoHoRbzUa3SF1X2d9KVBnyx
         NKnp6P0bFkcz78/RMm5rF1XhY4TdD27hm9zXNWD/JlTLvozYxH7N/JDNZ14OdP/jUZJD
         nfoBZ9mBskBlJde6Gt/uUMIN28SLs5U0vy1/5lxRLGBqdPgl6QIdLDEPKZGr/s5Ougyp
         62GeQYWolJEHUF3aDuBEsqnvdrtii+9sJFXzmp2nWX8EHgXpJjwNo8gbpqX72cR89B5b
         g55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AVNzuJ16OlOt4Vvvv/aqtbS0TAayMNqKXRIgbNicTgk=;
        b=VnQN3xUpzZON90V0Q+8Z23gN1d+3T17Mpme8CthWGNCdqyYnPMKNbvk3mzUInNUZvt
         K05Uu+B6kWEhCLhVG9Mn62xjvTckvkYTIWsDxs2zT/tYZrxVTkKwAe8RAH9xH+eAQKz9
         u3F2aXoPSuYtcCn7rzd0MFZA3VAmXhn7+gZVy76+ZvwxCgTB56UNd7e9yxmLjkTfrPQe
         uKCNDk7WeVvfLd3K6BS5V+g+qTCzq9pQJTPjt6iM7kbzCFWmJ1/xy0CK4fQOpcGXXVni
         kI+CySVrUgEJeL9LIWCQYXli7hmSj0846CqUD8SNyBWgUkFFtE+7hMscC+Q4xqxY4d12
         laHA==
X-Gm-Message-State: APjAAAXzupdCLgoJDYg83eqXEYhjXKVrMg2QmlkkrjROzcyZsViWNaaz
        Lo8yBymF1c24JUliu+qjl14hlg==
X-Google-Smtp-Source: APXvYqzlpK5pBiX4ZkgLqxxNTRGRH0ynLDYmWkspxcryl8RjU9it0Gu+UXY5JkgZrcsNnP/avbUxqw==
X-Received: by 2002:a63:6157:: with SMTP id v84mr785749pgb.36.1559682432353;
        Tue, 04 Jun 2019 14:07:12 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id n184sm20166360pfn.21.2019.06.04.14.07.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 14:07:11 -0700 (PDT)
Date:   Tue, 4 Jun 2019 14:07:10 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map
 definitions using BTF
Message-ID: <20190604210710.GA17053@mini-arch>
References: <20190531202132.379386-7-andriin@fb.com>
 <20190531212835.GA31612@mini-arch>
 <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
 <20190603163222.GA14556@mini-arch>
 <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
 <20190604010254.GB14556@mini-arch>
 <f2b5120c-fae7-bf72-238a-b76257b0c0e4@fb.com>
 <20190604042902.GA2014@mini-arch>
 <20190604134538.GB2014@mini-arch>
 <CAEf4BzZEqmnwL0MvEkM7iH3qKJ+TF7=yCKJRAAb34m4+B-1Zcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZEqmnwL0MvEkM7iH3qKJ+TF7=yCKJRAAb34m4+B-1Zcg@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/04, Andrii Nakryiko wrote:
> On Tue, Jun 4, 2019 at 6:45 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 06/03, Stanislav Fomichev wrote:
> > > > BTF is mandatory for _any_ new feature.
> > > If something is easy to support without asking everyone to upgrade to
> > > a bleeding edge llvm, why not do it?
> > > So much for backwards compatibility and flexibility.
> > >
> > > > It's for introspection and debuggability in the first place.
> > > > Good debugging is not optional.
> > > Once llvm 8+ is everywhere, sure, but we are not there yet (I'm talking
> > > about upstream LTS distros like ubuntu/redhat).
> > But putting this aside, one thing that I didn't see addressed in the
> > cover letter is: what is the main motivation for the series?
> > Is it to support iproute2 map definitions (so cilium can switch to libbpf)?
> 
> In general, the motivation is to arrive at a way to support
> declaratively defining maps in such a way, that:
> - captures type information (for debuggability/introspection) in
> coherent and hard-to-screw-up way;
> - allows to support missing useful features w/ good syntax (e.g.,
> natural map-in-map case vs current completely manual non-declarative
> way for libbpf);

[..]
> - ultimately allow iproute2 to use libbpf as unified loader (and thus
> the need to support its existing features, like
> BPF_MAP_TYPE_PROG_ARRAY initialization, pinning, map-in-map);
So prog_array tail call info would be encoded in the magic struct instead of
a __section_tail(whatever) macros that iproute2 is using? Does it
mean that the programs that target iproute2 would have to be rewritten?
Or we don't have a goal to provide source-level compatibility?

In general, supporting iproute2 seems like the most compelling
reason to use BTF given current state of llvm+btf adoption.
BPF_ANNOTATE_KV_PAIR and map-in-map syntax while ugly, is not the major
paint point (imho); but I agree, with BTF both of those things
look much better.

That's why I was trying to understand whether we can start with using
BTF to support _existing_ iproute2 format and then, once it's working,
generalize it (and kill bpf_map_def or make it a subset of generic BTF).
That way we are not implementing another way to support pinning/tail
calls, but enabling iproute2 to use libbpf.

But feel free to ignore all my nonsense above; I don't really have any
major concerns with the new generic format rather than discoverability
(the docs might help) and a mandate that everyone switches to it immediately.

> The only missing feature that can be supported reasonably with
> bpf_map_def is pinning (as it's just another int field), but all the
> other use cases requires awkward approach of matching arbitrary IDs,
> which feels like a bad way forward.
> 
> 
> > If that's the case, maybe explicitly focus on that? Once we have
> > proof-of-concept working for iproute2 mode, we can extend it to everything.
