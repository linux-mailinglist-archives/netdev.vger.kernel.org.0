Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5429B30F3C8
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 14:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbhBDNUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 08:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236029AbhBDNUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 08:20:39 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422ACC061573
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 05:19:59 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id es14so1667433qvb.3
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 05:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OO56TMnidPIMl+cljOMxZhsTJu5cDh1llnEfgrlFdMw=;
        b=PIPPcJraCICnhlYMduc6gbQQFfQ/DPDJYS5LbABE/sxe5ivibE/FAbIliA+Fy+UAm3
         xFAQBFT+FnYz7RgBnvPIHlc7/TQ4JHrr4DtIeqe1YaAJBHpmSKv6yd3QBUXgBNLTNWb+
         GMRVjjn9Zq+T+ulnBbPLP3LTeEwD+lB+aV7tvFMhLWw7qSMQ/RiDPs+RG6NvX0GGEtP5
         myco3qByrQ2gUqk5cZJac7490KW4BfvsV5KkjpYtsCqz44nt2sOwqT+/ANhqdWOTdLq1
         USCs6iKEuTvoFrrcFztxWldlr4dVh8Zt/ew+T9erXbG3SRVlHB7K+p52P6JkERnsfU2+
         T+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OO56TMnidPIMl+cljOMxZhsTJu5cDh1llnEfgrlFdMw=;
        b=f775oxqrTZNXjd840rYw3KSY3q2xjRV7e7bIMMDNorHHujsARknLbKlLiu+tnmpQ2P
         XU6vqGTfhWpTy8hVaWRfTYhuVhSJ/ODAnq8jZaa7URZmbF47MueAt07apMg5P8uIVM3s
         pkASEWQjFTa/SECv2dWBPMRxp6Bj9stqdBCKIAM3jvS2GOJbXo7Rd14SD/3Jbdeh4pNB
         u86ZjZRypsBX6lO8YldpRvEmPmtJxKeWhaZrm/cXPSFJw7+KhNg8MUun2KJqifFRb7Ks
         JXHk8Axtr80DXXBzi9KpG67m6XlBetJGEUuquF0VfrFhkpG9CS+JMEmIQLtqcOShwJ2w
         uhkA==
X-Gm-Message-State: AOAM530O3/9w5YHsuQ2k26euhzCwc3vJtAHuFDuIXz66FuuJpJIQxn0o
        qqVCZ2ev89MwoNu+34ikVdX4JVYbN8Pguw==
X-Google-Smtp-Source: ABdhPJy/enWJjkBjeqS8jB2wK4uIiUxnNlh8FcxG38jC5R4ro9y589KV5pHG3vG6Jg4vJ73dl9njgQ==
X-Received: by 2002:a0c:ab16:: with SMTP id h22mr7372933qvb.44.1612444798132;
        Thu, 04 Feb 2021 05:19:58 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id z5sm5285336qkc.61.2021.02.04.05.19.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 05:19:56 -0800 (PST)
Subject: Re: [iproute PATCH] tc: u32: Fix key folding in sample option
To:     Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20210202183051.21022-1-phil@nwl.cc>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <6948a2a9-1ed2-ce8d-daeb-601c425e1258@mojatatu.com>
Date:   Thu, 4 Feb 2021 08:19:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210202183051.21022-1-phil@nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Phil,

I couldnt tell by inspection if what used to work before continues to.
In particular the kernel version does consider the divisor when folding.

Two examples that currently work, if you can try them:

Most used scheme:
---
tc filter add dev $DEV parent 999:0  protocol ip prio 10 u32 \
ht 2:: \
sample ip protocol 1 0xff match ip src 1.2.3.4/32 flowid 1:10 \
action ok
----

and this i also found in one of my scripts:
----
tc filter add dev $DEV parent 999:0  protocol ip prio 10 u32 \
ht 2:: \
sample u32 0x00000806 0x0000ffff at 12 \
match u32 0x00000800 0x0000ff00 at 12 flowid 1:10 \
action ok
----

Probably a simple meaning of "working" is:
the values before and after (your changes) are consistent.

If also you will do us a kindness and add maybe a testcase in tdc?
This way next person wanting to fix it can run the tests first before
posting a patch.

cheers,
jamal

On 2021-02-02 1:30 p.m., Phil Sutter wrote:
> In between Linux kernel 2.4 and 2.6, key folding for hash tables changed
> in kernel space. When iproute2 dropped support for the older algorithm,
> the wrong code was removed and kernel 2.4 folding method remained in
> place. To get things functional for recent kernels again, restoring the
> old code alone was not sufficient - additional byteorder fixes were
> needed.
> 
> While being at it, make use of ffs() and thereby align the code with how
> kernel determines the shift width.
> 
> Fixes: 267480f55383c ("Backout the 2.4 utsname hash patch.")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Initially I considered changing the kernel's key folding instead as the
> old method didn't just ignore key bits beyond the first byte. Yet I am
> not sure if this would cause problems with hardware offloading. And
> given the fact that this simplified key folding is in place since the
> dawn of 2.6, it is probably not such a big problem anyway.
> ---
>   tc/f_u32.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/tc/f_u32.c b/tc/f_u32.c
> index 2ed5254a40d5f..a5747f671e1ea 100644
> --- a/tc/f_u32.c
> +++ b/tc/f_u32.c
> @@ -978,6 +978,13 @@ show_k:
>   	goto show_k;
>   }
>   
> +static __u32 u32_hash_fold(struct tc_u32_key *key)
> +{
> +	__u8 fshift = key->mask ? ffs(ntohl(key->mask)) - 1 : 0;
> +
> +	return ntohl(key->val & key->mask) >> fshift;
> +}
> +
>   static int u32_parse_opt(struct filter_util *qu, char *handle,
>   			 int argc, char **argv, struct nlmsghdr *n)
>   {
> @@ -1110,9 +1117,7 @@ static int u32_parse_opt(struct filter_util *qu, char *handle,
>   				}
>   				NEXT_ARG();
>   			}
> -			hash = sel2.keys[0].val & sel2.keys[0].mask;
> -			hash ^= hash >> 16;
> -			hash ^= hash >> 8;
> +			hash = u32_hash_fold(&sel2.keys[0]);
>   			htid = ((hash % divisor) << 12) | (htid & 0xFFF00000);
>   			sample_ok = 1;
>   			continue;
> 

