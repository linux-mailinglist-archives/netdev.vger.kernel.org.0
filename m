Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE084F74EC
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 06:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240779AbiDGEo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 00:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240750AbiDGEox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 00:44:53 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DED1017F0;
        Wed,  6 Apr 2022 21:42:51 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id dr20so8297902ejc.6;
        Wed, 06 Apr 2022 21:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n4HcXuOXAZE6zoHCC/T33DPT/bULLpPnOSYZG5xwNiM=;
        b=OYCMJRqmnh+B04rA+lkcc6Tlxx/poyV9w7qffpk4eAaYIEU3DKUsnhDwnIxKU96asq
         2NIgU9uLB3YkkzlgSAnq0ZPUrN/vC+Nq0K7hDQCZdFRC6e4fSdUigklwY/7f4WXMaW8x
         YZ47E5a982hGjh6fepld1dKvkAmch7se4vGCilW+j6dsX2yQ8U1STz4WkwJf9nwtPMjC
         Lx7TCjiJdQ74ZTwN612hxYTgsnWCrhMbTg9+zZYWeReSDkPR6NbY/20/VzaAQYY40Far
         +2Dz3KIjT+AUYIjo17uM3qsRp61sE8+ofojcRhaI6MMEz6gpDLbaZ94ofPgdp4PHnEaU
         e+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n4HcXuOXAZE6zoHCC/T33DPT/bULLpPnOSYZG5xwNiM=;
        b=qKu5gWzSeRh1+pIxdqFKR4yRacWNjohu7a7yxYWW7X/KjEbBHxU6AgA0Ku7poWAZvm
         DZ1aNRLFWGn2+yJ8MrqFE9CZV+CCCzclgO7tvbUq/72XqzvNZnMeFvW+J2xmj1apodew
         ooYqPHsyYXBnJgyrdN/5eiHnCFF8Wr8gMePWd7VI31sajoB6FToyqsBccN+Isq5CmY1k
         1UiqXTwg9NdzMQvQizujEV7mnhbziy0MfeGDtGmgcg2n392youXGlQB5yw39GRK5o+u1
         CJ7PGgOtkurS+wmry/bUeBTBfwOcgZHC5brAj/ZkYQxS3Pf6ewW3SKRFqZen0LUX942F
         kLdw==
X-Gm-Message-State: AOAM530vNH1QmfdZ/9OhrQUhUxW8MbOfdR74QmEWZzU6GBobIRb2dlhs
        kkyAg7chlSPYvpI16F7oBqY=
X-Google-Smtp-Source: ABdhPJxrygnMfLK8eagvxGviFG90GKXnm04NyWO6ssvyhvKoxhRK6ZP9BtRjtVzfuNBoGZXcylcLNg==
X-Received: by 2002:a17:907:6d96:b0:6df:f199:6a7c with SMTP id sb22-20020a1709076d9600b006dff1996a7cmr11603771ejc.137.1649306569679;
        Wed, 06 Apr 2022 21:42:49 -0700 (PDT)
Received: from anparri.mshome.net (host-87-11-75-174.retail.telecomitalia.it. [87.11.75.174])
        by smtp.gmail.com with ESMTPSA id e3-20020a170906374300b006e7f060bf6asm4199455ejc.207.2022.04.06.21.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 21:42:49 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Subject: [PATCH 2/2] hv_netvsc: Print value of invalid ID in netvsc_send_{completion,tx_complete}()
Date:   Thu,  7 Apr 2022 06:40:34 +0200
Message-Id: <20220407044034.379971-3-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407044034.379971-1-parri.andrea@gmail.com>
References: <20220407044034.379971-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That being useful for debugging purposes.

Notice that the packet descriptor is in "private" guest memory, so
that Hyper-V can not tamper with it.

While at it, remove two unnecessary u64-casts.

Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
---
 drivers/net/hyperv/netvsc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 9442f751ad3aa..4061af5baaea3 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -792,9 +792,9 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
 	int queue_sends;
 	u64 cmd_rqst;
 
-	cmd_rqst = channel->request_addr_callback(channel, (u64)desc->trans_id);
+	cmd_rqst = channel->request_addr_callback(channel, desc->trans_id);
 	if (cmd_rqst == VMBUS_RQST_ERROR) {
-		netdev_err(ndev, "Incorrect transaction id\n");
+		netdev_err(ndev, "Invalid transaction ID %llx\n", desc->trans_id);
 		return;
 	}
 
@@ -854,9 +854,9 @@ static void netvsc_send_completion(struct net_device *ndev,
 	/* First check if this is a VMBUS completion without data payload */
 	if (!msglen) {
 		cmd_rqst = incoming_channel->request_addr_callback(incoming_channel,
-								   (u64)desc->trans_id);
+								   desc->trans_id);
 		if (cmd_rqst == VMBUS_RQST_ERROR) {
-			netdev_err(ndev, "Invalid transaction id\n");
+			netdev_err(ndev, "Invalid transaction ID %llx\n", desc->trans_id);
 			return;
 		}
 
-- 
2.25.1

