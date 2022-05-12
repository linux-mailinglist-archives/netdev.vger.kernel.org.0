Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB89524BBC
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 13:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353310AbiELLdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 07:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353257AbiELLdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 07:33:25 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2B91C7419
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:33:23 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id q130so6096851ljb.5
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dQ6Kj1AFx+WOgmL0iPWurV5hXCaWyWM8z6CScgnZ/mE=;
        b=eZlrMjgNhGomXxclaICAouypvp3lRfwA6aZfhe3AuMITDC5aWokIMqIolhVdtaZYd2
         8NkrnkmRYFE86hKFaKF3lR5XNcvz5vRIqWhpY7UjzJ/mRrdMw+kXRu1GxHv10+l/grGb
         eYFVeRSPr0I/DORddBVbHRUdOebbrl2/EbqnfMeS2fLZbbyBLTu7lyPhSM71VKxO7p6E
         8CgT4Mv+1vL2Es14NninGcjg/EPWQF6UwwbzBPbNrUr0zvPgDoNdT2tknD9NQiY/eh9P
         Qdco9bi/vP/OBeQ+JDoSE+az1KTEBX8/LIkySJJCbfkibbj7YZuoDqCgwI0m1P8nAOEZ
         JFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dQ6Kj1AFx+WOgmL0iPWurV5hXCaWyWM8z6CScgnZ/mE=;
        b=yoQz7tvVoxnfPIlRYA7zX6CfrKS+imuPBnmPQHIgp2iYiCHk+uszxI95RQxQhtTj1v
         sDPS/eOA36TBD4mOPV2pQk8CLqV+/Hh5pIAhr49/4Ef8tRI4M1kYZrekrcPTrHxfJS1d
         dN8Gqc9/UVJuv77VfuftCTVqQaySPhTk/DC6FYCmp54alA2cWsfJogap1G9gui/uSp2I
         h6dOopwjluhbMhIsVcaRckUFlMOFbUQZkwxVh8M36+cHtlOmcEa3zIDIyzGSTP0M5xW9
         F/nu96YMZjfn2eAdKhzSCkwEI2EDcOGFia0v6WM+2PJ/fvC/K3l3CfH9pKHJRdHHKV53
         VNvA==
X-Gm-Message-State: AOAM532eI44aKTAJJRIyPon3F1IOylT/SRxuEgtQ+dgoh6hCovdwjPwy
        ynuSoX2pJkRmyGemZwgY1+/gLAwY/28PrF9F
X-Google-Smtp-Source: ABdhPJxBbnjmcbyqDTcs/WSaKg6jAB/MlcJZ2EYLz6uh2au/7rvOWL/6K4Gs9t4HeVQS/eC8xFyNYQ==
X-Received: by 2002:a2e:8902:0:b0:24f:1446:3101 with SMTP id d2-20020a2e8902000000b0024f14463101mr19979362lji.266.1652355201900;
        Thu, 12 May 2022 04:33:21 -0700 (PDT)
Received: from localhost.localdomain (host-188-190-49-235.la.net.ua. [188.190.49.235])
        by smtp.gmail.com with ESMTPSA id r29-20020ac25a5d000000b0047255d211a6sm741758lfn.213.2022.05.12.04.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 04:33:21 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [RFC PATCH v2 3/5] uapi/linux/virtio_net.h: Added USO types.
Date:   Thu, 12 May 2022 14:23:45 +0300
Message-Id: <20220512112347.18717-4-andrew@daynix.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220512112347.18717-1-andrew@daynix.com>
References: <20220512112347.18717-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added new GSO type for USO: VIRTIO_NET_HDR_GSO_UDP_L4.
Feature VIRTIO_NET_F_HOST_USO allows to enable NETIF_F_GSO_UDP_L4.
Separated VIRTIO_NET_F_GUEST_USO4 & VIRTIO_NET_F_GUEST_USO6 features
required for Windows guests.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 include/uapi/linux/virtio_net.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 3f55a4215f11..c654feb1ed9b 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -56,6 +56,9 @@
 #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
+#define VIRTIO_NET_F_GUEST_USO4	54	/* Guest can handle USOv4 in. */
+#define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
+#define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
 
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
@@ -130,6 +133,7 @@ struct virtio_net_hdr_v1 {
 #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
 #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
 #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
+#define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4& IPv6 UDP (USO) */
 #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
 	__u8 gso_type;
 	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
-- 
2.35.1

