Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB47B320A10
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 12:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBULo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 06:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhBULo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 06:44:57 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFBAC061574
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 03:44:16 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id h25so4596849eds.4
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 03:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dhrn779+a4z/VQxcMafxNvJ9pBhmzV8lMEegc3MEdvY=;
        b=VYzCmz/IpOHVbebwWJ42tkC0yblsRK/yZg4sUyVdkmrp1NT9zsuGmuM52IUEOcqn5V
         YmTwGP0a2IJeRqIHxM5WCd6d76wFYhj9lTX2DV8GcrAHoAA8mhL1uGVsjncQqi7T1UHr
         8dsWaCJoIziCY7Qmdb3JJh4ZUtLdLQWWH2RgtohKDvbsn+ltezHLXuHTb2t65A9TnqkG
         huYdV+XE6r1bn3kIQofAE27iClLXTnsJm/HckFXMBukryCZibNNfQC9imCTMZRC8Xfvk
         isU/PjSphswSQoTcV7tWRSMyr11ZyRfnUZr6NhqoyBIsclwR2hSjzzQoONutoIq/5Dm1
         tApw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dhrn779+a4z/VQxcMafxNvJ9pBhmzV8lMEegc3MEdvY=;
        b=XkMV+BgQhXjjhxz7MIPHrCzCGdFXLj8NJ374cyxXtApHlOaSGf+Wje+XrOJNvZsOzU
         ePj//av5nBeDYXntTB385S/B6wZkN5kCyFRPP3E1oy4qf9NFgbCoC6acY+JnnXRKeO8k
         6YWlWnoPjRMVTRdKZyfjCF46gr3y5EvOeWFVGaOj9cOiuxBL4MiI8wSmAcKvMAUHE2Nz
         qvGn9WSSFc84cEBsDe7Umt6U5tKTinjfRgvkMJ5gvQjS9e+h/MLB99Fu6N3duh97dMq1
         gnTbnWDGlfJ9Z/0s2y8Vp7f1mjKMJROPmepnAGhVc2Jhh39yQ87QXDEz9PHfgf4JzClW
         i6OA==
X-Gm-Message-State: AOAM530V2i3B5CWZhVSONHkThyv20CM/yTbhc//8sTJUKcZN3/x6JxdH
        eoBmbmBs69IaailsS2i2YI4=
X-Google-Smtp-Source: ABdhPJw27UbxK1VZjh26CdqdQonGjkK6TO3asaERjRg0CqE5PFBBLCHMyRHm4iK+LQkAdpdIFbLfxQ==
X-Received: by 2002:aa7:da19:: with SMTP id r25mr18337968eds.367.1613907855131;
        Sun, 21 Feb 2021 03:44:15 -0800 (PST)
Received: from [132.68.43.202] ([132.68.43.202])
        by smtp.gmail.com with ESMTPSA id bz20sm8514508ejc.28.2021.02.21.03.44.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 03:44:14 -0800 (PST)
Subject: Re: [PATCH v4 net-next 07/21] nvme-tcp: Add DDP data-path
To:     David Ahern <dsahern@gmail.com>, Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, smalin@marvell.com,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        benishay@nvidia.com, Or Gerlitz <ogerlitz@nvidia.com>,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210211211044.32701-1-borisp@mellanox.com>
 <20210211211044.32701-8-borisp@mellanox.com>
 <cfd61c5a-c5fd-e0d9-fb60-be93f1c98735@gmail.com>
 <CAJ3xEMgZg9dFyc8cnbuPPAFT3jd2k27TdLOz-vtVmxy9k9zHcg@mail.gmail.com>
 <f9c45756-b823-7cab-213c-761866230c96@gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <c0eba1e7-f113-2400-72c1-4361e79363a7@gmail.com>
Date:   Sun, 21 Feb 2021 13:44:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <f9c45756-b823-7cab-213c-761866230c96@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/02/2021 19:00, David Ahern wrote:
> On 2/17/21 7:01 AM, Or Gerlitz wrote:
>>>> @@ -1136,6 +1265,10 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
>>>>       else
>>>>               flags |= MSG_EOR;
>>>>
>>>> +     if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) &&
>>>> +         blk_rq_nr_phys_segments(rq) && rq_data_dir(rq) == READ)
>>>> +             nvme_tcp_setup_ddp(queue, pdu->cmd.common.command_id, rq);
>>>> +
>>>
>>> For consistency, shouldn't this be wrapped in the CONFIG_TCP_DDP check too?
>>
>> We tried to avoid the wrapping in some places where it was
>> possible to do without adding confusion, this one is a good
>> example IMOH.
>>
>>
> 
> The above (and other locations like it) can easily be put into a helper
> that has logic when the CONFIG is enabled and compiles out when not.
> Consistency makes for simpler, cleaner code for optional features.
> 

The above is consistent in the sense that we wrap only places that are
absolutely necessary, so as to avoid ifdefs as much as possible.

Specifically, here and in ddp_teardown, we will add a wrapper to reduce
clutter if offload is not used.
