Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5E233E25F
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhCPXvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhCPXvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5074764F90;
        Tue, 16 Mar 2021 23:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938676;
        bh=3OeIsMijVJX6ZKrSFRa3+DVx8aleWeltamhbdgf2vW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ATwzAIQJhj60dOixnXuGdAS23tVP5Z3BSeh1HQwcEe9qgZOxLPWOmmIsTLD1jgBzp
         8SkmbEsSy3sW3+aqwft9FYId73n5B7aSmMcWn7gs/7wziqqjIEFVDNdV6MxOK0KA0h
         RtovyL4D1oihlQCnmyWQb8wdKJ4nNVxX/94KSDYwS9orIOxSDPi3GCAkWAyWZ7wAtZ
         me+8incHsvlHIHOc6sfwD5m01Osvjd5a8OmVjDDP37vQFcX3S1ehySh/q/v0WfWnuF
         qwumh0vLlNr3O7/AnqFEKBknaAMppoIDCBsnu6u5da1Q0VSzVObh6fCjy5cF/WogK3
         /fbeOyjp2Utqw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net: Change dev parameter to const in netif_device_present()
Date:   Tue, 16 Mar 2021 16:50:58 -0700
Message-Id: <20210316235112.72626-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Not all ndos check the present bit before calling the ndo and the driver
may want to check it. Sometimes the dev parameter passed as const so we
pass it to netif_device_present() as const.
Since netif_device_present() doesn't modify dev parameter anyway, declare
it as const.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b379d08a12ed..97254c089eb2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4175,7 +4175,7 @@ static inline bool netif_oper_up(const struct net_device *dev)
  *
  * Check if device has not been removed from system.
  */
-static inline bool netif_device_present(struct net_device *dev)
+static inline bool netif_device_present(const struct net_device *dev)
 {
 	return test_bit(__LINK_STATE_PRESENT, &dev->state);
 }
-- 
2.30.2

