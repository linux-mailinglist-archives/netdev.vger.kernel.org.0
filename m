Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF2D444ECA
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 07:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhKDGYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 02:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhKDGYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 02:24:48 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009A6C061714;
        Wed,  3 Nov 2021 23:22:10 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x64so4856421pfd.6;
        Wed, 03 Nov 2021 23:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZMnc+RdzGFexAA80bF3zG73sNj3BpUf7giuC8WuGlDI=;
        b=oiyLfsWklzdS/vpdi8mS4Vz2uAHcX/+QWXpVamLnCzdaqjm6BQuczB1ktfcOkUSi4t
         mIK2ukUqrFRi7/oLfklHNuXxfptwRnkkIex9leUQIKsBNu49ZXu6u3ADgGUgC3UeKW1I
         35NcbhNHkXPqfGp+SLe9kiWfoRjhVJGgXmGmLjo4QirdihcNe0FZvu9jX1KB0u15citr
         qV/m/QxfdPyXSgmSWQoCgi6SZNW1/9V8oX4HWifU45mScJohaTSQB8v3m/s7zGkTMFgw
         kf1g8rKzq7d2Qf2R97Wg2N+WU2gHtmZ1BQRJSP+dAowU2g5QQoQBvf6PRe22QOHTghem
         3p/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZMnc+RdzGFexAA80bF3zG73sNj3BpUf7giuC8WuGlDI=;
        b=IigdpWF0jS/whcnmszKOcLEL93x6p0zkPo8HNiVZ+0Li8tbcoOV1NkzsiJiplePv5o
         KLr1yzfQqo2gEN5fPuvo8BA9Z2cI7lwzeVwndh4eB9m4yg1deWWmcF8QCtn3DVCd/yfL
         BKSyE6CWz1T1mNZNJIJ0XAFG2NRdcY6/DU1SToQ8oT4UdzdpaS1w9+NyEGiqVaLy6bSM
         p86mbLP7FT7XmzcNbOVbnXAmr8TekRH+78toMGD/jPkCjQJdSyW9p4oEk+jJhwuVUiHC
         HbwOoBh0ec+JgwKoR5RA5upHJ1ffk1CSENCu4sLYQqKj5PJ75KAbyFrYdvxwgcYy1Ltz
         vZQA==
X-Gm-Message-State: AOAM533RhI0TG/ASTIc6BVO3DEOQdBAphrchC68RRx95elnRPON1JlUh
        zOvy22BtXz/lQzhVmwd8QHg=
X-Google-Smtp-Source: ABdhPJwK0lNxtD55HRIkVJRtCGHDv0L7yhL3+zBMQTxLASxtUrH91l1JSfjSeLB+DOZniwks3t4wEQ==
X-Received: by 2002:a63:6881:: with SMTP id d123mr20788473pgc.68.1636006930568;
        Wed, 03 Nov 2021 23:22:10 -0700 (PDT)
Received: from debian11-dev-61.localdomain (192.243.120.180.16clouds.com. [192.243.120.180])
        by smtp.gmail.com with ESMTPSA id bf19sm6572608pjb.6.2021.11.03.23.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 23:22:10 -0700 (PDT)
From:   davidcomponentone@gmail.com
X-Google-Original-From: yang.guang5@zte.com.cn
To:     sgoutham@marvell.com
Cc:     davidcomponentone@gmail.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, hkelam@marvell.com,
        sbhatta@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] octeontx2-af: use swap() to make code cleaner
Date:   Thu,  4 Nov 2021 14:21:58 +0800
Message-Id: <20211104062158.1506043-1-yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index bb6b42bbefa4..c0005a1feee6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2450,9 +2450,7 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
 		bmap = mcam->bmap_reverse;
 		start = mcam->bmap_entries - start;
 		end = mcam->bmap_entries - end;
-		index = start;
-		start = end;
-		end = index;
+		swap(start, end);
 	} else {
 		bmap = mcam->bmap;
 	}
-- 
2.30.2

