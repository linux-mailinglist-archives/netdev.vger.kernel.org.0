Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB8F844DF
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 08:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfHGGzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 02:55:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41430 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbfHGGzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 02:55:04 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2297C9B28F;
        Wed,  7 Aug 2019 06:55:04 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB6001001281;
        Wed,  7 Aug 2019 06:55:01 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, jgg@ziepe.ca
Subject: [PATCH V3 01/10] vhost: disable metadata prefetch optimization
Date:   Wed,  7 Aug 2019 02:54:40 -0400
Message-Id: <20190807065449.23373-2-jasowang@redhat.com>
In-Reply-To: <20190807065449.23373-1-jasowang@redhat.com>
References: <20190807065449.23373-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 07 Aug 2019 06:55:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

This seems to cause guest and host memory corruption.
Disable for now until we get a better handle on that.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 819296332913..42a8c2a13ab1 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -96,7 +96,7 @@ struct vhost_uaddr {
 };
 
 #if defined(CONFIG_MMU_NOTIFIER) && ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE == 0
-#define VHOST_ARCH_CAN_ACCEL_UACCESS 1
+#define VHOST_ARCH_CAN_ACCEL_UACCESS 0
 #else
 #define VHOST_ARCH_CAN_ACCEL_UACCESS 0
 #endif
-- 
2.18.1

