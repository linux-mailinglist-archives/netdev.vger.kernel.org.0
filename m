Return-Path: <netdev+bounces-1325-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A3D6FD5B3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 07:00:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88F361C20CBE
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 05:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D879811;
	Wed, 10 May 2023 05:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E9065F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 05:00:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68ED40FE
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683694821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XeGHjCbz8dSGYd3TX1liaACMeHk61OyZyX7cZcDFTH4=;
	b=PEF9gLl+qc2ztQLWEa4LgsE1N1cQaWQjUVNMisaL2wBttw93J2y0iVVevPnNYzRwdUXWO9
	P/Vl1hqlGUiZwGJ0G0J8d+hY+7iLDfndP0ZcCWtPHJTa2J9jhde23XV3EBUKjFqWX3p1Wy
	uKylZKtRkwRnam2nUnrxW2ioXAoHvV4=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-SoqY2bdKMtObsp1tb8_iDg-1; Wed, 10 May 2023 01:00:20 -0400
X-MC-Unique: SoqY2bdKMtObsp1tb8_iDg-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5287c9b01fdso6153500a12.2
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 22:00:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683694819; x=1686286819;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XeGHjCbz8dSGYd3TX1liaACMeHk61OyZyX7cZcDFTH4=;
        b=l/tAXQi30uTrzD9fzvqKAVNra6T0X5cIfbqbDWjy2OjWxJUQFBMYbsRRu4odvGa4wU
         YlaRyl2ITFv0U/NDeYkBmX7QtnNkuZ39GuQcxhAnOaG/i1RkCjI8tdBmc2dEkCSETLri
         HCcjU/WL4eVk4n+mmcPbs+w+HCg1hVF0KUyOW2KnRn/KJUOA8usytCegjawZlgRPJ/nM
         tZr9y0cNgmRV9N9VDlhInE8jkw8se7RNnM73TV9WzrzaBfOFyuGk0dJuFWZy3F4DQEJA
         lUwA2jUYxneZ4ccNycWcz6ApHwMC4KePgnHz2ZYNezCR48k2PsSzMpji2uPps5s63cJG
         NlIg==
X-Gm-Message-State: AC+VfDxv18zMiFLvou9yp73woaOKUi0XYiUeEMSH8wUxFTtogfZZEFOq
	0fdwc7h08joYMxzwnWQoIjgHFV9irC5WRGUXz28CHHyFkQppIV3i+Ue2Ed9domYGppYLwDMRVc1
	fS+Ep3uUzgSO6eyg5
X-Received: by 2002:a05:6a20:549e:b0:100:4369:164a with SMTP id i30-20020a056a20549e00b001004369164amr14030937pzk.46.1683694819294;
        Tue, 09 May 2023 22:00:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5ebCTud1rBz1QnWQJHfKRmNeCZ/yR49zeE232z167CAyNmOh2ig/ETAvy8858079sOcnIVIQ==
X-Received: by 2002:a05:6a20:549e:b0:100:4369:164a with SMTP id i30-20020a056a20549e00b001004369164amr14030897pzk.46.1683694818843;
        Tue, 09 May 2023 22:00:18 -0700 (PDT)
Received: from [10.72.13.243] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w12-20020aa7858c000000b0064867dc8719sm188015pfn.118.2023.05.09.22.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 22:00:18 -0700 (PDT)
Message-ID: <a13a2d3f-e76e-b6a6-3d30-d5534e2fa917@redhat.com>
Date: Wed, 10 May 2023 13:00:08 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net v3] virtio_net: Fix error unwinding of XDP
 initialization
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Feng Liu <feliu@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>,
 Simon Horman <simon.horman@corigine.com>, Bodong Wang <bodong@nvidia.com>,
 William Tu <witu@nvidia.com>, Parav Pandit <parav@nvidia.com>,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20230503003525.48590-1-feliu@nvidia.com>
 <1683340417.612963-3-xuanzhuo@linux.alibaba.com>
 <559ad341-2278-5fad-6805-c7f632e9894e@nvidia.com>
 <1683510351.569717-1-xuanzhuo@linux.alibaba.com>
 <c2c2bfed-bdf1-f517-559c-f51c9ca1807a@nvidia.com>
 <1683596602.483001-1-xuanzhuo@linux.alibaba.com>
