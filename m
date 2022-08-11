Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA33C58F99E
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbiHKI6q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Aug 2022 04:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbiHKI6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:58:45 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA55F93500;
        Thu, 11 Aug 2022 01:58:38 -0700 (PDT)
Received: from mta90.sjtu.edu.cn (unknown [10.118.0.90])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 489ED1008B38D;
        Thu, 11 Aug 2022 16:58:36 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id 367A037C894;
        Thu, 11 Aug 2022 16:58:36 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta90.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta90.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id b23Tk3-bSQrg; Thu, 11 Aug 2022 16:58:36 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta90.sjtu.edu.cn (Postfix) with ESMTP id E110D37C893;
        Thu, 11 Aug 2022 16:58:35 +0800 (CST)
Date:   Thu, 11 Aug 2022 16:58:35 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     jasowang <jasowang@redhat.com>
Cc:     eperezma <eperezma@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Message-ID: <1086777713.7205476.1660208315800.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <CACGkMEt4GzC7t0qqc2SgUWDRB9Amr+XDKiYOKmogrOyfCBFwvA@mail.gmail.com>
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn> <20220721084341.24183-2-qtxuning1999@sjtu.edu.cn> <16a232ad-e0a1-fd4c-ae3e-27db168daacb@redhat.com> <2a8838c4-2e6f-6de7-dcdc-572699ff3dc9@sjtu.edu.cn> <CACGkMEuwgZRt=J_2i-XugMZtcG-xZ7ZF1RpTjmErT5+RCcZ1OQ@mail.gmail.com> <682271447.4491372.1659449548731.JavaMail.zimbra@sjtu.edu.cn> <CACGkMEt4GzC7t0qqc2SgUWDRB9Amr+XDKiYOKmogrOyfCBFwvA@mail.gmail.com>
Subject: Re: [RFC 1/5] vhost: reorder used descriptors in a batch
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [113.222.45.197]
X-Mailer: Zimbra 8.8.15_GA_4308 (ZimbraWebClient - GC103 (Mac)/8.8.15_GA_3928)
Thread-Topic: vhost: reorder used descriptors in a batch
Thread-Index: M16IR97jTiXFP6299ulwkGGu3xALKQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> From: "jasowang" <jasowang@redhat.com>
> To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>
> Cc: "eperezma" <eperezma@redhat.com>, "sgarzare" <sgarzare@redhat.com>, "Michael Tsirkin" <mst@redhat.com>, "netdev"
> <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm list" <kvm@vger.kernel.org>,
> "virtualization" <virtualization@lists.linux-foundation.org>
> Sent: Thursday, August 4, 2022 1:04:16 PM
> Subject: Re: [RFC 1/5] vhost: reorder used descriptors in a batch

