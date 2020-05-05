Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0201A1C57EA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbgEEODP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729338AbgEEODL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:03:11 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA7FC0610D5
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 07:03:10 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z6so2491754wml.2
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 07:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=75HMiSxkO2iGkQyQ4GVIN4XRI1pdsKTRs1XUFo380Tg=;
        b=ezkHqFr+hwvoCUtODTn4bBFeBlly8HWvJiblO2xXxesyL1/DLZmDW9fWmLJy7I2RQr
         z4/XNFhycXjhViK/BtzNr49/HW22OGYzoaHSo6ikn+HA9TUGYGli4gQkHpqtEr2bTpYA
         yLqoD0FHi+vSoCHjSuXExIZJhGpSCZTAG0sV4/ATtjgUJmbj1QRCYqjecaYdkoQzH5+V
         8JoTWUO+/cc22OXSb3qfzo0V8+qGZc1XoFvMhJN3sR80zAAuS6l5SlPTJ5F5tMVyWHcn
         v3iKjJkQoYARwNCRLfmlHgh7MJVBQOH4mgE7mBdrIK5lphaZhbbBqRK6JZ4soEZ+4q0N
         QkcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=75HMiSxkO2iGkQyQ4GVIN4XRI1pdsKTRs1XUFo380Tg=;
        b=Pv0UOAjuBxe7PvPo5SFRbH2+qlYVCIDyJi18CQcnTt1msB9A+e3gKYP5xkbaB9erU6
         BlNf+eekv57YbC0NQIKS54Z9J1xtwGJsAIciZjDsoLFn5GhXfqpUJKSDe/zINamti9yF
         qk6GznmEuhWcA4MWYz7v6FtFmUtFhbWX5Cf1ZEIuWsrF9F5Zw6bfzQa0ESSAbzKIgQbT
         5jL4MDMIN/gJqcw65nkhhXQ+rQLCnhwYCTv6jyrfr6kkdZYPrh7TPkZjWzMElZEub4yX
         tT63tAt6smCYVd1dBprJLgYH7UJ/dPAs9RqO9mgiOZ/Ly8z+P0RbkfnEGAiwchNz58d+
         2nsQ==
X-Gm-Message-State: AGi0PuZg+oqkCli6pUzrsNElpDD8Idlhsg5OLE4xiSuhpICqwtUZRG2E
        nGCxmAO2CD8VSrsqy5zI0C9yvQ==
X-Google-Smtp-Source: APiQypInGXnY7PvS5QaUhdwBc8tu5ppIGoSSB01va3t8HjUU2Ty34gk2vT4nfcEtZEackOyvGp/6MQ==
X-Received: by 2002:a1c:a7c2:: with SMTP id q185mr3740385wme.42.1588687389697;
        Tue, 05 May 2020 07:03:09 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id c190sm4075755wme.4.2020.05.05.07.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 07:03:09 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 04/11] net: ethernet: mediatek: remove unnecessary spaces from Makefile
Date:   Tue,  5 May 2020 16:02:24 +0200
Message-Id: <20200505140231.16600-5-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200505140231.16600-1-brgl@bgdev.pl>
References: <20200505140231.16600-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The Makefile formatting in the kernel tree usually doesn't use tabs,
so remove them before we add a second driver.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/mediatek/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/Makefile b/drivers/net/ethernet/mediatek/Makefile
index 2d8362f9341b..3362fb7ef859 100644
--- a/drivers/net/ethernet/mediatek/Makefile
+++ b/drivers/net/ethernet/mediatek/Makefile
@@ -3,5 +3,5 @@
 # Makefile for the Mediatek SoCs built-in ethernet macs
 #
 
-obj-$(CONFIG_NET_MEDIATEK_SOC)                 += mtk_eth.o
+obj-$(CONFIG_NET_MEDIATEK_SOC) += mtk_eth.o
 mtk_eth-y := mtk_eth_soc.o mtk_sgmii.o mtk_eth_path.o
-- 
2.25.0

