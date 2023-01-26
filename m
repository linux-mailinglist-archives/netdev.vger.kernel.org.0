Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3645167C4BB
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbjAZHOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbjAZHOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:14:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB8C46D42
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:14:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 293A161758
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C406C433D2;
        Thu, 26 Jan 2023 07:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717271;
        bh=EXy1wv8MiWPKKsraf5oQzFJNQLVbZoftl6mw8S2G43M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivBXU9N4rv2qCj2vO6xSxJfQdgsExVlvtWQak5GxqXnUnjC5pRFuNGlk96g68DdFn
         0LyGM0AKxOkJIuUOBylgWN/ZyXoMReM/vSFlfOgriMBj3RQm/J37dzvkxtqoCJulyo
         xeIS/MJfHyE6xi56F8HHjgAxijut67QQ2RKMeV02BQ2Xj6T5dSwjPaT/Nf/euEjllR
         sfrmfuHRoXngwBCdLtsEKHPMMedp87JORVfaK1P+5DSi2/46Y6bw2A3umWl8fhpvRY
         3mjHWdwW4gscHZV3flsRHCh0dBcl56ejjzcq/gYq+Lo51WLr9UWQES77KNR7Lg2Hlc
         ZhGfZMu/PT+7g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, imagedong@tencent.com
Subject: [PATCH net-next 07/11] net: skbuff: drop the linux/sched.h include
Date:   Wed, 25 Jan 2023 23:14:20 -0800
Message-Id: <20230126071424.1250056-8-kuba@kernel.org>
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

linux/sched.h was added for skb_mstamp_* (all the way back
before linux/sched.h got split and linux/sched/clock.h created).
We don't need it in skbuff.h any more.

Sadly this change is currently a noop because linux/dma-mapping.h
and net/page_pool.h pull in half of the universe.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: imagedong@tencent.com
---
 include/linux/skbuff.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index aa920591ba37..a1978adc5644 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -28,7 +28,6 @@
 #include <linux/hrtimer.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdev_features.h>
-#include <linux/sched.h>
 #include <net/flow_dissector.h>
 #include <linux/splice.h>
 #include <linux/in6.h>
-- 
2.39.1

