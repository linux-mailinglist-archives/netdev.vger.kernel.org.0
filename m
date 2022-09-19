Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF305BC457
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 10:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiISIbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 04:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiISIbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 04:31:51 -0400
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 519DB2127F
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 01:31:50 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id B968C60077;
        Mon, 19 Sep 2022 10:31:48 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1oaCBw-0005zv-Lo; Mon, 19 Sep 2022 10:31:48 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2-next] link: display 'allmulti' counter
Date:   Mon, 19 Sep 2022 10:31:36 +0200
Message-Id: <20220919083136.23043-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This counter is based on the same principle that the 'promiscuity' counter:
the flag ALLMULTI is displayed only when it is explicitly requested by the
userland. This counter enables to know if 'allmulti' is configured on an
interface.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/uapi/linux/if_link.h | 1 +
 ip/ipaddress.c               | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e0fbbfeeb3a1..a59b4cd03e93 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -370,6 +370,7 @@ enum {
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_MAX_SIZE,
 	IFLA_TSO_MAX_SEGS,
+	IFLA_ALLMULTI,
 
 	__IFLA_MAX
 };
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 45955e1c065e..1f034f7db520 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1205,6 +1205,12 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 				   " promiscuity %u ",
 				   rta_getattr_u32(tb[IFLA_PROMISCUITY]));
 
+		if (tb[IFLA_ALLMULTI])
+			print_uint(PRINT_ANY,
+				   "allmulti",
+				   " allmulti %u ",
+				   rta_getattr_u32(tb[IFLA_ALLMULTI]));
+
 		if (tb[IFLA_MIN_MTU])
 			print_uint(PRINT_ANY,
 				   "min_mtu", "minmtu %u ",
-- 
2.33.0

