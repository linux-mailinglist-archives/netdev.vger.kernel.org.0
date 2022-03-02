Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC49F4CA923
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 16:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241366AbiCBPhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 10:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238150AbiCBPhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 10:37:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04EB0C6262
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 07:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646235410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HiWuNUMDb+jMyibsjnWGqQsYAJ9IA+FOAlDaEyD0AQE=;
        b=TsAd0yea8sQu+AbhYDtJUK7irV1bqLVSjxYr1jTxkWSLAGveXgKqExo3amcgM92MQSmrHC
        lGHvAObfu65TPRUfR5T81IBC0Ug6lqfLfQxa2sltfMbdSb8ILm0bFGQW5enb38Rr3mjBTF
        I0Wm6wrYpe+OqF2WGclH4UhyxMCgRpI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-NqplVNvNMfCuKUVgfu6Nng-1; Wed, 02 Mar 2022 10:36:49 -0500
X-MC-Unique: NqplVNvNMfCuKUVgfu6Nng-1
Received: by mail-wm1-f71.google.com with SMTP id a26-20020a7bc1da000000b003857205ec7cso500144wmj.2
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 07:36:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HiWuNUMDb+jMyibsjnWGqQsYAJ9IA+FOAlDaEyD0AQE=;
        b=M1tbj3hYOkJM/f1ymBBoNqsGdkvrwd72Zf8Xouo0MEo6zF3l45c+ajDeK9/h5zjMkf
         h8cFqfqacYNe4cxVau+nSzFGCiLE26tgni6oTxILRV1J/5srQskvq2si4fnAv0CfW5m1
         8QPGt+7Zvn6GwWpoJUJFzhgbJ/PglmN3f06lFjHmhL707cfEt1KOzovwZtPybwRlyjvw
         nP+0CLE/0jxuvpmcNapjD27sV/MexZoHyTV2HdfUF+ER7q2dwkOU+Nsw+sBQ8Tgp+77P
         p+QI7d9I5XqDezX8sZ2+xAgmsLnDcaEcpoBFt1Qt57FW+5YEJhA3NBAQOciMbqNpQiTD
         hfrg==
X-Gm-Message-State: AOAM530RRxaKvhEY9J+Ark+/3VXMwqohdMj30Nuz8fuaOZw6VQqIgXhC
        2aGCFbFen6/y9ZAcnFdrWGHDeN30hpgs+DQPNOqBqTaCNSQofrw0kehnTcqjF5TuczIJFcoJWs/
        +c+XxtqJtX7AfAXCc
X-Received: by 2002:adf:914f:0:b0:1ed:bb92:d0cc with SMTP id j73-20020adf914f000000b001edbb92d0ccmr23760986wrj.297.1646235407395;
        Wed, 02 Mar 2022 07:36:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyOXNVA6Ca35935P9zNNj3hLgvVWqdH+AVRnYEdYqNaoKk8H9E6ae22MHAewrFcGgr/Nliwkg==
X-Received: by 2002:adf:914f:0:b0:1ed:bb92:d0cc with SMTP id j73-20020adf914f000000b001edbb92d0ccmr23760976wrj.297.1646235407162;
        Wed, 02 Mar 2022 07:36:47 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id m12-20020a7bcb8c000000b003811afe1d45sm5852294wmi.37.2022.03.02.07.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 07:36:46 -0800 (PST)
Date:   Wed, 2 Mar 2022 16:36:43 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220302153643.glkmvnn2czrgpoyl@sgarzare-redhat>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302093446.pjq3djoqi434ehz4@sgarzare-redhat>
 <20220302083413-mutt-send-email-mst@kernel.org>
 <20220302141121.sohhkhtiiaydlv47@sgarzare-redhat>
 <20220302094946-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220302094946-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 09:50:38AM -0500, Michael S. Tsirkin wrote:
>On Wed, Mar 02, 2022 at 03:11:21PM +0100, Stefano Garzarella wrote:
>> On Wed, Mar 02, 2022 at 08:35:08AM -0500, Michael S. Tsirkin wrote:
>> > On Wed, Mar 02, 2022 at 10:34:46AM +0100, Stefano Garzarella wrote:
>> > > On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
>> > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
>> > > > to vhost_get_vq_desc().  All we have to do is take the same lock
>> > > > during virtqueue clean-up and we mitigate the reported issues.
>> > > >
>> > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
>> > >
>> > > This issue is similar to [1] that should be already fixed upstream by [2].
>> > >
>> > > However I think this patch would have prevented some issues, because
>> > > vhost_vq_reset() sets vq->private to NULL, preventing the worker from
>> > > running.
>> > >
>> > > Anyway I think that when we enter in vhost_dev_cleanup() the worker should
>> > > be already stopped, so it shouldn't be necessary to take the mutex. But in
>> > > order to prevent future issues maybe it's better to take them, so:
>> > >
>> > > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>> > >
>> > > [1]
>> > > https://syzkaller.appspot.com/bug?id=993d8b5e64393ed9e6a70f9ae4de0119c605a822
>> > > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9
>> >
>> >
>> > Right. I want to queue this but I would like to get a warning
>> > so we can detect issues like [2] before they cause more issues.
>>
>> I agree, what about moving the warning that we already have higher up, right
>> at the beginning of the function?
>>
>> I mean something like this:
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 59edb5a1ffe2..1721ff3f18c0 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -692,6 +692,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>>  {
>>         int i;
>> +       WARN_ON(!llist_empty(&dev->work_list));
>> +
>>         for (i = 0; i < dev->nvqs; ++i) {
>>                 if (dev->vqs[i]->error_ctx)
>>                         eventfd_ctx_put(dev->vqs[i]->error_ctx);
>> @@ -712,7 +714,6 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>>         dev->iotlb = NULL;
>>         vhost_clear_msg(dev);
>>         wake_up_interruptible_poll(&dev->wait, EPOLLIN | EPOLLRDNORM);
>> -       WARN_ON(!llist_empty(&dev->work_list));
>>         if (dev->worker) {
>>                 kthread_stop(dev->worker);
>>                 dev->worker = NULL;
>>
>
>Hmm I'm not sure why it matters.

Because after this new patch, putting locks in the while loop, when we 
finish the loop the workers should be stopped, because vhost_vq_reset() 
sets vq->private to NULL.

But the best thing IMHO is to check that there is no backend set for 
each vq, so the workers have been stopped correctly at this point.

Thanks,
Stefano

