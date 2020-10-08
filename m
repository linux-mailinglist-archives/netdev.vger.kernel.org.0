Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2BB287945
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731005AbgJHP7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731022AbgJHP5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:23 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138D7C0613D2;
        Thu,  8 Oct 2020 08:57:23 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g9so4653571pgh.8;
        Thu, 08 Oct 2020 08:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CaLkc5S5r8gSYs29OL2G0vSN6v5EU5CqRKTlV3j+mYY=;
        b=AQxGsIKMGtEnJ858YgNSUlOBvPyn9/jeLJ9IZz4BDSvAwio3m+LC+8Fa8y3j5dr5gT
         VM1UkMv6hf4CK+Ax/SB/f9hd9iaxSdQOiqW91mqR27B1m+j//78GOw5frnO2ix8guo9+
         BWNvo/MD2tUOfe8v0Xc/nFIy1lEOD269yDqzkqZt1/0kJKwltNIgpi+w+dprF01VzlTz
         zlzfrq4wsYPOeXydpsRtBewDmbWh2TuR809Hu9JW0hCVeM4AfgO1q3VhYYQf/ESvxxDX
         FUsmgJZGn4koWpuIlzgXGu8+WyslW+bbe91MnIgdIdBqsY0LPuPrztoQHN4VG7bmCltU
         z3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CaLkc5S5r8gSYs29OL2G0vSN6v5EU5CqRKTlV3j+mYY=;
        b=qRXB/ecjR8xcpbR95u2EvKOnZOeM0X9zL3vs15glScNO47tepkCC7gQMQMsTkRCs/8
         qb9omva4wze18lxjVHQTGNbaKHFq0dtruNfhr9bDqevkL/O4oWJDsswU96g9LeR1A+D+
         2+dBEWelOiwpnjQLSVUAZwzuKR0rIM4lTnghHhhXkV6pdcpGKK2Wqpw8mqNBfoadovhH
         06r1ULeYpNDNGV3/Vyyu99mECmMO1e2TI07hfungTzzrw+t1Y5YCNlaKau1qO86edMPL
         YhFSO9nrv+IhVmjyBo+JJoh44qIZRolZA/wf/HY3oahiJGPl7YHHxe3fXuo7EKZ5NcWq
         9d5g==
X-Gm-Message-State: AOAM533gL1WZu3bOZX3qp9Sl9zixqGOZGSRYAGzDPBEwSDn3vg0uPnB6
        5Wt0Huog8BljMCdM4qIt0C4=
X-Google-Smtp-Source: ABdhPJwCdhSC6bolvS/nyhvC95zl36KHGmPOYCB8R7gEKtsb0aciVCUS7r6O+gCj16wF5c+/xYCQkg==
X-Received: by 2002:a17:90a:1704:: with SMTP id z4mr8767715pjd.7.1602172642647;
        Thu, 08 Oct 2020 08:57:22 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:21 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 097/117] b43: set B43_DEBUGFS_FOPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:49 +0000
Message-Id: <20201008155209.18025-97-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: e4d6b7951812 ("[B43]: add mac80211-based driver for modern BCM43xx devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/broadcom/b43/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/b43/debugfs.c b/drivers/net/wireless/broadcom/b43/debugfs.c
index 89a25aefb327..c0d51cb57b27 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -611,6 +611,7 @@ static ssize_t b43_debugfs_write(struct file *file,
 			.read	= b43_debugfs_read,		\
 			.write	= b43_debugfs_write,		\
 			.llseek = generic_file_llseek,		\
+			.owner = THIS_MODULE,			\
 		},						\
 		.file_struct_offset = offsetof(struct b43_dfsentry, \
 					       file_##name),	\
-- 
2.17.1

