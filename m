Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2AD99859D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfHUUaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:30:23 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46036 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbfHUUaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 16:30:23 -0400
Received: by mail-qt1-f193.google.com with SMTP id k13so4679933qtm.12;
        Wed, 21 Aug 2019 13:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AM6V+OHmQGAHs8uXiG4yFirOyrum3cqbZCZGRLzVgU8=;
        b=aBr/xMyiMeI9lkii5QM3u9Pw3KIJp6LNMXzcNhq6sOib6Ck2jQZykLrdqjg8xtN0T1
         JwhPC51Bpr908ETzo3Q2kVC5jKLEdjTd/tDC/XV/H0PRCzMnWOIvxrnUsf1zpFHylWVt
         Ow/HZ551sRIu3pj+6oWAn4m2AIL41b0vWKEHpXLBz81J4O00LuGJKsm3fJdKI6uxyTmi
         6Vy7V7o3/R4Etu/PSLmtT7Yn41C69mZltD0SbwMHDE6KG7kdAgrwc9z7DYWpCO6GqlrS
         0//R26qukMs1vJr8sM6M1RuUmibvp8f1pWsAOXRj8C5iOtvMWDdOnTd8FlyfJOC4UhTU
         30jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AM6V+OHmQGAHs8uXiG4yFirOyrum3cqbZCZGRLzVgU8=;
        b=t/ls8NDQZbpDMLbdSB0DPx67/sgGmvORr5rFc0YKFwMfwS/9fW1kq4XEVlvjy9msrF
         fgcpAwoaLvwU613G4bOvUyov2CWPR5rmUmJQzTc7qyCEweNwYJVFgx0RdrKED5OMllU7
         QLnvE7Yy7yEXNUC8pnTMRb33rc1pMO4qHI39k0d0CdZZMyUgvQf/DsQgM2F3Mh8LTLsb
         t/HbXZYWBZMpdjPq+ZCoczjto9NfjIoj66H8kGbYLksyBuBIbLcuPSkzMbbtqh+m6thK
         5Bv5N/DWY+pOGuGWPHJjA9i8Y4l97EzrrYZF5wxR2zIxLygG+JY0NQVTQ2uVjxWcFxET
         VSVA==
X-Gm-Message-State: APjAAAVR5MIeRiZxpKXok0MRBJmjjp3vvbx62KBGyjkhu+A9Rmlfnr4F
        qPyDJfOxjoq9E227QYEN0e3utZbRM9Hw49q0gF4=
X-Google-Smtp-Source: APXvYqxXOHAMVXyCmzFgwsuaqXGq0/3vQxPxUU94ESFQyb3tB2iCFt67n8tjD86yIUYgRmYtUqARf9/SCQuRXiLRTdM=
X-Received: by 2002:a0c:ee86:: with SMTP id u6mr19811138qvr.38.1566419421558;
 Wed, 21 Aug 2019 13:30:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190820114706.18546-1-toke@redhat.com>
In-Reply-To: <20190820114706.18546-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Aug 2019 13:30:09 -0700
Message-ID: <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 4:47 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> iproute2 uses its own bpf loader to load eBPF programs, which has
> evolved separately from libbpf. Since we are now standardising on
> libbpf, this becomes a problem as iproute2 is slowly accumulating
> feature incompatibilities with libbpf-based loaders. In particular,
> iproute2 has its own (expanded) version of the map definition struct,
> which makes it difficult to write programs that can be loaded with both
> custom loaders and iproute2.
>
> This series seeks to address this by converting iproute2 to using libbpf
> for all its bpf needs. This version is an early proof-of-concept RFC, to
> get some feedback on whether people think this is the right direction.
>
> What this series does is the following:
>
> - Updates the libbpf map definition struct to match that of iproute2
>   (patch 1).


Hi Toke,

Thanks for taking a stab at unifying libbpf and iproute2 loaders. I'm
totally in support of making iproute2 use libbpf to load/initialize
BPF programs. But I'm against adding iproute2-specific fields to
libbpf's bpf_map_def definitions to support this.

