Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0D2A72B6
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 20:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfICSrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 14:47:04 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43669 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfICSrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 14:47:03 -0400
Received: by mail-pf1-f194.google.com with SMTP id d15so1812702pfo.10
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 11:47:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0oInCZCVxRDHHNZQh2zohajIbQXd80RnFiXOh17nr5s=;
        b=po8fmDDfAyX0J7mKw5i3nGhJqgplMWsh7yvHMJOTo4QL9xiohPTIxTXmIS8Ik5Wkb6
         EkY3zYe5bbSw60G5xdh8s1sYG8CAZK/V7bGsBPiEwEnS2B+eKJcd1Wdhvxn6pzgrmJKa
         A0qsjTWJj+roUdGoUIzQ5pYm4hzXAsNXCvEcrilgFc0+1ksqmhSWEEwdLPlGn6alPr19
         DYJ1MQOKGSrzyFoEm7zswOdZRj2cCPkyi91/FMpdphrMWESVG6lqBNq8K1Ob5sQUu6bE
         bU3954Xd+TnrrCtAXc+MHmp3AMdxrdoGFovyroeInAWeErMGR6RXjc+xvTIclqDcaCF8
         vR0w==
X-Gm-Message-State: APjAAAX0EnZMXAq5vqHeWNoc98v+TEb3NOjTNDrr25yP+AAHdxbu8Ulz
        1v+fXj0/QT4e7B3NjXjhkHkDvxHZv78=
X-Google-Smtp-Source: APXvYqyp6PsxC1jX74zAlOl3wgnSC/9PRLW24Vcbklx8mzvvIBD9O83FyaKqeLaZGizKum9GXqavpg==
X-Received: by 2002:a63:5402:: with SMTP id i2mr31425861pgb.414.1567536422460;
        Tue, 03 Sep 2019 11:47:02 -0700 (PDT)
Received: from localhost ([2601:647:5b80:29f7:1bdd:d748:9a4e:8083])
        by smtp.gmail.com with ESMTPSA id j26sm2975585pfe.181.2019.09.03.11.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 11:47:01 -0700 (PDT)
From:   Moritz Fischer <mdf@kernel.org>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Moritz Fischer <mdf@kernel.org>
Subject: [PATCH] net: fixed_phy: Add forward declaration for struct gpio_desc;
Date:   Tue,  3 Sep 2019 11:46:52 -0700
Message-Id: <20190903184652.3148-1-mdf@kernel.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add forward declaration for struct gpio_desc in order to address
the following:

./include/linux/phy_fixed.h:48:17: error: 'struct gpio_desc' declared inside parameter list [-Werror]
./include/linux/phy_fixed.h:48:17: error: its scope is only this definition or declaration, which is probably not what you want [-Werror]

Fixes commit 71bd106d2567 ("net: fixed-phy: Add
fixed_phy_register_with_gpiod() API")
Signed-off-by: Moritz Fischer <mdf@kernel.org>
---
 include/linux/phy_fixed.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/phy_fixed.h b/include/linux/phy_fixed.h
index 1e5d86ebdaeb..52bc8e487ef7 100644
--- a/include/linux/phy_fixed.h
+++ b/include/linux/phy_fixed.h
@@ -11,6 +11,7 @@ struct fixed_phy_status {
 };
 
 struct device_node;
+struct gpio_desc;
 
 #if IS_ENABLED(CONFIG_FIXED_PHY)
 extern int fixed_phy_change_carrier(struct net_device *dev, bool new_carrier);
-- 
2.23.0.187.g17f5b7556c-goog