Content-Language: en-US
From: Jason Wang <jasowang@redhat.com>
In-Reply-To: <1683596602.483001-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


在 2023/5/9 09:43, Xuan Zhuo 写道:
> On Mon, 8 May 2023 11:00:10 -0400, Feng Liu <feliu@nvidia.com> wrote:
>>
>> On 2023-05-07 p.m.9:45, Xuan Zhuo wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> On Sat, 6 May 2023 08:08:02 -0400, Feng Liu <feliu@nvidia.com> wrote:
>>>>
>>>> On 2023-05-05 p.m.10:33, Xuan Zhuo wrote:
>>>>> External email: Use caution opening links or attachments
>>>>>
>>>>>
>>>>> On Tue, 2 May 2023 20:35:25 -0400, Feng Liu <feliu@nvidia.com> wrote:
>>>>>> When initializing XDP in virtnet_open(), some rq xdp initialization
>>>>>> may hit an error causing net device open failed. However, previous
>>>>>> rqs have already initialized XDP and enabled NAPI, which is not the
>>>>>> expected behavior. Need to roll back the previous rq initialization
>>>>>> to avoid leaks in error unwinding of init code.
>>>>>>
>>>>>> Also extract a helper function of disable queue pairs, and use newly
>>>>>> introduced helper function in error unwinding and virtnet_close;
>>>>>>
>>>>>> Issue: 3383038
>>>>>> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
>>>>>> Signed-off-by: Feng Liu <feliu@nvidia.com>
>>>>>> Reviewed-by: William Tu <witu@nvidia.com>
>>>>>> Reviewed-by: Parav Pandit <parav@nvidia.com>
>>>>>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>>>>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>>>>> Change-Id: Ib4c6a97cb7b837cfa484c593dd43a435c47ea68f
>>>>>> ---
>>>>>>     drivers/net/virtio_net.c | 30 ++++++++++++++++++++----------
>>>>>>     1 file changed, 20 insertions(+), 10 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>>> index 8d8038538fc4..3737cf120cb7 100644
>>>>>> --- a/drivers/net/virtio_net.c
>>>>>> +++ b/drivers/net/virtio_net.c
>>>>>> @@ -1868,6 +1868,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>>>>>>          return received;
>>>>>>     }
>>>>>>
>>>>>> +static void virtnet_disable_qp(struct virtnet_info *vi, int qp_index)
>>>>>> +{
>>>>>> +     virtnet_napi_tx_disable(&vi->sq[qp_index].napi);
>>>>>> +     napi_disable(&vi->rq[qp_index].napi);
>>>>>> +     xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
>>>>>> +}
>>>>>> +
>>>>>>     static int virtnet_open(struct net_device *dev)
>>>>>>     {
>>>>>>          struct virtnet_info *vi = netdev_priv(dev);
>>>>>> @@ -1883,20 +1890,26 @@ static int virtnet_open(struct net_device *dev)
>>>>>>
>>>>>>                  err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, vi->rq[i].napi.napi_id);
>>>>>>                  if (err < 0)
>>>>>> -                     return err;
>>>>>> +                     goto err_xdp_info_reg;
>>>>>>
>>>>>>                  err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
>>>>>>                                                   MEM_TYPE_PAGE_SHARED, NULL);
>>>>>> -             if (err < 0) {
>>>>>> -                     xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>>>>>> -                     return err;
>>>>>> -             }
>>>>>> +             if (err < 0)
>>>>>> +                     goto err_xdp_reg_mem_model;
>>>>>>
>>>>>>                  virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
>>>>>>                  virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
>>>>>>          }
>>>>>>
>>>>>>          return 0;
>>>>>> +
>>>>>> +err_xdp_reg_mem_model:
>>>>>> +     xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>>>>>> +err_xdp_info_reg:
>>>>>> +     for (i = i - 1; i >= 0; i--)
>>>>>> +             virtnet_disable_qp(vi, i);
>>>>>
>>>>> I would to know should we handle for these:
>>>>>
>>>>>            disable_delayed_refill(vi);
>>>>>            cancel_delayed_work_sync(&vi->refill);
>>>>>
>>>>>
>>>>> Maybe we should call virtnet_close() with "i" directly.
>>>>>
>>>>> Thanks.
>>>>>
>>>>>
>>>> Can’t use i directly here, because if xdp_rxq_info_reg fails, napi has
>>>> not been enabled for current qp yet, I should roll back from the queue
>>>> pairs where napi was enabled before(i--), otherwise it will hang at napi
>>>> disable api
>>> This is not the point, the key is whether we should handle with:
>>>
>>>             disable_delayed_refill(vi);
>>>             cancel_delayed_work_sync(&vi->refill);
>>>
>>> Thanks.
>>>
>>>
>> OK, get the point. Thanks for your careful review. And I check the code
>> again.
>>
>> There are two points that I need to explain:
>>
>> 1. All refill delay work calls(vi->refill, vi->refill_enabled) are based
>> on that the virtio interface is successfully opened, such as
>> virtnet_receive, virtnet_rx_resize, _virtnet_set_queues, etc. If there
>> is an error in the xdp reg here, it will not trigger these subsequent
>> functions. There is no need to call disable_delayed_refill() and
>> cancel_delayed_work_sync().
> Maybe something is wrong. I think these lines may call delay work.
>
> static int virtnet_open(struct net_device *dev)
> {
> 	struct virtnet_info *vi = netdev_priv(dev);
> 	int i, err;
>
> 	enable_delayed_refill(vi);
>
> 	for (i = 0; i < vi->max_queue_pairs; i++) {
> 		if (i < vi->curr_queue_pairs)
> 			/* Make sure we have some buffers: if oom use wq. */
> -->			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
> -->				schedule_delayed_work(&vi->refill, 0);
>
> 		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, vi->rq[i].napi.napi_id);
> 		if (err < 0)
> 			return err;
>
> 		err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
> 						 MEM_TYPE_PAGE_SHARED, NULL);
> 		if (err < 0) {
> 			xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> 			return err;
> 		}
>
> 		virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
> 		virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
> 	}
>
> 	return 0;
> }
>
>
> And I think, if we virtnet_open() return error, then the status of virtnet
> should like the status after virtnet_close().
>
> Or someone has other opinion.