I've proposed the plan of extending libbpf's supported features so
that it can be used to load iproute2-style BPF programs earlier,
please see discussions in [0] and [1]. I think instead of emulating
iproute2 way of matching everything based on user-specified internal
IDs, which doesn't provide good user experience and is quite easy to
get wrong, we should support same scenarios with better declarative
syntax and in a less error-prone way. I believe we can do that by
relying on BTF more heavily (again, please check some of my proposals
in [0], [1], and discussion with Daniel in those threads). It will
feel more natural and be more straightforward to follow. It would be
great if you can lend a hand in implementing pieces of that plan!

I'm currently on vacation, so my availability is very sparse, but I'd
be happy to discuss this further, if need be.

  [0] https://lore.kernel.org/bpf/CAEf4BzbfdG2ub7gCi0OYqBrUoChVHWsmOntWAkJt=
47=3DFE+km+A@xxxxxxxxxxxxxx/
  [1] https://www.spinics.net/lists/bpf/msg03976.html

> - Adds functionality to libbpf to support automatic pinning of maps when
>   loading an eBPF program, while re-using pinned maps if they already
>   exist (patches 2-3).
> - Modifies iproute2 to make it possible to compile it against libbpf
>   without affecting any existing functionality (patch 4).
> - Changes the iproute2 eBPF loader to use libbpf for loading XDP
>   programs (patch 5).
>
>
> As this is an early PoC, there are still a few missing pieces before
> this can be merged. Including (but probably not limited to):
>
> - Consolidate the map definition struct in the bpf_helpers.h file in the
>   kernel tree. This contains a different, and incompatible, update to
>   the struct. Since the iproute2 version has actually been released for
>   use outside the kernel tree (and thus is subject to API stability
>   constraints), I think it makes the most sense to keep that, and port
>   the selftests to use it.
>
> - The iproute2 loader supports automatically populating map-in-map
>   definitions on load. This needs to be added to libbpf as well. There
>   is an implementation of this in the selftests in the kernel tree,
>   which will have to be ported (related to the previous point).
>
> - The iproute2 port needs to be completed; this means at least
>   supporting TC eBPF programs as well, figuring out how to deal with
>   cBPF programs, and getting the verbose output back to the same state
>   as before the port. Also, I guess the iproute2 maintainers need to ACK
>   that they are good with adding a dependency on libbpf.
>
> - Some of the code added to libbpf in patch 2 in this series include
>   code derived from iproute2, which is GPLv2+. So it will need to be
>   re-licensed to be usable in libbpf. Since `git blame` indicated that
>   the original code was written by Daniel, I figure he can ACK that
>   relicensing before applying the patches :)
>
>
> Please take a look at this series and let me know if you agree
> that this is the right direction to go. Assuming there's consensus that
> it is, I'll focus on getting the rest of the libbpf patches ready for
> merging. I'll send those as a separate series, and hold off on the
> iproute2 patches until they are merged; but for this version I'm
> including both in one series so it's easier to see the context.
>
> -Toke
>
>
> libbpf:
> Toke H=C3=B8iland-J=C3=B8rgensen (3):
>   libbpf: Add map definition struct fields from iproute2
>   libbpf: Add support for auto-pinning of maps with reuse on program
>     load
>   libbpf: Add support for specifying map pinning path via callback
>
>  tools/lib/bpf/libbpf.c | 205 +++++++++++++++++++++++++++++++++++++++--
>  tools/lib/bpf/libbpf.h |  18 ++++
>  2 files changed, 214 insertions(+), 9 deletions(-)
>
> iproute2:
> Toke H=C3=B8iland-J=C3=B8rgensen (2):
>   iproute2: Allow compiling against libbpf
>   iproute2: Support loading XDP programs with libbpf
>
>  configure          |  16 +++++
>  include/bpf_util.h |   6 +-
>  ip/ipvrf.c         |   4 +-
>  lib/bpf.c          | 148 ++++++++++++++++++++++++++++++++++++---------
>  4 files changed, 142 insertions(+), 32 deletions(-)
>
>
> --
> 2.22.1
>
