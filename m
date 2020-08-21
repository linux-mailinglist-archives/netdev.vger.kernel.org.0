Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAF824CF1C
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgHUHWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgHUHRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:17:18 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0899C061346
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:04 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x5so837963wmi.2
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JbF/Bt72HU4m6OYVeSeKpZw8pWXT/9Iw9CWWcKFsT/g=;
        b=kpv2Q00uO7NGh/BvYU2qonjtQ/aePbdc1Hykhk6pb1/zUo0Bj8FwG708OXpgzr9lVx
         GuLxkUWDbeYF9wbSAT5mW9gbgb60Y45u3VU108r11X+vl4X4ejmI4scPI1k2gADQAjJz
         6vhdT3+s19sDSUpDu6Q1NuaJO4RCpzAAh6wbK/PZZvlDsiChDNUhQq0N1W77DlvQIPYG
         NWF3RV8c6BnW+zmLcstXRHP5zNQY74YxLj+xNCI7WZ6+2me9OMPRQsUDQ4W6GwwbIXRX
         229s8nZlKysmHfOmwe0AYd3+qRrOgP9zhfy2dzlbvFkd0tQEp/6QSaNUNPKPMjBfou1T
         pgpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JbF/Bt72HU4m6OYVeSeKpZw8pWXT/9Iw9CWWcKFsT/g=;
        b=EVn8BMAiPJn8ke/ruy+lKXV9RhAHzoKx02Fatsk+6RWgMvL/FDx9dOtJ/8OAGT7Zwk
         BGOX2dtC2t0tmsKIv3390zkgr+VIRqtiNv8Fs1TT6xph6cKHcIj3ieTcvSpl8ZHVKxQK
         pGHLAt+hJSpfIl1X+V80VtAMaJs6NxkRGEqzWyTP+lZQE+TDbigJMtfRqkpcSvy3oNSK
         DXCMUIOEPbRSSx6Ivm5pT7ZB5YlyKLKKwNCS9GqCKWCIhSgp+TYrkZYhufSql0h6hfYm
         J73N+FquQzFqnUTfkv71E0GQsOdWEJc+uHNG7ku89suQj02dAZOCMJFvwHZ6b/FXmRuW
         tnlA==
X-Gm-Message-State: AOAM532MBh7AGCwlvb0T0bAtEyvCLWp9/9yFFxEZXcQZ03HHEwTmKmvs
        TihBFQY1nxIBFQX7Yq4KpP37gw==
X-Google-Smtp-Source: ABdhPJxg+W/uQNUPSAkt5RBaljjYtUlUgjDVZG+DCn3518FFq/ahY90cKO7VD3uyfol7mCnyX+199g==
X-Received: by 2002:a1c:f709:: with SMTP id v9mr2378123wmh.165.1597994223600;
        Fri, 21 Aug 2020 00:17:03 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:03 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: [PATCH 12/32] wireless: brcm80211: brcmfmac: firmware: Demote seemingly unintentional kernel-doc header
Date:   Fri, 21 Aug 2020 08:16:24 +0100
Message-Id: <20200821071644.109970-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function parameter is not documented and either are any of the
other functions in this source file.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c:69: warning: Function parameter or member 'c' not described in 'is_nvram_char'

Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 3aed4c4b887aa..d821a4758f8cf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -59,7 +59,7 @@ struct nvram_parser {
 	bool boardrev_found;
 };
 
-/**
+/*
  * is_nvram_char() - check if char is a valid one for NVRAM entry
  *
  * It accepts all printable ASCII chars except for '#' which opens a comment.
-- 
2.25.1

