Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D1A2506E8
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgHXRvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbgHXRvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 13:51:23 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA907C061573;
        Mon, 24 Aug 2020 10:51:22 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kAGco-00A1ue-Dy; Mon, 24 Aug 2020 19:51:18 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/3] libnetlink: add rtattr_for_each_nested() iteration macro
Date:   Mon, 24 Aug 2020 19:51:06 +0200
Message-Id: <20200824175108.53101-1-johannes@sipsolutions.net>
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

