Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8CF3F2119
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 21:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbhHSTyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 15:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbhHSTyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 15:54:23 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AE5C061575;
        Thu, 19 Aug 2021 12:53:46 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id i9so15322609lfg.10;
        Thu, 19 Aug 2021 12:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3AeLjlhKssMz6KvR/jEzAbtHb+o6oHjAp1MwtFyLU8Y=;
        b=WDOtLTk7j3Iqf8J5xFUaOS+zMJa2mL9dRyGMpKAmf7mpxVa4Xgpu3mr1HQ1auUI50o
         /d8XXvQ1GSfxdbLqbXo7Tvg3cTH64hlGIQt0fzzAH5Ksip3CeIwfHszMlw81niNEmzXM
         ngwl5V/iIUohW1yLZ08Dc2Nh5FivILEE+m/nlHEZ44FVB3ix8WyFmQ6k7vHl1PgQ5BKU
         4I6/7CrHCb4SjfP42RbgJbWbhfsK9v+eYWF5h8U7R09rkqA6xT7E0AxhlxD/65cQ7Ys4
         t3dvClvhpCHhNzT7PTldKs13CriaDFa00m8OerZOu4/L9+MFncC5taTXcYMV7RWhSoeC
         0EaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3AeLjlhKssMz6KvR/jEzAbtHb+o6oHjAp1MwtFyLU8Y=;
        b=hVMlimGlEfHD6U5nLrNLUEAC59PLYYdBOGCB181uIPnmJam4YEJTik4vHUY3hjdVKZ
         dkeIGc+NZGNUvMR2v+p5s5fAZc6F05eK/K4PHli4vAGMVfLX9Mr4vZOzASI4GIB8uhqx
         XRSOwqplQo1IPrD2zo2njTOtLQjZuQ5ZYAYt6fa3dsRGIEEVEbFnRHCBF/cSG2vFd69d
         dqPiuMjFMOdGNS2STg+Ytx0/pqMp2n84TTTsoh5OEiCBZi5HjyzX4Ss73kjat5+WK9zn
         4W5Y7sJAFL7ZDDmp679T3+RcMkXiEB58ZRoPrhhyHk9TSy78tDYJ6eVjuPtWbr7hRXH8
         iS+g==
X-Gm-Message-State: AOAM5305CEShdKGCY0wTop73NO72Svwt8RPh54ng896puF0UtirlvMyL
        lVO0y/hAesN8bQermuhM0as=
X-Google-Smtp-Source: ABdhPJwwE1NnTfqb2LgPEF4P9P4EwUf4JuziZpI7/tJZJFh9ERu9KrmMFfIek/3PNSSdNEk0GsaEzw==
X-Received: by 2002:a05:6512:3906:: with SMTP id a6mr11515501lfu.69.1629402824551;
        Thu, 19 Aug 2021 12:53:44 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.66.127])
        by smtp.gmail.com with ESMTPSA id s3sm402427lfb.15.2021.08.19.12.53.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 12:53:44 -0700 (PDT)
Subject: Re: [PATCH] net: qrtr: fix another OOB Read in qrtr_endpoint_post
To:     Jakub Kicinski <kuba@kernel.org>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Cc:     mani@kernel.org, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        butt3rflyh4ck <butterflyhhuangxx@gmail.com>,
        bjorn.andersson@linaro.org
References: <20210819181458.623832-1-butterflyhuangxx@gmail.com>
 <20210819121630.1223327f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <3a5aef93-fafb-5076-4133-690928b8644a@gmail.com>
Date:   Thu, 19 Aug 2021 22:53:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210819121630.1223327f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/21 10:16 PM, Jakub Kicinski wrote:
> On Fri, 20 Aug 2021 02:14:58 +0800 butt3rflyh4ck wrote:
>> From: butt3rflyh4ck <butterflyhhuangxx@gmail.com>
>> 
>> This check was incomplete, did not consider size is 0:
>> 
>> 	if (len != ALIGN(size, 4) + hdrlen)
>>                     goto err;
>> 
>> if size from qrtr_hdr is 0, the result of ALIGN(size, 4)
>> will be 0, In case of len == hdrlen and size == 0
>> in header this check won't fail and
>> 
>> 	if (cb->type == QRTR_TYPE_NEW_SERVER) {
>>                 /* Remote node endpoint can bridge other distant nodes */
>>                 const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
>> 
>>                 qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
>>         }
>> 
>> will also read out of bound from data, which is hdrlen allocated block.
>> 
>> Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
>> Fixes: ad9d24c9429e ("net: qrtr: fix OOB Read in qrtr_endpoint_post")
> 
> Please make sure to CC authors of patches which are under Fixes, they
> are usually the best people to review the patch. Adding them now.
> 
>> Signed-off-by: butt3rflyh4ck <butterflyhhuangxx@gmail.com>
> 
> We'll need your name. AFAIU it's because of Developer Certificate of
> Origin. You'll need to resend with this fixed (and please remember the CCs).
> 
>> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
>> index 171b7f3be6ef..0c30908628ba 100644
>> --- a/net/qrtr/qrtr.c
>> +++ b/net/qrtr/qrtr.c
>> @@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
>>  		goto err;
>>  	}
>>  
>> -	if (len != ALIGN(size, 4) + hdrlen)
>> +	if (!size || len != ALIGN(size, 4) + hdrlen)
>>  		goto err;
>>  
>>  	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
> 

I am able to trigger described bug with this repro:

#define _GNU_SOURCE

#include <endian.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

uint64_t r[1] = {0xffffffffffffffff};

int main(void)
{
    syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
    syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
    syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
    intptr_t res = 0;
    memcpy((void*)0x20000000, "/dev/qrtr-tun\000", 14);
    res = syscall(__NR_openat, 0xffffffffffffff9cul, 0x20000000ul, 
0x82ul, 0);
    if (res != -1)
      r[0] = res;
    memcpy((void*)0x20000000, 
"\x01\x21\x21\x39\x04\x00\x00\x00\xd6\x2c\xf3\x50"
 
"\x1a\x47\x56\x52\x19\x56\x86\xef\x00\x00\x00\x00"
                              "\xff\xff\xff\x00\xfe\xff\xff\xff", 32);
    syscall(__NR_write, r[0], 0x20000000ul, 0x20ul);
    return 0;
}

( I didn't write it, it's modified syzbot's repro :) )

One thing I am wondering about is why Fixes tag points to my commit? My 
commit didn't introduce any bugs, this bug will happen even _without_ my 
change.

Anyway, LGTM!

Reviewed-by: Pavel Skripkin <paskripkin@gmail.com>




With regards,
Pavel Skripkin