I agree, we need to disable and sync with the refill work.

Thanks


>
> Thanks.
>
>> The logic here is different from that of
>> virtnet_close. virtnet_close is based on the success of virtnet_open and
>> the tx and rx has been carried out normally. For error unwinding, only
>> disable qp is needed. Also encapuslated a helper function of disable qp,
>> which is used ing error unwinding and virtnet close
>> 2. The current error qp, which has not enabled NAPI, can only call xdp
>> unreg, and cannot call the interface of disable NAPI, otherwise the
>> kernel will be stuck. So for i-- the reason for calling disable qp on
>> the previous queue
>>
>> Thanks
>>
>>>>>> +
>>>>>> +     return err;
>>>>>>     }
>>>>>>
>>>>>>     static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>>>>>> @@ -2305,11 +2318,8 @@ static int virtnet_close(struct net_device *dev)
>>>>>>          /* Make sure refill_work doesn't re-enable napi! */
>>>>>>          cancel_delayed_work_sync(&vi->refill);
>>>>>>
>>>>>> -     for (i = 0; i < vi->max_queue_pairs; i++) {
>>>>>> -             virtnet_napi_tx_disable(&vi->sq[i].napi);
>>>>>> -             napi_disable(&vi->rq[i].napi);
>>>>>> -             xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>>>>>> -     }
>>>>>> +     for (i = 0; i < vi->max_queue_pairs; i++)
>>>>>> +             virtnet_disable_qp(vi, i);
>>>>>>
>>>>>>          return 0;
>>>>>>     }
>>>>>> --
>>>>>> 2.37.1 (Apple Git-137.1)
>>>>>>


