Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFBE4CA7AB
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 15:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242815AbiCBOMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 09:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239294AbiCBOMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 09:12:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1973434BB1
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 06:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646230289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zki/Dz8/SB2dieRvsIUHk7QNqNrRAue+WSnk+jKK4oo=;
        b=XcIuOSkwt24EpGcbhp251hSlJIGPZ6t5zIL+lYZlcjAERtJiuZrzSxKiPPKhsbWGJdU2AU
        HcAGbBfrOv/LkoRBdr+eU2MQVzO5Y/wFarMSjehIF5KkHtUkcjDW3E2pYfb6VZjPfBsbla
        8LGa0HI1yebushYQtaHaz7nhalo85Z0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-aGtmlO7MNwiBo4I7FZB2iA-1; Wed, 02 Mar 2022 09:11:28 -0500
X-MC-Unique: aGtmlO7MNwiBo4I7FZB2iA-1
Received: by mail-qt1-f200.google.com with SMTP id e28-20020ac8415c000000b002c5e43ca6b7so1337825qtm.9
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 06:11:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zki/Dz8/SB2dieRvsIUHk7QNqNrRAue+WSnk+jKK4oo=;
        b=FbcdFyyx2MYkWw6kvViGUKg3WrhPzIC6Y1oJklnCmFRHhsy8FMCMXa7AN/7wd+kuQY
         lYwjXfgrvTv6tBjvx2BiMUg09vewX5ZiNOtF6doCfe/yOfMWGhKmICdWJo6t3NQ0BRvB
         BdS/MGIrB/ON+0uHebWbCIgVEwN3Uivx7wfCu+Vu9wvftH+ouRp8sdWlG5UiIn7MAq8K
         qycL4Wzc0eGUusfkx0T93jf6dvGcBNTDZ4BD/K9M7bvJ3oPaXpPPp7uigOGulxFtjarm
         a/PxkJV4cmOgT+j7uFHJIOfhpXlVbgA6InVZ12kbusH966mMR2/UL3peKq8HTCXEaPWt
         4+1A==
X-Gm-Message-State: AOAM532ilX9LFJ1jXxD24DCGXZswjMzDHku8S/+QV6RAnpJBg2lO9Q0C
        6LPpKmVT2Mpx+9BgIFyTQ2TKPkPlvDgbxMVKX9si+KThDEh+Zgrvzg2yxXIE7L0F3Wc8Dcleg3i
        QHrcl+yCWZNqqCP7y
X-Received: by 2002:ac8:7fca:0:b0:2de:8f3d:89be with SMTP id b10-20020ac87fca000000b002de8f3d89bemr24147743qtk.34.1646230287708;
        Wed, 02 Mar 2022 06:11:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZ7kQbxyiazMoeLWG0fZ0hHibPi3bReSoEzb74TshqNyIXX6z6vntalQDbAmbzJRmBH10EiA==
X-Received: by 2002:ac8:7fca:0:b0:2de:8f3d:89be with SMTP id b10-20020ac87fca000000b002de8f3d89bemr24147720qtk.34.1646230287418;
        Wed, 02 Mar 2022 06:11:27 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id c18-20020ac87dd2000000b002dd53a5563dsm11954035qte.25.2022.03.02.06.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 06:11:26 -0800 (PST)
Date:   Wed, 2 Mar 2022 15:11:21 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220302141121.sohhkhtiiaydlv47@sgarzare-redhat>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302093446.pjq3djoqi434ehz4@sgarzare-redhat>
 <20220302083413-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220302083413-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 08:35:08AM -0500, Michael S. Tsirkin wrote:
>On Wed, Mar 02, 2022 at 10:34:46AM +0100, Stefano Garzarella wrote:
>> On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
>> > vhost_vsock_handle_tx_kick() already holds the mutex during its call
>> > to vhost_get_vq_desc().  All we have to do is take the same lock
>> > during virtqueue clean-up and we mitigate the reported issues.
>> >
>> > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
>>
>> This issue is similar to [1] that should be already fixed upstream by [2].
>>
>> However I think this patch would have prevented some issues, because
>> vhost_vq_reset() sets vq->private to NULL, preventing the worker from
>> running.
>>
>> Anyway I think that when we enter in vhost_dev_cleanup() the worker should
>> be already stopped, so it shouldn't be necessary to take the mutex. But in
>> order to prevent future issues maybe it's better to take them, so:
>>
>> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>>
>> [1]
>> https://syzkaller.appspot.com/bug?id=993d8b5e64393ed9e6a70f9ae4de0119c605a822
>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9
>
>
>Right. I want to queue this but I would like to get a warning
>so we can detect issues like [2] before they cause more issues.

I agree, what about moving the warning that we already have higher up, 
right at the beginning of the function?

I mean something like this:

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe2..1721ff3f18c0 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -692,6 +692,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
  {
         int i;
  
+       WARN_ON(!llist_empty(&dev->work_list));
+
         for (i = 0; i < dev->nvqs; ++i) {
                 if (dev->vqs[i]->error_ctx)
                         eventfd_ctx_put(dev->vqs[i]->error_ctx);
@@ -712,7 +714,6 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
         dev->iotlb = NULL;
         vhost_clear_msg(dev);
         wake_up_interruptible_poll(&dev->wait, EPOLLIN | EPOLLRDNORM);
-       WARN_ON(!llist_empty(&dev->work_list));
         if (dev->worker) {
                 kthread_stop(dev->worker);
                 dev->worker = NULL;


And maybe we can also check vq->private and warn in the loop, because 
the work_list may be empty if the device is doing nothing.

Thanks,
Stefano

