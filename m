Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E6447A885
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 12:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhLTLVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 06:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhLTLVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 06:21:41 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83BDC061574;
        Mon, 20 Dec 2021 03:21:40 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id t34so9370083qtc.7;
        Mon, 20 Dec 2021 03:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MBczxJm3I08jjd/QHRuYvFh7bIEcTce0GBizMJSEP8c=;
        b=d1gSa9qhkemwcKujwOGSI9dzt9WFOOqxeh34+7xeJrowWMfJVVYGDxUvaP/s1dXTde
         WEcPWmAe83rq8rFEyyYCc6YoWWFFE/5X0pZJA3vYAnfeNrF6N35X6aJx//4G2p3qGxwO
         ZU0sOO9ThRkOZm1LMc4pmmonXPEO9LsfXYD40aYL/htTXNbf4nTpCjycyS+djxW01mmp
         /3dMO7BkFW3cxjmIHTMPSkqgbJwyYVVe9zCJrnTl0yHrIwH1C8juqbiAXRDuG4LOoTJ7
         wWftqOiYGjzblReWdiwVDSA+wMFvDKI5ZOj8dyN8Y61aTtUnwVa57sAFFxOX2h8b3kLI
         dNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MBczxJm3I08jjd/QHRuYvFh7bIEcTce0GBizMJSEP8c=;
        b=mqqkr4gMa+i/vDEyntNHolsahJYwLpXrhhompkw00K5o1ujdqvu1HEjlWmRZ9jGF7O
         7onl6O4ryK3+73KN/ZMW9e5wI0rMgStFI6e0lVoVU1bmYvkhz5kh8RZ5ljAERn6iKvPd
         Q6pZGFEUErAUkyCoy4ih25/9VXhhPCpMFapD/5cAVB3Zs2tSp4duSIKtzknYtELy/9Vk
         vAyv4wHdt4NVxvbz74q36panu39P6Tq+JIe4TDjOsUWRXSqvrzGXj3jXqluAuDpUG+Iz
         qRW2mGAxKUoTkTncO0Woa9Xjg1Y/WA5MXEq6j70+DCfZzgjt9R6B25B7+AjXWafY94wR
         NaPQ==
X-Gm-Message-State: AOAM530Q3yZ7YydMS3douYooILZRABGi+wBm8hHNS+WCNHf/xkPv1NjJ
        9tS4DLWU0DoEkpwEW0NJ5sVWNjro3FU=
X-Google-Smtp-Source: ABdhPJxiHawe3//spU8yo9RWOXKIfuZi4wTgQUI6t9d6+bgFUY8WNgGtZAIp8IuoiNwyWSV176A+3Q==
X-Received: by 2002:a05:622a:170e:: with SMTP id h14mr1108255qtk.479.1639999299996;
        Mon, 20 Dec 2021 03:21:39 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id o21sm14724301qta.89.2021.12.20.03.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 03:21:39 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] ath11k: use min() to make code cleaner
Date:   Mon, 20 Dec 2021 11:21:33 +0000
Message-Id: <20211220112133.472472-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Use min() in order to make code cleaner.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 2b4d27d807ab..083856034136 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -614,8 +614,7 @@ int ath11k_wmi_mgmt_send(struct ath11k *ar, u32 vdev_id, u32 buf_id,
 	u32 buf_len;
 	int ret, len;
 
-	buf_len = frame->len < WMI_MGMT_SEND_DOWNLD_LEN ?
-		  frame->len : WMI_MGMT_SEND_DOWNLD_LEN;
+	buf_len = min(frame->len, WMI_MGMT_SEND_DOWNLD_LEN);
 
 	len = sizeof(*cmd) + sizeof(*frame_tlv) + roundup(buf_len, 4);
 
-- 
2.25.1

