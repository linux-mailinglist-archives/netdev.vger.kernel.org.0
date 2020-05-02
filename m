Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820B71C28AC
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 00:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbgEBWuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 18:50:04 -0400
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:54294 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728581AbgEBWuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 18:50:03 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 May 2020 18:50:03 EDT
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 49F3zy3xg1z9vCDJ
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 22:43:10 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id i_3Y5xIXtJAQ for <netdev@vger.kernel.org>;
        Sat,  2 May 2020 17:43:10 -0500 (CDT)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 49F3zy2t6vz9vCD1
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 17:43:10 -0500 (CDT)
Received: by mail-qt1-f197.google.com with SMTP id z3so15874203qtb.6
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 15:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=KR1J6K/N/jgMtmPG7Tj5KjyDT0kXwPVMrBemGwfcPxM=;
        b=PKTnIp3Pp+s6IVQhP198ve09phFiYcts74X67JMi3qpMhxginR5r/ZHjyWetLSWgpn
         GRLkmBXBageZfi/3I4BiDAnqAxm2oKXTfqKpypSPfPhy3oDEXEqIa57TfDvHoSUqZFyF
         TdSEMr68j6SydX9Ct12JCG3rXxClXGMeK4oAKmbIJbAKCRm1nes812WBiLwaDTB98JDg
         fdlvPZsF7Ke1PZC+6JH/oOBkWi56+Bn3nOQqcw/Ko3emhpsKRMFhud9upozve7BbgCGo
         triXpGg7S7Q8WXp072G5ZHOjkiYvh0r5ALUPQwh9zifi8wWXcNKJm4rwLmxPHra6StJx
         nTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KR1J6K/N/jgMtmPG7Tj5KjyDT0kXwPVMrBemGwfcPxM=;
        b=TtR3fFQMBYTknaz2jyu6faQaW86ZvJI2xxUQfpRP5c72mfKLNIKMCgkxqQipq7mqno
         SYf4J//aD2Kin0h9/IUsNLUL3AUI+Q3i/Jq/tnGM3+xTgKTHbaHi2wxYAjDICSF66PNU
         /FLazvTWLnf2sCyfw0xJruqtY0GhD6aAy0Ad8jxnApAs8VngvpF33wGGlVZZg+EKtSKA
         b57/mVK2poTxEsBNMMkvYPued3FN1bc90fFT5wTGtIEeD0HNlw2d8wL4+cQ5j56L7fH8
         bb+jlcMc5RenxxFCS+s5m5Vzhp0Qa9yw2Gp9a9IdK3X36YOfLOSV4AwTLjzts3hrZPmT
         xDkA==
X-Gm-Message-State: AGi0PuZki4PK6JvQNKIXkew8LxQcVsNZhf98f7ykHD0oMXgIB5XTNBz1
        9PyovFBn2Pzaj2bKQZTPBvSlAV2/kU8L4bMXobAGTfMQ1cR2+1VIdsPYEtPVikW7nshxaGKH2sx
        pDtx2zhGwh+CFXraymijR
X-Received: by 2002:ac8:39a7:: with SMTP id v36mr10349297qte.387.1588459389749;
        Sat, 02 May 2020 15:43:09 -0700 (PDT)
X-Google-Smtp-Source: APiQypJVoXz32Eihyqk5u9MNYq2tHVXWisKM8exVuCyk24JqmZEeXkVmiFsvZFVPDfijC7XmCArdfw==
X-Received: by 2002:ac8:39a7:: with SMTP id v36mr10349272qte.387.1588459389296;
        Sat, 02 May 2020 15:43:09 -0700 (PDT)
Received: from qiushi.dtc.umn.edu (cs-kh5248-02-umh.cs.umn.edu. [128.101.106.4])
        by smtp.gmail.com with ESMTPSA id u24sm5896172qkk.84.2020.05.02.15.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 15:43:08 -0700 (PDT)
From:   wu000273@umn.edu
To:     kuba@kernel.org
Cc:     davem@davemloft.net, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kjlu@umn.edu,
        wu000273@umn.edu
Subject: [PATCH] nfp: abm: fix a memory leak bug
Date:   Sat,  2 May 2020 17:42:59 -0500
Message-Id: <20200502224259.1477-1-wu000273@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

In function nfp_abm_vnic_set_mac, pointer nsp is allocated by nfp_nsp_open.
But when nfp_nsp_has_hwinfo_lookup fail, the pointer is not released,
which can lead to a memory leak bug. Fix this issue by adding
nfp_nsp_close(nsp) in the error path.

Signed-off-by: Qiushi Wu <wu000273@umn.edu>
---
 drivers/net/ethernet/netronome/nfp/abm/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/main.c b/drivers/net/ethernet/netronome/nfp/abm/main.c
index 9183b3e85d21..354efffac0f9 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/main.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/main.c
@@ -283,6 +283,7 @@ nfp_abm_vnic_set_mac(struct nfp_pf *pf, struct nfp_abm *abm, struct nfp_net *nn,
 	if (!nfp_nsp_has_hwinfo_lookup(nsp)) {
 		nfp_warn(pf->cpp, "NSP doesn't support PF MAC generation\n");
 		eth_hw_addr_random(nn->dp.netdev);
+		nfp_nsp_close(nsp);
 		return;
 	}
 
-- 
2.17.1

