Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F29B6A1C62
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjBXMqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBXMqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:46:00 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DAD51920;
        Fri, 24 Feb 2023 04:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=SvGY+xsurTZFQAmamVEuOGjTjEUZA1Dfz6HddeW/2JI=;
        t=1677242759; x=1678452359; b=n+3Z7kHJ6qfVbWu//Ibqqs2CfR/AMdn5PG6cPkdLIjNFzhP
        YTUXXsY20kuCiXsu9EdRh+kgSCHnHV4W5Q8l2oFE0SU7MU3cBzk4/CnvOIRH69XvRViE/rDCv/4d4
        vV7R6cO8vvKWV07UDiOmDX0dIVGxxl5k+Q+zFK0reqfbiZU7vkf5sDZXW+LHcxLgQwXG9yeZfGbTH
        0BE7Xsgx3zLw5/qjB8Vz+r4lvp9OwDMr8uBgWzR6QL+a0rQky09ufDlgSb7jBZtV16bV43EwpLQYS
        IHoFhVp0FsEpMkS5kCIHscGQpG4IkXIN7p1sc2TQnCXMalFc8oScD0tfJmQd0EZA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pVXSX-004CAe-2k;
        Fri, 24 Feb 2023 13:45:57 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 2/2] net: netlink: constify full range pointers
Date:   Fri, 24 Feb 2023 13:45:53 +0100
Message-Id: <20230224134441.10dbceb0bdf1.Iaac3edac4a32e0c69b6c5de0e8e986f61a619cab@changeid>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230224124553.94730-1-johannes@sipsolutions.net>
References: <20230224124553.94730-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

These pointers (and with them variables they point to)
really can be const, do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h     | 4 ++--
 net/ipv6/ioam6_iptunnel.c | 2 +-
 net/wireless/nl80211.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 52dedc8bfedd..6a4d6aae76bd 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -351,8 +351,8 @@ struct nla_policy {
 		const u32 mask;
 		const char *reject_message;
 		const struct nla_policy *nested_policy;
-		struct netlink_range_validation *range;
-		struct netlink_range_validation_signed *range_signed;
+		const struct netlink_range_validation *range;
+		const struct netlink_range_validation_signed *range_signed;
 		struct {
 			s16 min, max;
 		};
diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index 790a40e2497d..dd464d915ab8 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -46,7 +46,7 @@ struct ioam6_lwt {
 	struct ioam6_lwt_encap	tuninfo;
 };
 
-static struct netlink_range_validation freq_range = {
+static const struct netlink_range_validation freq_range = {
 	.min = IOAM6_IPTUNNEL_FREQ_MIN,
 	.max = IOAM6_IPTUNNEL_FREQ_MAX,
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fbea0e786b21..ae35b23fac73 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -462,7 +462,7 @@ nl80211_sta_wme_policy[NL80211_STA_WME_MAX + 1] = {
 	[NL80211_STA_WME_MAX_SP] = { .type = NLA_U8 },
 };
 
-static struct netlink_range_validation nl80211_punct_bitmap_range = {
+static const struct netlink_range_validation nl80211_punct_bitmap_range = {
 	.min = 0,
 	.max = 0xffff,
 };
-- 
2.39.2

