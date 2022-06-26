Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D2555B24D
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 15:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbiFZN3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 09:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbiFZN3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 09:29:53 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B920B7D0;
        Sun, 26 Jun 2022 06:29:53 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n10so6035103plp.0;
        Sun, 26 Jun 2022 06:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2RULbZpZ72MsKU+VIPl1ZlCBfNyyNEfInSr7ctdeJaA=;
        b=HFTRyZFM8fp4D4uT6kYifZ7HVbB/p1GelMjEw5/uVBwH8BRQRGBWWHzpDPM8QtqpcY
         s+6l3mqidoZHQZTYhsw7OMMfcVwafFQgsJrO3Eo6IahbH64LbxCZU3az9l9u6r8FxFKP
         JNibHIx1vqqIfm2c6C/CLWs/l9tYmfyRRGK7ZyGkP4fvSCe4+92cBbR88q2lwyvqxPDd
         pnVrwHs9+V9SQCvudiQa0f1Df37x2yLhWsRfSgX8RzBZtE/phIEPagJtFSc6PBnZtDaJ
         Iir4q2GJ9eX9zVAp81RJdrP/X3TnsloA8cR4I/60UNTeTuKVRzjH2BLfKIgrKLZ+4l42
         /8lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2RULbZpZ72MsKU+VIPl1ZlCBfNyyNEfInSr7ctdeJaA=;
        b=hVGq45c4RZYLDTXS/+ZDowqbNhKoq+XLKLvzBSUMJXH/bVtkxwS9OzGO7l/7KHzX6X
         kgwEDu4L1rKzqjPni8Aklhixm0+gFSXRwphHoILLW4/3dchPyc1sux2XV37Sr8NE8/OS
         b8xqrtTG9zu0lErIlJGKW79+GdOmeMNRUEiATPGCw/ZfXFZSfwSOvwYG91iBviPMifW9
         MbSIvyvZVBDOCRuwL/QfmcU/8rLSz3bWKuL+FQtPIXHUTrwZ2ciIY2oBBmP3IlF4SEso
         iFon6s7LCkBzttw4a8ti/sKe0WPmfqSmzZX5UUN84GvDtNo7/vJI1sa1HbCu91f0kYCb
         e5Lw==
X-Gm-Message-State: AJIora8ox3FeyWYg4dx/1XuI3f1hNeTeumLjzdxDxDjWHMI28/t59aYR
        ZwDjay4IXUk1SFjgbEwzTQtVFkyAxlo+zhRXPcw=
X-Google-Smtp-Source: AGRyM1ua2YJsU6YVxvsGpX/2Z37w3giUBi12PGVeX/Z5t641sFM4jy3euZf3jF2F29omGD5aiX+IFQ==
X-Received: by 2002:a17:90a:df98:b0:1ec:96e5:b04d with SMTP id p24-20020a17090adf9800b001ec96e5b04dmr10065479pjv.185.1656250192428;
        Sun, 26 Jun 2022 06:29:52 -0700 (PDT)
Received: from f34-buildvm.eng.vmware.com ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id v8-20020a17090a00c800b001df82551cf2sm5044526pjd.44.2022.06.26.06.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 06:29:52 -0700 (PDT)
From:   Shreenidhi Shedi <yesshedi@gmail.com>
X-Google-Original-From: Shreenidhi Shedi <sshedi@vmware.com>
To:     vburru@marvell.com, aayarekar@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shreenidhi Shedi <sshedi@vmware.com>
Subject: [PATCH] octeon_ep: use bitwise AND
Date:   Sun, 26 Jun 2022 18:59:47 +0530
Message-Id: <20220626132947.3992423-1-sshedi@vmware.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shreenidhi Shedi <sshedi@vmware.com>

This should be bitwise operator not logical.

Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
Signed-off-by: Shreenidhi Shedi <sshedi@vmware.com>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
index cc5114979..3d5d39a52 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
@@ -52,7 +52,7 @@

 #define    CN93_SDP_EPF_RINFO_SRN(val)           ((val) & 0xFF)
 #define    CN93_SDP_EPF_RINFO_RPVF(val)          (((val) >> 32) & 0xF)
-#define    CN93_SDP_EPF_RINFO_NVFS(val)          (((val) >> 48) && 0xFF)
+#define    CN93_SDP_EPF_RINFO_NVFS(val)          (((val) >> 48) & 0xFF)

 /* SDP Function select */
 #define    CN93_SDP_FUNC_SEL_EPF_BIT_POS         8
--
2.36.1

