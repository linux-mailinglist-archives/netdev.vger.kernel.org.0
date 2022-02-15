Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB684B79B3
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 22:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244450AbiBOViX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 16:38:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243584AbiBOViV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 16:38:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A52F9E56B
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 13:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644961089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lw6VFDNDin3+pbk+tx5AobUrmHH/xqmLZ9mW+ngKQHA=;
        b=b8jTXvwtJ5+Ua986iowvGdhZcXDa2QIsPJhkWmYNm3waE1tHdVtuuqFEi2uKpbxZ1kf28z
        YplXuX/b6YemvF9aVDbSv9Dwn1Clay3ERqXJ+fkXedNS8iILG4ZhTE86n1NEt8M8I1H5QG
        F8mGmHqfiwZMf9BgqyPVy7hPZlY0wB8=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-uiGr85x2PoSV1w-_8Q3qSw-1; Tue, 15 Feb 2022 16:38:08 -0500
X-MC-Unique: uiGr85x2PoSV1w-_8Q3qSw-1
Received: by mail-oi1-f200.google.com with SMTP id bj38-20020a05680819a600b002d2f27f444fso198251oib.18
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 13:38:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lw6VFDNDin3+pbk+tx5AobUrmHH/xqmLZ9mW+ngKQHA=;
        b=57wer6rsrZ7H/GboGuG6aCRlqJlhSvja9GOQISWnEM7EOxKL92v6qprUkSJHZWKu94
         sJlV2gmikBGdqYvMgbqglrBkscsepJx3mnmTGtlU74XJCqBZFpIQYll5i6tsp47bRJdZ
         vbWcqSrT2FIeAOk37OvaPxq9R84K+DIeMYPvQYHuqNAaHyttRIqcMFcn99yZPM4B6G3p
         RdA0fAzcGlQa436TV3CUfJGZn4+AzOPQxQ72Bs9ceO0lVhoVuSafNZPR6r+722THkGQZ
         wZekSM3TE+A44eftymm19CTOyjBRq8/tcnHpXbAR0UpwyDJnSlOGzdgAEMTKlDHjuoaW
         oP/Q==
X-Gm-Message-State: AOAM533TQpa0WTsddXShA1KH2pNLbzx6gIDbNEJGIDa5bVrluXazD4CU
        XDyFXuhWao2laYb9cIiWRHdD0hX6VYfR1lruO+xkpOz35jxm/oGKgEWT6oLSQN0FQGGSyOPvb8O
        D8GSOnALcnlB6cGXT
X-Received: by 2002:a05:6830:1493:: with SMTP id s19mr397257otq.85.1644961087405;
        Tue, 15 Feb 2022 13:38:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxHMQprTXozHvAqtiU55fjLcSJcPyW6e11I36Ur5jnj6V1ImozP4x5z3TQW31gX7xF9l32RWg==
X-Received: by 2002:a05:6830:1493:: with SMTP id s19mr397250otq.85.1644961087159;
        Tue, 15 Feb 2022 13:38:07 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id u32sm10936990oiw.28.2022.02.15.13.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 13:38:06 -0800 (PST)
From:   trix@redhat.com
To:     joyce.ooi@intel.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: ethernet: altera: cleanup comments
Date:   Tue, 15 Feb 2022 13:38:02 -0800
Message-Id: <20220215213802.3043178-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Replacements:
queueing to queuing
trasfer to transfer
aditional to additional
adaptor to adapter
transactino to transaction

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/altera/altera_sgdma.c    | 2 +-
 drivers/net/ethernet/altera/altera_tse_main.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_sgdma.c b/drivers/net/ethernet/altera/altera_sgdma.c
index db97170da8c7..7f247ccbe6ba 100644
--- a/drivers/net/ethernet/altera/altera_sgdma.c
+++ b/drivers/net/ethernet/altera/altera_sgdma.c
@@ -513,7 +513,7 @@ static int sgdma_txbusy(struct altera_tse_private *priv)
 {
 	int delay = 0;
 
-	/* if DMA is busy, wait for current transactino to finish */
+	/* if DMA is busy, wait for current transaction to finish */
 	while ((csrrd32(priv->tx_dma_csr, sgdma_csroffs(status))
 		& SGDMA_STSREG_BUSY) && (delay++ < 100))
 		udelay(1);
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 993b2fb42961..a3816264c35c 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -72,7 +72,7 @@ MODULE_PARM_DESC(dma_tx_num, "Number of descriptors in the TX list");
  */
 #define ALTERA_RXDMABUFFER_SIZE	2048
 
-/* Allow network stack to resume queueing packets after we've
+/* Allow network stack to resume queuing packets after we've
  * finished transmitting at least 1/4 of the packets in the queue.
  */
 #define TSE_TX_THRESH(x)	(x->tx_ring_size / 4)
@@ -390,7 +390,7 @@ static int tse_rx(struct altera_tse_private *priv, int limit)
 				   "RCV pktstatus %08X pktlength %08X\n",
 				   pktstatus, pktlength);
 
-		/* DMA trasfer from TSE starts with 2 aditional bytes for
+		/* DMA transfer from TSE starts with 2 additional bytes for
 		 * IP payload alignment. Status returned by get_rx_status()
 		 * contains DMA transfer length. Packet is 2 bytes shorter.
 		 */
@@ -1044,7 +1044,7 @@ static void altera_tse_set_mcfilterall(struct net_device *dev)
 		csrwr32(1, priv->mac_dev, tse_csroffs(hash_table) + i * 4);
 }
 
-/* Set or clear the multicast filter for this adaptor
+/* Set or clear the multicast filter for this adapter
  */
 static void tse_set_rx_mode_hashfilter(struct net_device *dev)
 {
@@ -1064,7 +1064,7 @@ static void tse_set_rx_mode_hashfilter(struct net_device *dev)
 	spin_unlock(&priv->mac_cfg_lock);
 }
 
-/* Set or clear the multicast filter for this adaptor
+/* Set or clear the multicast filter for this adapter
  */
 static void tse_set_rx_mode(struct net_device *dev)
 {
-- 
2.26.3

