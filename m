Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6616C21310
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 06:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfEQEaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 00:30:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34698 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfEQEaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 00:30:05 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 79B3630821AE;
        Fri, 17 May 2019 04:30:02 +0000 (UTC)
Received: from hp-dl380pg8-02.lab.eng.pek2.redhat.com (hp-dl380pg8-02.lab.eng.pek2.redhat.com [10.73.8.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37C901001E78;
        Fri, 17 May 2019 04:29:54 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, stefanha@redhat.com
Subject: [PATCH V2 0/4] Prevent vhost kthread from hogging CPU
Date:   Fri, 17 May 2019 00:29:48 -0400
Message-Id: <1558067392-11740-1-git-send-email-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 17 May 2019 04:30:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi:

This series try to prevent a guest triggerable CPU hogging through
vhost kthread. This is done by introducing and checking the weight
after each requrest. The patch has been tested with reproducer of
vsock and virtio-net. Only compile test is done for vhost-scsi.

Please review.

This addresses CVE-2019-3900.

Changs from V1:
- fix user-ater-free in vosck patch

Jason Wang (4):
  vhost: introduce vhost_exceeds_weight()
  vhost_net: fix possible infinite loop
  vhost: vsock: add weight support
  vhost: scsi: add weight support

 drivers/vhost/net.c   | 41 ++++++++++++++---------------------------
 drivers/vhost/scsi.c  | 21 ++++++++++++++-------
 drivers/vhost/vhost.c | 20 +++++++++++++++++++-
 drivers/vhost/vhost.h |  5 ++++-
 drivers/vhost/vsock.c | 28 +++++++++++++++++++++-------
 5 files changed, 72 insertions(+), 43 deletions(-)

-- 
1.8.3.1

