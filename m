Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A074464A34
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242325AbhLAI62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242275AbhLAI62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:58:28 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C000FC061748
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 00:55:07 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 8so23681263pfo.4
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 00:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=mt/YlklWkFfS0yF9ibH5y9vze0Bq+Suaib2gnljcJYo=;
        b=3YYZed+piS7K/gTSgnfvhD1SRxp2O7IBmLBWqi60Usump9lWTzvjKGhBpyRaYIJGMT
         8WI0WRn1SntqS58r3pdn4TqHnedXJ4RYNxfOS34FM37un+RAtR5RWpvVFEkiX7KMoOSd
         lJIdnUmny0O2GOtHJHIJ6i8z+u2whdfEdPFGrlosfRXerPzQfxOzgbxi7sHtui5sV5hk
         U7dpxP56xs4y2Je+2pq50IOzkwE8QWKc7TqA8CyBx7tgjORnrdA+4UH4MFXGCK1sb4z/
         hhwc9oJCn90yTp78hdeuhbPnxUsFrBTEphnswentIxkAwOOvFXIP1GJevkMY8PnRd8SR
         MuiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mt/YlklWkFfS0yF9ibH5y9vze0Bq+Suaib2gnljcJYo=;
        b=HSNDhEqkjUSOJ/Q6Tsca8DqloVDNMWoqkVk2rMELx77ZC9VifpfPV+G/hLSninDsD7
         PspRNpWMuZN8VEsZ/7dz0n+/uW61aNI4jyERRqPDsV5l2o27w9xWxR1vKzFQzVgD8Jgk
         P8J/irvG2bOzyTO1ievciC8Crk3N0yrh/NgF9HCqd8cGtK5YagirvHU+CEh8dfH8v0NS
         1wQBadct1kOT2RmmLdc+tndxwoyUxCSaAt8HsjG/YbB02Nzxv5yTES1PCPAC/dZFdZdD
         mLe18I2Qbb+6EMJbInbJlIPFQE8GcypKYEqFNg8sPoeak2nM1JF3Nb3OYyqlV/u1k3f0
         uG7Q==
X-Gm-Message-State: AOAM532T/0VKAdgE/Nahcr9D0mwaWdhF2XXiHBIqNunYQJzHWdVLC3ZT
        SzwbXmkGv5S+w7ex2HQVG76UAA==
X-Google-Smtp-Source: ABdhPJyxyU1omAYWJhDtt9f1AO8aXE21k8E+M9SeJXuvKEvtelwSGmLKAIaotW2gqLUqGcAzMvNRKQ==
X-Received: by 2002:a63:5f8d:: with SMTP id t135mr3615084pgb.610.1638348907287;
        Wed, 01 Dec 2021 00:55:07 -0800 (PST)
Received: from [10.86.117.166] ([139.177.225.236])
        by smtp.gmail.com with ESMTPSA id i185sm23314189pfg.80.2021.12.01.00.54.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 00:55:06 -0800 (PST)
Message-ID: <e18fb59e-040f-7edf-bb15-37c75bbd28a8@bytedance.com>
Date:   Wed, 1 Dec 2021 16:54:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [External] Re: [PATCH bpf-next] libbpf: Let any two INT/UNION
 compatible if their names and sizes match
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Muchun Song <songmuchun@bytedance.com>,
        zhouchengming@bytedance.com
References: <20211201035450.31083-1-zhoufeng.zf@bytedance.com>
 <CAEf4BzZ5Q9QkRGsT2kW+3AW4s7=qixJYO84heeu64TLG9DP3+A@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAEf4BzZ5Q9QkRGsT2kW+3AW4s7=qixJYO84heeu64TLG9DP3+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2021/12/1 下午12:17, Andrii Nakryiko 写道:
