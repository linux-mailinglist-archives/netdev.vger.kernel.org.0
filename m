Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5176C803C
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 15:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbjCXOr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 10:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbjCXOrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 10:47:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB30718AB8
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 07:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679669223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AuOjQOzMJu7jhalrvIVzIXLam0VRoOPHkDU+QEY7YhI=;
        b=gkmf1zbq6bQV7ABVdmpbP65Iu3Fdif3EFYsApnmGRHdgUMqnQ4HIAXbzyQLRiAqo75bKGd
        WsX0Mc/WMn2AwEhmQl2Vfsb9RAD0RF5qQqEdLba7UZiKj2yHdQe1BedYwN2v2+Du3ErewG
        X7onXIQTbSUfq+D5tI1XhkZqRBBenoc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-NKjWIPwbPqqlzUsPAlKvuQ-1; Fri, 24 Mar 2023 10:47:01 -0400
X-MC-Unique: NKjWIPwbPqqlzUsPAlKvuQ-1
Received: by mail-ed1-f72.google.com with SMTP id c1-20020a0564021f8100b004acbe232c03so3480368edc.9
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 07:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679669220;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AuOjQOzMJu7jhalrvIVzIXLam0VRoOPHkDU+QEY7YhI=;
        b=Ak5FREw9bMVXb2LdCZ8EWOWkU57jYv9Z6KBqwBY1V9QEV/wfgOZP7d+veDhJgyaCv1
         fGwKZg92Vu8AGjn6kNfcZb1wtCBRut/9hdEklE1UIURRx4MS5WtVmQ313hsMWEW6nJ6n
         KGczhAFjsa/B3/MQcQHgshq8mTDGdas36ktYT27DrGbZ2gRp59yp6yWcPmntzIqV9PTd
         G063ynWcOTmDHEP8jnZ44A21Hk5Gm91vyGQ9DmnzrbAL32yklUeDXS01DsxQLl/oda3c
         BcgIwPo495bgzKg6OTC4tILkQnAzVdBY1f7Xsd7Cp56Wc48Q345SvZVbGZ+Za0hNRIul
         Eeig==
X-Gm-Message-State: AAQBX9e888Z70VGx8sDN7hm+FkG+FyXDAfdofpp5aeSURc+a7SNAV02T
        aqu96Su4knu5IjqXD4nOSraZx7WFrkpaABeRQbjILcafNVIu2h/Mda3NqLHBOc59kfwuTlud8ei
        X3EUZDtuhkVHga2pS
X-Received: by 2002:a17:906:fa1b:b0:922:2ba3:2348 with SMTP id lo27-20020a170906fa1b00b009222ba32348mr2995760ejb.7.1679669220707;
        Fri, 24 Mar 2023 07:47:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZmfFJPCyGmiPR7O9KckKD9I87Kx7AyWLHRPUqCBRX1gMg+6qZWwdI6wSPtk2G3zOFrDNdJyA==
X-Received: by 2002:a17:906:fa1b:b0:922:2ba3:2348 with SMTP id lo27-20020a170906fa1b00b009222ba32348mr2995743ejb.7.1679669220454;
        Fri, 24 Mar 2023 07:47:00 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id c14-20020a509f8e000000b005003fd12eafsm10711203edf.63.2023.03.24.07.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 07:46:59 -0700 (PDT)
Date:   Fri, 24 Mar 2023 15:46:57 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, linux-kernel@vger.kernel.org,
        eperezma@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 8/8] vdpa_sim: add support for user VA
Message-ID: <qrnz6o73374x5hio4jkgpj7et4ihym2wniob25so2zbsyjxagp@lwprqyc5xp7n>
References: <20230321154228.182769-1-sgarzare@redhat.com>
 <20230321154804.184577-1-sgarzare@redhat.com>
 <20230321154804.184577-4-sgarzare@redhat.com>
 <78c7511a-deab-7e95-fde1-5317a568cf97@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <78c7511a-deab-7e95-fde1-5317a568cf97@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 11:49:32AM +0800, Jason Wang wrote:
