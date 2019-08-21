Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8BD798624
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbfHUVA2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Aug 2019 17:00:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbfHUVA2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 17:00:28 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5F09989AC4
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 21:00:27 +0000 (UTC)
Received: by mail-ed1-f69.google.com with SMTP id f11so2076955edb.16
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 14:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ruFXw9bzrxHGUHChucOB+CKkubs4QvC48DEyCDsjc3U=;
        b=B656PLaV7BqpdSozaed9otinqwz82N2zHzz93gf+zMG3g5w3QAtMWAyJtpIibn+8bw
         LDBMO8iP9hE/6+Dd2PeK+/P2cA/nTax2+Rp33NPJNwZdxcFE8WGgIDR5JLGmMHuQgtut
         BNSLgHnZT9a5qD1fDiPobUBSsEclfIkq4/+6jzQNzsIKiMXhRvnrd2GyHJov1UNINe1y
         la4jdGMrjCmtaxuJ+7AM1DO1g6DkRQ4XBXudpDEpjKE6WV757iF1NnhcpYaZkMDobRok
         cwHjhgHi/ahYCtWW51ffWt3rnPjvkDV2P2YmGIboaO8JEfAAZ+4mAFafk3+9x103X32Q
         f2ZA==
X-Gm-Message-State: APjAAAWzKLlpnPnVVgHNXRtA4uqkrt6B4X/Nf9/MdLWysQYI7zW/e9Rc
        Uj6wZefu07LAeydOvXsr7qz2pDF1VBNIbZmhl1Vq7OMfLlXJWaKf4mZVH70ZyrdL4G+ipLHMbHg
        DNDVuPYmUAYTsMnsw
X-Received: by 2002:a50:ccd9:: with SMTP id b25mr38169323edj.114.1566421226030;
        Wed, 21 Aug 2019 14:00:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz4Vd95rZsajzsZH/kXeb8Ecz4sVxKWF+Y5ZvEWDtGLTuq82UBCEJjUola5Mgs8PVgJZkJ7bQ==
X-Received: by 2002:a50:ccd9:: with SMTP id b25mr38169303edj.114.1566421225863;
        Wed, 21 Aug 2019 14:00:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id h13sm3241367edw.78.2019.08.21.14.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 14:00:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2C3E6181CEF; Wed, 21 Aug 2019 23:00:24 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
In-Reply-To: <20190821192611.xmciiiqjpkujjup7@ast-mbp.dhcp.thefacebook.com>
References: <20190820114706.18546-1-toke@redhat.com> <20190821192611.xmciiiqjpkujjup7@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 21 Aug 2019 23:00:24 +0200
Message-ID: <87ef1eqlnb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Tue, Aug 20, 2019 at 01:47:01PM +0200, Toke Høiland-Jørgensen wrote:
>> iproute2 uses its own bpf loader to load eBPF programs, which has
>> evolved separately from libbpf. Since we are now standardising on
>> libbpf, this becomes a problem as iproute2 is slowly accumulating
>> feature incompatibilities with libbpf-based loaders. In particular,
>> iproute2 has its own (expanded) version of the map definition struct,
>> which makes it difficult to write programs that can be loaded with both
>> custom loaders and iproute2.
>> 
>> This series seeks to address this by converting iproute2 to using libbpf
>> for all its bpf needs. This version is an early proof-of-concept RFC, to
>> get some feedback on whether people think this is the right direction.
>> 
>> What this series does is the following:
>> 
>> - Updates the libbpf map definition struct to match that of iproute2
>>   (patch 1).
>> - Adds functionality to libbpf to support automatic pinning of maps when
>>   loading an eBPF program, while re-using pinned maps if they already
>>   exist (patches 2-3).
>> - Modifies iproute2 to make it possible to compile it against libbpf
>>   without affecting any existing functionality (patch 4).
>> - Changes the iproute2 eBPF loader to use libbpf for loading XDP
>>   programs (patch 5).
>> 
>> 
>> As this is an early PoC, there are still a few missing pieces before
>> this can be merged. Including (but probably not limited to):
>> 
>> - Consolidate the map definition struct in the bpf_helpers.h file in the
>>   kernel tree. This contains a different, and incompatible, update to
>>   the struct. Since the iproute2 version has actually been released for
>>   use outside the kernel tree (and thus is subject to API stability
>>   constraints), I think it makes the most sense to keep that, and port
>>   the selftests to use it.
>
> It sounds like you're implying that existing libbpf format is not
> uapi.

No, that's not what I meant... See below.

> It is and we cannot break it.
> If patch 1 means breakage for existing pre-compiled .o that won't load
> with new libbpf then we cannot use this method.
> Recompiling .o with new libbpf definition of bpf_map_def isn't an option.
> libbpf has to be smart before/after and recognize both old and iproute2 format.

The libbpf.h definition of struct bpf_map_def is compatible with the one
used in iproute2. In libbpf.h, the struct only contains five fields
(type, key_size, value_size, max_entries and flags), and iproute2 adds
another 4 (id, pinning, inner_id and inner_idx; these are the ones in
patch 1 in this series).

The issue I was alluding to above is that the bpf_helpers.h file in the
kernel selftests directory *also* extends the bpf_map_def struct, and
adds two *different* fields (inner_map_idx and numa_mode). The former is
used to implement the same map-in-map definition functionality that
iproute2 has, but with different semantics. The latter is additional to
that, and I'm planning to add that to this series.

Since bpf_helpers.h is *not* part of libbpf (yet), this will make it
possible to keep API (and ABI) compatibility with both iproute2 and
libbpf. As in, old .o files will still load with libbpf after this
series, they just won't be able to use the new automatic pinning
feature.

-Toke
