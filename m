Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D754D27F0
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiCIErQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 23:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiCIErO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 23:47:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ACE1BECC57
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 20:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646801174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O9y7hYtf8DIbE/b1LIIjEL5hDziwE2SHgt9FQ5yzHZY=;
        b=Rw4HgqxFdx9R5XkzimF6Q9vaE+dGRjq1OMXXjp7p85D65q11yr3aRAPXED6Qoe6GjCoD2S
        sQSpzf87Gil43Ninq0cTK7PoOn9yk/cjLYbmHiDeUkKVnrr/j+vDSBVVqtyj9T3RBGJZiy
        rwPY3QURaQOEi0scarEuUK/0yqVt9sM=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-295-ih1Ko46-PIiLa44glNcTJw-1; Tue, 08 Mar 2022 23:46:13 -0500
X-MC-Unique: ih1Ko46-PIiLa44glNcTJw-1
Received: by mail-pf1-f198.google.com with SMTP id 67-20020a621446000000b004f739ef52f1so889925pfu.0
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 20:46:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=O9y7hYtf8DIbE/b1LIIjEL5hDziwE2SHgt9FQ5yzHZY=;
        b=deOwC+D9IsIVzYxZxe6n4h5YA6vKwNrMlgCdr9eKSjlJwVsUl2rUaIOBee/uFLxdmh
         puc3zJ7j1BpPlUnv6z7sLnM6+zs6QH17+Gc4OUezyXMaDZ6JB+wfg6IPBYGPlQ4KlF6B
         tVoSis1cSyXMSMTbWdBiYxt1VIikybjKWRKwQQwMML2g848tEPkD5+WigQRPAT334R44
         DKpp2DHkLi/PM5lhoKxeBNGvpyPWzi/rQ2DcHc1iXUL/wFCMgtjxlmDWTwHPtHHRbupO
         TZJMhsG9AkfO0xNLjf+K5WGje/zQdS0l0ueB2StK5089TpsGo5X4mBCJN9VqglSGi97O
         7d4g==
X-Gm-Message-State: AOAM530srvhUkfia1/asBLceEXyd5Ls5QcCHUFWN5xhjgNtDeznRCrSO
        nc7jPApd0DHStipUjSauBtGYgznvrhxRnZxGvCBHBIgYl5zKx6RYDeWjYBDvmbJN6IGT9FztZHn
        xazqijiICQ4GjuT0E
X-Received: by 2002:a17:90a:17ab:b0:1bf:9519:fe86 with SMTP id q40-20020a17090a17ab00b001bf9519fe86mr5407277pja.25.1646801172046;
        Tue, 08 Mar 2022 20:46:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzNoaLCqq9sRt9psO5uqafOMqGFVYmxmfOSqOlDkq0FsYupDy1WKwY2W2xGCXK65aGhCKiuiQ==
X-Received: by 2002:a17:90a:17ab:b0:1bf:9519:fe86 with SMTP id q40-20020a17090a17ab00b001bf9519fe86mr5407253pja.25.1646801171689;
        Tue, 08 Mar 2022 20:46:11 -0800 (PST)
Received: from [10.72.13.251] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o5-20020a056a00214500b004bd7036b50asm810863pfk.172.2022.03.08.20.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 20:46:11 -0800 (PST)
Message-ID: <2c823fed-8024-39e7-f6f5-176fb518fc1a@redhat.com>
Date:   Wed, 9 Mar 2022 12:45:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v7 00/26] virtio pci support VIRTIO_F_RING_RESET
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/8 下午8:34, Xuan Zhuo 写道:
> The virtio spec already supports the virtio queue reset function. This patch set
> is to add this function to the kernel. The relevant virtio spec information is
> here:
>
>      https://github.com/oasis-tcs/virtio-spec/issues/124
>
> Also regarding MMIO support for queue reset, I plan to support it after this
> patch is passed.
>
> Performing reset on a queue is divided into four steps:
>       1. virtio_reset_vq()              - notify the device to reset the queue
>       2. virtqueue_detach_unused_buf()  - recycle the buffer submitted
>       3. virtqueue_reset_vring()        - reset the vring (may re-alloc)
>       4. virtio_enable_resetq()         - mmap vring to device, and enable the queue
>
> The first part 1-17 of this patch set implements virtio pci's support and API
> for queue reset. The latter part is to make virtio-net support set_ringparam. Do
> these things for this feature:
>
>        1. virtio-net support rx,tx reset
>        2. find_vqs() support to special the max size of each vq
>        3. virtio-net support set_ringparam
>
> #1 -#3 :       prepare
> #4 -#12:       virtio ring support reset vring of the vq
> #13-#14:       add helper
> #15-#17:       virtio pci support reset queue and re-enable
> #18-#21:       find_vqs() support sizes to special the max size of each vq
> #23-#24:       virtio-net support rx, tx reset
> #22, #25, #26: virtio-net support set ringparam
>
> Test environment:
>      Host: 4.19.91
>      Qemu: QEMU emulator version 6.2.50 (with vq reset support)
>      Test Cmd:  ethtool -G eth1 rx $1 tx $2; ethtool -g eth1
>
>      The default is split mode, modify Qemu virtio-net to add PACKED feature to test
>      packed mode.
>
>
> Please review. Thanks.
>
> v7:
>    1. fix #6 subject typo
>    2. fix #6 ring_size_in_bytes is uninitialized
>    3. check by: make W=12
>
> v6:
>    1. virtio_pci: use synchronize_irq(irq) to sync the irq callbacks
>    2. Introduce virtqueue_reset_vring() to implement the reset of vring during
>       the reset process. May use the old vring if num of the vq not change.
>    3. find_vqs() support sizes to special the max size of each vq
>
> v5:
>    1. add virtio-net support set_ringparam
>
> v4:
>    1. just the code of virtio, without virtio-net
>    2. Performing reset on a queue is divided into these steps:
>      1. reset_vq: reset one vq
>      2. recycle the buffer from vq by virtqueue_detach_unused_buf()
>      3. release the ring of the vq by vring_release_virtqueue()
>      4. enable_reset_vq: re-enable the reset queue
>    3. Simplify the parameters of enable_reset_vq()
>    4. add container structures for virtio_pci_common_cfg
>
> v3:
>    1. keep vq, irq unreleased


