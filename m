Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906FC58B48B
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 10:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiHFIYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 04:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiHFIYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 04:24:40 -0400
X-Greylist: delayed 303 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 06 Aug 2022 01:24:39 PDT
Received: from mail1.systemli.org (mail1.systemli.org [93.190.126.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6030714030
        for <netdev@vger.kernel.org>; Sat,  6 Aug 2022 01:24:39 -0700 (PDT)
From:   Nick Hainke <vincent@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1659774277;
        bh=EAriawOA4lz7ohIRct2NpDLexxoJzVkbnojxJWSFc3U=;
        h=From:To:Cc:Subject:Date:From;
        b=lIXeNghSZIuJ4xwLqAdWFLJb0fWWbQ0zzfYLm9YP3Zua89G+a5ns3ZcC1e1FfAtW1
         /GxbtffosijkTwVQlrD6J63s3US5i8FlBjNI+iSbN/py2lEQO6xlkVJoAHDhJcIliN
         YHr+sjB22cuQcwSPMmmiBS+VWVp75YQ03g9KO5dR9LJ5t9ZvS3b9ILp8xpgWkjhPDP
         IBDy4wtL17sh9M82Qi9jr4KwUXutBjIaPcIEUYVmAFwYlnveW4DAl+/Hg47fJ8SE0e
         lEe243Mly7cNBuVWCY5q3flz5Y/5Q9qrtQPmCzUpJjQIg0Yhg0ggKPrLt3Vjps8NrO
         hybMVNCvM45rg==
To:     netdev@vger.kernel.org
Cc:     Nick Hainke <vincent@systemli.org>
Subject: [PATCH iproute2] ipstats: Define MIN function to fix undefined references
Date:   Sat,  6 Aug 2022 10:24:06 +0200
Message-Id: <20220806082406.216286-1-vincent@systemli.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes errors in the form of:
 in function `ipstats_show_64':
 <artificial>:(.text+0x4e30): undefined reference to `MIN'

Signed-off-by: Nick Hainke <vincent@systemli.org>
---
 ip/ipstats.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/ip/ipstats.c b/ip/ipstats.c
index 5cdd15ae..2f500fc8 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -6,6 +6,10 @@
 #include "utils.h"
 #include "ip_common.h"
 
+#ifndef MIN
+#define MIN(a, b) ((a) < (b) ? (a) : (b))
+#endif
+
 struct ipstats_stat_dump_filters {
 	/* mask[0] filters outer attributes. Then individual nests have their
 	 * filtering mask at the index of the nested attribute.
-- 
2.37.1

