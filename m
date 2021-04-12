Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9218435CDF4
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245102AbhDLQlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343988AbhDLQga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:36:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC199613E9;
        Mon, 12 Apr 2021 16:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244844;
        bh=WUnuG80lqhLMKiJH1dvqTgCL3bD0jvB2DDa1wtZQdn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozMuYV36oGzHGj8kDl6B10y1BMyTZWam+LZDjnme7CuMNh+Sit+CkvElxoxy2jPoO
         Z9M/TAI8U2M/mLPmxMyxfm7CVdc4cdMFJVFNjp92rB6z2ge0dJdN3CdxbFj6n2z2Qo
         r/+m2kJ3KK3w8FhoiiQcV2gPncjseCu7Fr+ee11mBlEz67HUPHsNuz4BUJjFPVH7d2
         Bu30VBxHtTi58MsLJtiafxyAuaArZ6UixE8NQjIsZ8W1j6q42zx7fKuVcqiaTlXBY6
         1Q8M6IRMhGYSL/WRtEWUCAirNWjJNJa1ljUt+Qb0FjV2EW3+NUh6vBddHLdeBp6x+S
         GAIcPThqRdBnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 15/23] net: ieee802154: stop dump llsec seclevels for monitors
Date:   Mon, 12 Apr 2021 12:26:56 -0400
Message-Id: <20210412162704.315783-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162704.315783-1-sashal@kernel.org>
References: <20210412162704.315783-1-sashal@kernel.org>
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
index d71dfe03b89c..a54ca9ba9107 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2054,6 +2054,11 @@ nl802154_dump_llsec_seclevel(struct sk_buff *skb, struct netlink_callback *cb)
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

