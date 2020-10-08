Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92884287892
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731654AbgJHPy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731377AbgJHPyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:54 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA97C0613D2;
        Thu,  8 Oct 2020 08:54:54 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id g10so4335717pfc.8;
        Thu, 08 Oct 2020 08:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DR+pfHfdMhhdSmcJQNSIofIteoVJcDuhkAYRZpnEQmY=;
        b=nQXxdK74BIm7QpSErfFTshyRYqfESA8pT+naAwBkTDrODxRf7KfNYX/lqPnJaW5t61
         jV+F5TraOKJBOqLZYQHhXy9kFEEQsGa1xIBzV0OejbUGXKntq9I9BQ7vxig/O8GG6x7T
         w6wFW8uv3bzgCGMKsfZ0kWuLgvDloPzb5VKYBrGcDefS2Wv1wb6TN7v9s0HMGcvp2sw5
         tIgZwVIvMikV0z7tB2nwbCbeRXCeURExcnpGxkc7E3RfNYBEK+oj+JK9JFacimNx+ao1
         FKDkK3llQqa/mIiIUcmYWsvxKl1dUGH79W7BZnRN4MJWOxz0YauYRxMQXMcEDyYBD0xY
         8dQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DR+pfHfdMhhdSmcJQNSIofIteoVJcDuhkAYRZpnEQmY=;
        b=JAIHHg2FavvgTkz6mu2kxovaiHC/qsCsvPvFPF3F64wcW8bVNWYx7nbLgMINiSMhI4
         cSuPCmogfpBGNWaLvhGfPpWzB6hrQkQE+2WdbECK15XZBK+NE7okV9sSUjNh5F1ViaeJ
         z5z2tSzRhDeDre1kZA90LPyewkh7hQXLTDODH87zhmJV0tMfNjjtXVy+eEIf9eeyfvt6
         1/0xn2dTsKboD07o4gUhccjfx7LEzrd5IdS2vz4WCL5Tz03irryDIgnfjKPOy2Rv81C2
         fu1Cdjri40+G22BLjzbUh4NUNPMTdaEnvkfCD0vC+HildblZ9F64uSD/g+6Drba4rkwb
         zkdQ==
X-Gm-Message-State: AOAM5328oRd2nSXalYu/yncpRINnsu7FhYjrOzzQdFtKW1t2+vPNGlx3
        w0f/rRRhbWDW9uic2hr73Uo=
X-Google-Smtp-Source: ABdhPJzxTV1dSsxPfjfISsftArC1aH0zRY7a8pR10BotXiZlJqW8zXt7QCNfbT+w45SYb8OZHSDQUg==
X-Received: by 2002:a63:4e48:: with SMTP id o8mr7872574pgl.90.1602172494164;
        Thu, 08 Oct 2020 08:54:54 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:53 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 049/117] iwlwifi: runtime: set _FWRT_DEBUGFS_READ_FILE_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:01 +0000
Message-Id: <20201008155209.18025-49-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 93b167c13a3a ("iwlwifi: runtime: sync FW and host clocks for logs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index 267ad4eddb5c..c0edf6fb3760 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -122,6 +122,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.open = _iwl_dbgfs_##name##_open,				\
 	.llseek = generic_file_llseek,					\
 	.release = _iwl_dbgfs_release,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define FWRT_DEBUGFS_WRITE_WRAPPER(name, buflen, argtype)		\
-- 
2.17.1