The series became kind of huge.

I'd suggest to split it into two series.

1) refactoring of the virtio_ring to prepare for the resize
2) the reset support + virtio-net support

Thanks


>
> *** BLURB HERE ***
>
> Xuan Zhuo (26):
>    virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
>    virtio: queue_reset: add VIRTIO_F_RING_RESET
>    virtio: add helper virtqueue_get_vring_max_size()
>    virtio_ring: split: extract the logic of creating vring
>    virtio_ring: split: extract the logic of init vq and attach vring
>    virtio_ring: packed: extract the logic of creating vring
>    virtio_ring: packed: extract the logic of init vq and attach vring
>    virtio_ring: extract the logic of freeing vring
>    virtio_ring: split: implement virtqueue_reset_vring_split()
>    virtio_ring: packed: implement virtqueue_reset_vring_packed()
>    virtio_ring: introduce virtqueue_reset_vring()
>    virtio_ring: update the document of the virtqueue_detach_unused_buf
>      for queue reset
>    virtio: queue_reset: struct virtio_config_ops add callbacks for
>      queue_reset
>    virtio: add helper for queue reset
>    virtio_pci: queue_reset: update struct virtio_pci_common_cfg and
>      option functions
>    virtio_pci: queue_reset: extract the logic of active vq for modern pci
>    virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
>    virtio: find_vqs() add arg sizes
>    virtio_pci: support the arg sizes of find_vqs()
>    virtio_mmio: support the arg sizes of find_vqs()
>    virtio: add helper virtio_find_vqs_ctx_size()
>    virtio_net: get ringparam by virtqueue_get_vring_max_size()
>    virtio_net: split free_unused_bufs()
>    virtio_net: support rx/tx queue reset
>    virtio_net: set the default max ring size by find_vqs()
>    virtio_net: support set_ringparam
>
>   arch/um/drivers/virtio_uml.c             |   2 +-
>   drivers/net/virtio_net.c                 | 257 ++++++++--
>   drivers/platform/mellanox/mlxbf-tmfifo.c |   3 +-
>   drivers/remoteproc/remoteproc_virtio.c   |   2 +-
>   drivers/s390/virtio/virtio_ccw.c         |   2 +-
>   drivers/virtio/virtio_mmio.c             |  12 +-
>   drivers/virtio/virtio_pci_common.c       |  28 +-
>   drivers/virtio/virtio_pci_common.h       |   3 +-
>   drivers/virtio/virtio_pci_legacy.c       |   8 +-
>   drivers/virtio/virtio_pci_modern.c       | 146 +++++-
>   drivers/virtio/virtio_pci_modern_dev.c   |  36 ++
>   drivers/virtio/virtio_ring.c             | 584 +++++++++++++++++------
>   drivers/virtio/virtio_vdpa.c             |   2 +-
>   include/linux/virtio.h                   |  12 +
>   include/linux/virtio_config.h            |  74 ++-
>   include/linux/virtio_pci_modern.h        |   2 +
>   include/uapi/linux/virtio_config.h       |   7 +-
>   include/uapi/linux/virtio_pci.h          |  14 +
>   18 files changed, 979 insertions(+), 215 deletions(-)
>
> --
> 2.31.0
>

