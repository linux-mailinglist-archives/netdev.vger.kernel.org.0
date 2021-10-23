Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBF9438562
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 22:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhJWUxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 16:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhJWUxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 16:53:41 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E932C061764
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 13:51:22 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id y132-20020a1c7d8a000000b0032ca5765d6cso3450034wmc.0
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 13:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kEwYolz4VIQFPnenm8oXWVvdwRHOXPlOP+RR+wPyyMI=;
        b=06JEttD3lkLMmYwZA7v20BFi0ChSC1HuE/WIfMGpHJ3GLAqNRNejK/SOi2TUcm42uj
         zZu91P0pwLg45Z+YuPt6mU9VaIxCfk+pSUzAG14+H8DdIDn5wLVKLTG6Sc5MeIO3sdLl
         wCwne/nQXbOHmeHQj3WEa1+yMSXYFcNCmVOMVzoB2bfVCDv0cUTf9MSduU87ZtbKJ2uO
         7JwDq7udefpO/RbuHFgi9u8O+YpYHOMHE/hZnAB8mwGPGIZ6mcXaXZag//KONy48vhU7
         +ZB3eXsWOV7nEQ+W5klnrlTGi6eERDOLGGn1PXdpkevIX5yB/MrgBmUtXpZghXSFGfNE
         bkfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kEwYolz4VIQFPnenm8oXWVvdwRHOXPlOP+RR+wPyyMI=;
        b=PCY+pWzPfiuak3ffdw5E0fDXQb6Dd+5AKigbKFPFt6rQ1h/ZsVNY4cb253aO1aFsED
         fC3YGGVfYIyyODMmN1NSjxdYCnVhX/1ZXPHGTcM//nsjxuebYgOW1blaR7E0MmTTeBa4
         jiAAE7wMPxR5pG/lAFpehmnmCHmdBSMVaAHWdzptQ/WzdZTj7j/H3PN+LykodU+2CXht
         8S8r/aCH6IlLUZ/a3wWYQT6xCIynO4692lZNEWmJ2Vo4uYzp1f859HBcF8mk9pwxoa00
         josKq90yfQRGjBxe3lsp813/OHKhFSI440mMMTOiClpNS3HfENP0Ry90U9REypzoiu44
         BXIA==
X-Gm-Message-State: AOAM532o6u5T49wFwfT711VlWKOpvBMuW5QpMQ9jv83Wp05vqevO09KF
        nVTtxrI31cpsTb8tugTP7VKSeljXiUjV3JI7
X-Google-Smtp-Source: ABdhPJxG+eX5S0wGZLbFkYGmCFnRP+E72bVW2eatzXWAVybX0k9F7RFqiV4mB21BZi+DCPIjaEf9xw==
X-Received: by 2002:a1c:7c0e:: with SMTP id x14mr8965699wmc.128.1635022280612;
        Sat, 23 Oct 2021 13:51:20 -0700 (PDT)
Received: from [192.168.1.11] ([149.86.74.50])
        by smtp.gmail.com with ESMTPSA id u5sm12156898wrg.57.2021.10.23.13.51.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Oct 2021 13:51:20 -0700 (PDT)
Message-ID: <88f7e7f6-1a60-f229-b5f7-570059c33597@isovalent.com>
Date:   Sat, 23 Oct 2021 21:51:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH bpf-next 3/5] bpftool: Switch to libbpf's hashmap for
 pinned paths of BPF objects
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20211022171647.27885-1-quentin@isovalent.com>
 <20211022171647.27885-4-quentin@isovalent.com>
 <CAEf4BzbgGSS6p5Xyx6Sp34hLZQ8XwQN7Fg6ykPZ5VHFw6doUJw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <CAEf4BzbgGSS6p5Xyx6Sp34hLZQ8XwQN7Fg6ykPZ5VHFw6doUJw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-10-22 17:54 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Fri, Oct 22, 2021 at 10:16 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> In order to show pinned paths for BPF programs, maps, or links when
