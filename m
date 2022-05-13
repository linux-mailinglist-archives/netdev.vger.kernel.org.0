Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73049526179
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380092AbiEML5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344951AbiEML5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:57:30 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D612F5A16E;
        Fri, 13 May 2022 04:57:29 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id i24so7491779pfa.7;
        Fri, 13 May 2022 04:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=0fF8qG+6OPuKpVu0R1wybWbx/uW0OgdxXtYW7VZmtB0=;
        b=en0Bu/z5p8ZatuWsDOl3vRK0yzfxknKWGBKtHUL79XmmGaX0FDJ6aP8UlZfjfi8AC7
         B8goSa5qLxiRaJ1pEtTZrq7wKLeuH4DVeN/4FPgVCGBzJNDmoCVs8z3LsSoqCzHTG5F6
         9lzVcjOZRZW9fXy/7IvtsUNQppWTCarwEiLwWkhOYmh0rO94c7PgfdNPNA8SeZrAtUiM
         mojr02cigDmKUJ3SHuAbd54i5NHYznCi+j04bByM6jKkYven/kBLvDsz+B04NcLWMmfO
         Dz7inc5jBkerMOohQei7BopiI1Hxf1onmvN5x4EwtKCAE9S73EmrujRtBMqM+0Bw0gXh
         /AeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0fF8qG+6OPuKpVu0R1wybWbx/uW0OgdxXtYW7VZmtB0=;
        b=ahEbjuAomaCt8Uzm1KG0+G/3oWaQxIrszdAl5uLRmIpLhZqMCJKfncRz3sjQ0URrMf
         x6W2NMrETgZCgZur3mV6J++O6BeA0/Vxs3+r0MCpVXYrkIVUjFCbAkjjIVRTBIVmqRJT
         JGBygB1ElBaFgaZVkby3inZqr4KyseYgGsRNOJwgYRx3x9wU14rK4BfT2Rzen7scM4CO
         anRuGJSAUr1ay3kznosPAPliw6AzU43Bp0LIlr/nDO86sMMGHx5MsPvQbTtotyieU6s4
         vxt3SF8rOEL+thk9jh+e1vaXQGeNZjznOKlVr5nJHYdkuHnI1AeAOr4Nqahi3kRCRD/J
         TujQ==
X-Gm-Message-State: AOAM533FlBojJNQxg2h8tXA4zlRNe2v6j1YTTBZL0+pgOiEM/+7RdDvZ
        K3TYWtMN1pzLqB06kT0z9bE=
X-Google-Smtp-Source: ABdhPJyf920MKH7yGNayml+viV5l9I7COtZxQU2rA7nEWQ+eT0yfsVCuj6eEsMuDsojHcQGqUgGBqA==
X-Received: by 2002:a05:6a00:1a49:b0:510:a1d9:7d73 with SMTP id h9-20020a056a001a4900b00510a1d97d73mr4359749pfv.53.1652443049321;
        Fri, 13 May 2022 04:57:29 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id im2-20020a170902bb0200b0015e8d4eb1bdsm1732201plb.7.2022.05.13.04.57.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 May 2022 04:57:28 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wells.lu@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next] net: ethernet: Fix unmet direct dependencies detected for NVMEM_SUNPLUS_OCOTP
Date:   Fri, 13 May 2022 19:57:16 +0800
Message-Id: <1652443036-24731-1-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removed unnecessary:

	select COMMON_CLK_SP7021
	select RESET_SUNPLUS
	select NVMEM_SUNPLUS_OCOTP

from Kconfig.

Reported-by: kernel test robot <yujie.liu@intel.com>
Signed-off-by: Wells Lu <wellslutw@gmail.com>
---
 drivers/net/ethernet/sunplus/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/sunplus/Kconfig b/drivers/net/ethernet/sunplus/Kconfig
index d0144a2..be50a6b 100644
--- a/drivers/net/ethernet/sunplus/Kconfig
+++ b/drivers/net/ethernet/sunplus/Kconfig
@@ -23,9 +23,6 @@ config SP7021_EMAC
 	tristate "Sunplus Dual 10M/100M Ethernet devices"
 	depends on SOC_SP7021 || COMPILE_TEST
 	select PHYLIB
-	select COMMON_CLK_SP7021
-	select RESET_SUNPLUS
-	select NVMEM_SUNPLUS_OCOTP
 	help
 	  If you have Sunplus dual 10M/100M Ethernet devices, say Y.
 	  The network device creates two net-device interfaces.
-- 
2.7.4

