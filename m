Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA6B5B9691
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiIOIrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiIOIrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:47:05 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7811A98355;
        Thu, 15 Sep 2022 01:47:03 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso21710745pjk.0;
        Thu, 15 Sep 2022 01:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=kIrxc8mci/RrccREvho+GVT4skHCcg6IezHj6tnw+KY=;
        b=SBYpsSl9fOw8/p/KkQdvUfe9JAQhZm4PYBYdKgUhhEQrwSAn2iM6DS7mJllJZ/1BmA
         zqQxgEi/EpSZ0b1IIjLKggWnpzocI21uPbHOmcP++LnfoufLPDB2yMCWk4UC5+3TZ3sK
         kBiDsIB/NVFToUCFtzVrLzPJ8iU6pxFt9jzsyGFADdSYbrhmK+AtzZRvzWdmsE3qY73r
         5+kqJA8foHdbZu4JUDQaDrCyvBICFe4t27tHNFRmTM4pYmkVAzRhm5qehX7ZAymmOZa/
         gJgzNiFqcBv897/UvotDDrpGRb18DogUL7OQ3LDbZleQtwENn2MrSNLpX2LEyWtGyU0P
         juIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=kIrxc8mci/RrccREvho+GVT4skHCcg6IezHj6tnw+KY=;
        b=piIVZBSCjRSl1nQi5rQyUtKBBcXBrYtfV7N+4iWWfABe2NkHBYH+UDIpnwn99nAvzu
         w8Jn7m7djWyX8AXrrC9GZTcaUhNMc5R7pEoStq+viLp/IFq129+XD3tP1m/DWH2QAUkJ
         PjHS3ftL3PMbAfwzTF8LnOy+7mS7Uq7OmWrvK743xC68asxeAb1Jn4soG4xrJMbYo6iO
         C23XLBazycOvA/INwrPOXKGOZYG7xCvZaDW8mW9SllbNEoJ2Pfo3qREsXVeZ2aalDtoa
         M+jFlWse//sWy+ly03zZXtFm94uoAjkfxxEuqep79X9heDVhtN7qeSmN/uys2GxJIU2c
         WGgQ==
X-Gm-Message-State: ACrzQf0jSSOtGLpaBjNGYhQhYJYnUXvM7VViLQsZfYSkxZ9xA3EJ3Jmx
        EkYtX8Dbh3Ov0S/j3oFpoo4=
X-Google-Smtp-Source: AMsMyM6Hq3pRrhVhSs8UeW+cR4B9UQMXekV08nHvh/4has3YMzt6rrads3ck5L1/0xKd8cFBktoj/Q==
X-Received: by 2002:a17:903:32c4:b0:178:5206:b396 with SMTP id i4-20020a17090332c400b001785206b396mr365736plr.99.1663231622799;
        Thu, 15 Sep 2022 01:47:02 -0700 (PDT)
Received: from rfl-device.localdomain ([110.11.251.111])
        by smtp.gmail.com with ESMTPSA id p4-20020aa79e84000000b0053ea0e55574sm11670126pfq.187.2022.09.15.01.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 01:47:02 -0700 (PDT)
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
Subject: [PATCH] liquidio: CN23XX: delete repeated words
Date:   Thu, 15 Sep 2022 17:46:36 +0900
Message-Id: <20220915084637.5165-1-RuffaloLavoisier@gmail.com>
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

- Delete the repeated word 'to' in the comment

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
---
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h | 2 +-
 drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
index 3f1c189646f4..9a994b5bfff5 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
@@ -88,7 +88,7 @@
 #define    CN23XX_SLI_PKT_IN_JABBER                0x29170
 /* The input jabber is used to determine the TSO max size.
  * Due to H/W limitation, this need to be reduced to 60000
- * in order to to H/W TSO and avoid the WQE malfarmation
+ * in order to H/W TSO and avoid the WQE malfarmation
  * PKO_BUG_24989_WQE_LEN
  */
 #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
index d33dd8f4226f..19894b7c1ce8 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
@@ -37,7 +37,7 @@
 
 /* The input jabber is used to determine the TSO max size.
  * Due to H/W limitation, this need to be reduced to 60000
- * in order to to H/W TSO and avoid the WQE malfarmation
+ * in order to H/W TSO and avoid the WQE malfarmation
  * PKO_BUG_24989_WQE_LEN
  */
 #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
-- 
2.25.1

