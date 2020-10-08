Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179A4287939
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730837AbgJHP6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731653AbgJHP5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:41 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76890C0613D7;
        Thu,  8 Oct 2020 08:57:35 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id h6so4666496pgk.4;
        Thu, 08 Oct 2020 08:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ggn/qqDw5Ps9lvylNXGZ0/oCC+xNhAV2tZzyGJTLKUQ=;
        b=cLARU4vWvjD7XtiOATtJAR8hR/atiOfgHm43HPtfU7ygeCzWU6Xw1bY+N/WMIajuye
         iyxBKajfAS97/sG5JlOVywO87Zr3QWYDKtBgNiPFBzcPd25XNiGj1gomdDiyaOf0s4F0
         Ie01VjXpfXzhODLZaKxKP+aIeHaXLoW+2WHoGlDoQOTkoskCgW8jbMpQeU03qLA8UP55
         k68iTo1hLbCYn1N/K/UbpGlA4quhaKiEd2FdB75xx/xxT2POCnThb63fChsETjz5GJTC
         jVaQ66lEdj1CCjeBWen1ZOQ+CGsnzkJ1OHmX84h4pdYKI5p9EEjEfixm7/I6ZYNxgK/T
         wCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ggn/qqDw5Ps9lvylNXGZ0/oCC+xNhAV2tZzyGJTLKUQ=;
        b=h4oXof2LMjmrOZDgJ0q/zMRZVI7DZrZAlNMXwKhhx59+Ise2ta8UHk/yvFxhMZ5ua8
         o75drWhXTdRIspzlw5wLS2lZOWRFb9OpFsLStwKoLvQ2+Qs8yH/BcfeE/8f1xtMuIbmH
         lD6qA+eLpmqo83Mu+g5O5zN+DhSqaZ/+398yjaYaj852NoeTWeUq+2ZqVK6Y77xZDRJz
         bP6mSBQS8ucj83kmiPkf+WqTudJIhtl7XasOGHxacfmZaTvHFk5Ri47AK35WANfDkwRT
         KGI42IuvmLpzAuFxzveaq3BrH2XFD7iz+ewrAwirz3hIQfIgX0P0ylzMJkI6DVOxH+0j
         5w3w==
X-Gm-Message-State: AOAM530Ahd5ZtvO2zKbq4c2MS3tm6j1x/SzGMzamtpOjUE0awnBsF+VH
        TGPlU73819R1zahHcTwzzC0=
X-Google-Smtp-Source: ABdhPJx5cbuVpFRB6D8mk5ytn1H0QZcgNWFNr7Bb4JCuBaVfNfXRtB5y9ZuKvmBiv7sMoYLZQhMkVw==
X-Received: by 2002:a17:90b:118a:: with SMTP id gk10mr8427702pjb.218.1602172654767;
        Thu, 08 Oct 2020 08:57:34 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:34 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 101/117] mt76: mt7615: set fops_ampdu_stat.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:53 +0000
Message-Id: <20201008155209.18025-101-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 75601194a1c8 ("mt76: mt7615: collect aggregation stats")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
index 88931658a9fb..1770fa51f562 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
@@ -246,6 +246,7 @@ static const struct file_operations fops_ampdu_stat = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 static void
-- 
2.17.1

