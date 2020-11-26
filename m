Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9212C5595
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390158AbgKZNcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390034AbgKZNb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:31:59 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEFBC0617A7
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:31:58 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id e7so2158961wrv.6
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rWq4EIZLBdjUFDSSQaVD1PvQUVhVWlX38rMGrIxZmlM=;
        b=V+CXrilhjwCj4T6b2gK0G4kHB+E9WqcoPWO5sHkAO0mYwGJDTwIKysOOcMPrQ7g4ta
         cgZqRm+8L40GIBDP4lC95hryiFriui4GgqEk74cX0RearQVcu/fZv0jdkebEovrh3S5w
         QOW0o82Y4quszQIyb2K9ghJYZIrSe3PXLdd0UL8taINAjjHr3PxIvAtZjMm9fwuvmIwe
         /pGplvmZGDlkOkwfcbkOgZxiY5LuPGM+0Y7Csf5cfKX1JDQKjhiTmMaZmmETXFKVnT/9
         L7qYG3+8mCXHRtjWiQzM1HZx/jwM0EtEMLuuWOCVIjV1GpewSlC8w+BMGxy7y1na56NG
         S+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rWq4EIZLBdjUFDSSQaVD1PvQUVhVWlX38rMGrIxZmlM=;
        b=Gs++ZQnWHUBEhSiqStg3IDneHkMC8Vobvf3xKjn8m5nxPEoigNTkL8/fn/wikAATFi
         ABJjyDDhYMAMIQ7gtjiz1dRuCANMMylfQ/+GWe/FwnSpiNKup45hcPjh3AhttsEail9k
         qKKEeVh2BWOoa6Trj0AS9WeJPEO9VCmPdSBXNE2Jk3dUcCUR+4dqhs8v2hJGSmgOWmgr
         JsPJ4hTdf20wfJpdRp4/56dVmLIa4e8xsRD+VX1Mq+dKsoKG/Wgx1tjmY8JhIti5Ml5n
         akIpxgm4H8EbUntV4iJXfZ+NHAEII4fdFPWyzJK43rvpY75FYqdiBrg/pK1snuO5z7te
         35GQ==
X-Gm-Message-State: AOAM531/HmQPXu4SIfXBSxjrEwR5e0ZaYGP3iDUS8cF5eTYUCfy1dMfu
        nDnxQweYxnCpTdLUkv8CH5l3ZQ==
X-Google-Smtp-Source: ABdhPJxVDvRwfMlc/6PaK6IE8voRoyyugVPW9/0sd4X8zJjnzLg8wrJ4D/LuejkqlVFimEpIiqR6Qw==
X-Received: by 2002:adf:ed11:: with SMTP id a17mr3919828wro.197.1606397517455;
        Thu, 26 Nov 2020 05:31:57 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id n10sm8701001wrv.77.2020.11.26.05.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:31:56 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH 01/17] wil6210: wmi: Correct misnamed function parameter 'ptr_'
Date:   Thu, 26 Nov 2020 13:31:36 +0000
Message-Id: <20201126133152.3211309-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133152.3211309-1-lee.jones@linaro.org>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/wil6210/wmi.c:279: warning: Function parameter or member 'ptr_' not described in 'wmi_buffer_block'
 drivers/net/wireless/ath/wil6210/wmi.c:279: warning: Excess function parameter 'ptr' description in 'wmi_buffer_block'

Cc: Maya Erez <merez@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: wil6210@qti.qualcomm.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 421aebbb49e54..8699f8279a8be 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -262,7 +262,7 @@ struct fw_map *wil_find_fw_mapping(const char *section)
 /**
  * Check address validity for WMI buffer; remap if needed
  * @wil: driver data
- * @ptr: internal (linker) fw/ucode address
+ * @ptr_: internal (linker) fw/ucode address
  * @size: if non zero, validate the block does not
  *  exceed the device memory (bar)
  *
-- 
2.25.1

