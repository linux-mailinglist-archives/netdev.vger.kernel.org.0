Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A25D63FAE1
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiLAWs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiLAWs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:48:56 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BAA9C621
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 14:48:54 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id x6so3531431lji.10
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 14:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BlO6QTZCwR1RLEDuFRe8THkhQOGpd88LnLO5Y8el1kY=;
        b=OQa+DAdUw25Ne94o8Inx5iCJ59YUCMg+QHfRo6xIu6a4xvMjlsgj5c2yxNNo+UVHxE
         HeENFmyRRYnS1NoX9sJhjEOFj5+NH0pCOGM4g1y5/p/r6KRF7qzeZEWMkgF6KiVjdQY0
         VB+Qqyl8R1w0leOOZ82Mhtoj/85biqpWkIevsh4n7JGId7+6BtCdn1LRtjcrttvpK45S
         sUk8RqXnMV5eqe3OIi+AHNAUMfAQv3xxUHEMuIHZr5wgOa19b0vfcPEGEebDjTPUjC7/
         ckOTciOmLdDcV4kdYI+fCuGBRYCNf0lusxwinAq2I5mZ580SvwR8PTwhEhKr1XuOc2nl
         ksnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BlO6QTZCwR1RLEDuFRe8THkhQOGpd88LnLO5Y8el1kY=;
        b=CbHJWNGFr/OfXZywai/ZYYMZYngXS+52C3i/XMKJPwQgJPVIAiljkIkYlLBuRvORGw
         6ZUIQOeNXbZccv8te7e2vuxyJNHxJyyxtPL065yuZTlKaLDbdcJM4kRjy5gTWXZM4VHY
         s69rKnrombuI7IrF7tTdtXdmtNDprfIunE5a3xQyASEH9eXMdlaEKR+AbTWG+KVxcOse
         Z7FtedkZpTcDpnxptC8Wdnjv6ZDa/XeJArpogRU8ZM/kF7511JRmpbk5/teaA5XCtj7s
         Cx0IGCBuejOEEbbGXjT9U8hHruooMdlFQzHoLOUhTdjxZuS1bHVVWicQ0s2O0soiucEU
         Kvug==
X-Gm-Message-State: ANoB5pnFA53twdibvKR4F3q0Q1V5woPa5ppxgh426Z1GO3zmkS9ImwKM
        BuZtvaahjMELuBJe510eAY+H0A==
X-Google-Smtp-Source: AA0mqf5E3BX1xvmG/ZbvCu2JxFuLoiltJ9sVdMphUNGSiGKb9Gk6LgpxIlyJTnX8txMUn7W/r7Qskg==
X-Received: by 2002:a2e:b891:0:b0:277:8df:88a7 with SMTP id r17-20020a2eb891000000b0027708df88a7mr23324289ljp.139.1669934932549;
        Thu, 01 Dec 2022 14:48:52 -0800 (PST)
Received: from localhost.localdomain ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id g7-20020a056512118700b00497ab34bf5asm797573lfr.20.2022.12.01.14.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 14:48:52 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     devel@daynix.com
Subject: [PATCH v4 3/6] driver/net/tun: Added features for USO.
Date:   Fri,  2 Dec 2022 00:33:29 +0200
Message-Id: <20221201223332.249441-3-andrew@daynix.com>
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

Added support for USO4 and USO6.
For now, to "enable" USO, it's required to set both
USO4 and USO6 simultaneously.
USO enables NETIF_F_GSO_UDP_L4.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/tap.c | 10 ++++++++--
 drivers/net/tun.c |  8 +++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 9e75ed3f08ce..a2be1994b389 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -957,6 +957,10 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 			if (arg & TUN_F_TSO6)
 				feature_mask |= NETIF_F_TSO6;
 		}
+
+		/* TODO: for now USO4 and USO6 should work simultaneously */
+		if ((arg & (TUN_F_USO4 | TUN_F_USO6)) == (TUN_F_USO4 | TUN_F_USO6))
+			features |= NETIF_F_GSO_UDP_L4;
 	}
 
 	/* tun/tap driver inverts the usage for TSO offloads, where
@@ -967,7 +971,8 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	 * When user space turns off TSO, we turn off GSO/LRO so that
 	 * user-space will not receive TSO frames.
 	 */
-	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6))
+	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6) ||
+	    (feature_mask & (TUN_F_USO4 | TUN_F_USO6)) == (TUN_F_USO4 | TUN_F_USO6))
 		features |= RX_OFFLOADS;
 	else
 		features &= ~RX_OFFLOADS;
@@ -1091,7 +1096,8 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
 	case TUNSETOFFLOAD:
 		/* let the user check for future flags */
 		if (arg & ~(TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
-			    TUN_F_TSO_ECN | TUN_F_UFO))
+			    TUN_F_TSO_ECN | TUN_F_UFO |
+			    TUN_F_USO4 | TUN_F_USO6))
 			return -EINVAL;
 
 		rtnl_lock();
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 24001112c323..a7b9808368d0 100644
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
@@ -2885,6 +2885,12 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
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
2.38.1

