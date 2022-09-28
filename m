Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58315EDEE3
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiI1Og3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbiI1Og0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:36:26 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DECACA35;
        Wed, 28 Sep 2022 07:36:22 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id k3-20020a05600c1c8300b003b4fa1a85f8so1126030wms.3;
        Wed, 28 Sep 2022 07:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=on2LHm8sMZDl8Rn8YgnIjYrpIKwexiS2g2UGbQmLvu8=;
        b=OtDX/zk9k72UiiyoEZTOBtXSIbHTwpwXMHkM5svnDUDNm1jcfl6ZQwOZ534YSnEvSt
         OCBgEpy3/OpsH9lodFAfkO26I5BMd0QgVRGewJtqk15FZ1xDfuMNHZnqVs2/XoirK7Yj
         IGNzCHhqpmHs0Bimr/c3Dh/NM+BmowVtUBVqOSaYpDnAqUVMPTgZDsH0sAwQqkePa7ox
         YbxJDfqbe62aLrK0IJFz0kJILSkDE+rJqXdhIbjm+j5LcvC1Zn9Q7QJERp59hd0O6vDP
         Im386L19K9TChfDPdWCrHHXzkv2LIp5aFqhPbJjaTVZt3bW8/IhoZEg5K2cl4DBClzby
         MKYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=on2LHm8sMZDl8Rn8YgnIjYrpIKwexiS2g2UGbQmLvu8=;
        b=0InD+AWKYbbsWXlVmRGQU+yOhK8vK1Hj5ZNzObCpdd6tk6FFkoFcZMmxraE8sIVUE/
         uEtu303xI60x871510ba6GOHMVwQ3y4Aa2jYHsubbmyzTjIKP62cFNxAG4JwkTVfRkkc
         2hN9aI4kAJXxR+bIjiefgApCgr3/TkA1HW/qEiAmfs2grnXv1DIO8B/2Fe0q2cQontf+
         1TG+i3zOUw97r8OVSEM9VUwALsBP+dp1ygtXN2JyGXLCUlvlbc9H7TmPTG4voc8td+20
         /jCxdmHh/MMZ/eHsigYy/Y8oq1E2AyHmvXUZTE81zspep1I6vPiaP2dyuZntKQ4lJM85
         tSQQ==
X-Gm-Message-State: ACrzQf3tkNMgLDDBPxPSiA5Tnjb+Lx5tMNkqr77Ml3dt5xz/XZybFn5p
        ubGwDux0TQrwepLbHq9g1FM=
X-Google-Smtp-Source: AMsMyM4jE7GOPkysZy5M8IOwFhjjMPYF3GUVzy8WQUB82HYJN1KpazDuVRTUIxOK8y6j9G8tTH6HVg==
X-Received: by 2002:a05:600c:1c84:b0:3b3:ef37:afd3 with SMTP id k4-20020a05600c1c8400b003b3ef37afd3mr6861272wms.155.1664375780454;
        Wed, 28 Sep 2022 07:36:20 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id g14-20020adff3ce000000b0022af9555669sm5132242wrp.99.2022.09.28.07.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:36:19 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: lan966x: Fix spelling mistake "tarffic" -> "traffic"
Date:   Wed, 28 Sep 2022 15:36:18 +0100
Message-Id: <20220928143618.34947-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.1
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

There is a spelling mistake in a netdev_err message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c
index 950ea4807eb6..7fa76e74f9e2 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c
@@ -7,7 +7,7 @@ int lan966x_mqprio_add(struct lan966x_port *port, u8 num_tc)
 	u8 i;
 
 	if (num_tc != NUM_PRIO_QUEUES) {
-		netdev_err(port->dev, "Only %d tarffic classes supported\n",
+		netdev_err(port->dev, "Only %d traffic classes supported\n",
 			   NUM_PRIO_QUEUES);
 		return -EINVAL;
 	}
-- 
2.37.1

