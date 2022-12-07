Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7B364594C
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiLGLvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiLGLvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:51:40 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161045133E
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 03:51:34 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id vp12so13364473ejc.8
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 03:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/l0FUf2LxM2s+FDut6wgd6Dg4LANJfMwzdqmeR53eYQ=;
        b=zGFToKn8FO86Xuv7xvlk8liqDBqCPtY/J6xbVIrbVoCMYk37GfocinB/w4RX6y/pzM
         4ZGegPNiPLEVFHdFPF6sRPCUqQ+MQPse11q8bDMIKo9f+StPCIaCT18AKoOOE7/j58ni
         qHJZjAwf2Diws280GHKdu2muF6bQCiQfRUkOSH6dIbG7qwf5kouiNDBzbs8+JGmuYhPs
         pjEyAaDqf1+JDh9lwjKS13SEbi4oeHEGWOvPuVVmNu52DF63clWC4lBbmZL9XZ1/8Asi
         u6/Rz+zYUUj8+1Rvk0lcnWiM1B3nmx+byccKjnjwbApusrzRV8aX9HgnfnoBEbTdzbba
         6aVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/l0FUf2LxM2s+FDut6wgd6Dg4LANJfMwzdqmeR53eYQ=;
        b=Xyy+19umG1l878ZhTtxBXdXHECN1tnjTyq6+ink4SBVVXZA3aWmYVBBYeT5KiylwKC
         GnlKbCNjYGOjD5HcA2BEAOPhTxXQDekG16gHWFgcsiWvRmjrB7wcgietI6egSrr2tHrl
         uowNolejjuRCfKiLc3JNCdMMkq2Qv0nPqePqQEU17QmzjZw0vusTKjerDdhP6K3bDL1E
         Hj2++e167g4H+UkbkL9XZVBwQv98WjSKMn9oNr4hQYMh6qdODHNtsQluHJXsPX0TnI9w
         T3OuE704+CwfN0LFOALmH8NNMTbtuhMdRuppeUAxEBSk8hEl5otaImKCQ3UcvhJoexHS
         ODKA==
X-Gm-Message-State: ANoB5pmASQqdXtMVrpD36dVRrxwb/FhpgTJj4y1q6fRPRIGaPJCr8ppN
        vp1y4DSaas7XmpkF8KOOI9MWpQ==
X-Google-Smtp-Source: AA0mqf7+5NlnP9WcERs7h4Vqci3F/FAmaQylak0BsGYiINaDgtGqamvILPTZQKlrzMLN2sxBgVUllA==
X-Received: by 2002:a17:906:fa0d:b0:7c0:e5cb:b73b with SMTP id lo13-20020a170906fa0d00b007c0e5cbb73bmr12860692ejb.624.1670413892372;
        Wed, 07 Dec 2022 03:51:32 -0800 (PST)
Received: from localhost.localdomain ([193.33.38.48])
        by smtp.gmail.com with ESMTPSA id g26-20020a056402181a00b004618a89d273sm2132816edy.36.2022.12.07.03.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 03:51:32 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v5 5/6] linux/virtio_net.h: Support USO offload in vnet header.
Date:   Wed,  7 Dec 2022 13:35:57 +0200
Message-Id: <20221207113558.19003-6-andrew@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221207113558.19003-1-andrew@daynix.com>
References: <20221207113558.19003-1-andrew@daynix.com>
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

