Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3A235CD04
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243454AbhDLQcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245110AbhDLQ3h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:29:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20B2A61373;
        Mon, 12 Apr 2021 16:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244738;
        bh=qENRe/7gEB3dC/PjDSOfkzKH2jNlWqwjXiuY2JoIrWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVubaH/8OgVPkwa4UBffqVM9fU6EfJAi9TsxHFrwvvpSA9l2NAGLva+gppDiBpibs
         1aeG2qTkutvTDUS0cSD5mSxiCdXI5Ud3wgiNJWnpYNlJSBybIb5dudUDQivyEmCIcd
         3kVg6CTTc8yYcLlRPOXq+8ifd2YDNYesBm29wCHcyLhM7SF/jxaQ2bJGOmG19NfZuy
         IP13iqwpG6FflDRT0kfv85/LwPwOve8IlVkeRWOKnkbqNvM6h2XMkSYHKxVdYrdpd3
         XP4vK8IqjCU46pwlvB+k7cltGlZ1TY6Rhiz/pGUOWzUn8ABU14StF73n248xOkS5Md
         9ecouEWQGbknQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 29/39] net: ieee802154: stop dump llsec seclevels for monitors
Date:   Mon, 12 Apr 2021 12:24:51 -0400
Message-Id: <20210412162502.314854-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162502.314854-1-sashal@kernel.org>
References: <20210412162502.314854-1-sashal@kernel.org>
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
index 39740c1fbebf..7c013d45d690 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2042,6 +2042,11 @@ nl802154_dump_llsec_seclevel(struct sk_buff *skb, struct netlink_callback *cb)
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

