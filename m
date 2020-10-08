Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D3A287888
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731614AbgJHPyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731377AbgJHPyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:38 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A555C061755;
        Thu,  8 Oct 2020 08:54:38 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o25so4676731pgm.0;
        Thu, 08 Oct 2020 08:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6EzXv2Zt7KX6g1F168WjpOKFjasZcuS0dW6h2mDBi00=;
        b=nzVLfs1kRqgqAPUx/KO3E1IpwrQYvhqSdqUH0jHN2PieGBkFTI6Tt0nrXeEA1nfjev
         9lY6+AtgIZQ8PRpRDAmhuSSg0VeYtVq8Jnpgn+4RjNdh5poyCxyiIL+6HqU9keN6Q6sA
         4PJio1FTdSmD6wPKoj5ZylejtER06TVkYehC563fY6g+4c2Y1xsTy4ak3so77KCfn02l
         07SK1ot5QUqec+M1ti2/IWBTVvkmRZVxnZSQLHsK9ToJhLXcK96EPA65LSQ8CUf1Z4FP
         bfLdt0xTC1T20XUmdhfPlE/gqCZYXDU04WKFMCAdJ5S1Rz7DVUDUyK/Ekqc8MDeOFyei
         r30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6EzXv2Zt7KX6g1F168WjpOKFjasZcuS0dW6h2mDBi00=;
        b=rv3UCZrzL+xIYCaF7FXt3DXyrTxyE2cmgZDpdZj3p5SZcS05HwwPsuloWQSO9GQ8kl
         oi4x9G+DTOLpSM6jdzGjQGMSlkx+LM6hQP+iZszf1w1/DKRKLDhCSGAGV3Z1zpEdeTt9
         FaAmjyvZC4qdrHZOZUIUc5EVr12CK93Pr/Y7ZtGY3F9od7XjHrNZ5wZJWAfavchNEe4G
         bM0K3QvU7kjd/CYzilUTJC2klMo6/R8IYi6iK5FD9papGRNuZBa6ADdgYGxbzoLGxs7p
         7vCniPakZ3XinwES4icfdb/FDEdOnt3YyVfHMhSm0gPST86vE/V7N2CK6V10z3t+XLXU
         oF7A==
X-Gm-Message-State: AOAM532zY4AVe7fFLN5p1ykoZnOhtKCS6mxvf4AXh0bwON/7aN14dCiR
        5rh4Km/CztUKhPTJ3iuVzMU=
X-Google-Smtp-Source: ABdhPJxm9VAS5OD6RtDgOVcupMfvMW7FvB8noSe+x7mWZGDnk64X+2Kg5WiiOM6grLxbHB7Sm8Odyg==
X-Received: by 2002:a17:90b:8c:: with SMTP id bb12mr5439906pjb.48.1602172478008;
        Thu, 08 Oct 2020 08:54:38 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:37 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 044/117] iwlwifi: set rs_sta_dbgfs_scale_table_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:56 +0000
Message-Id: <20201008155209.18025-44-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 8ca151b568b6 ("iwlwifi: add the MVM driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 86b2ebb5d5fb..97289236f2e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -3903,6 +3903,7 @@ static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.read = rs_sta_dbgfs_scale_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
-- 
2.17.1

