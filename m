Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1563D3816
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhGWJML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 05:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbhGWJMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 05:12:10 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0608EC061757
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 02:52:44 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id j6-20020a05600c1906b029023e8d74d693so1254235wmq.3
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 02:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XVfmLROS6zWD9ahsrkRPG/Htb6Q850jRPmTPvGrU1mE=;
        b=rn56to9toHYdSIaifDEc+qaurH//AIkPrOIvKiLySOTFKGsJX04LP7K9LqztvsxaoT
         LDdV9NS2cWVoqE+O7/G3CzgjKp0oI6RVIqhc0yj8bgzFXKeOAH5Af2Psa7D0cBGWG/B7
         2po968e791BJHD6TzKNpke+YywrUItABhKizRrhCkgjhrAk41wFlaiUhR/zKg1Eiwbtv
         UlV+uw9Q3Stb+wy+St33yswgRyV0S8dHXCJBHHAeTgL6XvvX6I1f7P2FJDJeGoqMy10R
         Re0ctDp8y9p1aPwFmqgaO5WVXG+yRGeCBbbjFTIcMNluJhrDGNGM9AHBoCmToQfqU5pe
         YzYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XVfmLROS6zWD9ahsrkRPG/Htb6Q850jRPmTPvGrU1mE=;
        b=Wi+oqaiuv/RzfUKsZqd2CYbWfBDt952IpNBd1caliZgAld7GmZtVEy31iLnbe6FJSe
         aLtAJHF4Fe1FnfO7wJqqf1hSes7yGfiegHpC9OoA11m4az5fdcD4RrlcjwyGbg0LTcS+
         ouiUiM40P68G4m4M86eB4ODatR5qrR5i+MHCJt++L4yqq/cf0Lz1chc4+nG/IAEOCMRJ
         3jS8a727AthWzUHj/BY3nfmQujvtY2sfnr2RoamMYucTu43XGpGM3adZsSbNmfI1uxEa
         4ng3ITIVmuvICTmuDK5GdDNmNTPCZZ3NdqDxaGwC0SqK40lr1aaE5iYGCPjv4WHUT7Uh
         njOA==
X-Gm-Message-State: AOAM533hd6FTZPyTez4RtsOkXhStsiuopdhaCXTaGyJQ8qUB5L9Qe3WW
        +7PloL1sKWMxW5aTzfPGMeqXZQ==
X-Google-Smtp-Source: ABdhPJxOL5iR9IuziP9Adhe+mzKQHQ4+ZNRUiBXIBJKXA9B/oSTmzMo4Z6I4BM7vOQuXADZaau6JaA==
X-Received: by 2002:a7b:cbd5:: with SMTP id n21mr13464446wmi.2.1627033962618;
        Fri, 23 Jul 2021 02:52:42 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.77.94])
        by smtp.gmail.com with ESMTPSA id z11sm32184405wru.65.2021.07.23.02.52.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 02:52:41 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 3/5] tools: replace btf__get_from_id() with
 btf__load_from_kernel_by_id()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <20210721153808.6902-1-quentin@isovalent.com>
 <20210721153808.6902-4-quentin@isovalent.com>
 <CAEf4BzatvJORZvkz37_XJxvk5+Amr8V8iHq=1_4k_uCz0fE-eQ@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <3802e42d-321f-6580-8d6a-f862ac4f62da@isovalent.com>
Date:   Fri, 23 Jul 2021 10:52:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzatvJORZvkz37_XJxvk5+Amr8V8iHq=1_4k_uCz0fE-eQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-07-22 17:48 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> Replace the calls to deprecated function btf__get_from_id() with calls
>> to btf__load_from_kernel_by_id() in tools/ (bpftool, perf, selftests).
>> Update the surrounding code accordingly (instead of passing a pointer to
>> the btf struct, get it as a return value from the function). Also make
>> sure that btf__free() is called on the pointer after use.
>>
>> v2:
>> - Given that btf__load_from_kernel_by_id() has changed since v1, adapt
>>   the code accordingly instead of just renaming the function. Also add a
>>   few calls to btf__free() when necessary.
>>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>> ---
>>  tools/bpf/bpftool/btf.c                      |  8 ++----
>>  tools/bpf/bpftool/btf_dumper.c               |  6 ++--
>>  tools/bpf/bpftool/map.c                      | 16 +++++------
>>  tools/bpf/bpftool/prog.c                     | 29 ++++++++++++++------
>>  tools/perf/util/bpf-event.c                  | 11 ++++----
>>  tools/perf/util/bpf_counter.c                | 12 ++++++--
>>  tools/testing/selftests/bpf/prog_tests/btf.c |  4 ++-
>>  7 files changed, 51 insertions(+), 35 deletions(-)
>>
> 
> [...]
> 
>> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
>> index 09ae0381205b..12787758ce03 100644
>> --- a/tools/bpf/bpftool/map.c
>> +++ b/tools/bpf/bpftool/map.c
>> @@ -805,12 +805,11 @@ static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
>>                 }
>>                 return btf_vmlinux;
>>         } else if (info->btf_value_type_id) {
>> -               int err;
>> -
>> -               err = btf__get_from_id(info->btf_id, &btf);
>> -               if (err || !btf) {
>> +               btf = btf__load_from_kernel_by_id(info->btf_id);
>> +               if (libbpf_get_error(btf)) {
>>                         p_err("failed to get btf");
>> -                       btf = err ? ERR_PTR(err) : ERR_PTR(-ESRCH);
>> +                       if (!btf)
>> +                               btf = ERR_PTR(-ESRCH);
> 
> why not do a simpler (less conditionals)
> 
> err = libbpf_get_error(btf);
> if (err) {
>     btf = ERR_PTR(err);
> }
> 
> ?

Because if btf is NULL at this stage, this would change the return value
from -ESRCH to NULL. This would be problematic in mapdump(), since we
check this value ("if (IS_ERR(btf))") to detect a failure in
get_map_kv_btf().

I could change that check in mapdump() to use libbpf_get_error()
instead, but in that case it would similarly change the return value for
mapdump() (and errno), which I think would be propagated up to main()
and would return 0 instead of -ESRCH. This does not seem suitable and
would play badly with batch mode, among other things.

So I'm considering keeping the one additional if.

> 
>>                 }
>>         }
>>
>> @@ -1039,11 +1038,10 @@ static void print_key_value(struct bpf_map_info *info, void *key,
>>                             void *value)
>>  {
>>         json_writer_t *btf_wtr;
>> -       struct btf *btf = NULL;
>> -       int err;
>> +       struct btf *btf;
>>
>> -       err = btf__get_from_id(info->btf_id, &btf);
>> -       if (err) {
>> +       btf = btf__load_from_kernel_by_id(info->btf_id);
>> +       if (libbpf_get_error(btf)) {
>>                 p_err("failed to get btf");
>>                 return;
>>         }
> 
> [...]
> 
>>
>>         func_info = u64_to_ptr(info->func_info);
>> @@ -781,6 +784,8 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
>>                 kernel_syms_destroy(&dd);
>>         }
>>
>> +       btf__free(btf);
>> +
> 
> warrants a Fixes: tag?

I don't mind adding the tags, but do they have any advantage here? My
understanding is that they tend to be neon signs for backports to stable
branches, but this patch depends on btf__load_from_kernel_by_id(),
meaning more patches to pull. I'll see if I can move the btf__free()
fixes to a separate commit, maybe.
