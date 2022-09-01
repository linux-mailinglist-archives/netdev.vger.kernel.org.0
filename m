Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193365A8E1A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 08:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbiIAGOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 02:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbiIAGOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 02:14:14 -0400
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15537119C50;
        Wed, 31 Aug 2022 23:14:13 -0700 (PDT)
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
        by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id 6F06D10087D60;
        Thu,  1 Sep 2022 14:14:10 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id 1FC8237C83F;
        Thu,  1 Sep 2022 14:14:10 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta91.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta91.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id sNz9ikVBzg68; Thu,  1 Sep 2022 14:14:10 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id E611837C83E;
        Thu,  1 Sep 2022 14:14:09 +0800 (CST)
Date:   Thu, 1 Sep 2022 14:14:09 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        eperezma <eperezma@redhat.com>, jasowang <jasowang@redhat.com>,
        sgarzare <sgarzare@redhat.com>, Michael Tsirkin <mst@redhat.com>
Message-ID: <1987009989.9672563.1662012849811.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <1662012423.9200838-1-xuanzhuo@linux.alibaba.com>
References: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn> <20220901055434.824-6-qtxuning1999@sjtu.edu.cn> <1662012423.9200838-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC v3 5/7] virtio: unmask F_NEXT flag in desc_extra
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.162.206.161]
X-Mailer: Zimbra 8.8.15_GA_4308 (ZimbraWebClient - GC104 (Mac)/8.8.15_GA_3928)
Thread-Topic: virtio: unmask F_NEXT flag in desc_extra
Thread-Index: 2yceLelHrZ0oQXoJXM26DE2cdEtpSw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> From: "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>
> To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>
> Cc: "netdev" <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm list" <kvm@vger.kernel.org>,
> "virtualization" <virtualization@lists.linux-foundation.org>, "Guo Zhi" <qtxuning1999@sjtu.edu.cn>, "eperezma"
> <eperezma@redhat.com>, "jasowang" <jasowang@redhat.com>, "sgarzare" <sgarzare@redhat.com>, "Michael Tsirkin"
> <mst@redhat.com>
> Sent: Thursday, September 1, 2022 2:07:03 PM
> Subject: Re: [RFC v3 5/7] virtio: unmask F_NEXT flag in desc_extra

> On Thu,  1 Sep 2022 13:54:32 +0800, Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>> We didn't unmask F_NEXT flag in desc_extra in the end of a chain,
>> unmask it so that we can access desc_extra to get next information.
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>  drivers/virtio/virtio_ring.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>> index a5ec724c01d8..00aa4b7a49c2 100644
>> --- a/drivers/virtio/virtio_ring.c
>> +++ b/drivers/virtio/virtio_ring.c
>> @@ -567,7 +567,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>>  	}
>>  	/* Last one doesn't continue. */
>>  	desc[prev].flags &= cpu_to_virtio16(_vq->vdev, ~VRING_DESC_F_NEXT);
>> -	if (!indirect && vq->use_dma_api)
>> +	if (!indirect)
>>  		vq->split.desc_extra[prev & (vq->split.vring.num - 1)].flags &=
>>  			~VRING_DESC_F_NEXT;
>>
>> @@ -584,6 +584,8 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>>  					 total_sg * sizeof(struct vring_desc),
>>  					 VRING_DESC_F_INDIRECT,
>>  					 false);
>> +		vq->split.desc_extra[head & (vq->split.vring.num - 1)].flags &=
>> +			~VRING_DESC_F_NEXT;
> 
> Wondering if this is necessary? When setting flags, NEXT is not included.

I adopted your advice in this patch series and remove this unnecessary code, but I
leave that modification i patch 6/7. Sorry for my git rebase mistake.

Thanks

> 
>>  	}
>>
>>  	/* We're using some buffers from the free list. */
>> @@ -685,7 +687,6 @@ static void detach_buf_split(struct vring_virtqueue *vq,
>> unsigned int head,
>>  			     void **ctx)
>>  {
>>  	unsigned int i, j;
>> -	__virtio16 nextflag = cpu_to_virtio16(vq->vq.vdev, VRING_DESC_F_NEXT);
>>
>>  	/* Clear data ptr. */
>>  	vq->split.desc_state[head].data = NULL;
>> @@ -693,7 +694,7 @@ static void detach_buf_split(struct vring_virtqueue *vq,
>> unsigned int head,
>>  	/* Put back on free list: unmap first-level descriptors and find end */
>>  	i = head;
>>
>> -	while (vq->split.vring.desc[i].flags & nextflag) {
>> +	while (vq->split.desc_extra[i].flags & VRING_DESC_F_NEXT) {
>>  		vring_unmap_one_split(vq, i);
>>  		i = vq->split.desc_extra[i].next;
>>  		vq->vq.num_free++;
>> --
>> 2.17.1
>>
