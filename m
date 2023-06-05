Return-Path: <netdev+bounces-7910-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ED1C7220F6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCAD91C20BA1
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9364D134A0;
	Mon,  5 Jun 2023 08:27:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E4511C97
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:27:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A09CD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 01:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685953620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J8at3jyLYspjW7I0pCXUj/ZCT3YmM7eGZSNtKBL6MtI=;
	b=ZC7P/pVtDCPvndICFSArghp24mpRlh8fIJ3JU8ug9Jg0xUPa7FIhsJhRj5Qm8oZIuzAuZR
	GlBvUloe4lJBVpnB2dO4FRx4vcnzWZPm5sKOIdJn2yS1Qu9FaT3GTGLlSJfgogPcQJtzlc
	fektKEu6cYz39uv0isaKoZSQQ1m7JSw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-pqLyNv6gOcKXjSY0NJ6aEQ-1; Mon, 05 Jun 2023 04:26:58 -0400
X-MC-Unique: pqLyNv6gOcKXjSY0NJ6aEQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f73283f6c7so6806455e9.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 01:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685953617; x=1688545617;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J8at3jyLYspjW7I0pCXUj/ZCT3YmM7eGZSNtKBL6MtI=;
        b=UG2YR2CMttbjRyqPdv3NB/mmXzwixXe8czNMI0EewSI93xC78mAIAZUrW+jbc1NmE5
         +o2j1/xsq8TDI0da57xNqJwusyvk3sM0fKf2kY8UdaQGV0zrHqTKTBaiXgrla+W1SSiV
         DdBozLMkRfELsENc3/UJXZz4QdJZIe4xSew28P8D3kHzgpUKC5xnrca26YhiIgM+GJFV
         afEP/lXrMuCAbZd5/DC1aTN8XUIZ/xAPzB5nUKzsXxO5dONq10A+MbNP7UV88qp9lZ0i
         PekpAydZ1B9totW+p9hux+///ZoJVPj+aVufD6LR3qJxFTpuJm49ytotRXTa+aap7LLD
         BDjw==
X-Gm-Message-State: AC+VfDwkGBYVbC34EoU2PplS557HosHBr9hBN4Zm+JU58JF2wReTO50a
	aaeASC8T3l1kdxBlsq6n6iFQoGHYdTU3rqGs5dC02jgdMM/pSKV1n7IHPoHnCoxMTbRb4TZ5D8W
	L+cUaxmU5CVVs9Kxe
X-Received: by 2002:a05:600c:1d98:b0:3f7:367a:38cb with SMTP id p24-20020a05600c1d9800b003f7367a38cbmr3232785wms.2.1685953617682;
        Mon, 05 Jun 2023 01:26:57 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7VE8iVjNCuqsNoEIKvM2en0FHwV2THTF/MEveUKF9yun03XpX+3wMK7X0sxFjbHVuiakb1jg==
X-Received: by 2002:a05:600c:1d98:b0:3f7:367a:38cb with SMTP id p24-20020a05600c1d9800b003f7367a38cbmr3232772wms.2.1685953617428;
        Mon, 05 Jun 2023 01:26:57 -0700 (PDT)
Received: from sgarzare-redhat ([5.77.94.106])
        by smtp.gmail.com with ESMTPSA id y5-20020adfd085000000b003095bd71159sm9123063wrh.7.2023.06.05.01.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 01:26:56 -0700 (PDT)
Date: Mon, 5 Jun 2023 10:26:54 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>, jasowang@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	virtualization@lists.linux-foundation.org, stefanha@redhat.com
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 vhost_work_queue
Message-ID: <4rqrebfglyif4d7i4ufdnj2uqnubvljkeciqmelvotti5iu5ja@fryxznjicgn6>
References: <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
 <CAGxU2F7HK5KRggiY7xnKHeXFRXJmqcKbjf3JnXC3mbmn9xqRtw@mail.gmail.com>
 <e4589879-1139-22cc-854f-fed22cc18693@oracle.com>
 <6p7pi6mf3db3gp3xqarap4uzrgwlzqiz7wgg5kn2ep7hvrw5pg@wxowhbw4e7w7>
 <035e3423-c003-3de9-0805-2091b9efb45d@oracle.com>
 <CAGxU2F5oTLY_weLixRKMQVqmjpDG_09yL6tS2rF8mwJ7K+xP0Q@mail.gmail.com>
 <43f67549-fe4d-e3ca-fbb0-33bea6e2b534@oracle.com>
 <bbe697b6-dd9e-5a8d-21c5-315ab59f0456@oracle.com>
 <7vk2uizpmf4fi54tmmopnbwwb7fs2xg6vae6ynrcvs26hjmshb@hpjzu4jfj35i>
 <b5a845e9-1fa0-ea36-98c4-b5da989c44c6@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b5a845e9-1fa0-ea36-98c4-b5da989c44c6@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 11:33:09AM -0500, Mike Christie wrote:
>On 6/1/23 2:47 AM, Stefano Garzarella wrote:
>>>
>>> static void vhost_worker_free(struct vhost_dev *dev)
>>> {
>>> -    struct vhost_worker *worker = dev->worker;
>>> +    struct vhost_task *vtsk = READ_ONCE(dev->worker.vtsk);
>>>
>>> -    if (!worker)
>>> +    if (!vtsk)
>>>         return;
>>>
>>> -    dev->worker = NULL;
>>> -    WARN_ON(!llist_empty(&worker->work_list));
>>> -    vhost_task_stop(worker->vtsk);
>>> -    kfree(worker);
>>> +    vhost_task_stop(vtsk);
>>> +    WARN_ON(!llist_empty(&dev->worker.work_list));
>>> +    WRITE_ONCE(dev->worker.vtsk, NULL);
>>
>> The patch LGTM, I just wonder if we should set dev->worker to zero here,
>
>We might want to just set kcov_handle to zero for now.
>
>In 6.3 and older, I think we could do:
>
>1. vhost_dev_set_owner could successfully set dev->worker.
>2. vhost_transport_send_pkt runs vhost_work_queue and sees worker
>is set and adds the vhost_work to the work_list.
>3. vhost_dev_set_owner fails in vhost_attach_cgroups, so we stop
>the worker before the work can be run and set worker to NULL.
>4. We clear kcov_handle and return.
>
>We leave the work on the work_list.
>
>5. Userspace can then retry vhost_dev_set_owner. If that works, then the
>work gets executed ok eventually.
>
>OR
>
>Userspace can just close the device. vhost_vsock_dev_release would
>eventually call vhost_dev_cleanup (vhost_dev_flush won't see a worker
>so will just return), and that will hit the WARN_ON but we would
>proceed ok.
>
>If I do a memset of the worker, then if userspace were to retry
>VHOST_SET_OWNER, we would lose the queued work since the work_list would
>get zero'd. I think it's unlikely this ever happens, but you know best
>so let me know if this a real issue.
>

I don't think it's a problem, though, you're right, we could hide the 
warning and thus future bugs, better as you proposed.

Thanks,
Stefano


