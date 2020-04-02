Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 601D219BC02
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 08:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgDBGwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 02:52:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12600 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725875AbgDBGwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 02:52:49 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9984748B7BA6F3CE41D5;
        Thu,  2 Apr 2020 14:52:39 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 14:52:29 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <tiwei.bie@intel.com>, <mst@redhat.com>, <jasowang@redhat.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH -next] vhost: remove set but not used variable 'status'
Date:   Thu, 2 Apr 2020 14:51:06 +0800
Message-ID: <20200402065106.20108-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following gcc warning:
drivers/vhost/vdpa.c:299:5: warning: variable 'status' set but not used [-Wunused-but-set-variable]
  u8 status;
     ^~~~~~

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/vhost/vdpa.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 421f02a8530a..a645b1db606d 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -296,7 +296,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 	struct vdpa_callback cb;
 	struct vhost_virtqueue *vq;
 	struct vhost_vring_state s;
-	u8 status;
 	u32 idx;
 	long r;
 
@@ -310,8 +309,6 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 	idx = array_index_nospec(idx, v->nvqs);
 	vq = &v->vqs[idx];
 
-	status = ops->get_status(vdpa);
-
 	if (cmd == VHOST_VDPA_SET_VRING_ENABLE) {
 		if (copy_from_user(&s, argp, sizeof(s)))
 			return -EFAULT;
-- 
2.17.2

