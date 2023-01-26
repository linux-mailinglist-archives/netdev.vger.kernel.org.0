Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC5B67C4BA
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbjAZHOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbjAZHOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:14:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3878D46702
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:14:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADEE6616E9
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0BEC433A0;
        Thu, 26 Jan 2023 07:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717271;
        bh=QzOtkXAX7u7SyLqqlcoRzSWM4JdXl1CkpsDk8nMngU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqUVPmMjG8LakndUamXchCD73c9c8dk84EvUEPD6dz5xpU/38vvx0tnDil9t6PTdB
         2OezpsP9cwesL1TFeRIltAtE15n8XNlq0k/o+MlnsQtJb06b60g7vXfqAHcJMWYWV+
         8wv9UhqaJsE4a6tAscWoq1UfPFSR56vp6QXC25mePH4KXoP5DUw+hqv5zPhmzT1IZu
         TNQ5OPNbE85Q+QdqzuknD8XWxWe8fjTfsDrT4+iUe+UgvQZ0N75xEwhyamrq7Oaz6K
         3VVQbgora+4Utzggl2qSgHqrgXvY2TTz8yikUPYR/mHxv5FmY7j7bZxgKTebh5gnxP
         nbPt9/a+ADPUw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, imagedong@tencent.com
Subject: [PATCH net-next 06/11] net: skbuff: drop the linux/sched/clock.h include
Date:   Wed, 25 Jan 2023 23:14:19 -0800
Message-Id: <20230126071424.1250056-7-kuba@kernel.org>
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

It used to be necessary for skb_mstamp_* static inlines,
but those are gone since we moved to usec timestamps in
TCP, in 2017.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: imagedong@tencent.com
---
 include/linux/skbuff.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7eeb06f9ca1f..aa920591ba37 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -29,7 +29,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/netdev_features.h>
 #include <linux/sched.h>
-#include <linux/sched/clock.h>
 #include <net/flow_dissector.h>
 #include <linux/splice.h>
 #include <linux/in6.h>
-- 
2.39.1

