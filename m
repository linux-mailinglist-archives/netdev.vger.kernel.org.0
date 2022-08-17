Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E975969B2
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 08:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238435AbiHQGne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 02:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiHQGnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 02:43:33 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17272B62E
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 23:43:31 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 12so11236092pga.1
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 23:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=sRtVmdkfpIv+4fJ6hEvE/u1I0caO2Utch477V1tTTSQ=;
        b=B6y6PEJmx2qiyHVQwpLfY35AoW9MxWGQJ/u2Fdo3JL9rOFFAWnxXyBbYVMDi81FG2w
         3mdzEditG26F6zi5AobWEoEv0s1ekpwrTYUlTB6auOqUIf221yaeukYGG3gKPjQlJKkg
         8w+1aHQnBwKW0KrjKliqqFuyk0xL52Kbl7MfJmYaJws3vMA2ur6XLLs+PAA3xNtQO9HL
         pffS/6hQ6SXu4lVcmprqIUYYIOoeWI0+IODFKqPXu44aK+i9VGL4lG7kzMTlKVlCC8WP
         m0ACw/rEN1oVr8aP0CflmraNbcUKJdhZLeHjtLgam2qDV6kcxwv+TVWMWr0rWGo52Nop
         LbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=sRtVmdkfpIv+4fJ6hEvE/u1I0caO2Utch477V1tTTSQ=;
        b=DXJIgEHOosJ68EtdQ2WbSVJphbnNka9dYzZMd4v7ufFyfh3w5JXJIXJfxSPpXMkZiI
         ScY4RDIdeDbiSqn5g8w1noxdlYEHrJOryDz2n3k1OYQb8XjE9K2heMCZoPQhrQ3AtQHI
         U3YEa7Lk4NILM9eE/FPMsFfwbq4aGrGA36J0PU/OZOoR3SrfVDwkeiA0fuWf4CtrZa5F
         J0uS3g3nkNyzL/S0JDcsDmuKr0eAxYYnmlQTS3aml2rs0B1Z1na1bKyHST7u5k7InA+R
         8a4LLlRDH0EgMdwAaxnm4AdPKPRyTG3n/6HXNSzVcm6ICP1CxhymKprOb7yrbEGtki8U
         bx1A==
X-Gm-Message-State: ACgBeo1Ka4RSzXBPqTLOlFplISe+Ayz4RNiFKD8xneaPc098iAWAa5qG
        rbGWSJYfTi04IF+2S069Gq8=
X-Google-Smtp-Source: AA6agR4jTkQIoWwsu8U7pRmSeejsbdCgNbbKnRMCQNoGEqTjE/Nh2ZtoqZ64ZgAreWV4KR2/j9H0Nw==
X-Received: by 2002:a63:4608:0:b0:41a:617f:e194 with SMTP id t8-20020a634608000000b0041a617fe194mr21435137pga.152.1660718611295;
        Tue, 16 Aug 2022 23:43:31 -0700 (PDT)
Received: from localhost.localdomain (203-74-121-181.hinet-ip.hinet.net. [203.74.121.181])
        by smtp.gmail.com with ESMTPSA id i10-20020a1709026aca00b0016dc240b24bsm568882plt.95.2022.08.16.23.43.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Aug 2022 23:43:30 -0700 (PDT)
From:   Wong Vee Khee <veekhee@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [net-next v2 1/1] stmmac: intel: remove unused 'has_crossts' flag
Date:   Wed, 17 Aug 2022 14:43:24 +0800
Message-Id: <20220817064324.10025-1-veekhee@gmail.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wong Vee Khee <veekhee@apple.com>

The 'has_crossts' flag was not used anywhere in the stmmac driver,
removing it from both header file and dwmac-intel driver.

Signed-off-by: Wong Vee Khee <veekhee@apple.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 -
 include/linux/stmmac.h                            | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 52f9ed8db9c9..1d96ca96009b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -610,7 +610,6 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->int_snapshot_num = AUX_SNAPSHOT1;
 	plat->ext_snapshot_num = AUX_SNAPSHOT0;
 
-	plat->has_crossts = true;
 	plat->crosststamp = intel_crosststamp;
 	plat->int_snapshot_en = 0;
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 8df475db88c0..fb2e88614f5d 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -257,7 +257,6 @@ struct plat_stmmacenet_data {
 	u8 vlan_fail_q;
 	unsigned int eee_usecs_rate;
 	struct pci_dev *pdev;
-	bool has_crossts;
 	int int_snapshot_num;
 	int ext_snapshot_num;
 	bool int_snapshot_en;
-- 
2.32.1 (Apple Git-133)

