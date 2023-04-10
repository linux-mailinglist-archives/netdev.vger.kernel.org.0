Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91876DCE0B
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 01:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjDJX1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 19:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjDJX1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 19:27:35 -0400
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BAD26AD;
        Mon, 10 Apr 2023 16:27:25 -0700 (PDT)
Received: by mail-ot1-f45.google.com with SMTP id 39-20020a9d04aa000000b006a1370e214aso1322768otm.11;
        Mon, 10 Apr 2023 16:27:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681169245; x=1683761245;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tr9LLuBzpOy9ftur5sYz2tVpCadcYN7bj01HXP4dq28=;
        b=VgmYw3w3hhw53sr+VnHJFeiPcgK+U0XBectwGwkXi6r5LkKDqhn18d4oBVWtX8SKHu
         tiy5hIxEvgK2EGmWG90MdWzqnhmu3H2MMEwEln2fw66Hr6rYdonwyLZuik+krT3xj6Ld
         lx2gfmlgG099DC30/qgVohmw+x9TFytzgKkiQ/psJsTOlf7j8Lf2Lnmgz1+Pcd8BgLOf
         wzb0QHPJ0oVUwpwxZMy5alTrgj8vp1/FACLfkSlzz2YQ6CYn6MLN/7zrmLBPKQSV3rJf
         JGfyRlUAZdt4UVotMq7sdss84MuPQ39KTNliPkRcz1R8maEUxtWY6qoSdiajrgCsdGw9
         VaSA==
X-Gm-Message-State: AAQBX9fHWv4VdNrkNK+3LkEi9lyBnM6x1iDdeWl5xP+o/EggJYJ2r+Kt
        kBM48g9WH+UOYDe/UMNs+w==
X-Google-Smtp-Source: AKy350bzWNWCtm3fBi0rN/yd3/bsFmcLjSt1Xup5SQAd2LGIQPyrIjLJ6265a/Hm4ULgPSwmKb5RTA==
X-Received: by 2002:a9d:7b44:0:b0:6a1:2de7:bfca with SMTP id f4-20020a9d7b44000000b006a12de7bfcamr3561511oto.19.1681169244771;
        Mon, 10 Apr 2023 16:27:24 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id v16-20020a056830141000b0069f951899e1sm4857162otp.24.2023.04.10.16.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 16:27:24 -0700 (PDT)
Received: (nullmailer pid 1562062 invoked by uid 1000);
        Mon, 10 Apr 2023 23:27:23 -0000
From:   Rob Herring <robh@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ti/cpsw: Add explicit platform_device.h and of_platform.h includes
Date:   Mon, 10 Apr 2023 18:27:19 -0500
Message-Id: <20230410232719.1561950-1-robh@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TI CPSW uses of_platform_* functions which are declared in of_platform.h.
of_platform.h gets implicitly included by of_device.h, but that is going
to be removed soon. Nothing else depends on of_device.h so it can be
dropped. of_platform.h also implicitly includes platform_device.h, so
add an explicit include for it, too.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c     | 2 +-
 drivers/net/ethernet/ti/cpsw_new.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 37f0b62ec5d6..f9cd566d1c9b 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -27,7 +27,7 @@
 #include <linux/of.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
-#include <linux/of_device.h>
+#include <linux/of_platform.h>
 #include <linux/if_vlan.h>
 #include <linux/kmemleak.h>
 #include <linux/sys_soc.h>
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 35128dd45ffc..c61e4e44a78f 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -7,6 +7,7 @@
 
 #include <linux/io.h>
 #include <linux/clk.h>
+#include <linux/platform_device.h>
 #include <linux/timer.h>
 #include <linux/module.h>
 #include <linux/irqreturn.h>
@@ -23,7 +24,7 @@
 #include <linux/of.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
-#include <linux/of_device.h>
+#include <linux/of_platform.h>
 #include <linux/if_vlan.h>
 #include <linux/kmemleak.h>
 #include <linux/sys_soc.h>
-- 
2.39.2

