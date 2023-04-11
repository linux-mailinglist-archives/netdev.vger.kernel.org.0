Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE57C6DDFAE
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjDKP2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjDKP2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:28:49 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56B559D1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:28:31 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-7607a12cfd3so2923239f.1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1681226911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=avUeuwpzPDLmh7q6KyhD3z/3GxLA2d1SOJIQRmXe534=;
        b=g/ckIo1Xl3s3ii/SXTvKWq4+VEpFHO8ZWzGghwcXEfKKHdYCF7FryYczAS0bsZPMSz
         PSFW1p2ZCfMF2AnGCmGKcmmoRBmZJtK1yeGh4B1ZZNHHuTpzv8vHWwA9g0Oq495904CN
         8i4zpaw/Z1/ebEpo0/5bWly+QvIG/ioURmD3rDEz/eo4wI7GK/dlcJCWScbSP30D0JPn
         L7kSxyZbBxTe3JctKQb3F79B5cn6awo7++d6HcqNmiUVo7Mre5jTY5xZbFmwLPnJ6kiE
         /7HS2a69csnvOfC9D2xrJ2FoIWhlgz2vxwlKohFiSjtYft0ols5Ta+ZMhVvwDhso50eB
         d1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681226911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=avUeuwpzPDLmh7q6KyhD3z/3GxLA2d1SOJIQRmXe534=;
        b=6Y1HAYPwlWoOt1xYRl/8fyMwWQnbL0IOBlpj0/Vda8wMLUcRqKyGVhhVvbrKEyvzXb
         nKvozts+zi0buqBRKkNCtTVDLznWqwlWICn7aunN/28fAjq1nrOAwdvggve+wpRolH6z
         kpu7zvJz44mO9Vr4z/3tSZz5alI2bCYfH4KS9bv43YsG5Iyazj2gD6KQpXHCCLK9gbYG
         QSiUOaRkjslBxLZRA44g3C719zEvFoDEbj+VPrXz8sgs8e9jQ78TBSomVo1kVG094vEV
         v748lGzZVpfd/DzusIUvjeV7faUWwKIuOJAomD0sPX64PyTq7UJWlQHFsFTNW2Hg0g2f
         Kwug==
X-Gm-Message-State: AAQBX9ftbQvorXbNxusyK0MSIxOb2PVMmqKtvr+Ozk3WIt9KtXgDvg4e
        dzVAFzdnwgwzTCvcf7kbjAewhw==
X-Google-Smtp-Source: AKy350biJbNAfJ5exruo7SQbqqHyqtO2T8cETYQARA3S7L66NyYCpZDI0XbxkrW4747fvTOc4xxD3w==
X-Received: by 2002:a05:6602:2b91:b0:75c:f48c:2075 with SMTP id r17-20020a0566022b9100b0075cf48c2075mr7044533iov.2.1681226911077;
        Tue, 11 Apr 2023 08:28:31 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a3-20020a029403000000b0040bc0a9e711sm2136630jai.88.2023.04.11.08.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 08:28:30 -0700 (PDT)
Message-ID: <20cb4641-c765-e5ef-41cb-252be7721ce5@kernel.dk>
Date:   Tue, 11 Apr 2023 09:28:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Breno Leitao <leitao@debian.org>
Cc:     Willem de Bruijn <willemb@google.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, asml.silence@gmail.com,
        leit@fb.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, matthieu.baerts@tessares.net,
        marcelo.leitner@gmail.com
References: <20230406144330.1932798-1-leitao@debian.org>
 <CA+FuTSeKpOJVqcneCoh_4x4OuK1iE0Tr6f3rSNrQiR-OUgjWow@mail.gmail.com>
 <ZC7seVq7St6UnKjl@gmail.com>
 <CA+FuTSf9LEhzjBey_Nm_-vN0ZjvtBSQkcDWS+5uBnLmr8Qh5uA@mail.gmail.com>
 <e576f6fe-d1f3-93cd-cb94-c0ae115299d8@kernel.org>
 <ZDVLyi1PahE0sfci@gmail.com>
 <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
 <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
 <643573df81e20_11117c2942@willemb.c.googlers.com.notmuch>
 <036c80e5-4844-5c84-304c-7e553fe17a9b@kernel.dk>
 <64357608c396d_113ebd294ba@willemb.c.googlers.com.notmuch>
 <19c69021-dce3-1a4a-00eb-920d1f404cfc@kernel.dk>
 <64357bb97fb19_114b22294c4@willemb.c.googlers.com.notmuch>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <64357bb97fb19_114b22294c4@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/23 9:24?AM, Willem de Bruijn wrote:
> Jens Axboe wrote:
>> On 4/11/23 9:00?AM, Willem de Bruijn wrote:
>>> Jens Axboe wrote:
>>>> On 4/11/23 8:51?AM, Willem de Bruijn wrote:
>>>>> Jens Axboe wrote:
>>>>>> On 4/11/23 8:36?AM, David Ahern wrote:
>>>>>>> On 4/11/23 6:00 AM, Breno Leitao wrote:
>>>>>>>> I am not sure if avoiding io_uring details in network code is possible.
>>>>>>>>
>>>>>>>> The "struct proto"->uring_cmd callback implementation (tcp_uring_cmd()
>>>>>>>> in the TCP case) could be somewhere else, such as in the io_uring/
>>>>>>>> directory, but, I think it might be cleaner if these implementations are
>>>>>>>> closer to function assignment (in the network subsystem).
>>>>>>>>
>>>>>>>> And this function (tcp_uring_cmd() for instance) is the one that I am
>>>>>>>> planning to map io_uring CMDs to ioctls. Such as SOCKET_URING_OP_SIOCINQ
>>>>>>>> -> SIOCINQ.
>>>>>>>>
>>>>>>>> Please let me know if you have any other idea in mind.
>>>>>>>
>>>>>>> I am not convinced that this io_uring_cmd is needed. This is one
>>>>>>> in-kernel subsystem calling into another, and there are APIs for that.
>>>>>>> All of this set is ioctl based and as Willem noted a little refactoring
>>>>>>> separates the get_user/put_user out so that in-kernel can call can be
>>>>>>> made with existing ops.
>>>>>>
>>>>>> How do you want to wire it up then? We can't use fops->unlocked_ioctl()
>>>>>> obviously, and we already have ->uring_cmd() for this purpose.
>>>>>
>>>>> Does this suggestion not work?
>>>>
>>>> Not sure I follow, what suggestion?
>>>>
>>>
>>> This quote from earlier in the thread:
>>>
>>> I was thinking just having sock_uring_cmd call sock->ops->ioctl, like
>>> sock_do_ioctl.
>>
>> But that doesn't work, because sock->ops->ioctl() assumes the arg is
>> memory in userspace. Or do you mean change all of the sock->ops->ioctl()
>> to pass in on-stack memory (or similar) and have it work with a kernel
>> address?
> 
> That was what I suggested indeed.
> 
> It's about as much code change as this patch series. But it avoids
> the code duplication.

Breno, want to tackle that as a prep patch first? Should make the
functional changes afterwards much more straightforward, and will allow
support for anything really.

-- 
Jens Axboe

