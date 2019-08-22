Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38EF3990FF
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731923AbfHVKiW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Aug 2019 06:38:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbfHVKiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:38:22 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 11891109AE
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 10:38:21 +0000 (UTC)
Received: by mail-ed1-f70.google.com with SMTP id i10so3117891edv.14
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 03:38:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3WF76R9PRluSwsSbBisHuTfQpPlZfHG8CCj+Dbr+eN8=;
        b=rKPX7g4r5xPfe8ED/pK/jQ0IKYeldk0KlBRrDXufBLtSMDrCK4KAztAyrz+zF3/+Ot
         vUgUoddnV9MprAnAD9Ppp01FJn6Cu5fXNOMyHHHHIeBuG39LmXajkv+bIw9Hn9Rmi1S8
         3cqcyXdjNNF3sQGzipJXjn6E0muNGXhYzFMMwRvn2g1YWkR4Qid/0awvq+0CSckF3t8e
         pDUPzxHhZ58xuFpzd3G2ZY/lgY8LhasVKIYi9MMl0yVyaIvIE58cpSbQfHeKVqhTJPpz
         PEmENvbcX3uWpqu7hLltFN5Wy8LZJjhSNl11qRGzkLerFeGegP5fn2/zLq39We6u2v5Q
         7a0A==
X-Gm-Message-State: APjAAAWNwya8qOsgvS4kUNO3Tiu3m4Fa7aW5JXomvs4tfwaoEj+4JnTk
        bwn2B9nqhdRz/isLN43Kx6Qlwt70dIOZLkFh6P1G3j0abYQ6tdJDt53HOCX4z69H5du6H4k3gcU
        Hanf7qpoEvoryzdWN
X-Received: by 2002:aa7:c389:: with SMTP id k9mr11406793edq.175.1566470299872;
        Thu, 22 Aug 2019 03:38:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwES2nggyHN87LpGxHfpuoh53GOMS5YnMJCbxe42BZzTz9LYqV0cMOrbTyJkseXDOJx/onB1g==
X-Received: by 2002:aa7:c389:: with SMTP id k9mr11406761edq.175.1566470299651;
        Thu, 22 Aug 2019 03:38:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id i1sm2436280edi.13.2019.08.22.03.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 03:38:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4B4FC181CEF; Thu, 22 Aug 2019 12:38:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
In-Reply-To: <CAEf4BzbR3gdn=82gCmSQ+=81222J0zza9z6JyYs=TkUY=WDXQw@mail.gmail.com>
References: <20190820114706.18546-1-toke@redhat.com> <20190821192611.xmciiiqjpkujjup7@ast-mbp.dhcp.thefacebook.com> <87ef1eqlnb.fsf@toke.dk> <CAEf4BzbR3gdn=82gCmSQ+=81222J0zza9z6JyYs=TkUY=WDXQw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 22 Aug 2019 12:38:18 +0200
Message-ID: <87lfvlpjs5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Aug 21, 2019 at 4:29 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> > On Tue, Aug 20, 2019 at 01:47:01PM +0200, Toke Høiland-Jørgensen wrote:
>> >> iproute2 uses its own bpf loader to load eBPF programs, which has
>> >> evolved separately from libbpf. Since we are now standardising on
>> >> libbpf, this becomes a problem as iproute2 is slowly accumulating
>> >> feature incompatibilities with libbpf-based loaders. In particular,
>> >> iproute2 has its own (expanded) version of the map definition struct,
>> >> which makes it difficult to write programs that can be loaded with both
>> >> custom loaders and iproute2.
>> >>
>> >> This series seeks to address this by converting iproute2 to using libbpf
>> >> for all its bpf needs. This version is an early proof-of-concept RFC, to
>> >> get some feedback on whether people think this is the right direction.
>> >>
>> >> What this series does is the following:
>> >>
>> >> - Updates the libbpf map definition struct to match that of iproute2
>> >>   (patch 1).
>> >> - Adds functionality to libbpf to support automatic pinning of maps when
>> >>   loading an eBPF program, while re-using pinned maps if they already
>> >>   exist (patches 2-3).
>> >> - Modifies iproute2 to make it possible to compile it against libbpf
>> >>   without affecting any existing functionality (patch 4).
>> >> - Changes the iproute2 eBPF loader to use libbpf for loading XDP
>> >>   programs (patch 5).
>> >>
>> >>
>> >> As this is an early PoC, there are still a few missing pieces before
>> >> this can be merged. Including (but probably not limited to):
>> >>
>> >> - Consolidate the map definition struct in the bpf_helpers.h file in the
>> >>   kernel tree. This contains a different, and incompatible, update to
>> >>   the struct. Since the iproute2 version has actually been released for
>> >>   use outside the kernel tree (and thus is subject to API stability
>> >>   constraints), I think it makes the most sense to keep that, and port
>> >>   the selftests to use it.
>> >
>> > It sounds like you're implying that existing libbpf format is not
>> > uapi.
>>
>> No, that's not what I meant... See below.
>>
>> > It is and we cannot break it.
>> > If patch 1 means breakage for existing pre-compiled .o that won't load
>> > with new libbpf then we cannot use this method.
>> > Recompiling .o with new libbpf definition of bpf_map_def isn't an option.
>> > libbpf has to be smart before/after and recognize both old and iproute2 format.
>>
>> The libbpf.h definition of struct bpf_map_def is compatible with the one
>> used in iproute2. In libbpf.h, the struct only contains five fields
>> (type, key_size, value_size, max_entries and flags), and iproute2 adds
>> another 4 (id, pinning, inner_id and inner_idx; these are the ones in
>> patch 1 in this series).
>>
>> The issue I was alluding to above is that the bpf_helpers.h file in the
>> kernel selftests directory *also* extends the bpf_map_def struct, and
>> adds two *different* fields (inner_map_idx and numa_mode). The former is
>> used to implement the same map-in-map definition functionality that
>> iproute2 has, but with different semantics. The latter is additional to
>> that, and I'm planning to add that to this series.
>>
>> Since bpf_helpers.h is *not* part of libbpf (yet), this will make it
>
> We should start considering it as if it was, so if we can avoid adding
> stuff that I'd need to untangle to move it into libbpf, I'd rather
> avoid it.
> We've already prepared this move by relicensing bpf_helpers.h. Moving
> it into libbpf itself is immediate next thing I'll do when I'm back.

Yeah, I figured that with the relicensing, bpf_helpers would probably be
making its way into libbpf soon. Which is why I wanted to start this
discussion before that: If we do move bpf_helpers as-is, that will put
us in the territory of full-on binary incompatibility. So the time to
discuss doing this in a compatible way is now, before any such move is
made.

-Toke
