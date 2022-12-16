Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FFF64E803
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 09:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiLPINz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 03:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiLPINz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 03:13:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E2D2BB36
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 00:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671178389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bQjL3q+AnOHU8AQ6TvuOdI4mq0zg5ZcY1jgOH3hwbcw=;
        b=F3uvSvlu1/SjJqkpj8HYdwIyeHaZx4VpfLRoiRaI3kCg+nVUOxVv7ScNHAN048WyMUjcaM
        zu/46WWvzq+PxOnRLQuI4V1ZEY3y3BTA0ShwiOXj7kGagF9A7FJ77ELRTbvE9z5WrjnCH4
        /P9IdUexDY8+TJu3nQpaPCgNe/CSxiE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-635-ucgcWG92Odyyn_HY5E_MGg-1; Fri, 16 Dec 2022 03:13:08 -0500
X-MC-Unique: ucgcWG92Odyyn_HY5E_MGg-1
Received: by mail-ed1-f72.google.com with SMTP id y20-20020a056402271400b0046c9a6ec30fso1330520edd.14
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 00:13:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQjL3q+AnOHU8AQ6TvuOdI4mq0zg5ZcY1jgOH3hwbcw=;
        b=Zi9SkJergIcAhSfFb7s5ujWPtsjRDmKin1DvHE9/AGdk8kHX+zEAQGRG7ZLyM/Ebpl
         +lOE1wt5tqmsOZ1Z9/7i9i5CEEtDtPOthNhB4TFDET6WCwdhPtAis2I0BRSRB37t8Z7u
         nSIknyMl5s/hgDCbnLyVw75KbxVem3KuKdlJb4GayOa/U41O3wZt9XImtAI66H4ZFCLZ
         U4f+K6vmxHx1kOt9nZBKlSycbtLG3yZsvDA68wayLmQwx2XBjd7ie/1/clPERxzQ0b7J
         Fs5ga9L/Vc71YGhodET1S/n/PcDIqdt71eHCwzMFmK3AQ+ZDu9CM5V3B5L6bLlWEnd9P
         puEQ==
X-Gm-Message-State: ANoB5pmGduYAKWbxcy7BJEI1WWU/mDIuhcSQozEqRB26gj8LcjyI4PJF
        6QJWUPNLEFLMUN9xsnVJVw1w/YivvKSamd4MAMXNIjY34osQVCrTdjsDDs3LT1dBYxKVcUktgyp
        b3XKwVOOQRgnm79aO
X-Received: by 2002:a17:906:355a:b0:7c1:524d:2bec with SMTP id s26-20020a170906355a00b007c1524d2becmr19852128eja.39.1671178387558;
        Fri, 16 Dec 2022 00:13:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5wE+zDRSipmZT34oqhzqGjoBGWViMN+Y0mBwmRSDBo4LL94Dtq8vBJH6J3QxiaqrDxb4PfAA==
X-Received: by 2002:a17:906:355a:b0:7c1:524d:2bec with SMTP id s26-20020a170906355a00b007c1524d2becmr19852111eja.39.1671178387343;
        Fri, 16 Dec 2022 00:13:07 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id k1-20020a17090632c100b007c10ad73927sm568966ejk.28.2022.12.16.00.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 00:13:06 -0800 (PST)
Date:   Fri, 16 Dec 2022 09:13:03 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com,
        stefanha@redhat.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] vdpa_sim: add support for user VA
Message-ID: <20221216081303.p4pcveclfa5n4slw@sgarzare-redhat>
References: <20221214163025.103075-1-sgarzare@redhat.com>
 <20221214163025.103075-7-sgarzare@redhat.com>
 <CACGkMEuk0xNwthy4NgR1xPfEVt-EgtmZmfiacJprGgyvi3hVAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACGkMEuk0xNwthy4NgR1xPfEVt-EgtmZmfiacJprGgyvi3hVAA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 03:26:46PM +0800, Jason Wang wrote:
>On Thu, Dec 15, 2022 at 12:31 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> The new "use_va" module parameter (default: false) is used in
>> vdpa_alloc_device() to inform the vDPA framework that the device
>> supports VA.
>>
>> vringh is initialized to use VA only when "use_va" is true and the
>> user's mm has been bound. So, only when the bus supports user VA
>> (e.g. vhost-vdpa).
>>
>> vdpasim_mm_work_fn work is used to attach the kthread to the user
>> address space when the .bind_mm callback is invoked, and to detach
>> it when the device is reset.
>
>One thing in my mind is that the current datapath is running under
>spinlock which prevents us from using iov_iter (which may have page
>faults).
>
>We need to get rid of the spinlock first.

Right! I already have a patch for that since I used for the vdpa-blk 
software device in-kernel PoC where I had the same issue.

I'll add it to the series!

