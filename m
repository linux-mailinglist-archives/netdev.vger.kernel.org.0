Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11395B0450
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 14:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiIGMv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 08:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiIGMvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 08:51:43 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1D679687
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 05:51:40 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id bz13so16823835wrb.2
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 05:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=1lVpjtDlaF+5VhIEURmZCQn6FL6I+O+1d6YHDApNOVo=;
        b=5UQNPtqdkHpPWN0N9/VEPYYyYNwtNnwe+9/3G7MdlNAfG8WjcMeWVFb/Wr9BBND3Ti
         FL5Ek2A+ZXash4w/mb7J1X863Ol65gpFzJYJ3QOfWJZlFFbxYHbDOgTCvOpvj4r3zfjz
         q7wJzkYmJo1kyBvDKsJkO70q+OCp1qgJYhJTeaceKscLPyvkGgbjZsvZY+uzXF6IKRrB
         DWPpbNWp4dg+fikIcudCObxMyfECnE+fYdf4+EoYudL7scDufpWTpMSDQdiWADquaNfy
         DoaqqzahRz+M50gl0MmrgCEz4OMswO469LBZKsc4MEJMIo/6mMUjPeqemPnFdlMpDGOU
         2eLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=1lVpjtDlaF+5VhIEURmZCQn6FL6I+O+1d6YHDApNOVo=;
        b=w9/fEf+jrbLaIPeAfUWQjykFstCCPf23Hs6r2iAnVLkEuTcQHYFk++3xNRPrZYqG6A
         oPVl4omlbhNCJ89aMzySbhEyfJD+cZviA6R8d0wcPwyESoEzO6k9UevCRCgNfMdI+C0f
         44chrPsaEp1NrIayxtN86UxsAMieeHuMCEBBNSNlHQMoiQoW2fTm2SkFBtYr8oqxVfLv
         FdK8tU0iWh5PnWg2yc6lDYYWl0+cQeHauf0q16lWZsOWhp24bbud1Fsn6vLyEXVclnSB
         Lte52G8oUtLq4f3gpI45lFUY8U3zy1OzH7UAoBtQkAcqSLcPak4Bj747Ct+3w1yLQkOC
         o6kg==
X-Gm-Message-State: ACgBeo1ZOPnElqT9iXp1S/cQMStJhPUlBsRwxkEVTLQjNrMjpQJRlAiK
        7EFmIl6kwpRSzw35tjVVJwBwyNbdvGlYMSQZ
X-Google-Smtp-Source: AA6agR7E7ieAZs6ZSxlc170nzW3ZuxPMzwS5U8xxx/8UBWzcJrILidBN+RNwFSraQHtxHJDkCS7XLA==
X-Received: by 2002:a5d:588b:0:b0:227:1c28:f470 with SMTP id n11-20020a5d588b000000b002271c28f470mr2106538wrf.331.1662555099965;
        Wed, 07 Sep 2022 05:51:39 -0700 (PDT)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id e27-20020adf9bdb000000b0021f0ff1bc6csm11480001wrc.41.2022.09.07.05.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 05:51:39 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     edumazet@google.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v3 5/6] linux/virtio_net.h: Support USO offload in vnet header.
Date:   Wed,  7 Sep 2022 15:50:47 +0300
Message-Id: <20220907125048.396126-6-andrew@daynix.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907125048.396126-1-andrew@daynix.com>
References: <20220907125048.396126-1-andrew@daynix.com>
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
2.37.2

