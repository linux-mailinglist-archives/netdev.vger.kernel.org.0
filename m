Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9652328790C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731960AbgJHP5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731929AbgJHP5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:42 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C946C0613D8;
        Thu,  8 Oct 2020 08:57:38 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f19so4326938pfj.11;
        Thu, 08 Oct 2020 08:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YqAJZHZtPZt3y+aav7S3myXA+GDLw0nhSzEfUGaYfeM=;
        b=XqV8UMUCnTMb5YLgD/gJydW8cPO8/PgfDDXPRIxvh6d11bwolQQMm7F9AU5SkEDLDL
         msmlElIvJSWJDjDpriiuAL9T5qqjoHri3kD/N138FhiCbR90+ucedvFwWADCy7MGuikV
         VWtgwOQ9ADIfqDuXDT5PBoV+3zr78qMIyMmfNpZRPzcKL6prlh+b41IWFAF4xWcgcbg8
         1Vemr4n81qtwLZi9Nak9NDaWpNxtv0EsxhQZPLLwMvlhXbK9NChZIXFuFRrgREXITZna
         aUVwz1QLf2D/EbSatPBMt1opcM6fPJ8wqSv6GLb0t7dq//o/r9Q4FEUY+p9H12pzyNWT
         gaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YqAJZHZtPZt3y+aav7S3myXA+GDLw0nhSzEfUGaYfeM=;
        b=fXWJRuTP6J4C9n33cAoDMFG22S6V5MUZg9Ilesmc9RzKPMLnytPKKHUKKPKc7vz3YQ
         OVIooF+hPwjB+xRPXkJLGamMYKs8/MUFPdiwEgP7m56tUEU3CXbsW+G+NqGwURvJ2Bsn
         HRITe9nJJK9zTBFxSx5DKzgX48SwO8fOBAV6kfZBpz0wF94rSEzAejIkugob+hxLM1rz
         T43k8oSMaUGdiWJvjD+VWfNIniZzwcu/OtRb5CkPiXVCfw4k1cUrPEZ1n2w1th98JZSt
         JdGvF0OEegvDVsV8fku0NdlulfcfFtqtNzka6A9nMPfRUa86bLsp3zp+bnEYUTE4Wc02
         o7Gg==
X-Gm-Message-State: AOAM532AQfyE1NDfTeavAs3HlbMB+xvARlxUfLaLzXm35G27BTmfXy7Q
        UnpTXuEUKiA0BYVVG3EhhCM=
X-Google-Smtp-Source: ABdhPJxuTQRMJDNb/VkGNUhXszcq2hcRAOtrVwql+kXMG3JDn7Bg9IkrWP9qmQw2PB6yyCzQweJqwA==
X-Received: by 2002:a17:90a:6443:: with SMTP id y3mr8725837pjm.150.1602172658136;
        Thu, 08 Oct 2020 08:57:38 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:37 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 102/117] mt76: mt7603: set fops_ampdu_stat.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:54 +0000
Message-Id: <20201008155209.18025-102-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 5a8d4678e02b ("mt76: mt7603: collect aggregation stats")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c
index 8ce6880b2bb8..af6fb67a6f7b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c
@@ -102,6 +102,7 @@ static const struct file_operations fops_ampdu_stat = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 void mt7603_init_debugfs(struct mt7603_dev *dev)
-- 
2.17.1

