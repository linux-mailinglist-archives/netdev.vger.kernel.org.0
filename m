Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA0D249A64
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 12:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgHSK3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 06:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbgHSK3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 06:29:07 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63865C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 03:29:07 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k8LL7-006mIZ-IW; Wed, 19 Aug 2020 12:29:05 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 1/2] libnetlink: add rtattr_for_each_nested() iteration macro
Date:   Wed, 19 Aug 2020 12:29:02 +0200
Message-Id: <20200819102903.21740-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is useful for iterating elements in a nested attribute,
if they're not parsed with a strict length limit or such.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/libnetlink.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index e27516f7648f..0d4a9f29afbd 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -284,4 +284,9 @@ int rtnl_from_file(FILE *, rtnl_listen_filter_t handler,
  * messages from dump file */
 #define NLMSG_TSTAMP	15
 
+#define rtattr_for_each_nested(attr, nest) \
+	for ((attr) = (void *)RTA_DATA(nest); \
+	     RTA_OK(attr, RTA_PAYLOAD(nest) - ((char *)(attr) - (char *)RTA_DATA((nest)))); \
+	     (attr) = RTA_TAIL((attr)))
+
 #endif /* __LIBNETLINK_H__ */
-- 
2.26.2

