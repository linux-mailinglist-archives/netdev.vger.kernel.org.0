Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911EF4BE451
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381023AbiBUQo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:44:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380995AbiBUQox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:44:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92A97220D5
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 08:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645461869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VNieaTwekELLlfDmLcMtpN2ymnlly2vIEQ3lgNT3la0=;
        b=RlHDYW/oWNSOZabieGNo8Iaqd7Wv0Ig4jDoEYrEk6sehYqHgbe1MhfD4le0QGv/SRUJeYL
        QaJyMtR/5VxataocwbTrb9srd7fGIQHLpO1FBCO+fNSTfpXOyDPtKf8iBaOErLqBQeGmtk
        0Bk6xbabPkBLzFrocSipOUfam0eql0s=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-R03HChunNt61XhVYSaeQJQ-1; Mon, 21 Feb 2022 11:44:28 -0500
X-MC-Unique: R03HChunNt61XhVYSaeQJQ-1
Received: by mail-qk1-f199.google.com with SMTP id a15-20020a05620a066f00b0060c66d84489so13850995qkh.19
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 08:44:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VNieaTwekELLlfDmLcMtpN2ymnlly2vIEQ3lgNT3la0=;
        b=yUtfXTbOzcNUxkj80kDXb4wlgZvAOvBCC11C8nuO6wIA/piTKDHOGwkYUVxDLJMrLO
         0swaSTLxm/Uan4UV2lqiMQIAav7KD0132NkSjVX2l/nBunfSTFvzQXTEmzGCDFk6ZYvS
         sblnuYxp0AKzXIz/sXXCNHPZl24f1dDuRkP1nHHkU6u8Ee+EK4q4NsTmsgAj6LYiOONz
         3pXt2X1HfK3HF1BVEaFeLvhFjaxQawHdZFQDeX3REFSyuWWEbFrA2kMTxkU5pXKPJtf9
         UYLm81UBRN60TfKqnQc0XTEig2C2YYyzqMbmIumyEQ0BSLTg1XgZXUUgRYOR+1yEH/EO
         R/5A==
X-Gm-Message-State: AOAM533v1r5Mp2wRyz9r4DhwfX3SNIddbTDqVvxlVoI3fn6q7kmKWKDS
        yoX2Y9IpTb/Ox4zQ9DXrIYbl1sE1HAIDdOKM29ZMJKZow+VMFfTNy+c78cNNLAifIuFGYDzi2s7
        kI0X7dZQIcHYyizMI
X-Received: by 2002:a37:9cd6:0:b0:5dd:184f:a6a6 with SMTP id f205-20020a379cd6000000b005dd184fa6a6mr12426920qke.76.1645461867988;
        Mon, 21 Feb 2022 08:44:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9+BSp31qAHOQzN7kKtZNi6gPPEeZ2f6xPuAzosuYqWftvxHapdtxcfYdSzcIVRhUHsRkkXA==
X-Received: by 2002:a37:9cd6:0:b0:5dd:184f:a6a6 with SMTP id f205-20020a379cd6000000b005dd184fa6a6mr12426906qke.76.1645461867775;
        Mon, 21 Feb 2022 08:44:27 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id y15sm27100949qko.133.2022.02.21.08.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 08:44:27 -0800 (PST)
Date:   Mon, 21 Feb 2022 17:44:20 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kvm <kvm@vger.kernel.org>, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH] vhost/vsock: don't check owner in vhost_vsock_stop()
 while releasing
Message-ID: <20220221164420.cnhs6sgxizc6tcok@sgarzare-redhat>
References: <20220221114916.107045-1-sgarzare@redhat.com>
 <CAGxU2F6aMqTaNaeO7xChtf=veDJYtBjDRayRRYkZ_FOq4CYJWQ@mail.gmail.com>
 <YhO6bwu7iDtUFQGj@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YhO6bwu7iDtUFQGj@anirudhrb.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 09:44:39PM +0530, Anirudh Rayabharam wrote:
>On Mon, Feb 21, 2022 at 02:59:30PM +0100, Stefano Garzarella wrote:
>> On Mon, Feb 21, 2022 at 12:49 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> >
>> > vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
>> > ownership. It expects current->mm to be valid.
>> >
>> > vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
>> > the user has not done close(), so when we are in do_exit(). In this
>> > case current->mm is invalid and we're releasing the device, so we
>> > should clean it anyway.
>> >
>> > Let's check the owner only when vhost_vsock_stop() is called
>> > by an ioctl.
>> >
>> > Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
>> > Cc: stable@vger.kernel.org
>> > Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
>> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> > ---
>> >  drivers/vhost/vsock.c | 14 ++++++++------
>> >  1 file changed, 8 insertions(+), 6 deletions(-)
>>
>> Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
>
>I don't think this patch fixes "INFO: task hung in vhost_work_dev_flush"
>even though syzbot says so. I am able to reproduce the issue locally
>even with this patch applied.

Are you using the sysbot reproducer or another test?
In that case, can you share it?

 From the stack trace it seemed to me that the worker accesses a zone 
that has been cleaned (iotlb), so it is invalid and fails.
That's why I had this patch tested which should stop the worker before 
cleaning.

Thanks,
Stefano

