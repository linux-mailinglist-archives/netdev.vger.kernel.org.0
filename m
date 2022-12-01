Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AB863ECBA
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiLAJoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiLAJoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:44:11 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D618C681
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 01:44:03 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 62so1175945pgb.13
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 01:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0mg5gF5Bc8jYhcH7zz7tLGXFeH5/FEWq/MS0hfM5LXE=;
        b=vFi/RDoTTAN0UIF3zWyyp8VvrLHeJL8VWsQ2cYgvqzCiICTpkJ95gSt3suEHnIkeDr
         SL8QRzHbt6jVBgrMnuD86/aQYEYco5/+vnLI0bHb9CIBlTh5dEs09CcsC/IeNa8qM9c6
         dQK8dqz2QfEk6YA594WR/BrVGd4ZBZ0zvQWv6Dh8cQw0W7HiU0XHOLHzHaR9YTkTygBE
         YAZQZig3OjPRaDkbC/6nQYrcI0chnV3Cn4jKwLkHW18NBOs9UMpgnMAIw0FTu/4UQ9du
         WAr6GIxNuz1U93QoA198DWneDGlWpEtqS4Aj5cPRpKFliz4Ac2brcy1BevP4Nqssy4nD
         ZKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0mg5gF5Bc8jYhcH7zz7tLGXFeH5/FEWq/MS0hfM5LXE=;
        b=XWyWSAG9eZ2hu1vWhxb9BPulQV0Ccym2RUZKrTQR0tPAzEWOtZdCMCGDr1SVe0Aqju
         qcb9m92Ycw9poSgOXmApfGgftP99cT2iglpvv5PdZBGOfD78pmIyqQI+RjuDaWGBhjFw
         G2bp5zgNG5G61VJ2+zdgDENzUFC3OxkW21rIXCNGNUXtB1U0/MxR/IPYqAA9TPvFjHEJ
         ZzfwhGvU7NETSzAvjrp879mg5MtHNqIHpdbNCKgcPDGWAZ0gkP4E9Jsw6oHIGjFNaQZZ
         UzCEhWhuk1AEq21vrJEcoEJMqt+3+X20bGymp2B7A0fVULIU0MoCJP2Tn7ooaFpPhvwm
         p5sw==
X-Gm-Message-State: ANoB5pkWm/xjq19TYB7kyVmssQvQyr99XWwq8n5QXfruwAmD8gk8aJ7t
        FiPzXauFs0LhV3OwogYFtciJAprfUXsOKCVC
X-Google-Smtp-Source: AA0mqf6slQpb9xPr0WH3wGhYCbp2Gfc6+Cpbn3pDDlI0O/ecnNX2Wh2sasXFp8o9w0V136i7Qu9H9w==
X-Received: by 2002:aa7:81d8:0:b0:561:c694:80b with SMTP id c24-20020aa781d8000000b00561c694080bmr46928664pfn.47.1669887842856;
        Thu, 01 Dec 2022 01:44:02 -0800 (PST)
Received: from alarm.flets-east.jp ([2400:4050:c360:8200:7b99:f7c3:d084:f1e2])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b0018996404dd5sm3152297plg.109.2022.12.01.01.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 01:44:02 -0800 (PST)
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
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH net v3] igbvf: Regard vf reset nack as success
Date:   Thu,  1 Dec 2022 18:43:35 +0900
Message-Id: <20221201094335.60940-1-akihiko.odaki@daynix.com>
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
V2 -> V3: Added Fixes: tag

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