>> listing them with the "-f" option, bpftool creates hash maps to store
>> all relevant paths under the bpffs. So far, it would rely on the
>> kernel implementation (from tools/include/linux/hashtable.h).
>>
>> We can make bpftool rely on libbpf's implementation instead. The
>> motivation is to make bpftool less dependent of kernel headers, to ease
>> the path to a potential out-of-tree mirror, like libbpf has.
>>
>> This commit is the first step of the conversion: the hash maps for
>> pinned paths for programs, maps, and links are converted to libbpf's
>> hashmap.{c,h}. Other hash maps used for the PIDs of process holding
>> references to BPF objects are left unchanged for now. On the build side,
>> this requires adding a dependency to a second header internal to libbpf,
>> and making it a dependency for the bootstrap bpftool version as well.
>> The rest of the changes are a rather straightforward conversion.
>>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
>>  tools/bpf/bpftool/Makefile |  8 +++---
>>  tools/bpf/bpftool/common.c | 50 ++++++++++++++++++++------------------
>>  tools/bpf/bpftool/link.c   | 35 ++++++++++++++------------
>>  tools/bpf/bpftool/main.h   | 29 +++++++++++++---------
>>  tools/bpf/bpftool/map.c    | 35 ++++++++++++++------------
>>  tools/bpf/bpftool/prog.c   | 35 ++++++++++++++------------
>>  6 files changed, 105 insertions(+), 87 deletions(-)
>>
> 
> [...]
> 
>> @@ -420,28 +421,20 @@ static int do_build_table_cb(const char *fpath, const struct stat *sb,
>>         if (bpf_obj_get_info_by_fd(fd, &pinned_info, &len))
>>                 goto out_close;
>>
>> -       obj_node = calloc(1, sizeof(*obj_node));
>> -       if (!obj_node) {
>> +       path = strdup(fpath);
>> +       if (!path) {
>>                 err = -1;
>>                 goto out_close;
>>         }
>>
>> -       obj_node->id = pinned_info.id;
>> -       obj_node->path = strdup(fpath);
>> -       if (!obj_node->path) {
>> -               err = -1;
>> -               free(obj_node);
>> -               goto out_close;
>> -       }
>> -
>> -       hash_add(build_fn_table->table, &obj_node->hash, obj_node->id);
>> +       hashmap__append(build_fn_table, u32_as_hash_field(pinned_info.id), path);
> 
> handle errors? operation can fail

Right, I missed it for hashmap__append(). I'll address everywhere.

> 
>>  out_close:
>>         close(fd);
>>  out_ret:
>>         return err;
>>  }
> 
> [...]
> 
>>
>>  unsigned int get_page_size(void)
>> @@ -962,3 +956,13 @@ int map_parse_fd_and_info(int *argc, char ***argv, void *info, __u32 *info_len)
>>
>>         return fd;
>>  }
>> +
>> +size_t bpftool_hash_fn(const void *key, void *ctx)
>> +{
>> +       return (size_t)key;
>> +}
>> +
>> +bool bpftool_equal_fn(const void *k1, const void *k2, void *ctx)
> 
> kind of too generic and too assuming function (hash_fn and
> equal_fn)... Maybe either use static functions near each hashmap use
> case, or name it to specify that it works when keys are ids?

Makes sense. I'll probably just rename them in that case, because the
functions are the same for all hash maps and I don't really feel like
having five copies of it.

> 
>> +{
>> +       return k1 == k2;
>> +}
> 
> [...]
> 
>> @@ -256,4 +247,18 @@ int do_filter_dump(struct tcmsg *ifinfo, struct nlattr **tb, const char *kind,
>>
>>  int print_all_levels(__maybe_unused enum libbpf_print_level level,
>>                      const char *format, va_list args);
>> +
>> +size_t bpftool_hash_fn(const void *key, void *ctx);
>> +bool bpftool_equal_fn(const void *k1, const void *k2, void *ctx);
>> +
>> +static inline void *u32_as_hash_field(__u32 x)
> 
> it's used for keys only, right? so u32_as_hash_key?

Yes for this patch, but we're calling it on a value in the following
patch, in build_btf_type_table(), to store the ID of a program or a map
associated to a given BTF object ID.

So I'll keep the current name here for v2, but I'll address all your
other comments.

Thanks for the review,
Quentin

