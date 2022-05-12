Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5C2524BB9
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 13:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353276AbiELLda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 07:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353253AbiELLdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 07:33:25 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2041CEEFE
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:33:22 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id u23so8531816lfc.1
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vWGmhmweV+dNU5jtCxsxI3a+Zh1xPCMPOBO82/gmlT8=;
        b=LKUD1yC32xjbxmkSjCnpvuGV+8W7U4BU65WpHJE3jq3pkQpn1jtn6WIi0hBwFbvO1H
         A9TSVFsVVQfZbvcjeW13k4cH6GFbrI5hb0Z4djPSZd1N6bBC67YPH452ep4LQwsk0WV8
         y2YzdhmWiMSLQZFLeedNKlvsJGIR0oAkoC9fTPqx1xNStO2xj0HGxgNgfWCkuf0BTSfB
         zhM0kGiyzLSCjeiQgbzY7bjCBK+FcgdMsz0UnP4Zgpjnb4SOX3/4bMiKLkJGKbXTrlDO
         KzFWIsuWwK6BVT0/jE4YaTxGKFY00f6wvNeNPO/Rek5sOuC08PXqLalP/n9r+2F1I/L+
         TFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vWGmhmweV+dNU5jtCxsxI3a+Zh1xPCMPOBO82/gmlT8=;
        b=CXXQ9sUVKKPfM0WK/THopCCwQSJ6d1Cb9z8dR6abQxzPXjzRHl7b2sJ1yNuZPvuLwT
         3WaIJ+CoBI4mTyLla609K8uIPZgFNGKHa9Klp0o51Tr/UZCLoULdizdXDjbeof+mARVu
         w/e66P6Q0B1Px+o7T+AxF8yt2Y61RRTfRZ94k5bAAUL/2MKEMzneLNesZu3qP2y+Q1Dd
         ISt/15OldZU3UP7GM0lw9k/qi1v9txSDnEDqU2qloiSkUb+/6rGn0igzwd29tTp6EckF
         pbC332Be8XK0bd/os454Jw82EfZxhgSmhHo3ghbFymNn/a8Nw6NlHL7+Xtsn7qqDV58j
         TQLg==
X-Gm-Message-State: AOAM533JsAkRkL1nHTJSjlIFM5/pZZ1iZhkwXoi+Iy/3AZ1zEd65T1yZ
        VS6/Ds02gOaDFjs2b9JQ6jqT+TsqvSbDG4YI
X-Google-Smtp-Source: ABdhPJxbWkbMoHZx9vnNhaWMQsFMmMpNbbKEDn9qoqWTiVezpVArTwZqGvvEio/w1aBmU0O0mXLwOg==
X-Received: by 2002:a05:6512:3e17:b0:473:205d:a3d5 with SMTP id i23-20020a0565123e1700b00473205da3d5mr23770800lfv.80.1652355200800;
        Thu, 12 May 2022 04:33:20 -0700 (PDT)
Received: from localhost.localdomain (host-188-190-49-235.la.net.ua. [188.190.49.235])
        by smtp.gmail.com with ESMTPSA id r29-20020ac25a5d000000b0047255d211a6sm741758lfn.213.2022.05.12.04.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 04:33:20 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [RFC PATCH v2 2/5] driver/net/tun: Added features for USO.
Date:   Thu, 12 May 2022 14:23:44 +0300
Message-Id: <20220512112347.18717-3-andrew@daynix.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220512112347.18717-1-andrew@daynix.com>
References: <20220512112347.18717-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for USO4 and USO6.
For now, to "enable" USO, it's required to set both USO4 and USO6 simultaneously.
USO enables NETIF_F_GSO_UDP_L4.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/tap.c | 10 ++++++++--
 drivers/net/tun.c |  8 +++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index c3d42062559d..eae7c2c13713 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -955,6 +955,10 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 			if (arg & TUN_F_TSO6)
 				feature_mask |= NETIF_F_TSO6;
 		}
+
+		/* TODO: for now USO4 and USO6 should work simultaneously */
+		if ((arg & (TUN_F_USO4 | TUN_F_USO6)) == (TUN_F_USO4 | TUN_F_USO6))
+			features |= NETIF_F_GSO_UDP_L4;
 	}
 
 	/* tun/tap driver inverts the usage for TSO offloads, where
@@ -965,7 +969,8 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	 * When user space turns off TSO, we turn off GSO/LRO so that
 	 * user-space will not receive TSO frames.
 	 */
-	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6))
+	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6) ||
+	    (feature_mask & (TUN_F_USO4 | TUN_F_USO6)) == (TUN_F_USO4 | TUN_F_USO6))
 		features |= RX_OFFLOADS;
 	else
 		features &= ~RX_OFFLOADS;
@@ -1089,7 +1094,8 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
 	case TUNSETOFFLOAD:
 		/* let the user check for future flags */
 		if (arg & ~(TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
-			    TUN_F_TSO_ECN | TUN_F_UFO))
+			    TUN_F_TSO_ECN | TUN_F_UFO |
+			    TUN_F_USO4 | TUN_F_USO6))
 			return -EINVAL;
 
 		rtnl_lock();
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index dbe4c0a4be2c..ecad1bdee717 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -185,7 +185,7 @@ struct tun_struct {
 	struct net_device	*dev;
 	netdev_features_t	set_features;
 #define TUN_USER_FEATURES (NETIF_F_HW_CSUM|NETIF_F_TSO_ECN|NETIF_F_TSO| \
-			  NETIF_F_TSO6)
+			  NETIF_F_TSO6 | NETIF_F_GSO_UDP_L4)
 
 	int			align;
 	int			vnet_hdr_sz;
@@ -2861,6 +2861,12 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
 		}
 
 		arg &= ~TUN_F_UFO;
+
+		/* TODO: for now USO4 and USO6 should work simultaneously */
+		if (arg & TUN_F_USO4 && arg & TUN_F_USO6) {
+			features |= NETIF_F_GSO_UDP_L4;
+			arg &= ~(TUN_F_USO4 | TUN_F_USO6);
+		}
 	}
 
 	/* This gives the user a way to test for new features in future by
-- 
2.35.1

