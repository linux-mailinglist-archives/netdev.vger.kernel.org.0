Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB784AB3F4
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 07:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiBGFrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 00:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239478AbiBGDlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 22:41:04 -0500
X-Greylist: delayed 71 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 19:41:02 PST
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DE70C061A73
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 19:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644205260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xVIuoCTqsLoPm1wGvsBC88Fgmkqn303MCtDtpNt2DAQ=;
        b=bC8xOKhdr5WGK8iE0XOm2D7/fsUpiECZ14jMlXJZbHFXh8CjxzRIsMTHrBZt4qrbGJJokv
        CpUSL6ZTmzaq7MXD+QvgYCjUf+JAVaumDRuidlJYBPtWWzRcHUa1ebEDHyqhaT8Bw0LF5i
        Gk5A9mVeWQHrgQUmB6ph8wqedQ4DJqY=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-lHuLF78sP2mAJf9cLSZn3Q-1; Sun, 06 Feb 2022 22:39:50 -0500
X-MC-Unique: lHuLF78sP2mAJf9cLSZn3Q-1
Received: by mail-lj1-f197.google.com with SMTP id p10-20020a2ea4ca000000b0023c8545494fso3877548ljm.2
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 19:39:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xVIuoCTqsLoPm1wGvsBC88Fgmkqn303MCtDtpNt2DAQ=;
        b=bIPdgAaYpSbNQ+BTBDamOJ9suSNr1b46tFix+u5YJv2wpPaz3bLLXVUJzvRP7QC/kR
         IXoaTbVMTSBGSusxVXRcoeryrUv+uSguB0LGIPzlOsbQAI7GJ+rL7OGaU7Kh71pY9TvW
         N5ItefwnWALIKyRD1MAEJMHzGMm991GWhnCOL8Ey1a+S8K6GCBc8O5ZlFGlIBMBmwiGC
         fzVKmEiiA3n23eKG3L2xwkoCsMuXE6wtEbghl1cce2swb6FrHRD1NfmDldltv8SiG8G9
         XE18iiof2mUWD07Z+qVn449qKXBi/7Vo+VtqinXFTu/b9e60psuRX/iOz01TNx5o2K9u
         bJ2w==
X-Gm-Message-State: AOAM532karR+/1lp58TInOhe2K4e4c0zWAV9uOA9RLO4Fe4tWIiLwjw3
        Z4W/Yd/dRxGI+MkVppJlgy3JFCEWYoHMWgYxiUcaKpkAdJnYp7kWshaVsyYM7z0swXxNKJLIXla
        roVTtqAUiXBB2GR/NJboxbY8qpcOuMTzK
X-Received: by 2002:a2e:a4a9:: with SMTP id g9mr7613472ljm.369.1644205188300;
        Sun, 06 Feb 2022 19:39:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQMAzYq+CxytLesVKBqO45/3hGiHz1b6TXhrBr/eXRPDdce+EOxX9OpBCJ3GQOmMhNUh/OlcI2VNakyYjFmnw=
X-Received: by 2002:a2e:a4a9:: with SMTP id g9mr7613459ljm.369.1644205188083;
 Sun, 06 Feb 2022 19:39:48 -0800 (PST)
MIME-Version: 1.0
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 7 Feb 2022 11:39:36 +0800
Message-ID: <CACGkMEspyHTmcSaq9fgpU88VCZGzu21Khp9H+fqL-pb5GLdEpA@mail.gmail.com>
Subject: Re: [PATCH v3 00/17] virtio pci support VIRTIO_F_RING_RESET
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 3:35 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> ================================================================================
> The virtio spec already supports the virtio queue reset function. This patch set
> is to add this function to the kernel. The relevant virtio spec information is
> here:
>
>     https://github.com/oasis-tcs/virtio-spec/issues/124
>
> Also regarding MMIO support for queue reset, I plan to support it after this
> patch is passed.
>
> #14-#17 is the disable/enable function of rx/tx pair implemented by virtio-net
> using the new helper.

One thing that came to mind is the steering. E.g if we disable an RX,
should we stop steering packets to that queue?

Thanks

> This function is not currently referenced by other
> functions. It is more to show the usage of the new helper, I not sure if they
> are going to be merged together.
>
> Please review. Thanks.
>
> v3:
>   1. keep vq, irq unreleased
>
> Xuan Zhuo (17):
>   virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
>   virtio: queue_reset: add VIRTIO_F_RING_RESET
>   virtio: queue_reset: struct virtio_config_ops add callbacks for
>     queue_reset
>   virtio: queue_reset: add helper
>   vritio_ring: queue_reset: extract the release function of the vq ring
>   virtio_ring: queue_reset: split: add __vring_init_virtqueue()
>   virtio_ring: queue_reset: split: support enable reset queue
>   virtio_ring: queue_reset: packed: support enable reset queue
>   virtio_ring: queue_reset: add vring_reset_virtqueue()
>   virtio_pci: queue_reset: update struct virtio_pci_common_cfg and
>     option functions
>   virtio_pci: queue_reset: release vq by vp_dev->vqs
>   virtio_pci: queue_reset: setup_vq use vring_setup_virtqueue()
>   virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
>   virtio_net: virtnet_tx_timeout() fix style
>   virtio_net: virtnet_tx_timeout() stop ref sq->vq
>   virtio_net: split free_unused_bufs()
>   virtio_net: support pair disable/enable
>
>  drivers/net/virtio_net.c               | 220 ++++++++++++++++++++++---
>  drivers/virtio/virtio_pci_common.c     |  62 ++++---
>  drivers/virtio/virtio_pci_common.h     |  11 +-
>  drivers/virtio/virtio_pci_legacy.c     |   5 +-
>  drivers/virtio/virtio_pci_modern.c     | 120 +++++++++++++-
>  drivers/virtio/virtio_pci_modern_dev.c |  28 ++++
>  drivers/virtio/virtio_ring.c           | 144 +++++++++++-----
>  include/linux/virtio.h                 |   1 +
>  include/linux/virtio_config.h          |  75 ++++++++-
>  include/linux/virtio_pci_modern.h      |   2 +
>  include/linux/virtio_ring.h            |  42 +++--
>  include/uapi/linux/virtio_config.h     |   7 +-
>  include/uapi/linux/virtio_pci.h        |   2 +
>  13 files changed, 618 insertions(+), 101 deletions(-)
>
> --
> 2.31.0
>

