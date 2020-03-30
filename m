Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C8319888A
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 01:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbgC3XrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 19:47:00 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.123]:43262 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728980AbgC3XrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 19:47:00 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 88F113D20F4
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 18:46:58 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id J47OjPQgcVQh0J47OjcTWg; Mon, 30 Mar 2020 18:46:58 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MHojYII/Ua+k7l5hgugppwNvwPqnKoi9qCSV0tIDcMY=; b=WNCS8YARVVpPBy1UXYjUAQe9YQ
        X6c2Xd0hKDmUu0kPnKn8t41HP/yVT8sZYIkv3JeBOsbBDfRQlq5t6x+EDWmdUmriVVWbPWd5tD8xz
        GowGlSXb5Jq+w+PtislgOHg8eZkJMcxfaoI7hvVfWWQBkBv4DAN/3QFUj3nXR6fgMjoWN1gv4aFSu
        vBKaN2abzcQMoalF4KmdvwXhed/SlJzZHdGf07Hp+3zb+jpFW/hIlfRi8f9Z1hS76bTL735ucbXY7
        hNmup79QHHtRJuPUt1zGPS08cYCANg4ZNbwFHa2errdAWcmg5YlblLo2ZK/6JaNOw0LV87U5n/MQi
        cMl/vKrg==;
Received: from cablelink-189-218-116-241.hosts.intercable.net ([189.218.116.241]:34376 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jJ47M-000kyx-S1; Mon, 30 Mar 2020 18:46:56 -0500
Date:   Mon, 30 Mar 2020 18:50:40 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] vhost: vdpa: remove unnecessary null check
Message-ID: <20200330235040.GA9997@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.218.116.241
X-Source-L: No
X-Exim-ID: 1jJ47M-000kyx-S1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: cablelink-189-218-116-241.hosts.intercable.net (embeddedor) [189.218.116.241]:34376
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 13
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

container_of is never null, so this null check is
unnecessary.

Addresses-Coverity-ID: 1492006 ("Logically dead code")
Fixes: 20453a45fb06 ("vhost: introduce vDPA-based backend")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/vhost/vdpa.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 421f02a8530a..3d2cb811757a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -678,8 +678,6 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	int nvqs, i, r, opened;
 
 	v = container_of(inode->i_cdev, struct vhost_vdpa, cdev);
-	if (!v)
-		return -ENODEV;
 
 	opened = atomic_cmpxchg(&v->opened, 0, 1);
 	if (opened)
-- 
2.26.0

