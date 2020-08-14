Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57ED22448FE
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgHNLlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728229AbgHNLkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:22 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C40C06138B
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:19 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r2so8075563wrs.8
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YFgXjYQQ0+xg2jvt5uv0D8nLYp5jF/FJWwM+q4+R5DE=;
        b=GFwPVGLxXf/mpStDrwQbhZhhGdubhcLGe+9QBE3auyMrhgHAOnfF9/382XpY9WzAAy
         erGIGgYbUKa0VY9jyzkDnooZ6tWkoEPH3xTCvwbUgzwtQFCfVUMsdD2xluztnlnPHvPk
         Wj4O4gMCgAcc6ALZu71VEc8S4IQ8s/EONoLx4Y9Fs3Vy8yIAaRcJBYmeiVyQ6GUffrlz
         TPa7yzxScLbZHbr9ozFnhXH0Kf/XqZHFzqZSosAFH3TrtyEWg4/ZPY3GopviOpzQoUln
         DBDzrWxAlV0KS4t0N5dOKAnzYmh2hN8EI/wPGmyITJ1kTzwUkB9iwLfiNipfsuCEf+W4
         dWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YFgXjYQQ0+xg2jvt5uv0D8nLYp5jF/FJWwM+q4+R5DE=;
        b=RxEAFPQAAr4N4o7vhTsO37UU8hxbuLrhBGZg11lHUcYi7zpM9I3SkG3f7rs1MNPSfL
         80kpZLXrNjQjp1d/ZlewYgCyMr48h3n74nj6HB5FMnMOf13puGbUYhslfMqtbl3taWo7
         Gg5to860GCxAPaMbPImXBiSdCPRbaoINalLjtdMamnXzG5R7mSHu4lF3VTTKzuICXYiB
         hC/kWPCDeCEGQ9vu3AhNMuEkGQ1rPJYz5Cjer8rmZaKt+noCLGD7A9Kyl4OO9fS1AK2y
         LjG0Drbyb3SQiIP/Tl4P/wRWd4dhiuswUFj0pHr+2IZzbd2pEA8D8HjT9wuGD1mcMezf
         H/xQ==
X-Gm-Message-State: AOAM531kzkgI57nyVL1/K3FWYGjy5pzb3UWz6AcSQubY+6nE0aTfE7g0
        /2BrmXncSdc+m/s1yJMIGLFSkQ==
X-Google-Smtp-Source: ABdhPJyYbghJq3Vbytc+37vzZWS3PlyxtAiIzUiiOcVh5+jOzFITVoKVkNX94BOY56UhZmaJvfCDEw==
X-Received: by 2002:a5d:5746:: with SMTP id q6mr2377308wrw.59.1597405218092;
        Fri, 14 Aug 2020 04:40:18 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:17 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH 24/30] net: wireless: broadcom: brcm80211: brcmsmac: mac80211_if: Demote a few non-conformant kerneldoc headers
Date:   Fri, 14 Aug 2020 12:39:27 +0100
Message-Id: <20200814113933.1903438-25-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c:30:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c:288: warning: Function parameter or member 'wl' not described in 'brcms_free'
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c:1127: warning: Function parameter or member 'pdev' not described in 'brcms_attach'
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c:1222: warning: Function parameter or member 'pdev' not described in 'brcms_bcma_probe'
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c:1301: warning: Function parameter or member 'work' not described in 'brcms_driver_init'

Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c         | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index 648efcbc819fa..29a834ea45eb8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -275,14 +275,13 @@ static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
 	}
 }
 
-/**
+/*
  * This function frees the WL per-device resources.
  *
  * This function frees resources owned by the WL device pointed to
  * by the wl parameter.
  *
  * precondition: can both be called locked and unlocked
- *
  */
 static void brcms_free(struct brcms_info *wl)
 {
@@ -1115,7 +1114,7 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 	return ieee_hw_rate_init(hw);
 }
 
-/**
+/*
  * attach to the WL device.
  *
  * Attach to the WL device identified by vendor and device parameters.
@@ -1210,7 +1209,7 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 
 
 
-/**
+/*
  * determines if a device is a WL device, and if so, attaches it.
  *
  * This function determines if a device pointed to by pdev is a WL device,
@@ -1290,7 +1289,7 @@ static struct bcma_driver brcms_bcma_driver = {
 	.id_table = brcms_coreid_table,
 };
 
-/**
+/*
  * This is the main entry point for the brcmsmac driver.
  *
  * This function is scheduled upon module initialization and
@@ -1317,7 +1316,7 @@ static int __init brcms_module_init(void)
 	return 0;
 }
 
-/**
+/*
  * This function unloads the brcmsmac driver from the system.
  *
  * This function unconditionally unloads the brcmsmac driver module from the
-- 
2.25.1

