Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03124396F32
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhFAIrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:47:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233165AbhFAIrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 04:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622537122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=m8BOMT+1NjAco9MxdqnLMg71t/kZo3fvIxUKRkXGuWc=;
        b=XLhr5iRDuVqFqVwp1FYxUXcvNYPVqkRqS3iIs0RmID7HKsyCziBpKaD2T/j9g93GQUXB/h
        Y5/2RuGbVFW+zB0gi+WuFAfHojmkO9fzVHftzSbttU/GECBDDrQwGWXt8vxFQ558ddnU84
        Tz+l3e+HLWsv8P/6ZhAhnowFqXsnHt4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-T-5UWkCIOhO0x1dG2qwbKw-1; Tue, 01 Jun 2021 04:45:19 -0400
X-MC-Unique: T-5UWkCIOhO0x1dG2qwbKw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C841107ACFC;
        Tue,  1 Jun 2021 08:45:18 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-16.pek2.redhat.com [10.72.12.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BC871037E81;
        Tue,  1 Jun 2021 08:45:05 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     eli@mellanox.com
Subject: [PATCH 0/4] Packed virtqueue state support for vDPA
Date:   Tue,  1 Jun 2021 16:44:59 +0800
Message-Id: <20210601084503.34724-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

Eli Cohen (1):
  virtio/vdpa: clear the virtqueue state during probe

Jason Wang (3):
  vdpa: support packed virtqueue for set/get_vq_state()
  virtio-pci library: introduce vp_modern_get_driver_features()
  vp_vdpa: allow set vq state to initial state after reset

 drivers/vdpa/ifcvf/ifcvf_main.c        |  4 +--
 drivers/vdpa/vdpa_sim/vdpa_sim.c       |  4 +--
 drivers/vdpa/virtio_pci/vp_vdpa.c      | 42 ++++++++++++++++++++++++--
 drivers/vhost/vdpa.c                   |  4 +--
 drivers/virtio/virtio_pci_modern_dev.c | 21 +++++++++++++
 drivers/virtio/virtio_vdpa.c           | 15 +++++++++
 include/linux/vdpa.h                   | 25 +++++++++++++--
 include/linux/virtio_pci_modern.h      |  1 +
 8 files changed, 105 insertions(+), 11 deletions(-)

-- 
2.25.1

