Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015DA63ED81
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiLAKU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiLAKUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:20:20 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F83E98956
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:20:16 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 136so1290143pga.1
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 02:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j+iNLgZBHVFYVqAiKpaqYdWWjZFUYRy5zBVAjX1O+nQ=;
        b=YJWv5iOEvqI+beFxfLWL+0HTOZlErkbrpNcTf4vFnDqxK8klrn+BorJpFEMBEdaVLs
         cnCCj3rLdSXDQQpIXtvi5IZ7L4kV0eNf0/7SnUv1LJ4zNJPZhpvV5JO/ZCxYMaXa2eWC
         9h40Nv/9x6dEHPPbDONVxIfvE0i5uvkLJN2wuvPy1QGl6Hfd15fAjY+1t4Xjw91U/SV0
         stIl21nN9reZb88gtoWcLzg7DMyQPFCjx5bplFUAQ3bvD7iw+3a7RswoQ0Qjg2yNtSI1
         xtk4wemqixDdUN9oYzTPthVUSg0LtfIkVFHL9KuLyxDwgnb2AIpkyHAfm+elNiZFtLY0
         6CZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j+iNLgZBHVFYVqAiKpaqYdWWjZFUYRy5zBVAjX1O+nQ=;
        b=2OIk+EL+7JMhdVI3Lp1booZHgICgDQ3DpkhwEJzAEoRSeKvCHI+4tDSsBNnbxM61+T
         mkE7wSy7bo9k08cetUV6ERuOCHS22rN2mKP1JzaYvDzGZXIGxdhxVlTaEzOVvFmWAej9
         e7HrsJRGZIg6fhjdjBZToGL3QFKNKKdAYSOpZl9UpyNrYQxsFdURUlWvgUWE0Mx5d1VP
         x/PSZPkjUlk+AhXJY0hV5lbKZK4VKCxVHzIxB949sqfqczwFBgGGDOnKQHAGVfN3EW7u
         TCQe1tBkAIze5UtWWlHR/6Fuuy/Xu9YvF82EoPypgfSLFunW2X+N9k4IU7GpPzNzuZZJ
         PEPA==
X-Gm-Message-State: ANoB5pmT1oZFMzB4C3xUaCznpS6nqRjJK1JJ8jXh9n6r402y9HbltCNw
        yXw0ampsqO23vwWJMst2XG9CMQ==
X-Google-Smtp-Source: AA0mqf7fksbSZOyCBni3D+9eCcjk09sHMqEqioylnSOV7zMZWndYABL6qD4HKFDypG6UJN8iiAW1zw==
X-Received: by 2002:a05:6a00:324e:b0:575:871f:2e7a with SMTP id bn14-20020a056a00324e00b00575871f2e7amr11661250pfb.35.1669890015643;
        Thu, 01 Dec 2022 02:20:15 -0800 (PST)
Received: from alarm.flets-east.jp ([2400:4050:c360:8200:7b99:f7c3:d084:f1e2])
        by smtp.gmail.com with ESMTPSA id j5-20020a170902690500b001708c4ebbaesm3164914plk.309.2022.12.01.02.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 02:20:15 -0800 (PST)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH net v4] igbvf: Regard vf reset nack as success
Date:   Thu,  1 Dec 2022 19:20:03 +0900
Message-Id: <20221201102003.67861-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vf reset nack actually represents the reset operation itself is
performed but no address is assigned. Therefore, e1000_reset_hw_vf
should fill the "perm_addr" with the zero address and return success on
such an occasion. This prevents its callers in netdev.c from saying PF
still resetting, and instead allows them to correctly report that no
address is assigned.

Fixes: 6ddbc4cf1f4d ("igb: Indicate failure on vf reset for empty mac address")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
V3 -> V4: Removed blank lines between cases
V2 -> V3: Added Fixes: tag

 drivers/net/ethernet/intel/igbvf/vf.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/vf.c b/drivers/net/ethernet/intel/igbvf/vf.c
index b8ba3f94c363..a47a2e3e548c 100644
--- a/drivers/net/ethernet/intel/igbvf/vf.c
+++ b/drivers/net/ethernet/intel/igbvf/vf.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2009 - 2018 Intel Corporation. */
 
+#include <linux/etherdevice.h>
+
 #include "vf.h"
 
 static s32 e1000_check_for_link_vf(struct e1000_hw *hw);
@@ -131,11 +133,16 @@ static s32 e1000_reset_hw_vf(struct e1000_hw *hw)
 		/* set our "perm_addr" based on info provided by PF */
 		ret_val = mbx->ops.read_posted(hw, msgbuf, 3);
 		if (!ret_val) {
-			if (msgbuf[0] == (E1000_VF_RESET |
-					  E1000_VT_MSGTYPE_ACK))
+			switch (msgbuf[0]) {
+			case E1000_VF_RESET | E1000_VT_MSGTYPE_ACK:
 				memcpy(hw->mac.perm_addr, addr, ETH_ALEN);
-			else
+				break;
+			case E1000_VF_RESET | E1000_VT_MSGTYPE_NACK:
+				eth_zero_addr(hw->mac.perm_addr);
+				break;
+			default:
 				ret_val = -E1000_ERR_MAC_INIT;
+			}
 		}
 	}
 
-- 
2.38.1

