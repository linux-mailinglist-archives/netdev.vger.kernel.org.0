Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113582A28FA
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgKBLYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728549AbgKBLYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:21 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56DDC061A04
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:20 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id x7so14160094wrl.3
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rWq4EIZLBdjUFDSSQaVD1PvQUVhVWlX38rMGrIxZmlM=;
        b=x2UW17qR4c0kvXf/+l7qSJedHq1o8V2vl+ISBbFylFtvk2vUKWFFpdTfou1B8He+Q0
         c+EyGOB8XIf0ZxnaJhpyHhEd7SQSHc9aQMv4SMKIg/qaImxtSbTN6yHfSvo32N3zZtMk
         hHi62B9axAABq+Q0CPfoGb/WgA5XJaLhXqCdkiIKH25TgmhbwN9Dw+6Sxd4+QQlBdM1T
         PA2IqSCyqLG7ebal/2RFDCJe+6tyKItzL5qw9Yz70AjrsRf0DmARk71ZPY06Png1aycE
         /HyfpVe2jMrIWISBydC5ez8ffVW0P5z9PiFIqkhYIxziqjqKTD72SZTffs8zm4WgVA0G
         Jq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rWq4EIZLBdjUFDSSQaVD1PvQUVhVWlX38rMGrIxZmlM=;
        b=J58swIMF/CUUl6EVXnWWQRJhQzJnY5s65nKAylPGqCeju6zZt7Ip+iAxoA1Ly+zv6z
         cOgqBAXDD5igRvW3Q4mvpxYMtMn8+phEOlYQde6KYxnINExiFDH60GafRo+MSZ6HyoMX
         3KUJDZ0t7sPaYFmFxPcEjRijMaAmLn4o7h68vH5C4mSLODK4wAerLeyVjxv5UPTlZEZo
         BEsMAuCTZ0gqjtEyCtZk+0KiyBivzCPs0ssONbi4N4V09uYhcm5qUvM4D0RJbF3pIwIN
         ccZUfDf5GTng5oJ5BziEeOwG/yURZLXiycdxalZKf5/DF9ixVnBt0DAhA8eHbY6IBrAH
         Wzug==
X-Gm-Message-State: AOAM533N8zh1l6WOb6GRbN7Htl2U/md/pdwPwN1KSiAlnGRYcoT8S58N
        9Xl8xzEYo8nInqGySJs8uL44UA==
X-Google-Smtp-Source: ABdhPJzTs3Su8jafA1/QFINA6CLlvpL8pFXQ+/MTGhpyj+hXg91Kpda51zuYKkZ+k1gKCcylqLCg+g==
X-Received: by 2002:adf:82a7:: with SMTP id 36mr19854627wrc.1.1604316259365;
        Mon, 02 Nov 2020 03:24:19 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:18 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Maya Erez <merez@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH 01/41] wil6210: wmi: Correct misnamed function parameter 'ptr_'
Date:   Mon,  2 Nov 2020 11:23:30 +0000
Message-Id: <20201102112410.1049272-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
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

