Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE54464594F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiLGLvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiLGLvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:51:40 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F905133A
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 03:51:33 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id m19so24501951edj.8
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 03:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jBijGHO2AiN4F548fLyvLB60bsMpsKu4cHIqRi1tL5k=;
        b=H9X+AFPnQ/jrcVc/TZh4p6OCCB9QnS40L1PNff3KnTL3jCQL/9YUSluFGfIWNf3gKH
         Gj5X2MslAuL+bwkvot+yLkNRpx8VbxU01EEsTtDoNqwWtxIKptrYkCBN/XI9T2+zwe74
         eAUoicIW8NJphlWRYGQw2g27aHrS9bae1rFemv1LMfPt3ufU/rnFiG5tPle8inwnkPT2
         0nf03huOy7XhdnabUxaYiNjW14wavAn5/OUDv+5szb+Pz3olGMLKwG2srJddxiKQ7/w/
         Gugi/uX4FrkP6kLI3ZyM3Nj0erZmocZCHO21aSKmBHfughvhmmd3V8DmhRyTf21tDBfA
         JKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jBijGHO2AiN4F548fLyvLB60bsMpsKu4cHIqRi1tL5k=;
        b=opKo5ZWC68ONhU9lGIj0lFREpJL0VvGrL3+q6RczoVucfFkCV8SbhUDy4y0eJnygAK
         fKJfV6sOupwgJQoO1w/ANRjnA+zSAmCY/CTqE4CzV22sOGyHjIu0otLswvtHI9mh1I+c
         H5Q/3dC8ztzNjYaqzfc4KWN1FPM8n36RhHDFA3lk2ujWcsCsCnp7jiF5uPh/8cHU8SoG
         VkdbBNdsNMdJrlItez/Ln7C1t67xZfFtNfewXZPc+uo3Qu5sqBV6ys1BYjbAqI7PugMu
         Jn85Z5xCTWJ8GsAdSTdw6SbNhH+h8O1h+Yi+srt4GsRk8s6rq5RBO3Vf+IZazxLoCe/F
         XcYA==
X-Gm-Message-State: ANoB5pkc6Y49ktWxryRsJyqpex8y5p+Jlc9p2Y6ohvhZs/UBSoL4XA/u
        HCxm/M0n/d8wF3+E7PkWi5AACc81R13FnuES
X-Google-Smtp-Source: AA0mqf7faeznv+cpNEiJunIj8ZXLiDNsCAgep7kdqvALdydx8RSBGSjOxHBYVMfpgyqOzpQDAkk/iA==
X-Received: by 2002:a05:6402:528d:b0:468:dc9:ec08 with SMTP id en13-20020a056402528d00b004680dc9ec08mr5877921edb.17.1670413890749;
        Wed, 07 Dec 2022 03:51:30 -0800 (PST)
Received: from localhost.localdomain ([193.33.38.48])
        by smtp.gmail.com with ESMTPSA id g26-20020a056402181a00b004618a89d273sm2132816edy.36.2022.12.07.03.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 03:51:30 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v5 4/6] uapi/linux/virtio_net.h: Added USO types.
Date:   Wed,  7 Dec 2022 13:35:56 +0200
Message-Id: <20221207113558.19003-5-andrew@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221207113558.19003-1-andrew@daynix.com>
References: <20221207113558.19003-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 6cb842ea8979..b4062bed186a 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -57,6 +57,9 @@
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
 #define VIRTIO_NET_F_NOTF_COAL	53	/* Device supports notifications coalescing */
+#define VIRTIO_NET_F_GUEST_USO4	54	/* Guest can handle USOv4 in. */
+#define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
+#define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
@@ -130,6 +133,7 @@ struct virtio_net_hdr_v1 {
 #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
 #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
 #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
+#define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4& IPv6 UDP (USO) */
 #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
 	__u8 gso_type;
 	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
-- 
2.38.1

