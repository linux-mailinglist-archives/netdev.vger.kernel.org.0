Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4976C5EB1
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCWFVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjCWFVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:21:10 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB85171E;
        Wed, 22 Mar 2023 22:21:09 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x3so81690961edb.10;
        Wed, 22 Mar 2023 22:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679548868;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQ3/MMrs7fOEw9Jd5dWKupgT3gzNQkdxihTCZGsPDmI=;
        b=R2XOpoJZvRNESbyIOwefYoyfc6WUkceVZUIVpBLBAOW7WyAteGm/h4N7KM2wGvZqoU
         AFKWLmbJB+GArg0LWMMSFDQ7/37Ada2q3ZfA7W2ZmuFdUird8ofOKovZkb3vsgSZhmAl
         OQ36CvynrY5LHp4vtaBQFHRvmnHmaWrHAh0imAyaUheUdQx7h1u2k8fFjX2wSahR1+fA
         od+i1FfFE4IcAZdvJo+WJtPQUBkhSHxgLnQMRPrdRQEOgHvtz3odeVSRAjCerawS24M2
         w76HzsbCph0JgXSAAooO4yIzwvCleEgxjAW9Hd865zC3cu64/4anbFf0y+kW8CZwdkdo
         Y4nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679548868;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sQ3/MMrs7fOEw9Jd5dWKupgT3gzNQkdxihTCZGsPDmI=;
        b=AcQZuGmYSu+M9AqU7BiHduQqw7YRI8pb5fkpM4Ss0xA8bMCMkNIdVI0tbO6lmffLPV
         wLg4aCgPg04rnHwrICGJR4YyJJD/2imIIQbO6AWKmSrMgS0MeM4B7DQX1voSdFLgA2Fu
         HlKQv4rvT/ILF1CeIbae3w49c6PtlFENo1bXyvWoy7sALvI9JWhlrYwI+ZGSpyD7AfG3
         xgaUWJJ338ZwdvN/9IrIP7qzkk9I9jIFxD/uENNY4cktNueeOg9+g/7bPGPhot0tL1zb
         irYH45MJ4M9U3BIeKa2N1o9RwUoDXTWE0OqCpZMQphQdwz5HGlCefA1WAvx0rPhteINe
         At2w==
X-Gm-Message-State: AO0yUKVfZfCvmksf2oErMA8GYCkpBsv/3KWctqwXPgOH5ce6w3CZjoKf
        Znr5atyKgYW96MZi9a+hZ+w=
X-Google-Smtp-Source: AK7set8YQJ806nGRLwfgjJjKzD682xxAOm/YlSCIrumF/P9SMQ2CNzpYuaCr9Q7GhZbvdUTyErfoNQ==
X-Received: by 2002:a05:6402:a53:b0:4bf:b2b1:84d8 with SMTP id bt19-20020a0564020a5300b004bfb2b184d8mr4481480edb.19.1679548867499;
        Wed, 22 Mar 2023 22:21:07 -0700 (PDT)
Received: from felia.fritz.box ([2a02:810d:2a40:1104:d509:cbf0:f579:76f0])
        by smtp.gmail.com with ESMTPSA id y94-20020a50bb67000000b004be11e97ca2sm8603467ede.90.2023.03.22.22.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 22:21:07 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] ethernet: broadcom/sb1250-mac: clean up after SIBYTE_BCM1x55 removal
Date:   Thu, 23 Mar 2023 06:21:01 +0100
Message-Id: <20230323052101.30111-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit b984d7b56dfc ("MIPS: sibyte: Remove unused config option
SIBYTE_BCM1x55"), some #if's in the Broadcom SiByte SOC built-in Ethernet
driver can be simplified.

Simplify prepreprocessor conditions after config SIBYTE_BCM1x55 removal.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
I looked around on lore.kernel.org and could not find a pending patch from
Thomas Bogendoerfer related to cleaning up this network driver after he
removed the config. So, to be on the safe side, I just sent this quick
clean-up patch.

 drivers/net/ethernet/broadcom/sb1250-mac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/sb1250-mac.c b/drivers/net/ethernet/broadcom/sb1250-mac.c
index f02facb60fd1..3a6763c5e8b3 100644
--- a/drivers/net/ethernet/broadcom/sb1250-mac.c
+++ b/drivers/net/ethernet/broadcom/sb1250-mac.c
@@ -73,7 +73,7 @@ MODULE_PARM_DESC(int_timeout_rx, "RX timeout value");
 
 #include <asm/sibyte/board.h>
 #include <asm/sibyte/sb1250.h>
-#if defined(CONFIG_SIBYTE_BCM1x55) || defined(CONFIG_SIBYTE_BCM1x80)
+#if defined(CONFIG_SIBYTE_BCM1x80)
 #include <asm/sibyte/bcm1480_regs.h>
 #include <asm/sibyte/bcm1480_int.h>
 #define R_MAC_DMA_OODPKTLOST_RX	R_MAC_DMA_OODPKTLOST
@@ -87,7 +87,7 @@ MODULE_PARM_DESC(int_timeout_rx, "RX timeout value");
 #include <asm/sibyte/sb1250_mac.h>
 #include <asm/sibyte/sb1250_dma.h>
 
-#if defined(CONFIG_SIBYTE_BCM1x55) || defined(CONFIG_SIBYTE_BCM1x80)
+#if defined(CONFIG_SIBYTE_BCM1x80)
 #define UNIT_INT(n)		(K_BCM1480_INT_MAC_0 + ((n) * 2))
 #elif defined(CONFIG_SIBYTE_SB1250) || defined(CONFIG_SIBYTE_BCM112X)
 #define UNIT_INT(n)		(K_INT_MAC_0 + (n))
@@ -1527,7 +1527,7 @@ static void sbmac_channel_start(struct sbmac_softc *s)
 	 * Turn on the rest of the bits in the enable register
 	 */
 
-#if defined(CONFIG_SIBYTE_BCM1x55) || defined(CONFIG_SIBYTE_BCM1x80)
+#if defined(CONFIG_SIBYTE_BCM1x80)
 	__raw_writeq(M_MAC_RXDMA_EN0 |
 		       M_MAC_TXDMA_EN0, s->sbm_macenable);
 #elif defined(CONFIG_SIBYTE_SB1250) || defined(CONFIG_SIBYTE_BCM112X)
-- 
2.17.1

