Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CF64E539F
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 14:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236780AbiCWNzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 09:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiCWNzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 09:55:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A272170CF9
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 06:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648043650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PxY8wqYF5UreGCgb86/smuxb7YEIu8E3VvPChOzSsM8=;
        b=H88hJk6nbGiT4ww3DXaFYEJb9sdFugohXVb8c+hHaQ5aYsnE6RFGvt54PSOaCSQtrfqflU
        kZce9QHhdFej3xLy9q11oYECXfBFSbP9QSS/mdvKLoZMAn8Bovs/dso5yphnKgr47MME2Z
        bX9CBNCSTf8lSqUUDYdWAahPFgJIAtY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-t5zJ08dhMuGhT0FXuOHjJQ-1; Wed, 23 Mar 2022 09:54:09 -0400
X-MC-Unique: t5zJ08dhMuGhT0FXuOHjJQ-1
Received: by mail-qt1-f198.google.com with SMTP id h11-20020ac87d4b000000b002e1c9a3ae51so1244104qtb.0
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 06:54:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PxY8wqYF5UreGCgb86/smuxb7YEIu8E3VvPChOzSsM8=;
        b=cNq0fFphVauHgp69LC7LcFGwDZQ2qaRoYUNYtUmPxbrkGhiK303fMUI/s2GEbyIlNa
         g/1ZnqlqGc0DPg+ltXGnNq+gutTJ8CdhJUtYs+KGhL1SirzAibsk5v5zl6bOCKKyCX7w
         dg4GNYfTic3R6+UyfUZZ6TfClu93H47FO32v8DtMtOlbQ/idJSnZmZAI8Mzf5HdL/f2m
         CgX3/p07pV7BU7s3zZ0dO13KLcS8/nHMZ+/zUdy1wOyz+C0IbYQgej93GI2Aes96Ep8j
         +UcHlMcgN041NrlTcPU2rNlERdD2NSXpLn5oUtm4AGjMlmCqXep9ES8N5HXL5O030mb3
         RQwQ==
X-Gm-Message-State: AOAM532hA8EHFQCkXa3LEkCftm5mEWvT0t0bwEHEGq316hkWE6qjjqlw
        AOrTdFkMMou8N282zaJhxFW+hia+xmxF4yPLQuY4yW3gekSiZIRHVoRH1Jd2vD6cmDkUFOYmPl0
        Pbadb+06277pSBiQt
X-Received: by 2002:a05:620a:709:b0:67d:db18:b62b with SMTP id 9-20020a05620a070900b0067ddb18b62bmr18499632qkc.2.1648043649204;
        Wed, 23 Mar 2022 06:54:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNKMkeyDL6owOuZq/yQMl0dC0JGNmXAlEIBKsmpJ7pAyWr8mQi6FjWZ/yzv80h7Z6guEaHTQ==
X-Received: by 2002:a05:620a:709:b0:67d:db18:b62b with SMTP id 9-20020a05620a070900b0067ddb18b62bmr18499620qkc.2.1648043648982;
        Wed, 23 Mar 2022 06:54:08 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id p10-20020a05620a132a00b0067f926e36b2sm18222qkj.91.2022.03.23.06.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 06:54:08 -0700 (PDT)
Date:   Wed, 23 Mar 2022 14:54:03 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v2 1/3] vsock/virtio: enable VQs early on probe
Message-ID: <20220323135403.hqhi3pxzgr6rb7qo@sgarzare-redhat>
References: <20220323084954.11769-1-sgarzare@redhat.com>
 <20220323084954.11769-2-sgarzare@redhat.com>
 <YjskSh4PgXuDStAF@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YjskSh4PgXuDStAF@stefanha-x1.localdomain>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 01:44:42PM +0000, Stefan Hajnoczi wrote:
>On Wed, Mar 23, 2022 at 09:49:52AM +0100, Stefano Garzarella wrote:
>> virtio spec requires drivers to set DRIVER_OK before using VQs.
>> This is set automatically after probe returns, but virtio-vsock
>> driver uses VQs in the probe function to fill rx and event VQs
>> with new buffers.
>>
>> Let's fix this, calling virtio_device_ready() before using VQs
>> in the probe function.
>>
>> Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>  net/vmw_vsock/virtio_transport.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> index 5afc194a58bb..b1962f8cd502 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -622,6 +622,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>  	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
>>  	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
>>
>> +	virtio_device_ready(vdev);
>
>Can rx and event virtqueue interrupts be lost if they occur before we
>assign vdev->priv later in virtio_vsock_probe()?

Yep, as Michael suggested I'll fix the patch order in the next version.

Thanks,
Stefano

