Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E5D504D57
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 09:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbiDRIAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 04:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236348AbiDRIAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 04:00:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 762661903E
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 00:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650268674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QB2hIEaNOaVSvZW6GhB9ZPGkcBR5Y/EmwtAltVQbGz4=;
        b=AD9LL2b+RJIGeE/ObOWmT6su/8qni16sYsSN1aqZ3oBBmv0jLl3RsPBDaPtxh1Mu8EOXXn
        vndMTgmA8mWebPPhMk8+1y5tB+slT+XnJupu0NgNNsCEwqGy2zO9vHXwrUTWEVAAiUk2RH
        49MNh3dqoOMQD/6cJWS37wYR98teti0=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-KBK-fncaNU6HZRfzI08pmw-1; Mon, 18 Apr 2022 03:57:53 -0400
X-MC-Unique: KBK-fncaNU6HZRfzI08pmw-1
Received: by mail-pl1-f197.google.com with SMTP id f6-20020a170902ab8600b0015895212d23so7290987plr.6
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 00:57:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QB2hIEaNOaVSvZW6GhB9ZPGkcBR5Y/EmwtAltVQbGz4=;
        b=wkQPw1yIuU6UgQ2FJEvljAWYm66CwTFkmJ4SJryV31L8nbJ1xqlNquw/wg9bkNlTMp
         n4Yvc8Qd6slePNyg1V4NHTOLoxneaf4zp1jj0HOslbQzqr9kw0o/SKuYnmVQIrk9dOLd
         G2AusuEClZixG+2HxDmvKGalxyoV71eKcXTWXL63M9ojNNo50OzUc4RRJG/Fcg0w8crz
         cy2iz7gQrwN7BVBLaaD+uDTJkDJZYJjESHOaU1yxb/uOULyhQaufXTbLeq6TrEqHgL5x
         46DODfWztSdyvfmxArSOfIHCPaarhxGV4Y93o3nSm2LOkQQy7OcgrifgOZ2r2oDXm2w/
         9Haw==
X-Gm-Message-State: AOAM532UIUoff/MzCpX+EE4qneccFQQ760sP9Dum4sB3/1gmmCH9ItXe
        I4wqBXw7T61GonYNpnOLS9vTUXW5AyzHqy2kOJidzVkGjw+7zAQGC7tTEzhEhMDk1QuBPJCiIPS
        eoMmvW/84q2T58Zta
X-Received: by 2002:a17:902:b596:b0:158:f23a:c789 with SMTP id a22-20020a170902b59600b00158f23ac789mr7372578pls.57.1650268672282;
        Mon, 18 Apr 2022 00:57:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDSBaptpR+stWjiJRuBIZwcdjg4yDbmUSoZFvIAfQXF+o8QMtyy7IztplQWHr8YNawm7+9AQ==
X-Received: by 2002:a17:902:b596:b0:158:f23a:c789 with SMTP id a22-20020a170902b59600b00158f23ac789mr7372559pls.57.1650268671926;
        Mon, 18 Apr 2022 00:57:51 -0700 (PDT)
Received: from [10.72.13.25] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v13-20020a17090a00cd00b001d297df6725sm2377825pjd.22.2022.04.18.00.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 00:57:51 -0700 (PDT)
Message-ID: <0ab18346-5245-389d-5996-b805042889da@redhat.com>
Date:   Mon, 18 Apr 2022 15:57:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v9 31/32] virtio_net: support rx/tx queue resize
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-32-xuanzhuo@linux.alibaba.com>
 <122008a6-1e79-14d3-1478-59f96464afc9@redhat.com>
 <1649838917.6726515-10-xuanzhuo@linux.alibaba.com>
 <CACGkMEvPH1k76xB_cHq_S9hvMXgGruoXpKLfoMZvJZ-L7wM9iw@mail.gmail.com>
 <1649989126.5433838-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEuju+kdapRbnx6OxsmAbD=JZin67xGBLEqLrMeuPPw0Fg@mail.gmail.com>
 <1650014226.0312726-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <1650014226.0312726-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/4/15 17:17, Xuan Zhuo 写道:
