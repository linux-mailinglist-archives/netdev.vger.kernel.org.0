Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3DA63FAE5
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbiLAWtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiLAWs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:48:58 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A24A1C1D
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 14:48:56 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id d3so3573907ljl.1
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 14:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/l0FUf2LxM2s+FDut6wgd6Dg4LANJfMwzdqmeR53eYQ=;
        b=YgA9JI0r8x1idCpGrUISHXxPTdpS8bE+zsK2hvBE6Clp7Ot8Tk6aeKy8gHLzxM9ui6
         kC97V/EXcm29B+G1Wg5a7hkVWQ3+bAK5vu99zAskxHMi0yjdL+s2G6pFOFL8LJ6YMrQr
         dT1zEeyypZF4PBKfoG9RmIKCV01RpeCg7mkX/vh/FYeN4WPOQdeO7ejQKenuwrerVhn1
         JKY0SzO7f92Vpm3LiqAnYZoGS/wTqDzcpS8Kj3v8JrfT5UFennM93bMqq/oWMWpUzup1
         WIpuivGA5QSgzGvV9nM9bamVilfi++Rtc1Q44hoWfxurIEOwu2e4lFeNcgPVNGiuZcFD
         rvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/l0FUf2LxM2s+FDut6wgd6Dg4LANJfMwzdqmeR53eYQ=;
        b=QlkCJptR3iBtRXxs4Nv3BpiKsCoxA1I5PxFxXTK8Dga3eZ9HdxiEDKhyvf630XAyaC
         TFrgdEREgv3PsFi8jL0oEjQQNZr+wP+Py9Ly3nTRXYZaUlaUJzrJukvUhfdiVGmA8Z0m
         qmL5Kh7g4mpVVylC+4n4Wn5pn1mvTmKPgEs7BJn7mnH/99hJQ4lQFwG/h0nH6z2af8A0
         otQ0HoPw+q/WBk/sX+ItGso5OsSDcN/x7RQhnWBqZ1a8bzYo1TLij/hP6QVe0DN7turc
         +mTAxQAQM/x47NV3lDIkKa/rzCoANEzQddmCoH8I8dARXLO2bdd7eVd2mYpM6iL+YMtw
         MtAQ==
X-Gm-Message-State: ANoB5pkOygCHtwvvX3+CXDWXAHVsKA9IIBbveaIx4rZvXcBil+3Z+2AS
        yeibgw3VQqTc44BWbSGVKESMBg==
X-Google-Smtp-Source: AA0mqf6z1/SPXT0IYlCh6uASjRLPNbQTx97NzAe14WJnS6Vvg6j4QCwKsOjDSjCtAjn6pCA/kVnYpw==
X-Received: by 2002:a05:651c:243:b0:279:9935:9170 with SMTP id x3-20020a05651c024300b0027999359170mr9579082ljn.457.1669934935286;
        Thu, 01 Dec 2022 14:48:55 -0800 (PST)
Received: from localhost.localdomain ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id g7-20020a056512118700b00497ab34bf5asm797573lfr.20.2022.12.01.14.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 14:48:54 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     devel@daynix.com
Subject: [PATCH v4 5/6] linux/virtio_net.h: Support USO offload in vnet header.
Date:   Fri,  2 Dec 2022 00:33:31 +0200
Message-Id: <20221201223332.249441-5-andrew@daynix.com>
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

Now, it's possible to convert USO vnet packets from/to skb.
Added support for GSO_UDP_L4 offload.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 include/linux/virtio_net.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index a960de68ac69..bdf8de2cdd93 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -15,6 +15,7 @@ static inline bool virtio_net_hdr_match_proto(__be16 protocol, __u8 gso_type)
 	case VIRTIO_NET_HDR_GSO_TCPV6:
 		return protocol == cpu_to_be16(ETH_P_IPV6);
 	case VIRTIO_NET_HDR_GSO_UDP:
+	case VIRTIO_NET_HDR_GSO_UDP_L4:
 		return protocol == cpu_to_be16(ETH_P_IP) ||
 		       protocol == cpu_to_be16(ETH_P_IPV6);
 	default:
@@ -31,6 +32,7 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
 	switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
 	case VIRTIO_NET_HDR_GSO_TCPV4:
 	case VIRTIO_NET_HDR_GSO_UDP:
+	case VIRTIO_NET_HDR_GSO_UDP_L4:
 		skb->protocol = cpu_to_be16(ETH_P_IP);
 		break;
 	case VIRTIO_NET_HDR_GSO_TCPV6:
@@ -69,6 +71,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 			ip_proto = IPPROTO_UDP;
 			thlen = sizeof(struct udphdr);
 			break;
+		case VIRTIO_NET_HDR_GSO_UDP_L4:
+			gso_type = SKB_GSO_UDP_L4;
+			ip_proto = IPPROTO_UDP;
+			thlen = sizeof(struct udphdr);
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -182,6 +189,8 @@ static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
 			hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
 		else if (sinfo->gso_type & SKB_GSO_TCPV6)
 			hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
+		else if (sinfo->gso_type & SKB_GSO_UDP_L4)
+			hdr->gso_type = VIRTIO_NET_HDR_GSO_UDP_L4;
 		else
 			return -EINVAL;
 		if (sinfo->gso_type & SKB_GSO_TCP_ECN)
-- 
2.38.1

