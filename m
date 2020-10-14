Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258B228DB0A
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 10:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgJNITk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 04:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728946AbgJNITe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 04:19:34 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910A7C051133;
        Wed, 14 Oct 2020 01:10:51 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e23so1395177wme.2;
        Wed, 14 Oct 2020 01:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qc0X0ueFIug2eGcCkUWiSsZWwEmCO9v7Zz71O8TUyKM=;
        b=GGZEfs1dcXE+rh/hnCbHJsLLjIIU7I2vGVWw1fn6bcMxg9sO1CkxP0Ps0H0vesVIJH
         vcQwoI0qu+VDa5d8J9I0KNaif2TZYHWZ5qTJ/TScF3XhB9SFGcCJCy6iUCqTmj+o9JM7
         MwrbK6ORdi2MeDnP7Hcl7nnSdz5RsorhulznRlB4vRTlk39j8KpwR/vyZseJ2cTBM6Q9
         eAIMIk3lQlmb+CMfUoqk234RBvpQa4gxjjQjQPPiRAoK0ecaV/NTMgdNHpMHAdN5/B4V
         1331vz+K8WGSiGcLVXnscvis57+DiqK8K9T0WfA8C+ZKwDM1MM8C7wA06tpblZq18BCR
         XBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qc0X0ueFIug2eGcCkUWiSsZWwEmCO9v7Zz71O8TUyKM=;
        b=XJGH41rWuUPXrlNMOOCoibj6XpyOeY9zlL6GSZQGwxFBUJHHBCndYNgVOZ5GJZrBSs
         /+G9UQDO3O5GlzmpQi6roNLXSccDpTNN5yq6ZcfGipMsN/3RV1QMhBh+sIvvu7f7freg
         MB9CuqGOuS/GAPxhGwbzvdVcn0pqEN0HHfvFc4igC7omo5f342rajZnSc/Hz8FeqjoRQ
         Z14qesFcxQJFXuDpUl+872A0HhXjc3pFKe11Hofs89rEPvGD1/yAJ4kihg8G2QVDWATA
         PH05+faONbSXbuLZ+1cKWss6Fxw4QSor7md96R5oO47xSqul4RbUEw9pyPnvM0tVQzq5
         2CPg==
X-Gm-Message-State: AOAM5301domGUCo578n6JulCHZ/PZQyuU5K7sMwTPxQhG+oJheMhdUPA
        VgLXYpM0moGVtF1Mqp0u60E=
X-Google-Smtp-Source: ABdhPJwhCHCouzh8PJqucNZwvw+b2q8Z7MV7MiNRhOtSLcZK+MB/vqLLSJDLcCWq6MUAgwWJZ6HMcw==
X-Received: by 2002:a05:600c:2189:: with SMTP id e9mr2102016wme.153.1602663049207;
        Wed, 14 Oct 2020 01:10:49 -0700 (PDT)
Received: from [192.168.8.147] ([37.167.96.60])
        by smtp.gmail.com with ESMTPSA id l3sm2399496wmg.32.2020.10.14.01.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 01:10:48 -0700 (PDT)
Subject: Re: [PATCH net v2] net: fix pos incrementment in ipv6_route_seq_next
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Vasily Averin <vvs@virtuozzo.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20201013183121.1988411-1-yhs@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f1a37830-f86a-57ba-aba8-7b15e91d0481@gmail.com>
Date:   Wed, 14 Oct 2020 10:10:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201013183121.1988411-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/20 8:31 PM, Yonghong Song wrote:
> Commit 4fc427e05158 ("ipv6_route_seq_next should increase position index")
> tried to fix the issue where seq_file pos is not increased
> if a NULL element is returned with seq_ops->next(). See bug
>   https://bugzilla.kernel.org/show_bug.cgi?id=206283
> The commit effectively does:
>   - increase pos for all seq_ops->start()
>   - increase pos for all seq_ops->next()
> 
> For ipv6_route, increasing pos for all seq_ops->next() is correct.
> But increasing pos for seq_ops->start() is not correct
> since pos is used to determine how many items to skip during
> seq_ops->start():
>   iter->skip = *pos;
> seq_ops->start() just fetches the *current* pos item.
> The item can be skipped only after seq_ops->show() which essentially
> is the beginning of seq_ops->next().
> 
> For example, I have 7 ipv6 route entries,
>   root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=4096
>   00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
>   fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>   fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000004 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   0+1 records in
>   0+1 records out
>   1050 bytes (1.0 kB, 1.0 KiB) copied, 0.00707908 s, 148 kB/s
>   root@arch-fb-vm1:~/net-next
> 
> In the above, I specify buffer size 4096, so all records can be returned
> to user space with a single trip to the kernel.
> 
> If I use buffer size 128, since each record size is 149, internally
> kernel seq_read() will read 149 into its internal buffer and return the data
> to user space in two read() syscalls. Then user read() syscall will trigger
> next seq_ops->start(). Since the current implementation increased pos even
> for seq_ops->start(), it will skip record #2, #4 and #6, assuming the first
> record is #1.
> 
>   root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=128
>   00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
> 4+1 records in
> 4+1 records out
> 600 bytes copied, 0.00127758 s, 470 kB/s
> 
> To fix the problem, create a fake pos pointer so seq_ops->start()
> won't actually increase seq_file pos. With this fix, the
> above `dd` command with `bs=128` will show correct result.
> 
> Fixes: 4fc427e05158 ("ipv6_route_seq_next should increase position index")
> Cc: Vasily Averin <vvs@virtuozzo.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Suggested-by: Vasily Averin <vvs@virtuozzo.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  net/ipv6/ip6_fib.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Changelog:
>  v1 -> v2:
>   - instead of push increment of *pos in ipv6_route_seq_next() for
>     seq_ops->next() only. Add a face pos pointer in seq_ops->start()
>     and use it when calling ipv6_route_seq_next().
> 
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 141c0a4c569a..e633b2b7deda 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -2622,8 +2622,10 @@ static void *ipv6_route_seq_start(struct seq_file *seq, loff_t *pos)
>  	iter->skip = *pos;
>  
>  	if (iter->tbl) {
> +		loff_t p;

Please init this, otherwise I can guarantee syzbot will be not happy.

                p = *pos;

> +
>  		ipv6_route_seq_setup_walk(iter, net);
> -		return ipv6_route_seq_next(seq, NULL, pos);
> +		return ipv6_route_seq_next(seq, NULL, &p);
>  	} else {
>  		return NULL;
>  	}
> 
