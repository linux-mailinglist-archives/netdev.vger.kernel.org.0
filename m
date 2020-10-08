Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57791287854
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731518AbgJHPxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730261AbgJHPxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:22 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223CBC061755;
        Thu,  8 Oct 2020 08:53:21 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x5so2968421plo.6;
        Thu, 08 Oct 2020 08:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pUO0uGciYf9B2jjWdxKLGn4NNP/NOVzDPvkzC3p9CpU=;
        b=Kds+YHipmnCERQ0LB9Ergr3psOKKnJgAoLOQczggjKfQNZkjiryZH1p19hSjGGgk29
         czCXeRAdWNQ7OctT76/Nwk/Xd5D7/YjT0HzffA78O3orknhAFIdqOEwLhfxMbLpk0zN/
         dqx67AZJwVmFrcFZmckLmcs+WYfR+cHurPB0lDWFqFWuvT+3YkYC+0K3uUH9JP9VODNn
         cPhNq9eXoewGNFYzzwEQv3NF7klgg1Ur5mxMVU+caFFCOu0jpv3IeZBN8fVTRiUBa1DJ
         m2wvqtSOVgTIvx+gU2zEYHteoeb9DdDJ1sIRNUqmUVj9KT3d/pwBigLQHO4azPeozgjE
         huTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pUO0uGciYf9B2jjWdxKLGn4NNP/NOVzDPvkzC3p9CpU=;
        b=pn1soUv8ZLuOAPxZMomIkIHNxaad0LxNoyA8j0R1WUJqT3KNbbNEZZqcuXDX9Jg1tJ
         ce55HaLFA54ZpV50NCfuL/+BAfEZb8gp6T1vnKWK8qQk1dbUiPSeb6Cgt8GquYo8kI8P
         721jTdYDgKQQXkls4Avq001pexSwVZZJISgrZqWAp8j/F9yOR/nQF84bxA7jyXWS3mjR
         HqX8A1INBWrH8zyrU4Vcf+XFN+exaF5UBA7RUz7Rao1dV8CyFb4f+Ospvx7F7EvLjhqk
         76YJuroQlElOhwn79IB+H+74C3FWtIhE5Mn8euu11saCKxCve1oTnFiF5iku/dfxbX+u
         Hq9Q==
X-Gm-Message-State: AOAM533QbWu+/4H2DLSaeihN9BEeFApn1yfTB0wR7kybQkmfgqFar/HL
        zbNly3FIQFOmErAIV1oZsXE=
X-Google-Smtp-Source: ABdhPJzmyrBqmPMopKDPAkdOBFpCRw1w6CTro5OX3uSdy9oZAToSwaPyaeRbgSEJiRIm2iGBWGUzJg==
X-Received: by 2002:a17:902:7fc9:b029:d3:effa:7162 with SMTP id t9-20020a1709027fc9b02900d3effa7162mr8208091plb.69.1602172400676;
        Thu, 08 Oct 2020 08:53:20 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:19 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 019/117] net: hsr: set hsr_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:31 +0000
Message-Id: <20201008155209.18025-19-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: fc4ecaeebd26 ("net: hsr: add debugfs support for display node list")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index 7e11a6c35bc3..92ebb5ff41e4 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -90,6 +90,7 @@ static const struct file_operations hsr_fops = {
 	.read	= seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 /* hsr_debugfs_init - create hsr node_table file for dumping
-- 
2.17.1

