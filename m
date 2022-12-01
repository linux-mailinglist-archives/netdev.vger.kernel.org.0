Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B231D63ECFC
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiLAJ44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiLAJ4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:56:50 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E922B89AD6
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 01:56:48 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 130so1372862pfu.8
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 01:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gEi5WooIzymVJWTmisumqALsHWCs8mFJrm8lGYU0gwg=;
        b=lhsxbXMptzbThlto8/s9mq8gvOTeQm71kwyFost1kp4jJfu3FfEwyfW7FlEez3IAT0
         2fpaIR9O13gitkUK3SPHjae1AzvyxVIAVkabSih35tKaIDAGUMUm0wzJ6dJshVtcmLGN
         UpsJ3vovMBypF8U1dbftpieUXFgFcq8RJOA9LmWv/WXOeluYInOfunSYysa7LLP0wzBf
         GdmgMnyDkgtaTPv79HlDRjeNoUy4sNAp36s12S0c68a5NbhupNNDVJpM/TePN/8y1L0y
         i8ASwM+6bdRVyao00W2CiX68Ztw1DWhQ4sba2Ps1x+4kwu7L3JDWCJH/65H3Cyf8DYi7
         A4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gEi5WooIzymVJWTmisumqALsHWCs8mFJrm8lGYU0gwg=;
        b=xT7NfkoXWKTfS/JPU7FK1HPe/NsF3yhjddudDFB+X1KX9lYOzyFI2RrkZy99azZwUf
         0pRAR1/IK1sF0IV62afZ3HgJVQbWr+et8zMiVwArrOELtsE2cWoNwNDwJ09jSgje8m4C
         yhBMxJT08DafkHx3wElMySYnxz4dUfrpl/iGiUj0t9ehzGvsikQRyv/7sG0pUXf1CLR5
         8esOhOHiNN1sZrEdNSrKfgmoND9cq+DWez75bPHa9X4SDn/w8wse0E9Chc/4dvmQjTLc
         jcqQSLpd5dq7DZWlJ7Jjj1Qz/JQYtXNyvioRyJZKkxLMtkb2ACPEMs4AWQhycr/l+Lum
         el5A==
X-Gm-Message-State: ANoB5plnIbxkldNcjCIEngGrPJNAdUiTl7AD4wJdw/xijwKiZNc1SDyR
        eUOjNmNin+lK1wJp16t1LzaWng==
X-Google-Smtp-Source: AA0mqf6/kB86fKTvI6Alt6QeX/Re8QGsHujO7z6ZxIRp/ruxn0H9ZYp/9b2o18P9qS5nzK12O0Sr7Q==
X-Received: by 2002:a62:5844:0:b0:563:1231:1da with SMTP id m65-20020a625844000000b00563123101damr50373568pfb.5.1669888608459;
        Thu, 01 Dec 2022 01:56:48 -0800 (PST)
Received: from alarm.flets-east.jp ([2400:4050:c360:8200:7b99:f7c3:d084:f1e2])
        by smtp.gmail.com with ESMTPSA id j3-20020a170902da8300b001714e7608fdsm3146244plx.256.2022.12.01.01.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 01:56:48 -0800 (PST)
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
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH net v3 RESEND] igbvf: Regard vf reset nack as success
Date:   Thu,  1 Dec 2022 18:56:38 +0900
Message-Id: <20221201095638.63652-1-akihiko.odaki@daynix.com>
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
Resending as I forgot to CC Tony Nguyen. Sorry for messing your mailbox.
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

