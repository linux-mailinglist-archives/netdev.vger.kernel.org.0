Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B19E633862
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbiKVJ15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiKVJ1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:27:51 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFC5627F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:27:29 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id q71so13562240pgq.8
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eATo/hld30hJMYbs854XvpQGAeslm1I6YJ3BHDFYFEg=;
        b=Dh3UF3El3dMJ6YHfGqSY2/yW/4eIWI4c2NX7FXI3gZTQg52GpepQx2iYs+axwGyBch
         xiLrUm+XzFNiFGIfuuQRPX9rt6coTdn4F9lkTciXMvemJQXPzHd68W7F/hIphcnaTbBV
         8cByzmD0CZttP5yYv4Rs0IuLYG/6TWS6YFUemU+GT8E0CXUkzN22hbt4eFMS2TinVBRl
         x0SmsG5H6gYOAnieaxxv5MxW4lHVdXfqFXPd2AI4NhLFOiybEtgqwU5eZikBFTVreFz9
         L5njN1gHd6uREwoD6fbog1A8q5qxdd1uYNjAqvPpzZnWJaClkz1cMnLhqB2DWZd8wFyp
         Q9Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eATo/hld30hJMYbs854XvpQGAeslm1I6YJ3BHDFYFEg=;
        b=6Fm1LofsOTwk4pC0FMckacQTnIIrTccPl+qRvCR80SX2oZtiZYFMq+uZM69icRWkrY
         GgE8RgipfLz0+Xw8CKkAvc4YOijZpWJyCeDVYZwqm1Q0eWi4LRW4Gix0G3rgNNy4GTfX
         VRwOqtkgpJoWHTaLrzTyESkg4RqoeDf4kp6h9clqlBMHf6QpUB3bNa04jc6GvMKCemSW
         vZySYr+DT+P2hx0cJYOtQ2s4xvye9oFn8wNe2hMbk7QWrsZtjcPYEEdUczjOlWIihER1
         ZAc60qlfbCD+umN2yLxxRH5RhfDiOe1mP8+FkU+FdehN5WMuWv0oOGiX7JTSkrlsWtH4
         zuqg==
X-Gm-Message-State: ANoB5pmyETnVz+VeitEzG8wMZeYeUF2wgvDGgFjU+MY+9N70KPB2iUVZ
        zsF6Tz4PFpJNPoyDrhnf1Dlfdg==
X-Google-Smtp-Source: AA0mqf5FEiWQeGphury5+1tD79SfHYxjMoofOiV7AmZQVVrt3KAqnKKRF05vDd/tj0redx0XMfIMUw==
X-Received: by 2002:aa7:9293:0:b0:56b:9bf4:c1c4 with SMTP id j19-20020aa79293000000b0056b9bf4c1c4mr14057458pfa.67.1669109249227;
        Tue, 22 Nov 2022 01:27:29 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id g10-20020a170902d1ca00b00178acc7ef16sm9678567plb.253.2022.11.22.01.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 01:27:28 -0800 (PST)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH] igbvf: Regard vf reset nack as success
Date:   Tue, 22 Nov 2022 18:27:07 +0900
Message-Id: <20221122092707.30981-1-akihiko.odaki@daynix.com>
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
performed but no address is not assigned. Therefore, e1000_reset_hw_vf
should fill the "perm_addr" with the zero address and return success on
such an occassion. This prevents its callers in netdev.c from saying PF
still resetting, and instead allows them to correctly report that no
address is assigned.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/ethernet/intel/igbvf/vf.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/vf.c b/drivers/net/ethernet/intel/igbvf/vf.c
index b8ba3f94c363..2691ae2a8002 100644
--- a/drivers/net/ethernet/intel/igbvf/vf.c
+++ b/drivers/net/ethernet/intel/igbvf/vf.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2009 - 2018 Intel Corporation. */
 
+#include <linux/etherdevice.h>
+
 #include "vf.h"
 
 static s32 e1000_check_for_link_vf(struct e1000_hw *hw);
@@ -131,11 +133,18 @@ static s32 e1000_reset_hw_vf(struct e1000_hw *hw)
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
+
+			case E1000_VF_RESET | E1000_VT_MSGTYPE_NACK:
+				eth_zero_addr(hw->mac.perm_addr);
+				break;
+
+			default:
 				ret_val = -E1000_ERR_MAC_INIT;
+			}
 		}
 	}
 
-- 
2.38.1