> On Tue, Aug 2, 2022 at 10:12 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>>
>>
>>
>> ----- Original Message -----
>> > From: "jasowang" <jasowang@redhat.com>
>> > To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>
>> > Cc: "eperezma" <eperezma@redhat.com>, "sgarzare" <sgarzare@redhat.com>, "Michael
>> > Tsirkin" <mst@redhat.com>, "netdev"
>> > <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm
>> > list" <kvm@vger.kernel.org>,
>> > "virtualization" <virtualization@lists.linux-foundation.org>
>> > Sent: Friday, July 29, 2022 3:32:02 PM
>> > Subject: Re: [RFC 1/5] vhost: reorder used descriptors in a batch
>>
>> > On Thu, Jul 28, 2022 at 4:26 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>> >>
>> >> On 2022/7/26 15:36, Jason Wang wrote:
>> >>
>> >>
>> >> ÔÚ 2022/7/21 16:43, Guo Zhi Ð´µÀ:
>> >>
>> >> Device may not use descriptors in order, for example, NIC and SCSI may
>> >> not call __vhost_add_used_n with buffers in order.  It's the task of
>> >> __vhost_add_used_n to order them.
>> >>
>> >>
>> >>
>> >> I'm not sure this is ture. Having ooo descriptors is probably by design to have
>> >> better performance.
>> >>
>> >> This might be obvious for device that may have elevator or QOS stuffs.
>> >>
>> >> I suspect the right thing to do here is, for the device that can't perform
>> >> better in the case of IN_ORDER, let's simply not offer IN_ORDER (zerocopy or
>> >> scsi). And for the device we know it can perform better, non-zercopy ethernet
>> >> device we can do that.
>> >>
>> >>
>> >>   This commit reorder the buffers using
>> >> vq->heads, only the batch is begin from the expected start point and is
>> >> continuous can the batch be exposed to driver.  And only writing out a
>> >> single used ring for a batch of descriptors, according to VIRTIO 1.1
>> >> spec.
>> >>
>> >>
>> >>
>> >> So this sounds more like a "workaround" of the device that can't consume buffer
>> >> in order, I suspect it can help in performance.
>> >>
>> >> More below.
>> >>
>> >>
>> >>
>> >> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> >> ---
>> >>   drivers/vhost/vhost.c | 44 +++++++++++++++++++++++++++++++++++++++++--
>> >>   drivers/vhost/vhost.h |  3 +++
>> >>   2 files changed, 45 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> >> index 40097826c..e2e77e29f 100644
>> >> --- a/drivers/vhost/vhost.c
>> >> +++ b/drivers/vhost/vhost.c
>> >> @@ -317,6 +317,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>> >>       vq->used_flags = 0;
>> >>       vq->log_used = false;
>> >>       vq->log_addr = -1ull;
>> >> +    vq->next_used_head_idx = 0;
>> >>       vq->private_data = NULL;
>> >>       vq->acked_features = 0;
>> >>       vq->acked_backend_features = 0;
>> >> @@ -398,6 +399,8 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>> >>                         GFP_KERNEL);
>> >>           if (!vq->indirect || !vq->log || !vq->heads)
>> >>               goto err_nomem;
>> >> +
>> >> +        memset(vq->heads, 0, sizeof(*vq->heads) * dev->iov_limit);
>> >>       }
>> >>       return 0;
>> >>   @@ -2374,12 +2377,49 @@ static int __vhost_add_used_n(struct vhost_virtqueue
>> >>   *vq,
>> >>                   unsigned count)
>> >>   {
>> >>       vring_used_elem_t __user *used;
>> >> +    struct vring_desc desc;
>> >>       u16 old, new;
>> >>       int start;
>> >> +    int begin, end, i;
>> >> +    int copy_n = count;
>> >> +
>> >> +    if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>> >>
>> >>
>> >>
>> >> How do you guarantee that ids of heads are contiguous?
>> >>
>> >> There is no need to be contiguous for ids of heads.
>> >>
>> >> For example, I have three buffer { .id = 0, 15}, {.id = 20, 30} {.id = 15, 20}
>> >> for vhost_add_used_n. Then I will let the vq->heads[0].len=15.
>> >> vq->heads[15].len=5, vq->heads[20].len=10 as reorder. Once I found there is no
>> >> hold in the batched descriptors. I will expose them to driver.
>> >
>> > So spec said:
>> >
>> > "If VIRTIO_F_IN_ORDER has been negotiated, driver uses descriptors in
>> > ring order: starting from offset 0 in the table, and wrapping around
>> > at the end of the table."
>> >
>> > And
>> >
>> > "VIRTIO_F_IN_ORDER(35)This feature indicates that all buffers are used
>> > by the device in the same order in which they have been made
>> > available."
>> >
>> > This means your example is not an IN_ORDER device.
>> >
>> > The driver should submit buffers (assuming each buffer have one
>> > descriptor) in order {id = 0, 15}, {id = 1, 30} and {id = 2, 20}.
>> >
>> > And even if it is submitted in order, we can not use a batch because:
>> >
>> > "The skipped buffers (for which no used ring entry was written) are
>> > assumed to have been used (read or written) by the device completely."
>> >
>> > This means for TX we are probably ok, but for rx, unless we know the
>> > buffers were written completely, we can't write them in a batch.
>> >
>> > I'd suggest to do cross testing for this series:
>> >
>> > 1) testing vhost IN_ORDER support with DPDK virtio PMD
>> > 2) testing virtio IN_ORDER with DPDK vhost-user via testpmd
>> >
>> > Thanks
>> >
>> You are correct, for rx we can't do a batch because we have to let the driver
>> know the length of buffers.
> 
> Note that we can do a batch for rx when we know all the buffers have
> been fully written.
> 
>>
>> I think these circumstances can offer batch:
>> 1. tx
>> 2. rx with RX_MRGBUF feature, which introduce a header for each received buffer
>>
>> Consider batch is not a mandatory requirement for in order feature according to
>> spec.
>> I'd like to let current RFC patch focus on in order implementation, and send
>> another
>> patch series to improve performance by batching on above circumstances.
> 
> That's fine, how about simply starting from the patch that offers
> IN_ORDER when zerocopy is disabled?
> 

