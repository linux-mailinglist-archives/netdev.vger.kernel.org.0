Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF023A48BB
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 20:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhFKShT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 14:37:19 -0400
Received: from mail-oi1-f177.google.com ([209.85.167.177]:42678 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhFKShS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 14:37:18 -0400
Received: by mail-oi1-f177.google.com with SMTP id s23so6723203oiw.9
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 11:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ew9h/Q9nlpeVU8K44YxBsZe3engPpz6IH0eC1iNzyMY=;
        b=lDhBsDXr9rfZ63V0dMKSUwItGRhBj6HJjUA6NhezWSwCI3iRRqq+j2lTr+aJPws6/u
         W4QcX9vf0y4VFr4gCn4Twmyda1jLlO7zcwHxjuKUlJtZQG4xp2mqLLD+LL/0DjIr7vUC
         4S6Rkkp3TD5Y8XtOJXhmdZV4govGPPdeXN6SL+BHjV/xIyR4GJbrF+TeJLA+01Q1qEaV
         8/DP8jR9J0vMRgpZjB5Eorsl8yxyIQGE4nvMIG9VliUqRMhYt3u35Wd/PS8/lBaBwqSJ
         dqLCMpIVPHVVNG1EQ3NZNmuN9+a2j5bGtRY26jIpOsIPzGbXkfhaPTO/1Z2RTQzEUk6v
         0Nww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ew9h/Q9nlpeVU8K44YxBsZe3engPpz6IH0eC1iNzyMY=;
        b=JzqCT0jTO0ullt53pgYNYL6pqo2QY+CwMHIlt8gULLE5nIz1zt4CfK/ohgBUTKEi88
         mXsQbQ0OLJL+bdKb96Gufj2TpMV0cUbXAgh3u3bQ1fDsAhtzGKJ2vdqi6tykG0sLMw28
         zxZcmaLWhXGYbKHQOUMj7M3WNI2asQ5pSyi2yqGZtUysVVnAeRjE/sbRunW61ynmvVtP
         trMRQSxW//lBJaBkqxwOlaPA2XlFqI4cZ6ZUe7/qa7zGm8E1mQMMFu5JTdVzsGT5V5BC
         YDX79vwd3nzwcdA2ScI9HoLX04G87u3b/ME4lIFIMYj20QrPgh9u34aJoI95vkUphe3h
         W77w==
X-Gm-Message-State: AOAM530EaPAnAUVwpjCObGaXS5DDxteSk+Jhr3EViJMnRLNkz2mFrV28
        ymc8yDKMTmvA0y6tr11X13iAye3PnSuCgg==
X-Google-Smtp-Source: ABdhPJwHqibxiB4WeqLjtBjLifsXSS1XnNCTrXQ5FtSwDlh+4byy4hC+Cbqa3AiZik8HpnmzyPy+9Q==
X-Received: by 2002:aca:170b:: with SMTP id j11mr3377510oii.45.1623436444600;
        Fri, 11 Jun 2021 11:34:04 -0700 (PDT)
Received: from fedora.attlocal.net ([2600:1700:271:1a80::2d])
        by smtp.gmail.com with ESMTPSA id f7sm1276183oot.36.2021.06.11.11.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 11:34:04 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next v2] ibmvnic: fix kernel build warning in strncpy
Date:   Fri, 11 Jun 2021 13:33:53 -0500
Message-Id: <20210611183353.91951-1-lijunp213@gmail.com>
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
v2: suggested by Shannon Nelson to use strlcpy
    I looked up strscpy and it seems preferred to strlcpy.
 
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 497f1a7da70b..99eddb2c8e36 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4390,7 +4390,7 @@ static void handle_vpd_rsp(union ibmvnic_crq *crq,
 
 complete:
 	if (adapter->fw_version[0] == '\0')
-		strncpy((char *)adapter->fw_version, "N/A", 3 * sizeof(char));
+		strscpy((char *)adapter->fw_version, "N/A", sizeof(adapter->fw_version));
 	complete(&adapter->fw_done);
 }
 
-- 
2.23.0

