Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4368D463C1E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243613AbhK3QsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:48:04 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:54840 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238301AbhK3QsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 11:48:04 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 4J3Sk45pSwz9vmdP
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 16:44:44 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZBV2sM4W-aFm for <netdev@vger.kernel.org>;
        Tue, 30 Nov 2021 10:44:44 -0600 (CST)
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 4J3Sk43mBtz9vmdn
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 10:44:44 -0600 (CST)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p6.oit.umn.edu 4J3Sk43mBtz9vmdn
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p6.oit.umn.edu 4J3Sk43mBtz9vmdn
Received: by mail-pf1-f197.google.com with SMTP id y68-20020a626447000000b004a2b2d0c39eso13134162pfb.14
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 08:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PaeiLQYvyxb/egvfxneLGShNKX/REnwSjHvw37uaFCI=;
        b=kAglzTGrPgxrNYWpODLwneomdarMnjBmCEYpHzg0mlyiVGI8yhZ1Xw14DA/bayXBVe
         Rvl0VOLQ4PfZsfMPAOYNe1uRNZ/53wiOyS0KL4koX1fOTDxWq1OVasd1H4ZR9Aa2cgaM
         i/VZuQjRQU2Sx1fZrVJR6rdTlzlBy+67tzFvX2W5cyv5ykIfljv8lbxm/GjagVUZdbPa
         sNkJmQWE+BWadlmYSikko3EY6/p7tfaEbzuyTL1h5+ZsuquCHRc8Pi3j5+kHCz+Aqj8w
         +IAQ4N1+Ngwj6jGwvH/wLj0k9cHN/35oFv4MTr8NUyK1IblMMUC8X10oBjhpBJ3Bnnav
         kQMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PaeiLQYvyxb/egvfxneLGShNKX/REnwSjHvw37uaFCI=;
        b=n0EC5X7nKakBvp7r+lF/q5f4yNmVc8R/qQNdalWIQRJDHICFrHx9Jot9EhOIxw5GTo
         lObg9CsLmjUEn8wdQy6vh0FHsCCZg60+ffpRs5B6fTjRau8bL/A7C4hRolaOOKriUK3X
         y/KPlXcoL+jB8QwCwqCfmgXUsnVjD7rmXR7CzrkrYLSqxcjDJT4IWF6Epx4fSLVeOkJF
         DqZh5gf/nXrqbRlbT5awdRr5jujAbxWJ+IhTQmneGDqky1ZoIwuiEj65z1jfR4kGFiPf
         +t0Rq5TvG6lRjsMNRkpjvjIFRmbhIYHI8W2gdjeB+JDkRPOvr0t4QgHlC6zmyFUJkTlj
         4aPA==
X-Gm-Message-State: AOAM5301qnbijwRcRMYaxzrJDPGJTJHOBdgS+sDUvOaBCJVyHcIQveeK
        sEuKOL9m/E5cMd3wqlC0fdfzK/oWuTGwvIGfViRNsuQIoWPNbRSk/sCwExlkQC3oFAYH28/S0/f
        qWGv3bm8bPE8krGcpRJaJ
X-Received: by 2002:a17:90b:1b4b:: with SMTP id nv11mr33539pjb.131.1638290683708;
        Tue, 30 Nov 2021 08:44:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6D96bJSvgqWrNljSraQswVWeIyQsJHaWNZcj0Nla/JfAsxMD4xnJDOQqOo92m0zTctmI0rw==
X-Received: by 2002:a17:90b:1b4b:: with SMTP id nv11mr33518pjb.131.1638290683492;
        Tue, 30 Nov 2021 08:44:43 -0800 (PST)
Received: from zqy787-GE5S.lan ([36.7.42.137])
        by smtp.gmail.com with ESMTPSA id c35sm15304312pgm.67.2021.11.30.08.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 08:44:43 -0800 (PST)
From:   Zhou Qingyang <zhou1615@umn.edu>
To:     zhou1615@umn.edu
Cc:     kjlu@umn.edu, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx4_en: Fix an use-after-free bug in mlx4_en_try_alloc_resources()
Date:   Wed,  1 Dec 2021 00:44:38 +0800
Message-Id: <20211130164438.190591-1-zhou1615@umn.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mlx4_en_try_alloc_resources(), mlx4_en_copy_priv() is called and
tmp->tx_cq will be freed on the error path of mlx4_en_copy_priv().
After that mlx4_en_alloc_resources() is called and there is a dereference
of &tmp->tx_cq[t][i] in mlx4_en_alloc_resources(), which could lead to
a use after free problem on failure of mlx4_en_copy_priv().

Fix this bug by adding a check of mlx4_en_copy_priv()

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_MLX4_EN=m show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: ec25bc04ed8e ("net/mlx4_en: Add resilience in low memory systems")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 3f6d5c384637..f1c10f2bda78 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2286,9 +2286,14 @@ int mlx4_en_try_alloc_resources(struct mlx4_en_priv *priv,
 				bool carry_xdp_prog)
 {
 	struct bpf_prog *xdp_prog;
-	int i, t;
+	int i, t, ret;
 
-	mlx4_en_copy_priv(tmp, priv, prof);
+	ret = mlx4_en_copy_priv(tmp, priv, prof);
+	if (ret) {
+		en_warn(priv, "%s: mlx4_en_copy_priv() failed, return\n",
+			__func__);
+		return ret;
+	}
 
 	if (mlx4_en_alloc_resources(tmp)) {
 		en_warn(priv,
-- 
2.25.1

