Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716EB62185D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbiKHPev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbiKHPeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:34:16 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83155800C;
        Tue,  8 Nov 2022 07:34:15 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id b62so13735104pgc.0;
        Tue, 08 Nov 2022 07:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u9swQkcBm/iCeAXMRTatWlWKKkWYvo/iunckk+egI0U=;
        b=BmxoWWkJGjMSlD+HeDoUF7gfsIWUFQH8lNzQcN99nVMf1uc3X/XLToM7G8Z+CdMVN6
         +Kp6Ar4yJ//fEoBuoVcwi1o3c+VqfDdpiugWm+91vVxKWwQHnk6Ox2dXJgRFVXm4DLc5
         x+9/OpdL94evi0a5XflJnDhupH9mHX58qPq8+xEZmFdiYsPvb57bkrhEkFEWE9hDEhbw
         g+V1v7QaVAjve3MhJU3VqDXwxs2kFzC6BIVVrXJlvYRPuFJrbE1F3KQS9YnjxA2NnFc9
         8Svwev98dFvJKACcRexT9nDTsdu6FKSnbCl/LQJ3hN+Bw/h8XAezF6lqcaHqfmeAlpRT
         7HxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u9swQkcBm/iCeAXMRTatWlWKKkWYvo/iunckk+egI0U=;
        b=Ul/scU7tC24JGsOb24IwCB6QvByNoMa+ugw8q40sJyUr7Yv9kl1Lkw4lg7DGQ6D6tm
         mYUcLETWQWBicdVxZmLUXGIm0aq62wFrnhcHRz02MZien4RiROM/5RU8bDmdQ3L4X+9r
         Z5P8UBBa7wMa02TCMlcMwC+dy5JQSLvS7uUwym91KmVHwHV4R6fnbGZ1Zrw79SmmwEa0
         zNxznKqK/qp5iFsOAf6T8EV1ULdLGw1kY4cZ2Bz6T9YAu1k3G1QQJwmd6CnC9wFipnSV
         WN90ixHcymfcGt6ws15JnWT28Bcgcy1GbQmFdabxPyjB3ATWefDW5luwiQdqOmU4u7qu
         iP8Q==
X-Gm-Message-State: ACrzQf2j5izHkzxMpzyDArCD0yL/Ylq/0viYnyyplwozl/5DCfCdfG0h
        g0uJOlP6rDgpKY5ZXl2ZqV3JGsmS67KGtQ==
X-Google-Smtp-Source: AMsMyM5LPYC3UUVut7WM+tpAT0zPvtzz0bjLpGVsU9SDNhmshG7oyggmbgXUxry4hPW9oc6anfs2pQ==
X-Received: by 2002:a63:6909:0:b0:41c:9f4f:a63c with SMTP id e9-20020a636909000000b0041c9f4fa63cmr50141108pgc.76.1667921655310;
        Tue, 08 Nov 2022 07:34:15 -0800 (PST)
Received: from localhost.localdomain ([203.158.52.158])
        by smtp.gmail.com with ESMTPSA id w10-20020a17090a460a00b00213202d77d9sm6243412pjg.43.2022.11.08.07.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 07:34:14 -0800 (PST)
From:   Albert Zhou <albert.zhou.50@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, nic_swsd@realtek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH net-next RFC 5/5] r8152: remove redundant code
Date:   Wed,  9 Nov 2022 02:33:42 +1100
Message-Id: <20221108153342.18979-6-albert.zhou.50@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221108153342.18979-1-albert.zhou.50@gmail.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the unused but defined macros TRUE, FALSE.

Remove commented code, which refers to the non-existent functions
r8156_*_eee.

Signed-off-by: Albert Zhou <albert.zhou.50@gmail.com>
---
 drivers/net/usb/r8152.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 10dff6a88093..6ffc89780c96 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -46,11 +46,6 @@
 #include <linux/mdio.h>
 #include <uapi/linux/mdio.h>
 
-#ifndef FALSE
-	#define TRUE	1
-	#define FALSE	0
-#endif
-
 enum rtl_cmd {
 	RTLTOOL_PLA_OCP_READ_DWORD = 0,
 	RTLTOOL_PLA_OCP_WRITE_DWORD,
@@ -19096,10 +19091,6 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->up			= rtl8156_up;
 		ops->down		= rtl8156_down;
 		ops->unload		= rtl8153_unload;
-//#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
-//		ops->eee_get		= r8156_get_eee;
-//		ops->eee_set		= r8156_set_eee;
-//#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8156_hw_phy_cfg_test;
 		ops->autosuspend_en	= rtl8156_runtime_enable;
-- 
2.34.1

