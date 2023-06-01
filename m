Return-Path: <netdev+bounces-7023-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7906D7194AF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 09:47:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F94928152D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 07:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD401C12A;
	Thu,  1 Jun 2023 07:47:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9076ADF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 07:47:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80888170E
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 00:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685605672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LJY0ffzy9d7zjgW/HEvqIO2dS8yVBrmwr6J73PuSOuU=;
	b=CgGko6pxX5vQUtwvveXVGwMkmHEdL/1TxFwGQGOQTVaJM3XcLWQ3rr+Oa/5vLiRh9IvZTZ
	Av/mqrbLDZ5AQCXEKSgx12paf/pxL1kPDEiC3C+KwIfjJI2cpmSIQtPeQKuVErI4y/OT83
	IRBcmFWtPJs90iQU7c1h1G/rs1Lsd0g=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-ELZNahzCO5y0zH1PU1o6vA-1; Thu, 01 Jun 2023 03:47:51 -0400
X-MC-Unique: ELZNahzCO5y0zH1PU1o6vA-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2af23cfd23aso4024721fa.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 00:47:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685605670; x=1688197670;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJY0ffzy9d7zjgW/HEvqIO2dS8yVBrmwr6J73PuSOuU=;
        b=j7O4d7xBZ+ZVu+ffDMk2uWI0T26JOnYhtPtSXQ3tcNln8+fgK2nj/bOja4+fjX2+76
         mCgiIeXJy0ACdbUJkNVn66DxibesWGsD50sFpoxiThV3I0nhFjOwPI64EZFBY6uwdhPA
         /YVlF/czqEGQnRZoEMfQu77D8AmH0MW21CMf+qsy4/h2LMIWC+/5AGvxniphz1xu1WUV
         IotJR7HHXSH2pa8WaHNDlqIXFBtNDMx7orCy2hTQZzvx+SwMf7xIFz/vhegOU28YIcW6
         OilD/f5W4bhHXjg72IIv0BfkzDXMZ9zNr4W5AGSiJINQ/17zxX2DiH0Te2N3hcBOhLdr
         XUkw==
X-Gm-Message-State: AC+VfDzVzD7TWrXp+v7jhhjHr6OOP0T6eT14Fc0TLZ+mNaRLRF0i1Ufx
	mgYayy/nOCW5qdzRANoTrMYMa+T4LOkmO88mH44A13qIvLb9zuagU7fye+yAY2XvtKslLwPpuz1
	/nMgfx6d8xsZ/fc4V
X-Received: by 2002:a2e:8782:0:b0:2ad:8c4a:ef7e with SMTP id n2-20020a2e8782000000b002ad8c4aef7emr4339348lji.43.1685605670000;
        Thu, 01 Jun 2023 00:47:50 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6n6txE71tIS8COu2Dmzs3VgI+CjTKwcsBTD8jJe3gHKSoIl+5OkJ1upYUs7A36ArMnP+FMZA==
X-Received: by 2002:a2e:8782:0:b0:2ad:8c4a:ef7e with SMTP id n2-20020a2e8782000000b002ad8c4aef7emr4339335lji.43.1685605669610;
        Thu, 01 Jun 2023 00:47:49 -0700 (PDT)
Received: from sgarzare-redhat ([134.0.3.103])
        by smtp.gmail.com with ESMTPSA id k12-20020a056402048c00b00514c4350243sm1763867edv.56.2023.06.01.00.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 00:47:48 -0700 (PDT)
Date: Thu, 1 Jun 2023 09:47:45 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>, jasowang@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	virtualization@lists.linux-foundation.org, stefanha@redhat.com
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 vhost_work_queue
Message-ID: <7vk2uizpmf4fi54tmmopnbwwb7fs2xg6vae6ynrcvs26hjmshb@hpjzu4jfj35i>
References: <0000000000001777f605fce42c5f@google.com>
 <20230530072310-mutt-send-email-mst@kernel.org>
 <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
 <CAGxU2F7HK5KRggiY7xnKHeXFRXJmqcKbjf3JnXC3mbmn9xqRtw@mail.gmail.com>
 <e4589879-1139-22cc-854f-fed22cc18693@oracle.com>
 <6p7pi6mf3db3gp3xqarap4uzrgwlzqiz7wgg5kn2ep7hvrw5pg@wxowhbw4e7w7>
 <035e3423-c003-3de9-0805-2091b9efb45d@oracle.com>
 <CAGxU2F5oTLY_weLixRKMQVqmjpDG_09yL6tS2rF8mwJ7K+xP0Q@mail.gmail.com>
 <43f67549-fe4d-e3ca-fbb0-33bea6e2b534@oracle.com>
 <bbe697b6-dd9e-5a8d-21c5-315ab59f0456@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <bbe697b6-dd9e-5a8d-21c5-315ab59f0456@oracle.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 11:27:12AM -0500, Mike Christie wrote:
>On 5/31/23 10:15 AM, Mike Christie wrote:
>>>> rcu would work for your case and for what Jason had requested.
>>> Yeah, so you already have some patches?
>>>
>>> Do you want to send it to solve this problem?
>>>
>> Yeah, I'll break them out and send them later today when I can retest
>> rebased patches.
>>
>
>Just one question. Do you core vhost developers consider RCU more complex
>or switching to READ_ONCE/WRITE_ONCE? I am asking because for this immediate
>regression fix we could just switch to the latter like below to just fix
>the crash if we think that is more simple.
>
>I think RCU is just a little more complex/invasive because it will have the
>extra synchronize_rcu calls.

