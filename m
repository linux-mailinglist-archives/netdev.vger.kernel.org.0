Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E5E608E4E
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 18:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiJVQAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 12:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJVP77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 11:59:59 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9757157E21;
        Sat, 22 Oct 2022 08:59:56 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id a14so6430546wru.5;
        Sat, 22 Oct 2022 08:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JLicVVBng/C9cWRFOU9jZiKv2wdfy/cScrDa0FYJh64=;
        b=i5TICKwIPaXc4OBSHQ1/CLzMpjAAoTwJfIfFzhcf31QvgdHTOC/38OxOU5A9ZjMbFt
         BCOJX5jin9nDUf4GH4tnJb5q30Rjb/3SEcAUBNBdBoprqWoFF2ElKOVUPisIA7vNJLdf
         GO0q5CuEMbUTEcRes2Zd7xiFWGBcGj0/JEUtcjGuFZavwkvZCbzLBCcTUkgmjowDFP6T
         ckG31zsnsI9+RvA1M5oQnpeQwznuCjJqbO3aI5kX2ITdgapmRCIQVNhA+PuiwMTgtO6H
         8XYvL1CMKFKDUyL87zGJaQQ0/bnMG6X9Ol7Jc6A7V+LNkhn2xnGownix6Kmg2LqjWJpJ
         2JRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JLicVVBng/C9cWRFOU9jZiKv2wdfy/cScrDa0FYJh64=;
        b=ZDqCMBL9OxSRDURFYukGCFHAt+BqPjASxHu+qA+uG1/TEXSITo9s9280DlHtwuQENc
         jtHEygXx6pogYXlQeXng3ji8CLl6bW1TJsjL6mN5Q1l1v6orWBIJN8kp3JDZ+1ZjOfgW
         3GO60eFw92W835p0YcIwj8sEEYHvb/tF4LFrvtxd0vtH/RnQ3gj8Rv5c2QYY5ZNU2EwU
         xqtWbRnehkG/gU1ICyOEyqGZiRNTyMuGg2TfduCOYYazKdUuGE6seqZ88h63nVRuFjBN
         +UWMIUux1miafH10W4kzFJBcCmy9gZ/eVqV2KS3XFAordsFxkxCR65Ix0YwyxLuELabf
         u/FQ==
X-Gm-Message-State: ACrzQf2ydTgt5dRuA0LjL2muSSaRlmZCfn8sSU0sNuX5TrneDeNQ2vQX
        UQvtWNvCaLg/yUTQVzrptSs=
X-Google-Smtp-Source: AMsMyM6mIH5zfrDvBgYZOygsaBUHTl4ZUyCjyfAjW7KQP1La76CJbQ411ETgtaSJU5OtQVIYrsZz0A==
X-Received: by 2002:adf:d842:0:b0:22e:33e2:f379 with SMTP id k2-20020adfd842000000b0022e33e2f379mr15577268wrl.23.1666454394450;
        Sat, 22 Oct 2022 08:59:54 -0700 (PDT)
Received: from [192.168.8.100] (188.29.34.67.threembb.co.uk. [188.29.34.67])
        by smtp.gmail.com with ESMTPSA id l7-20020a05600c47c700b003b95ed78275sm5525230wmo.20.2022.10.22.08.59.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Oct 2022 08:59:53 -0700 (PDT)
Message-ID: <99ab0cb7-45ad-c67d-66f4-6b52c5e6ac33@gmail.com>
Date:   Sat, 22 Oct 2022 16:57:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH for-6.1 1/3] net: flag sockets supporting msghdr
 originated zerocopy
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <cover.1666346426.git.asml.silence@gmail.com>
 <3dafafab822b1c66308bb58a0ac738b1e3f53f74.1666346426.git.asml.silence@gmail.com>
 <20221021091404.58d244af@kernel.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20221021091404.58d244af@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/22 17:14, Jakub Kicinski wrote:
> On Fri, 21 Oct 2022 11:16:39 +0100 Pavel Begunkov wrote:
>> We need an efficient way in io_uring to check whether a socket supports
>> zerocopy with msghdr provided ubuf_info. Add a new flag into the struct
>> socket flags fields.
>>
>> Cc: <stable@vger.kernel.org> # 6.0
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/linux/net.h | 1 +
>>   net/ipv4/tcp.c      | 1 +
>>   net/ipv4/udp.c      | 1 +
>>   3 files changed, 3 insertions(+)
>>
>> diff --git a/include/linux/net.h b/include/linux/net.h
>> index 711c3593c3b8..18d942bbdf6e 100644
>> --- a/include/linux/net.h
>> +++ b/include/linux/net.h
>> @@ -41,6 +41,7 @@ struct net;
>>   #define SOCK_NOSPACE		2
>>   #define SOCK_PASSCRED		3
>>   #define SOCK_PASSSEC		4
>> +#define SOCK_SUPPORT_ZC		5
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> 
> Any idea on when this will make it to Linus? If within a week we can
> probably delay:

After a chat with Jens, IIUC he can take it and send out to
Linus early. So, sounds like a good plan


> https://lore.kernel.org/all/dc549a4d5c1d2031c64794c8e12bed55afb85c3e.1666287924.git.pabeni@redhat.com/
> and avoid the conflict.

-- 
Pavel Begunkov
