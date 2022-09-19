Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273255BC11D
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 03:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiISBsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 21:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiISBsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 21:48:30 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6326110FDE;
        Sun, 18 Sep 2022 18:48:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so5473154pjm.1;
        Sun, 18 Sep 2022 18:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=wluvAQ2a1k5ujO/8y240pONv4SHYrKXDskmK8CL0ghc=;
        b=WOcOP0Q9y6oH2fWhyJ55+GhxFy1xEhQqDKXZMQgj1QjfLw1jZtNL+Takagkb/LNIk+
         O/gzjCb0ZZ1zQmL6stvsFJUB+Ph2wNjSOB+G8HkhOFa4aTWfegXZIPgfQirXc3CdlwgI
         yJTsoTJaikvxijdFH4yA3dHFF5aD8Kz7fnhIbYHQ/1o8lo6MBZ7XevRtdHU3sk0jbEmJ
         AJ2k+Hje7agd20En+ooTXLNahfJH1fgTOU99M8sWhyS0PWsC0Z5x/sFrKpNcFZBw+U8C
         /D7sic2yPFFfQne7yprdNCtynuirQMheUgA0PCzUtmOD6fE+IFeOjmgoPe0AFLzoRRrb
         zvbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=wluvAQ2a1k5ujO/8y240pONv4SHYrKXDskmK8CL0ghc=;
        b=dlRceJ3LYHqb3PRrxmT1LD/i5H20jZN6DzaTIFmV12sFXe6jTp8gX6R7kXdzhINcBh
         XS9bv2p9cYb/HKKCzZTtjmXkh3RsXWOEfP6pB5hBtKqgobALOJ01CAjvddhsWDiH8fqB
         ycC8TWOMiDaMkGPjeUT6WQ+ke50JCd/Uxe+34RXFeB/5nPH9ufx8dPaJhVeUjZZLacTq
         g/XznrnGLqQdvLamedadSOYLC/jdbbumCB/RFAQNzJgYygRI5nrZ7eemMXdiZwcwJsnh
         P+9LUSILl7gY6motv1UYm69Y+vjsjK2Q/l5oCSC1d9esHJ6pJ7H0jUtgsOdKw81XTxpM
         i5gg==
X-Gm-Message-State: ACrzQf0FDGT3VNgPHJplfqPHGs2gVQxl4abP0ICt39OrfXCTKXYeBLck
        FqzkuYgIZM+4XOWMtZ+YVes=
X-Google-Smtp-Source: AMsMyM51tMsVrtNtgp3tW3K0QLm5qL4zxoUOjw19WI97ZxdpYQvElGt6gRD4Hk7hFYRJdWf+fZN2jQ==
X-Received: by 2002:a17:90a:d14a:b0:203:7b4b:6010 with SMTP id t10-20020a17090ad14a00b002037b4b6010mr7709525pjw.237.1663552108700;
        Sun, 18 Sep 2022 18:48:28 -0700 (PDT)
Received: from rfl-device.localdomain ([110.11.251.111])
        by smtp.gmail.com with ESMTPSA id g11-20020aa796ab000000b0053bf1f90188sm19340831pfk.176.2022.09.18.18.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 18:48:28 -0700 (PDT)
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
Subject: [PATCH v4] liquidio: CN23XX: delete repeated words, add missing words and fix typo in comment
Date:   Mon, 19 Sep 2022 10:48:13 +0900
Message-Id: <20220919014813.32709-1-RuffaloLavoisier@gmail.com>
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
I'm sorry, can you explain exactly which part and how to fix it? I didn't quite understand. <this need> How can I fix this part?

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

