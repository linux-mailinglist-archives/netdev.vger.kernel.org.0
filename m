Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43882878D0
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731796AbgJHP4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731781AbgJHP4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:12 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8F2C0613D7;
        Thu,  8 Oct 2020 08:56:11 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k8so4351349pfk.2;
        Thu, 08 Oct 2020 08:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sk5F78VcGPn+w7sgfEi3r97SHb8j3ok8zbS2IeIk1ug=;
        b=rKqP7eYmgW/tQFTs4r1JB9NYk3ez37im6n/Qlk1lPzoct+Sh5ayv2e4e3pj4RoaXD0
         xsoo9v951BK4whK1el3HMBiTW1IwS0uK+V6WChVgS3N1wmOvQfhT3CNe3XyGlbxYMX32
         vwBHz/lk/KJKQJVfg4lsrlUG5Qk+iEjxmLFi8Tz9wq+suumY/tLqtGYdmAlsWWsLjymm
         nZfixauEonWzu4YNSPv1K2bA4XgOOfQH5GrDyLO/r33PZL0HetiPQvLqr6oi0i2jhhYD
         LD3ksP7XzN/IskBx4bF2KbabsuMI9KD0lyo8DuyHU2XFSd53XKN2aJ/6AzpkUCfksHmG
         hzVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sk5F78VcGPn+w7sgfEi3r97SHb8j3ok8zbS2IeIk1ug=;
        b=sez5+BVrSA1poAibvklxJSQEwc8mAP8A16Gj0fUBIStkFl5rZtN1Yg9lWxr2AgxKUm
         ScOzKCHlO0ffM2ABRl8YWHJVW7rxMiRzLzkUCFJj4Ys7jZPvINOtntr6SEJjp9vCU9uz
         U8lDV4zwUie6kb3ceWLubyq33Hlf1NNrIRlbeMuhNMx/xeby4el552PxsulUPyIscmh5
         HjJa70RMnCpbBdnrx8KTbrW8giR0hgm14osv0Ca06Ap2fpFJ4t6Q3110WwaiVzp19cA7
         BplGjI66PkR3mAyW9AIfyOfcyXUOCuWB4kzEO4zMKJ7JEZvs2mowaFcg0sjZh+ytUeZT
         4Dlw==
X-Gm-Message-State: AOAM533GoAvrpLlfDSHB5pF0kDOYfCIJ4q5gpVwAE7CrJsWAaeeCVnu3
        v2prI3M7UXVEou+e+zDGexw=
X-Google-Smtp-Source: ABdhPJyNg5hR6o1q/hxSe6JG1qvI6LnFfYlPFM+KTr6/VSTtAScCOzjoNQgPn8PWyexy80zoOdKgJA==
X-Received: by 2002:a63:ba49:: with SMTP id l9mr312005pgu.246.1602172571471;
        Thu, 08 Oct 2020 08:56:11 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:10 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 074/117] wcn36xx: set fops_wcn36xx_dump.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:26 +0000
Message-Id: <20201008155209.18025-74-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/debug.c b/drivers/net/wireless/ath/wcn36xx/debug.c
index 6bd874c0a9f5..4b78be5c67e8 100644
--- a/drivers/net/wireless/ath/wcn36xx/debug.c
+++ b/drivers/net/wireless/ath/wcn36xx/debug.c
@@ -135,6 +135,7 @@ static ssize_t write_file_dump(struct file *file,
 static const struct file_operations fops_wcn36xx_dump = {
 	.open = simple_open,
 	.write =       write_file_dump,
+	.owner = THIS_MODULE,
 };
 
 #define ADD_FILE(name, mode, fop, priv_data)		\
-- 
2.17.1

