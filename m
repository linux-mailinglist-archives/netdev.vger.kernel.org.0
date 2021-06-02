Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1A6397EB5
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 04:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhFBCRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 22:17:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230090AbhFBCR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 22:17:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622600147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=N2hbGFGlNW8qsY3oULviD3PMmzK5iC/Hpr9g3x8tySM=;
        b=BgqzhJeA2V2ka6pzmpheZS2yJAh9GEtFvuPgGhebhhn3SjApxQYjhqwah6ynl8TlUfp9vd
        VvWRAQNZhoJgw0L89ECDrf30+XUGrAbSMRIfo4hwnRTSYIERIRNV6jJhjPIRSzB716t5ry
        5lMqXpCPTaTdfBwjciG0eZ/NYL+Pza0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-7tJn53B3N5-yE_3yLMzS-Q-1; Tue, 01 Jun 2021 22:15:45 -0400
X-MC-Unique: 7tJn53B3N5-yE_3yLMzS-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 616F4801B13;
        Wed,  2 Jun 2021 02:15:44 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-99.pek2.redhat.com [10.72.12.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF824687EC;
        Wed,  2 Jun 2021 02:15:38 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     eli@mellanox.com
Subject: [PATCH V2 RESEND 0/4] Packed virtqueue state support for vDPA
Date:   Wed,  2 Jun 2021 10:15:32 +0800
Message-Id: <20210602021536.39525-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi:

This series implements the packed virtqueue state support for
vDPA. This is done via extending the vdpa_vq_state to support packed
virtqueue.

For virtio-vDPA, an initial state required by the virtio spec is set.

For vhost-vDPA, the packed virtqueue support still needs to be done at
both vhost core and vhost-vDPA in the future.

Please review.

Tested with packed=on/off via virtio_vdpa driver.

Change since V1:
- unbreak mlx5_vdpa build

Thanks

Eli Cohen (1):
  virtio/vdpa: clear the virtqueue state during probe

Jason Wang (3):
  vdpa: support packed virtqueue for set/get_vq_state()
  virtio-pci library: introduce vp_modern_get_driver_features()
  vp_vdpa: allow set vq state to initial state after reset

 drivers/vdpa/ifcvf/ifcvf_main.c        |  4 +--
 drivers/vdpa/mlx5/net/mlx5_vnet.c      |  8 ++---
 drivers/vdpa/vdpa_sim/vdpa_sim.c       |  4 +--
 drivers/vdpa/virtio_pci/vp_vdpa.c      | 42 ++++++++++++++++++++++++--
 drivers/vhost/vdpa.c                   |  4 +--
 drivers/virtio/virtio_pci_modern_dev.c | 21 +++++++++++++
 drivers/virtio/virtio_vdpa.c           | 15 +++++++++
 include/linux/vdpa.h                   | 25 +++++++++++++--
 include/linux/virtio_pci_modern.h      |  1 +
 9 files changed, 109 insertions(+), 15 deletions(-)

-- 
2.25.1

