Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A356D992CE
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388323AbfHVMEE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Aug 2019 08:04:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388099AbfHVMEE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 08:04:04 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 333742CE955
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 12:04:03 +0000 (UTC)
Received: by mail-ed1-f72.google.com with SMTP id h25so3238687edb.12
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 05:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=wBmyQ0Hy/UM8S214jYmG5LDTLJcJpDDuEuKZgg1dhPI=;
        b=W+gJyVk0W++hywdaL97R+K9DlebMUiPfeWckPeNTHvnRvU9gQ8jGz3WACIlQnZChwB
         vYCpwwIAMUGPtZjhEA1ZC+gRUIOLtOh87U5nxhPQkC4mXhBVkSIlnTi+xIiK3j6r+QGQ
         tCkSKYIDqC+bFYqNvuqUWMt+dcAavzAB3+rSCAjPz0ocxvWeSagHsLj8dvIFQZFWBixi
         lIdOygISZ9SDhJzjB4Cv9Ch6G8ySCa29Q9MJC4THcbV6B6MAvIvTCCSnVanO1uzWZJE1
         Q86AeJzehyPPcBsh7F6A79MZB1NFTLJ+cWXLGb86tKDFRe8mZmK+oMEydLytW0ep2ty5
         UgQg==
X-Gm-Message-State: APjAAAVSu/mPNL5pVEM3aC/Lrjmevg886S13b8Y1sXUldrbZeguRreOQ
        irN+yYpI1zef5x1DxN0KrTnrrIWWEZUx49n6Dj7B6NkWc/ed5suTRHl/qUq+1s8ta+tPeADdZ6B
        c9sn/JebspQZJMsRN
X-Received: by 2002:a17:906:6792:: with SMTP id q18mr16583440ejp.80.1566475441943;
        Thu, 22 Aug 2019 05:04:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy5GSOkNqt0Yxnl/s2BOnQdexajOEQCYK0eNqAKHYQ3jLHgs2l9Tw/T5Av/UN2cKt8wtoRz0Q==
X-Received: by 2002:a17:906:6792:: with SMTP id q18mr16583412ejp.80.1566475441679;
        Thu, 22 Aug 2019 05:04:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id o88sm3969643edb.28.2019.08.22.05.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 05:04:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7A17D181CEF; Thu, 22 Aug 2019 14:04:00 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        andrii.nakryiko@gmail.com
Subject: Re: [RFC bpf-next 4/5] iproute2: Allow compiling against libbpf
In-Reply-To: <0c3d78eb-d305-9266-b505-c2f9181d5c89@iogearbox.net>
References: <20190820114706.18546-1-toke@redhat.com> <20190820114706.18546-5-toke@redhat.com> <9de36bbf-b70d-9320-c686-3033d0408276@iogearbox.net> <87imqppjir.fsf@toke.dk> <0c3d78eb-d305-9266-b505-c2f9181d5c89@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 22 Aug 2019 14:04:00 +0200
Message-ID: <877e75pftb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 8/22/19 12:43 PM, Toke Høiland-Jørgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>> On 8/20/19 1:47 PM, Toke Høiland-Jørgensen wrote:
>>>> This adds a configure check for libbpf and renames functions to allow
>>>> lib/bpf.c to be compiled with it present. This makes it possible to
>>>> port functionality piecemeal to use libbpf.
>>>>
>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>> ---
>>>>    configure          | 16 ++++++++++++++++
>>>>    include/bpf_util.h |  6 +++---
>>>>    ip/ipvrf.c         |  4 ++--
>>>>    lib/bpf.c          | 33 +++++++++++++++++++--------------
>>>>    4 files changed, 40 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/configure b/configure
>>>> index 45fcffb6..5a89ee9f 100755
>>>> --- a/configure
>>>> +++ b/configure
>>>> @@ -238,6 +238,19 @@ check_elf()
>>>>        fi
>>>>    }
>>>>    
>>>> +check_libbpf()
>>>> +{
>>>> +    if ${PKG_CONFIG} libbpf --exists; then
>>>> +	echo "HAVE_LIBBPF:=y" >>$CONFIG
>>>> +	echo "yes"
>>>> +
>>>> +	echo 'CFLAGS += -DHAVE_LIBBPF' `${PKG_CONFIG} libbpf --cflags` >> $CONFIG
>>>> +	echo 'LDLIBS += ' `${PKG_CONFIG} libbpf --libs` >>$CONFIG
>>>> +    else
>>>> +	echo "no"
>>>> +    fi
>>>> +}
>>>> +
>>>>    check_selinux()
>>>
>>> More of an implementation detail at this point in time, but want to
>>> make sure this doesn't get missed along the way: as discussed at
>>> bpfconf [0] best for iproute2 to handle libbpf support would be the
>>> same way of integration as pahole does, that is, to integrate it via
>>> submodule [1] to allow kernel and libbpf features to be in sync with
>>> iproute2 releases and therefore easily consume extensions we're adding
>>> to libbpf to aide iproute2 integration.
>> 
>> I can sorta see the point wrt keeping in sync with kernel features. But
>> how will this work with distros that package libbpf as a regular
>> library? Have you guys given up on regular library symbol versioning for
>> libbpf?
>
> Not at all, and I hope you know that. ;-)

Good! Didn't really expect you had, just checking ;)

> The reason I added lib/bpf.c integration into iproute2 directly back
> then was exactly such that users can start consuming BPF for tc and
> XDP via iproute2 /everywhere/ with only a simple libelf dependency
> which is also available on all distros since pretty much forever. If
> it was an external library, we could have waited till hell freezes
> over and initial distro adoption would have pretty much taken forever:
> to pick one random example here wrt the pace of some downstream
> distros [0]. The main rationale is pretty much the same as with added
> kernel features that land complementary iproute2 patches for that
> kernel release and as libbpf is developed alongside it is reasonable
> to guarantee user expectations that iproute2 released for kernel
> version x can make use of BPF features added to kernel x with same
> loader support from x.

Well, for iproute2 I would expect this to be solved by version
dependencies. I.e. iproute2 version X would depend on libbpf version Y+
(like, I dunno, the version of libbpf included in the same kernel source
tree as the kernel version iproute2 is targeting? :)).

If we vendor libbpf into every project using it, we'll end up with
dozens of different versions statically linked into each binary, kinda
defeating the purpose of having it as a shared library in the first
place...

-Toke
