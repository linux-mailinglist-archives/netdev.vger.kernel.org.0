Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F64F99821
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 17:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731775AbfHVP2S convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Aug 2019 11:28:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731077AbfHVP2S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 11:28:18 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E0C0811D8
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 15:28:17 +0000 (UTC)
Received: by mail-ed1-f72.google.com with SMTP id f3so3587234edx.10
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 08:28:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=krMfSLZcsg7EJW3/JmyKQzYNmpY5sLVlz3EGChY+0Vg=;
        b=HSgkb1Jz+tBBDXaBnoENcJ6SvcxLaRhbuxOH5BlyOj1t9bbfYpLXQ6OfA839NlKugm
         CQReTJz1zneBvNBCLoK+3HI+RXBft7GAbkxujm5TB0qwfPpszrLrUDDGV0NHXoWy9P5E
         HQsD+Mw6xyEXobqSAJVdkiBw+Kr8VNoNadQeg64tsCEwQ+y2wWegQN8984UpBE4u4OCb
         +qf6zIrSXv4EidoWNpfp6p83o3d8klxbcNIli60jaFTWvKjdPFrHf1XkbhBjapwnEFCk
         XsCGCy+VjlJve7R+IAhAzt8wDtgBQhvVK8R76h0dW9uYmoZe6cYIap4mOpkIgk6FGI+D
         /F6Q==
X-Gm-Message-State: APjAAAXW4wXYR6MipschQVm+e/r+0a04rOeqeZdM6xKI/DeRZ0pQkMzJ
        DsSXFTQIUdbD/qhdTOCmjHACIkKo14AxxJw61xxF2ZKckBCKsomti8sVdQgIplaT3gqNQbILEik
        DGplzcbXiwGZR7Mm3
X-Received: by 2002:a50:982a:: with SMTP id g39mr42427141edb.88.1566487695945;
        Thu, 22 Aug 2019 08:28:15 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxnSJz0Yuac1EFb3CuPfOvbRFXUk0QFhxQhZWF0nZbq15JMgFuxehfkZBdeRKDZznSFqLw25g==