> On Fri, 15 Apr 2022 13:53:54 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> On Fri, Apr 15, 2022 at 10:23 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>>> On Thu, 14 Apr 2022 17:30:02 +0800, Jason Wang <jasowang@redhat.com> wrote:
>>>> On Wed, Apr 13, 2022 at 4:47 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>>>>> On Wed, 13 Apr 2022 16:00:18 +0800, Jason Wang <jasowang@redhat.com> wrote:
>>>>>> 在 2022/4/6 上午11:43, Xuan Zhuo 写道:
>>>>>>> This patch implements the resize function of the rx, tx queues.
>>>>>>> Based on this function, it is possible to modify the ring num of the
>>>>>>> queue.
>>>>>>>
>>>>>>> There may be an exception during the resize process, the resize may
>>>>>>> fail, or the vq can no longer be used. Either way, we must execute
>>>>>>> napi_enable(). Because napi_disable is similar to a lock, napi_enable
>>>>>>> must be called after calling napi_disable.
>>>>>>>
>>>>>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>>>>>> ---
>>>>>>>    drivers/net/virtio_net.c | 81 ++++++++++++++++++++++++++++++++++++++++
>>>>>>>    1 file changed, 81 insertions(+)
>>>>>>>
>>>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>>>> index b8bf00525177..ba6859f305f7 100644
>>>>>>> --- a/drivers/net/virtio_net.c
>>>>>>> +++ b/drivers/net/virtio_net.c
>>>>>>> @@ -251,6 +251,9 @@ struct padded_vnet_hdr {
>>>>>>>      char padding[4];
>>>>>>>    };
>>>>>>>
>>>>>>> +static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
>>>>>>> +static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
>>>>>>> +
>>>>>>>    static bool is_xdp_frame(void *ptr)
>>>>>>>    {
>>>>>>>      return (unsigned long)ptr & VIRTIO_XDP_FLAG;
>>>>>>> @@ -1369,6 +1372,15 @@ static void virtnet_napi_enable(struct virtqueue *vq, struct napi_struct *napi)
>>>>>>>    {
>>>>>>>      napi_enable(napi);
>>>>>>>
>>>>>>> +   /* Check if vq is in reset state. The normal reset/resize process will
>>>>>>> +    * be protected by napi. However, the protection of napi is only enabled
>>>>>>> +    * during the operation, and the protection of napi will end after the
>>>>>>> +    * operation is completed. If re-enable fails during the process, vq
>>>>>>> +    * will remain unavailable with reset state.
>>>>>>> +    */
>>>>>>> +   if (vq->reset)
>>>>>>> +           return;
>>>>>>
>>>>>> I don't get when could we hit this condition.
>>>>>
>>>>> In patch 23, the code to implement re-enable vq is as follows:
>>>>>
>>>>> +static int vp_modern_enable_reset_vq(struct virtqueue *vq)
>>>>> +{
>>>>> +       struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
>>>>> +       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>>>> +       struct virtio_pci_vq_info *info;
>>>>> +       unsigned long flags, index;
>>>>> +       int err;
>>>>> +
>>>>> +       if (!vq->reset)
>>>>> +               return -EBUSY;
>>>>> +
>>>>> +       index = vq->index;
>>>>> +       info = vp_dev->vqs[index];
>>>>> +
>>>>> +       /* check queue reset status */
>>>>> +       if (vp_modern_get_queue_reset(mdev, index) != 1)
>>>>> +               return -EBUSY;
>>>>> +
>>>>> +       err = vp_active_vq(vq, info->msix_vector);
>>>>> +       if (err)
>>>>> +               return err;
>>>>> +
>>>>> +       if (vq->callback) {
>>>>> +               spin_lock_irqsave(&vp_dev->lock, flags);
>>>>> +               list_add(&info->node, &vp_dev->virtqueues);
>>>>> +               spin_unlock_irqrestore(&vp_dev->lock, flags);
>>>>> +       } else {
>>>>> +               INIT_LIST_HEAD(&info->node);
>>>>> +       }
>>>>> +
>>>>> +       vp_modern_set_queue_enable(&vp_dev->mdev, index, true);
>>>>> +
>>>>> +       if (vp_dev->per_vq_vectors && info->msix_vector != VIRTIO_MSI_NO_VECTOR)
>>>>> +               enable_irq(pci_irq_vector(vp_dev->pci_dev, info->msix_vector));
>>>>> +
>>>>> +       vq->reset = false;
>>>>> +
>>>>> +       return 0;
>>>>> +}
>>>>>
>>>>>
>>>>> There are three situations where an error will be returned. These are the
>>>>> situations I want to handle.
>>>> Right, but it looks harmless if we just schedule the NAPI without the check.
>>> Yes.
>>>
>>>>> But I'm rethinking the question, and I feel like you're right, although the
>>>>> hardware setup may fail. We can no longer sync with the hardware. But using it
>>>>> as a normal vq doesn't have any problems.
>>>> Note that we should make sure the buggy(malicous) device won't crash
>>>> the codes by changing the queue_reset value at its will.
>>> I will keep an eye on this situation.
>>>
>>>>>>
>>>>>>> +
>>>>>>>      /* If all buffers were filled by other side before we napi_enabled, we
>>>>>>>       * won't get another interrupt, so process any outstanding packets now.
>>>>>>>       * Call local_bh_enable after to trigger softIRQ processing.
>>>>>>> @@ -1413,6 +1425,15 @@ static void refill_work(struct work_struct *work)
>>>>>>>              struct receive_queue *rq = &vi->rq[i];
>>>>>>>
>>>>>>>              napi_disable(&rq->napi);
>>>>>>> +
>>>>>>> +           /* Check if vq is in reset state. See more in
>>>>>>> +            * virtnet_napi_enable()
>>>>>>> +            */
>>>>>>> +           if (rq->vq->reset) {
>>>>>>> +                   virtnet_napi_enable(rq->vq, &rq->napi);
>>>>>>> +                   continue;
>>>>>>> +           }
>>>>>>
>>>>>> Can we do something similar in virtnet_close() by canceling the work?
>>>>> I think there is no need to cancel the work here, because napi_disable will wait
>>>>> for the napi_enable of the resize. So if the re-enable failed vq is used as a normal
>>>>> vq, this logic can be removed.
>>>> Actually I meant the part of virtnet_rx_resize().
>>>>
>>>> If we don't synchronize with the refill work, it might enable NAPI unexpectedly?
>>> I don't think this situation will be encountered, because napi_disable is
>>> mutually exclusive, so there will be no unexpected napi enable.
>>>
>>> Is there something I misunderstood?
>> So in virtnet_rx_resize() we do:
>>
>> napi_disable()
>> ...
>> resize()
>> ...
>> napi_enalbe()
>>
>> How can we guarantee that the work is not run after the napi_disable()?
>
> I think you're talking about a situation like this:
>
> virtnet_rx_resize          refill work
> -----------------------------------------------------------
>   napi_disable()
>   ...                       napi_disable()
>   resize()                      ...
>                             napi_enable()
>   ...
>   napi_enalbe()
>
>
> But in fact:
>
> virtnet_rx_resize          refill work
> -----------------------------------------------------------
>   napi_disable()
>   ...                       napi_disable() <----[0]
>   resize()                       |
>   ...                            |
>   napi_enalbe()                  |
>                             napi_disable() <---- [1] here success
>                             napi_enable()
>
> Because virtnet_rx_resize() has already executed napi_disable(), napi_disalbe()
> of [0] will wait until [1] to complete.
>
> I'm not sure if my understanding is correct.


I think you're right here.

Thanks


>
> Thanks.
>
>> Thanks
>>
>>> Thanks.
>>>
>>>> Thanks
>>>>
>>>>>
>>>>>>
>>>>>>> +
>>>>>>>              still_empty = !try_fill_recv(vi, rq, GFP_KERNEL);
>>>>>>>              virtnet_napi_enable(rq->vq, &rq->napi);
>>>>>>>
>>>>>>> @@ -1523,6 +1544,10 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
>>>>>>>      if (!sq->napi.weight || is_xdp_raw_buffer_queue(vi, index))
>>>>>>>              return;
>>>>>>>
>>>>>>> +   /* Check if vq is in reset state. See more in virtnet_napi_enable() */
>>>>>>> +   if (sq->vq->reset)
>>>>>>> +           return;
>>>>>>
>>>>>> We've disabled TX napi, any chance we can still hit this?
>>>>> Same as above.
>>>>>
>>>>>>
>>>>>>> +
>>>>>>>      if (__netif_tx_trylock(txq)) {
>>>>>>>              do {
>>>>>>>                      virtqueue_disable_cb(sq->vq);
>>>>>>> @@ -1769,6 +1794,62 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>>>>>>>      return NETDEV_TX_OK;
>>>>>>>    }
>>>>>>>
>>>>>>> +static int virtnet_rx_resize(struct virtnet_info *vi,
>>>>>>> +                        struct receive_queue *rq, u32 ring_num)
>>>>>>> +{
>>>>>>> +   int err;
>>>>>>> +
>>>>>>> +   napi_disable(&rq->napi);
>>>>>>> +
>>>>>>> +   err = virtqueue_resize(rq->vq, ring_num, virtnet_rq_free_unused_buf);
>>>>>>> +   if (err)
>>>>>>> +           goto err;
>>>>>>> +
>>>>>>> +   if (!try_fill_recv(vi, rq, GFP_KERNEL))
>>>>>>> +           schedule_delayed_work(&vi->refill, 0);
>>>>>>> +
>>>>>>> +   virtnet_napi_enable(rq->vq, &rq->napi);
>>>>>>> +   return 0;
>>>>>>> +
>>>>>>> +err:
>>>>>>> +   netdev_err(vi->dev,
>>>>>>> +              "reset rx reset vq fail: rx queue index: %td err: %d\n",
>>>>>>> +              rq - vi->rq, err);
>>>>>>> +   virtnet_napi_enable(rq->vq, &rq->napi);
>>>>>>> +   return err;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static int virtnet_tx_resize(struct virtnet_info *vi,
>>>>>>> +                        struct send_queue *sq, u32 ring_num)
>>>>>>> +{
>>>>>>> +   struct netdev_queue *txq;
>>>>>>> +   int err, qindex;
>>>>>>> +
>>>>>>> +   qindex = sq - vi->sq;
>>>>>>> +
>>>>>>> +   virtnet_napi_tx_disable(&sq->napi);
>>>>>>> +
>>>>>>> +   txq = netdev_get_tx_queue(vi->dev, qindex);
>>>>>>> +   __netif_tx_lock_bh(txq);
>>>>>>> +   netif_stop_subqueue(vi->dev, qindex);
>>>>>>> +   __netif_tx_unlock_bh(txq);
>>>>>>> +
>>>>>>> +   err = virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf);
>>>>>>> +   if (err)
>>>>>>> +           goto err;
>>>>>>> +
>>>>>>> +   netif_start_subqueue(vi->dev, qindex);
>>>>>>> +   virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
>>>>>>> +   return 0;
>>>>>>> +
>>>>>>> +err:
>>>>>>
>>>>>> I guess we can still start the queue in this case? (Since we don't
>>>>>> change the queue if resize fails).
>>>>> Yes, you are right.
>>>>>
>>>>> Thanks.
>>>>>
>>>>>>
>>>>>>> +   netdev_err(vi->dev,
>>>>>>> +              "reset tx reset vq fail: tx queue index: %td err: %d\n",
>>>>>>> +              sq - vi->sq, err);
>>>>>>> +   virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
>>>>>>> +   return err;
>>>>>>> +}
>>>>>>> +
>>>>>>>    /*
>>>>>>>     * Send command via the control virtqueue and check status.  Commands
>>>>>>>     * supported by the hypervisor, as indicated by feature bits, should

