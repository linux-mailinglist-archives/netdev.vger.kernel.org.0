Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0032AEF65
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgKKLRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgKKLRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:17:10 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A02C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 03:17:09 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id d17so2607392lfq.10
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 03:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=SmD3+sLYBLHCX5kIQGy8Wg7QbI8g3por4Ij6pZStXAo=;
        b=tuNFJUUa4Or2tzeijfJGe4TGJ8HZv0d2rT6lPqsF7xaicDwNTPXGmWjQ7VtFgQqYcN
         tm1U67y+nY0gI/iQkmPloyM6FEu5ZtHxkCBtIVzlNDxiyYxqoMlKQp3d7hzR7lRKx9YF
         tFyfPiEOeYh289aKQPZ+nptP3Uai5IR/nKbkI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=SmD3+sLYBLHCX5kIQGy8Wg7QbI8g3por4Ij6pZStXAo=;
        b=GPueT6Lb1PYC+/DuKge7S/n365oWYF7phAUQilIg4wrFp/SBboc78+o2tM4GCH5ErL
         CiWSIzUzVbQ5LWalZMK/+Kjs607Tu83gJw96KYqFTSZl6CjFOASSW8XTO6DH1/mglFwQ
         BgHQgsjZ+058ldaL7jCvI0CoM7zMECPMshTLFNexzfqIaG6vSmNpEt5nuHSyFMTEqP0n
         1qc4xeHGyWpcNAhVhJdeRUXSgNnka1Quwj0TGcL8Hx/a2yxthQefZ9sEiN+erGR5FU0v
         6WOMQqGq/ZlbdIJjMkGiszxNz0tlJTfV0LGwbTzfikqz7NzQFCSUuCSEBl1comxQtRF5
         p/iQ==
X-Gm-Message-State: AOAM531Wjbx7oBzIyaueOXrVpiFxlHIDoGpBfKI5ZRTzN46B49FDKUSo
        HsmIZ7ny/zlRIMd4hupHWtCa+A==
X-Google-Smtp-Source: ABdhPJznBLeCBVObooLKP6FokZLlhU9L/hti/kOz52w26yVhFZYmSQl+sVV4RdcDtFEL35/OuO0Bdw==
X-Received: by 2002:a19:8497:: with SMTP id g145mr9710785lfd.504.1605093428226;
        Wed, 11 Nov 2020 03:17:08 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id w13sm192029lfq.72.2020.11.11.03.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 03:17:07 -0800 (PST)
References: <X6rJ7c1C95uNZ/xV@santucci.pierpaolo> <CAEf4BzYTvPOtiYKuRiMFeJCKhEzYSYs6nLfhuten-EbWxn02Sg@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Santucci Pierpaolo <santucci@epigenesys.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] selftest/bpf: fix IPV6FR handling in flow dissector
In-reply-to: <CAEf4BzYTvPOtiYKuRiMFeJCKhEzYSYs6nLfhuten-EbWxn02Sg@mail.gmail.com>
Date:   Wed, 11 Nov 2020 12:17:06 +0100
Message-ID: <87imacw3bh.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 05:48 AM CET, Andrii Nakryiko wrote:
> On Tue, Nov 10, 2020 at 9:12 AM Santucci Pierpaolo
> <santucci@epigenesys.com> wrote:
>>
>> From second fragment on, IPV6FR program must stop the dissection of IPV6
>> fragmented packet. This is the same approach used for IPV4 fragmentation.
>>
>
> Jakub, can you please take a look as well?

I'm not initimately familiar with this test, but looking at the change
I'd consider that Destinations Options and encapsulation headers can
follow the Fragment Header.

With enough of Dst Opts or levels of encapsulation, transport header
could be pushed to the 2nd fragment. So I'm not sure if the assertion
from the IPv4 dissector that 2nd fragment and following doesn't contain
any parseable header holds.

Taking a step back... what problem are we fixing here?

>
>> Signed-off-by: Santucci Pierpaolo <santucci@epigenesys.com>
>> ---
>>  tools/testing/selftests/bpf/progs/bpf_flow.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
>> index 5a65f6b51377..95a5a0778ed7 100644
>> --- a/tools/testing/selftests/bpf/progs/bpf_flow.c
>> +++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
>> @@ -368,6 +368,8 @@ PROG(IPV6FR)(struct __sk_buff *skb)
>>                  */
>>                 if (!(keys->flags & BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG))
>>                         return export_flow_keys(keys, BPF_OK);
>> +       } else {
>> +               return export_flow_keys(keys, BPF_OK);
>>         }
>>
>>         return parse_ipv6_proto(skb, fragh->nexthdr);
>> --
>> 2.29.2
>>
