Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D17035CE33
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244541AbhDLQmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245634AbhDLQhz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:37:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C734E60200;
        Mon, 12 Apr 2021 16:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244876;
        bh=vxqCjmWffc+tKLgEkTQKo7R57buqEOzPlYgk1BYITqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLfssJe7Gee5wrceV21W6nKHjx7Lj+5DjenDTnos7otfIdsarMQAemaz5Ukj0oQLO
         /bZERxAQ5zUiyv9gJhp98lPQOx7+fE1l5JAacV5jN2sMoBLi7FuCpW6Xs5IfCu9pvh
         /4PA4i/wufX+iyl7jTuWJMrxWXW6UuwzymIJtGU46358QYfH4tbi/YO5cGDUBYeiTs
         a5olmBJq+G6/9FRaN+MxsxUTnDyCxPaMqSCYZ5kZuwpuAbsqhNWPkMMPjQP0XZzq8G
         RDyvaHLcHbMg0HXCMxpWWpy9FW3RsLIxhCZphC3o6JNgfTOecGDy/88bYpIIZEJRug
         pIxqXV35ZHAhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 15/23] net: ieee802154: stop dump llsec seclevels for monitors
Date:   Mon, 12 Apr 2021 12:27:28 -0400
Message-Id: <20210412162736.316026-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162736.316026-1-sashal@kernel.org>
References: <20210412162736.316026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 4c9b4f55ad1f5a4b6206ac4ea58f273126d21925 ]

This patch stops dumping llsec seclevels for monitors which we don't
support yet. Otherwise we will access llsec mib which isn't initialized
for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-13-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 244fbbf3b58e..5e6e8c80cc41 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2004,6 +2004,11 @@ nl802154_dump_llsec_seclevel(struct sk_buff *skb, struct netlink_callback *cb)
 	if (err)
 		return err;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR) {
+		err = skb->len;
+		goto out_err;
+	}
+
 	if (!wpan_dev->netdev) {
 		err = -EINVAL;
 		goto out_err;
-- 
2.30.2

