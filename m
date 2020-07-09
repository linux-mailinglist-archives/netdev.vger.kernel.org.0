Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73AF21A40E
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 17:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgGIPvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 11:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGIPvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 11:51:46 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A531EC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 08:51:45 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id s16so1418641lfp.12
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 08:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=i1vTe+zF2JiNvwmHr9QoSQ5TpSuREwn9q25p9eKOW6A=;
        b=ZuEJuiQffnD3R3vZwOTl/vip08oARu4Jb2uwtsMFZM/4y94c9TUStkpbn4tlQGyzBD
         2KtdM3WrJUhdPdnsnQHERnEM6nMcAFUJ87SouV8KDl1RcI+TROApFJR7LZdABX3V9GHQ
         ue9OsmBeBk+M2a7Cx9Y1ECL74e03be+a9jHus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=i1vTe+zF2JiNvwmHr9QoSQ5TpSuREwn9q25p9eKOW6A=;
        b=QUBzH13tumwXhTGMvZfsbaKPy7UnpkE21bf3kPr+0Cp1YPQoXl3M3B40Dl4Wj2pBjz
         pldUZ0yuowGc4EGzPhPl8MO0F3GueZIEgizN+Sj8BvC56YoAQh7JsM/GZI5hAYpYW3S1
         oXEKaySGADHszB13d08gYjuZpxZWQpCpadisppAXEMQUbGEj9cW8ObP18P/wOUKuVAwn
         Qm0d0DPhkkAinn3KRDB8E11ffLWlCM82OciKibBVJx5QSlcqESE96Xut7yR/wijmPs0Z
         IekIuY9Uk1oh8w9Dab+zr0LUYl7fhTz2mVN3vXapvAWqr32Deb91f56kT/rIAuFnLZfp
         aW6Q==
X-Gm-Message-State: AOAM530eE1QcY8tOMkJkt6xu3XQHhg1ZNJ8I1nLfZHtIwRZiVxMBePTZ
        zwKdg5xLkKX9TvG9TD900vLCYQ==
