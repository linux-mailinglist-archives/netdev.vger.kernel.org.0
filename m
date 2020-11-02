Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416882A2902
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgKBLYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgKBLYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:38 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955A1C061A53
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:37 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id e2so9131851wme.1
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xuBtucNK6orquLtJMKORaW0tLzjtm6vr9NLgmkKGSZ4=;
        b=QvlkOlDalMkDg3/bMvwge5T0Ii+8IuTEkO83EKlfjVa/CW7cw8OD3+zV7urVzsZ2MY
         GMsyeneq3/3u+RRHGTUUXtGbQdJYVU5v7TaLQW4D9sWNFLRbbe4pAwoNWKQR/nD/RG35
         ARq5Hy8NdBltEOOHwcy9cRPwm7KhLeKN/i+CBN8MAzuaUk8b++WerxEB6TO4AKomC+Y1
         wDAUtexWJPUD0pJQMpvF3bX2BVnPCGZL5SKXeK9Gy9R5bjbNlvtOPDblxwD34XZ77+xP
         c9hq/5Sml0YI5zxIIgCXApi6TBTnEX9m/skqJNrV1SjcfzUF76ZozMAfv1UH0uyBf4Wg
         EICQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xuBtucNK6orquLtJMKORaW0tLzjtm6vr9NLgmkKGSZ4=;
        b=CAxXpeprkha5orHT+BRz5a0vXfaoN4CTrbLhgyUXrEgm8XWVap9wLA7jXk3OatFP5+
         jrGWUvx+4fHjP5RuVjEteykTXH7+6qXds30TqvtzCL33HQBTEvAOfxycGgOYaK9Wsd+Z
         SFielz8Sr3c6c7t3pmCNAZBFqZf7ApO7Vqz6eCWLa/uqrOE6Qkq14Sm0KCF7O7MzVT8g
         AnqGQp6HBQcF541BFHht95Qq89trazfWZn+Q6HNqqt/Y0vEw3fM4QTXfVEoZ38HTDHKT
         wMVugxpIaNkk1yLLy/i0rlAv+kxHW1jlbY8JI1Ss9zYGQUWXHJ/poGcA8zwkB9oEeNn0
         vJgA==
X-Gm-Message-State: AOAM531cGz1WS67mnhdUJwdbZ8KPygikhGFKf5J09cqcP0L+ypnEPO6C
        9EFEaPf85G7VA8GQvm8efplXMA==
X-Google-Smtp-Source: ABdhPJxl+oUD+eenUUM55ZHK6NU6oy1ZIm6YJN4DNA3V05R69spUoktUQtN9bLIF/DRQiUhiaokCLw==
X-Received: by 2002:a1c:3503:: with SMTP id c3mr16873385wma.43.1604316276365;
        Mon, 02 Nov 2020 03:24:36 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:35 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 15/41] iwlwifi: iwl-eeprom-read: Demote one nonconformant function header
Date:   Mon,  2 Nov 2020 11:23:44 +0000
Message-Id: <20201102112410.1049272-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
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

