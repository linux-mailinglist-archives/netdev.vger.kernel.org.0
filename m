Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F8D1687D9
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 20:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgBUTxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 14:53:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbgBUTxN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 14:53:13 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBD2A20722;
        Fri, 21 Feb 2020 19:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582314793;
        bh=U6JmjUuAlTNd2GybDKXMr207vVx6gtGOnqZPR+UVbyI=;
        h=From:To:Cc:Subject:Date:From;
        b=zsV/Fv6IuWWv+gUnS4y5SoLmSxvxY1+gpTxBLpMAkOGySxKQ/KmZZQRg5NH/8CFgL
         Pleb0kboqlJLxIn67D6YtsKTMijW45AJObobhTtWoAb5jODvwI9ufdXyy+7uq7TrSg
         oAwHktPdB7zkIvgNvnH8fDcp+D2+8P1kfV/7soAw=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH] tun: Remove unnecessary BUG_ON check in tun_net_xmit
Date:   Fri, 21 Feb 2020 12:53:09 -0700
Message-Id: <20200221195309.72955-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The BUG_ON for NULL tfile is now redundant due to a recently
added null check after the rcu_dereference. Remove the BUG_ON.

Cc: Jason Wang <jasowang@redhat.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 drivers/net/tun.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 650c937ed56b..79f248cb282d 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1078,8 +1078,6 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	tun_debug(KERN_INFO, tun, "tun_net_xmit %d\n", skb->len);
 
-	BUG_ON(!tfile);
-
 	/* Drop if the filter does not like it.
 	 * This is a noop if the filter is disabled.
 	 * Filter can be enabled only for the TAP devices. */
-- 
2.17.1

