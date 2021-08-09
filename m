Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F90A3E452B
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 14:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbhHIMDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 08:03:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhHIMDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 08:03:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C56760BD3;
        Mon,  9 Aug 2021 12:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628510604;
        bh=i1SSaMqLK/t9+a8jBYbUL9UO1xunMtUISULJwZHB5kc=;
        h=From:To:Cc:Subject:Date:From;
        b=WMRjwqSuh/4TCq7UOhgFdpZ7z9unosGxuc8a6qoAcOg3U7PEeem9GDS2A/HmQuA64
         d/4nqYPUoPzl4UXbJ3xDF8O//5C09bOfvTubSmQzdnvPxWAyjzHcGv/9TP3YFm4ac2
         b90hpt6utsyZixoTRaRSwwzFgUS0KVw9bVG+m8+DJLDTNfwxkKA+AnZfK+5iAKNRRX
         J5q0Q7y/SkxEzSKkKE62UQuKtdXWbYJzjXlOA71h6e624oGb+HBfo8ULhI9+maKf99
         EphV2Wd9bW0seqet2fmntkxoOgrmm/JVYf0c5a/ZympyYgwsGq7o2TskD0mq2DUmMR
         XhNvCcH458ZIw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] devlink: Fix port_type_set function pointer check
Date:   Mon,  9 Aug 2021 15:03:19 +0300
Message-Id: <97f68683b3b6c7ea8420c64817771cdedfded7ae.1628510543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Fix a typo when checking existence of port_type_set function pointer.

Fixes: 82564f6c706a ("devlink: Simplify devlink port API calls")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index d3b16dd9f64e..b02d54ab59ac 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1274,7 +1274,7 @@ static int devlink_port_type_set(struct devlink_port *devlink_port,
 {
 	int err;
 
-	if (devlink_port->devlink->ops->port_type_set)
+	if (!devlink_port->devlink->ops->port_type_set)
 		return -EOPNOTSUPP;
 
 	if (port_type == devlink_port->type)
-- 
2.31.1

