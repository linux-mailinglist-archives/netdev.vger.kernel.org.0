Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8A44D1139
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 08:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344689AbiCHHnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 02:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344678AbiCHHnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 02:43:49 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380363878D;
        Mon,  7 Mar 2022 23:42:53 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id k92so7282673pjh.5;
        Mon, 07 Mar 2022 23:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=VMEKwBiD/5CmwbAtof2z8GMwXPO9FueLZUgikJXVEAk=;
        b=mxs5OdtHR3i8lji4+csXfWtvPd+Ajo3T2V05avIkmU6rDqFNnOiOkK3M3y11qlmZL0
         bDEdDKOHvihmcW0iN0A7L2RT6fTgRNxrGN2Mjc0rXIUGPoXRb4ZrgJm02EFy7mxdKbE7
         tL11ddv1JI1kBccAlq4+2P0AVhiEzFYsFRobQjogMRC9UdbvsQTxaIXRQ5AbKTJQyWjk
         FLtw8bso0FgAcjAEt531gugQxIH5jc13K3DZlHsbCpZBNZuibmyhQUyj96SMUc0dDdZT
         T0WKxdpqoze0O/LIFW95RF7p+IQNSAB7naPqMbqOKL+h9wqDUVGiV2kLWN44nZsPzD47
         nOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VMEKwBiD/5CmwbAtof2z8GMwXPO9FueLZUgikJXVEAk=;
        b=aDM2ABACy7CTfB7hvSIvqh8AlbM5fmpK4COkwjxio9zCjSF8Olj9Lzsz4MFUQQVRrv
         ZH9qGHI5RuHOvefCRKWRC/JE1aD9waMf8WxU2CTzmzswfAWhKnPNpt2Ng4WoGzFs/0py
         22h35h+xUVBRK4HaTuIt9+FLOHBRuqRqWyydw9X7xN6AMcpsLVedW1L5x/uuso6bOyhT
         mZP74j9nhlUt25MkyecIVcdqXGz7NAEHk/bqjZCdWvmmdhbjID7dD0/jIAgFUZZ+/UGA
         AWAkLaCbO1cBqFRh7ebRrsCs0pVWeFSEwpWE9DaocdMxGU4ndf3qCXiGspVBNpWJfKLg
         06kw==
X-Gm-Message-State: AOAM530sHqT3US4tBcxDg3Mf7R5Yc7Y7splRrsr3gxjlEqEpNQVOAEJK
        0b7lbW9ygLLOgGDBRDSqtyw=
X-Google-Smtp-Source: ABdhPJxCIJOSRGFFK97b/cGmwGW3M1OLE5e8Oy7VsJLf+f47DIdwZKPAToBOfmmwwjCSpEJTSzQFQg==
X-Received: by 2002:a17:902:d2c9:b0:151:e08b:1442 with SMTP id n9-20020a170902d2c900b00151e08b1442mr11277025plc.5.1646725372737;
        Mon, 07 Mar 2022 23:42:52 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id h16-20020a17090a055000b001bf5ad0e45esm1709772pjf.43.2022.03.07.23.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 23:42:52 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH] net: marvell: prestera: Add missing of_node_put() in prestera_switch_set_base_mac_addr
Date:   Tue,  8 Mar 2022 07:42:47 +0000
Message-Id: <20220308074247.26332-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This node pointer is returned by of_find_compatible_node() with
refcount incremented. Calling of_node_put() to aovid the refcount leak.

Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index cad93f747d0c..73cd0a4b7291 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -554,6 +554,7 @@ static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
 		dev_info(prestera_dev(sw), "using random base mac address\n");
 	}
 	of_node_put(base_mac_np);
+	of_node_put(np);
 
 	return prestera_hw_switch_mac_set(sw, sw->base_mac);
 }
-- 
2.17.1