X-Received: by 2002:a50:982a:: with SMTP id g39mr42427119edb.88.1566487695767;
        Thu, 22 Aug 2019 08:28:15 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id p20sm3703597eja.59.2019.08.22.08.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 08:28:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 47FED181CEF; Thu, 22 Aug 2019 17:28:14 +0200 (CEST)
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
In-Reply-To: <2cf18fed-f2ec-bea3-658e-07ba8124148a@iogearbox.net>
References: <20190820114706.18546-1-toke@redhat.com> <20190820114706.18546-5-toke@redhat.com> <9de36bbf-b70d-9320-c686-3033d0408276@iogearbox.net> <87imqppjir.fsf@toke.dk> <0c3d78eb-d305-9266-b505-c2f9181d5c89@iogearbox.net> <877e75pftb.fsf@toke.dk> <4ca44e39-9b32-909f-df8d-f565eae57498@iogearbox.net> <87zhk1nwvc.fsf@toke.dk> <2cf18fed-f2ec-bea3-658e-07ba8124148a@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 22 Aug 2019 17:28:14 +0200
Message-ID: <87v9upnrsh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 8/22/19 3:38 PM, Toke Høiland-Jørgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>> On 8/22/19 2:04 PM, Toke Høiland-Jørgensen wrote:
>>>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>>>> On 8/22/19 12:43 PM, Toke Høiland-Jørgensen wrote:
>>>>>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>>>>>> On 8/20/19 1:47 PM, Toke Høiland-Jørgensen wrote:
>>>>>>>> This adds a configure check for libbpf and renames functions to allow
>>>>>>>> lib/bpf.c to be compiled with it present. This makes it possible to
>>>>>>>> port functionality piecemeal to use libbpf.
>>>>>>>>
>>>>>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>>>> ---
>>>>>>>>      configure          | 16 ++++++++++++++++
>>>>>>>>      include/bpf_util.h |  6 +++---
>>>>>>>>      ip/ipvrf.c         |  4 ++--
>>>>>>>>      lib/bpf.c          | 33 +++++++++++++++++++--------------
>>>>>>>>      4 files changed, 40 insertions(+), 19 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/configure b/configure
>>>>>>>> index 45fcffb6..5a89ee9f 100755
>>>>>>>> --- a/configure
>>>>>>>> +++ b/configure
>>>>>>>> @@ -238,6 +238,19 @@ check_elf()
>>>>>>>>          fi
>>>>>>>>      }
>>>>>>>>      
>>>>>>>> +check_libbpf()
>>>>>>>> +{
>>>>>>>> +    if ${PKG_CONFIG} libbpf --exists; then
>>>>>>>> +	echo "HAVE_LIBBPF:=y" >>$CONFIG
>>>>>>>> +	echo "yes"
>>>>>>>> +
>>>>>>>> +	echo 'CFLAGS += -DHAVE_LIBBPF' `${PKG_CONFIG} libbpf --cflags` >> $CONFIG
>>>>>>>> +	echo 'LDLIBS += ' `${PKG_CONFIG} libbpf --libs` >>$CONFIG
>>>>>>>> +    else
>>>>>>>> +	echo "no"
>>>>>>>> +    fi
>>>>>>>> +}
>>>>>>>> +
>>>>>>>>      check_selinux()
>>>>>>>
>>>>>>> More of an implementation detail at this point in time, but want to
>>>>>>> make sure this doesn't get missed along the way: as discussed at
>>>>>>> bpfconf [0] best for iproute2 to handle libbpf support would be the
>>>>>>> same way of integration as pahole does, that is, to integrate it via
>>>>>>> submodule [1] to allow kernel and libbpf features to be in sync with
>>>>>>> iproute2 releases and therefore easily consume extensions we're adding
>>>>>>> to libbpf to aide iproute2 integration.
>>>>>>
>>>>>> I can sorta see the point wrt keeping in sync with kernel features. But
>>>>>> how will this work with distros that package libbpf as a regular
>>>>>> library? Have you guys given up on regular library symbol versioning for
>>>>>> libbpf?
>>>>>
>>>>> Not at all, and I hope you know that. ;-)
>>>>
>>>> Good! Didn't really expect you had, just checking ;)
>>>>
>>>>> The reason I added lib/bpf.c integration into iproute2 directly back
>>>>> then was exactly such that users can start consuming BPF for tc and
>>>>> XDP via iproute2 /everywhere/ with only a simple libelf dependency
>>>>> which is also available on all distros since pretty much forever. If
>>>>> it was an external library, we could have waited till hell freezes
>>>>> over and initial distro adoption would have pretty much taken forever:
>>>>> to pick one random example here wrt the pace of some downstream
>>>>> distros [0]. The main rationale is pretty much the same as with added
>>>>> kernel features that land complementary iproute2 patches for that
>>>>> kernel release and as libbpf is developed alongside it is reasonable
>>>>> to guarantee user expectations that iproute2 released for kernel
>>>>> version x can make use of BPF features added to kernel x with same
>>>>> loader support from x.
>>>>
>>>> Well, for iproute2 I would expect this to be solved by version
>>>> dependencies. I.e. iproute2 version X would depend on libbpf version Y+
>>>> (like, I dunno, the version of libbpf included in the same kernel source
>>>> tree as the kernel version iproute2 is targeting? :)).
>>>
>>> This sounds nice in theory, but from what I've seen major (!) distros
>>> already seem to have a hard time releasing kernel x along with iproute2
>>> package x, concrete example was that distro kernel was on 4.13 and its
>>> official iproute2 package on 4.9,
>> 
>> If the iproute2 package is not being updated at all I don't really see
>> how it would make any difference whether libbpf is vendored or not? :)
>> 
>>> adding yet another variable that needs to be in sync with kernel is
>>> simply impractical especially for a _core_ package like iproute2 that
>>> should have as little dependencies as possible. I also don't want to
>>> make a bet on whether libbpf will be available on every distro that
>>> also ships iproute2. Hence approach that pahole (and also bcc by the
>>> way) takes is most reasonable to have the best user experience.
>> 
>> Most users are going to get iproute2 from their distro packages anyway,
>> so if distros are incompetent at packaging, my bet is that you're going
>> to run into issues one way or another.
>> 
>> But OK, if you think it is easier to work around bad distros by
>> vendoring, you guys are the maintainers, so that's up to you. But can we
>> at least put in the version dependency and let the build system pick up
>> a system libbpf if it exists and is compatible? That way distros that
>> *are* competent can still link it dynamically...
>
> Yeah that would be fine by me to use this as a fallback, and I think that
> iproute2's configure script should be able to easily handle this
> situation.

Cool, I can live with that :)

-Toke
