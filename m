Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C54F48F331
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 00:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiANXtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 18:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiANXs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 18:48:57 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE13C061574;
        Fri, 14 Jan 2022 15:48:57 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id p18so8990257wmg.4;
        Fri, 14 Jan 2022 15:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=La6vxx89LoJkplOXTrCEQipBpHlGptWD3ksMauPkOfU=;
        b=BogPgfoe6NchlV2k3yFPNQaiVUpwxBWO4bk/TWwvQRtnYx0ZYqHPh6f4sixPj7fyDI
         Epk5z3YY9YuOiTKgF7wSBuylZEmJP04VIUrfRkvV/NEKq/LZQYw80dYfIeHv8qVA6psm
         FGlC6SIaN1EYxwef4kFaPVvy4rCx5i1gdot/ZPTVTmmAJDxNQbkjfvhJ6d4MP/M2ThKJ
         gDQVOn8mUbtXq6ORXyFtEJwnku8x53z/vhzWjOsGnZXG1YTyPOJ6GoP+oa4X5kv9/3nT
         z257rz8N1G4PYaf3e8kecTDJRWsEqG0sEvknJUByTmUh1ZN55GhBv76BKrdkP2aSXUVX
         TKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=La6vxx89LoJkplOXTrCEQipBpHlGptWD3ksMauPkOfU=;
        b=j5DvXgBTe8zEg7hv9evzKt6z8zYQLJ4tOGxFI7Wxcb+VKu4RyDAKKgAR9c4P3VJvQd
         cZNldm2UOhvLz5SQs5OQQ1TcD8sXEXXLUTzT89OANkCgwQyjdj/3E1hlvjaq70ZDXIeG
         mXUqs/R/pPBVsHhhD8CfK6oG9766r0bNTacfDwnyl2gMghzMyiNfCzlkCrRudfTHzFCp
         4r9OcdVGUpFWYjjZ8gJ44Hd9VA9VZ0Dwsfx/5CeqqNtf/g6zXnJaxvBI03p5D7K6z7eP
         S+O0zbyCApJ2Kjq2ByUcb+kOJ4RXIFuYpi2DtX2eAUT49TND6qomgEJ83IgEdwDjkFpO
         xDSw==
X-Gm-Message-State: AOAM531UjESgtCy2VG0RKI2Bw9NxKKEpJclbmEa8uZsyCZjb9J/wz2d+
        2JjBiaMa4cvv5+c6CdHgBEI9a1PAbg8=
X-Google-Smtp-Source: ABdhPJystG3jsSgdQtccETHSCVGHfilGgZfMIXRY2Kc7mkF7F3bhjNzpIyDdwTr+W7+k9nYviAlZNQ==
X-Received: by 2002:a05:600c:3643:: with SMTP id y3mr17836122wmq.54.1642204135556;
        Fri, 14 Jan 2022 15:48:55 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7684-7400-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7684:7400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id i3sm5788533wmq.21.2022.01.14.15.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:48:55 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 4/4] rtw88: mac: Use existing interface mask macros in rtw_pwr_seq_parser()
Date:   Sat, 15 Jan 2022 00:48:25 +0100
Message-Id: <20220114234825.110502-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
References: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the magic numbers for the intf_mask with their existing
RTW_PWR_INTF_PCI_MSK and RTW_PWR_INTF_USB_MSK macros to make the code
easier to understand.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index d1678aed9d9c..aa6b3d2eaa38 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -217,10 +217,10 @@ static int rtw_pwr_seq_parser(struct rtw_dev *rtwdev,
 	cut_mask = cut_version_to_mask(cut);
 	switch (rtw_hci_type(rtwdev)) {
 	case RTW_HCI_TYPE_PCIE:
-		intf_mask = BIT(2);
+		intf_mask = RTW_PWR_INTF_PCI_MSK;
 		break;
 	case RTW_HCI_TYPE_USB:
-		intf_mask = BIT(1);
+		intf_mask = RTW_PWR_INTF_USB_MSK;
 		break;
 	default:
 		return -EINVAL;
-- 
2.34.1