>
>>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>  drivers/vdpa/vdpa_sim/vdpa_sim.h |   1 +
>>  drivers/vdpa/vdpa_sim/vdpa_sim.c | 104 ++++++++++++++++++++++++++++++-
>>  2 files changed, 103 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>> index 07ef53ea375e..1b010e5c0445 100644
>> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
>> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>> @@ -55,6 +55,7 @@ struct vdpasim {
>>         struct vdpasim_virtqueue *vqs;
>>         struct kthread_worker *worker;
>>         struct kthread_work work;
>> +       struct mm_struct *mm_bound;
>>         struct vdpasim_dev_attr dev_attr;
>>         /* spinlock to synchronize virtqueue state */
>>         spinlock_t lock;
>> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> index 36a1d2e0a6ba..6e07cedef30c 100644
>> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>> @@ -36,10 +36,90 @@ module_param(max_iotlb_entries, int, 0444);
>>  MODULE_PARM_DESC(max_iotlb_entries,
>>                  "Maximum number of iotlb entries for each address space. 0 means unlimited. (default: 2048)");
>>
>> +static bool use_va;
>> +module_param(use_va, bool, 0444);
>> +MODULE_PARM_DESC(use_va, "Enable the device's ability to use VA");
>> +
>>  #define VDPASIM_QUEUE_ALIGN PAGE_SIZE
>>  #define VDPASIM_QUEUE_MAX 256
>>  #define VDPASIM_VENDOR_ID 0
>>
>> +struct vdpasim_mm_work {
>> +       struct kthread_work work;
>> +       struct task_struct *owner;
>> +       struct mm_struct *mm;
>> +       bool bind;
>> +       int ret;
>> +};
>> +
>> +static void vdpasim_mm_work_fn(struct kthread_work *work)
>> +{
>> +       struct vdpasim_mm_work *mm_work =
>> +               container_of(work, struct vdpasim_mm_work, work);
>> +
>> +       mm_work->ret = 0;
>> +
>> +       if (mm_work->bind) {
>> +               kthread_use_mm(mm_work->mm);
>> +#if 0
>> +               if (mm_work->owner)
>> +                       mm_work->ret = cgroup_attach_task_all(mm_work->owner,
>> +                                                             current);
>> +#endif
>> +       } else {
>> +#if 0
>> +               //TODO: check it
>> +               cgroup_release(current);
>> +#endif
>> +               kthread_unuse_mm(mm_work->mm);
>> +       }
>> +}
>> +
>> +static void vdpasim_worker_queue_mm(struct vdpasim *vdpasim,
>> +                                   struct vdpasim_mm_work *mm_work)
>> +{
>> +       struct kthread_work *work = &mm_work->work;
>> +
>> +       kthread_init_work(work, vdpasim_mm_work_fn);
>> +       kthread_queue_work(vdpasim->worker, work);
>> +
>> +       spin_unlock(&vdpasim->lock);
>> +       kthread_flush_work(work);
>> +       spin_lock(&vdpasim->lock);
>> +}
>> +
>> +static int vdpasim_worker_bind_mm(struct vdpasim *vdpasim,
>> +                                 struct mm_struct *new_mm,
>> +                                 struct task_struct *owner)
>> +{
>> +       struct vdpasim_mm_work mm_work;
>> +
>> +       mm_work.owner = owner;
>> +       mm_work.mm = new_mm;
>> +       mm_work.bind = true;
>> +
>> +       vdpasim_worker_queue_mm(vdpasim, &mm_work);
>> +
>
>Should we wait for the work to be finished?

Yep, I'm waiting inside vdpasim_worker_queue_mm() calling 
kthread_flush_work().

If we will use mutex, I think we can avoid the lock release around that 
call.

>
>> +       if (!mm_work.ret)
>> +               vdpasim->mm_bound = new_mm;
>> +
>> +       return mm_work.ret;
>> +}
>> +
>> +static void vdpasim_worker_unbind_mm(struct vdpasim *vdpasim)
>> +{
>> +       struct vdpasim_mm_work mm_work;
>> +
>> +       if (!vdpasim->mm_bound)
>> +               return;
>> +
>> +       mm_work.mm = vdpasim->mm_bound;
>> +       mm_work.bind = false;
>> +
>> +       vdpasim_worker_queue_mm(vdpasim, &mm_work);
>> +
>> +       vdpasim->mm_bound = NULL;
>> +}
>>  static struct vdpasim *vdpa_to_sim(struct vdpa_device *vdpa)
>>  {
>>         return container_of(vdpa, struct vdpasim, vdpa);
>> @@ -66,8 +146,10 @@ static void vdpasim_vq_notify(struct vringh *vring)
>>  static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
>>  {
>>         struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
>> +       bool va_enabled = use_va && vdpasim->mm_bound;
>>
>> -       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, false, false,
>> +       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, false,
>> +                         va_enabled,
>>                           (struct vring_desc *)(uintptr_t)vq->desc_addr,
>>                           (struct vring_avail *)
>>                           (uintptr_t)vq->driver_addr,
>> @@ -96,6 +178,9 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
>>  {
>>         int i;
>>
>> +       //TODO: should we cancel the works?
>> +       vdpasim_worker_unbind_mm(vdpasim);
>
>We probably don't need this since it's the virtio level reset so we
>need to keep the mm bound in this case. Otherwise we may break the
>guest. It should be the responsibility of the driver to call
>config_ops->unbind if it needs to do that.

Got it, my biggest concern was when we go from a vhost-vdpa virtio-vdpa, 
but as you said, in vhost-vdpa I can call unbind before releasing the 
device.

Thanks,
Stefano

