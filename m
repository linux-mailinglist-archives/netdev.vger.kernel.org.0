Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021F367DA33
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjA0AIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjA0AIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:08:31 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696DE4B19D;
        Thu, 26 Jan 2023 16:08:30 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d3so3376337plr.10;
        Thu, 26 Jan 2023 16:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Uc6aKUtXlv3GS/KMoafn+YIiq695lQmLJQ+YunBm9p4=;
        b=JDKYdDzxrtnrxAGN1MD+/x4vWdJRLzzQ/V5iVcAobx7hLlYxZaIXMuskl6Ged+I6X+
         Q/XhS/d86vbp0FujZn8o8I8hkwPOxwePvk5odPVHN/pE/Ap0i+eR9n24+gKwYRcXQeVV
         Y2bAgKyA588/meqfzUsTe6cIr7eZUpOJIIsAjh1LxfxpcrWt5BiSJGod+JSoZvHgG9YL
         mk9EO1unzhonUglH+OgNodkTyYQUSagiUuPjKejdh3d4ackOoa3IJh3XKYw7Hf39ivsM
         ALCEuKUSdVLZR9KD+Xfps6cW3qTziL9KOhtK0r5+UlEpAx0sO9KX7RY2NlPUc3ec2phU
         ihdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uc6aKUtXlv3GS/KMoafn+YIiq695lQmLJQ+YunBm9p4=;
        b=eTVwBbKu5QEfylogPRW6EkAw40F7EySK0HBixW7cEU7oJdFkLmsuIpajW1r/aedWbg
         ssFQ/KAgIsU8PjPv6J0bRy3FbB/gCq/tvXQ5zrEWdI/MBM5bIXqlf6h5jhNsSDZx2EdQ
         PuSkL3iWULwFqnhxSOEFWCpXj58szvHcLQ8cfpd2blRgEzI926HWdKLjsy5L+HBEeYv4
         wfK5Ce18dKJeBy0pxDe7ANlh6tZQgt9PoS8Gs+QZXqiE/0NDYOEXZ04ed5Sit4IcaLqx
         7XAUoHrT8PefUCoNDftWiyS3Ti7r1nPtT4nGxgiXmyiUmBdkCjoHLM8LC91ADDVnanpL
         sIGA==
X-Gm-Message-State: AFqh2kqjUPbti6Jj9C+Z0/OGclykkJIlaxsyR2QfuF+uz+KRVYnS4oT1
        kCHHntWt410U1HJxzsVsGDnrirdJTFasxQ==
X-Google-Smtp-Source: AMrXdXupOG8HzamFqnl0Y8CVEzJszgrRBhPIqJ9dut8zR9/qsdpg1/7ZWRu5Xfk0sDdECkDzHmP5Dw==
X-Received: by 2002:a17:902:8b81:b0:194:87e1:41a with SMTP id ay1-20020a1709028b8100b0019487e1041amr38637373plb.42.1674778109410;
        Thu, 26 Jan 2023 16:08:29 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l10-20020a170902eb0a00b00196503444b0sm324959plb.43.2023.01.26.16.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 16:08:28 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     maxime@cerno.tech, Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: bcmgenet: Add a check for oversized packets
Date:   Thu, 26 Jan 2023 16:08:19 -0800
Message-Id: <20230127000819.3934-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Occasionnaly we may get oversized packets from the hardware which
exceed the nomimal 2KiB buffer size we allocate SKBs with. Add an early
check which drops the packet to avoid invoking skb_over_panic() and move
on to processing the next packet.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 21973046b12b..d937daa8ee88 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2316,6 +2316,14 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 			  __func__, p_index, ring->c_index,
 			  ring->read_ptr, dma_length_status);
 
+		if (unlikely(len > RX_BUF_LENGTH)) {
+			netif_err(priv, rx_status, dev, "oversized packet\n");
+			dev->stats.rx_length_errors++;
+			dev->stats.rx_errors++;
+			dev_kfree_skb_any(skb);
+			goto next;
+		}
+
 		if (unlikely(!(dma_flag & DMA_EOP) || !(dma_flag & DMA_SOP))) {
 			netif_err(priv, rx_status, dev,
 				  "dropping fragmented packet!\n");
-- 
2.25.1

