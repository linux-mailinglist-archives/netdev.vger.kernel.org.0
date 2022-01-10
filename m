Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2728F4896A6
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 11:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244161AbiAJKpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 05:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244259AbiAJKoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 05:44:08 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA238C061201;
        Mon, 10 Jan 2022 02:44:07 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id g2so10759501pgo.9;
        Mon, 10 Jan 2022 02:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YR97/Gcp1I+ruoUyRgA/knLTefKnR/NxJA6qzNXeyNE=;
        b=qt9pKgpi90EZoBuvBzFJx4QHrLCOLJkJfLooUHUiGzddM0BW+vMN9Kvpvwwjwv6rPH
         PM9I2pZ+3ockDRa1RWtnHAGm47TpgOGn5wt9A6l/tEDw4E2vF72XVEVvAuYcqo07lSdG
         ZmKTlTPrAZ99OHFn8zFqpmTKwOAF0lkflN2l/tmL5LK92DL94eWz224vSGsH3AhJreF7
         wYXi5yceB3i4JQwI29p1WaOxyqGUqaeP9/kbAN1F9JmGkQttHvbcaDoF4SUdi/Z5iYtt
         obxqy7CnMF9OnkNlBB1XOvqO5zWlDFTJav9exUOTsSpNJuj7f+QrMwibVyi4ViF5E478
         YRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YR97/Gcp1I+ruoUyRgA/knLTefKnR/NxJA6qzNXeyNE=;
        b=X4op5JauqcopVwyezfiJNu4/CxUQD6ywkJZwXE8JSAMt4Qs7iTJatiyPiUSMglRWVG
         65clG9ouK55pS5oI6PtT4vmWceCjbfnX0/Biie7MyWu+ymPuDAVFFAYUSXjNn/zErvpO
         WNjQuteEJQPlKpPbRCI6bRNPVbef5UA8LCjypaAWP+0wr6qdJS2FN1MBluFsWxVozd3R
         royyIiSu9WoK283KJ3cLabJ8JLFfmeKKG3o09q7Zt3mRhexE6MyovFZYTFOuaZn5HcqU
         IFbpPpmDJ80FtYzTDiWvCASj0VZmmoWbR8HhqM/dYcgHJVOsVbQslIBtdHOkRSauhjdL
         OXew==
X-Gm-Message-State: AOAM533fwx5jJaJwkJ5ewHYSJwZ4nPQZ8+bnF+mYnOMS+9m8lgnB+cK9
        uWzGBh/cPmwaCL6CIkbJrs0=
X-Google-Smtp-Source: ABdhPJzVsl0u8cUSqvFadlDEm8edhJdFVyVjPHZbVqqcRgPObUBMHAlHFjbrQ2WBHMuOy618eo1/6w==
X-Received: by 2002:a05:6a00:2304:b0:4ba:4cbb:8289 with SMTP id h4-20020a056a00230400b004ba4cbb8289mr74397557pfh.79.1641811447304;
        Mon, 10 Jan 2022 02:44:07 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id i9sm4490726pfe.94.2022.01.10.02.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 02:44:07 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, chi.minghao@zte.com.cn, andrew@lunn.ch,
        grundler@chromium.org, oneukum@suse.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH] drivers/net/usb: remove redundant status variable
Date:   Mon, 10 Jan 2022 10:44:02 +0000
Message-Id: <20220110104402.646793-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value from sierra_net_send_cmd() directly instead
of taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 drivers/net/usb/sierra_net.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index bb4cbe8fc846..818ff8a24098 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -334,15 +334,12 @@ static int sierra_net_send_cmd(struct usbnet *dev,
 
 static int sierra_net_send_sync(struct usbnet *dev)
 {
-	int  status;
 	struct sierra_net_data *priv = sierra_net_get_private(dev);
 
 	dev_dbg(&dev->udev->dev, "%s", __func__);
 
-	status = sierra_net_send_cmd(dev, priv->sync_msg,
+	return sierra_net_send_cmd(dev, priv->sync_msg,
 			sizeof(priv->sync_msg), "SYNC");
-
-	return status;
 }
 
 static void sierra_net_set_ctx_index(struct sierra_net_data *priv, u8 ctx_ix)
-- 
2.25.1

