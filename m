Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0964A5BC289
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 07:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiISFfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 01:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiISFfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 01:35:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD85B4B9;
        Sun, 18 Sep 2022 22:35:04 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q62-20020a17090a17c400b00202a3497516so5057519pja.1;
        Sun, 18 Sep 2022 22:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=0QtEN2K/GWQrkGXkiVMaJ2FghoxmUb6zTRh0w9WCrNM=;
        b=ecXDzQxwsMjJZjpUvHM66046cuxiVhli05zOr4VuAtLAblpCAYdgwhwnBxS29g38oI
         qjOE6NjAYlmFlC3FvrE6qcBaMaVinJFwgZq5nug2/p44Y5SZiP8IlR00D0+GqbNucX6e
         LTYuwYGROZ4UWON0NCtCg9ruddlOFVs6KWi1PmA9r/RTNsdiFKhfMORRrlAAIt7vVRf0
         k8kHgJoI0717ZyWx32ZepaUNo5U0RMAKNPfge9LcAvy/fw7kQ5bTzBBGFX8Ds2Z1vi2D
         GoDXh8ooe80zo2pJc77GQ1yyIuOGDdTExBc20LRmg4u/lD4Rox/+hl7Uebe9stlyhfZe
         smig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=0QtEN2K/GWQrkGXkiVMaJ2FghoxmUb6zTRh0w9WCrNM=;
        b=AB7FwdfGidQR6ryEdCNe3yeW/8mbVQUNXAswzC6QCOxvwMsPxk1YZEPT2MG6a+T1+y
         fdENv37c/TjZkclPfoe3v6u0nnqAqAMYjk2H8CClIxqNDzOCgY8ft7L7o5XxDq13vkHQ
         pAZLIr4bvK+DEAf8lZZ4F/AMj1YcMFIgx6trm5lq6PODfaDVFTbR98E1nVV12KvRXKUl
         VZWh+o3oyAdfivkBqH7QJrjGTlKuPNNM0Dxv/t26XHR2fYtULB3dg1bCUO8rBQzU/Dok
         HyQpP6x4FA7RomThP4gv1XBXr80fYEFPzNY3AT4fswnDahv10dGX/bmVsr0eV8RV9C48
         dazQ==
X-Gm-Message-State: ACrzQf2XFAPMvziIlzRdeqtIDwAuXvCxPxnM5hC38mSahg3Bms+8nv75
        YVz9iIIB8W4lTZATVRzGPHU=
X-Google-Smtp-Source: AMsMyM7pXSSS6HBX1b6C9yMJgHUXqiuLI/BH2iWZKKCd0KWJP8L4Fd7X4RgeqWKOpSGgS//JdfFsjg==
X-Received: by 2002:a17:902:f314:b0:178:a6ca:4852 with SMTP id c20-20020a170902f31400b00178a6ca4852mr406513ple.116.1663565703663;
        Sun, 18 Sep 2022 22:35:03 -0700 (PDT)
Received: from rfl-device.localdomain ([110.11.251.111])
        by smtp.gmail.com with ESMTPSA id w2-20020a1709026f0200b0016d4f05eb95sm19372878plk.272.2022.09.18.22.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 22:35:03 -0700 (PDT)
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
Subject: [PATCH v5] liquidio: CN23XX: delete repeated words, add missing words and fix typo in comment
Date:   Mon, 19 Sep 2022 14:34:46 +0900
Message-Id: <20220919053447.5702-1-RuffaloLavoisier@gmail.com>
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

- Correct spelling on 'malformation', 'needs'.

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
---
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h | 4 ++--
 drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
index 3f1c189646f4..a0fd32476225 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
@@ -87,8 +87,8 @@
  */
 #define    CN23XX_SLI_PKT_IN_JABBER                0x29170
 /* The input jabber is used to determine the TSO max size.
- * Due to H/W limitation, this need to be reduced to 60000
- * in order to to H/W TSO and avoid the WQE malfarmation
+ * Due to H/W limitation, this needs to be reduced to 60000
+ * in order to use H/W TSO and avoid the WQE malformation
  * PKO_BUG_24989_WQE_LEN
  */
 #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
index d33dd8f4226f..e956109415cd 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
@@ -36,8 +36,8 @@
 #define     CN23XX_CONFIG_PCIE_FLTMSK              0x720
 
 /* The input jabber is used to determine the TSO max size.
- * Due to H/W limitation, this need to be reduced to 60000
- * in order to to H/W TSO and avoid the WQE malfarmation
+ * Due to H/W limitation, this needs to be reduced to 60000
+ * in order to use H/W TSO and avoid the WQE malformation
  * PKO_BUG_24989_WQE_LEN
  */
 #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
-- 
2.25.1

