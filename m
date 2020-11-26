Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820D72C55C1
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390429AbgKZNdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390218AbgKZNcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:32:06 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21276C061A4F
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:06 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id g14so2126242wrm.13
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xuBtucNK6orquLtJMKORaW0tLzjtm6vr9NLgmkKGSZ4=;
        b=fxFvY4F9TAI3WLouXVEDBCny/tfmKyGzUcAMYh+tZX60mwEb575ArQEYNr1as6rviJ
         b5iYC89cQ3hyCFHG7ZaehdrRYgrT6ouRF4gJ/jYIk3lXhlIIACIwxcmua1P/3CsedSTX
         m5mf8HS4rAwHshbiXkaE4dvZ8a1vJFTTjhOSJ5nijQendWJ/7lJ6iPOwW69wsFOBFNW8
         rlsQlL5M1yPZwp+hIOslJDuJbVqYnwliaVqpCIZa6SI/9IV0Fa8qIe8e5pdUOMWbTUTX
         1WOUoyCBbAZVcYxGie+kvw7PT0Ww8qc5rLjAS/1ykNx13GP7OOognTQk8j08i8iPRcfO
         7d2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xuBtucNK6orquLtJMKORaW0tLzjtm6vr9NLgmkKGSZ4=;
        b=K4kyfL+RuFo1qnFaza5fn0kAZeTQBdKJDRQ6o10G8b9HbuQYsqna9oQneFx0pfrcot
         fUdrt0/CKVUrWBnbna5eeW+rSKPHkqJKeAEzw63mRPoBWKnoChSdmlDnw2UVVJTXgmpE
         vc9+1Gp1GZZwng2nBixPp36n1WgtEES5VD8HuPyiLQDXy/WgvYARBKzewjjRRYc6UuDj
         qScyry6cHkugEqT5X6SOFDznJ/nxCgDTsq7QMA1sImZDwNMwCs6s0FaIUjtqLoPMtRhy
         N32W3bfQwgKtueXiDlz3OxMdgMYF9viFMP2qSMXhCnz6my7jGv8TNcMGvW9i7RsDFdqa
         HVsg==
X-Gm-Message-State: AOAM532gL60JihfwKWGNmhkOz8VMnPlrXFjVQnr4STsUyVNVNMph3DSX
        RzbnCLCxxedKP2fjhdQyv9KHHw==
X-Google-Smtp-Source: ABdhPJxEqrNkgHGQvyOLo0FR6NpjjkFky++1qbEa/oplWQmxA4TLp1X2l26V0s1OnHiEeUtF4gnwCw==
X-Received: by 2002:a05:6000:143:: with SMTP id r3mr3797328wrx.331.1606397524835;
        Thu, 26 Nov 2020 05:32:04 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id n10sm8701001wrv.77.2020.11.26.05.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:32:04 -0800 (PST)
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
Subject: [PATCH 07/17] iwlwifi: iwl-eeprom-read: Demote one nonconformant function header
Date:   Thu, 26 Nov 2020 13:31:42 +0000
Message-Id: <20201126133152.3211309-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133152.3211309-1-lee.jones@linaro.org>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c:347: warning: Function parameter or member 'trans' not described in 'iwl_read_eeprom'
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c:347: warning: Function parameter or member 'eeprom' not described in 'iwl_read_eeprom'
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c:347: warning: Function parameter or member 'eeprom_size' not described in 'iwl_read_eeprom'

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
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
index ad6dc4497437e..1b2d9fd82a3de 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
@@ -335,7 +335,7 @@ static int iwl_find_otp_image(struct iwl_trans *trans,
 	return -EINVAL;
 }
 
-/**
+/*
  * iwl_read_eeprom - read EEPROM contents
  *
  * Load the EEPROM contents from adapter and return it
-- 
2.25.1

