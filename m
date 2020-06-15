Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915631F936A
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 11:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgFOJab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 05:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728986AbgFOJab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 05:30:31 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7AAC05BD43
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 02:30:29 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j10so16324143wrw.8
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 02:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9PyDy+lPgxoS47WMp8ZmjVUGLv0r3brP/KQkZKhcDf8=;
        b=QxHl5WABvi0AL+F2pxxMoAFr08oZ+Hcui6cwFDypx35YFSL0Es2Q8c/7E2qjmqQeDY
         ZHzoFkQ0o1R1kpnUZ35sDvdJqo18UsHTTttKuVeBZN8M6eSBd+YlE7/qFYWOAN4hz7RM
         r8Xzi74Zc2P/s0mp2HXNJpozUXNVKKKdoeZkpcdeSjM0gmN79EAo6NpXA83+s3GMRtqK
         80Z9tXnU/UBJQZDB+HBwfWqsHpMymru2ikj12IXF0JEGCSd3HH9zAD0NzHq5ZiBrqwW6
         LgIhInt3CygXJlZ5d+Iez1d9sI1MbJrBL3ehL7kmlm4fw6+ET4pZ+3uyc6rc4jeMhsoc
         ULzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9PyDy+lPgxoS47WMp8ZmjVUGLv0r3brP/KQkZKhcDf8=;
        b=DABvVo1vC4BDiztr15hSIB+XP2fSxsbS/zIzBvL6++9sHWMwjGmRtxQMuS6GabPD2a
         vvLzvecYl1SSxtajqeKbmyiXb7JwIpp8acnnZxRLLW0Aq7iAExVV5rP9EvVEV9DTNsVJ
         a8fPqNAoLNHDK+brkv+kGkzDpct6scbyGyHLtlos1j5MJm4opTnIHk80vJPdiNnsKLUY
         xGIXCOwKWnLdHsHrAtWj5u1J13rqLpem3corHiSZqy2AOFsRCM2XgkyEMbFVfWGqaagv
         qdmqwblNNg2dhEjUh7Ea7E7afDl+cTpkfqWKXINSNGF+CJQCiI68DAvDAPVQ2tgEl9CP
         TvNA==
X-Gm-Message-State: AOAM531O0WbETsjKzk+HxvIA/cRTsMVjt6eAq/R/eLK5Wo6NTqsGN2lM
        0yeD3QouYZ1qi2+ZQzzl3ZWY0w==
X-Google-Smtp-Source: ABdhPJyRG3KlUcY+CCckIILFBLaJqYbI76Ry9vtXtMwXHBOkMiCqmBdTiK2f7E9UNTUKDkVbOkD5yQ==
X-Received: by 2002:a5d:4d4d:: with SMTP id a13mr28498697wru.252.1592213428587;
        Mon, 15 Jun 2020 02:30:28 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.184.27])
        by smtp.gmail.com with ESMTPSA id x8sm24129663wrs.43.2020.06.15.02.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 02:30:28 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 8/8] tools/bpftool: show PIDs with FDs open
 against BPF map/prog/link/btf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        Song Liu <songliubraving@fb.com>
References: <20200612223150.1177182-1-andriin@fb.com>
 <20200612223150.1177182-9-andriin@fb.com>
 <20200613034507.wjhd4z6dsda3pz7c@ast-mbp>
 <CAEf4BzaHVRxkiDbTGashiuakXFBRYvDsQmJ0O08xFijKXiAwSg@mail.gmail.com>
 <20200613221419.GB7488@kernel.org> <87pna01yzh.fsf@toke.dk>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <d2220bfb-db28-251a-66ca-6f3a6377c94f@isovalent.com>
Date:   Mon, 15 Jun 2020 10:30:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87pna01yzh.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-06-15 11:04 UTC+0200 ~ Toke Høiland-Jørgensen <toke@redhat.com>
> Arnaldo Carvalho de Melo <acme@kernel.org> writes:
> 
>> Em Fri, Jun 12, 2020 at 10:57:59PM -0700, Andrii Nakryiko escreveu:
>>> On Fri, Jun 12, 2020 at 8:45 PM Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>>>>
>>>> On Fri, Jun 12, 2020 at 03:31:50PM -0700, Andrii Nakryiko wrote:
>>>>> Add bpf_iter-based way to find all the processes that hold open FDs against
>>>>> BPF object (map, prog, link, btf). Add new flag (-o, for "ownership", given
>>>>> -p is already taken) to trigger collection and output of these PIDs.
>>>>>
>>>>> Sample output for each of 4 BPF objects:
>>>>>
>>>>> $ sudo ./bpftool -o prog show
>>>>> 1992: cgroup_skb  name egress_alt  tag 9ad187367cf2b9e8  gpl
>>>>>         loaded_at 2020-06-12T14:18:10-0700  uid 0
>>>>>         xlated 48B  jited 59B  memlock 4096B  map_ids 2074
>>>>>         btf_id 460
>>>>>         pids: 913709,913732,913733,913734
>>>>> 2062: cgroup_device  tag 8c42dee26e8cd4c2  gpl
>>>>>         loaded_at 2020-06-12T14:37:52-0700  uid 0
>>>>>         xlated 648B  jited 409B  memlock 4096B
>>>>>         pids: 1
>>>>>
>>>>> $ sudo ./bpftool -o map show
>>>>> 2074: array  name test_cgr.bss  flags 0x400
>>>>>         key 4B  value 8B  max_entries 1  memlock 8192B
>>>>>         btf_id 460
>>>>>         pids: 913709,913732,913733,913734
>>>>>
>>>>> $ sudo ./bpftool -o link show
>>>>> 82: cgroup  prog 1992
>>>>>         cgroup_id 0  attach_type egress
>>>>>         pids: 913709,913732,913733,913734
>>>>> 86: cgroup  prog 1992
>>>>>         cgroup_id 0  attach_type egress
>>>>>         pids: 913709,913732,913733,913734
>>>>
>>>> This is awesome.
>>
>> Indeed.
>>  
>>> Thanks.
>>>
>>>>
>>>> Why extra flag though? I think it's so useful that everyone would want to see
>>
>> Agreed.
>>  
>>> No good reason apart from "being safe by default". If turned on by
>>> default, bpftool would need to probe for bpf_iter support first. I can
>>> add probing and do this by default.
>>
>> I think this is the way to go.
> 
> +1
> 
> And also +1 on the awesomeness of this feature! :)
> 
> -Toke
> 

Thanks a lot Andrii, the feature looks great indeed.

Thank you for the clean-up and refactoring in bpftool and its Makefile
as well, I am happy to confirm that test_bpftool_build.sh still passes
on my setup with your changes.

Quentin
