Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AECCF192AD9
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 15:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgCYONF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 10:13:05 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33402 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727546AbgCYONE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 10:13:04 -0400
Received: by mail-lj1-f196.google.com with SMTP id f20so2649224ljm.0
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 07:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ZwW24+4pVyVTdc4hTZ9bgyJklHJBzgAw8V7+P6HiMuE=;
        b=llFVJ0Ec03Z/stVzpEXsmuptCiP6vCWWcAEA3z6t6EvusuuAz6jO++NWmdXYkutjKp
         8uUVwLlSf0Dn+Wla5iZ5GnNaWy+e4MWR0pwO15pmai9mv1VAIO1CMFSQyGpdGCZDGsnK
         iOwyd3Bm7hSFgKDI++WQ+CIiw0g/rxmvEUDpJ56GVwFw7ECYQr7bSttkCKvkymHr3B8H
         qoSMn6g5BS4lCS3um7XNLbbL5cGdLeo0sbTc5XGuGFcxEhASdu8UJ/iMolr6t5sLNPVn
         eU/CtMf/20yc5VH5vfQAmyQjrzEMa8dJV2pIlekq3qh9p7KkK0+YT8BfVwBu3nh/Kngk
         0Gkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZwW24+4pVyVTdc4hTZ9bgyJklHJBzgAw8V7+P6HiMuE=;
        b=qWCmhkAgGwmuU1xjyN7iarSgMTwTBMTBnb/2jc4thR+BzmZzVurtqYQoYyqFitFXAb
         c9tQirxbE9aEc4edur3fQXq43h4D3Qkqa3ajCSMpzX18mrQQtsgyxrD7s9ZySenvfcR+
         Myb7dwXsYj201cBWp0QiE3m5jzQhS8AUxa84pEqdchN2SU1PJh/SbnOuL6lLqFPV+Paj
         9nq7qZuC3FAo6p94L4yEqK6zbmnqyrH0knf53xLojFDT+QOSDgTuBGzD1dVFlHa5pNOw
         76W9NvHt4NMHSOcwNDYPdVfCrsYNhcDIoSlc9NUNFap4QYTcxqsBeikkzKscHs6o4SaM
         Yyzg==
X-Gm-Message-State: ANhLgQ0nHyAPA+qyBR9jphlxVhs4YzZQBEkISdqbMh3/ziy/1N933GUo
        nq+aYQze6TGC/LFAJHmo0K7tD7v2I84=
X-Google-Smtp-Source: ADFU+vtWN0UHzyVYmcRwNlCg9uLOwulM9G/LE3xh55sLvZxVEaE6oUpa+K2pMRsIPmziplXdH6Vgnw==
X-Received: by 2002:a2e:818e:: with SMTP id e14mr2136610ljg.225.1585145581601;
        Wed, 25 Mar 2020 07:13:01 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.40.234])
        by smtp.gmail.com with ESMTPSA id b23sm11824862lff.64.2020.03.25.07.13.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 07:13:01 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     hawk@kernel.org, ilias.apalodimas@linaro.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH net-next] net: page pool: allow to pass zero flags to page_pool_init()
Date:   Wed, 25 Mar 2020 17:12:55 +0300
Message-Id: <1585145575-14477-1-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

page pool API can be useful for non-DMA cases like
xen-netfront driver so let's allow to pass zero flags to
page pool flags.

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 net/core/page_pool.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 10d2b25..eeeb0d9 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -39,27 +39,29 @@ static int page_pool_init(struct page_pool *pool,
 	if (ring_qsize > 32768)
 		return -E2BIG;
 
-	/* DMA direction is either DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
-	 * DMA_BIDIRECTIONAL is for allowing page used for DMA sending,
-	 * which is the XDP_TX use-case.
-	 */
-	if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
-	    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
-		return -EINVAL;
-
-	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV) {
-		/* In order to request DMA-sync-for-device the page
-		 * needs to be mapped
+	if (pool->p.flags) {
+		/* DMA direction is either DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
+		 * DMA_BIDIRECTIONAL is for allowing page used for DMA sending,
+		 * which is the XDP_TX use-case.
 		 */
-		if (!(pool->p.flags & PP_FLAG_DMA_MAP))
+		if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
+		    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
 			return -EINVAL;
 
-		if (!pool->p.max_len)
-			return -EINVAL;
+		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV) {
+			/* In order to request DMA-sync-for-device the page
+			 * needs to be mapped
+			 */
+			if (!(pool->p.flags & PP_FLAG_DMA_MAP))
+				return -EINVAL;
 
-		/* pool->p.offset has to be set according to the address
-		 * offset used by the DMA engine to start copying rx data
-		 */
+			if (!pool->p.max_len)
+				return -EINVAL;
+
+			/* pool->p.offset has to be set according to the address
+			 * offset used by the DMA engine to start copying rx data
+			 */
+		}
 	}
 
 	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
-- 
1.8.3.1

