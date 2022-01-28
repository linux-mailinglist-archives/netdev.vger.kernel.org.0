Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282E749F4D9
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347037AbiA1IEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiA1IEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:04:39 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE057C061714;
        Fri, 28 Jan 2022 00:04:38 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id y17so4539762qtx.9;
        Fri, 28 Jan 2022 00:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3TT5bHFkruxbVd2ktp2QQbLXvdZSrdDVPPNEsULjQf8=;
        b=eaLzwa9Kslys8dp2UL461qM6t3WgE7Bfc5PK217VTpcTfKKbK3d0cEbymTYH01R/GH
         QHX92kd8N35181AMIaJ31faLpMYXkAnZZw42QfZacVMnn/n5K0masi8UIy/lGzGti75X
         stLgR7sZrGvcM2jziAg+L5S06eoPCAWX77HzXlRJxTSvjTy9mgqwXB2lgnDa7WS30Tm5
         ErJcAVqUZ3f/C/7+nbMAosLmw38xJ4e+1yMnRE1wLSP3b8ZgO8WGHAi3cTAd4vzhtrdZ
         iFKP0d3sUwJPPyI59NoNZUiH4tQrdWY3kVrHCaf80L+On6QsROPxsAyMLM99KSl8wcdn
         ZT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3TT5bHFkruxbVd2ktp2QQbLXvdZSrdDVPPNEsULjQf8=;
        b=vIOF2yMsCKW3XpaXRWSJspHr4wxEF+eiQsTj8a/n59F+W5eywhAS86xyEdAx0tn15g
         YksvA3yilW6XiXHqfYHxsH8Ilp5qcKuNkFEyEbZCjr6Z3GnICaq8vNfxq12L2wPbljXS
         WMxhYPas9p964IwhpBV/10n+TBWgnUJ/oprvDj2dLn5koKRd8n3ogdKd6ZKDB3k1D+Kh
         xi3I+0kZWO3CHZMzCzGCJxgrBs4E6CdvjwiwHo3+CBQmATLbmn/KcYgfdAof8FO2rhU1
         H1aWwqITyDCa7raf5sx8m9Wk2vy/qU0xX7tYMTRRSZ06HKjXmkY9TICA+sYRUsqFiAGL
         Y7ww==
X-Gm-Message-State: AOAM531FMZNOqHmX0juyDeaAVDE195Rf2FEfKEuqNoK7+fl3AZUVoO8/
        FR/J5qnJA1Sa760sH5G8mO5p2mSoAkI=
X-Google-Smtp-Source: ABdhPJy8Dm/EfYX+j0uTQdaKcdWk7EsyXceDYatXLLNPMDv32jBEQEzCKxba6h7EKqO9GYeGcnxpDQ==
X-Received: by 2002:a05:622a:1042:: with SMTP id f2mr5333187qte.231.1643357077913;
        Fri, 28 Jan 2022 00:04:37 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 195sm2780348qkf.30.2022.01.28.00.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 00:04:37 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] wcn36xx: use struct_size over open coded arithmetic
Date:   Fri, 28 Jan 2022 08:04:30 +0000
Message-Id: <20220128080430.1211593-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>

Replace zero-length array with flexible-array member and make use
of the struct_size() helper in kmalloc(). For example:

struct wcn36xx_hal_ind_msg {
	struct list_head list;
	size_t msg_len;
	u8 msg[];
};

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index caeb68901326..16036881542f 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -3347,7 +3347,7 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
 	case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
 	case WCN36XX_HAL_PRINT_REG_INFO_IND:
 	case WCN36XX_HAL_SCAN_OFFLOAD_IND:
-		msg_ind = kmalloc(sizeof(*msg_ind) + len, GFP_ATOMIC);
+		msg_ind = kmalloc(struct_size(*msg_ind, msg, len), GFP_ATOMIC);
 		if (!msg_ind) {
 			wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
 				    msg_header->msg_type);
-- 
2.25.1

