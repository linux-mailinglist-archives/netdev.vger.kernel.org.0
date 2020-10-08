Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BDC2878FE
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbgJHP5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730841AbgJHP5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:01 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197A4C0613D3;
        Thu,  8 Oct 2020 08:57:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id bb1so2976448plb.2;
        Thu, 08 Oct 2020 08:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3VzWT6HRJEnNHiHoLIsKjth52BnG0NvlFKcBX62YyM0=;
        b=eRffuTuaGe7Gb5Uq8P8NBEkKBUdy54730DcWmbr47yKkOa0xlXuZFXQ8RqDPEHVtqO
         U0LDRel+QoWvrQI9dHaSsMxGXCh6/ABjIRl+2KgN4Kp56Idk/RKk8xCNE7ikrhk34Dvf
         zdpcNRASG4huKYYRNWMnWfdJDy3Iz8Ivq/EeS4uPw5sRJUzKJGBtmxGF67BprSzo//94
         57emobn1BbKHpHttAAntLCrUPU9QzhEUTFVO4qa6bLU2KmiKY3CrAzT3q8t/tatJOoSh
         Li105n8L6ut1lfdg7Snsk8TBHIW4TNM97h4Ws9cqpHxWuxb1RKUr0eYVlLuHjaYkTUpW
         USkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3VzWT6HRJEnNHiHoLIsKjth52BnG0NvlFKcBX62YyM0=;
        b=BTaE4VN3kKtT8AirshouXsed+QB6UQpL7tfawt6dHMEjwjZnOqwBqncY8ZJQ7XEhFO
         DIJgcXKlqtWA+iEvqn9BhhSv5WWpiofiUEmJE2bIsSDLqZuh+PbhQfb6bIooB4Fle/Rw
         ksueM+/1crzT9WAWo23PQjd3d4IzGhcG38Nb+yyjMh/FZtehBS/mZVt2n2XAcViO37v+
         WCnCr4W5VS8Bgpshd1GZe/URjqDUw1wfZ4KQ4IjGbZi+vxF+qZtjSIJXpYhEzi5S0aFg
         elZjqdy766WC8yJE1X58/W4K60RhV0j4iVREOnyjD7VLitb7BNpAxQ2ymISg+xEFdP0e
         IUXQ==
X-Gm-Message-State: AOAM530+Hudx7IMDcy+10R1AGYEqGkk1sKZXcHaxTVQAXyo2y5Ik/Fya
        093RrpPnojRXf5dq3cuU09g=
X-Google-Smtp-Source: ABdhPJwCQ9Tz2atCw6gPI6xCPGKCnnrppBjAltGzgFT2SB8yvxP6fvYWuDU0khDerQJ6nGDeUoQD1A==
X-Received: by 2002:a17:902:a613:b029:d3:8afc:da51 with SMTP id u19-20020a170902a613b02900d38afcda51mr8056463plq.19.1602172620660;
        Thu, 08 Oct 2020 08:57:00 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:59 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 090/117] wil6210: set fops_fw_capabilities.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:42 +0000
Message-Id: <20201008155209.18025-90-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 12bace75704e ("wil6210: extract firmware capabilities from FW file")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index c4c159656eb6..b147b97c0d5e 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -2204,6 +2204,7 @@ static const struct file_operations fops_fw_capabilities = {
 	.release	= single_release,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
+	.owner		= THIS_MODULE,
 };
 
 /*---------FW version------------*/
-- 
2.17.1

