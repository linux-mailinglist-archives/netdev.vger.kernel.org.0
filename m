Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF6533A7AE
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 20:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbhCNToP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 15:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbhCNTnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 15:43:49 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977CFC061574;
        Sun, 14 Mar 2021 12:43:48 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j18so4644319wra.2;
        Sun, 14 Mar 2021 12:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JhQQZ730Ric7YkzqrbciaYJqNCpwz1HnANK4iuqSu2g=;
        b=jd7TiWzFZzxNUrFPuqmjaB5O1BDKvfdPQib16Qf5LBJf81Ah54FkVAg5yh11S0ipQt
         OWp9Xe8RE8Md4dg9gAxv8DR8+uRjHvLg/21CiDi5flLPxvI1swDqoSncwtoh44N1wMEr
         hTRxlmLmObA11646pwFxtOQ96N0k/fy1cJn6Ne+SgY91fTRaz2zyedU2YYglDDyWZdjc
         dr1hVIaWfTq/gJ/fmFdUfUpvZZqOhoen6U0yM0Yre+Rk63UaZzErDLVi/Uw05s4Hdh8x
         X7dB6t2lQwYnrAPqLvqIncz1bzINpS34+Dtsj37bGMlJLwz+Ga9Yw3CQoWbfHVVML8jv
         ZblQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JhQQZ730Ric7YkzqrbciaYJqNCpwz1HnANK4iuqSu2g=;
        b=DtEubkKleqaHsyxtfIRR9pTwfUpcz7760m0+hSIeIq2IxUElrha9H92dlQHXeQ33+B
         OLXVbEIiUUGbxmZQT6G5HgG9toNl0VKQb/ktz0HC1JxIkJ47wqYGt+29NMNqYHRdb48O
         6W7ndUY3Nt4SLhg7/q366mrK6dGK3aRydIP9h1u0Nce6aFMYXxHoqH/zBXJUqaVhUE2D
         XLGsd7wieP4P5b+tbhlMfr5KuLcKEl3uN3y7wIQH0M4/DzvCT7zpH18DsnAwO9rhpOOH
         z3ljp3bp+yKV6nfiTXCh7Vf9yD2lNV96TmwfPqvEUAdunpvAEZcPrbUrdRfHK/GV4eBx
         qgyA==
X-Gm-Message-State: AOAM531nak5aY1Ce7PuucBa1tGyWdgzNCPJRRbQmVfG5D+A1dKzw2ZZx
        t+JqwL/gqXAEvK4wBMX5orHfItNRDowVuA==
X-Google-Smtp-Source: ABdhPJxY1J0l8vaQiUBT6wUYkPhG0LATc7waebos/Z7EFDdesiw4carYxR7hHUKKFG80zAd1hDGmQg==
X-Received: by 2002:a5d:6cd2:: with SMTP id c18mr24015011wrc.330.1615751026993;
        Sun, 14 Mar 2021 12:43:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:fc04:867f:ef73:99ed? (p200300ea8f1fbb00fc04867fef7399ed.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:fc04:867f:ef73:99ed])
        by smtp.googlemail.com with ESMTPSA id u63sm10176042wmg.24.2021.03.14.12.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Mar 2021 12:43:46 -0700 (PDT)
Subject: [PATCH net-next 1/3] iwlwifi: use DECLARE_BITMAP macro
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <22e63925-1469-2839-e4d3-c10d8658ba82@gmail.com>
Message-ID: <7dc766a7-7aca-5d24-955a-cf2a12039b31@gmail.com>
Date:   Sun, 14 Mar 2021 20:40:02 +0100
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

Use DECLARE_BITMAP macro to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/img.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/img.h b/drivers/net/wireless/intel/iwlwifi/fw/img.h
index 1dee4714e..de6c7d05a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/img.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.h
@@ -51,8 +51,8 @@ struct iwl_ucode_capabilities {
 	u32 error_log_addr;
 	u32 error_log_size;
 	u32 num_stations;
-	unsigned long _api[BITS_TO_LONGS(NUM_IWL_UCODE_TLV_API)];
-	unsigned long _capa[BITS_TO_LONGS(NUM_IWL_UCODE_TLV_CAPA)];
+	DECLARE_BITMAP(_api, NUM_IWL_UCODE_TLV_API);
+	DECLARE_BITMAP(_capa, NUM_IWL_UCODE_TLV_CAPA);
 
 	const struct iwl_fw_cmd_version *cmd_versions;
 	u32 n_cmd_versions;
-- 
2.30.2

