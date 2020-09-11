Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93083265E5E
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 12:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgIKKw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 06:52:29 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52621 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgIKKwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 06:52:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599821543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jHRtuARY5xx6Zy98e3+O2VSg03hcSksfEHlzR8SEmwI=;
        b=QFz2gZ2fGClrXr8hyHi5G0xHaCqNAimZzPy4UDrqarbOJuomkQ3OL7298MtAGNby8yW+Jv
        W/PiI+mi4XNoAZg9JH0/NqCnw6Z7pbTMc9T3A9ukJSB4YZwdvHdwb14t9N/SwTko9UXjJ3
        jhbtYeb02l8jtYy7Dg7rS3Q2Exw2/Us=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-c4CP-rjtP8SQkXGWzxG-HQ-1; Fri, 11 Sep 2020 06:52:21 -0400
X-MC-Unique: c4CP-rjtP8SQkXGWzxG-HQ-1
Received: by mail-wm1-f69.google.com with SMTP id 23so1207063wmk.8
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 03:52:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=jHRtuARY5xx6Zy98e3+O2VSg03hcSksfEHlzR8SEmwI=;
        b=kTW762z0bb+L0zlxHGW5tK2i9Ji215X2Il/xM+1dFL940uD7rj0/0EcCnx9g4lUk6J
         7nuXkTBFB9gmciE7DPasVivsj4VQcMZUrSVHUWcML8HE0wSFhzgtPFeBeZgirxaO2xab
         LadprN0FUrG3rvaQYjveL56zdo/PLTMCgUPRvYKSrClEXTamWjWsZQzAwWmVpRS0D5nT
         6ZXFGMSXb8b5WLCEMFck2EPQ80d+6xXsBe7qzYDnvrnKQ+wYWduGdWSOLY7RiACY0Z+u
         iL8Df+pbDHBT6QeV9AWG2FakLpKNkZdVuPTxKOJCtlUH0JeqWKyZ0skqOPhdM5EH/jpO
         4pDA==
X-Gm-Message-State: AOAM531oaZZMpXiyhqOvScN1ic4jRGezb4nvn0BoEmPUKCcQwuv/8R5c
        7njQFM4qwDaAQTiNOMFnjP3oJlOfDhoxaz1hYeJHUpNUZu45Rwev1TThsd0b9i66Wdc9nREtn5o
        0t2Ce+y4IC1L0YbyR
X-Received: by 2002:a7b:c92c:: with SMTP id h12mr1598938wml.121.1599821540088;
        Fri, 11 Sep 2020 03:52:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzp9uoo30gaLk4Sxob/TvZRYrTy45Lu6qbRVTyt1j2VLxqIlMWDyqrfaslZWCCi+1zHfh3dtQ==
X-Received: by 2002:a7b:c92c:: with SMTP id h12mr1598909wml.121.1599821539588;
        Fri, 11 Sep 2020 03:52:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l16sm4115533wrb.70.2020.09.11.03.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 03:52:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 838341829D4; Fri, 11 Sep 2020 12:52:17 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eelco Chaudron <echaudro@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Fix context type resolving for
 extension programs
In-Reply-To: <CAADnVQ+3sBR7dTQhX+eHvzJajtnm0QctjrWFyc+LMkHJOoOabA@mail.gmail.com>
References: <20200909151115.1559418-1-jolsa@kernel.org>
 <CAADnVQ+3sBR7dTQhX+eHvzJajtnm0QctjrWFyc+LMkHJOoOabA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Sep 2020 12:52:17 +0200
Message-ID: <871rj8bn6m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Sep 9, 2020 at 8:11 AM Jiri Olsa <jolsa@kernel.org> wrote:
>>
>> Eelco reported we can't properly access arguments if the tracing
>> program is attached to extension program.
>>
>> Having following program:
>>
>>   SEC("classifier/test_pkt_md_access")
>>   int test_pkt_md_access(struct __sk_buff *skb)
>>
>> with its extension:
>>
>>   SEC("freplace/test_pkt_md_access")
>>   int test_pkt_md_access_new(struct __sk_buff *skb)
>>
>> and tracing that extension with:
>>
>>   SEC("fentry/test_pkt_md_access_new")
>>   int BPF_PROG(fentry, struct sk_buff *skb)
>>
>> It's not possible to access skb argument in the fentry program,
>> with following error from verifier:
>>
>>   ; int BPF_PROG(fentry, struct sk_buff *skb)
>>   0: (79) r1 = *(u64 *)(r1 +0)
>>   invalid bpf_context access off=0 size=8
>>
>> The problem is that btf_ctx_access gets the context type for the
>> traced program, which is in this case the extension.
>>
>> But when we trace extension program, we want to get the context
>> type of the program that the extension is attached to, so we can
>> access the argument properly in the trace program.
>>
>> Reported-by: Eelco Chaudron <echaudro@redhat.com>
>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>> ---
>>  kernel/bpf/btf.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>> index f9ac6935ab3c..37ad01c32e5a 100644
>> --- a/kernel/bpf/btf.c
>> +++ b/kernel/bpf/btf.c
>> @@ -3859,6 +3859,14 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>>         }
>>
>>         info->reg_type = PTR_TO_BTF_ID;
>> +
>> +       /* When we trace extension program, we want to get the context
>> +        * type of the program that the extension is attached to, so
>> +        * we can access the argument properly in the trace program.
>> +        */
>> +       if (tgt_prog && tgt_prog->type == BPF_PROG_TYPE_EXT)
>> +               tgt_prog = tgt_prog->aux->linked_prog;
>> +
>>         if (tgt_prog) {
>>                 ret = btf_translate_to_vmlinux(log, btf, t, tgt_prog->type, arg);
>
> I think it would be cleaner to move resolve_prog_type() from verifier.c
> and use that helper function here.

FYI, I've added a different version of this patch to my freplace
multi-attach series (since the approach here was incompatible with
that).

-Toke

