Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99794287843
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbgJHPxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731454AbgJHPxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:08 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0A7C061755;
        Thu,  8 Oct 2020 08:53:08 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y14so4314235pfp.13;
        Thu, 08 Oct 2020 08:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SN/h/ec9wr6n93of2IHwVep4zGi4gUdHrJLbLv07L5A=;
        b=ti6G6+EzJVHxdbAZ0/zRcN7XZ7kCQzf8cbvHWDYmLKa0MbxopRnxuPGK3PmX4EGLhE
         6AmiLXQl3TLy18v+4NwzA8gzUxBrq2hnFlLNSr705yEsIyuB8C98MylGiH3/tZmifqVM
         bmD6Xr6T8Kp8YJz+8K2LK7tfvJhj7V2g3gRjobo6PfE1FywYHNFrMP/W2nHfbhQP589w
         dHrxv28qQkx3rmOV+yL/dlFJqu/gyGhHEqYs0wZLqi8L4BOW8EglEUZHenRqYuplFlMa
         KzRyLTtsUh0IFwenckNK2BW8eSv+rfqXCzxSlzMBpsWQv4ldMBoQdS1GrU0tAcQVDW4Z
         aZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SN/h/ec9wr6n93of2IHwVep4zGi4gUdHrJLbLv07L5A=;
        b=jMt5qIESxBF6A987IgvcChxbW95oWeLinwuyxWLlEB/dPPtjxadm7SiA3vOm3cCiAh
         AAc8cUD0K+OQ97aDTXOl/fN54bnSvykEG4n3yGuACsOtH35JDBPC0e5k7vcXFVX0y9f2
         elpB0+UvLL9o3C3+40OnFLcoX06wH0mheO2sD201VO/kRU5HRj4ZWJI6jBsGszh5k2OK
         x4FCQCXzemgnn/0KPDUSeR1d+tU/1e+TvB171teXLPGrWcU0fvn54dx45GBHI0yptppV
         Gg8o0NRj99agPcskhPXFG19HNbuCuNTxJkAahot+GTOgpxGJn6woOAUMlv+BApKT6qHI
         Ot7w==
X-Gm-Message-State: AOAM530PI1Yw9AHzRy2MCh5is34SHNs7Z9M5Xav/7c/+ALFyjzNiS4b/
        OIXPrkS8F+VnXJu4rdsuHH0=
X-Google-Smtp-Source: ABdhPJz5PXnURxHKFu03oL8B1P31ytQ9vNmy2lGyrApPbIUR4ec60EByFpNFzLXePZrJN5H9Mtbo7w==
X-Received: by 2002:a62:1d52:0:b029:152:3cf6:e2a8 with SMTP id d79-20020a621d520000b02901523cf6e2a8mr8089828pfd.46.1602172387915;
        Thu, 08 Oct 2020 08:53:07 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:07 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 015/117] mac80211: set reset_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:27 +0000
Message-Id: <20201008155209.18025-15-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 827b1fb44b7e ("mac80211: resume properly, add suspend/resume test")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index a3f3e3add3c2..97eec43a6945 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -359,6 +359,7 @@ static const struct file_operations reset_ops = {
 	.write = reset_write,
 	.open = simple_open,
 	.llseek = noop_llseek,
+	.owner = THIS_MODULE,
 };
 #endif
 
-- 
2.17.1

