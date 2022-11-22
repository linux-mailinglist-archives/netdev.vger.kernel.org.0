Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48327634025
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 16:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiKVP1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 10:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbiKVP1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 10:27:01 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAC160689
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 07:27:00 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id q71so14340229pgq.8
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 07:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3eN8PG1tu0zv6ECYGZ0bUFaylUuOM6J9ZGH6Fn6kJHo=;
        b=MF2ry8jCjEfJSczD2TlSQRhxgxw/769GkaMOON9oAkxuEIN97YK7PZjef+RkvUqmn6
         c7AjFerXB1PJT2u2UzDPulK7aXgB17t38IkHEMHHKIogmM4cbG1WwJK6iglP6/5mXOrt
         JmUu/ADf6amE5NTKz6Npi0hz37SGswSnxd+WcFtY0rB4YMUuwQ2w+DwouTzl4kNxpGZr
         CrgSBr2d6j1OSLNtjFltNveJZwLExs/unNW9lRX31lK/abl95eV/kH0TDAvbWCtkhje9
         EkbTVXMgxMLewSuaN4hKU4P4MDuGb074N7xhcU37E00p2MKSPiBCSK+7zoaWT6ce5axZ
         o2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3eN8PG1tu0zv6ECYGZ0bUFaylUuOM6J9ZGH6Fn6kJHo=;
        b=ESKuGKXJYV5DphKEFjI1RSwoPc8hWginziolnYyg3Pm46THhNlfpfOcSENx8NZPDjQ
         KNp7MnEiqH815GRN9gLPK8k1VKJVlwVgOEfax6lit4Yo9B/p4nLBMtRG3tzza9rVamZC
         dRzx+XJ8NKaNxmc8iwSSApIFgYvi/glsxUQos1B4HS9k+cwipOgiOBy1Py92qzSlNwHU
         L/LEtUKq9a83rH8luuf8anSegzzFFR/HJD3E6/HUKf7+ZnSWbBkK1j2Lprz4BYVNlYj9
         8x6XJxmCEwpo64CVyuvWy1plbZSRXmB7LY1WyL7G7Fnbjs6DYYgYy3DI5iUAJ08AzhcH
         nciw==
X-Gm-Message-State: ANoB5pmbdKTOV0JDriEG1HYA00bJbkehmRb+KRgXEUXlxevaYWSME+Nv
        R+dTVsop5cS3FcJ3L4Fc4Q83ip3bHABnkw==
X-Google-Smtp-Source: AA0mqf62k0bqINVN7BK4sgHzvRy7LZL/c5HZpP1IiynzWyp5FdyrjeP2xnyMjAcErD7lncdNpbEc4w==
X-Received: by 2002:a62:5e41:0:b0:56b:db09:a235 with SMTP id s62-20020a625e41000000b0056bdb09a235mr6211427pfb.20.1669130820272;
        Tue, 22 Nov 2022 07:27:00 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902f64900b00176d218889esm12161633plg.228.2022.11.22.07.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 07:26:59 -0800 (PST)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v2] igbvf: Regard vf reset nack as success
Date:   Wed, 23 Nov 2022 00:26:30 +0900
Message-Id: <20221122152630.76190-1-akihiko.odaki@daynix.com>
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

