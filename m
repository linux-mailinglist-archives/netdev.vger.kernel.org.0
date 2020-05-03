Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252271C2F4C
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 22:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgECUtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 16:49:46 -0400
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:50070 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbgECUtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 16:49:43 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 49FdQZ74Tcz9vKT9
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 20:49:42 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6zqyLlleS0ij for <netdev@vger.kernel.org>;
        Sun,  3 May 2020 15:49:42 -0500 (CDT)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 49FdQZ5npYz9vKT0
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:49:42 -0500 (CDT)
Received: by mail-qt1-f200.google.com with SMTP id q43so18516138qtj.11
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 13:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zSYYMjCer/k9tmJ7ZZe4YO3vkQ6QJMlcwBfIN/y6pU4=;
        b=S4jyhd/m97dQjajh3P06TxKvTaD5NanIRG9+JD9GuZVN+HHjK92aLTnnMkH914pr3J
         E6MJi1qP/gWWjsfaKqEkDrLTePribNxLCtgLQE87Iwgg5aCFd0VkEZhjYW+INF0HEYJ5
         FvQf6AccCvuhnHLXSvretDJxSYjoGoREO+iyqbGFL51LcoCySRjgTteR8+fy08cPuncp
         fYNp8G+yqikiMNpn8/KK2gWKysFCslyJf24GhdE1IpxNMTnqcJTnTYUypsQPfVm+5qbI
         y8rGLXqF4+FIJslak9Qq8gxi/Pyv8iqMoLtNcvJP4313bI1YaDGPppuLjK2NhLlvmRB4
         2xDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zSYYMjCer/k9tmJ7ZZe4YO3vkQ6QJMlcwBfIN/y6pU4=;
        b=fPOYEYG5/Fu2ik0xKf0JT70D+GN3hVKu0X238Cm/pepIyUCyAkz8r7l2fBQouZaAHU
         Lf9DymX9N0wyJioXbJpsh5PUGNJYwFA9zsxRgZRchRWT14kkibKZFUOFM6w6F5YIlqnu
         FrENjaHQnuPEH+3RZw5GPWA40aqFaLMg5/yyDJh/X/BTAUSlE7ejCZujlLxzeTyXwD1h
         REs2OO1fRH4UWTIzKKV9aQAMZWOSkghxmfLd+OuSun4KWeHGlNbb+nS8FT2r0Zd+xKsp
         CyeBKlLbcrsugpVsIWm+kmoLigbaGPJrulMz2FHomtgxOyezs8m7Ud9biCNvBXAiqd9u
         fnQQ==
X-Gm-Message-State: AGi0PuYSCE2TrElEo1nRKAT2eQMP2SwfIvc+9EAJRR/ZKCohd8ubhgZy
        1RrwduwIJWisMziXgomcRHrmBrfBL+GWGPczL1vssRYrh8DVCQDhOQksb9cJGmJIAB0Rv5L/70m
        x4kezOfAHpIE+4vdvoKgg
X-Received: by 2002:a37:4955:: with SMTP id w82mr12151030qka.240.1588538981655;
        Sun, 03 May 2020 13:49:41 -0700 (PDT)
X-Google-Smtp-Source: APiQypL/yRI3pvKwp5EcSRyFRyzRWgGDsy73tBk0Bjk1YTubstQEXIh8JCXYenyVhJAmb49/eivC6w==
X-Received: by 2002:a37:4955:: with SMTP id w82mr12151006qka.240.1588538981093;
        Sun, 03 May 2020 13:49:41 -0700 (PDT)
Received: from qiushi.dtc.umn.edu (cs-kh5248-02-umh.cs.umn.edu. [128.101.106.4])
        by smtp.gmail.com with ESMTPSA id a124sm8366919qkf.93.2020.05.03.13.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 13:49:40 -0700 (PDT)
From:   wu000273@umn.edu
To:     kuba@kernel.org
Cc:     davem@davemloft.net, Markus.Elfring@web.de,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kjlu@umn.edu, wu000273@umn.edu
Subject: [PATCH v3] nfp: abm: Fix incomplete release of system resources in nfp_abm_vnic_set_mac()
Date:   Sun,  3 May 2020 15:49:32 -0500
Message-Id: <20200503204932.11167-1-wu000273@umn.edu>
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
 drivers/net/ethernet/netronome/nfp/abm/main.c | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/main.c b/drivers/net/ethernet/netronome/nfp/abm/main.c
index 9183b3e85d21..f196789f62fe 100644
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
@@ -300,12 +297,16 @@ nfp_abm_vnic_set_mac(struct nfp_pf *pf, struct nfp_abm *abm, struct nfp_net *nn,
 		   &mac_addr[3], &mac_addr[4], &mac_addr[5]) != 6) {
 		nfp_warn(pf->cpp, "Can't parse persistent MAC address (%s)\n",
 			 hwinfo);
-		eth_hw_addr_random(nn->dp.netdev);
-		return;
+		goto generate_random_address;
 	}
 
 	ether_addr_copy(nn->dp.netdev->dev_addr, mac_addr);
 	ether_addr_copy(nn->dp.netdev->perm_addr, mac_addr);
+	return;
+
+generate_random_address:
+	eth_hw_addr_random(nn->dp.netdev);
+	return;
 }
 
 static int
-- 
2.17.1

