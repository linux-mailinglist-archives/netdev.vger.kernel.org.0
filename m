Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E3A41EB1
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 10:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbfFLIMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 04:12:00 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34129 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730042AbfFLIMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 04:12:00 -0400
Received: by mail-lf1-f65.google.com with SMTP id y198so11362309lfa.1
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 01:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lFS4BBAAFXbjrbCxdYjYSGPzdbbXyO/GncmZQneFLcA=;
        b=qin+oZhf13sdSKn1SKVta6xNQYBa7ZCymdbgUUHhuXuNkSdmsnN+xPwGBDrKl1DDKA
         9eirix1ojbveQYt3vkTmM3znNupkTqQ8im6xurMFPDyRXfonbylfyKnt15BDcEym4lMm
         zbtDPDw9VXTMVRkSt4rI+FWRMj1Xt9LbcvKTqAjccyQz1RgkOT7KcWQMjwFvReihwunX
         5IId7kX7++BKRB2fbN9hvksAPw8W2FWW8C3fA5ZdlzJyuJ3b7B0RFoEVakEDyZ633Z8p
         MGnaSs3SJUvJl5KKJ4xQOKm/SeukK6uVQdR8m6q9ikusAy5ui1WToMXZfIqpBKQxclhK
         4grA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lFS4BBAAFXbjrbCxdYjYSGPzdbbXyO/GncmZQneFLcA=;
        b=kfCq48bbsOaUJBJ8wphIwq2HezmdyOGEPrlCEmt9jnKOq30haEynxwOr6xMwBdDWAZ
         vJq8yUNDf/xk5fsXrBY1rasM5M8TstRh2aipSA/tpiv09f4dE/ycU37l26ku0mvbN4LW
         ggOJ46ltnQoXg9864oxPf9x+YdGs6zQk4XCjduttJCJ9Akcu+dU0PdpuxXwoSjmK7MjL
         tnHTbOWSDhilw/k73w2Kf/CndcjXqvzAUBTn8EJbxI3bx6Mk8GVMBZmtii67wFQn5Weg
         IBJH8ct4W9ZM4q+EzECNBjCJQyXoZtq9Mjl034RW8qs6Q981MgW7nKtTBu4NAOmgDz01
         aGFw==
X-Gm-Message-State: APjAAAXGtfL7SCGTp4r9rjffP8D7KDO94HFDq98tUty/AJGZXrvmoPS8
        5mV1+FWye5RPsnDc3PkkRtlDWA==
X-Google-Smtp-Source: APXvYqzFkbRzv2cUwnOkrG34fAgQA5tXqMO36EKSSBfuGGn0JzJjJC6Fc/hggdqH7MAIezjdsxEYaQ==
X-Received: by 2002:ac2:4466:: with SMTP id y6mr13435120lfl.0.1560327118141;
        Wed, 12 Jun 2019 01:11:58 -0700 (PDT)
Received: from localhost (c-1c3670d5.07-21-73746f28.bbcust.telenor.se. [213.112.54.28])
        by smtp.gmail.com with ESMTPSA id z6sm2544076ljk.57.2019.06.12.01.11.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 01:11:57 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linus.walleij@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH v2] drivers: net: dsa: fix warning same module names
Date:   Wed, 12 Jun 2019 10:11:47 +0200
Message-Id: <20190612081147.1372-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with CONFIG_NET_DSA_REALTEK_SMI and CONFIG_REALTEK_PHY
enabled as loadable modules, we see the following warning:

warning: same module names found:
  drivers/net/phy/realtek.ko
  drivers/net/dsa/realtek.ko

Rework so the driver name is rtl8366 instead of realtek.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/net/dsa/Makefile                        | 4 ++--
 drivers/net/dsa/{rtl8366.c => rtl8366-common.c} | 0
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/net/dsa/{rtl8366.c => rtl8366-common.c} (100%)

diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index fefb6aaa82ba..d7a282eb2ff9 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -9,8 +9,8 @@ obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
 obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
 obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
-obj-$(CONFIG_NET_DSA_REALTEK_SMI) += realtek.o
-realtek-objs			:= realtek-smi.o rtl8366.o rtl8366rb.o
+obj-$(CONFIG_NET_DSA_REALTEK_SMI) += rtl8366.o
+rtl8366-objs			:= realtek-smi.o rtl8366-common.o rtl8366rb.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_I2C) += lan9303_i2c.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366-common.c
similarity index 100%
rename from drivers/net/dsa/rtl8366.c
rename to drivers/net/dsa/rtl8366-common.c
-- 
2.20.1

