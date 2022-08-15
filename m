Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547E0594E5B
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiHPCBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243651AbiHPCBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:01:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01F5A220046
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660600402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=nE9l+oBuuihtRdwrfLYvB+ZfpLg2bb3PcW4cPmCNwqE=;
        b=RrgP37l8lMoBxZ4/jGC6A86UoBGXBmhMCL63a36CZKrzxdZY7iAoRlntTDv7oaKDQe4erX
        sEqTfnTunYnUbJ2Zrpe9IOeK3WayQIgZPlazVjMg5OlI/xk84sHgVDBNnM9cLD+Wdomq6C
        Os5LgaZatZyKu2ga3Hzuuq/tb3CEa74=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-218-LhZIcCu_N5is1LRUzzJwYA-1; Mon, 15 Aug 2022 17:53:21 -0400
X-MC-Unique: LhZIcCu_N5is1LRUzzJwYA-1
Received: by mail-wm1-f71.google.com with SMTP id az42-20020a05600c602a00b003a552086ba9so9238402wmb.6
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:53:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=nE9l+oBuuihtRdwrfLYvB+ZfpLg2bb3PcW4cPmCNwqE=;
        b=Kh9F3pSDrhc+O90LtUAfNq1M1AVKjpPkHzWRFL47duq0E3GPMRnmXU/oePEyV9sD4i
         fE/X4npu6mbW4S/3g2W9EnMw6FeiBLCHJgP9lmw5o2l0/ExBNI5YGwIprdy4mGH93jcD
         M1EXcFtsAKt42SezWAJQ4OY9IcUG5JzrGF/WhSIJMTNAarTBlv8sLjI8rVMrrIzRJTfv
         dwrCTakFvB76ulgO4DZ6I+2wHICIBZ86x2gfQNBGxO5gT/sH2mliLKKaC13mrGyJOC28
         l3Y91/OE/Elj+4ikoPUg8yuYzc3cITZnRdIcBYUhgoqYRaexPwR8lmPQQioOfUgvpgn9
         mqkw==
X-Gm-Message-State: ACgBeo2crbbuTKU1EK0/3RqYjeRDqJnagqjS1NVhS2NSq/VgInt3+Uog
        bx+Z0f/taw0HATfxS6h5BggdxJeaYNeb8prh/oejPnKywiUW1qhJW+FnYYDoxtpz7JcHmwsDqz6
        wAImdtLp4wg9uMpLq
X-Received: by 2002:adf:e588:0:b0:21f:ace:dd82 with SMTP id l8-20020adfe588000000b0021f0acedd82mr9691327wrm.226.1660600400302;
        Mon, 15 Aug 2022 14:53:20 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4hxSDMZpftCBBMFSFs4qXARqcIDfoNeMwyu98fDGaG6R9gCUSZWy72wuRpnU0bbvDp4w56Vw==
X-Received: by 2002:adf:e588:0:b0:21f:ace:dd82 with SMTP id l8-20020adfe588000000b0021f0acedd82mr9691323wrm.226.1660600400097;
        Mon, 15 Aug 2022 14:53:20 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id j27-20020a05600c1c1b00b003a32251c3f9sm11520530wms.5.2022.08.15.14.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 14:53:19 -0700 (PDT)
Date:   Mon, 15 Aug 2022 17:53:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v2 0/5] virtio: drop sizing vqs during init
Message-ID: <20220815215251.154451-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supplying size during init does not work for all transports.
In fact for legacy pci doing that causes a memory
corruption which was reported on Google Cloud.

We might get away with changing size to size_hint so it's
safe to ignore and then fixing legacy to ignore the hint.

But the benefit is unclear in any case, so let's revert for now.
Any new version will have to come with
- documentation of performance gains
- performance testing showing existing workflows
  are not harmed materially. especially ones with
  bursty traffic
- report of testing on legacy devices


Huge shout out to Andres Freund for the effort spent reproducing and
debugging!  Thanks to Guenter Roeck for help with testing!

Michael S. Tsirkin (5):
  virtio_net: Revert "virtio_net: set the default max ring size by
    find_vqs()"
  virtio: Revert "virtio: add helper virtio_find_vqs_ctx_size()"
  virtio-mmio: Revert "virtio_mmio: support the arg sizes of find_vqs()"
  virtio_pci: Revert "virtio_pci: support the arg sizes of find_vqs()"
  virtio: Revert "virtio: find_vqs() add arg sizes"

 arch/um/drivers/virtio_uml.c             |  2 +-
 drivers/net/virtio_net.c                 | 42 +++---------------------
 drivers/platform/mellanox/mlxbf-tmfifo.c |  1 -
 drivers/remoteproc/remoteproc_virtio.c   |  1 -
 drivers/s390/virtio/virtio_ccw.c         |  1 -
 drivers/virtio/virtio_mmio.c             |  9 ++---
 drivers/virtio/virtio_pci_common.c       | 20 +++++------
 drivers/virtio/virtio_pci_common.h       |  3 +-
 drivers/virtio/virtio_pci_legacy.c       |  6 +---
 drivers/virtio/virtio_pci_modern.c       | 17 +++-------
 drivers/virtio/virtio_vdpa.c             |  1 -
 include/linux/virtio_config.h            | 26 +++------------
 12 files changed, 28 insertions(+), 101 deletions(-)

-- 
MST

