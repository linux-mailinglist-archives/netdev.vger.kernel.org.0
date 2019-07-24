Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFDC572D88
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfGXL2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:28:08 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37417 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbfGXL2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:28:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so20807699pfa.4;
        Wed, 24 Jul 2019 04:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lPJODdHXNUOCzN4xKheoilyC8acYqYcYpJHRoZ1WYTE=;
        b=Fu4nqhcYDzCc4ntaKb7ylasjdocx9Eikc8FaHxArxaS6uDPqCuh0EK2dtQE/solJ18
         gHBjVEBwBhyF93uBI2c8ePdVZyBMIDhosx2JlikkAUWUUliM+tALQ45lZaXeluBMMkNH
         iyIjEKS2SC7V9BTbIUtUlTvknLk70VBWxUi0K64JapboigZ5Sd2gO7cnai4ozu/V5JHN
         GLH72jKqthjH2jBTHL28YcJEhFc/A6XTRJ8mAijVaf/ZJgdmbT9ncnK8k4puUhpVk4zI
         6dokJZRsqmHgbyCbWNbv6rW2KZ3jY3nnlcrLVPIGK//+6DrK2LNPjBjFMQwuwtD2tUiY
         ywWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lPJODdHXNUOCzN4xKheoilyC8acYqYcYpJHRoZ1WYTE=;
        b=WMel2vub18xNkOTGA75I3Ic/xNbzU9hn7JUNUiads+IL4UfI/LKBMJb6EtKZa79RK+
         h5y4Yk6UyrghZF588eeP7XHmjvl3bP3kaF7vmvPKk90Y6CO6D9yg0OkZOLYXN9iIDqp6
         eBy+VVmKQ676JaMIKcMRCQOIAwnaiT02Qnsaffwo59n+uYAy1KyJalWQLOH0dfoFjNdJ
         ZQ4qgupPuZA670Lwv+ilmsi2JYjooyGuT7Nhko91Yz4M9Lo53Ddtx9097e0dRtkJRBef
         YwGwaGb2TTndTTFutLIEVUguZqC6jZH419AV/Wf38nOp/8SpvyQyqqaWOJ0Uy3GuyUTf
         bHKA==
X-Gm-Message-State: APjAAAVMos1gaQ9J/mHSzpy4UDJbTIzQjbPEYr9pqKieG/h90+HpxvIF
        ZAuQJFqBzZJAUJy8A8u3sZ0=
X-Google-Smtp-Source: APXvYqwjl6M6gzKYKVaYmJV0bxSI+Rd5/9Ly6OfIsh//DBqkDgM+0ehH9CSiJf3Or7y+qJZk8KikTg==
X-Received: by 2002:a62:8f91:: with SMTP id n139mr11098810pfd.48.1563967687615;
        Wed, 24 Jul 2019 04:28:07 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id e13sm58185441pff.45.2019.07.24.04.28.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 04:28:07 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next 10/10] rtlwifi: rtl_pci: Use dev_get_drvdata
Date:   Wed, 24 Jul 2019 19:28:02 +0800
Message-Id: <20190724112802.13620-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using to_pci_dev + pci_get_drvdata,
use dev_get_drvdata to make code simpler.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 4055e0ab75ba..7d96fe5f1a44 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2409,8 +2409,7 @@ EXPORT_SYMBOL(rtl_pci_disconnect);
  ****************************************/
 int rtl_pci_suspend(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = dev_get_drvdata(dev);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	rtlpriv->cfg->ops->hw_suspend(hw);
@@ -2422,8 +2421,7 @@ EXPORT_SYMBOL(rtl_pci_suspend);
 
 int rtl_pci_resume(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = dev_get_drvdata(dev);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	rtlpriv->cfg->ops->hw_resume(hw);
-- 
2.20.1

