Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADB3619874
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbiKDNul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiKDNuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:50:40 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFFC29B;
        Fri,  4 Nov 2022 06:50:39 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso3227665wmo.1;
        Fri, 04 Nov 2022 06:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Cm3BsyVvYpSeuNudkmxYNEssTxhnxpwGrC+e8qB022Q=;
        b=NR7TLJzCPb2Z1wMhlgNcq0uSnplDtHg4xB4GGeup2S6Xc1Ve0fJXVFoCfSpEtqpMfR
         GmKR3ZrUu8LLaKnYzfBRlq/ltFR/JitfNcXUIZB6hBiD1u0xwyJqTt/E0n6ic1wZYr1L
         EYNwIhAKgLywM7z9kC8sUbiN5Ey8TAcXFZVwTjSqKjO/aaghluyXYUfhsiOS3JHx3XM7
         GIj5YUnl2iFMVCVJGdXTRBL8+eXGUCuyC+0hzp5BX8oLKZU1+uH3B5FVTqXEHAh8rhwI
         0cscXkYMEvbZymCjgY4tJYZ5ribl105etf8thyq27r5FlorxKCKYEngVSHyNuxV2qqkE
         RvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cm3BsyVvYpSeuNudkmxYNEssTxhnxpwGrC+e8qB022Q=;
        b=mnXFSke4K4BU0EVAx8HDU+gm7dWqJnmxSOAc3WYMDkdDHms+KqbwlTET1hjTgbuzUS
         +XUX7pBu+C8g6TjZGJJAsQSxb2Zr6wGBTrRe6OYsEI1cSD/3HYCeW8Waxu7LW2oXoT10
         U5IjZVi5rMuE8HIFWSSkxFi/waEXtT5WyQapthLtbBcjddzXZS4X2dbghBx4d8hbXw1j
         AdtydKfsqie4Z2gntxePJkYfbdZSyzEuRbb6GabM0fe0AqS8isl/YuRmSAhdxLw1gmJ3
         e8oX1xb6VMlhm9Ae0L5tg1Qc11/fgluZcbMfSfx84GzDwaEeqdw/FuiyLZRbkNYDlGRP
         2diw==
X-Gm-Message-State: ACrzQf34mUWPy4UIbCb54jx+OYpYMSO4mi63JuGGR9epBP9UsaXGTlXb
        0LU5FvQK4Alb/Ai9yBES36s=
X-Google-Smtp-Source: AMsMyM6126QLQtqa/BlEQCAV4mdK+f0+HGOLxQHukxIVJzMus3Xva0A3wSvIXT1Qcg2lsLOnrkIxxg==
X-Received: by 2002:a1c:2507:0:b0:3b3:3681:f774 with SMTP id l7-20020a1c2507000000b003b33681f774mr34535073wml.134.1667569838131;
        Fri, 04 Nov 2022 06:50:38 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c4f1500b003b4fdbb6319sm3340603wmq.21.2022.11.04.06.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 06:50:37 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Stanislaw Gruszka <stf_xl@wp.pl>, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlegacy: remove redundant variable len
Date:   Fri,  4 Nov 2022 13:50:36 +0000
Message-Id: <20221104135036.225628-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Variable len is being assigned and modified but it is never
used. The variable is redundant and can be removed.

Cleans up clang scan build warning:
warning: variable 'len' set but not used [-Wunused-but-set-variable]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 7352d5b2095f..429952871976 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -1202,8 +1202,6 @@ il3945_rx_handle(struct il_priv *il)
 		D_RX("r = %d, i = %d\n", r, i);
 
 	while (i != r) {
-		int len;
-
 		rxb = rxq->queue[i];
 
 		/* If an RXB doesn't have a Rx queue slot associated with it,
@@ -1217,10 +1215,6 @@ il3945_rx_handle(struct il_priv *il)
 			       PAGE_SIZE << il->hw_params.rx_page_order,
 			       DMA_FROM_DEVICE);
 		pkt = rxb_addr(rxb);
-
-		len = le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK;
-		len += sizeof(u32);	/* account for status word */
-
 		reclaim = il_need_reclaim(il, pkt);
 
 		/* Based on type of command response or notification,
-- 
2.38.1

