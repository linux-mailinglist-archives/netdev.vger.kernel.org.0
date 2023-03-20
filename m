Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91D56C2592
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 00:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjCTXYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 19:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCTXYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 19:24:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C297136ED
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 16:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679354607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GpP2z7KdETtSjf5FRKQeOFJT3f2f22hqp1FLeOMOD9E=;
        b=QFdO0I5qpvuf+2NsG0y3b5rfJllWHQlYrO5/sul57olNRrVACzupVbjty33Yak7LKOX4ml
        DGD3Ne5XMPY/Dg5IDrvPsWWCzBhUD8IC2+hiun6dI4jv++iL9OR8NPdvQHCqcGlRBxzJ2W
        dVJPneifjOlaq28Fg899y+QFyAXEGWw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-2J-18bVFPcmWUr9Gyl4wAA-1; Mon, 20 Mar 2023 19:23:26 -0400
X-MC-Unique: 2J-18bVFPcmWUr9Gyl4wAA-1
Received: by mail-qt1-f198.google.com with SMTP id b11-20020ac87fcb000000b003e37d72d532so1153088qtk.18
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 16:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679354606;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GpP2z7KdETtSjf5FRKQeOFJT3f2f22hqp1FLeOMOD9E=;
        b=Pqx9eWIAgTNf2NiVZEQlym16O0761T38TIjz6m6LMP1F/lgV7s9VgdV9s+SFJka3GJ
         vPDp8ca3yZmSdmamtUTBQN21OLAMmH8+Od7bPbaupGpHRn2or1vvLK4/6356ULkeHCJG
         k+sYRgtXpAVKJprRPN1ywvAPJVUjP+u3wnIdBu+k6kmgajVpvBlRoJF4zqZtWstAdSgb
         M1YpNaSvhKTkPjrPLehfTJ/eogD5WAGm9AcfMgTfsAheq2tMxN8TMVFEQKOURHrJfou1
         RQk2+A8kDnvakpCHU5WvJxen/n406dym7A6E7EQswBtlJRo+GZWuoOy7wO3OqUuYNyGO
         EBuQ==
X-Gm-Message-State: AO0yUKWFlZHWUzFdWUnajLNyOzhMsLX2fhgqzT/UPBEBGDMxxAXrkAFP
        LPEocxTz+k1Df2PBSzRsktyV3aJfhIwdWJd37NtkVdi3f8+uHzmjPa7FujigSuA7/mN96o5NTie
        NQP++LxZPxCAuI2xf
X-Received: by 2002:a05:6214:2a88:b0:56e:b1e0:3fef with SMTP id jr8-20020a0562142a8800b0056eb1e03fefmr1002388qvb.24.1679354605908;
        Mon, 20 Mar 2023 16:23:25 -0700 (PDT)
X-Google-Smtp-Source: AK7set8QOzhqOd7nFesFbCuOTTVxImRbs0jpuxacByG/oeEhIIMtdUjSbjovf3qvpuVqd45uRXJMxQ==
X-Received: by 2002:a05:6214:2a88:b0:56e:b1e0:3fef with SMTP id jr8-20020a0562142a8800b0056eb1e03fefmr1002373qvb.24.1679354605659;
        Mon, 20 Mar 2023 16:23:25 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id q145-20020a374397000000b007429ee9482dsm8113502qka.134.2023.03.20.16.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 16:23:25 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     chris.snook@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, yuanjilin@cdjrlc.com,
        liew.s.piaw@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] net: atheros: atl1c: remove unused atl1c_irq_reset function
Date:   Mon, 20 Mar 2023 19:23:17 -0400
Message-Id: <20230320232317.1729464-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang with W=1 reports
drivers/net/ethernet/atheros/atl1c/atl1c_main.c:214:20: error:
  unused function 'atl1c_irq_reset' [-Werror,-Wunused-function]
static inline void atl1c_irq_reset(struct atl1c_adapter *adapter)
                   ^
This function is not used, so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 40c781695d58..4a288799633f 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -207,16 +207,6 @@ static inline void atl1c_irq_disable(struct atl1c_adapter *adapter)
 	synchronize_irq(adapter->pdev->irq);
 }
 
-/**
- * atl1c_irq_reset - reset interrupt confiure on the NIC
- * @adapter: board private structure
- */
-static inline void atl1c_irq_reset(struct atl1c_adapter *adapter)
-{
-	atomic_set(&adapter->irq_sem, 1);
-	atl1c_irq_enable(adapter);
-}
-
 /*
  * atl1c_wait_until_idle - wait up to AT_HW_MAX_IDLE_DELAY reads
  * of the idle status register until the device is actually idle
-- 
2.27.0

