Return-Path: <netdev+bounces-776-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DEF66F9E1A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 05:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE14C280EB4
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 03:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA19125BC;
	Mon,  8 May 2023 03:12:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DA05248
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 03:12:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335EE7ED1
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 20:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683515533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9nyAgUbuTjzD6fHJpqxIZiFQeyCjpbJk624bFTFNpfo=;
	b=dqAL4kMtn1iPVye9ftLbseCCSTCjkzdJSEHmWjTl6S72iWjsgp3N2vv26LhkwWXAXioEUH
	X3C+siAfl1JAm+J/w9JsmL1jK4uveIo2/adgi4TCAwvzim522IUnzI/CAgheEgGZ+t+WZ/
	Us0YeHduY8an97DUjCrI7KEkmp8BqkY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-H09zp729M3G2hdA06ObeAA-1; Sun, 07 May 2023 23:12:12 -0400
X-MC-Unique: H09zp729M3G2hdA06ObeAA-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1ab032d91a1so22133235ad.1
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 20:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683515531; x=1686107531;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9nyAgUbuTjzD6fHJpqxIZiFQeyCjpbJk624bFTFNpfo=;
        b=iq4N9kQ8XBb2ovGe04dosic/PFOcB4XQLT7a4AFg5mbpZZCpd95U7u82d81hXaI5j/
         CTA17NLPNAB1D44RoVj03IJAsQ6+/+UmIkBnHv8vet2YPsSkaVB05FxshfIs+OALDHH5
         18S5S6llAbKDaPITBXPgte8LqbxOXGOTD4Zk1kqeqZd8K+lxQDi2Up37wAfi9RFG0s4i
         hs2JgrpDghcH1qnpfWHUpdIjhAyKlr/gVfr5DLyrwwAfM+cnMBxClExThjAub4Y4VIwU
         XCIN32HzINQlZm7dcEJ4cvxLjlqHQGOZ6D5sW7W19iq2axRA3johp6e/TI8sDgXvXVkS
         oqtA==
X-Gm-Message-State: AC+VfDy62HYDWJ1eIoOib+Rwi5Ip3Y4HOswko7Rf/4fMp1bmusuajZh/
	TjdnDtLamBIbHfmy8NY1OLta5CteWq7fTrql5LIr2YnlMFgMTZQXs0ZFRJvDAS0o+o7v3Mye0zJ
	MXbGXdtRkcCLzCbX/
X-Received: by 2002:a17:902:a516:b0:1ab:1355:1a45 with SMTP id s22-20020a170902a51600b001ab13551a45mr8724901plq.30.1683515530941;
        Sun, 07 May 2023 20:12:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4Dsr/5I/1xDjPCTgBELpkfYOze5JmdS9lW2LqmCICvddW3VQUgjgtMk5CSsiE4sTTKAkq0Yg==
X-Received: by 2002:a17:902:a516:b0:1ab:1355:1a45 with SMTP id s22-20020a170902a51600b001ab13551a45mr8724890plq.30.1683515530640;
        Sun, 07 May 2023 20:12:10 -0700 (PDT)
Received: from [10.72.12.58] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o4-20020a170902d4c400b00199193e5ea1sm5857923plg.61.2023.05.07.20.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 May 2023 20:12:10 -0700 (PDT)
Message-ID: <2b5cf90a-efa8-52a7-9277-77722622c128@redhat.com>
Date: Mon, 8 May 2023 11:12:03 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v4] virtio_net: suppress cpu stall when free_unused_bufs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Wenliang Wang <wangwenliang.1995@bytedance.com>, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 zhengqi.arch@bytedance.com, willemdebruijn.kernel@gmail.com,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com
References: <1683167226-7012-1-git-send-email-wangwenliang.1995@bytedance.com>
 <CACGkMEs_4kUzc6iSBWvhZA1+U70Pp0o+WhE0aQnC-5pECW7QXA@mail.gmail.com>
 <20230507093328-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Jason Wang <jasowang@redhat.com>
In-Reply-To: <20230507093328-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


在 2023/5/7 21:34, Michael S. Tsirkin 写道:
> On Fri, May 05, 2023 at 11:28:25AM +0800, Jason Wang wrote:
>> On Thu, May 4, 2023 at 10:27 AM Wenliang Wang
>> <wangwenliang.1995@bytedance.com> wrote:
>>> For multi-queue and large ring-size use case, the following error
>>> occurred when free_unused_bufs:
>>> rcu: INFO: rcu_sched self-detected stall on CPU.
>>>
>>> Fixes: 986a4f4d452d ("virtio_net: multiqueue support")
>>> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
>>> ---
>>> v2:
>>> -add need_resched check.
>>> -apply same logic to sq.
>>> v3:
>>> -use cond_resched instead.
>>> v4:
>>> -add fixes tag
>>> ---
>>>   drivers/net/virtio_net.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index 8d8038538fc4..a12ae26db0e2 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -3560,12 +3560,14 @@ static void free_unused_bufs(struct virtnet_info *vi)
>>>                  struct virtqueue *vq = vi->sq[i].vq;
>>>                  while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
>>>                          virtnet_sq_free_unused_buf(vq, buf);
>>> +               cond_resched();
>> Does this really address the case when the virtqueue is very large?
>>
>> Thanks
>
> it does in that a very large queue is still just 64k in size.
> we might however have 64k of these queues.


Ok, but we have other similar loops especially the refill, I think we 
may need cond_resched() there as well.

Thanks


>
>>>          }
>>>
>>>          for (i = 0; i < vi->max_queue_pairs; i++) {
>>>                  struct virtqueue *vq = vi->rq[i].vq;
>>>                  while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
>>>                          virtnet_rq_free_unused_buf(vq, buf);
>>> +               cond_resched();
>>>          }
>>>   }
>>>
>>> --
>>> 2.20.1
>>>


