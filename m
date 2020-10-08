Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7B328789A
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731674AbgJHPzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730546AbgJHPyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:51 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA5DC061755;
        Thu,  8 Oct 2020 08:54:51 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n9so4643328pgf.9;
        Thu, 08 Oct 2020 08:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I67jtUWj4lQ6MYmKWTK3k4EslMrchiY8PwIogsFQAm8=;
        b=flb3blqzo+eiFc/JJwU8SXNLlQ4ORpuqW8vmh12CZQ8as3U1xpH34jEjj5JCv02f23
         QQpaMMby+NE4pzAEVQ8AjV6LSi/W8XelRS2LGbcOIOewp8+ghvOpJPoX46ZThHgXsoz+
         xaKaKS9llY47HqywBgcpln3+RnG6ChsR/DVX2ZnIGlsROp95nLCREMWtt+IN7Z5T8J0q
         +0+ZShUwFLzseLbZUR9fqY3oOAnu6m5lYiX0NOSsB0UbkHD5LjaLROlNdjrHElmp6eAG
         CitlCjABYrRua14AbuyH9S2fhCBFZ7VD1yFUiHjGnwvuNXjTezEyFJgln//DfFtKoZlk
         4HnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I67jtUWj4lQ6MYmKWTK3k4EslMrchiY8PwIogsFQAm8=;
        b=bMjWf5mfr+vnUpkyJTT7wVqUTNJfVjMcyHglPHwPfnp5A2JEa1WRN/xIew56QQbYiJ
         2RKs8bZAyB0DQjfolbUsYt7mgQM/6+wKEsyZERlMfc7Qjd7a7tuae87dlJjXKMrviZQa
         /MjiEW3gswYSiobAWj7Zh7mKOkBtW+G13oTdeka7AvnpTjqetZFG9VVCT6l4q2rC5+bZ
         lK+BlzxGDiD+P5acgW77pkm7IaAMNAAWD/A/ajg6RtwBqhF9ClhRAflPwX1xBtZv3a8c
         iIHeN/xcRtMuhCuddIeBGdn6IfaOK8Gc/OiGGI0+9dr0cu2g/pzGwonYDAQg9Yo9zZba
         oNNw==
X-Gm-Message-State: AOAM533IBoIb1S91GB8ao6qtk6dRz3VQxaiFFPWJFUzgVP3Xj+f/dKSE
        FkLdvpoFKVQCxx8GklffuAo=
X-Google-Smtp-Source: ABdhPJymHPTv4TpZLXvBvwb0Fb+GZUU563h5UpfsusYFzBPHVLNC8P1tCM75H5S0SHKMrajyd4IWtw==
X-Received: by 2002:a63:f015:: with SMTP id k21mr8056317pgh.422.1602172490991;
        Thu, 08 Oct 2020 08:54:50 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:49 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 048/117] iwlwifi: mvm: set iwl_dbgfs_mem_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:00 +0000
Message-Id: <20201008155209.18025-48-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 2b55f43f8e47 ("iwlwifi: mvm: Add mem debugfs entry")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 8fae7e707374..3bfa91b4cba9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1981,6 +1981,7 @@ static const struct file_operations iwl_dbgfs_mem_ops = {
 	.write = iwl_dbgfs_mem_write,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 void iwl_mvm_sta_add_debugfs(struct ieee80211_hw *hw,
-- 
2.17.1

