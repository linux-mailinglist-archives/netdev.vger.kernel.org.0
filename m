Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12B94CCF42
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 08:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238960AbiCDHvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 02:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235758AbiCDHvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 02:51:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C55B4190B4B
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 23:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646380247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RHT38EAK8wYUL1DGHAhrEW8RVwO4xAs9c9L8nS+s5yk=;
        b=htaabeUWVHhM4SqgizHuWQ7X4Q3HSuw4oixJk7tQj6y0SE58Uq4vXYXnVMT6jZUeo2daCy
        nNr3yJP8/I/RlGrkC/srKXgHx2k/3BS8zdqPQgDy9We0Jg7wF2bLa2zCdiiKpGPHJjP4qU
        WXFNy+jAyuAcoE+2LBiAXttwy47eS0s=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-bcakViLTOEywTULxCdoVRA-1; Fri, 04 Mar 2022 02:50:46 -0500
X-MC-Unique: bcakViLTOEywTULxCdoVRA-1
Received: by mail-qk1-f200.google.com with SMTP id m22-20020a05620a221600b005f180383baeso4955573qkh.15
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 23:50:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RHT38EAK8wYUL1DGHAhrEW8RVwO4xAs9c9L8nS+s5yk=;
        b=mVcnOAb6i073lCwEqTtj08Y6LK3MhXOuKI9SGRcJSnPeO/+5Z/rLNWjDVxFUoWs5jy
         t7sa5kw7qzPr5pRvV3ih0J9LTR0kO13NcQE/IJZoYOKdNttyaBPBDRmRYY7/8f8S9sE9
         5ZIv0sDjXr3ZAPX+UK33Fg5qtpRSfDrj6W8kEjI6DBr7mSlwRzD/RweHIetw2sSR6g1D
         HQ1P3rmvqQZf88go8SStLOSCoczZ1UOAm4nTaXOzxKTOpZO1eTMv/kedyKlTyTCVPyWs
         6mbpOGhelLWwtY8PxjhidnC7Oqosw/LoNCBpgaYXHLS6WAe7XGtecO5du0b8cnDbViMz
         W6Rw==
X-Gm-Message-State: AOAM532w5ztg/muQ2jAczZKQ/FB3G9OgTMUwxLZa0agGfB79sPMqH6sd
        LOftlnlsh8hEWaqk+QWP6uCGo7DzyynRCXiPamW8m1/VpeNdhfB3V7108MTLmT0yeovlrXf6AOR
        8rljPL10cdF7WB9bw
X-Received: by 2002:a37:6808:0:b0:46c:e3c1:7247 with SMTP id d8-20020a376808000000b0046ce3c17247mr1770386qkc.770.1646380246248;
        Thu, 03 Mar 2022 23:50:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzMCSQfDu5Agxl+Zrju4icTbzmVnYv6E0GbiwcmRYdI77zGTFN/asNZoAGZHw/6BhY/xu+7Bg==
X-Received: by 2002:a37:6808:0:b0:46c:e3c1:7247 with SMTP id d8-20020a376808000000b0046ce3c17247mr1770377qkc.770.1646380245984;
        Thu, 03 Mar 2022 23:50:45 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id z14-20020a05622a028e00b002dc8e843596sm2953032qtw.61.2022.03.03.23.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 23:50:45 -0800 (PST)
Date:   Fri, 4 Mar 2022 08:50:39 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] vhost: Provide a kernel warning if mutex is held
 whilst clean-up in progress
Message-ID: <20220304075039.rewrf3gnbbh3sdfl@sgarzare-redhat>
References: <20220303151929.2505822-1-lee.jones@linaro.org>
 <YiETnIcfZCLb63oB@unreal>
 <20220303155645-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220303155645-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 03, 2022 at 04:01:06PM -0500, Michael S. Tsirkin wrote:
>On Thu, Mar 03, 2022 at 09:14:36PM +0200, Leon Romanovsky wrote:
>> On Thu, Mar 03, 2022 at 03:19:29PM +0000, Lee Jones wrote:
>> > All workers/users should be halted before any clean-up should take place.
>> >
>> > Suggested-by:  Michael S. Tsirkin <mst@redhat.com>
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> > ---
>> >  drivers/vhost/vhost.c | 3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> > index bbaff6a5e21b8..d935d2506963f 100644
>> > --- a/drivers/vhost/vhost.c
>> > +++ b/drivers/vhost/vhost.c
>> > @@ -693,6 +693,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>> >  	int i;
>> >
>> >  	for (i = 0; i < dev->nvqs; ++i) {
>> > +		/* Ideally all workers should be stopped prior to clean-up */
>> > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
>> > +
>> >  		mutex_lock(&dev->vqs[i]->mutex);
>>
>> I know nothing about vhost, but this construction and patch looks
>> strange to me.
>>
>> If all workers were stopped, you won't need mutex_lock(). The mutex_lock
>> here suggests to me that workers can still run here.
>>
>> Thanks
>
>
>"Ideally" here is misleading, we need a bigger detailed comment
>along the lines of:
>
>/*
> * By design, no workers can run here. But if there's a bug and the
> * driver did not flush all work properly then they might, and we
> * encountered such bugs in the past.  With no proper flush guest won't
> * work correctly but avoiding host memory corruption in this case
> * sounds like a good idea.
> */

Can we use vhost_vq_get_backend() to check this situation?

IIUC all the vhost devices clear the backend to stop the workers.
This is not racy (if we do after the mutex_lock) and should cover all 
cases.

Thanks,
Stefano

