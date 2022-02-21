Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D77D4BDC59
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379009AbiBUPXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 10:23:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238016AbiBUPXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 10:23:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12DE81DA7B
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 07:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645456966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=//ocvqSZP1Bqt7GMZm3TubXy/TDW1Bh0IsBpphamyS8=;
        b=hLJ2MBj8rINfwVCD2b7mdqOBLEJr9Hpytt27R+lLNFLNmusfy2gllLCDaG0Kj71m+QwSNU
        cLfN1niW2U6GQO7VT18HPlJ9YnwVQkYGI4x0LAEa4owB9QBF6pA+Ii8ReeAeglfOHmLb1P
        GbSt5NfXq++e7v00gkBd5D+zs5huezc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-fWmw_sDTNyuPSm0viri9pw-1; Mon, 21 Feb 2022 10:22:45 -0500
X-MC-Unique: fWmw_sDTNyuPSm0viri9pw-1
Received: by mail-wm1-f72.google.com with SMTP id k30-20020a05600c1c9e00b0037d1bee4847so8136690wms.9
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 07:22:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=//ocvqSZP1Bqt7GMZm3TubXy/TDW1Bh0IsBpphamyS8=;
        b=HnW7p/TdDdylha5xl9CpzRro9e1nc7fFwlWe3qhAxBRz3L8cIngVO6xHE6gSDz2pwS
         pqRMwm63zBQ4r8Mkh0+mGgR+OZtqx6RG29vKV832CtvM5VfIr2dj0FoJfMGjVMO37qvv
         tH2sQAlsCh4uZdNrA/ZIXJk+yMldd6P/fIORZD7sGr+P08bQXPWibY6SILDbz5/6CwZj
         0aLNDMzQTmTAsoYTH7XQAFyLu7IlbCGaeYmoC+kZx7jpMrk9bAI0rNft0BxKK2jQVkKc
         2UMyDCK30YLp2to6kG05/irmun1iIS6qFiVAWZHytkyZLOZacRwlyRDpfFUGW9QKEKvY
         4wSg==
X-Gm-Message-State: AOAM5319i3ceD1+X1RE5s3LCmVCOA0doXs33Kk5O0Voj0HLYRlOBxHnu
        biJoRhAxG7ktvgcCID9YxYecfLzXVgHaIjiFllbajt2khGLvm2aqnpGmEMNbFShpdMqfzH3O87/
        /5E7Mj9sSQ6g+dkrI
X-Received: by 2002:adf:f3cc:0:b0:1e7:4fd9:6fd3 with SMTP id g12-20020adff3cc000000b001e74fd96fd3mr15663046wrp.266.1645456964080;
        Mon, 21 Feb 2022 07:22:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyRe76b/qP2XEzCDRn/yzRVG9vTAJA8nQ+6DymsN10XGTOpBA26zz1vt6D+IC5eOeVGMUheYA==
X-Received: by 2002:adf:f3cc:0:b0:1e7:4fd9:6fd3 with SMTP id g12-20020adff3cc000000b001e74fd96fd3mr15663016wrp.266.1645456963802;
        Mon, 21 Feb 2022 07:22:43 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id j5-20020a05600c410500b0037bc3e4b526sm7745956wmi.7.2022.02.21.07.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 07:22:43 -0800 (PST)
Date:   Mon, 21 Feb 2022 16:22:40 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Asias He <asias@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: don't check owner in vhost_vsock_stop()
 while releasing
Message-ID: <20220221152240.nbdthe4grii577zd@sgarzare-redhat>
References: <20220221114916.107045-1-sgarzare@redhat.com>
 <20220221094829-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220221094829-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 10:03:39AM -0500, Michael S. Tsirkin wrote:
>On Mon, Feb 21, 2022 at 12:49:16PM +0100, Stefano Garzarella wrote:
>> vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
>> ownership. It expects current->mm to be valid.
>>
>> vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
>> the user has not done close(), so when we are in do_exit(). In this
>> case current->mm is invalid and we're releasing the device, so we
>> should clean it anyway.
>>
>> Let's check the owner only when vhost_vsock_stop() is called
>> by an ioctl.
>
>
>
>
>> Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
>> Cc: stable@vger.kernel.org
>> Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>  drivers/vhost/vsock.c | 14 ++++++++------
>>  1 file changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> index d6ca1c7ad513..f00d2dfd72b7 100644
>> --- a/drivers/vhost/vsock.c
>> +++ b/drivers/vhost/vsock.c
>> @@ -629,16 +629,18 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
>>  	return ret;
>>  }
>>
>> -static int vhost_vsock_stop(struct vhost_vsock *vsock)
>> +static int vhost_vsock_stop(struct vhost_vsock *vsock, bool check_owner)
>
>>  {
>>  	size_t i;
>>  	int ret;
>>
>>  	mutex_lock(&vsock->dev.mutex);
>>
>> -	ret = vhost_dev_check_owner(&vsock->dev);
>> -	if (ret)
>> -		goto err;
>> +	if (check_owner) {
>> +		ret = vhost_dev_check_owner(&vsock->dev);
>> +		if (ret)
>> +			goto err;
>> +	}
>>
>>  	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
>>  		struct vhost_virtqueue *vq = &vsock->vqs[i];
>> @@ -753,7 +755,7 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
>>  	 * inefficient.  Room for improvement here. */
>>  	vsock_for_each_connected_socket(vhost_vsock_reset_orphans);
>>
>> -	vhost_vsock_stop(vsock);
>
>Let's add an explanation:
>
>When invoked from release we can not fail so we don't
>check return code of vhost_vsock_stop.
>We need to stop vsock even if it's not the owner.

Do you want me to send a v2 by adding this as a comment in the code?

Thanks,
Stefano

