Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC431582044
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiG0Goe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiG0GoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:44:09 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9688240BDA
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:46 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id d17so23661798lfa.12
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+d/aojT1TCgagMDA6o2QljnvpRxpeI/WOeBAtluw3O0=;
        b=KgE76jCoQUSTM3acGvNgdioxOEkcwqT3ATxQ/UKzncXpzHm99rgdQcDERpI7r0DfFz
         +kuBVu/gqktgjLZuKQpqo/2Dcsy3A/EbG4tmCU7vt1sShG6wE+bzGY7TwcJNFGCDzK0o
         9Byu/2RBM6kvb6w4suTzpCgxsv7cq7icKIz6y8yeCHzuM3qVjxrcIBl31wKX7RkywxI9
         nV1g914DXiCqEsTlKfNgLX1z6BmmnRP6qquAFA4vtuMwWQfeRBAPG975EnFuppbFuFuA
         M9enYRdLjp4FUaDYzrM6y1LuZp+h/IgPdOSmE11tyligi2Ud46aPuEDcjwnpRwhkl+Dy
         evlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+d/aojT1TCgagMDA6o2QljnvpRxpeI/WOeBAtluw3O0=;
        b=SBtfIyTIjMo1pq6fGoKYNH11putsMJv/mtfBolwI+GpxpC4oZHhG4ZP/HV+hEeX4o9
         BK1eLewEZ1sKOU3v8hQB/CwAlJTdJYILvn4fogCTbT97nu3REeX/CUnVXxR13wSPUia0
         UHs6CvOrP86T3F0hQ9XP61F74oD4ctldbgujKduaNlF0bBiwGjSfQBqJMKfNS+2L5wal
         fJbIdrqZAIMazOrXcOcQqGZv+BxMIDHk7DzzZfLLesoYLzRsss8KHSavmHSKIBmjvN9D
         hC/7MYsS2TbOwtkjYqI3DS3x+Nq0KwaB+/Ll+CsHrIyxSiTMmYUTmdx/LgGOXt7w61hX
         jCzQ==
X-Gm-Message-State: AJIora9c8aWwsjhr7KV/57gOn3xq7YObkW4UzgRWbtZgFrNuME+b2SMv
        hYBiF0LuCWbN/BePTvvIGe6kJQ==
X-Google-Smtp-Source: AGRyM1stenOwsAHzzcXaa1c51ami5gL6ZJn0lL6L3V+GXYFnR39RX0SCospuWmnJUC7p/bKt+S155A==
X-Received: by 2002:ac2:456c:0:b0:48a:8c7f:e332 with SMTP id k12-20020ac2456c000000b0048a8c7fe332mr4788547lfm.410.1658904224554;
        Tue, 26 Jul 2022 23:43:44 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id w19-20020a05651234d300b0048a97a1df02sm1157231lfr.6.2022.07.26.23.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 23:43:43 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH v3 4/8] net: mvpp2: initialize port fwnode pointer
Date:   Wed, 27 Jul 2022 08:43:17 +0200
Message-Id: <20220727064321.2953971-5-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220727064321.2953971-1-mw@semihalf.com>
References: <20220727064321.2953971-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation to switch the DSA subsystem from using
of_find_net_device_by_node() to its more generic fwnode_
equivalent, the port's device structure should be updated
with its fwnode pointer, similarly to of_node - see analogous
commit c4053ef32208 ("net: mvpp2: initialize port of_node pointer").

This patch is required to prevent a regression before updating
the DSA API on boards that connect the mvpp2 port to switch,
such as Clearfog GT-8K or CN913x CEx7 Evaluation Board.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b84128b549b4..03d5ff649c47 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6868,7 +6868,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	dev->min_mtu = ETH_MIN_MTU;
 	/* 9704 == 9728 - 20 and rounding to 8 */
 	dev->max_mtu = MVPP2_BM_JUMBO_PKT_SIZE;
-	dev->dev.of_node = port_node;
+	device_set_node(&dev->dev, port_fwnode);
 
 	port->pcs_gmac.ops = &mvpp2_phylink_gmac_pcs_ops;
 	port->pcs_xlg.ops = &mvpp2_phylink_xlg_pcs_ops;
-- 
2.29.0

