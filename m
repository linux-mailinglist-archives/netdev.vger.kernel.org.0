Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA61F2878CA
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730582AbgJHP4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731426AbgJHPzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:47 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7BEC0613D2;
        Thu,  8 Oct 2020 08:55:47 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 144so4341402pfb.4;
        Thu, 08 Oct 2020 08:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IwF10ypWvazPHutI4WwM/WKSMkEpUIYjJO1G7I8jtpI=;
        b=QBTc5vPv2sTw1E5yrTXbQUzoEeaG7dLrhmTh7+jMrOJE0lROs5X3eZ+6R5kQRJOu4C
         5GjPCTDkguRXbz+soEnjjVpPkC2UN4TKDDcwoTu/xvw8s+UORkD0xgW7FPFhLukYYaxT
         5mOCxpLCd+zBXQhfNq4d7MHjMU+0lV2xiP03PY9AhvjtIPVZLrbUuTdXlcH5To3CqCPE
         XqHIKD/IiB1NBN4OkR5YY4WbsIVT+c4wEnI8IHE3bK6V6m/EC7N6Hqg1IBn+fpzQZ6hu
         e9KCmKJahRcwvix4tikjEHOZY9/bcZdBOBUXdA9flOifEX1kOZu/Hazb0SLafNdSQxJy
         SJgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IwF10ypWvazPHutI4WwM/WKSMkEpUIYjJO1G7I8jtpI=;
        b=n8m73ckZzN+Zgje53CXdaW/2FsyfQx/jC7MKILY7E4QOOCDfKrPCZPjb0nErOBFDGd
         S3WMBy1Jij3vEQ8g4ZiLT5MXaW7/yPS2OQlZsnU66jId4l3WRZXQATkE5kHoyxiOBDYR
         +SBD8zHJGAi2fIlGQSCqwIvSAq8QmxiEI6U/71QbR0/pLMzFamOffxtGxKE2FvFmX/G/
         rkX3aF6F4VRJP6PwVxDbcd6aJvNct2e21VYugz2yHmtIPUv1s65IodQSqn1PGB7zKji9
         5ygPwVwjxK8F+5lelQLQ2DnYyGyJUaTNQ05nOzOAUdScFchxcl7gpoU9/n21rjDfGJao
         IwgQ==
X-Gm-Message-State: AOAM531mK2ZhTemDlhVN8Q6momFTfhy2kPQFkdnPzHzmhzi4U6Tujtev
        qlka5bvMNT6lpzimTO7fA5F/FrMy5sw=
X-Google-Smtp-Source: ABdhPJxrrJEVMtlETNHQ1Ypiti4TssNb6+O3Z+Wm06TPH+4/HXcTuaFFKeMagQZvnPbO7UAn1ORMUA==
X-Received: by 2002:a62:7c09:0:b029:152:60c9:43b2 with SMTP id x9-20020a627c090000b029015260c943b2mr8078945pfc.79.1602172546678;
        Thu, 08 Oct 2020 08:55:46 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:45 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 066/117] ath11k: set fops_pktlog_filter.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:18 +0000
Message-Id: <20201008155209.18025-66-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/ath11k/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/debug.c b/drivers/net/wireless/ath/ath11k/debug.c
index 8494ddbef7e7..da085c0a01ed 100644
--- a/drivers/net/wireless/ath/ath11k/debug.c
+++ b/drivers/net/wireless/ath/ath11k/debug.c
@@ -1123,7 +1123,8 @@ static ssize_t ath11k_read_pktlog_filter(struct file *file,
 static const struct file_operations fops_pktlog_filter = {
 	.read = ath11k_read_pktlog_filter,
 	.write = ath11k_write_pktlog_filter,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t ath11k_write_simulate_radar(struct file *file,
-- 
2.17.1