X-Google-Smtp-Source: ABdhPJzShMBJ7LvrhAgbuJHS4KMMqdanfazkGofu8+nZ5MN7qGPhhDszucP3r25ua3ZCwIWFJTAmRg==
X-Received: by 2002:ac2:4422:: with SMTP id w2mr40027090lfl.152.1594309904039;
        Thu, 09 Jul 2020 08:51:44 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id n4sm1059201lfl.40.2020.07.09.08.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 08:51:43 -0700 (PDT)
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-13-jakub@cloudflare.com> <CAEf4BzbrUZhpxfw_eeJJCoo46_x1Y8naE19qoVUWi5sTSNSdzA@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next v3 12/16] libbpf: Add support for SK_LOOKUP program type
In-reply-to: <CAEf4BzbrUZhpxfw_eeJJCoo46_x1Y8naE19qoVUWi5sTSNSdzA@mail.gmail.com>
Date:   Thu, 09 Jul 2020 17:51:42 +0200
Message-ID: <87h7ugadpt.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 06:23 AM CEST, Andrii Nakryiko wrote:
> On Thu, Jul 2, 2020 at 2:25 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Make libbpf aware of the newly added program type, and assign it a
>> section name.
>>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>
>> Notes:
>>     v3:
>>     - Move new libbpf symbols to version 0.1.0.
>>     - Set expected_attach_type in probe_load for new prog type.
>>
>>     v2:
>>     - Add new libbpf symbols to version 0.0.9. (Andrii)
>>
>>  tools/lib/bpf/libbpf.c        | 3 +++
>>  tools/lib/bpf/libbpf.h        | 2 ++
>>  tools/lib/bpf/libbpf.map      | 2 ++
>>  tools/lib/bpf/libbpf_probes.c | 3 +++
>>  4 files changed, 10 insertions(+)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 4ea7f4f1a691..ddcbb5dd78df 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -6793,6 +6793,7 @@ BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
>>  BPF_PROG_TYPE_FNS(tracing, BPF_PROG_TYPE_TRACING);
>>  BPF_PROG_TYPE_FNS(struct_ops, BPF_PROG_TYPE_STRUCT_OPS);
>>  BPF_PROG_TYPE_FNS(extension, BPF_PROG_TYPE_EXT);
>> +BPF_PROG_TYPE_FNS(sk_lookup, BPF_PROG_TYPE_SK_LOOKUP);
>>
>>  enum bpf_attach_type
>>  bpf_program__get_expected_attach_type(struct bpf_program *prog)
>> @@ -6969,6 +6970,8 @@ static const struct bpf_sec_def section_defs[] = {
>>         BPF_EAPROG_SEC("cgroup/setsockopt",     BPF_PROG_TYPE_CGROUP_SOCKOPT,
>>                                                 BPF_CGROUP_SETSOCKOPT),
>>         BPF_PROG_SEC("struct_ops",              BPF_PROG_TYPE_STRUCT_OPS),
>> +       BPF_EAPROG_SEC("sk_lookup",             BPF_PROG_TYPE_SK_LOOKUP,
>> +                                               BPF_SK_LOOKUP),
>
> So it's a BPF_PROG_TYPE_SK_LOOKUP with attach type BPF_SK_LOOKUP. What
> other potential attach types could there be for
> BPF_PROG_TYPE_SK_LOOKUP? How the section name will look like in that
> case?

BPF_PROG_TYPE_SK_LOOKUP won't have any other attach types that I can
forsee. There is a single attach type shared by tcp4, tcp6, udp4, and
udp6 hook points. If we hook it up in the future say to sctp, I expect
the same attach point will be reused.

>
>>  };
>>
>>  #undef BPF_PROG_SEC_IMPL
>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>> index 2335971ed0bd..c2272132e929 100644
>> --- a/tools/lib/bpf/libbpf.h
>> +++ b/tools/lib/bpf/libbpf.h
>> @@ -350,6 +350,7 @@ LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
>>  LIBBPF_API int bpf_program__set_tracing(struct bpf_program *prog);
>>  LIBBPF_API int bpf_program__set_struct_ops(struct bpf_program *prog);
>>  LIBBPF_API int bpf_program__set_extension(struct bpf_program *prog);
>> +LIBBPF_API int bpf_program__set_sk_lookup(struct bpf_program *prog);
>>
>>  LIBBPF_API enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog);
>>  LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
>> @@ -377,6 +378,7 @@ LIBBPF_API bool bpf_program__is_perf_event(const struct bpf_program *prog);
>>  LIBBPF_API bool bpf_program__is_tracing(const struct bpf_program *prog);
>>  LIBBPF_API bool bpf_program__is_struct_ops(const struct bpf_program *prog);
>>  LIBBPF_API bool bpf_program__is_extension(const struct bpf_program *prog);
>> +LIBBPF_API bool bpf_program__is_sk_lookup(const struct bpf_program *prog);
>>
>>  /*
>>   * No need for __attribute__((packed)), all members of 'bpf_map_def'
>> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
>> index 6544d2cd1ed6..04b99f63a45c 100644
>> --- a/tools/lib/bpf/libbpf.map
>> +++ b/tools/lib/bpf/libbpf.map
>> @@ -287,5 +287,7 @@ LIBBPF_0.1.0 {
>>                 bpf_map__type;
>>                 bpf_map__value_size;
>>                 bpf_program__autoload;
>> +               bpf_program__is_sk_lookup;
>>                 bpf_program__set_autoload;
>> +               bpf_program__set_sk_lookup;
>>  } LIBBPF_0.0.9;
>> diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
>> index 10cd8d1891f5..5a3d3f078408 100644
>> --- a/tools/lib/bpf/libbpf_probes.c
>> +++ b/tools/lib/bpf/libbpf_probes.c
>> @@ -78,6 +78,9 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
>>         case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
>>                 xattr.expected_attach_type = BPF_CGROUP_INET4_CONNECT;
>>                 break;
>> +       case BPF_PROG_TYPE_SK_LOOKUP:
>> +               xattr.expected_attach_type = BPF_SK_LOOKUP;
>> +               break;
>>         case BPF_PROG_TYPE_KPROBE:
>>                 xattr.kern_version = get_kernel_version();
>>                 break;
>> --
>> 2.25.4
>>
