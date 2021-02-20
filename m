Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5831F3203AD
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 05:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhBTEc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 23:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhBTEcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 23:32:55 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0D3C061574;
        Fri, 19 Feb 2021 20:32:14 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id e9so5398031pjj.0;
        Fri, 19 Feb 2021 20:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3yCttkUx212Ws6BTJ2fdRdVpLwAsB14QF6Ud0cGT18g=;
        b=k8PgyoRcuZ1594p6siTTyJGzzMHBC6odvBihaj3/CFzO3YkShOgf7bxgOVPLQCPMzh
         xFS2JNrRKMeJlWS4KuMVKJgxhMVar9Ewt1Xu3EJhZl7IO4ELKoTZ8+1a0pcWeUQHoWmH
         Ha6aISkSKmr2yrnWln5asJR/evaB/xP97BmGb1zXJyuZYPoj/NMNMGqLmIQDdObER+cj
         NyTTmyjG3xYurYn/xX6V7JKS1JuPz1mPkeCxqjgdjmpS7PjN5WqDEwA4nTHeWljWDmO4
         TKvD2rJhHUhJRqAQAffeenvgZS0DP5eHOka8PtWkh7LvIlH9qcNleV3jl0abgdjx6kib
         cdJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3yCttkUx212Ws6BTJ2fdRdVpLwAsB14QF6Ud0cGT18g=;
        b=WiRv/uBBpN22dx+fMoKOhHjNqIz2XgqoHFGNeAiUcmdZsQ0yR77sIoiH/RVRVTVy3f
         6gofws4HePclVBaw6ojMeoKZH6+fpsXQobyfHXmPOp2ocnv2Ojye2xKayhiIpYRKiSGs
         VvEJYA/2OxXNHIVDb8b0LrQQEuLJeE+dUYbcgxjSC+iBCO3Ispk+9/6ha0eA5UtkYmey
         Btlh3bnpHiGhmGu1FlcHUVK0GgV8nuqnzqbEGA6CGywSomieLefTdobemI4ug13biNOa
         jNHFclLHwKBWg++uvgq3+SPuXMHPF7lpdxKl4sKg5SkLW38Qqdqmva2o9Id7rke4OB0F
         z3cA==
X-Gm-Message-State: AOAM531li+vJHu1ormUFjVmtlK0fYrD7AH6tNdodjm1WyWxagsJnVoJs
        z+4p/tXI2wJ9EA6mqwe/PeA=
X-Google-Smtp-Source: ABdhPJyjMsBPPxTgwfCmU92cN2F38mcCH0tSp3aTPpoefPYnlTZC7hvk6Ps8gSmWs8zfRIHawXijvA==
X-Received: by 2002:a17:902:ed88:b029:e3:6b9f:9ac3 with SMTP id e8-20020a170902ed88b02900e36b9f9ac3mr5060522plj.72.1613795534208;
        Fri, 19 Feb 2021 20:32:14 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id ca19sm997054pjb.31.2021.02.19.20.32.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Feb 2021 20:32:13 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] arp: Remove the arp_hh_ops structure
Date:   Sat, 20 Feb 2021 12:32:03 +0800
Message-Id: <20210220043203.11754-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'arp_hh_ops' structure is similar to the 'arp_generic_ops' structure.
So remove the 'arp_hh_ops' structure.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/ipv4/arp.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 922dd73e5740..6d60d9b89286 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -135,14 +135,6 @@ static const struct neigh_ops arp_generic_ops = {
 	.connected_output =	neigh_connected_output,
 };
 
-static const struct neigh_ops arp_hh_ops = {
-	.family =		AF_INET,
-	.solicit =		arp_solicit,
-	.error_report =		arp_error_report,
-	.output =		neigh_resolve_output,
-	.connected_output =	neigh_resolve_output,
-};
-
 static const struct neigh_ops arp_direct_ops = {
 	.family =		AF_INET,
 	.output =		neigh_direct_output,
@@ -277,15 +269,10 @@ static int arp_constructor(struct neighbour *neigh)
 			memcpy(neigh->ha, dev->broadcast, dev->addr_len);
 		}
 
-		if (dev->header_ops->cache)
-			neigh->ops = &arp_hh_ops;
-		else
-			neigh->ops = &arp_generic_ops;
-
-		if (neigh->nud_state & NUD_VALID)
-			neigh->output = neigh->ops->connected_output;
+		if (!dev->header_ops->cache && (neigh->nud_state & NUD_VALID))
+			neigh->output = arp_generic_ops.connected_output;
 		else
-			neigh->output = neigh->ops->output;
+			neigh->output = arp_generic_ops.output;
 	}
 	return 0;
 }
-- 
2.29.0