Yes, you may be right, in this case we should just need
READ_ONCE/WRITE_ONCE if dev->worker is no longer a pointer.

>
>
>diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>index a92af08e7864..03fd47a22a73 100644
>--- a/drivers/vhost/vhost.c
>+++ b/drivers/vhost/vhost.c
>@@ -235,7 +235,7 @@ void vhost_dev_flush(struct vhost_dev *dev)
> {
> 	struct vhost_flush_struct flush;
>
>-	if (dev->worker) {
>+	if (READ_ONCE(dev->worker.vtsk)) {
> 		init_completion(&flush.wait_event);
> 		vhost_work_init(&flush.work, vhost_flush_work);
>
>@@ -247,7 +247,9 @@ EXPORT_SYMBOL_GPL(vhost_dev_flush);
>
> void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
> {
>-	if (!dev->worker)
>+	struct vhost_task *vtsk = READ_ONCE(dev->worker.vtsk);
>+
>+	if (!vtsk)
> 		return;
>
> 	if (!test_and_set_bit(VHOST_WORK_QUEUED, &work->flags)) {
>@@ -255,8 +257,8 @@ void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
> 		 * sure it was not in the list.
> 		 * test_and_set_bit() implies a memory barrier.
> 		 */
>-		llist_add(&work->node, &dev->worker->work_list);
>-		wake_up_process(dev->worker->vtsk->task);
>+		llist_add(&work->node, &dev->worker.work_list);
>+		wake_up_process(vtsk->task);
> 	}
> }
> EXPORT_SYMBOL_GPL(vhost_work_queue);
>@@ -264,7 +266,7 @@ EXPORT_SYMBOL_GPL(vhost_work_queue);
> /* A lockless hint for busy polling code to exit the loop */
> bool vhost_has_work(struct vhost_dev *dev)
> {
>-	return dev->worker && !llist_empty(&dev->worker->work_list);
>+	return !llist_empty(&dev->worker.work_list);
> }
> EXPORT_SYMBOL_GPL(vhost_has_work);
>
>@@ -468,7 +470,7 @@ void vhost_dev_init(struct vhost_dev *dev,
> 	dev->umem = NULL;
> 	dev->iotlb = NULL;
> 	dev->mm = NULL;
>-	dev->worker = NULL;
>+	memset(&dev->worker, 0, sizeof(dev->worker));
> 	dev->iov_limit = iov_limit;
> 	dev->weight = weight;
> 	dev->byte_weight = byte_weight;
>@@ -542,46 +544,38 @@ static void vhost_detach_mm(struct vhost_dev *dev)
>
> static void vhost_worker_free(struct vhost_dev *dev)
> {
>-	struct vhost_worker *worker = dev->worker;
>+	struct vhost_task *vtsk = READ_ONCE(dev->worker.vtsk);
>
>-	if (!worker)
>+	if (!vtsk)
> 		return;
>
>-	dev->worker = NULL;
>-	WARN_ON(!llist_empty(&worker->work_list));
>-	vhost_task_stop(worker->vtsk);
>-	kfree(worker);
>+	vhost_task_stop(vtsk);
>+	WARN_ON(!llist_empty(&dev->worker.work_list));
>+	WRITE_ONCE(dev->worker.vtsk, NULL);

The patch LGTM, I just wonder if we should set dev->worker to zero here,
but maybe we don't need to.

Thanks,
Stefano

> }
>
> static int vhost_worker_create(struct vhost_dev *dev)
> {
>-	struct vhost_worker *worker;
> 	struct vhost_task *vtsk;
> 	char name[TASK_COMM_LEN];
> 	int ret;
>
>-	worker = kzalloc(sizeof(*worker), GFP_KERNEL_ACCOUNT);
>-	if (!worker)
>-		return -ENOMEM;
>-
>-	dev->worker = worker;
>-	worker->kcov_handle = kcov_common_handle();
>-	init_llist_head(&worker->work_list);
>+	dev->worker.kcov_handle = kcov_common_handle();
>+	init_llist_head(&dev->worker.work_list);
> 	snprintf(name, sizeof(name), "vhost-%d", current->pid);
>
>-	vtsk = vhost_task_create(vhost_worker, worker, name);
>+	vtsk = vhost_task_create(vhost_worker, &dev->worker, name);
> 	if (!vtsk) {
> 		ret = -ENOMEM;
> 		goto free_worker;
> 	}
>
>-	worker->vtsk = vtsk;
>+	WRITE_ONCE(dev->worker.vtsk, vtsk);
> 	vhost_task_start(vtsk);
> 	return 0;
>
> free_worker:
>-	kfree(worker);
>-	dev->worker = NULL;
>+	WRITE_ONCE(dev->worker.vtsk, NULL);
> 	return ret;
> }
>
>diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>index 0308638cdeee..305ec8593d46 100644
>--- a/drivers/vhost/vhost.h
>+++ b/drivers/vhost/vhost.h
>@@ -154,7 +154,7 @@ struct vhost_dev {
> 	struct vhost_virtqueue **vqs;
> 	int nvqs;
> 	struct eventfd_ctx *log_ctx;
>-	struct vhost_worker *worker;
>+	struct vhost_worker worker;
> 	struct vhost_iotlb *umem;
> 	struct vhost_iotlb *iotlb;
> 	spinlock_t iotlb_lock;
>


