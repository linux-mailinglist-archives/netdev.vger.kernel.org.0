Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5535287904
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731886AbgJHP5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730964AbgJHP5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:16 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CF9C0613D6;
        Thu,  8 Oct 2020 08:57:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id p11so2969904pld.5;
        Thu, 08 Oct 2020 08:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zsp1f6T9aoXrg33z2WLXsW7tDdYDHFrfejg8cWxOAW0=;
        b=hH6tKUwVNX/VZTnsKe6BVDRizmh/E2bW7dtzMQsznnVdsx7wS3cAhDUHf6SU3J5vV8
         mRp5ggQrtSaM2eAGo6FHEA6wVAr0WCf/LJ0AkMfiU0jbzNqBcrs/k7D0K7XC87uAVxpB
         /p3U6hxSrhphXk9Ks/qajwW5dLJRlUlw/a0ypAQaZGuFMOTb2Dh4rIMqv09eSdFPlxRt
         loQdK6Fj2EmnxO+1w7KuuX2OLJHiHcUarkLYWyt0/+AEA9oMGN+qzl1qeueCtpTLAzbk
         L+ja1jodgbFeGhKQoP1a/CG36zAJJmK16Etza+ZMCMdlIlfQ69JWCYIDje4+7RUBitAJ
         jcig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zsp1f6T9aoXrg33z2WLXsW7tDdYDHFrfejg8cWxOAW0=;
        b=sXHujbSN0uQJp6AIawTHyAoq3uCFmQ9dmYoggA945zHDfpA+Ql41ytwHAcUWFepoho
         YAqJYxgewGDuFt2YCS9XUF34TS4jP4jSqzgbGaOX+8F/C/WPKcsC/G7Vlas4/vF9eEHg
         jZb0tYqpJAxNov69hiQOeCGZBNV9kosAi2970ILVvOmUyxOgmVPRCcTBHNRBOFU8llJA
         IFIUm+F61k4/reyzERHQz/v237wi/wHWEC0VZtxoIVxJnOboSrKxiQSokMTH48CiwVrL
         wA7gX+qwIxQ/9KrdaxONiNowhDJ0b0j31V70I+YxSMLcU4DRiRfy7TBoz4cpMWgkbRBe
         oxsg==
X-Gm-Message-State: AOAM531dGhU3FimZ5WEcZPNR1zr+fJNeD9NX1+OiJE3BbFrR+RSdoIOf
        c0pGlVmdlx8IPnJZPm8Gz9U=
X-Google-Smtp-Source: ABdhPJyyKdDdvSy66qo3o3uJbwvSEO42tCf5MC3wYGNmZtLposigy0O2iJRsp5dINeyOcu06bHIUtw==
X-Received: by 2002:a17:902:b211:b029:d2:1fde:d452 with SMTP id t17-20020a170902b211b02900d21fded452mr8088462plr.36.1602172630050;
        Thu, 08 Oct 2020 08:57:10 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:09 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 093/117] wil6210: set fops_compressed_rx_status.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:45 +0000
Message-Id: <20201008155209.18025-93-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 96c93589e2df ("wil6210: initialize TX and RX enhanced DMA rings")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 4ac558f95586..7540c49aba3f 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -2347,6 +2347,7 @@ static const struct file_operations fops_compressed_rx_status = {
 	.read = seq_read,
 	.write = wil_compressed_rx_status_write,
 	.llseek	= seq_lseek,
+	.owner = THIS_MODULE,
 };
 
 /*----------------*/
-- 
2.17.1

