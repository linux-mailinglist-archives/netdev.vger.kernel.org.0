Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4DC287864
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731569AbgJHPyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729756AbgJHPx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:27 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D2FC061755;
        Thu,  8 Oct 2020 08:53:27 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m15so2959821pls.8;
        Thu, 08 Oct 2020 08:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DFiII6K/5zzohX7htLZ/WMzaT9KKafZRq9CyEt/q/uk=;
        b=TIuCrZSyTzqaCTwFEJWGoeASTgjCQsgEIDnIdDDzAgO+8w49Qun4sWOIU0auzIRlZH
         6M7a0uRZpAJXJYHrukv073aGIIhDc+Q51u3L7nx9QN2NsUZvcDFEeymCdIbaTQ3jn4op
         hyELTdGPL+LTU24J8R4PZMzdQB3F4HquLJpj4zEr5M/7J6079qPEkYWZGamUyelr4yu6
         vWj7Bged37xn+doD71RjMTt/LgygpYnXgCVlwOsNBVpU9l/ybQBPSAVER9aOmem+sbWO
         7vIlGQtosiOVxOk4MEhf6LIfPuD7bMgv81OANy2LqsLPPwfjzP9IcfKhSlbI5s1TXlsg
         rA9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DFiII6K/5zzohX7htLZ/WMzaT9KKafZRq9CyEt/q/uk=;
        b=WpXd0fkKAGGNO4vXkTNwr7VMUb05m7a6/IizmTjKYfleA+0bjzqleGpRfSP0ZLrGkx
         ex7SORuTobMNtUFAIxvFiYZorjR35gW34pwgwUT4JihWhjfw6AKcjSONamKOmAIf1MRl
         GDWmXYZ5j1+3KSFrNCqgqKH90piVtWPLHGYFTuNvK58vx0re0H8wUEAr2fijyZimBA6M
         6oJrzUGqnl4mvG78pVgXHpPxaBFamDEH6utpMQL7xM+vMP3NykGoGfK13FMBV4XlN9L2
         b4aYx1YO0T1V/hAgWH/cTWo+qMC/Go0kIrjzW44W+9Y08mqtsUoPe2SdXt1lZkCTZme0
         NC0A==
X-Gm-Message-State: AOAM532xYVcWldBOcviISFblyWAuxBu4Sc0H7dH3hb9w/lc6QJM70Tzp
        DfYrXFnTGXYsWD5g5SfHfgs=
X-Google-Smtp-Source: ABdhPJzUwB8RERt6vcR9D0FtQY9efGeGWzI31hEgPHo+6w8cp9I8etdxoc+Lz4A1OVvuGfu5oTBNfw==
X-Received: by 2002:a17:902:8215:b029:d3:8afd:522e with SMTP id x21-20020a1709028215b02900d38afd522emr8243747pln.47.1602172406762;
        Thu, 08 Oct 2020 08:53:26 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:26 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 021/117] 6lowpan: iphc: set lowpan_ctx_pfx_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:33 +0000
Message-Id: <20201008155209.18025-21-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 5609c185f24d ("6lowpan: iphc: add support for stateful compression")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/6lowpan/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/6lowpan/debugfs.c b/net/6lowpan/debugfs.c
index 1c140af06d52..29c3627a00e2 100644
--- a/net/6lowpan/debugfs.c
+++ b/net/6lowpan/debugfs.c
@@ -161,6 +161,7 @@ static const struct file_operations lowpan_ctx_pfx_fops = {
 	.write		= lowpan_ctx_pfx_write,
 	.llseek		= seq_lseek,
 	.release	= single_release,
+	.owner		= THIS_MODULE,
 };
 
 static void lowpan_dev_debugfs_ctx_init(struct net_device *dev,
-- 
2.17.1

