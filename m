Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF7B285D9B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgJGKyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgJGKyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:54:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03303C0613D2
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 03:54:05 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQ758-000qv0-A7; Wed, 07 Oct 2020 12:54:02 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] ethtool: correct policy for ETHTOOL_MSG_CHANNELS_SET
Date:   Wed,  7 Oct 2020 12:53:51 +0200
Message-Id: <20201007125348.a74389e18168.Ieab7a871e27b9698826e75dc9e825e4ddbc852b1@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007125348.a0b250308599.Ie9b429e276d064f28ce12db01fffa430e5c770e0@changeid>
References: <20201007125348.a0b250308599.Ie9b429e276d064f28ce12db01fffa430e5c770e0@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This accidentally got wired up to the *get* policy instead
of the *set* policy, causing operations to be rejected. Fix
it by wiring up the correct policy instead.

Fixes: 5028588b62cb ("ethtool: wire up set policies to ops")
Reported-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/ethtool/netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 8a85a4e6be9b..50d3c8896f91 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -830,8 +830,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_CHANNELS_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_channels,
-		.policy = ethnl_channels_get_policy,
-		.maxattr = ARRAY_SIZE(ethnl_channels_get_policy) - 1,
+		.policy = ethnl_channels_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_channels_set_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_COALESCE_GET,
-- 
2.26.2

