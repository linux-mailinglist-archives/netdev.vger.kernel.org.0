Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6EE2EA915
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbhAEKo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728699AbhAEKoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:44:55 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9317EC061574;
        Tue,  5 Jan 2021 02:44:15 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id q5so28136026ilc.10;
        Tue, 05 Jan 2021 02:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aby+ROLVQe/j+JcF7PcokGiqYcXue3VyQb2cq2QP36E=;
        b=gAp62h+pW8XjZy1mLWZZh7DeMhKW4dwYVNTP3ESLQWUAQyCLJ2qAeQrIFuDrv92U+D
         OYYvsIfzmT2yzNAKDF4LlqKXwJyYQJ+k5d38p9v+QTCpJuWkyQwmZPf/jd6h9JIiBCIJ
         tMIxOa5RJnx6x9/4a6IZ1wXB9hrLN2wdxoSyFVEcJrflXoZzeFBS0EKJ4CzjjSCOniu4
         Ya2N0ECQZuGo0bOKPLZCFCWgukC4kHSAhtP9uMu0rGJc6VEv1ab47tU8gzp5XUXCYn+H
         RTxUbnPb03gf12apRVTJ+sgvWhA7HWOjdzZJkS5xN5re5XYzT3Oj8qPtAAvSiPmHwgHd
         mhOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aby+ROLVQe/j+JcF7PcokGiqYcXue3VyQb2cq2QP36E=;
        b=R2t+Crwe1acjCc1d/4VaI+5kRt8IfzXZRJsKtDbbEJy8iEaAttr1OM0rPuAxb32QRX
         Yle/COJ1LzWmuKTXmxVB6KomLawrg9YWvTgF+G7szR+E1w+dvMb862QMVwtzIVoGsOk0
         AnjAFF2yTQhXn27hBlW4jTLYcByImUiQTw9bphZ0iSUaOqd6igw+FURLxFjDKotxQedL
         +Ut4YBhGq0MZ5/YcyiCqx3N7MTzPJMEuaZX/cZBXp4sMd/gLOksZ2Q5AzN2vSONABoWe
         Zhn+OdXz6Wjh77/nvjcQ9XB3bXTdqDbn6TXTLg9KBNopoVNqW6CVLQhWtHvUNb4WJjwE
         9caQ==
X-Gm-Message-State: AOAM532vAe4H+9krNy8UkCLMMywy6waHmkh2EK/MMkwMFMdXYnwTjSVq
        TM/QKJDCg4pseH+UgRA46R8=
X-Google-Smtp-Source: ABdhPJw5sCo41NxSJ0Cnavo5ZcJU1fgWGGrzaa9kwzbPx/DpC0JvBNiB9+no9NUxhMpf+BP6DDtDcQ==
X-Received: by 2002:a92:c50d:: with SMTP id r13mr72463098ilg.160.1609843455092;
        Tue, 05 Jan 2021 02:44:15 -0800 (PST)
Received: from localhost.localdomain ([156.146.37.136])
        by smtp.gmail.com with ESMTPSA id f3sm42003691ilu.74.2021.01.05.02.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 02:44:14 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net,
        christophe.jaillet@wanadoo.fr, zhengbin13@huawei.com,
        baijiaju1990@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: rtlwifi: rtl8821ae:  defautly to de-faulty ,last in the series
Date:   Tue,  5 Jan 2021 16:14:20 +0530
Message-Id: <20210105104420.6051-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/defautly/de-faulty/p

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
index 9d6f8dcbf2d6..0e8f7c5fd028 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
@@ -970,7 +970,7 @@ bool rtl8821ae_is_tx_desc_closed(struct ieee80211_hw *hw,

 	/**
 	 *beacon packet will only use the first
-	 *descriptor defautly,and the own may not
+	 *descriptor de-faulty,and the own may not
 	 *be cleared by the hardware
 	 */
 	if (own)
--
2.26.2

