Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47F46A8125
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 12:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjCBLf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 06:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCBLfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 06:35:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2EE20543
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 03:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677756871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VN5H8jXkUyi7b3gGlXy5t9+JY6Ep4JlnJplI0XClENQ=;
        b=RWlas/G32zRmY2z5vPJ+vmV7RmM4YDog9rtsXrlrzjtllPhnT/d5YSkxtsnoHwxwKSW3yw
        HpkPYIr3r6vO7LEC/gnFqpwyqW7kljaKsH74+YPo1DfZiClv0cgNbY2ORCEAjZ0vgahZrc
        QyMiIgoTpXiItJo6IiVimWxqdnu+l4o=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-546-FKGOF9IoOXiJDE-bFRneew-1; Thu, 02 Mar 2023 06:34:28 -0500
X-MC-Unique: FKGOF9IoOXiJDE-bFRneew-1
Received: by mail-qv1-f69.google.com with SMTP id lt7-20020a056214570700b0057290f3623eso8595944qvb.3
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 03:34:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VN5H8jXkUyi7b3gGlXy5t9+JY6Ep4JlnJplI0XClENQ=;
        b=A47UxQmyL+Y9A0zBC/YYtx4xyV0TE2noGXBBAEqXn80Ukfn0dEnQyzrbhJAVGc6KX1
         5Yklf7d7Hr1UMtmCeiZ3KpQEU7E4YBq2yNYYEh2h5/y4b3z0M89h0P/562H+W2UrMid+
         wGd2uFSwY3b1PsHO7iLJS7GpA6QIUq4qKtyM3bKIRGXDqaiGzUlR0j+t62FO66EOPn3/
         j8WkJdi6/xbzMoxIGGsdbLEqjh4fiwKPs3uz9NQ4EId+pGvPlHpfRC/OQRndB/UM8NDd
         neXGZ8Wh1TQXXv4PbX+LrsIzhjZ6WoYbvaB8TylQOD8hUK7VGVHQ6aBauX26C2RLYP0v
         v2kQ==
X-Gm-Message-State: AO0yUKUjpe9/WmHWcmnElrFnp0osN2ArMi0eBNVfU+ULLG0HbFKSzNF2
        4Wp1oxcb0+jhSKQMxC4hqLy0CcWoLdY60UrOvMKuo158jMu7l35eHlDzqBhSF/M1pCmuOvmt1Yk
        HWB6OzTBiijMpFAVI
X-Received: by 2002:ac8:5784:0:b0:3b9:bd05:bde1 with SMTP id v4-20020ac85784000000b003b9bd05bde1mr17927059qta.8.1677756868183;
        Thu, 02 Mar 2023 03:34:28 -0800 (PST)
X-Google-Smtp-Source: AK7set/2/Vd4OA7axFE8KFaebdPNos2qTeW2fYUlVEyXvnFpPWZ0y0QARAa9MZDYbM3lH3FNvX4jMA==
X-Received: by 2002:ac8:5784:0:b0:3b9:bd05:bde1 with SMTP id v4-20020ac85784000000b003b9bd05bde1mr17927037qta.8.1677756867876;
        Thu, 02 Mar 2023 03:34:27 -0800 (PST)
Received: from step1.redhat.com (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id o12-20020ac8698c000000b003ba19e53e43sm10084156qtq.25.2023.03.02.03.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:34:27 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v2 0/8] vdpa_sim: add support for user VA
Date:   Thu,  2 Mar 2023 12:34:13 +0100
Message-Id: <20230302113421.174582-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
- rebased on Linus' tree, commit ae3419fbac84 ("vc_screen: don't clobber
  return value in vcs_read")
- removed `struct task_struct *owner` param (unused for now, maybe
  useful to support cgroups) [Jason]
- add unbind_mm callback [Jason]
- call the new unbind_mm callback during the release [Jason]
- avoid to call bind_mm callback after the reset, since the device
  is not detaching it now during the reset
- added new patch replace kmap_atomic() with kmap_local_page() since
  checkpatch.pl complained about deprecation of kmap_atomic() touched
  by a patch in this series
- fix cast warnings when build with W=1 C=1
- added new patch to replace the spinlock with a mutex [Jason]
- `use_va` set to true by default [Eugenio]
- supported the new unbind_mm callback [Jason]
- removed the unbind_mm call in vdpasim_do_reset() [Jason]
- avoided to release the lock while call kthread_flush_work() since
  we are now using a mutex to protect the device state

RFC v1: https://lore.kernel.org/lkml/20221214163025.103075-1-sgarzare@redhat.com/

This series adds support for the use of user virtual addresses in the
vDPA simulator devices.

The main reason for this change is to lift the pinning of all guest memory.
Especially with virtio devices implemented in software.

The next step would be to generalize the code in vdpa-sim to allow the
implementation of in-kernel software devices. Similar to vhost, but using vDPA
so we can reuse the same software stack (e.g. in QEMU) for both HW and SW
devices.

For example, we have never merged vhost-blk, and lately there has been interest.
So it would be nice to do it directly with vDPA to reuse the same code in the
VMM for both HW and SW vDPA block devices.

The main problem (addressed by this series) was due to the pinning of all
guest memory, which thus prevented the overcommit of guest memory.

Thanks,
Stefano

Stefano Garzarella (8):
  vdpa: add bind_mm/unbind_mm callbacks
  vhost-vdpa: use bind_mm/unbind_mm device callbacks
  vringh: replace kmap_atomic() with kmap_local_page()
  vringh: support VA with iotlb
  vdpa_sim: make devices agnostic for work management
  vdpa_sim: use kthread worker
  vdpa_sim: replace the spinlock with a mutex to protect the state
  vdpa_sim: add support for user VA

 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  11 +-
 include/linux/vdpa.h                 |  10 ++
 include/linux/vringh.h               |   5 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c    |   2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 160 ++++++++++++++---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  10 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  10 +-
 drivers/vhost/vdpa.c                 |  30 ++++
 drivers/vhost/vringh.c               | 247 +++++++++++++++++++++------
 9 files changed, 395 insertions(+), 90 deletions(-)

-- 
2.39.2

