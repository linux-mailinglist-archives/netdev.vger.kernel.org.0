Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160A255200D
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243158AbiFTPMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243138AbiFTPML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:12:11 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E42DF01
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:52 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id g12so6165375ljk.11
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b2AKescmGlKNcLJ4HDilF0tkENV4Ss4sdm70D7RL07I=;
        b=rC8BmvECl/r/bwfRj5gY7fodnhLqkpD4/oDWpi9b3OqcVG5ZUJBUxXg0eHvaiSIWpc
         IT0YD2Adcjo4ZMc0x840TpCxLky45HTQiPIqUJydervFxSXgtIcppzWfcZJkhi72SNWK
         ouR22ZiEzbdEvSDFvDiye0JCgRhLdiHKKGP+ntSIGgjXXI4ldbxIpPo4P9c8iwDSBepI
         6pqwl4764R9eFoPbY170VW85np3DEMUShyv2BXRJ+7aUB/zHKPp5vSfT2bxjQzx95L3L
         xAeDffMP12clZd831cesX422+qx0HE/HsovbR9uhU4jPNhwKdQnrj9nw58DePoQtc9rR
         NbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b2AKescmGlKNcLJ4HDilF0tkENV4Ss4sdm70D7RL07I=;
        b=ReglDpnV5MgTv/wTENjDEpD60/+cnb3AsjUo2oLVmY3WpVrm5By5qis0sGQetrmdY4
         mIA6Q9sarVj85dtjS3pWXkJAo5bP2OLLvlooZs5i+3P5LYo4+Fdk9XVCAy2vXhJgYjur
         NoxO/2WwGaG9V/Goq1SuLNto8GmALELu/hgJJ1IBBJajXGXVICdqU+F5ZVor4K5mxkya
         F9ZJkr7fnSbFxEfXYxAF4oPyaBEltaiupRsykqrfjkmJuqV8PUys4w+ViZHn3MIIko4b
         41DqRCvwGY37zggNCf3tgMMKMt2SxZTpIc5CiUGoemXPuA4emn/g29B3R/p4ZCZgUXAw
         nX8Q==
X-Gm-Message-State: AJIora8MztptE2gBYHMqyIHRcW8qLntvzMYVW0DJegxaVA/KwQMo0Z4Q
        uN6CvVUX1QKq7nGFO0HM6x+2NQ==
X-Google-Smtp-Source: AGRyM1vbXLtUNjH0AC77POL9h5Lp/wi5D1FylX8FlzNfPcENyyC4zuvZ6/whXb8+g5bZ5gWNdMZBTw==
X-Received: by 2002:a05:651c:1502:b0:255:b837:a27a with SMTP id e2-20020a05651c150200b00255b837a27amr11499984ljf.284.1655737369056;
        Mon, 20 Jun 2022 08:02:49 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e19-20020a05651236d300b0047f79f7758asm17564lfs.22.2022.06.20.08.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:02:48 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        lenb@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH 04/12] net: mvpp2: initialize port fwnode pointer
Date:   Mon, 20 Jun 2022 17:02:17 +0200
Message-Id: <20220620150225.1307946-5-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220620150225.1307946-1-mw@semihalf.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b84128b549b4..cd2f113bb1a4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6869,6 +6869,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	/* 9704 == 9728 - 20 and rounding to 8 */
 	dev->max_mtu = MVPP2_BM_JUMBO_PKT_SIZE;
 	dev->dev.of_node = port_node;
+	dev->dev.fwnode = port_fwnode;
 
 	port->pcs_gmac.ops = &mvpp2_phylink_gmac_pcs_ops;
 	port->pcs_xlg.ops = &mvpp2_phylink_xlg_pcs_ops;
-- 
2.29.0

