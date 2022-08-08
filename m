Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A9258CCD4
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 19:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244107AbiHHRkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 13:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243999AbiHHRkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 13:40:16 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E39BE27;
        Mon,  8 Aug 2022 10:40:14 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j7so11721425wrh.3;
        Mon, 08 Aug 2022 10:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b6NyspBynCgB0aqOOfv34vTT0VGyBHOTvX5leDaB4ow=;
        b=MvsqmM9fHt3qUcS9fwPL4xOfzpuvlux1xSaZ3z/EuZcMjlDK/rUaEFHboaRG6+l3Dk
         15cmqOsEt9LNE1rfXhWMMwjoonbFvQp7/wkPbrz2GpUJFqYLiqySEcrrP57qGY569l4D
         puy5WjLyjHi8qcg5GSxrP9L6CCfJo8b2srLakUreBShuuKLr1ilEY/e2s0SoYmHR7bMl
         RrhQ8H/FqBn+lhC/+hL3eIwm3rpNofCqnmaC9dMS730I2++JGcHXeMkBSg8zYpIPiuDo
         bcxNZSKPAIBsf9T4ulvLx/u3Bu8n2LHSW5oxfx3ZF4MZbjdhCxwlX1kIZPG/tDW/mdXb
         5c+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b6NyspBynCgB0aqOOfv34vTT0VGyBHOTvX5leDaB4ow=;
        b=DkrHOY7gUj94j/oo9Iz/OZrocPKiy2r3hHPYXetL4FJ0IM1qKU1YP07IgHH3cQnZOD
         W10BaBb0cvGs3TZgXwveW4HnFp4Lan5PCIwDWHrjKeS9PrGqAfTqaoguS5QAtrTUol/i
         vE/1gfRHtxNquH80Q4RZgTdXKhqs388qEkYYvajLQVZVh41W/6Ehb9dsXAUEZ1iNjIOh
         VsC5IK98zpB8UmRpk5ZbnQjLvtDB/rxHDN9xNyJyWsIzj30Ty2bWa4ScHIeUrkUOJ73L
         EZvDK4EWy/eLX2M6QhGsYLMlG9i0GhYKEBjUf2s56Mxwa4tc0pxVXzsYxBSv163vAogs
         1V+w==
X-Gm-Message-State: ACgBeo25WDx2VfBuu+VTpd+myX31Lh7Gkztq8EYnGysifY8E9tia0Frc
        frgeWC4Tds5TIrMnJVIeXsZmKtH/rN7bDg==
X-Google-Smtp-Source: AA6agR70oUi5lMFUJ8/LRlO+IVjjg44N56BMArjcJLorq3ALwlbUbo9GKUG9/yZv27A45inkzEgRwQ==
X-Received: by 2002:a5d:6102:0:b0:220:6382:eab1 with SMTP id v2-20020a5d6102000000b002206382eab1mr11908128wrt.539.1659980412635;
        Mon, 08 Aug 2022 10:40:12 -0700 (PDT)
Received: from snuff.lan (94-21-185-111.pool.digikabel.hu. [94.21.185.111])
        by smtp.gmail.com with ESMTPSA id g6-20020a5d5406000000b0021e491fd250sm12015621wrv.89.2022.08.08.10.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 10:40:11 -0700 (PDT)
