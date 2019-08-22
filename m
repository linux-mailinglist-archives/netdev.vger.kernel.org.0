Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B85398CAE
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 09:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbfHVHwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 03:52:25 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36535 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfHVHwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 03:52:25 -0400
Received: by mail-qk1-f194.google.com with SMTP id d23so4328838qko.3;
        Thu, 22 Aug 2019 00:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=stsi8RFSWb77dkaMBOkDmi7oTII8TH3asCZgAjew5iI=;
        b=JN3jltGKmrf1S/xJ1QOHeBQvQRroHmq+Sg9BfHm5DIOKugqkG/QB1DyNnR6oJttEqe
         5weLChdZG/8UYw09raeRtKsd1sTHfHEjWjo0dxMLgHzK4Fc+vVeg+6QIoay3oVWr050t
         H5tQqiZP3czjfHnxj0JrGDZSdc5pflcF1pYBoXQeaKDKfyzglA9DcGGCx1JVYT8MvtdR
         KJphxeCDjRNHveq4CNNkM8rCDgO2JH/Y+u/lufFEHKEDV1IZi9+itT2/L1xBUuhCsJ++
         ZIeIomGLM34aAgTGnbvb5Jb5cpEkhYOXxlWRM6UEj03Im8VwviGsBeL0iauiqQXavRrc
         RlCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=stsi8RFSWb77dkaMBOkDmi7oTII8TH3asCZgAjew5iI=;
        b=pN6kfMBZc0MaVNMXSQWpnc+ld3rEf2qmnB7R0nnnEUE9V6SxhWDzQX7YEOauJa07Hx
         U5VB3vQPmtUOqgSPT6eFJ0oQ/ukPHkiLK3MUFW9yrCrAL3oB9lUzJz7cGiCrNOl9IGxb
         UisTRaWdGtPksqNDenbKJQwTSGtTTV6MwMF0hJMq3IyMBB9fZa0wRPEi/D63GTUMU4Oq
         R88B5z0+RWs4FEU2WknhXjOQDWDYRTqvC5gacVlfFU8a8hGukzQGHmglqqBm03cPZu8h
         S3JJk44n9zGRpv0HQDyuozQAkTmNPLXBddSCqTjpSTHzxzZBimiEjFt/FZp+tYRUIQya
         ysww==
X-Gm-Message-State: APjAAAVQkS5T5njc6vLFKBuz7I3ialJtw2t+McD9YP8XbYm54bSMwvRk
        iWZ+eyr3CcNZGcfrv9X1Fi/3czhBIUBz/Wc1u18=
X-Google-Smtp-Source: APXvYqzJkFKWSc1J6JTRGBSBy9gYtuY9CbtdYngIp1B15yo0YHowUjrEFL3tGm0lHauQn9z4YUbsUefvnfVkt99LhXE=
X-Received: by 2002:a37:6007:: with SMTP id u7mr19573805qkb.92.1566460343964;
 Thu, 22 Aug 2019 00:52:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190820114706.18546-1-toke@redhat.com> <20190821192611.xmciiiqjpkujjup7@ast-mbp.dhcp.thefacebook.com>
 <87ef1eqlnb.fsf@toke.dk>
In-Reply-To: <87ef1eqlnb.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Aug 2019 00:52:13 -0700
Message-ID: <CAEf4BzbR3gdn=82gCmSQ+=81222J0zza9z6JyYs=TkUY=WDXQw@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
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

On Wed, Aug 21, 2019 at 4:29 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Tue, Aug 20, 2019 at 01:47:01PM +0200, Toke H=C3=B8iland-J=C3=B8rgen=
sen wrote:
> >> iproute2 uses its own bpf loader to load eBPF programs, which has
> >> evolved separately from libbpf. Since we are now standardising on
> >> libbpf, this becomes a problem as iproute2 is slowly accumulating
> >> feature incompatibilities with libbpf-based loaders. In particular,
> >> iproute2 has its own (expanded) version of the map definition struct,
> >> which makes it difficult to write programs that can be loaded with bot=
h
> >> custom loaders and iproute2.
> >>
> >> This series seeks to address this by converting iproute2 to using libb=
pf
> >> for all its bpf needs. This version is an early proof-of-concept RFC, =
to
> >> get some feedback on whether people think this is the right direction.
> >>
> >> What this series does is the following:
> >>
> >> - Updates the libbpf map definition struct to match that of iproute2
> >>   (patch 1).
> >> - Adds functionality to libbpf to support automatic pinning of maps wh=
en
> >>   loading an eBPF program, while re-using pinned maps if they already
> >>   exist (patches 2-3).
> >> - Modifies iproute2 to make it possible to compile it against libbpf
> >>   without affecting any existing functionality (patch 4).
> >> - Changes the iproute2 eBPF loader to use libbpf for loading XDP
> >>   programs (patch 5).
> >>
> >>
> >> As this is an early PoC, there are still a few missing pieces before
> >> this can be merged. Including (but probably not limited to):
> >>
> >> - Consolidate the map definition struct in the bpf_helpers.h file in t=
he
> >>   kernel tree. This contains a different, and incompatible, update to
> >>   the struct. Since the iproute2 version has actually been released fo=
r
> >>   use outside the kernel tree (and thus is subject to API stability
> >>   constraints), I think it makes the most sense to keep that, and port
> >>   the selftests to use it.
> >
> > It sounds like you're implying that existing libbpf format is not
> > uapi.
>
> No, that's not what I meant... See below.
>
> > It is and we cannot break it.
> > If patch 1 means breakage for existing pre-compiled .o that won't load
> > with new libbpf then we cannot use this method.
> > Recompiling .o with new libbpf definition of bpf_map_def isn't an optio=
n.
> > libbpf has to be smart before/after and recognize both old and iproute2=
 format.
>
> The libbpf.h definition of struct bpf_map_def is compatible with the one
> used in iproute2. In libbpf.h, the struct only contains five fields
> (type, key_size, value_size, max_entries and flags), and iproute2 adds
> another 4 (id, pinning, inner_id and inner_idx; these are the ones in
> patch 1 in this series).
>
> The issue I was alluding to above is that the bpf_helpers.h file in the
> kernel selftests directory *also* extends the bpf_map_def struct, and
> adds two *different* fields (inner_map_idx and numa_mode). The former is
> used to implement the same map-in-map definition functionality that
> iproute2 has, but with different semantics. The latter is additional to
> that, and I'm planning to add that to this series.
>
> Since bpf_helpers.h is *not* part of libbpf (yet), this will make it

We should start considering it as if it was, so if we can avoid adding
stuff that I'd need to untangle to move it into libbpf, I'd rather
avoid it.
We've already prepared this move by relicensing bpf_helpers.h. Moving
it into libbpf itself is immediate next thing I'll do when I'm back.

> possible to keep API (and ABI) compatibility with both iproute2 and
> libbpf. As in, old .o files will still load with libbpf after this
> series, they just won't be able to use the new automatic pinning
> feature.
>
> -Toke