>
>在 2023/3/21 23:48, Stefano Garzarella 写道:
>>The new "use_va" module parameter (default: true) is used in
>>vdpa_alloc_device() to inform the vDPA framework that the device
>>supports VA.
>>
>>vringh is initialized to use VA only when "use_va" is true and the
>>user's mm has been bound. So, only when the bus supports user VA
>>(e.g. vhost-vdpa).
>>
>>vdpasim_mm_work_fn work is used to serialize the binding to a new
>>address space when the .bind_mm callback is invoked, and unbinding
>>when the .unbind_mm callback is invoked.
>>
>>Call mmget_not_zero()/kthread_use_mm() inside the worker function
>>to pin the address space only as long as needed, following the
>>documentation of mmget() in include/linux/sched/mm.h:
>>
>>   * Never use this function to pin this address space for an
>>   * unbounded/indefinite amount of time.
>>
>>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>---
>>
>>Notes:
>>     v3:
>>     - called mmget_not_zero() before kthread_use_mm() [Jason]
>>       As the documentation of mmget() in include/linux/sched/mm.h says:
>>       * Never use this function to pin this address space for an
>>       * unbounded/indefinite amount of time.
>>       I moved mmget_not_zero/kthread_use_mm inside the worker function,
>>       this way we pin the address space only as long as needed.
>>       This is similar to what vfio_iommu_type1_dma_rw_chunk() does in
>>       drivers/vfio/vfio_iommu_type1.c
>>     - simplified the mm bind/unbind [Jason]
>>     - renamed vdpasim_worker_change_mm_sync() [Jason]
>>     - fix commit message (s/default: false/default: true)
>>     v2:
>>     - `use_va` set to true by default [Eugenio]
>>     - supported the new unbind_mm callback [Jason]
>>     - removed the unbind_mm call in vdpasim_do_reset() [Jason]
>>     - avoided to release the lock while call kthread_flush_work() since we
>>       are now using a mutex to protect the device state
>>
>>  drivers/vdpa/vdpa_sim/vdpa_sim.h |  1 +
>>  drivers/vdpa/vdpa_sim/vdpa_sim.c | 80 +++++++++++++++++++++++++++++++-
>>  2 files changed, 79 insertions(+), 2 deletions(-)
>>
>>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>>index 4774292fba8c..3a42887d05d9 100644
>>--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
>>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
>>@@ -59,6 +59,7 @@ struct vdpasim {
>>  	struct vdpasim_virtqueue *vqs;
>>  	struct kthread_worker *worker;
>>  	struct kthread_work work;
>>+	struct mm_struct *mm_bound;
>>  	struct vdpasim_dev_attr dev_attr;
>>  	/* mutex to synchronize virtqueue state */
>>  	struct mutex mutex;
>>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>>index ab4cfb82c237..23c891cdcd54 100644
>>--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>>@@ -35,10 +35,44 @@ module_param(max_iotlb_entries, int, 0444);
>>  MODULE_PARM_DESC(max_iotlb_entries,
>>  		 "Maximum number of iotlb entries for each address space. 0 means unlimited. (default: 2048)");
>>+static bool use_va = true;
>>+module_param(use_va, bool, 0444);
>>+MODULE_PARM_DESC(use_va, "Enable/disable the device's ability to use VA");
>>+
>>  #define VDPASIM_QUEUE_ALIGN PAGE_SIZE
>>  #define VDPASIM_QUEUE_MAX 256
>>  #define VDPASIM_VENDOR_ID 0
>>+struct vdpasim_mm_work {
>>+	struct kthread_work work;
>>+	struct vdpasim *vdpasim;
>>+	struct mm_struct *mm_to_bind;
>>+	int ret;
>>+};
>>+
>>+static void vdpasim_mm_work_fn(struct kthread_work *work)
>>+{
>>+	struct vdpasim_mm_work *mm_work =
>>+		container_of(work, struct vdpasim_mm_work, work);
>>+	struct vdpasim *vdpasim = mm_work->vdpasim;
>>+
>>+	mm_work->ret = 0;
>>+
>>+	//TODO: should we attach the cgroup of the mm owner?
>>+	vdpasim->mm_bound = mm_work->mm_to_bind;
>>+}
>>+
>>+static void vdpasim_worker_change_mm_sync(struct vdpasim *vdpasim,
>>+					  struct vdpasim_mm_work *mm_work)
>>+{
>>+	struct kthread_work *work = &mm_work->work;
>>+
>>+	kthread_init_work(work, vdpasim_mm_work_fn);
>>+	kthread_queue_work(vdpasim->worker, work);
>>+
>>+	kthread_flush_work(work);
>>+}
>>+
>>  static struct vdpasim *vdpa_to_sim(struct vdpa_device *vdpa)
>>  {
>>  	return container_of(vdpa, struct vdpasim, vdpa);
>>@@ -59,8 +93,10 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
>>  {
>>  	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
>>  	uint16_t last_avail_idx = vq->vring.last_avail_idx;
>>+	bool va_enabled = use_va && vdpasim->mm_bound;
>>-	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true, false,
>>+	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true,
>>+			  va_enabled,
>>  			  (struct vring_desc *)(uintptr_t)vq->desc_addr,
>>  			  (struct vring_avail *)
>>  			  (uintptr_t)vq->driver_addr,
>>@@ -130,8 +166,20 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops;
>>  static void vdpasim_work_fn(struct kthread_work *work)
>>  {
>>  	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
>>+	struct mm_struct *mm = vdpasim->mm_bound;
>>+
>>+	if (mm) {
>>+		if (!mmget_not_zero(mm))
>>+			return;
>
>
>Do we need to check use_va here.

Yep, right!

>
>Other than this
>
>Acked-by: Jason Wang <jasowang@redhat.com>

Thanks for the reviews,
Stefano

