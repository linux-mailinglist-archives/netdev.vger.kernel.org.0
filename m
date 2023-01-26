Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5C267C4C1
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbjAZHOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbjAZHOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:14:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420C1646B7
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:14:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5CB4B81D08
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A38C433A0;
        Thu, 26 Jan 2023 07:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717273;
        bh=AVd+2IBKsYoE5RXATxlm0P7651K4S1aoey3mf600ogE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IeRtRICFQII9CSHRmqwMKJIINLwJN4CKenJKB8qjYgEaBl2BZutDY4v9UAA5XUNEh
         V+Xf8FUcoL5YMw/2uB0Kv7WF9L3Hj3z86ct8n56+Lyfz/bhkkacGVLjvwxKk3EaR32
         vqSdQc57PqqApl9Mb4EGffawOZptti9UjNf4EJBzjVI8mWerb+tWcvcnhwjz3I0Ecl
         5tj1d3IBDGQ88DSM4d0mKzMvarTKT+7ov6vstx5NFBjoqh9U9k494J7PxtLydgwT0T
         /G8q0ihhE2tDyk1dwQTQjCVf4ulKu4n+1s/Ny93JXo7tLOjxHuwKd5WSTJvQUkDl+w
         TSCdr3CAxjELA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/11] net: remove unnecessary includes from net/flow.h
Date:   Wed, 25 Jan 2023 23:14:24 -0800
Message-Id: <20230126071424.1250056-12-kuba@kernel.org>
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

This file is included by a lot of other commonly included
headers, it doesn't need socket.h or flow_dissector.h.

This reduces the size of this file after pre-processing
from 28165 to 4663.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
---
 include/net/flow.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/flow.h b/include/net/flow.h
index 2f0da4f0318b..bb8651a6eaa7 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -8,12 +8,13 @@
 #ifndef _NET_FLOW_H
 #define _NET_FLOW_H
 
-#include <linux/socket.h>
 #include <linux/in6.h>
 #include <linux/atomic.h>
-#include <net/flow_dissector.h>
+#include <linux/container_of.h>
 #include <linux/uidgid.h>
 
+struct flow_keys;
+
 /*
  * ifindex generation is per-net namespace, and loopback is
  * always the 1st device in ns (see net_dev_init), thus any
-- 
2.39.1

