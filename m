Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CB35BC0E1
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 03:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiISBEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 21:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiISBET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 21:04:19 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C686913D68;
        Sun, 18 Sep 2022 18:04:18 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q62-20020a17090a17c400b00202a3497516so4650794pja.1;
        Sun, 18 Sep 2022 18:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=jUwOpqo/BKxzYsEAqMc5DTa4e7zgkceNk79Yq/88PNQ=;
        b=PVVAw2HxpX0fYEW7l+h8u8PiDVwWlYpDPQ2i2wpajO5gWOtjob9d3snyb8VHTNiql7
         hd0m2LsuL/VHDZW9Ndf6f+1W3yf8itWFaMYuDNnHydaaJWQy4MDOr7O2SSpR1GBE2NJ7
         ad7loYP/I8sz47NmBmk3+VnWC4+HKphjgW3vkTUot/GfE0OInYHnhePqDPD/gWPdOyjG
         GlWWI5//H20ZHoRYN4wyc79h35ZnkZEpXnVIgg7i6nQZ4pnDWq9qRGrgW4bpFUmMHEKA
         CS4fsUEBrAXvBJ6838xq326TTAWoKxZGrdL9iDth9wYLFk86bAgXzY3LHjTJDPvBCSfi
         bXcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=jUwOpqo/BKxzYsEAqMc5DTa4e7zgkceNk79Yq/88PNQ=;
        b=IeRbdQPN22xC7a8zi1e0kD6+wc3pixGoGkqGHWNTo6/UCLzF9kYHoGwAcnMOslcGRP
         5Wq+MuGbiC/sxEEVCBbSJU4IliW5z/a4XoFO+5LEZnZtbxY3VhxJcdDNuwep15h6P8Rf
         KQpNSm1fm6fgAmtRcXSLJLHPJJ/9x6Is0/QHeJo3ouwYsClw3mcYTKqElVFwYTwjuNFM
         9v7td9/PUIJgLs/fRUgFG6mZKNCrqrDrAKGWIkFsEvZA69y5SjV3xpI/M5Igfj2yKJuq
         Cge/Gfwi+0nRcxkEnTPxzqrt6jkyX9p8i3Qz6dFnVZ6o3pgnSFCa0yCltLA5/RfULKag
         wL5A==
X-Gm-Message-State: ACrzQf2OpMLsK+uKj6bBKXakreER8fl+ZBr4ewFQn4a/j3QUXi5OUFiy
        pu8K1J04XvCrWgMERS3GKDU=
X-Google-Smtp-Source: AMsMyM78dt2xwmM91h5FXM/uLqGzhsxnoo4uGhSdfr+VVODgDWUqtRy0t13ni+8w9Ob2q4HEKGhY6A==
X-Received: by 2002:a17:902:f78d:b0:174:f7aa:921b with SMTP id q13-20020a170902f78d00b00174f7aa921bmr10507027pln.37.1663549458152;
        Sun, 18 Sep 2022 18:04:18 -0700 (PDT)
Received: from rfl-device.localdomain ([110.11.251.111])
        by smtp.gmail.com with ESMTPSA id 185-20020a6308c2000000b00439c1e13112sm4616627pgi.22.2022.09.18.18.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 18:04:17 -0700 (PDT)
From:   Ruffalo Lavoisier <ruffalolavoisier@gmail.com>
X-Google-Original-From: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
To:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] liquidio: CN23XX: delete repeated words, add missing words and fix typo in comment
Date:   Mon, 19 Sep 2022 10:04:08 +0900
Message-Id: <20220919010410.6081-1-RuffaloLavoisier@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Delete the repeated word 'to' in the comment.

- Add the missing 'use' word within the sentence.

- Correct spelling on 'malformation'.

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
---
Please check if it has been corrected properly!

 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h | 2 +-
 drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
index 3f1c189646f4..244e27ea079c 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
@@ -88,7 +88,7 @@
 #define    CN23XX_SLI_PKT_IN_JABBER                0x29170
 /* The input jabber is used to determine the TSO max size.
  * Due to H/W limitation, this need to be reduced to 60000
- * in order to to H/W TSO and avoid the WQE malfarmation
+ * in order to use H/W TSO and avoid the WQE malformation
  * PKO_BUG_24989_WQE_LEN
  */
 #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
index d33dd8f4226f..e85449249670 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
@@ -37,7 +37,7 @@
 
 /* The input jabber is used to determine the TSO max size.
  * Due to H/W limitation, this need to be reduced to 60000
- * in order to to H/W TSO and avoid the WQE malfarmation
+ * in order to use H/W TSO and avoid the WQE malformation
  * PKO_BUG_24989_WQE_LEN
  */
 #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
-- 
2.25.1

