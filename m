Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A7767DEAD
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 08:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbjA0HpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 02:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbjA0HpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 02:45:18 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3066239282
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 23:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=vD5GDesKkOAVOZz7ndcWLKnkKoZ3quMECf3cb4xfhuk=; t=1674805517; x=1676015117; 
        b=BHtWtm63ApMoN+y0sZCSAktSuJEXneckIMeZNjlF4HI4p/4JxzDj1O4ZRAOFNsdm5cMFpv7pbeU
        LmZxi1N9PMwx3odgGvpx9nNV0gO4v0vdJwMFZwGJaQi339s5hqBMFWcIG/xb4F89CU80/xONdkXuj
        9dS83PRXDMfDrIXeGPN073m/7zFOy0ZiHLcha+JfsHU7Ck+wdcWkDyPGtIM05KPvDPDayohtOy18J
        KcXD1+kEcWJTvdlnht/PP+ec+J33VZiC1RlT+q4C56+NtnKQOlNt8tuG4CdnlEwTi7wVl+6eQoXdn
        ArMzavs+uQnuuWtkMeofujynwwYGPN0fU4mw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pLJQ8-00DS7N-1N;
        Fri, 27 Jan 2023 08:45:12 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH net-next] net: netlink: recommend policy range validation
Date:   Fri, 27 Jan 2023 08:45:06 +0100
Message-Id: <20230127084506.09f280619d64.I5dece85f06efa8ab0f474ca77df9e26d3553d4ab@changeid>
X-Mailer: git-send-email 2.39.1
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

For large ranges (outside of s16) the documentation currently
recommends open-coding the validation, but it's better to use
the NLA_POLICY_FULL_RANGE() or NLA_POLICY_FULL_RANGE_SIGNED()
policy validation instead; recommend that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 6e1e670e06bc..b12cd957abb4 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -276,7 +276,8 @@ enum nla_policy_validation {
  *                         Note that in the interest of code simplicity and
  *                         struct size both limits are s16, so you cannot
  *                         enforce a range that doesn't fall within the range
- *                         of s16 - do that as usual in the code instead.
+ *                         of s16 - do that using the NLA_POLICY_FULL_RANGE()
+ *                         or NLA_POLICY_FULL_RANGE_SIGNED() macros instead.
  *                         Use the NLA_POLICY_MIN(), NLA_POLICY_MAX() and
  *                         NLA_POLICY_RANGE() macros.
  *    NLA_U8,
-- 
2.39.1

