Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94BA488CF9
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbiAIXJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235684AbiAIXJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:09:24 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D894DC06173F;
        Sun,  9 Jan 2022 15:09:23 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id l10so23447419wrh.7;
        Sun, 09 Jan 2022 15:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wPKxhx2q2jFWM/iTPcuC0q3uyZMxRL+DFdkOTJpxQpo=;
        b=KHldNEm7dvXtVKNXy5NlD2dhVd5mD3/YMiy32sXTM/M1vKQoWtl+PfTeaUoXJMsYPX
         Ie27hhsdRfTkdDiUjqHEiofWJAPYPya2LhydpxS+lS6QSDY0Xxm1jB6Bb3+0YKT3Ruiq
         hkrnXteJ5KB7BHYG4KHquk/R06/salx8RMRHNqN72PX76sg/K3zf9F/gFSmz3+Ud0rgi
         SyxGAYUujsdTocQWL0hmjpn1tkhBwnDcR+fIliN/JErwP2QlqkoThhH2l7Zx99h7unJi
         nl4uRzASe4/00HzU4wvZHyp/svQNALgLUNMuOQheRbl1vYfAGBNHuJp1xTfb9Pc9K/sR
         eYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wPKxhx2q2jFWM/iTPcuC0q3uyZMxRL+DFdkOTJpxQpo=;
        b=DVEggE4kMSi7KvcenenBkTljSv0Jg8Tu+N64+DvBTSmoZLMuLjoTRImfRjHQ4X44Lq
         kXiwM2iyM837nzDVHZ1lTiLc9kCjGllGo3j61PGkg1xSac5VLLeLMZHZ9UpeY32X0nou
         QJ32cBiVI5nRldxyDZ0gHstOZ0gOlK2e/DwXRbNlF/ITUnaT3xSrQbJp3NsS3UFSHUaE
         Voc4Clk+fJfWOHEDEYqKWFh4vyhTo3HuKQi5AEouyNSW5cBZ2Y+qqkozFUyEvapFWrVk
         ueCpgv9ptD87OkdqGcbdxJbUNwtI8V41khU9gPSTY0KEhl5sBCdDkg+ghKmfyDN1BPYx
         btRg==
X-Gm-Message-State: AOAM531cYTl2p4vIfB8IDGF13tkMRi/XElDcq6UgovrdFKFmJ4xlbBbp
        HU625VdL2HwS1/rBgFS5QJLoom55Dc73lA==
X-Google-Smtp-Source: ABdhPJwAN4zPVaVuJsz4AbwLIOh62v6SI6YY3h8LSW0dH5S/icrAlJKJQefw1zJtQnaV8C0leiemkA==
X-Received: by 2002:adf:f4ca:: with SMTP id h10mr63293743wrp.512.1641769762151;
        Sun, 09 Jan 2022 15:09:22 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id l6sm6889932wry.18.2022.01.09.15.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 15:09:21 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Solomon Peachy <pizza@shaftnet.org>, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cw1200: wsm: make array queue_id_to_wmm_aci static const
Date:   Sun,  9 Jan 2022 23:09:21 +0000
Message-Id: <20220109230921.58766-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't populate the read-only array queue_id_to_wmm_aci on the stack
but instead make it static. Also makes the object code a little smaller.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/st/cw1200/wsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/wsm.c b/drivers/net/wireless/st/cw1200/wsm.c
index 99624dd34886..5a3e7a626702 100644
--- a/drivers/net/wireless/st/cw1200/wsm.c
+++ b/drivers/net/wireless/st/cw1200/wsm.c
@@ -537,7 +537,7 @@ int wsm_set_tx_queue_params(struct cw1200_common *priv,
 {
 	int ret;
 	struct wsm_buf *buf = &priv->wsm_cmd_buf;
-	u8 queue_id_to_wmm_aci[] = {3, 2, 0, 1};
+	static const u8 queue_id_to_wmm_aci[] = { 3, 2, 0, 1 };
 
 	wsm_cmd_lock(priv);
 
-- 
2.32.0

