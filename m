Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A05358939
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfF0RrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:47:02 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42672 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfF0Rq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:46:56 -0400
Received: by mail-pl1-f195.google.com with SMTP id ay6so1669633plb.9;
        Thu, 27 Jun 2019 10:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3wa5l7pG8nLarObGGKN3KC/Gb1Kl6rdRUespqtYtHG8=;
        b=fyt47It0FsoAa43d3HHQUuYgnPjg0K6miz356RanzK/2I24lD7i7WNXbVmjt/A5n2Z
         t4Y0nyxSStJeQDCRUGjyM7xaQw8H+ZGJwhvLD/b4r9KBzr1LAEbR69QADE0K+/VYT+k/
         yDUPkxZIj2zmuU+rSHUWiiRi59L9CfbEqqr7hibtaJ4ar8+HDPLuthKg5A5gg17fcOlS
         tHic8COMI65R5N7PZbUto8u21yhxpM2/kLgR79pAYvwhioaMNWG/K0ZaWySYuGiwkN2t
         bNB2S+8lDR4cOKS5LcTbSvtQaKvnwGliOwkU63oX753qKTHHIjTpi32zruFBsxoFBD8H
         qHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3wa5l7pG8nLarObGGKN3KC/Gb1Kl6rdRUespqtYtHG8=;
        b=fcjOTlQekj4aAmkQs8R7zAJbNyZSiWgmsDJV0P/2OLgFlvRlHz1F0WZbAQFLwmBoJk
         0RlmMbxmXbygzn6o1F05qg3kWKPD6EfPu2COmCrjIyMW8pkKSsfuQgLXbO2lsBZriX41
         xJFKYLdpk39K2CmXezBmAHN7eDEIpmOCrzFsuJzl8qEycZyBgjZJpBp4dHNBXYXypbFV
         XR8U8gz4nipzSujcdWyVw4YNGXNpHgCkeGnmPh2nbJR9jrK7JkQipZjD0c7vVbbRnd/u
         MzHdvb4ba/OmZvjxv5wYQIatZghgKgR8PIpLBBkC/jL+kIqGCL6h0N5NlOhlQh2cSfFM
         uiMg==
X-Gm-Message-State: APjAAAXfbJBKamHDDD1WzUlxFu4yaG94ujhDTXd3AwLcnrsL3cqfQOWN
        BHXcDcyiErXpRPadSD+q37k=
X-Google-Smtp-Source: APXvYqxXu+B9kCvR5mIxJJI6LdGLiS/TAYqKF49tPPw1HLFdZI9/AshW4sZ39kReUVjuMpv2Uz4icQ==
X-Received: by 2002:a17:902:b20d:: with SMTP id t13mr5748282plr.229.1561657616140;
        Thu, 27 Jun 2019 10:46:56 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id o13sm9559352pje.28.2019.06.27.10.46.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:46:55 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 74/87] ethernet: jme.c: remove memset after dma_alloc_coherent
Date:   Fri, 28 Jun 2019 01:46:49 +0800
Message-Id: <20190627174649.6580-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/ethernet/jme.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 76b7b7b85e35..0b668357db4d 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -582,11 +582,6 @@ jme_setup_tx_resources(struct jme_adapter *jme)
 	if (unlikely(!(txring->bufinf)))
 		goto err_free_txring;
 
-	/*
-	 * Initialize Transmit Descriptors
-	 */
-	memset(txring->alloc, 0, TX_RING_ALLOC_SIZE(jme->tx_ring_size));
-
 	return 0;
 
 err_free_txring:
-- 
2.11.0

