Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5706533A7B0
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 20:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhCNToR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 15:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbhCNTnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 15:43:50 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD329C061574;
        Sun, 14 Mar 2021 12:43:49 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so19008640wml.2;
        Sun, 14 Mar 2021 12:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uphds8AuecjI9QNpNuQj9Y2x9eEtS5xUyy6OMjiB/rI=;
        b=p3D4LW2jo/Y4MC/YyTNIOSjEVoJebt3vUOuIp2dLzEvN15giSGRMamgiBAK0LIGQcQ
         fG8sFgbAiunf/nkLSeZ8mezIeHiOXnMZIrHt1uYXzgHjEL4Hm8GTl5JCBnAOsZ0Rt9Qf
         yb8/2u53ugA3FZ/7Bfzd4Jmlu7l9tKauA1iHetQoqcIBibTp4H28sEBnSth9JnzvAXj4
         RKgHdP8k0PtVcBBDhijmiScQCEHcwrCtfc/8mFbCXdDYWjIR536dq7svTUp0mHAVa2m2
         OhsN329f9/23RxcinIUHJVRjy+WxoYt5SzSMC027HiqmS83DEZHxakAtmWLsV7YVbOhW
         4d+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uphds8AuecjI9QNpNuQj9Y2x9eEtS5xUyy6OMjiB/rI=;
        b=NvJrF/9E5sC/2UDL/DT002LrkvgkvU85lIgesg38y48JV93NVvMt4apxQTEMUznLz/
         f1sHTVNn6Md+NmCHfgab4szz/oncppgL6Xcu/fpvSzqHPJA2jFTbfZoQgRwDYP5+tOLt
         D/4bCCQUMJMOuZhvYhGz+tymYBWaKCyVkg04mv/8nTHZX+TSx/E1P8atOyWGsovt1QZY
         cRQA6zJRGAmV6sZKktiNAL/MxJh3Xw6RWJTWjOB42HhWvwhmDtVGNb7uHBHCwbVpwEh2
         576nURRxok2IyPeWilGdcbXxhE/vEIMVIojJhEfLcS2WojIjNTGK1iEm3N0hDl8bxYhy
         Nivw==
X-Gm-Message-State: AOAM531vQRRgMs5fvPC6u+0bDmwFfHKGsHkS5JewoEzk9oeood5etx1/
        jThZuiQfh+q2UczS3BXSxyFkbzRxXVNyhg==
X-Google-Smtp-Source: ABdhPJwlT9fmJjmBuTAPRJF17N+Q0dEahD0ZzA2W/t7wBWskv6aQ5Ol9n5/6rO+apE4ilJkaZpt5pA==
X-Received: by 2002:a1c:3d46:: with SMTP id k67mr17760273wma.188.1615751028294;
        Sun, 14 Mar 2021 12:43:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:fc04:867f:ef73:99ed? (p200300ea8f1fbb00fc04867fef7399ed.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:fc04:867f:ef73:99ed])
        by smtp.googlemail.com with ESMTPSA id a8sm10158812wmm.46.2021.03.14.12.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Mar 2021 12:43:48 -0700 (PDT)
Subject: [PATCH net-next 2/3] iwlwifi: switch "index larger than supported by
 driver" warning to debug level
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <22e63925-1469-2839-e4d3-c10d8658ba82@gmail.com>
Message-ID: <693dcf02-16bd-7bec-8cad-bb927c1e899f@gmail.com>
Date:   Sun, 14 Mar 2021 20:42:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <22e63925-1469-2839-e4d3-c10d8658ba82@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a chip supports additional API calls that are not supported by the
driver yet, then this is no reason to bother users with a warning.
Therefore switch the message to debug level.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index eb168dc53..647f8d003 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -408,9 +408,8 @@ static void iwl_set_ucode_api_flags(struct iwl_drv *drv, const u8 *data,
 	int i;
 
 	if (api_index >= DIV_ROUND_UP(NUM_IWL_UCODE_TLV_API, 32)) {
-		IWL_WARN(drv,
-			 "api flags index %d larger than supported by driver\n",
-			 api_index);
+		IWL_DEBUG_FW_INFO(drv, "api flags index %d larger than supported by driver\n",
+				  api_index);
 		return;
 	}
 
@@ -429,9 +428,8 @@ static void iwl_set_ucode_capabilities(struct iwl_drv *drv, const u8 *data,
 	int i;
 
 	if (api_index >= DIV_ROUND_UP(NUM_IWL_UCODE_TLV_CAPA, 32)) {
-		IWL_WARN(drv,
-			 "capa flags index %d larger than supported by driver\n",
-			 api_index);
+		IWL_DEBUG_FW_INFO(drv, "capa flags index %d larger than supported by driver\n",
+				  api_index);
 		return;
 	}
 
-- 
2.30.2


