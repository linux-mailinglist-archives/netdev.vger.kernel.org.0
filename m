Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E959A2C55A0
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390266AbgKZNcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390242AbgKZNcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:32:07 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974A5C061A48
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:07 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id r3so2178463wrt.2
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LgKtNmQfGnZeeFNwZJm+JSbHcTG8sEx1i9uktjmVfHw=;
        b=diSVxSAoA40tZEtS/HzleEtjZHtOlucT3xtLPjQTgjZqyNCONejvfwzDQ9rykhgSo/
         EC3mKBZiW8Y5/3yHi2UXTIJGHUlJZWmhmGKEzoFG4WE77PAi2Gt1qssdtssc+4ye7qOY
         pOOJu38hmlttKJ/wu6A29AeM/dSRlCKiFap/M1FUM0A49ppUqc4MS/6/YZ7Ilmaon+3l
         ZykubvRyrnyBUVtXVW4XC2vYrPauBp/aPbGRvXo3xT80JNaEwaIuofRvLbFtOJdsF2Gb
         6oJI+aIb0M4cuqnQcp21K4cd3cKvyCpJ8sim4c2daOi3LjPnapOS7eUQuEB9kOLB6Phn
         y6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LgKtNmQfGnZeeFNwZJm+JSbHcTG8sEx1i9uktjmVfHw=;
        b=IHx4nah+fmNqyrB18IyaAEo4vq59Jy2rm6SBfc0Vgh9nQUDfyMyXyNwwExSlrIsWpN
         nmhDlJAa9u9xiHK1HEN4ymiu2x4F6XMOxm4kZphpSOklbzCrLV3p6H3p2Zmzz746uXcj
         vQogBYE15OhkQhBGEhgHU3SHna1hh0WKHM2w+lKjVb+b+07eGe7XAO8JtxupupKYKJHA
         wMtQXjmc0/CyNyqToS38wjdgFs4FNiAaYjgSz7RYWdFK7YjYSwl4/G8IaUUZ/ZxS1FaG
         z8FpXHzTITffzvHmpaWxb/x/1AeA6AbeR7Cp9GcF/9QqXufF89CdQGrACejusec/gRiu
         D8hg==
X-Gm-Message-State: AOAM533n93kXql86sFLRh8LqdRpmExKGk/TsmHwwoCB/3QdjuETBaeHt
        9VlCotjEUNzRGtEEEg4KFxLUxw==
X-Google-Smtp-Source: ABdhPJxCIYT+lF7JbaW4XiyGU7BSoo+9JGKkKGnf0fEfWfYR7PXVvWXzcXpp+ZzvHC83M7okR4aAcQ==
X-Received: by 2002:adf:e4d1:: with SMTP id v17mr3803758wrm.325.1606397526033;
        Thu, 26 Nov 2020 05:32:06 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id n10sm8701001wrv.77.2020.11.26.05.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:32:05 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 08/17] iwlwifi: iwl-eeprom-parse: Fix 'struct iwl_eeprom_enhanced_txpwr's header
Date:   Thu, 26 Nov 2020 13:31:43 +0000
Message-Id: <20201126133152.3211309-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133152.3211309-1-lee.jones@linaro.org>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c:340: warning: cannot understand function prototype: 'struct iwl_eeprom_enhanced_txpwr '

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index cf7e2a9232e52..f29d5758c8dff 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -324,15 +324,15 @@ enum iwl_eeprom_enhanced_txpwr_flags {
 };
 
 /**
- * iwl_eeprom_enhanced_txpwr structure
+ * struct iwl_eeprom_enhanced_txpwr
  * @flags: entry flags
  * @channel: channel number
- * @chain_a_max_pwr: chain a max power in 1/2 dBm
- * @chain_b_max_pwr: chain b max power in 1/2 dBm
- * @chain_c_max_pwr: chain c max power in 1/2 dBm
+ * @chain_a_max: chain a max power in 1/2 dBm
+ * @chain_b_max: chain b max power in 1/2 dBm
+ * @chain_c_max: chain c max power in 1/2 dBm
  * @delta_20_in_40: 20-in-40 deltas (hi/lo)
- * @mimo2_max_pwr: mimo2 max power in 1/2 dBm
- * @mimo3_max_pwr: mimo3 max power in 1/2 dBm
+ * @mimo2_max: mimo2 max power in 1/2 dBm
+ * @mimo3_max: mimo3 max power in 1/2 dBm
  *
  * This structure presents the enhanced regulatory tx power limit layout
  * in an EEPROM image.
-- 
2.25.1

