Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDEDE4DD260
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 02:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiCRBV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 21:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiCRBV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 21:21:56 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D07E2571A5;
        Thu, 17 Mar 2022 18:20:38 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l1-20020a05600c4f0100b00389645443d2so4103556wmq.2;
        Thu, 17 Mar 2022 18:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ow9WE/x0y21BF9BsskKcwPU9dRpux5T6k8fuA2iplUY=;
        b=bkbL5JcCQo9od9B8PDETuIDSCmJX4W+4yEy5eDK/EewHA/vnjY1V++LrJsoLAJNSWr
         t++U5vfBgEh7cc4xzofaI+Hr7fB8ujopEoSCFzaGGdE8yUMlSroMIAIF4w4VWMADGRBC
         9oPd32W+a7wG/yttwzLKjo1l+GQfc8fE+l6Fqc7aVMLogiHfwnYEWhLnCGTheo6VcRRd
         +OWFRvg+QBKgScA+rI+nKm5DqR/qb15I0JC8aOSVtTzzO7i3VYkqYE8zmeNCwRlYKeky
         kELehVXcLA/elcnqLI77ADQsB2txDYujDre3S+x3mwrm8UQr0ZlApYFBZeCvlTPfxPj9
         aTGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ow9WE/x0y21BF9BsskKcwPU9dRpux5T6k8fuA2iplUY=;
        b=gHOg2A4hK1fqJh1wOL9NZoKn/GpMXEBIlXM2L4T0uVEYq6E81V1VryIS4ge7nQyjo2
         PykYKftoyWDO+Pf52rt6Lcmbr42WDxLtn5O/RXF3vbyJ10sLm5PplmjXgOPH5k6rsE5S
         FOkjGZUj/kl+HsPzpUiu8JAqocbjiwxMsCszegcnUIHdEOnWalwigcO2J2UCWTJ5szkz
         Y8Vn+gJ05jpP/iaP5yNBfKEjj8aJluuVy84ZYczlUHdEMRVCY0Zl9nKjBSBE/v5fEmIR
         IX/L4C7+ZYIHChV/vv4e5t6NJtSy3d4o9/oRNbD5ML0mwBwGzAgVNO9DBO9TNAp71sds
         UDTQ==
X-Gm-Message-State: AOAM533PF8I6YprHNHytJMbZPRnKFNCRVlFYk9I6AHluMAV+IMF8U4fG
        D0j5ssTmbRPFroO9tDpVde4=
X-Google-Smtp-Source: ABdhPJwLPznoPhNWDA2mDexWJeLTMIRynOicTwbpMOkJYwaiy79gn+qAu0F/euVWJTGQzZS90MYo2A==
X-Received: by 2002:a05:600c:3b14:b0:389:e95d:75af with SMTP id m20-20020a05600c3b1400b00389e95d75afmr13523900wms.143.1647566437133;
        Thu, 17 Mar 2022 18:20:37 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id j34-20020a05600c1c2200b0038995cb915fsm13381888wms.9.2022.03.17.18.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 18:20:36 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH] qlcnic: remove redundant assignment to variable index
Date:   Fri, 18 Mar 2022 01:20:35 +0000
Message-Id: <20220318012035.89482-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Variable index is being assigned a value that is never read, it is being
re-assigned later in a following for-loop. The assignment is redundant
and can be removed.

Cleans up clang scan build warning:
drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c:1358:17: warning:
Although the value stored to 'index' is used in the enclosing expression,
the value is never actually read from 'index' [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index e10fe071a40f..54a2d653be63 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -1355,7 +1355,7 @@ static void qlcnic_get_ethtool_stats(struct net_device *dev,
 
 	memset(data, 0, stats->n_stats * sizeof(u64));
 
-	for (ring = 0, index = 0; ring < adapter->drv_tx_rings; ring++) {
+	for (ring = 0; ring < adapter->drv_tx_rings; ring++) {
 		if (adapter->is_up == QLCNIC_ADAPTER_UP_MAGIC) {
 			tx_ring = &adapter->tx_ring[ring];
 			data = qlcnic_fill_tx_queue_stats(data, tx_ring);
-- 
2.35.1

