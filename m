Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF1198645
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbfHUVHH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Aug 2019 17:07:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbfHUVHH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 17:07:07 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 73EABC0546FE
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 21:07:06 +0000 (UTC)
Received: by mail-ed1-f71.google.com with SMTP id f11so2086000edb.16
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 14:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=+7oLCOeDF3XQIliJ9uRMKaUP7ACTfu+YJIQN3Ry6XhE=;
        b=dfLrxhA5IM5lk25xfJHd/ErxUgSqQOtJSLPv1l8knbB5jkIUVK3LdAH1Bm9QtlM1Zv
         ek2fZMbXnGMAhkptZaZ+Xkci+lFdoej8RzOyIH1j6coNllBXN2CsKIVFdCag31HMoYxS
         N9+AnCmxIx6KtyfY1fALEg1GfFunz9R5wkoh+ZPmjQdbladSWoGkB7WoTw5q2spQKJAF
         rNde0eo6dJdFxuo87RvGRkjhWxa6QKHuLyfcHoI8ZaYJoCejn9IEoZMObk19Xyr/tAY/
         UPfPkpFdQaOm3ZMAMl60it3eQYeCrzD6+U/nIZuIP7nGUGykowlNMvNxaY6iRuKzS2ML
         cnjQ==
X-Gm-Message-State: APjAAAWTvDdf3JZ8NZ/Qzk71aiL7H8MOgMH0oCzaEM3PB+cyMu7TPvEk
        UIGwOITIVSgAM36XwdwuYYSPdeJlaWTAQc3k3FWqefKuN30KwfXC/3zCRV0MPf0C5E+0gipMlse
        uLEKc2vfk3qI62VDk
X-Received: by 2002:a05:6402:8c9:: with SMTP id d9mr38353378edz.154.1566421625246;
        Wed, 21 Aug 2019 14:07:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzUY+iDRwRgKuCrfG9co2//nIesFJTWxGEP9ldqjNYDopMSqCNSsQT8NfZSjV1TXbVNUAiHxA==
X-Received: by 2002:a05:6402:8c9:: with SMTP id d9mr38353362edz.154.1566421625088;
        Wed, 21 Aug 2019 14:07:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id r16sm3288626eji.71.2019.08.21.14.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 14:07:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CB1E2181CEF; Wed, 21 Aug 2019 23:07:03 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
In-Reply-To: <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
References: <20190820114706.18546-1-toke@redhat.com> <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 21 Aug 2019 23:07:03 +0200
Message-ID: <87blwiqlc8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Aug 20, 2019 at 4:47 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
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
>
>
> Hi Toke,
>
> Thanks for taking a stab at unifying libbpf and iproute2 loaders. I'm
> totally in support of making iproute2 use libbpf to load/initialize
> BPF programs. But I'm against adding iproute2-specific fields to
> libbpf's bpf_map_def definitions to support this.
>
> I've proposed the plan of extending libbpf's supported features so
> that it can be used to load iproute2-style BPF programs earlier,
> please see discussions in [0] and [1].

Yeah, I've seen that discussion, and agree that longer term this is
probably a better way to do map-in-map definitions.

However, I view your proposal as complementary to this series: we'll
probably also want the BTF-based definition to work with iproute2, and
that means iproute2 needs to be ported to libbpf. But iproute2 needs to
be backwards compatible with the format it supports now, and, well, this
series is the simplest way to achieve that IMO :)

> I think instead of emulating iproute2 way of matching everything based
> on user-specified internal IDs, which doesn't provide good user
> experience and is quite easy to get wrong, we should support same
> scenarios with better declarative syntax and in a less error-prone
> way. I believe we can do that by relying on BTF more heavily (again,
> please check some of my proposals in [0], [1], and discussion with
> Daniel in those threads). It will feel more natural and be more
> straightforward to follow. It would be great if you can lend a hand in
> implementing pieces of that plan!
>
> I'm currently on vacation, so my availability is very sparse, but I'd
> be happy to discuss this further, if need be.

Happy to collaborate on your proposal when you're back from vacation;
but as I said above, I believe this is a complementary longer-term
thing...

-Toke