Yeah, I'd like to start from vsock device, which doesn't use zerocopy

Thanks
> Thanks
> 
>>
>> What's your opinon.
>>
>> Thanks
>> >
>> >>
>> >>
>> >> +        /* calculate descriptor chain length for each used buffer */
>> >>
>> >>
>> >>
>> >> I'm a little bit confused about this comment, we have heads[i].len for this?
>> >>
>> >> Maybe I should not use vq->heads, some misleading.
>> >>
>> >>
>> >> +        for (i = 0; i < count; i++) {
>> >> +            begin = heads[i].id;
>> >> +            end = begin;
>> >> +            vq->heads[begin].len = 0;
>> >>
>> >>
>> >>
>> >> Does this work for e.g RX virtqueue?
>> >>
>> >>
>> >> +            do {
>> >> +                vq->heads[begin].len += 1;
>> >> +                if (unlikely(vhost_get_desc(vq, &desc, end))) {
>> >>
>> >>
>> >>
>> >> Let's try hard to avoid more userspace copy here, it's the source of performance
>> >> regression.
>> >>
>> >> Thanks
>> >>
>> >>
>> >> +                    vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
>> >> +                           end, vq->desc + end);
>> >> +                    return -EFAULT;
>> >> +                }
>> >> +            } while ((end = next_desc(vq, &desc)) != -1);
>> >> +        }
>> >> +
>> >> +        count = 0;
>> >> +        /* sort and batch continuous used ring entry */
>> >> +        while (vq->heads[vq->next_used_head_idx].len != 0) {
>> >> +            count++;
>> >> +            i = vq->next_used_head_idx;
>> >> +            vq->next_used_head_idx = (vq->next_used_head_idx +
>> >> +                          vq->heads[vq->next_used_head_idx].len)
>> >> +                          % vq->num;
>> >> +            vq->heads[i].len = 0;
>> >> +        }
>> >> +        /* only write out a single used ring entry with the id corresponding
>> >> +         * to the head entry of the descriptor chain describing the last buffer
>> >> +         * in the batch.
>> >> +         */
>> >> +        heads[0].id = i;
>> >> +        copy_n = 1;
>> >> +    }
>> >>         start = vq->last_used_idx & (vq->num - 1);
>> >>       used = vq->used->ring + start;
>> >> -    if (vhost_put_used(vq, heads, start, count)) {
>> >> +    if (vhost_put_used(vq, heads, start, copy_n)) {
>> >>           vq_err(vq, "Failed to write used");
>> >>           return -EFAULT;
>> >>       }
>> >> @@ -2410,7 +2450,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct
>> >> vring_used_elem *heads,
>> >>         start = vq->last_used_idx & (vq->num - 1);
>> >>       n = vq->num - start;
>> >> -    if (n < count) {
>> >> +    if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>> >>           r = __vhost_add_used_n(vq, heads, n);
>> >>           if (r < 0)
>> >>               return r;
>> >> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>> >> index d9109107a..7b2c0fbb5 100644
>> >> --- a/drivers/vhost/vhost.h
>> >> +++ b/drivers/vhost/vhost.h
>> >> @@ -107,6 +107,9 @@ struct vhost_virtqueue {
>> >>       bool log_used;
>> >>       u64 log_addr;
>> >>   +    /* Sort heads in order */
>> >> +    u16 next_used_head_idx;
>> >> +
>> >>       struct iovec iov[UIO_MAXIOV];
>> >>       struct iovec iotlb_iov[64];
>> >>       struct iovec *indirect;
>> >>
>> >>
>> >>
>>
