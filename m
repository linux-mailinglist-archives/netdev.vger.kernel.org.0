Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15F65E870F
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbiIXBxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbiIXBxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:53:49 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF73109508;
        Fri, 23 Sep 2022 18:53:48 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id i3so1188116qkl.3;
        Fri, 23 Sep 2022 18:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=mEOjjinJBS1qWUuCIBh6UgT1Mu6ffVpl8EY8geKQjdE=;
        b=EMH7sxk/K27lQL6ZB5kjAnloR9i2W8DN1+MrlObnr2w/1Nn7QWI/vs/K4qQV9nuRjS
         9WQPaTwntilZ91gEWZfzLgSWaTSoEzJUZz9JOIRPsKCEVheQjc2DVpRNT1+6w+P0G6AC
         1os4ARjc1OxpAm1gnvqbSiiAp8qfo1FIwZIPbCQm88IYKVlgUN8YCht6uZPtGrmpjg3B
         eVnJGs+lTFUZEnRDX8gNugMGJViInBkhLMAUHqpSsAg/IiTpNBzx6NLT4fCKZE6HwtSr
         gdzopsNu611sZdca9+ZgrVd9PRzVZVJYQftlC+8TJPvZpFLDt2shXWe76OLecwJvXdeB
         ETzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=mEOjjinJBS1qWUuCIBh6UgT1Mu6ffVpl8EY8geKQjdE=;
        b=cs5cvsrtM+OCJyhjjegpIMhF8vxGKmcWIDgb5fD0OlWifEANYe3h0Wb5Z1qInynDfL
         36USeek5u6ubDLiCOv9+I2M7rsgIW6Db9qVUj63wVM7RtgGvLSUtK/Cel0xWUTEtBFnF
         Hm8wILFQh056NK6vVzywC3/pDKo+RWrB/hTLo616EG2pK7DTeHPu3JrxcYY7jNTZ/X4C
         ps6UZP7V5Yjg79ArwoIw+mlRNNjfVEpZFht89aZZl7utDDDuYCQBrStfUjTM/eUcuG/n
         n1EmBlPw1l2+hhL+vZX/RIMxgORcSV/vKCkATZ1da0NqESVRt/2+CQ7VBrY4c3/XNURs
         tU0Q==
X-Gm-Message-State: ACrzQf3KGHVpcaoLWS1tEcbeRvXC3w/Fd+eb72TN5eeuMJ/0H3ZiqptY
        5uY5Kg7UQFhcmuNJ/hlQe5c=
X-Google-Smtp-Source: AMsMyM5wRuds6mIcmGqNHQHGC/IcVsmZJD8v2ZeMHicGQuWZDTawbS3y3YvaSADXqlNUbWxLT3fyIA==
X-Received: by 2002:a37:65d0:0:b0:6cd:cce9:bd71 with SMTP id z199-20020a3765d0000000b006cdcce9bd71mr7590594qkb.353.1663984426818;
        Fri, 23 Sep 2022 18:53:46 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id o13-20020a05620a2a0d00b006baef6daa45sm7291133qkp.119.2022.09.23.18.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:53:46 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Zheyu Ma <zheyuma97@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v2 03/13] sunhme: forward the error code from pci_enable_device()
Date:   Fri, 23 Sep 2022 21:53:29 -0400
Message-Id: <20220924015339.1816744-4-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220924015339.1816744-1-seanga2@gmail.com>
References: <20220924015339.1816744-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

This already returns a proper error value, so pass it to the caller.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

Changes in v2:
- Remove space after pci_enable_device

 drivers/net/ethernet/sun/sunhme.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 7340d0f2ef93..63a7cacd8286 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2940,11 +2940,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		strcpy(prom_name, "SUNW,hme");
 #endif
 
-	err = -ENODEV;
-
-	if (pci_enable_device(pdev))
+	err = pci_enable_device(pdev);
+	if (err)
 		goto err_out;
 	pci_set_master(pdev);
+	err = -ENODEV;
 
 	if (!strcmp(prom_name, "SUNW,qfe") || !strcmp(prom_name, "qfe")) {
 		qp = quattro_pci_find(pdev);
-- 
2.37.1

