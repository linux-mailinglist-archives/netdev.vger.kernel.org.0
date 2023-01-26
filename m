Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041B767C4B9
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjAZHOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbjAZHOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:14:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6E04940D;
        Wed, 25 Jan 2023 23:14:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5387BB81CFE;
        Thu, 26 Jan 2023 07:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBC9C4339C;
        Thu, 26 Jan 2023 07:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717268;
        bh=2buijH5NC03JTe4ruxSgx6ayDJXbPvvqXaW977NwBNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrN3PHd+UbX/mQnRrPrHxU3oxNZUTe7VLsZ1geNM4mbrHxAV6s4TdG5CBZCpA41xV
         jHT4HiWjxyO46LiVhTM5bkbNTRVzLdODPYsOCLdcPWqD+7r/bJefi/K0CqsjtMeINv
         IKAX/+DY2KLvFgf0RizXERcJYFQZ8vs3WAAyTuXMZX17gpUZge42XwJfjfaa5T7VGw
         9gJk9qEj3nZlIZPVBTQssj4w/oI3QuctdRXh2yrYzvYrLPbnSesFS4LBe4Ia88u2xb
         xY9FjHJWgz1e24PfS2NAM5smvyuMFyJ8Jefd3MieusY1Pi1ga7zSqRXfAW3U+7uIXq
         WIKjo9BEOLz1Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, kvalo@kernel.org,
        martin.lau@kernel.org, ast@kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH net-next 01/11] net: add missing includes of linux/net.h
Date:   Wed, 25 Jan 2023 23:14:14 -0800
Message-Id: <20230126071424.1250056-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126071424.1250056-1-kuba@kernel.org>
References: <20230126071424.1250056-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

linux/net.h will soon not be included by linux/skbuff.h.
Fix the cases where source files were depending on the implicit
include.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: kvalo@kernel.org
CC: martin.lau@kernel.org
CC: ast@kernel.org
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/intersil/orinoco/hermes.c | 1 +
 include/linux/igmp.h                           | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intersil/orinoco/hermes.c b/drivers/net/wireless/intersil/orinoco/hermes.c
index 256946552742..4888286727ff 100644
--- a/drivers/net/wireless/intersil/orinoco/hermes.c
+++ b/drivers/net/wireless/intersil/orinoco/hermes.c
@@ -38,6 +38,7 @@
  * under either the MPL or the GPL.
  */
 
+#include <linux/net.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
diff --git a/include/linux/igmp.h b/include/linux/igmp.h
index 78890143f079..b19d3284551f 100644
--- a/include/linux/igmp.h
+++ b/include/linux/igmp.h
@@ -15,6 +15,7 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/refcount.h>
+#include <linux/sockptr.h>
 #include <uapi/linux/igmp.h>
 
 static inline struct igmphdr *igmp_hdr(const struct sk_buff *skb)
-- 
2.39.1

