Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182D92878C5
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbgJHP4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730863AbgJHPz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:56 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C5EC061755;
        Thu,  8 Oct 2020 08:55:56 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id k8so4350743pfk.2;
        Thu, 08 Oct 2020 08:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pfuo+ODM7s9TgopEFYu+f8EPhwKyR/Vk60BRbvNfbcE=;
        b=loDdAqkjehHXL2LFmQD05nwtubzD3PrPJApWBJtl3c2DYHeEQFv5S35MzyUH/U+QvR
         hgRhgjeeR6UorbvN2XhVr+0VPu4fhJ4eAkk5efrCau532lhotQkEbU+cON3Uh2TCupv6
         wMWYAQrDhgtXORrBCJPHacCRw6h3t31T7+R3spgkD/zsbGUrn9KFsuCjfiTROGjAzdBd
         siLtih2x0IncE+noW51iH34gElmDmlbICfj/nCkQ7WiLidE+wCBfBg7X+S8bb+N+6YlQ
         PXldKkPbW+grfNFEnJqqTclwNtt/1eFuNyYh+ia1BvI/kLYrla9xiuYXJudo8YRZKsyz
         ONxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pfuo+ODM7s9TgopEFYu+f8EPhwKyR/Vk60BRbvNfbcE=;
        b=Yz33g8HIEczOJC21KuLLIA43OsYs9a1RzPMQ/41hNEr/9acxYYb+Gq3ZpwmLoDL8Xv
         Sl4ZkN4vaXLARnds56NL+RDk278YO8xh0fOyW1f6A+PS0h/S/eX9BwDKnS7FRF60eiDQ
         IWTB2qT16rTb83fe44os+RZRfGwnwE3roAqx+m4pJ2UMY/BGjHUEU74k3Awbh7kep/Qg
         ePYcPwWJEb/TzST8heOLZvJo3bg57Zj0YR4o4XF2PK8oxDzhYYqkj0ggWCaGAOpWZJbe
         IYJSYX/erS5OPdUprsrFaG3ybi69rwmcia3Y8yWfR6bYSCGni6N0RLndGDXqPwrWWAoQ
         ykbA==
X-Gm-Message-State: AOAM531qoBFuNNETcabH0FWHsM3KmAZrxwy8msDTfuqizMeancFaZALq
        5+oJO/MpoBfnR3JZRTCrTrI=
X-Google-Smtp-Source: ABdhPJzkgu6DSC0hnrRv1c8EXy11hP/vhmO0RIAaKy6zzxBp+Imc0CLMpK9h7c272JLzaEItTOefPA==
X-Received: by 2002:a17:90a:1702:: with SMTP id z2mr8983651pjd.88.1602172555908;
        Thu, 08 Oct 2020 08:55:55 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:55 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 069/117] ath10k: set fops_quiet_period.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:21 +0000
Message-Id: <20201008155209.18025-69-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 63fb32df9786 ("ath10k: add debugfs entry to configure quiet period")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 78bbb0380323..9789ef98d25b 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1956,7 +1956,8 @@ static ssize_t ath10k_read_quiet_period(struct file *file, char __user *ubuf,
 static const struct file_operations fops_quiet_period = {
 	.read = ath10k_read_quiet_period,
 	.write = ath10k_write_quiet_period,
-	.open = simple_open
+	.open = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t ath10k_write_btcoex(struct file *file,
-- 
2.17.1

