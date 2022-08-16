Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2EA75954B2
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiHPILN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbiHPIKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:10:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BB6DE8B
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 22:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660628189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=WjKAhjhunNiMNkU3Od6M/0vKjOdgqMSNXwPsu3GbYh8=;
        b=OZlmyV5xMn1PtoB6T0VdFWINc71TI54FW1j9TpN/VEKXJXN/UlIln3NNqMxN4xb+xf0haA
        5412ceozJ3kTrwUMSY9hl8l9HsL88nxFhsDKlD1ds8Yj2HDs3IJFge++BRDR5Vh5HYed6B
        Bc2mn/pu62lJFsm6Oc0hQlwMFxe/00s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-601-veJC0D-WP2yI4ys9EIdcGA-1; Tue, 16 Aug 2022 01:36:24 -0400
X-MC-Unique: veJC0D-WP2yI4ys9EIdcGA-1
Received: by mail-wm1-f69.google.com with SMTP id i132-20020a1c3b8a000000b003a537064611so4462624wma.4
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 22:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=WjKAhjhunNiMNkU3Od6M/0vKjOdgqMSNXwPsu3GbYh8=;
        b=T44b98eF1YWSP/AeCH7PvvV+LLfPGsGXTvcQlYpf8Wviti7rr59fCplT2j8JR5zcfm
         motRaTJAwpqomrCHuObPoMAMiU/rDeabGD8t1wDCiU85GDBrmxGykIYNXJsvf0MOfdaZ
         QKP/E9SaoSPjSbYlFzpVsyNws/uOq9c7HGjsF2RBrVeCTEvaa6tTWm2JgUq/CDJ47JZE
         LMgWcuRQVLAgtI4IDcIKmHO4XzbgCufO/3BMzOXAWpY0nbvaR9cmYDwZ9VJ7AGlkCOR5
         +2beZ1y1ZXVmHTiETUoUjKkULhMseAbtw7RzTypfigHItVdY5LUzvdvEFE1tXqEegx0r
         uptw==
X-Gm-Message-State: ACgBeo1hB7zmjxFwtMXXFRHazU9795WCuEWHTtAUb/Req4tywVbO78sh
        ZxnA+xUaxHylv33xM+lm5q3DjqEpMbdkZUjSPAcpoBOx7LvZUwKWQO7DfYAtHvHCrUTrbZievLY
        hImSbfNIBSth6vXCo
X-Received: by 2002:a05:600c:5023:b0:3a6:3f9:a031 with SMTP id n35-20020a05600c502300b003a603f9a031mr1681812wmr.131.1660628183683;
        Mon, 15 Aug 2022 22:36:23 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7Ytdoo+ffEU/Wth88pKDtXl7fYx4Itdz9p5tt4Lf/IjatyzTa6AA/SXcS7E/UC3HmlhH/8rQ==
X-Received: by 2002:a05:600c:5023:b0:3a6:3f9:a031 with SMTP id n35-20020a05600c502300b003a603f9a031mr1681790wmr.131.1660628183420;
        Mon, 15 Aug 2022 22:36:23 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id v17-20020a5d43d1000000b0021eed2414c9sm8763232wrr.40.2022.08.15.22.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 22:36:22 -0700 (PDT)
Date:   Tue, 16 Aug 2022 01:36:18 -0400
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
Subject: [PATCH v4 0/6] virtio: drop sizing vqs during init
Message-ID: <20220816053602.173815-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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


changes from v3
	added a vdpa revert
changes from v2
	drop unrelated patches
changes from v1
	revert the ring size api, it's unused now

Michael S. Tsirkin (5):
  virtio_net: Revert "virtio_net: set the default max ring size by
    find_vqs()"


Michael S. Tsirkin (6):
  virtio_net: Revert "virtio_net: set the default max ring size by
    find_vqs()"


Michael S. Tsirkin (6):
  virtio_net: Revert "virtio_net: set the default max ring size by
    find_vqs()"
  virtio: Revert "virtio: add helper virtio_find_vqs_ctx_size()"
  virtio-mmio: Revert "virtio_mmio: support the arg sizes of find_vqs()"
  virtio_pci: Revert "virtio_pci: support the arg sizes of find_vqs()"
  virtio_vdpa: Revert "virtio_vdpa: support the arg sizes of find_vqs()"
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
 drivers/virtio/virtio_vdpa.c             | 16 ++++-----
 include/linux/virtio_config.h            | 26 +++------------
 12 files changed, 34 insertions(+), 110 deletions(-)

-- 
MST

