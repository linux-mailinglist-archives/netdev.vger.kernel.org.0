Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356B9611212
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiJ1NAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiJ1NAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:00:20 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3979356F8
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:00:18 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y4so4799981plb.2
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5iJgtqpqiJVn//zhOfDmx7Kv+t48Z9oElzV8cQV4k8Q=;
        b=OYyI1D0//SYHg7b9sDx9vjzWuMkJE0shNqa2Ap8f/NCqkVLJzjc+VklmLtIPloaXN/
         bcAk4bSk4VpzlPj13/R1bBnPUM5Qm8iMvZq8utmw3hiV1k1tRJwDYZBeAOJsOVPTm75I
         CKSRzSfgiTeWhtkm5GuQVZpD+1iTHJp6chiq+v7s0ZFpqU53u4FTWEMoLqUFCnL/KqCl
         x0nm9C4ORjC47udpZ2tXLPfgAA28yQHwo9lh29uFutgVJ4jdNWR8r4qtc+xVra76ILdX
         QMwFkn5XQReuxrsDbdnzfuCipMkOxzzpTFJNiNbGt5NWk16rMldf2cpA5MYmxASsmzn9
         QPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5iJgtqpqiJVn//zhOfDmx7Kv+t48Z9oElzV8cQV4k8Q=;
        b=XbP0oSN9usPhmFluslGMdAiC35vLE+HhoH9GcAIlzNgthn+dQVS8+4+a72b+eiBEz7
         HBl16kJTq5kqv+bjExJjHzZsMTGbn1uy/OGbHOdJAT4RuDZrm9EWJJxjFNZeZANkcTxC
         lcwXa/yLVNCGcuoMt8EYmvTN8Mcwj6yh0FLCDl1bkfeQlh5JJKbQHsboi09B/0Tz5cBU
         HHL39un+law8P3HvFvMilvR0g6geJDKD1cBRiSYBlIzjkR5mVCGXX1SiLxZUoI6GppJV
         dpII/P+UsLmXlv2HoPHDqhAqN7DXezc9rix5fO6yOy0PCGin4pFI7w7e8URF+IHe/OqS
         oIuA==
X-Gm-Message-State: ACrzQf3E3nx/MVU/ewQl6C6GmPyWuuvFKgg3PTWYjxH2BPph73cE3y/R
        ADJBz8AEV47l2f58HS8HpTjqIg==
X-Google-Smtp-Source: AMsMyM7PmTVcA7PMinrbHKlUjxdSN3EiXgN4d3rE8Fu3scAMRdj2UzkM3odDl9Tmj7UjN9XWOSa9DA==
X-Received: by 2002:a17:902:b90b:b0:186:8a4d:d4b7 with SMTP id bf11-20020a170902b90b00b001868a4dd4b7mr33134131plb.129.1666962015777;
        Fri, 28 Oct 2022 06:00:15 -0700 (PDT)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id v19-20020a17090ac91300b002036006d65bsm2512524pjt.39.2022.10.28.06.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 06:00:15 -0700 (PDT)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yan Vugenfirer <yan@daynix.com>,
        intel-wired-lan@lists.osuosl.org, Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v2] e1000e: Fix TX dispatch condition
Date:   Fri, 28 Oct 2022 22:00:00 +0900
Message-Id: <20221028130000.7318-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

e1000_xmit_frame is expected to stop the queue and dispatch frames to
hardware if there is not sufficient space for the next frame in the
buffer, but sometimes it failed to do so because the estimated maxmium
size of frame was wrong. As the consequence, the later invocation of
e1000_xmit_frame failed with NETDEV_TX_BUSY, and the frame in the buffer
remained forever, resulting in a watchdog failure.

This change fixes the estimated size by making it match with the
condition for NETDEV_TX_BUSY. Apparently, the old estimation failed to
account for the following lines which determines the space requirement
for not causing NETDEV_TX_BUSY:
    ```
    	/* reserve a descriptor for the offload context */
    	if ((mss) || (skb->ip_summed == CHECKSUM_PARTIAL))
    		count++;
    	count++;

    	count += DIV_ROUND_UP(len, adapter->tx_fifo_limit);
    ```

This issue was found when running http-stress02 test included in Linux
Test Project 20220930 on QEMU with the following commandline:
```
qemu-system-x86_64 -M q35,accel=kvm -m 8G -smp 8
	-drive if=virtio,format=raw,file=root.img,file.locking=on
	-device e1000e,netdev=netdev
	-netdev tap,script=ifup,downscript=no,id=netdev
```

Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 49e926959ad3..55cf2f62bb30 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5936,9 +5936,9 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 		e1000_tx_queue(tx_ring, tx_flags, count);
 		/* Make sure there is space in the ring for the next send. */
 		e1000_maybe_stop_tx(tx_ring,
-				    (MAX_SKB_FRAGS *
+				    ((MAX_SKB_FRAGS + 1) *
 				     DIV_ROUND_UP(PAGE_SIZE,
-						  adapter->tx_fifo_limit) + 2));
+						  adapter->tx_fifo_limit) + 4));
 
 		if (!netdev_xmit_more() ||
 		    netif_xmit_stopped(netdev_get_tx_queue(netdev, 0))) {
-- 
2.37.3

