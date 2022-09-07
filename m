Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7F25B0452
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 14:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiIGMv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 08:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiIGMvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 08:51:42 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8235AA4FA
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 05:51:35 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id az27so20244647wrb.6
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 05:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=nGlu+O6PlfW3f4AqMN8ylp1+LKCaEOK0oFUo4L9z4xA=;
        b=ueJxzkN3eJNlAg+GMZs26h6REziEHQI3HWXre9RJs19XnQoBTzWRjuFazwWX3JOHMj
         t87i0l4mhR594c89dLs4LSfdPQsFiQzdtVKQ+nol8t7zDmcQ7wqGvA6wim/isjUzyyaD
         vM+MmvfLQA/jZ0SpdhtWFnyxTdiQ1GJ7yYqU0R7wsTm3CVqb3Fc+B2ZupB37ZUrGBRCL
         aSNWbFn72P35KeoiGctujICZrrNelp0EVbOJQa9r6PqO4YXqpiVq9KYGCSxpakiYJtL6
         OPBVcyQEOJEGvNYBrvGpPuv15mkiuTStd7LZoYTF0qYE8JQU1WGPEN9ic53zGYuQ1F4E
         mJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=nGlu+O6PlfW3f4AqMN8ylp1+LKCaEOK0oFUo4L9z4xA=;
        b=ih6//7y0WwG1FhVCZprrR3usYJSIhXKzvBkrfcKcCwkXJAx4L5egpD/FRAVcEukpiY
         IjFqda9MGdJFCtwheO1V7p0C2ZmwUWWDZZGmyW5SGOAv2QSe94kuO8lvB9hs7utQroH0
         hs56hjuIV8o6rAbBi5a5GV3BpH6NsT1p0pLw1yRPVhaflLrcjcFsbXpcSflIdj81+9bh
         2Ve1QcpojkV46q3BRbn2PoRKqY3irgtIKowB045ksR5N0B7AvQhAgBAp0TsXHK+34G4P
         qsyu+48lgaP3Wo3nmq+wqC0y8SAXL5JLkHpKtd7cGOJ8RwUaNoWDeyBlJ5Nrmg3zVzLn
         e+/Q==
X-Gm-Message-State: ACgBeo1UkaFHIliLc84iCR5WRNDuhh2ULlc8eFNqYn8XjE5j3KydE3vK
        EA/03HB1bKAgpCbzJ8s7zKGJ6w==
X-Google-Smtp-Source: AA6agR5ZEuRdm/1QAOIGaAcNDlwntn9DuFUT138xlWy0ZrQWQV31HT8C2Kgpx41gGSCq6ES6au8o0A==
X-Received: by 2002:a5d:6245:0:b0:225:3e24:e5b1 with SMTP id m5-20020a5d6245000000b002253e24e5b1mr2089702wrv.698.1662555093607;
        Wed, 07 Sep 2022 05:51:33 -0700 (PDT)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id e27-20020adf9bdb000000b0021f0ff1bc6csm11480001wrc.41.2022.09.07.05.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 05:51:33 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     edumazet@google.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v3 3/6] driver/net/tun: Added features for USO.
Date:   Wed,  7 Sep 2022 15:50:45 +0300
Message-Id: <20220907125048.396126-4-andrew@daynix.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907125048.396126-1-andrew@daynix.com>
References: <20220907125048.396126-1-andrew@daynix.com>
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
index 259b2b84b2b3..f0e674e1c45e 100644
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
@@ -2871,6 +2871,12 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
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
2.37.2

