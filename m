Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B49B28791C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731900AbgJHP55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731092AbgJHP5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:48 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F126BC0613D2;
        Thu,  8 Oct 2020 08:57:47 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o25so4684082pgm.0;
        Thu, 08 Oct 2020 08:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NxnURy1s4bmeadcVdRKZqcVPbgw1zYNZ2MTGOvYb6yQ=;
        b=qFe4QMb8rFeMJwjDzyAsIw7K9u5YJI7IJn1POK0yfxA+t/4ncVdwo+KJfg0i8DeDQk
         X/nKdLPE1abCKiQaqReRoL6kht8X3TWeOf6m9rw2lXYpuxfCg8Hra9e0IpOUZRsviJV5
         6N3ZHsmBOTRrt7R6w/xIy39hvwmd2mCB8OKHhF/BpAHHgoI+NeIrCYReTqEruo3AwUms
         QIm5onkgl8FrMJLroVzDDhq/qp3fa/id+7066l+fYIUKg2Og6+1Kkt0eTcb9hsH9cg/U
         utuLNeqAXXGgek3kRs56nDZLMvipCLphn37w4cjukhDPojzZt719+Cba2xfLHiLQmNMz
         spng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NxnURy1s4bmeadcVdRKZqcVPbgw1zYNZ2MTGOvYb6yQ=;
        b=Kwnj7ATyywu2gRuhzarr73PfwAxSR3KJYM4n7yZiseEF+q0GM6ey9Jjqsh+Um90psl
         Fcxs9h0rAgjraHO0avqBRbLuvlsyMFfD7C6Zx2o9khyTpn3M6Lohg3mXHfHt8bZE1Xqr
         fyudlCQ7sqn0/BtMk0LZV43nG0CBoXj8h1pKpSBKCxx6tDEaEoLEKRj/ZlXwtUKfLAdx
         Bv/TYzk3kl7UZPUlGSk0yfA/N74/YPZOA2Xa78Ex1J9DxUAy6epel4QPI/MvKtKp86+K
         rXh84pBsW9HWDWvLkGmfDbjbxRkHyjPz76T01Z6oTiM0Rz4NDSxSkDEhFYwjfcko+Fwl
         /1pw==
X-Gm-Message-State: AOAM531+mTJAEmqzSzcRwMmBgrzz3QJBtBlZ3pJH700tZQzz6NhGAujo
        IAJvT2CY4e+PrCw5O3HHb4I=
X-Google-Smtp-Source: ABdhPJz82wlyC/FBgJacP82XyDXV85dEMtQmBBLl6szHYxSiicRplJ2iul00yk2eL4iYV7iU2udROA==
X-Received: by 2002:a63:5fcb:: with SMTP id t194mr3825125pgb.119.1602172667514;
        Thu, 08 Oct 2020 08:57:47 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:46 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 105/117] mt76: mt7915: set fops_sta_stats.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:57 +0000
Message-Id: <20201008155209.18025-105-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: ec9742a8f38e ("mt76: mt7915: add .sta_add_debugfs support")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 31ac338c5526..149686906ad4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -462,6 +462,7 @@ static const struct file_operations fops_sta_stats = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 void mt7915_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-- 
2.17.1

