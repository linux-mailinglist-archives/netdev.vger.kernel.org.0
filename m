Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFB26F02C6
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 10:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243111AbjD0Iud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 04:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242131AbjD0Iuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 04:50:32 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05B22738
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 01:50:04 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b5c4c76aaso5828000b3a.2
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 01:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1682585404; x=1685177404;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bOdJGbByKbJcYV9ZPYV2JH9cXI/RfIpCkrphjg1KQ/s=;
        b=JFduCOczIxe+WvXouPfyVX6fu1JwXSLLKwfZR+9hn/noUchGmyHoojut/KX4jfDeyv
         6RC800/0LfqEszOsaWbkrJVUZmPoJ+75sjwhF/2QZjMDClg4VGnftJnHzRTv0gZuNZWb
         7hZZW5MuCc+IFpRnEYWwvBCfw6gzAYN7n/3VZ22Mac5WKWXiykiWzJTcN6FFahID981S
         vT6DtQLiUkAl4J231z3+nG699UnPonC7zRDHrTeELAdX7lOJDOjNo1tliDDxIlXvU0ko
         hyPChymYsFvoMAzfMbJeMJ8V/2yy5ptUScYW7Gq108kYpXTUF8y5PbEPYwpC5uqVtq0h
         DWIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682585404; x=1685177404;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bOdJGbByKbJcYV9ZPYV2JH9cXI/RfIpCkrphjg1KQ/s=;
        b=IfsOY7xoM9QmFmo6E03zPcjEsPI6ylMqUZZYIKRTdc7PAh6dviuM1ulF+1yupFqPY5
         phZYGznvoDAZ0uRbYbq96pxu1QVxsNyfU54LnwA6sEUQar0/f1ueboA7QiXnxTz9Jvdi
         DCPQd3ZHCyxJvR9177SXl4L/TiB6pzIjFLHg4dV4hhoa8owtdBUAaAxRQLT7zQL9rSG6
         Dhv7Rb6hmNzRFidRD2O8q1tHyxaTHlJXLYhxwTAiwN7BDb2DaI20qIdFRX18n4yozaPq
         n8GWuQiXJQl9BdrZaotPZRWMQrNOaFoQDyabFe4pEM5gP+CfNLNo8kOQ/hq0FwpbI765
         ZKRw==
X-Gm-Message-State: AC+VfDz3J9aiEyVMxBlRZrgOW28BfpU4yFSbcEQzW5F7TI/zQsGsGFFr
        wRTUWKNpXZPzCWEkRgIWLvFflg==
X-Google-Smtp-Source: ACHHUZ5Vb82T8JwS/kKxgo0uIIEBk57nTfpPqSPgXjkXUA7yoAcZ3RH8IamXT2JS7/vAlzisccD/Pw==
X-Received: by 2002:a05:6a00:2282:b0:63d:254a:3902 with SMTP id f2-20020a056a00228200b0063d254a3902mr1359429pfe.12.1682585404154;
        Thu, 27 Apr 2023 01:50:04 -0700 (PDT)
Received: from [10.2.195.40] ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id o8-20020a62f908000000b0063b5776b073sm12551490pfh.117.2023.04.27.01.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 01:50:03 -0700 (PDT)
Message-ID: <c2f6512e-cef6-04d5-8457-0408f12ca7a9@bytedance.com>
Date:   Thu, 27 Apr 2023 16:49:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH] virtio_net: suppress cpu stall when free_unused_bufs
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
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
From:   Wenliang Wang <wangwenliang.1995@bytedance.com>
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

On 4/27/23 4:23 PM, Michael S. Tsirkin wrote:
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
> fix the issue for you?
> 
Yeah, it works better.
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
