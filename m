Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1261629456
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiKOJbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbiKOJbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:31:41 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8D0EE39;
        Tue, 15 Nov 2022 01:31:40 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id ja4-20020a05600c556400b003cf6e77f89cso870810wmb.0;
        Tue, 15 Nov 2022 01:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xxOYorO+qp/Ux5uO45kQPwW5Xbfxtuq7/VNLX14n8IY=;
        b=lq9j8Yo+iYN2nBfXTbuHNwdedR1am7ZrPm1ovFLALugOLW9NFNvXFyvRydDoqouGce
         QOOCE09OddSjazJ1JNfegaB91Si+aYbqsrGXTJ+dWXX2PNIk/Rt2OpWXyRZ+9RiZtzYh
         +rGawEVIZ3s6XFJhbCvjyUQSdPJKQ3+kcbhL2rujjCIXNjjvOLrQe0Jdw4YA7OkEjXlj
         p4aghaBrIUAqhG7c6ymUY98504BQyOWAoFCQ1GKuichT1LJ7B6GNyIV4ZlzWxUjEbxgK
         nFjoKSMTjR79gGeCXPRSyHVUzwQg13tG6so38xlKsjRE5w2rSaNP4t2lPQAHDtaMU3ys
         CINQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xxOYorO+qp/Ux5uO45kQPwW5Xbfxtuq7/VNLX14n8IY=;
        b=3qLnioxfFtYikY0QiV48rUt7pprV54lxnE7flaHqYCOjZNsuvZRCVtg27OA6Slgy3w
         x4cE+9Lhg07QbMfCJVDYSl2n6l1BkkpLlqlsUzd/iUFEcHnwy+nb6/t93OhqIXYP/BVz
         kHyGd11UKsGyCM43l7zq53PXYXdneBUihlIBYGziOvoRa/vR3WSJBPvtQky7tMq1KVSX
         rPowzZNpujv2VeFZfbQuJgvB40toE8RwmsIepdj3AT18Mrr8548CxYBntdhJM6GucPm6
         y/z86xl3vwL/bldIPomA3a5yha61MUNMDyOlgvablF76UC3jxo5Ja4KURXcOz/LR86qV
         G0/A==
X-Gm-Message-State: ANoB5pkco1rBGT83JT3BN6FogR9ZY3b/6rlZ0+ufdjPYM1wLHunOEupv
        Csbd/jUTCtyDDmOH7PAk+Fk=
X-Google-Smtp-Source: AA0mqf568qIpfIQxac3Pe1jkRkBdQ5c3rksE6O0+Vmz9Szj0k+ikeq1ZEb/HZMhRgDxYmHuouJFY/A==
X-Received: by 2002:a05:600c:a0d:b0:3cf:77a6:2c2e with SMTP id z13-20020a05600c0a0d00b003cf77a62c2emr408664wmp.179.1668504699067;
        Tue, 15 Nov 2022 01:31:39 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id g13-20020a5d554d000000b002366e3f1497sm12078215wrw.6.2022.11.15.01.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 01:31:38 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next][V2]: sundance: remove unused variable cnt
Date:   Tue, 15 Nov 2022 09:31:37 +0000
Message-Id: <20221115093137.144002-1-colin.i.king@gmail.com>
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

Variable cnt is just being incremented and it's never used
anywhere else. The variable and the increment are redundant so
remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---

V2: Use the correct net-next convention. I do hope I've got this correct,
    apologies for being consistently incorrect in the past.

---
 drivers/net/ethernet/dlink/sundance.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index 43def191f26f..aaf0eda96292 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -1414,7 +1414,6 @@ static void refill_rx (struct net_device *dev)
 {
 	struct netdev_private *np = netdev_priv(dev);
 	int entry;
-	int cnt = 0;
 
 	/* Refill the Rx ring buffers. */
 	for (;(np->cur_rx - np->dirty_rx + RX_RING_SIZE) % RX_RING_SIZE > 0;
@@ -1441,7 +1440,6 @@ static void refill_rx (struct net_device *dev)
 		np->rx_ring[entry].frag.length =
 			cpu_to_le32(np->rx_buf_sz | LastFrag);
 		np->rx_ring[entry].status = 0;
-		cnt++;
 	}
 }
 static void netdev_error(struct net_device *dev, int intr_status)
-- 
2.38.1

