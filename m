Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DAF5A80EB
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiHaPIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiHaPIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:08:13 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574A05300E;
        Wed, 31 Aug 2022 08:08:12 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso21316199pjh.5;
        Wed, 31 Aug 2022 08:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=iWFIf9ElN8TxtCnTHIToMg3ZbWgSB5UvML/M3/3xtpY=;
        b=AA+qAmQ2Ihx4N9w/DmqJddeCttTFT+CLsKZLA4nehDNwHbgJs4w7dJ+UGuikeI2lPo
         W2bYWhIxmfwwKIy66KMDNSFVJv3JqUdsG0mhoyR60wNfWaU12l2mbMi3rRfjaqUVIBzB
         KwGnYujaZ+zTWF0Ray6rQuyEJl1BNVA8QXFUwxaaAp6EZXv8d1LhLK5BWQKKSVksrKlx
         MBSowfIBKcHg3sJE8XfTmEIyGSkaZfNzJDNuSeaGE6y5x/VO/A146jOLlPb3DMBSDPzk
         G1mCd4ZVAGz33rctvKBd7IMlTJg4bs2Rqv4cOF9XJORiECUKZi5Lw9DcCBPscxBO4gZP
         p5bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=iWFIf9ElN8TxtCnTHIToMg3ZbWgSB5UvML/M3/3xtpY=;
        b=OlKO51/yu+Hy6uk1cnxIHipDZSGQt8zBoSJeeJ+dIQWTnT4ofiQvjy/pi0PEdDrsUz
         gNlA6v5iKWhhrpUEIWpJTvusU1Cu0fRQHLnPdtlFYfAz0Tauki0DMpOXeaFr2PuRgZ4f
         9a8/Sd01fwCfVsYuWbzFfeJ3dq4NJPEwxkRqMQkY+GX3xon3D511LddsgySh4JdYEWle
         zXzRwP41DKbzApFrH0Px0snr0uJKhl3AEcIUvDppUJBFsKK9P4r/JXi4cnusH0NWKVVX
         3maYexdE4NtSeCpBnkmPf5ERr0nh4aVmZHm362gfMP0yVaDUR38EwlCQuFyDk5SpsnAQ
         oZQg==
X-Gm-Message-State: ACgBeo1zkmCPq1W+6DbnlCrpbL7CPsYSJqXrcUnI5+xTUVdnExhTlQGx
        PVRLf5DZZUl03ET8eQjzzJk=
X-Google-Smtp-Source: AA6agR60nDiAOlc9wA/x+4MWn3ZYLxOP+67enaD2S66jhA3wcrX8mg6SfolvUHEsbF6MdbnvYWbJXA==
X-Received: by 2002:a17:90b:4a05:b0:1fe:289a:3ce1 with SMTP id kk5-20020a17090b4a0500b001fe289a3ce1mr3713139pjb.96.1661958491711;
        Wed, 31 Aug 2022 08:08:11 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s5-20020a17090a6e4500b001fa9e7b0c3esm1392289pjm.41.2022.08.31.08.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 08:08:11 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] can: kvaser_pciefd: remove redundant variable ret
Date:   Wed, 31 Aug 2022 15:08:05 +0000
Message-Id: <20220831150805.305106-1-cui.jinpeng2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Return value directly from readl_poll_timeout() instead of
getting value from redundant variable ret.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
---
 drivers/net/can/kvaser_pciefd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index ed54c0b3c7d4..4e9680c8eb34 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -329,12 +329,9 @@ MODULE_DEVICE_TABLE(pci, kvaser_pciefd_id_table);
 static int kvaser_pciefd_spi_wait_loop(struct kvaser_pciefd *pcie, int msk)
 {
 	u32 res;
-	int ret;
-
-	ret = readl_poll_timeout(pcie->reg_base + KVASER_PCIEFD_SPI_STATUS_REG,
-				 res, res & msk, 0, 10);
 
-	return ret;
+	return readl_poll_timeout(pcie->reg_base + KVASER_PCIEFD_SPI_STATUS_REG,
+			res, res & msk, 0, 10);
 }
 
 static int kvaser_pciefd_spi_cmd(struct kvaser_pciefd *pcie, const u8 *tx,
-- 
2.25.1

