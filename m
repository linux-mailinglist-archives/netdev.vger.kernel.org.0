Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4358262CBAC
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239055AbiKPUyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238529AbiKPUx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:53:59 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9CD65CE
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:35 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id bj12so47077198ejb.13
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ah82tTOOObOFB3MDfuIM4J36KFmptfShWyxBMhuP5Xo=;
        b=FuFd7KEQ6d41KZBOZhhpBhnMjYXdxKD3gEK+faGWa/XfhW2EFx9CCnj4pbSYMac2Rg
         VIuXojA8qB/pnTAwSH/PmZxKpCmL2eAkLQyhE5BR42zG3IEDpWTJHKhUoMPbBlM0cwsa
         aoDXSsa8MbXs5ScTvpr0crbR+Zr5r66T3BoltNI3RObZ5w0EZWcatVi6Jt5ZsATEp/Dw
         jt8b+Zt2tr8/FhtYKWD6X46XX4b1PFmxtCddxq2uisW6m40miJnZawPupYuP4ofRL7OM
         qqYATmJca9f9feYgFHce3A/dYWupesj+8yaW4A7p+R4+b/3M0R4QMymOG5zlpIyc1L2s
         gTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ah82tTOOObOFB3MDfuIM4J36KFmptfShWyxBMhuP5Xo=;
        b=xciMjfe0u2jsBIY1MPx2aY61MvB1Gg6AKwciFAQPU1JNLzZ/ngpTjXIqaMt/FAhVQZ
         NEWzHSoPEFxdPqOXp46Ssckz/3wK0TLjakAhY+Ep6bvnX+jjlEi83OXnkOe48Zb98sOH
         3FgxVqGYasvPNo3rzIJaeURbH2KY9tUlE0NUel9fJmXf0esNfVd+LLcqAI9Q3ihEPNaw
         zJ+HagBleea7R3ZyfCMOk7t/el4wgB6XJXb4+bYpTZsQipVCOO9VRQywEiKDW+MF2INn
         YG/XJJ8kLo/PSbzhgqy8kFwdhWztKx8PPQQKrJ4eBLHJVf4Oo9v5Q8KW552C0h91drNG
         mlYg==
X-Gm-Message-State: ANoB5pltbvOa0lfaFzjV659mANtBRRytG1+YF3sUDsWRehVJwtBID8a5
        FjfxUchODJmfFvorUCFW0AT8Og==
X-Google-Smtp-Source: AA0mqf6TsBpIXovEdmEucl/l73gbKjxzP+VkiJgvsdH0sgJf+BVmPrCsGlJrR9tyIjg9pqj+KeInIA==
X-Received: by 2002:a17:906:53cd:b0:78c:1f2f:233e with SMTP id p13-20020a17090653cd00b0078c1f2f233emr19534963ejo.307.1668632013651;
        Wed, 16 Nov 2022 12:53:33 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4090:a244:804b:353b:565:addf:3aa7])
        by smtp.gmail.com with ESMTPSA id kv17-20020a17090778d100b007aece68483csm6782828ejc.193.2022.11.16.12.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:53:33 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 12/15] can: tcan4x5x: Remove invalid write in clear_interrupts
Date:   Wed, 16 Nov 2022 21:53:05 +0100
Message-Id: <20221116205308.2996556-13-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116205308.2996556-1-msp@baylibre.com>
References: <20221116205308.2996556-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register 0x824 TCAN4X5X_MCAN_INT_REG is a read-only register. Any writes
to this register do not have any effect.

Remove this write. The m_can driver aldready clears the interrupts in
m_can_isr() by writing to M_CAN_IR which is translated to register
0x1050 which is a writable version of this register.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/tcan4x5x-core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
index 41645a24384c..1fec394b3517 100644
--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -204,11 +204,6 @@ static int tcan4x5x_clear_interrupts(struct m_can_classdev *cdev)
 	if (ret)
 		return ret;
 
-	ret = tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_MCAN_INT_REG,
-				      TCAN4X5X_ENABLE_MCAN_INT);
-	if (ret)
-		return ret;
-
 	ret = tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_INT_FLAGS,
 				      TCAN4X5X_CLEAR_ALL_INT);
 	if (ret)
-- 
2.38.1

