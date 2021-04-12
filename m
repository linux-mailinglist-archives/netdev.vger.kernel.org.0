Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBB035CB48
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243626AbhDLQYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243498AbhDLQXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E75F56135B;
        Mon, 12 Apr 2021 16:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244611;
        bh=TM2eNXwdM8/2FBuHPPvrhSxBRj3u2wfaPPANwP0r8Hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWoStL+/+uwI/lu0DDVCwBIhEwuLzidybO+ADhuKiXoOLClSNZJkNj1XYrqT5WK0E
         85AMn6BRh5cZN/k3FynqHa+7H5EiKeJz+adyFTSP96bzwe5HmCrVJJOeHNCKMxxIo+
         JdftktDrR97S5JIA+fpvsdtEVj3e3+SNEU/hi7Pg1Jb+1DBPTYgxd93odWh2QvpF/C
         igV06h0GCC8VoOi2rl+9pwsKGxPre3kT/FlrSnAMLn9xaytI+HsYJuHhsk3RrH75eX
         lMJDlAWAEF2kkvutqWxNhAnc7d36H6isCIXHyh++2PC2uzqFdDzZSUI2hp7KUnrJYa
         s7FjRTdD61F/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+8b6719da8a04beeafcc3@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 28/51] net: ieee802154: forbid monitor for set llsec params
Date:   Mon, 12 Apr 2021 12:22:33 -0400
Message-Id: <20210412162256.313524-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 88c17855ac4291fb462e13a86b7516773b6c932e ]

This patch forbids to set llsec params for monitor interfaces which we
don't support yet.

Reported-by: syzbot+8b6719da8a04beeafcc3@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-3-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index e9e4652cd592..dd43aa03200e 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1384,6 +1384,9 @@ static int nl802154_set_llsec_params(struct sk_buff *skb,
 	u32 changed = 0;
 	int ret;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (info->attrs[NL802154_ATTR_SEC_ENABLED]) {
 		u8 enabled;
 
-- 
2.30.2

