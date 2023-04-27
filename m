Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032D56F0469
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 12:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243331AbjD0Kqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 06:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243636AbjD0Kqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 06:46:39 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2711C30F4
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 03:45:51 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b781c9787so2385278b3a.1
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 03:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1682592350; x=1685184350;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=30nosoiXQAMrXXSjMk3f0ScS/VVQ4IEv4NLyy2tKxdY=;
        b=Op//te13Se/Cnngme6oQ9wezBIdtyhpuLT07AzPjk6KoHmBrxcqBAbbCwgE2bNDkRq
         mEqJ4n8a9REsVNW1lXtWNhpWiQYjWU36nlPvSp4zUfojPQ0FBDlTjYiRI1C2gbvonXFN
         5jJSlQjH/l4tll69GEyH4mq5JA0QJf35MJaEg1Oq5zxWKVgrNUfYKzNIdhKdr4DkSvof
         md9vbadBNldAqp+VNjf0NBNmNnsthOMGd2/YJDaamNPuxfLPLg4sy8I8s898vIunxb17
         L3ELKs52PqGJXKcVrFmqnycItqfYDHbEg9u6Pa/3vrguqB7Os6gbbqxOz8DVubTm3XwD
         XNOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682592350; x=1685184350;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=30nosoiXQAMrXXSjMk3f0ScS/VVQ4IEv4NLyy2tKxdY=;
        b=hrB5oowo4JFIUntkp7AXmZvxM9qm1PQFa/DpEVF4TecGV12q7UncM4fgLjNjepkmX8
         9I09V2zuUhHcjH8VFQzPBrNhowky1Y2752WewXmGFqyaUjzKs7+880bo4D3AksI3n1+b
         2YTPJKVvWg4pYj7GIfJjzlulkQGo1BfV/X5rq6Nd7GXNItHsF8/vnbREnM9Q+akSwJ3S
         m1gryKSI3dHw7R34WIROMdzBglrJyP+n+OvulvBRc/TxAxtrgT38K/+koD4zpb9JIaSp
         teIICT5jKWdPL0qYA+IgqopfUprwVcB8Fu9jb1ZOuvmMiH4QjLHDgbF5L+0u+UEDV1jX
         JY3Q==
X-Gm-Message-State: AC+VfDxqtrzcBREKTOmMVB4aPJ+L/JxeiXuVTynVZIS19EUGGZtnG88B
        khh2zExFTun6J+9khy0kVqfntg==
X-Google-Smtp-Source: ACHHUZ6/TN+bAdEEGCPnEqHk3/jjucuKbswe5ia2u8r1cKfNOYcJMK4y9V5VUqT+LUg9y/V/yRFefA==
X-Received: by 2002:a17:902:ecca:b0:1a9:581b:fbaa with SMTP id a10-20020a170902ecca00b001a9581bfbaamr1374722plh.2.1682592350524;
        Thu, 27 Apr 2023 03:45:50 -0700 (PDT)
Received: from [10.70.252.135] ([139.177.225.229])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902b70900b001a96d295f15sm7108460pls.284.2023.04.27.03.45.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 03:45:50 -0700 (PDT)
Message-ID: <32eb2826-6322-2f3e-9c48-7fd9afc33615@bytedance.com>
Date:   Thu, 27 Apr 2023 18:45:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH] virtio_net: suppress cpu stall when free_unused_bufs
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Wenliang Wang <wangwenliang.1995@bytedance.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jasowang@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
References: <20230427043433.2594960-1-wangwenliang.1995@bytedance.com>
 <1682576442.2203932-1-xuanzhuo@linux.alibaba.com>
 <252ee222-f918-426e-68ef-b3710a60662e@bytedance.com>
 <1682579624.5395834-1-xuanzhuo@linux.alibaba.com>
 <20230427041206-mutt-send-email-mst@kernel.org>
 <1682583225.3180113-2-xuanzhuo@linux.alibaba.com>
 <20230427042259-mutt-send-email-mst@kernel.org>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20230427042259-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/4/27 16:23, Michael S. Tsirkin wrote:
> On Thu, Apr 27, 2023 at 04:13:45PM +0800, Xuan Zhuo wrote:
>> On Thu, 27 Apr 2023 04:12:44 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
>>> On Thu, Apr 27, 2023 at 03:13:44PM +0800, Xuan Zhuo wrote:
>>>> On Thu, 27 Apr 2023 15:02:26 +0800, Wenliang Wang <wangwenliang.1995@bytedance.com> wrote:
>>>>>
>>>>>
>>>>> On 4/27/23 2:20 PM, Xuan Zhuo wrote:
>>>>>> On Thu, 27 Apr 2023 12:34:33 +0800, Wenliang Wang <wangwenliang.1995@bytedance.com> wrote:
>>>>>>> For multi-queue and large rx-ring-size use case, the following error
>>>>>>
>>>>>> Cound you give we one number for example?
>>>>>
>>>>> 128 queues and 16K queue_size is typical.
>>>>>
>>>>>>
>>>>>>> occurred when free_unused_bufs:
>>>>>>> rcu: INFO: rcu_sched self-detected stall on CPU.
>>>>>>>
>>>>>>> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
>>>>>>> ---
>>>>>>>    drivers/net/virtio_net.c | 1 +
>>>>>>>    1 file changed, 1 insertion(+)
>>>>>>>
>>>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>>>> index ea1bd4bb326d..21d8382fd2c7 100644
>>>>>>> --- a/drivers/net/virtio_net.c
>>>>>>> +++ b/drivers/net/virtio_net.c
>>>>>>> @@ -3565,6 +3565,7 @@ static void free_unused_bufs(struct virtnet_info *vi)
>>>>>>>    		struct virtqueue *vq = vi->rq[i].vq;
>>>>>>>    		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
>>>>>>>    			virtnet_rq_free_unused_buf(vq, buf);
>>>>>>> +		schedule();
>>>>>>
>>>>>> Just for rq?
>>>>>>
>>>>>> Do we need to do the same thing for sq?
>>>>> Rq buffers are pre-allocated, take seconds to free rq unused buffers.
>>>>>
>>>>> Sq unused buffers are much less, so do the same for sq is optional.
>>>>
>>>> I got.
>>>>
>>>> I think we should look for a way, compatible with the less queues or the smaller
>>>> rings. Calling schedule() directly may be not a good way.
>>>>
>>>> Thanks.
>>>
>>> Why isn't it a good way?
>>
>> For the small ring, I don't think it is a good way, maybe we only deal with one
>> buf, then call schedule().
>>
>> We can call the schedule() after processing a certain number of buffers,
>> or check need_resched () first.
>>
>> Thanks.
> 
> 
> Wenliang, does
>              if (need_resched())
>                      schedule();

Can we just use cond_resched()?

> fix the issue for you?
> 
> 
>>
>>
>>>
>>>>
>>>>>
>>>>>>
>>>>>> Thanks.
>>>>>>
>>>>>>
>>>>>>>    	}
>>>>>>>    }
>>>>>>>
>>>>>>> --
>>>>>>> 2.20.1
>>>>>>>
>>>
> 

-- 
Thanks,
Qi