From:   Sandor Bodo-Merle <sbodomerle@gmail.com>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Felix Fietkau <nbd@openwrt.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sandor Bodo-Merle <sbodomerle@gmail.com>
Subject: [PATCH] net: bgmac:`Fix a BUG triggered by wrong bytes_compl
Date:   Mon,  8 Aug 2022 19:39:39 +0200
Message-Id: <20220808173939.193804-1-sbodomerle@gmail.com>
X-Mailer: git-send-email 2.36.1
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

On one of our machines we got:

kernel BUG at lib/dynamic_queue_limits.c:27!\r\n
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM\r\n
CPU: 0 PID: 1166 Comm: irq/41-bgmac Tainted: G        W  O    4.14.275-rt132 #1\r\n
Hardware name: BRCM XGS iProc\r\n
task: ee3415c0 task.stack: ee32a000\r\n
PC is at dql_completed+0x168/0x178\r\n
LR is at bgmac_poll+0x18c/0x6d8\r\n
pc : [<c03b9430>]    lr : [<c04b5a18>]    psr: 800a0313\r\n
sp : ee32be14  ip : 000005ea  fp : 00000bd4\r\n
r10: ee558500  r9 : c0116298  r8 : 00000002\r\n
r7 : 00000000  r6 : ef128810  r5 : 01993267  r4 : 01993851\r\n
r3 : ee558000  r2 : 000070e1  r1 : 00000bd4  r0 : ee52c180\r\n
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none\r\n
Control: 12c5387d  Table: 8e88c04a  DAC: 00000051\r\n
Process irq/41-bgmac (pid: 1166, stack limit = 0xee32a210)\r\n
Stack: (0xee32be14 to 0xee32c000)\r\n
be00:                                              ee558520 ee52c100 ef128810\r\n
be20: 00000000 00000002 c0116298 c04b5a18 00000000 c0a0c8c4 c0951780 00000040\r\n
be40: c0701780 ee558500 ee55d520 ef05b340 ef6f9780 ee558520 00000001 00000040\r\n
be60: ffffe000 c0a56878 ef6fa040 c0952040 0000012c c0528744 ef6f97b0 fffcfb6a\r\n
be80: c0a04104 2eda8000 c0a0c4ec c0a0d368 ee32bf44 c0153534 ee32be98 ee32be98\r\n
bea0: ee32bea0 ee32bea0 ee32bea8 ee32bea8 00000000 c01462e4 ffffe000 ef6f22a8\r\n
bec0: ffffe000 00000008 ee32bee4 c0147430 ffffe000 c094a2a8 00000003 ffffe000\r\n
bee0: c0a54528 00208040 0000000c c0a0c8c4 c0a65980 c0124d3c 00000008 ee558520\r\n
bf00: c094a23c c0a02080 00000000 c07a9910 ef136970 ef136970 ee30a440 ef136900\r\n
bf20: ee30a440 00000001 ef136900 ee30a440 c016d990 00000000 c0108db0 c012500c\r\n
bf40: ef136900 c016da14 ee30a464 ffffe000 00000001 c016dd14 00000000 c016db28\r\n
bf60: ffffe000 ee21a080 ee30a400 00000000 ee32a000 ee30a440 c016dbfc ee25fd70\r\n
bf80: ee21a09c c013edcc ee32a000 ee30a400 c013ec7c 00000000 00000000 00000000\r\n
bfa0: 00000000 00000000 00000000 c0108470 00000000 00000000 00000000 00000000\r\n
bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000\r\n
bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000\r\n
[<c03b9430>] (dql_completed) from [<c04b5a18>] (bgmac_poll+0x18c/0x6d8)\r\n
[<c04b5a18>] (bgmac_poll) from [<c0528744>] (net_rx_action+0x1c4/0x494)\r\n
[<c0528744>] (net_rx_action) from [<c0124d3c>] (do_current_softirqs+0x1ec/0x43c)\r\n
[<c0124d3c>] (do_current_softirqs) from [<c012500c>] (__local_bh_enable+0x80/0x98)\r\n
[<c012500c>] (__local_bh_enable) from [<c016da14>] (irq_forced_thread_fn+0x84/0x98)\r\n
[<c016da14>] (irq_forced_thread_fn) from [<c016dd14>] (irq_thread+0x118/0x1c0)\r\n
[<c016dd14>] (irq_thread) from [<c013edcc>] (kthread+0x150/0x158)\r\n
[<c013edcc>] (kthread) from [<c0108470>] (ret_from_fork+0x14/0x24)\r\n
Code: a83f15e0 0200001a 0630a0e1 c3ffffea (f201f0e7) \r\n

The issue seems similar to commit 90b3b339364c ("net: hisilicon: Fix a BUG
trigered by wrong bytes_compl") and potentially introduced by commit
b38c83dd0866 ("bgmac: simplify tx ring index handling").

If there is an RX interrupt between setting ring->end
and netdev_sent_queue() we can hit the BUG_ON as bgmac_dma_tx_free()
can miscalculate the queue size while called from bgmac_poll().

The machine which triggered the BUG runs a v4.14 RT kernel - but the issue
seems present in mainline too.

Fixes: b38c83dd0866 ("bgmac: simplify tx ring index handling")
Signed-off-by: Sandor Bodo-Merle <sbodomerle@gmail.com>
---
 drivers/net/ethernet/broadcom/bgmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 2dfc1e32bbb3..93580484a3f4 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -189,8 +189,8 @@ static netdev_tx_t bgmac_dma_tx_add(struct bgmac *bgmac,
 	}
 
 	slot->skb = skb;
-	ring->end += nr_frags + 1;
 	netdev_sent_queue(net_dev, skb->len);
+	ring->end += nr_frags + 1;
 
 	wmb();
 
-- 
2.36.1

