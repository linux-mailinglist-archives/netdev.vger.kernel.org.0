Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5B36133EE
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiJaKtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiJaKt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:49:29 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413FC2AD0
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:49:28 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id bj12so28247305ejb.13
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=clMZIOw1YuPM6JgNnvOj4SNevanCeDAGEYCghEVAyy0=;
        b=IhEwz7UTlr5sPEFujVfxJphMjAjLXK9xM5cmZVR8VsN9QBrqzTsNt9I0dCJW+amJCD
         78y1pdOt6t0HRvgpABfqxO5S6C0aJ84wYRwnpEawtqATGaluCBbM6OzynNIcYlKvWIyL
         y0/cWak6KDRwFact1BwHYRtBG+Chxgap3DjJw2ymef6Lt1xTP7NPPM0gzGdJReaIOOjb
         dFJ1cg8R0RtVRaX89gauS0S1JNXvpJwOixjh0sfwrxtFHpC0LUBL32VUNzrDAQQTRsAK
         qbgyu5B+y6Ww1Degc7J/sx8N/fvwiT3YUwV7yMvO0k/YXYzoHBo76h6hdR8ghoFUnceI
         +F5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=clMZIOw1YuPM6JgNnvOj4SNevanCeDAGEYCghEVAyy0=;
        b=Cu4dAsxHCwXVmGQb+KudDxHAlgM3E8Y3Lznt50BboQ/ZPlHfskjYk4gs3Fzl5uWm+s
         suQb26BEkVVy7wcZF8r0bhW2JWYP9/u7GQqFjZDR5O5d8W5hekpFbdkcdUd6BlUi+XTj
         qBsE2Nps7UARJ3MRsEIQyPNZfWhdo0BUCwJjoutw3DR+y4khGKfIcp4HFPvStZ1qv1cw
         exD5iOV7dVv4RkavRPGOzUk+vqSekLwCWrbkvAGb0KpESzlH8KSvVyuV5Fkl4ww4e4Oy
         /B9+0oDPnoWRI2V2yU6MotLQOCwxtUqAOSq/sqYw40yI1ohF99ZGVCVOI8+EFf4fGi0F
         OHqQ==
X-Gm-Message-State: ACrzQf0DuIxCIKTUPSJdl4UME8mCQkSyCLHfkzmNK3lBbJ5rIo+KVwEw
        CO8ESB6dErevrB3Bdo15ask=
X-Google-Smtp-Source: AMsMyM5J629M8p51YFz19fumgkGurV/0qexobLE2nSAAXmSiKByzwgmH/2I8y9Avk2CgJfZ5HoSQNQ==
X-Received: by 2002:a17:906:66ce:b0:7ad:d178:c252 with SMTP id k14-20020a17090666ce00b007add178c252mr4541043ejp.158.1667213366697;
        Mon, 31 Oct 2022 03:49:26 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id q18-20020a056402033200b004614c591366sm3067136edw.48.2022.10.31.03.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 03:49:26 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 net-next] net: broadcom: bcm4908_enet: report queued and transmitted bytes
Date:   Mon, 31 Oct 2022 11:48:56 +0100
Message-Id: <20221031104856.32388-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This allows BQL to operate avoiding buffer bloat and reducing latency.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Rebase on top of skb handling fixes
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index b0aac0bcb060..33d86683af50 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -505,6 +505,7 @@ static int bcm4908_enet_stop(struct net_device *netdev)
 	netif_carrier_off(netdev);
 	napi_disable(&rx_ring->napi);
 	napi_disable(&tx_ring->napi);
+	netdev_reset_queue(netdev);
 
 	bcm4908_enet_dma_rx_ring_disable(enet, &enet->rx_ring);
 	bcm4908_enet_dma_tx_ring_disable(enet, &enet->tx_ring);
@@ -564,6 +565,8 @@ static netdev_tx_t bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_devic
 	if (ring->write_idx + 1 == ring->length - 1)
 		tmp |= DMA_CTL_STATUS_WRAP;
 
+	netdev_sent_queue(enet->netdev, skb->len);
+
 	buf_desc->addr = cpu_to_le32((uint32_t)slot->dma_addr);
 	buf_desc->ctl = cpu_to_le32(tmp);
 
@@ -671,6 +674,7 @@ static int bcm4908_enet_poll_tx(struct napi_struct *napi, int weight)
 			tx_ring->read_idx = 0;
 	}
 
+	netdev_completed_queue(enet->netdev, handled, bytes);
 	enet->netdev->stats.tx_packets += handled;
 	enet->netdev->stats.tx_bytes += bytes;
 
-- 
2.34.1

