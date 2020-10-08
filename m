Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937BE28792C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbgJHP6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731304AbgJHP6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:58:00 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7ABC061755;
        Thu,  8 Oct 2020 08:58:00 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id p11so2971029pld.5;
        Thu, 08 Oct 2020 08:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Vi/uvIU4As/0xtGvRtE9Jkkrv2Lonp4zCWVLlkY6kUA=;
        b=dioAxuHDgHXAlqAFhMdW/xNV5JdZVM+50buKUO338zXAip/piZ03SLvYEL2jbD66QO
         CD1uqRA70e0wWcBTQb+bkiltk1vFWeHAOcn2mIZvSTDOnl2/w1oqyzjHGkaRsmCQq2Oi
         vDTgqO7wYi51+WNRn0f3IP+//PsaambVvdZHvpxKFYYLpDVyxm523fmZValaIjazDcOd
         01rD97ZqMQZWaMJBPOfF+vm+FwIBbTYN7MNN3Agy2S2vIpBM00lVuxopcwHm4vU3+6XN
         yztFIa0oyGC8YRSyhCYQc201KInL0WRU0HrIk5qS4JgJA3jopu2gei2HV/u1Tf9SUEnA
         yjEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Vi/uvIU4As/0xtGvRtE9Jkkrv2Lonp4zCWVLlkY6kUA=;
        b=joaCzU/oeHY0xnUX9+FNMl5NR8SgCVsm/RPFJ/LEyEPzOifpbCZEVFLqUr310mroHn
         2TQWRo99g9PYQtetTNmfWswUtFXP6XLl7v5MONAPRy1EdRESqAFj7bSVTQlQedYef1sQ
         zBJckq6m/l4F4sYgkJPXtGttI05KnF8KLRPvYWTEtw5YrK3OOW12hXpCAR2FaWF/pG/M
         yAO3+oANtjSzUxnRVE7jxkoTqVo1bNbYbie4X0t8GXinrjsZcL9HxbhiWQpJyE+o4UTF
         abRrLjbe6+4LdjVwxkAE3MLB/6zmUIMBrhtg75RsG7D28orhPkPipKTUC3bhRKa/bid5
         iZxw==
X-Gm-Message-State: AOAM533nTi28SQoeZMWYt9iOcmRsUbBLaNuhsDUjEHICmpBKtCDkFg63
        jlrSdGrmrtHsYgt95SgFnRQ=
X-Google-Smtp-Source: ABdhPJzVlmgLtpFfsv47C7gbxvtPADVuv4mOyJjqIe5YkIRLKRDMiUls06HuNRFJgs6A0BzKrUL2aQ==
X-Received: by 2002:a17:902:7c8d:b029:d2:80bd:2f30 with SMTP id y13-20020a1709027c8db02900d280bd2f30mr8171020pll.22.1602172679793;
        Thu, 08 Oct 2020 08:57:59 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:59 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 109/117] Bluetooth: set test_smp_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:52:01 +0000
Message-Id: <20201008155209.18025-109-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 64dd374eac15 ("Bluetooth: Export SMP selftest result in debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/bluetooth/smp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 9b96a2d85e86..3b91f927aab5 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -3752,6 +3752,7 @@ static const struct file_operations test_smp_fops = {
 	.open		= simple_open,
 	.read		= test_smp_read,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static int __init run_selftests(struct crypto_shash *tfm_cmac,
-- 
2.17.1

