Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECB5287D92
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbgJHU7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:59:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51094 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730874AbgJHU7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 16:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602190762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gN3Ln5Vu/RDE/s48yZNAciHUYcjsvxHecDlnVYzl5AQ=;
        b=bEffh+AHbho/XAb4rubFLJkXkqhUvJmDk0UCoKNdGQe0zjXy8D3w0nzNNLqjr2/Laikggx
        +v5cZeZFCw0/Tkdcepi/bbMklVOXrZu9Py214XzB04NiHNcVUrqKjLnT+LObnkQQLrfBuv
        1jghJbkHz+BUoi/il/ZSQMEdtDOGzxo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-MqV-0QXyOi2U8IiDfWDtiw-1; Thu, 08 Oct 2020 16:59:20 -0400
X-MC-Unique: MqV-0QXyOi2U8IiDfWDtiw-1
Received: by mail-wr1-f70.google.com with SMTP id b11so531735wrm.3
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 13:59:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=gN3Ln5Vu/RDE/s48yZNAciHUYcjsvxHecDlnVYzl5AQ=;
        b=M+/tz3StF8Td1oogz8//hc8XpoKyqCOitl99/avInQjAMqZkjj9mbJhc37iJ6hENXJ
         ZQRAwaDxOsDQLCLtFzZfqXujUKOm8r34BtsWovcJObJ/tCnDiq1nph/tJ693KEHSZlUW
         c+gYTCWx+CcvWjjF1fmyFpeddIgnbSP/Cm74NOpOlmfzOk3jBciIHd+NksYFZpxyE7Pd
         GUltGFeRriOzHK3kMQbNZN03xrcioxkZMRjj5ChbYTeg2XKXirf2gHHiv3Zp4LQrQMMD
         0tUbFSThfVlztJD9gm9rwn3B0QyUwdgU19Ha9zv64CXAMFYuIbaLm+v7HSSBM2Fso4un
         CrXg==
X-Gm-Message-State: AOAM533ocHSEhAolpC70/8ZyNVbxRQA4gprfkNxzAyrjCX5f4ulSkq4v
        l7dXNNpzp89R2WFzgFaqU/1/CHUkc+SUb4luZW1e5xnFM247qghm3EshiPtH0Z97k6+lV9Te+g3
        X7RJRe6bLO/2QSSEw
X-Received: by 2002:adf:e445:: with SMTP id t5mr10847388wrm.387.1602190759367;
        Thu, 08 Oct 2020 13:59:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2ioZa9AYDi6mbBOBwLtMRCgTFP019XkC4U1pMpogLYweKytdKZz/hzqEeMy986RhSKPwNcA==
X-Received: by 2002:adf:e445:: with SMTP id t5mr10847356wrm.387.1602190758897;
        Thu, 08 Oct 2020 13:59:18 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h3sm4063675wrw.78.2020.10.08.13.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 13:59:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DC16D1837DC; Thu,  8 Oct 2020 22:59:17 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH bpf-next] bpf_fib_lookup: return target ifindex even if
 neighbour lookup fails
In-Reply-To: <bf190e76-b178-d915-8d0d-811905d38fd2@iogearbox.net>
References: <20201008145314.116800-1-toke@redhat.com>
 <bf190e76-b178-d915-8d0d-811905d38fd2@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 08 Oct 2020 22:59:17 +0200
Message-ID: <87a6wwe8nu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 10/8/20 4:53 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> The bpf_fib_lookup() helper performs a neighbour lookup for the destinat=
ion
>> IP and returns BPF_FIB_LKUP_NO_NEIGH if this fails, with the expectation
>> that the BPF program will pass the packet up the stack in this case.
>> However, with the addition of bpf_redirect_neigh() that can be used inst=
ead
>> to perform the neighbour lookup.
>>=20
>> However, for that we still need the target ifindex, and since
>> bpf_fib_lookup() already has that at the time it performs the neighbour
>> lookup, there is really no reason why it can't just return it in any cas=
e.
>> With this fix, a BPF program can do the following to perform a redirect
>> based on the routing table that will succeed even if there is no neighbo=
ur
>> entry:
>>=20
>> 	ret =3D bpf_fib_lookup(skb, &fib_params, sizeof(fib_params), 0);
>> 	if (ret =3D=3D BPF_FIB_LKUP_RET_SUCCESS) {
>> 		__builtin_memcpy(eth->h_dest, fib_params.dmac, ETH_ALEN);
>> 		__builtin_memcpy(eth->h_source, fib_params.smac, ETH_ALEN);
>>=20
>> 		return bpf_redirect(fib_params.ifindex, 0);
>> 	} else if (ret =3D=3D BPF_FIB_LKUP_RET_NO_NEIGH) {
>> 		return bpf_redirect_neigh(fib_params.ifindex, 0);
>> 	}
>>=20
>> Cc: David Ahern <dsahern@gmail.com>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> ACK, this looks super useful! Could you also add a new flag which would s=
kip
> neighbor lookup in the helper while at it (follow-up would be totally fin=
e from
> my pov since both are independent from each other)?

Sure, can do. Thought about adding it straight away, but wasn't sure if
it would be useful, since the fib lookup has already done quite a lot of
work by then. But if you think it'd be useful, I can certainly add it.
I'll look at this tomorrow; if you merge this before then I'll do it as
a follow-up, and if not I'll respin with it added. OK? :)

-Toke

