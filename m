Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108F928790D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgJHP5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731927AbgJHP5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:42 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A0FC061755;
        Thu,  8 Oct 2020 08:57:41 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x13so1724646pfa.9;
        Thu, 08 Oct 2020 08:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZcJvpCxZ9I2vMvuvbdBZLufH22DuxRSXW7G/b4Gx4qE=;
        b=BgqevvE+jeD3439VKy7MbG3JZ7kEjYY4WJM5FdSKThC5Yfwt89+KzH5I+J6LmxcWT1
         FBZO/BfWeApkJCQ6RT05ftnRUU4f22KFGw/xQHqKe851dRtfFByI/TA47vN5GiMQElGi
         PqzlO6DRL0dCoRVNNLCmb8K3nVvWsTw63PIW1clxT3zdYbNTn/M4hu0fHoxC2+Nupuhu
         2yfDgZnBX+syDgTJ5caRfNUxj83RaxMCEFKwNYKKyZIKwAxZh7t9KBjEjboGZfbegvVK
         i2RI0JGBzMluLwyWS9G3FUF/rdutWRKjDF/9E5cgectFr6cvkmdqJQvHCMVkiFQ+zmO6
         RvIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZcJvpCxZ9I2vMvuvbdBZLufH22DuxRSXW7G/b4Gx4qE=;
        b=BRAocvlpMH9AyZ7FFzF2d8wsIBYqHw+J2PUKCwK9AaO33o4NJwg9DBNfR3suIS89Fw
         GjkP4V8RsNtWloiFerTMluEigxN0b+kc19ZHCb0Rl+95pXHSZbY4RB5eLr6NTAmfs/uu
         GvjL4hSkclpm4VhbWCcK7V7UOta7n2RnRr/yraEkKjg/M8Cx0yUwHx0T1jQkS8mzL+h7
         5VDdp7xgY0NcxcaS+cpN+JkNgObEhfd5Sv3d28+/ikGkHasb5eCxIiGDcVPD+gJd/qqi
         F9Zp9rYJi2M8Ss5z1nTMGCxij+KvtCVTkx56Bma78p8hTefFFbop/2rf1ksAR1f6esWt
         azfw==
X-Gm-Message-State: AOAM533+UjT/NlsaL+NUf2MO1N2uMgapi71Epj4VIkr/GNOwkSdykJi0
        N/zirAmIgMAtyacyDb9EasU=
X-Google-Smtp-Source: ABdhPJzYMntBzjPM/ADyty0EBrnqpblHKEG1q9Qm7PrriQgle1UYKPFNNYPi3JUcDgNKYdWax9QkOw==
X-Received: by 2002:a17:90a:6343:: with SMTP id v3mr4609310pjs.109.1602172661135;
        Thu, 08 Oct 2020 08:57:41 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:40 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 103/117] mt76: set fops_ampdu_stat.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:55 +0000
Message-Id: <20201008155209.18025-103-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
index ff448a1ad4e3..7d7247a9b3ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
@@ -53,6 +53,7 @@ static const struct file_operations fops_ampdu_stat = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 static int
@@ -92,6 +93,7 @@ static const struct file_operations fops_dfs_stat = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 static int read_agc(struct seq_file *file, void *data)
-- 
2.17.1

