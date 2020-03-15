Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7E6185EAD
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 18:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgCORRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 13:17:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:56458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728887AbgCORRu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 13:17:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8055CADB5;
        Sun, 15 Mar 2020 17:17:48 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3170CE0C04; Sun, 15 Mar 2020 18:17:48 +0100 (CET)
Message-Id: <1c58a7ea30236aedbd0f87611778878071b0b4a6.1584292182.git.mkubecek@suse.cz>
In-Reply-To: <cover.1584292182.git.mkubecek@suse.cz>
References: <cover.1584292182.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net 2/3] netlink: add nl_set_extack_cookie_u32()
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Sun, 15 Mar 2020 18:17:48 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to existing nl_set_extack_cookie_u64(), add new helper
nl_set_extack_cookie_u32() which sets extack cookie to a u32 value.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/linux/netlink.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 205fa7b1f07a..4090524c3462 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -119,6 +119,15 @@ static inline void nl_set_extack_cookie_u64(struct netlink_ext_ack *extack,
 	extack->cookie_len = sizeof(__cookie);
 }
 
+static inline void nl_set_extack_cookie_u32(struct netlink_ext_ack *extack,
+					    u32 cookie)
+{
+	u32 __cookie = cookie;
+
+	memcpy(extack->cookie, &__cookie, sizeof(__cookie));
+	extack->cookie_len = sizeof(__cookie);
+}
+
 void netlink_kernel_release(struct sock *sk);
 int __netlink_change_ngroups(struct sock *sk, unsigned int groups);
 int netlink_change_ngroups(struct sock *sk, unsigned int groups);
-- 
2.25.1

