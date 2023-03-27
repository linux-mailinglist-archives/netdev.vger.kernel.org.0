Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776B36CB2AE
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 01:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjC0XzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 19:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbjC0XzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 19:55:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D865B1724
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 16:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679961272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bN/6UZ/3G3OFwtl3tDJU5Pd1KJsgKsolxsW5pCSkgR4=;
        b=gmxScSDvBi5cAHhZNJ2jpWjuJvYdHRtk3q9YVGgnIVfLfd7gPSVEOTC7aRtR3caUbDsTv9
        Q/i63crVEFByLZGl0yMYUo+tpXmMLZbd2UFOwLT/FXDL/UDehcCYUvbIGDs5A93pK3NB4h
        l0luIxy6k/vGeAeuA7+cKEhmaDM7iWw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-h6fVodkrPAOl4kCP4Khf5w-1; Mon, 27 Mar 2023 19:54:31 -0400
X-MC-Unique: h6fVodkrPAOl4kCP4Khf5w-1
Received: by mail-qv1-f70.google.com with SMTP id h7-20020a0cd807000000b005dd254e7babso4305952qvj.14
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 16:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679961271;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bN/6UZ/3G3OFwtl3tDJU5Pd1KJsgKsolxsW5pCSkgR4=;
        b=dGMDIipdLb19T7FwjuEyJfnoV2WG5DQTMjmEzpXx57N0bahdvHqVDNqXysg/wXMKGs
         ShVhWwsFPlSSAIKMvFzrvGKgzhgaQrGDBPcAA0LL+Gms9hAX8wu7jkCVrHJX9/6EvKKO
         iP6g0MXgzXCVrvQymWckADFKMmzmTm1ZtjB10wMmfYIxo9REN3DtsjYor/ShaOcsvvzq
         c875RKjL1bGHUQtVEJjPOBTpxoEg/fPF/UejiWQZmHhdXiiYcyHdetaOBV0WnsDeDy0x
         XfVm0FOPGs5m5J+MoqSQPVxhkGVmER3Gq/46xuus9hz7YeV6FQrceokJR263dVWPvQuI
         z1Yw==
X-Gm-Message-State: AAQBX9cbUnFgYS657jv4AH6g3TL3BwcCrPeu6Jsta8lNHtB35cNIJIeG
        LTu5x7fraFGbLsfbH8wzmvFNqHxhpaxVisLFNOkrMaAZp0PFPFyxRKpo59/eE36KqtMdq9KcxM4
        RYbHv756p3eFjBMX/
X-Received: by 2002:a05:6214:1c45:b0:56b:7ec7:b158 with SMTP id if5-20020a0562141c4500b0056b7ec7b158mr24155037qvb.36.1679961271147;
        Mon, 27 Mar 2023 16:54:31 -0700 (PDT)
X-Google-Smtp-Source: AKy350YG2xhiotyuMY1L5G1mR7yrlH1f/ryIRtriuEls3TFl4S1M/12D5tDvSsBcKMGolgb5vfZ0sA==
X-Received: by 2002:a05:6214:1c45:b0:56b:7ec7:b158 with SMTP id if5-20020a0562141c4500b0056b7ec7b158mr24155015qvb.36.1679961270903;
        Mon, 27 Mar 2023 16:54:30 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id m124-20020a375882000000b0073b8745fd39sm17118677qkb.110.2023.03.27.16.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 16:54:30 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] net: ethernet: 8390: axnet_cs: remove unused xfer_count variable
Date:   Mon, 27 Mar 2023 19:54:23 -0400
Message-Id: <20230327235423.1777590-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang with W=1 reports
drivers/net/ethernet/8390/axnet_cs.c:653:9: error: variable
  'xfer_count' set but not used [-Werror,-Wunused-but-set-variable]
    int xfer_count = count;
        ^
This variable is not used so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/8390/axnet_cs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
index 3aef959fc25b..78f985885547 100644
--- a/drivers/net/ethernet/8390/axnet_cs.c
+++ b/drivers/net/ethernet/8390/axnet_cs.c
@@ -650,7 +650,6 @@ static void block_input(struct net_device *dev, int count,
 {
     unsigned int nic_base = dev->base_addr;
     struct ei_device *ei_local = netdev_priv(dev);
-    int xfer_count = count;
     char *buf = skb->data;
 
     if ((netif_msg_rx_status(ei_local)) && (count != 4))
@@ -662,9 +661,7 @@ static void block_input(struct net_device *dev, int count,
     insw(nic_base + AXNET_DATAPORT,buf,count>>1);
     if (count & 0x01) {
 	buf[count-1] = inb(nic_base + AXNET_DATAPORT);
-	xfer_count++;
     }
-
 }
 
 /*====================================================================*/
-- 
2.27.0

