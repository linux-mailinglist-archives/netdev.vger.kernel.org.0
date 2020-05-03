Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4CC1C2E8D
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 20:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgECSmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 14:42:31 -0400
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:38368 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728885AbgECSma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 14:42:30 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 49FZbn6K8Yz9vKb6
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 18:42:29 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ss0bsYN8bzuB for <netdev@vger.kernel.org>;
        Sun,  3 May 2020 13:42:29 -0500 (CDT)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 49FZbn54sYz9vKb7
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 13:42:29 -0500 (CDT)
Received: by mail-qk1-f197.google.com with SMTP id l19so16350377qki.14
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 11:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bERp/MYvY8iJVrv+YyRIQ4+dlCYQm4dIrcl0kh2LDyo=;
        b=hfOL75fLvjbGbVxKB87MExbY9F02snj66SbPvO8kdUaggICaYHLVp/qCtZzzCtC2mH
         E2uKFokuep4sIyLzQYmN71qOvzZ03GmkhPSYyad+8vAO1rX/1by6o04eyUBIdgcycLy3
         ffS88SixMFKoZpu7h2Csig3yiBI6SmAtQEiy8pcR/sVN42R5cMpVzs5SMrtQ9bDLoAPA
         /YTHguQZSjHIE/Y8a+4QOKF3UvmEVEZc+4OAth5ke/1r9wCOaemnCs/KTs53YlmjZdlT
         /FR0lpGugJIeUNHJra/mQ2KUZh7IgRCPGhTgbgZdtb8/JtBolkkb9eOGFv4pyUA9VPB0
         E7Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bERp/MYvY8iJVrv+YyRIQ4+dlCYQm4dIrcl0kh2LDyo=;
        b=ThJJKInP9M8zlgjsaCJZdqkEu8HMgsT57zXLBJwwloToXYF8ZSUaM3layVOaGhaF8W
         TXLD9K1IT5pw4cy5zbfHk6Gn3YKrUPNqIZUjeji2N+aT2fBH6uba7DZWYjR4lPw1vYpw
         Otye0G/XasJQIEC/RuS+ZCqBbgGvK/9mw3xpmx8RcoTPtPv27axASnhk5R4+AU+Jww05
         H62wve5PQ7zMxYY7yo6c9mc0S5r41KR5OeAGg2o38DyG24YrrEL8jZhD1/ibVLAzh+jI
         AFEa4WdnN9JJ20GnzfTm6LZ1q/Dh9Kf5KEF52y9nzSygvFf5Sp6/bdC4FCH7k4w1PCCe
         sXaA==
X-Gm-Message-State: AGi0PuZon3v3m/jhKD+4RWJa5y39+bv/k4z8y6ldq1UM1BmjB4gqnvbk
        uP6vx4qENgd23u9tkq49EEaK2oh4BGiLrmEVpTnTzFqO26ayoa8eefjfDkavpWDJptrt3RKTHV0
        4J1/WjozPsKLkWdyFtwE3
X-Received: by 2002:a05:620a:137a:: with SMTP id d26mr2038290qkl.326.1588531348879;
        Sun, 03 May 2020 11:42:28 -0700 (PDT)
X-Google-Smtp-Source: APiQypLA5qkfVL5yPYKXJbyK42ZVvx1EOqC9Qilm0q8+o3zSvor5mHTWo0MFNOxKcABMSC71qMKOig==
X-Received: by 2002:a05:620a:137a:: with SMTP id d26mr2038270qkl.326.1588531348490;
        Sun, 03 May 2020 11:42:28 -0700 (PDT)
Received: from qiushi.dtc.umn.edu (cs-kh5248-02-umh.cs.umn.edu. [128.101.106.4])
        by smtp.gmail.com with ESMTPSA id o43sm8769039qtb.49.2020.05.03.11.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 11:42:27 -0700 (PDT)
From:   wu000273@umn.edu
To:     kuba@kernel.org
Cc:     davem@davemloft.net, Markus.Elfring@web.de,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kjlu@umn.edu, wu000273@umn.edu
Subject: [PATCH v2] nfp: abm: Fix incomplete release of system resources in nfp_abm_vnic_set_mac()
Date:   Sun,  3 May 2020 13:42:20 -0500
Message-Id: <20200503184220.6209-1-wu000273@umn.edu>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

In function nfp_abm_vnic_set_mac, pointer nsp is allocated by nfp_nsp_open.
But when nfp_nsp_has_hwinfo_lookup fail, the pointer is not released,
which can lead to a memory leak bug. Thus add a call of the function
“nfp_nsp_close” for the completion of the exception handling.

Fixes: f6e71efdf9fb1 ("nfp: abm: look up MAC addresses via management FW")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
---
 drivers/net/ethernet/netronome/nfp/abm/main.c | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/main.c b/drivers/net/ethernet/netronome/nfp/abm/main.c
index 9183b3e85d21..a5152f11e2f5 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/main.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/main.c
@@ -265,8 +265,7 @@ nfp_abm_vnic_set_mac(struct nfp_pf *pf, struct nfp_abm *abm, struct nfp_net *nn,
 
 	if (id > pf->eth_tbl->count) {
 		nfp_warn(pf->cpp, "No entry for persistent MAC address\n");
-		eth_hw_addr_random(nn->dp.netdev);
-		return;
+		goto generate_random_address;
 	}
 
 	snprintf(hwinfo, sizeof(hwinfo), "eth%u.mac.pf%u",
@@ -276,14 +275,13 @@ nfp_abm_vnic_set_mac(struct nfp_pf *pf, struct nfp_abm *abm, struct nfp_net *nn,
 	if (IS_ERR(nsp)) {
 		nfp_warn(pf->cpp, "Failed to access the NSP for persistent MAC address: %ld\n",
 			 PTR_ERR(nsp));
-		eth_hw_addr_random(nn->dp.netdev);
-		return;
+		goto generate_random_address;
 	}
 
 	if (!nfp_nsp_has_hwinfo_lookup(nsp)) {
 		nfp_warn(pf->cpp, "NSP doesn't support PF MAC generation\n");
-		eth_hw_addr_random(nn->dp.netdev);
-		return;
+		nfp_nsp_close(nsp);
+		goto generate_random_address;
 	}
 
 	err = nfp_nsp_hwinfo_lookup(nsp, hwinfo, sizeof(hwinfo));
@@ -291,8 +289,7 @@ nfp_abm_vnic_set_mac(struct nfp_pf *pf, struct nfp_abm *abm, struct nfp_net *nn,
 	if (err) {
 		nfp_warn(pf->cpp, "Reading persistent MAC address failed: %d\n",
 			 err);
-		eth_hw_addr_random(nn->dp.netdev);
-		return;
+		goto generate_random_address;
 	}
 
 	if (sscanf(hwinfo, "%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx",
@@ -300,12 +297,15 @@ nfp_abm_vnic_set_mac(struct nfp_pf *pf, struct nfp_abm *abm, struct nfp_net *nn,
 		   &mac_addr[3], &mac_addr[4], &mac_addr[5]) != 6) {
 		nfp_warn(pf->cpp, "Can't parse persistent MAC address (%s)\n",
 			 hwinfo);
-		eth_hw_addr_random(nn->dp.netdev);
-		return;
+		goto generate_random_address;
 	}
 
 	ether_addr_copy(nn->dp.netdev->dev_addr, mac_addr);
 	ether_addr_copy(nn->dp.netdev->perm_addr, mac_addr);
+
+generate_random_address:
+	eth_hw_addr_random(nn->dp.netdev);
+	return;
 }
 
 static int
-- 
2.17.1

