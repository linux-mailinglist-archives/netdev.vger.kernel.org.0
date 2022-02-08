Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613204ACF5B
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346320AbiBHDAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346336AbiBHDAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 22:00:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07293C0401DB
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 19:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644289200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ur/XVUARqlEylrl75WMsGXRxz0bKGIVFgoVCSK+68pc=;
        b=FVUUztBKUftKhnfCoadqqUFhP+cevCoIgwOJHOwYWBizOdRYVldfqqx6u1GmsZdrKoRKio
        sMyaIaOls4PpCwEZL9C/zZJ5zzANzr4f/rP7AO4GmbMO5FkD5Q1YCZn91ZE/ZbQ4iACXGz
        Nd7DHtJdRPGi+MVM9is757loV4rquFQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-Lbgbjwc4MiuHZ_0wnpyKrw-1; Mon, 07 Feb 2022 21:59:57 -0500
X-MC-Unique: Lbgbjwc4MiuHZ_0wnpyKrw-1
Received: by mail-pj1-f71.google.com with SMTP id y10-20020a17090a134a00b001b8b7e5983bso3988066pjf.6
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 18:59:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ur/XVUARqlEylrl75WMsGXRxz0bKGIVFgoVCSK+68pc=;
        b=TKuGkNqc7MrhYr452MgiRkGl1zeSJIOV4/CaRRJwQTc+kTATaWXmHR4bRlXXmOhkXc
         HPMgwu/oAwvyY6cnojsAwtkSL2MCKnE6V5gBnED9uWvEijoq3C+i6tqZWkZDeo00bHjp
         8TkzU88hopFy6EqvaI16ztJGL0x9wTAR2Qr6b6lbF7gFIVsOzVeC0U1xAYb09DhGR9ue
         wUbpj6Mv88aVl2zrGeNIFpx8YCH0xljNY9PMoCEjRHhOPjfDL9OdvOmfiREtQvW9xJxF
         vJwFMbJ4R9U75rUqcVbkXLtUzBzog5rIyigJjiXx3s36ukKWLBNxA745HTVB0UqtV+rj
         TCrA==
X-Gm-Message-State: AOAM532eO329d5GFZk4axpIwyF0qxs6dkWdKSiBM/vBH3mqAdY2txxE0
        5i5oZoSkd/fGN7Eogpdx7lUP70bdeCXy+19A+AQX9AqzMSXFSOdi6rPBBYGHxmfSUWjGKWb1QrS
        5qiu5GNfgjI66HvVU
X-Received: by 2002:a17:90a:4291:: with SMTP id p17mr2091896pjg.126.1644289195721;
        Mon, 07 Feb 2022 18:59:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw66uwPUuiCvtKOAmk3ev+B5LJnqGSuJHyL+yJsXiATMQiVAvJGYVXYkgiixcW3KyH9wSlZ6w==
X-Received: by 2002:a17:90a:4291:: with SMTP id p17mr2091878pjg.126.1644289195452;
        Mon, 07 Feb 2022 18:59:55 -0800 (PST)
Received: from [10.72.13.233] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m21sm13834878pfk.26.2022.02.07.18.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:59:54 -0800 (PST)
Message-ID: <7d1e2d5b-a9a1-cbb7-4d80-89df1cb7bf15@redhat.com>
Date:   Tue, 8 Feb 2022 10:59:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v3 00/17] virtio pci support VIRTIO_F_RING_RESET
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
References: <1644213739.5846965-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <1644213739.5846965-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/7 下午2:02, Xuan Zhuo 写道:
> On Mon, 7 Feb 2022 11:39:36 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> On Wed, Jan 26, 2022 at 3:35 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>>> ================================================================================
>>> The virtio spec already supports the virtio queue reset function. This patch set
>>> is to add this function to the kernel. The relevant virtio spec information is
>>> here:
>>>
>>>      https://github.com/oasis-tcs/virtio-spec/issues/124
>>>
>>> Also regarding MMIO support for queue reset, I plan to support it after this
>>> patch is passed.
>>>
>>> #14-#17 is the disable/enable function of rx/tx pair implemented by virtio-net
>>> using the new helper.
>> One thing that came to mind is the steering. E.g if we disable an RX,
>> should we stop steering packets to that queue?
> Yes, we should reselect a queue.
>
> Thanks.


Maybe a spec patch for that?

Thanks


>
>> Thanks
>>
>>> This function is not currently referenced by other
>>> functions. It is more to show the usage of the new helper, I not sure if they
>>> are going to be merged together.
>>>
>>> Please review. Thanks.
>>>
>>> v3:
>>>    1. keep vq, irq unreleased
>>>
>>> Xuan Zhuo (17):
>>>    virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
>>>    virtio: queue_reset: add VIRTIO_F_RING_RESET
>>>    virtio: queue_reset: struct virtio_config_ops add callbacks for
>>>      queue_reset
>>>    virtio: queue_reset: add helper
>>>    vritio_ring: queue_reset: extract the release function of the vq ring
>>>    virtio_ring: queue_reset: split: add __vring_init_virtqueue()
>>>    virtio_ring: queue_reset: split: support enable reset queue
>>>    virtio_ring: queue_reset: packed: support enable reset queue
>>>    virtio_ring: queue_reset: add vring_reset_virtqueue()
>>>    virtio_pci: queue_reset: update struct virtio_pci_common_cfg and
>>>      option functions
>>>    virtio_pci: queue_reset: release vq by vp_dev->vqs
>>>    virtio_pci: queue_reset: setup_vq use vring_setup_virtqueue()
>>>    virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
>>>    virtio_net: virtnet_tx_timeout() fix style
>>>    virtio_net: virtnet_tx_timeout() stop ref sq->vq
>>>    virtio_net: split free_unused_bufs()
>>>    virtio_net: support pair disable/enable
>>>
>>>   drivers/net/virtio_net.c               | 220 ++++++++++++++++++++++---
>>>   drivers/virtio/virtio_pci_common.c     |  62 ++++---
>>>   drivers/virtio/virtio_pci_common.h     |  11 +-
>>>   drivers/virtio/virtio_pci_legacy.c     |   5 +-
>>>   drivers/virtio/virtio_pci_modern.c     | 120 +++++++++++++-
>>>   drivers/virtio/virtio_pci_modern_dev.c |  28 ++++
>>>   drivers/virtio/virtio_ring.c           | 144 +++++++++++-----
>>>   include/linux/virtio.h                 |   1 +
>>>   include/linux/virtio_config.h          |  75 ++++++++-
>>>   include/linux/virtio_pci_modern.h      |   2 +
>>>   include/linux/virtio_ring.h            |  42 +++--
>>>   include/uapi/linux/virtio_config.h     |   7 +-
>>>   include/uapi/linux/virtio_pci.h        |   2 +
>>>   13 files changed, 618 insertions(+), 101 deletions(-)
>>>
>>> --
>>> 2.31.0
>>>

