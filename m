Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6F359D275
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 09:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240532AbiHWHj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 03:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236517AbiHWHj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 03:39:57 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941BB31DC6
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 00:39:56 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id h204-20020a1c21d5000000b003a5b467c3abso9044440wmh.5
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 00:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=/xGaAo+gu3RU5MNzi1hEpBcjB2iHNX2K31piSFhIzSY=;
        b=25OfZpcTNblgcSVYzYQiCcESXtnS4ySJ8A8RJZ6DY0uELzCZBAx6KbEvGZdULrteEl
         ueUClFdnHmgWv7xZCX5OLxfk8WmvWNZmbsVLieRyQijMy2bKDW9GMunoRjeaDsEgDMOQ
         aKwrw6V303ok++rJ+I++g2r1yB/nXsuNjaTksnCeBk6/DDp/rrkGwcePeIGIsGUkhOl8
         RHMb+/aDNJYMbwyxZAyWR3YQf7DSb21BjooGLdENkB3SHO8nuNApSrCGUvv6S6llYlrT
         MKSOp4pegA+sxiN5bXVfU/XYCzeRDYwolBKFImKEin2ebmUSUGEjBG7+5OUFIadMx1Or
         bbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=/xGaAo+gu3RU5MNzi1hEpBcjB2iHNX2K31piSFhIzSY=;
        b=x4mVfYeGtyHt0kw21JgteSxSS/fS5MNBs9Zua5ooNyJKYNtUMy4WxZRGh21XHmfLK8
         8mdz7X8pbzhhmvChh19h6g+2PxCKBDHx0U+PI0iMswZ7YVT+/FKVcWYqgJuW4bCkwVos
         GuDRINNEx6+5tdH9hyO2XWvkmWJaIElAR9CBkTK/AZu1Vs5cWAjX5Fm0qIRUpIjamuyN
         J87N9pvaz0UbLpnhkAPZZOQ0aW74S4pGMFm5L9ELvHXTaxip1q81d/KyOKEBud4vUTXc
         avrys1VlmxkoguoR5wmINki1dx0cGeZH1hnMp/wlMLsZlotY8/uECMrwDKWjAxkpBhPK
         qXiA==
X-Gm-Message-State: ACgBeo3UP5XcdfniB8Q5dUHAzcWfV/peciNi3fhbYILDbv1tddXsEYWv
        hMWEVjTjP/X9c7BHJrIp2bZO0iV8LnxLcw==
X-Google-Smtp-Source: AA6agR7IPSvfi2l8cDaMLFCeaawGznK919HnbrCRMpCZlUaVkbJhAABZ6msAX1UeIK2TnTxWfW9Kzg==
X-Received: by 2002:a05:600c:3b9f:b0:3a6:53f:12fb with SMTP id n31-20020a05600c3b9f00b003a6053f12fbmr1296308wms.194.1661240394804;
        Tue, 23 Aug 2022 00:39:54 -0700 (PDT)
Received: from localhost.localdomain (bzq-84-110-153-254.static-ip.bezeqint.net. [84.110.153.254])
        by smtp.gmail.com with ESMTPSA id a8-20020adfdd08000000b0022537d826f3sm11183950wrm.23.2022.08.23.00.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 00:39:54 -0700 (PDT)
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH] net: virtio_net: fix notification coalescing comments
Date:   Tue, 23 Aug 2022 10:39:47 +0300
Message-Id: <20220823073947.14774-1-alvaro.karsz@solid-run.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix wording in comments for the notifications coalescing feature.

Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
---
 include/uapi/linux/virtio_net.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 29ced55514d..6cb842ea897 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -56,7 +56,7 @@
 #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
-#define VIRTIO_NET_F_NOTF_COAL	53	/* Guest can handle notifications coalescing */
+#define VIRTIO_NET_F_NOTF_COAL	53	/* Device supports notifications coalescing */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
@@ -364,24 +364,24 @@ struct virtio_net_hash_config {
  */
 #define VIRTIO_NET_CTRL_NOTF_COAL		6
 /*
- * Set the tx-usecs/tx-max-packets patameters.
- * tx-usecs - Maximum number of usecs to delay a TX notification.
- * tx-max-packets - Maximum number of packets to send before a TX notification.
+ * Set the tx-usecs/tx-max-packets parameters.
  */
 struct virtio_net_ctrl_coal_tx {
+	/* Maximum number of packets to send before a TX notification */
 	__le32 tx_max_packets;
+	/* Maximum number of usecs to delay a TX notification */
 	__le32 tx_usecs;
 };
 
 #define VIRTIO_NET_CTRL_NOTF_COAL_TX_SET		0
 
 /*
- * Set the rx-usecs/rx-max-packets patameters.
- * rx-usecs - Maximum number of usecs to delay a RX notification.
- * rx-max-frames - Maximum number of packets to receive before a RX notification.
+ * Set the rx-usecs/rx-max-packets parameters.
  */
 struct virtio_net_ctrl_coal_rx {
+	/* Maximum number of packets to receive before a RX notification */
 	__le32 rx_max_packets;
+	/* Maximum number of usecs to delay a RX notification */
 	__le32 rx_usecs;
 };
 
-- 
2.32.0

