Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6B65861EC
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 00:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238044AbiGaW7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 18:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiGaW7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 18:59:01 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FDDB49A;
        Sun, 31 Jul 2022 15:59:00 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f65so8205517pgc.12;
        Sun, 31 Jul 2022 15:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=oJqk7d4+5LcTXsCWtgqi9TT/AZXIsZdt+L9iCfbFF0Y=;
        b=D6Q7uM3MuWq8prZwXZVC3HbxsoTpyFkc63QmZq/7klpjYjoEPoW+I5NW2nXtR0spgn
         TLJO7UGBrk9p92fo94Igh1VFvdr4vttake7BMx13JTBaxYe6jSDmxsNhYObDUx7v75hJ
         T4Sp4uqKNJG7OYfd4FXeLHJskx6EDnBU3MrNJF1A4nUEiWlL8MelrvxY2vuM+mhu2Qk4
         tS7FB70gTVRu1Fb9k0UIMCRsMQYPLF/mIl9Rl2Z+6Ul/bzHBFATGfRvzuOe5yH/8p/1Z
         ALRSzz/YgAzLTMWDAnfRLeTtxlEvRRGlHTnqxJXXoeianjL2s4St4IaLK8wkPfNahdbA
         cNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=oJqk7d4+5LcTXsCWtgqi9TT/AZXIsZdt+L9iCfbFF0Y=;
        b=48xo6qKpOYn7R72k8KFoHqWTSGtXWvFHp0aZ42Bm+74VdJuKIMSH+WbR98lQWsLXjv
         x3BBoGursJyRvHHclXCVnSnWNqMipvwYXW7+t4IEeCavLPjXnFxDG0OKakTdLJHwcunE
         OVUCzgEtFew//fF2Tr4qptCXLQH/QnPE1jkvkdCjHet8FeXhCXFfE6fHtabJM5rKo7/r
         RXAHZ1rx7vaKPkPpzv4zahNIakDJHjiUNxenVnrBwmGxplA3JDYZ1hNz1d5I0Tr2B65h
         rXmOrEu9/cW72H3YU7msRciUqNPPPyklVonqv611/4retA2R/X5cRfzAOAYi1myBLdG+
         6XWA==
X-Gm-Message-State: AJIora8wiHW6sLpCTFuYgICSt/UkVmXh8zFhjcGdcZUVoIVjgYxSqH2n
        rxipEdUMrWDeLO/2ld5o0Q+pPHrq7C0=
X-Google-Smtp-Source: AA6agR5H03DT59ieEnrLk41UBn3dv1CbP/Q3QMAlvI4jtXfT7ASlbmndI0eGR21v5Mf9gyvI1g9W9g==
X-Received: by 2002:a05:6a00:124c:b0:52b:26b6:2ab4 with SMTP id u12-20020a056a00124c00b0052b26b62ab4mr13785950pfi.85.1659308340081;
        Sun, 31 Jul 2022 15:59:00 -0700 (PDT)
Received: from rfl-device.localdomain ([39.124.24.102])
        by smtp.gmail.com with ESMTPSA id j37-20020a635965000000b0041bee4032e5sm1713756pgm.38.2022.07.31.15.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 15:58:59 -0700 (PDT)
From:   Ruffalo Lavoisier <ruffalolavoisier@gmail.com>
X-Google-Original-From: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcm80211: remove duplicate words
Date:   Mon,  1 Aug 2022 07:58:50 +0900
Message-Id: <20220731225850.106290-1-RuffaloLavoisier@gmail.com>
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

Remove repeated 'to' from 'to to'

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/types.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/types.h
index ae1f3ad40d45..2b0df07ced74 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/types.h
@@ -123,7 +123,7 @@
 					 */
 
 /********************************************************************
- * Phy/Core Configuration.  Defines macros to to check core phy/rev *
+ * Phy/Core Configuration.  Defines macros to check core phy/rev *
  * compile-time configuration.  Defines default core support.       *
  * ******************************************************************
  */
-- 
2.25.1

