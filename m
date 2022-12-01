Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FFD63FAE7
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiLAWtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiLAWs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:48:56 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A93F8C6B8
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 14:48:55 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id f13so4779817lfa.6
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 14:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wN4DUy4CI6jrcJgFDHsjquJNvQgQh0CBq/XFO2ynUaE=;
        b=TncvI/pnkeQKaTJfWTddQy6i1xGln5P4sPqmOYmoh8XOX9/iXQfw6N0SvdcfSfVASv
         r137ImoL64G167gOUOSvgrXtIHtGGfrhTP5jgM/MLOxfUMfiWlSvACwPTVobcHuYR46g
         MwX4adfi0X7LDRT5bAqj9d2gd1RESvJMB4g/OptXCn94VM8wd2dF6bzxrbT95M2Wt2jJ
         3N/1pSh5ZX9eNzRDEQ3flEz9Sh7fqVzH0ex6eXtIxDrK1cpjafeWgUQhv2CSqKbFY8Ej
         pem/ne4CpXcoRv39ko8AWaaMYYtkpUnikYKqfVJQTMfx0IZTrNT3xRK5JlYpFVQHdcLN
         p69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wN4DUy4CI6jrcJgFDHsjquJNvQgQh0CBq/XFO2ynUaE=;
        b=eHHQY1xkMqOsPg3p15Doe2PwkpqNW6KGOk5qTLsnj4XNhXEdPDw+sA7KjRC/QcMKIM
         SxOvAkc++XoGGDEokikKdNLGsWiYsKXM5Ba0Fd8eUMDh7rIMaOL3D8N4MkzBrcIPdU10
         BMtK1ntd0pdcFClRRBmLjiaM2RfWeIhsfc08p0VA0NoKU7gLA9fKDjhuAJfOsUPKZ2Af
         jycBnFsyNluj8dpnLcz2AlRVnIRsPMGHeImyb3Bu0xUBrmyJ6br1BKDuBqarCAs3HMjM
         C5x4f5qxUrQHpji8BRidcaEnzlCHJlUrK+ejQaD5wITAjhpenyz788laP9LGOnU9oe1+
         DSag==
X-Gm-Message-State: ANoB5pkG2HJqfymikHhgEURZZ8tMCGJJ3Je6clzraf6Enjt0Yh8vn+W5
        Bl/u9tYc21jBbRCD+Vl3Q3pCcQ==
X-Google-Smtp-Source: AA0mqf5DW6loVcF3hzhX8GTVWuVnFDAc4kFRcXK0FVNwJuoCTfSpwo3G+W+r5qwFnML4wed50lRdOg==
X-Received: by 2002:a05:6512:715:b0:4b4:e552:5638 with SMTP id b21-20020a056512071500b004b4e5525638mr14555910lfs.287.1669934933946;
        Thu, 01 Dec 2022 14:48:53 -0800 (PST)
Received: from localhost.localdomain ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id g7-20020a056512118700b00497ab34bf5asm797573lfr.20.2022.12.01.14.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 14:48:53 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     devel@daynix.com
Subject: [PATCH v4 4/6] uapi/linux/virtio_net.h: Added USO types.
Date:   Fri,  2 Dec 2022 00:33:30 +0200
Message-Id: <20221201223332.249441-4-andrew@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221201223332.249441-1-andrew@daynix.com>
References: <20221201223332.249441-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 include/uapi/linux/virtio_net.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 6cb842ea8979..cbc631247489 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -57,6 +57,10 @@
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
 #define VIRTIO_NET_F_NOTF_COAL	53	/* Device supports notifications coalescing */
+#define VIRTIO_NET_F_GUEST_USO4	54	/* Guest can handle USOv4 in. */
+#define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
+#define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
+
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
@@ -130,6 +134,7 @@ struct virtio_net_hdr_v1 {
 #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
 #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
 #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
+#define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4& IPv6 UDP (USO) */
 #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
 	__u8 gso_type;
 	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
-- 
2.38.1

