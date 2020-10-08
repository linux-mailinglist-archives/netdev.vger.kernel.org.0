Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA932878AB
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731756AbgJHPzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731661AbgJHPzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:00 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC986C061755;
        Thu,  8 Oct 2020 08:55:00 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k8so4348607pfk.2;
        Thu, 08 Oct 2020 08:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZIr90SB4JyXvEm29mi4WS7PZx/zmULAaypR4P98y8xg=;
        b=NMw3OqpxXznTMO/QnXMmVIadDoYeMfuiP0dQEGaTEHmKuIgOj0v4pz1r10dPFwcugv
         ZpetOYIIB5jqaXiQ0JYBfKih7BNIjdOLPY0HGwA4MMu9ojvzzlnrmEK4GhRRzC+ocW8D
         8nhZu37r5cw0Jbwn2e/kUTWJzKjWN19muUiWRgSSm2xYQq37LwhXA5JjjvQULlyCfqbJ
         rgahj+ptYnilnPcPXx4eX+twfjRXy2NprRBOw6gjp0j6oMLyq+wjS+4NrGxTqQ2Iy1Rg
         vpqnwgEua4fl0eavi/UWe85n3w2blpvU8u2VBGXfPa81eaMkB4l/F47ScxDPauID1zwh
         tm4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZIr90SB4JyXvEm29mi4WS7PZx/zmULAaypR4P98y8xg=;
        b=Ql38rGuJxUuwcvytQZGTfqxdA6gjo6XFgZhZDV5vWj30rQmc9hqhPl18wUgvNNV7es
         2e96VsJzltduHsFa0ds4mGsYhjVtfTStYl7ucdY85g4A2EUn73PZMe2z/R7XdzPc+mOn
         DyK/xqn+lgHpBJQjkJUEoqUeJi1VLE5EB1XI1oggCxKj7b/zS9K3ecRVSH0XWPNIfTRJ
         2T64ZRGQS4TSkyNSxakpza7tCjp7xvH0OOaHTmJ66unfR8REgwns17XCKD5cEZ245nUb
         5atRBorMEtBWSTBSZ+ROIv7QKJ5wKcqbQrNtSnSlUwr+Lv8quy+u6SpIqMZyVcba5Fn/
         4VNg==
X-Gm-Message-State: AOAM532ArsVGgRY/g3f9GTzJhglAhVMKKio6rXbFmKG5Cx6m5qS4sG8Y
        ZLc1ctmG+HD3I5+UryLbk7Q=
X-Google-Smtp-Source: ABdhPJx/NmILHvpIE1XSkuf3cic9pyDSMk9sZTmPB21X6JXyodTkJjhsAv3Rd0xYKmrcsHg4MiaVfQ==
X-Received: by 2002:a17:90a:4f0f:: with SMTP id p15mr9134177pjh.10.1602172500472;
        Thu, 08 Oct 2020 08:55:00 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:59 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 051/117] iwlwifi: runtime: set _FWRT_DEBUGFS_WRITE_FILE_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:03 +0000
Message-Id: <20201008155209.18025-51-ap420073@gmail.com>
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
index d99ed6b2f781..5f41c8587ac6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -162,6 +162,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.open = _iwl_dbgfs_##name##_open,				\
 	.llseek = generic_file_llseek,					\
 	.release = _iwl_dbgfs_release,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define FWRT_DEBUGFS_READ_FILE_OPS(name, bufsz)				\
-- 
2.17.1

