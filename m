Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763B96299B9
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 14:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiKONKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 08:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiKONKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 08:10:08 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408222A715;
        Tue, 15 Nov 2022 05:10:05 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id w14so24158901wru.8;
        Tue, 15 Nov 2022 05:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jNJqWVNJspyPRmHDknqv5wE+zsI2INSRF91ITC6GXn0=;
        b=XxhSAxfD3ihHh+V7G+u3cBIqhSGHuGYYM+hYM6avQbw/d+mxiIUD7ZItLOaIe6/pWG
         GGOVsRjnWBNfsH8vl5kJ1yMymrZbF5+hn/cW/19WEHiQer/M5bTNUbsnMrEHUePZ64fy
         h0eqKB7Z2OVGAiiAJG1Jk0jkafiuCH0sybnZEa0TNgDJ5vKY+XfzxGMrYR+2rEaYSBYO
         rl8pv20JkOfEpOex8WHg2pCmpkcKGHQbYj7GVmieEniilLEt60GXSDKm025+1cTs7qGC
         H5g2ue/q7G+Oz9NRYTqLiMBsAAsuSdvdh+qd7LueLhnCmKoxjUvOrzaD8KOVajJOQEEe
         ZRkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jNJqWVNJspyPRmHDknqv5wE+zsI2INSRF91ITC6GXn0=;
        b=ctGajIJiElZd0I5GFFKkMFuACKygqIzND/HuLDnFCpNrsQdPWVevlW4fSAlk/EWzuh
         KLoS6KsEZe1rHWgdzeyW1txs0pPMLH6+vpGxDjcxVBscUSh8W/PqdBdnxgYT7mcfnaE9
         I7oIvSPltuWssm3S/F8vQm/Oq/Yi0csJ/G7d02Khgrtv8Z3QEEm6mvEd9Z3vxBRrtoTD
         hrumImIgyAc1vGJ0m4eGlXrWZGJqjQDWCEKXjLOIUVnxOC9XhG/vMB9iH/Ti3SXJ1GAg
         Qk7+wn66WEiPQBRylWfXoftDZJwVXWiQmLv/ROlRvijJlAdSp9MKqPDD1yKMFGsrswQH
         18yA==
X-Gm-Message-State: ANoB5plsY1MCJwq56BHnVCa2n2cUKebW9v2Qr12m+kyFkl5WtnwofyrZ
        MQp27217HOj5sc+nwLhGNzOWxqdGfWTlgg==
X-Google-Smtp-Source: AA0mqf7ZXhHT5P72C3QiHmY+SAs84KALSE3C8EKTBpnBIbUbHJF2tQAI3oO83HQkqxMl15gU2hxhTw==
X-Received: by 2002:a5d:43d2:0:b0:236:4930:2465 with SMTP id v18-20020a5d43d2000000b0023649302465mr10762553wrr.235.1668517804260;
        Tue, 15 Nov 2022 05:10:04 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id r7-20020adfce87000000b00236488f62d6sm12536841wrn.79.2022.11.15.05.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 05:10:03 -0800 (PST)
From:   Dan Carpenter <error27@gmail.com>
X-Google-Original-From: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Tue, 15 Nov 2022 16:09:55 +0300
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: ethernet: renesas: Fix return type in
 rswitch_etha_wait_link_verification()
Message-ID: <Y3OPo6AOL6PTvXFU@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rswitch_etha_wait_link_verification() is supposed to return zero
on success or negative error codes.  Unfortunately it is declared as a
bool so the caller treats everything as success.

Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index f0168fedfef9..231e8c688b89 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -920,7 +920,7 @@ static void rswitch_etha_write_mac_address(struct rswitch_etha *etha, const u8 *
 		  etha->addr + MRMAC1);
 }
 
-static bool rswitch_etha_wait_link_verification(struct rswitch_etha *etha)
+static int rswitch_etha_wait_link_verification(struct rswitch_etha *etha)
 {
 	iowrite32(MLVC_PLV, etha->addr + MLVC);
 
-- 
2.35.1

