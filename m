Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1121E9F9F0
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 07:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfH1Fks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 01:40:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:18843 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbfH1Fks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 01:40:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 22:40:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="scan'208";a="332049724"
Received: from dpdk-virtio-tbie-2.sh.intel.com ([10.67.104.71])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2019 22:40:45 -0700
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] vhost/test: fix build for vhost test
Date:   Wed, 28 Aug 2019 13:36:59 +0800
Message-Id: <20190828053700.26022-1-tiwei.bie@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since below commit, callers need to specify the iov_limit in
vhost_dev_init() explicitly.

Fixes: b46a0bf78ad7 ("vhost: fix OOB in get_rx_bufs()")
Cc: stable@vger.kernel.org
Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
---
 drivers/vhost/test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 9e90e969af55..ac4f762c4f65 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -115,7 +115,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
 	dev = &n->dev;
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
-	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX);
+	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV);
 
 	f->private_data = n;
 
-- 
2.17.1