> On Tue, Nov 30, 2021 at 7:55 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>
>> commit:67c0496e87d193b8356d2af49ab95e8a1b954b3c(kernfs: convert
>> kernfs_node->id from union kernfs_node_id to u64).
>>
>> The bpf program compiles on the kernel version after this commit and
>> then tries to run on the kernel before this commit, libbpf will report
>> an error. The reverse is also same.
>>
>> libbpf: prog 'tcp_retransmit_synack_tp': relo #4: kind <byte_off> (0),
>> spec is [342] struct kernfs_node.id (0:9 @ offset 104)
>> libbpf: prog 'tcp_retransmit_synack_tp': relo #4: non-matching candidate
>> libbpf: prog 'tcp_retransmit_synack_tp': relo #4: non-matching candidate
>> libbpf: prog 'tcp_retransmit_synack_tp': relo #4: no matching targets
>> found
>>
>> The type before this commit:
>>          union kernfs_node_id    id;
>>          union kernfs_node_id {
>>                  struct {
>>                          u32             ino;
>>                          u32             generation;
>>                  };
>>                  u64                     id;
>>          };
>>
>> The type after this commit:
>>          u64 id;
>>
>> We can find that the variable name and size have not changed except for
>> the type change.
>> So I added some judgment to let any two INT/UNION are compatible, if
>> their names and sizes match.
>>
>> Reported-by: Chengming Zhou <zhouchengming@bytedance.com>
>> Tested-by: Chengming Zhou <zhouchengming@bytedance.com>
>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>> ---
> This should be handled by application, not by hacking libbpf's CO-RE
> relocation logic. See [0] for how this should be done with existing
> BPF CO-RE mechanisms.
>
>    [0] https://nakryiko.com/posts/bpf-core-reference-guide/#handling-incompatible-field-and-type-changes

This is very useful to me, thank you very much.

>>   tools/lib/bpf/relo_core.c | 21 +++++++++++++++++----
>>   1 file changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
>> index b5b8956a1be8..ff7f4e97bafb 100644
>> --- a/tools/lib/bpf/relo_core.c
>> +++ b/tools/lib/bpf/relo_core.c
>> @@ -294,6 +294,7 @@ static int bpf_core_parse_spec(const struct btf *btf,
>>    *   - any two FLOATs are always compatible;
>>    *   - for ARRAY, dimensionality is ignored, element types are checked for
>>    *     compatibility recursively;
>> + *   - any two INT/UNION are compatible, if their names and sizes match;
>>    *   - everything else shouldn't be ever a target of relocation.
>>    * These rules are not set in stone and probably will be adjusted as we get
>>    * more experience with using BPF CO-RE relocations.
>> @@ -313,8 +314,14 @@ static int bpf_core_fields_are_compat(const struct btf *local_btf,
>>
>>          if (btf_is_composite(local_type) && btf_is_composite(targ_type))
>>                  return 1;
>> -       if (btf_kind(local_type) != btf_kind(targ_type))
>> -               return 0;
>> +       if (btf_kind(local_type) != btf_kind(targ_type)) {
>> +               if (local_type->size == targ_type->size &&
>> +                   (btf_is_union(local_type) || btf_is_union(targ_type)) &&
>> +                   (btf_is_int(local_type) || btf_is_int(targ_type)))
>> +                       return 1;
>> +               else
>> +                       return 0;
>> +       }
>>
>>          switch (btf_kind(local_type)) {
>>          case BTF_KIND_PTR:
>> @@ -384,11 +391,17 @@ static int bpf_core_match_member(const struct btf *local_btf,
>>          targ_type = skip_mods_and_typedefs(targ_btf, targ_id, &targ_id);
>>          if (!targ_type)
>>                  return -EINVAL;
>> -       if (!btf_is_composite(targ_type))
>> -               return 0;
>>
>>          local_id = local_acc->type_id;
>>          local_type = btf__type_by_id(local_btf, local_id);
>> +       if (!btf_is_composite(targ_type)) {
>> +               if (local_type->size == targ_type->size &&
>> +                   btf_is_union(local_type) && btf_is_int(targ_type))
>> +                       return 1;
>> +               else
>> +                       return 0;
>> +       }
>> +
>>          local_member = btf_members(local_type) + local_acc->idx;
>>          local_name = btf__name_by_offset(local_btf, local_member->name_off);
>>
>> --
>> 2.11.0
>>

