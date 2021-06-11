Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EDA3A4623
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFKQHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhFKQHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 12:07:32 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C31C061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 09:05:34 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 102-20020a9d0eef0000b02903fccc5b733fso3628562otj.4
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 09:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Ol9LmHX2jY59Zf0Udzv9fgb6HaOvJq8tTOEhATtJBQ=;
        b=eu1wbg4OE9zp1gAi46aS3nctjtOBc1No6o69K2tqZzD7kaRvn20zu4EEJ/qzsd50U+
         A/IxHP8+zy4Bm6ImtEEazonoZiUND9Ow1ULBjzq+t5Fo3SuaHyyiy2KCST4YYz9IzPQg
         TgQNWLCXutjYVMSNwHvo2iqkVOYiBWlQVaZ2kaSmVW7z+0G51Wh6FbRTD9g2RwmyzpZr
         bfItvC16LrvQbD81FW6sWN3rmU0HD1yJ5rGCShP+vaRIDyXE5IW6HdJffwSip0v2VRmo
         AtQ470Ov0gaWPCjeHOiu/htTXaTtdgCt7dvHw0gwTOC/gCau6/mqx6VPNCsF9a4frqDb
         Bn0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Ol9LmHX2jY59Zf0Udzv9fgb6HaOvJq8tTOEhATtJBQ=;
        b=EokbIjshahYT70CkxH06GYpeL9dSLFN2C/QO6pS25I/UHnBEeFq0t3a7W3jTnmZpe0
         hop37fSHr6SfxbEprpsUKuaXODDqV8AJtM7KWVQADAN/THjuQQ+llC4S7+RsZSKemw95
         3vkEsoO/AtKQn18Ekl1tYoonmor6jiTWfdPwDkhWFUapm2qe41MnX15GPliYmUXo05ci
         4npNQdgmApYVE9/mYRaDfgUbOBfRCBNkoVYh2gBTvKVkOlSjHuiRtzVVfF/jMVvOTh5g
         2ROGOpwe0fZyBad57iRnGbhLDw5begB//PgrjrDDfJfhfvLska9n853x7RpoBlNvs41V
         Cb7A==
X-Gm-Message-State: AOAM533G2jpAkGLC2/pY0dPfnl4zRr9vnytKdtTx1703OHjdjVx9ayzC
        izST7u/3+Bt6eHY2TK4vACi/d5l6dAio8A==
X-Google-Smtp-Source: ABdhPJyT+4BExUuWDZtizDT3dZkkp1oUYjQOFKEP0EBOVoWYqSB172QnaOjPmAvMsHNTKsc5CK67Hg==
X-Received: by 2002:a9d:66d9:: with SMTP id t25mr3769260otm.217.1623427533921;
        Fri, 11 Jun 2021 09:05:33 -0700 (PDT)
Received: from fedora.attlocal.net ([2600:1700:271:1a80::2d])
        by smtp.gmail.com with ESMTPSA id w186sm1258872oib.58.2021.06.11.09.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 09:05:33 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next] ibmvnic: fix kernel build warning in strncpy
Date:   Fri, 11 Jun 2021 11:05:29 -0500
Message-Id: <20210611160529.88936-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/ibm/ibmvnic.c: In function ‘handle_vpd_rsp’:
drivers/net/ethernet/ibm/ibmvnic.c:4393:3: warning: ‘strncpy’ output truncated before terminating nul copying 3 bytes from a string of the same length [-Wstringop-truncation]
 4393 |   strncpy((char *)adapter->fw_version, "N/A", 3 * sizeof(char));
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 497f1a7da70b..2675b2301ed7 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4390,7 +4390,7 @@ static void handle_vpd_rsp(union ibmvnic_crq *crq,
 
 complete:
 	if (adapter->fw_version[0] == '\0')
-		strncpy((char *)adapter->fw_version, "N/A", 3 * sizeof(char));
+		memcpy((char *)adapter->fw_version, "N/A", 3 * sizeof(char));
 	complete(&adapter->fw_done);
 }
 
-- 
2.23.0

