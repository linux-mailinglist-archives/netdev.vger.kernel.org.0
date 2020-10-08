Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A51287881
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731360AbgJHPyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbgJHPy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:29 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D86C061755;
        Thu,  8 Oct 2020 08:54:29 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g29so4675322pgl.2;
        Thu, 08 Oct 2020 08:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=579xXxImxTayvwBd6InvITipqEeAafl3+1V6cI6/h+I=;
        b=qNW+UWgdykPHg0LsjsZbO++r1pXLf4LxfkjTfwPLkJjOk+aXPe0YSse2FeTMz54AzB
         AT3NhftsVRve5NUTcRVq2qJRwFWsdxyEE9RiLhLElVSeBLvRgU64bqdN5K4pXO+x6Xa9
         3fbYzD75MKCuQ93gN90GNTojCPvHAHkJNs5zSVw3raYr9X63t4OD9ZNeyZrKs7V9LBf8
         3fPufwkDKw6nSuGhDPZQkcBs+e7nfTVrl/xE/C2PiRrJI+t/vIKDWgTT0yJ+OrElNBWF
         K16puDrOAwlN/oLcAKISmvCdJjxur1XxQR8azDZxcZ0RhFfoQ+H+GFcw67nt0DNz4JRN
         QOLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=579xXxImxTayvwBd6InvITipqEeAafl3+1V6cI6/h+I=;
        b=QvlqJFc5/g3ACRwTiCq2tCIBbPc7anuDGVk0j8jW5CodItjtW3UJh6JacnIOcvciul
         GUJVwPwVShk3cc7dmtCMDkoP79mERSwV+3UQNgaZVTD9aKF8G0MsR+AZoMH15m3Y43hT
         H8KiBJLvMnZugIACg9AxJ8ysTDBTqmRF0J3QMV94NDaNXvg29eWerRVvmvY/EDHavzwL
         uf9xbyPkJG/L7xvbzHoSS/nW4/66G5WmlGu2Ei+cKUAI/rDCLWinjhsACzZ510UZj6t8
         mpiWVHrLMGZ/aYZP6q9Nyb1LW4mndGZSrp+SSS6rpOy1BiDKkgiYFzYCNlPK7uZuLLlB
         bcAw==
X-Gm-Message-State: AOAM532/gEhnHScG/3Jo/J5eOdtCBB7bTVFroajZyiN96RW6Wl6F7S0Q
        H/SqHOVN0CXJYmzi4B/EPH/WAkbbOSE=
X-Google-Smtp-Source: ABdhPJyjrSBMa7L5sihGR1U7PPuHkxfJpc8v1Z3zMFmlpLsl8aqx4YTvyumzwfIQXCLi2zsUYHnAyQ==
X-Received: by 2002:a63:b18:: with SMTP id 24mr5526672pgl.214.1602172468795;
        Thu, 08 Oct 2020 08:54:28 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:28 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 041/117] iwlwifi: set DEBUGFS_READ_FILE_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:53 +0000
Message-Id: <20201008155209.18025-41-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 712b6cf57a53 ("iwlwifi: Add debugfs to iwl core")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index 911049201838..ac65141f0b3b 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -34,6 +34,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_WRITE_FILE_OPS(name)                                    \
-- 
2.17.1

