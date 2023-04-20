Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3EFA6E96FB
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbjDTOYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjDTOYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:24:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B17A3C33
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 07:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682000614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lfo2baQUlkaoUrH6uVBEN/YQb1jbKuxQyDXUby2j6jw=;
        b=WBwou1KnMVruyGMA3rktOxtTgPf2nxqOFT2Exors12GTpotB4EH7aZydyNqXCaZlOMX/vR
        hRSNhu5FVBhUtLBNNNSIai/x9JQixk6Rtw02vYCF8aJi5oJBsIU2bScyxcPBllkpn/QozK
        /L++DfcgQ2RpyKViW3cRAgXDvZT01YQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-iDJJoEQ3Mfyqn8NlwvFLNQ-1; Thu, 20 Apr 2023 10:23:31 -0400
X-MC-Unique: iDJJoEQ3Mfyqn8NlwvFLNQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE77E3C106A4;
        Thu, 20 Apr 2023 14:23:30 +0000 (UTC)
Received: from [10.39.208.29] (unknown [10.39.208.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFDA140C2064;
        Thu, 20 Apr 2023 14:23:28 +0000 (UTC)
Message-ID: <b97af8ee-5b5d-fbd9-443d-ee18f97ee03b@redhat.com>
Date:   Thu, 20 Apr 2023 16:23:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Marchand <david.marchand@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>, xuanzhuo@linux.alibaba.com,
        Eugenio Perez Martin <eperezma@redhat.com>
References: <20230419134329.346825-1-maxime.coquelin@redhat.com>
 <CACycT3tbQSFdADGiP-ijSj2ZjRctMsPmJQhEBygguzYOjA4Y9Q@mail.gmail.com>
From:   Maxime Coquelin <maxime.coquelin@redhat.com>
Subject: Re: [RFC 0/2] vduse: add support for networking devices
In-Reply-To: <CACycT3tbQSFdADGiP-ijSj2ZjRctMsPmJQhEBygguzYOjA4Y9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/23 10:13, Yongji Xie wrote:
> On Wed, Apr 19, 2023 at 9:44 PM Maxime Coquelin
> <maxime.coquelin@redhat.com> wrote:
>>
>> This small series enables virtio-net device type in VDUSE.
>> With it, basic operation have been tested, both with
>> virtio-vdpa and vhost-vdpa using DPDK Vhost library series
>> adding VDUSE support [0] using split rings layout.
>>
>> Control queue support (and so multiqueue) has also been
>> tested, but require a Kernel series from Jason Wang
>> relaxing control queue polling [1] to function reliably.
>>
>> Other than that, we have identified a few gaps:
>>
>> 1. Reconnection:
>>   a. VDUSE_VQ_GET_INFO ioctl() returns always 0 for avail
>>      index, even after the virtqueue has already been
>>      processed. Is that expected? I have tried instead to
>>      get the driver's avail index directly from the avail
>>      ring, but it does not seem reliable as I sometimes get
>>      "id %u is not a head!\n" warnings. Also such solution
>>      would not be possible with packed ring, as we need to
>>      know the wrap counters values.
>>
> 
> I'm not sure how to handle the reconnection in the vhost-user-net
> case. Can we use a tmpfs file to track inflight I/O like this [1]

We don't have inflight IOs with DPDK Vhsot library for net devices.
But yes, a solution is to have a tmpfs file to save needed data.

Advantage of this solution is it makes it possible to reconnect with
packed ring in case of application crash, as the wrap counter values
would not be lost.

> [1] https://qemu-project.gitlab.io/qemu/interop/vhost-user.html#inflight-i-o-tracking
> 
>>   b. Missing IOCTLs: it would be handy to have new IOCTLs to
>>      query Virtio device status, and retrieve the config
>>      space set at VDUSE_CREATE_DEV time.
>>
> 
> VDUSE_GET_STATUS ioctl might be needed. Or can we use a tmpfs file to
> save/restore that info.
> 
>> 2. VDUSE application as non-root:
>>    We need to run the VDUSE application as non-root. There
>>    is some race between the time the UDEV rule is applied
>>    and the time the device starts being used. Discussing
>>    with Jason, he suggested we may have a VDUSE daemon run
>>    as root that would create the VDUSE device, manages its
>>    rights and then pass its file descriptor to the VDUSE
>>    app. However, with current IOCTLs, it means the VDUSE
>>    daemon would need to know several information that
>>    belongs to the VDUSE app implementing the device such
>>    as supported Virtio features, config space, etc...
>>    If we go that route, maybe we should have a control
>>    IOCTL to create the device which would just pass the
>>    device type. Then another device IOCTL to perform the
>>    initialization. Would that make sense?
>>
> 
> I think we can reuse the VDUSE_CREATE_DEV ioctl (just use name,
> device_id and vendor_id) for control device here, and add a new ioctl
> VDUSE_DEV_SETUP to do device initialization.

OK.
If we do that, could we also provide the possibility to pass an UUID at 
VDUSE_DEV_SETUP time?

It could be useful if we save information in a tmpfs file, in order to
be able at reconnect time to ensure the tmpfs file UUID matches with the
VDUSE device UUID, and so avoid restoring a leftover tmpfs file of a
previously detroyed then re-created VDUSE device. Would that make sense?

Regards,
Maxime

> Thanks,
> Yongji
> 

