Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D4F315FC8
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 08:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhBJHA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 02:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbhBJHAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 02:00:19 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C20C061574;
        Tue,  9 Feb 2021 22:59:39 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id t2so612075pjq.2;
        Tue, 09 Feb 2021 22:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XCKWQNXWB4AbvF10Eq2wrIvNf5gXtMMoP+h6tI0nVDM=;
        b=dUCJIKT7aBYjoMQ8jr7wgyBQJ5WqUJorZzKTG+pbcyDfq/iEuAvsOCoWsxv8gUbdqz
         mI0lOziSQ38kvLr5oZypSXwXRvvlcqLyod+gikdudir/j88WgFD9S/qWlAJaErEA7Zzn
         AoN9Y8IqDPQBShXrdox6skLICdItIRoYi0umkrDMNSnmuOmHF/JUiWCtEkc0hr194ZH9
         X1izEidQ7Ic0rVnNfY/0xNOq6NcsUZ/gr0fQEJRs61R7uQ/UWSDVPa6ZBQPfo6QiCeJS
         PApZ5NCn6YQtlQiljmp2KUQFL04ckQ1QTQHufISFDnEo9hf8RaWimiw31rUIs/suvB3A
         9U6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XCKWQNXWB4AbvF10Eq2wrIvNf5gXtMMoP+h6tI0nVDM=;
        b=FVbReNbHniF2hSfSK1Qk5az0vWzfZ+xL7UXji6KoSERCLjX7JNTCj/vbFll79D0OT2
         c3HbA7STa48vQcglpnSPnLXrk8UjYEdF9eiWnWfXik4OoHFsCamh38yyHdfFs4HeONQW
         qZh0opXB1lfnlVk/SxACzhHaWZBnXynLYetGwZNAhG8x0mT30aHvdrfCo0Bil6MdxWy0
         GggwAavvCR/FTv119He0nLFjPFMKATUiDpO3UOtOLHYnVx27kAjKVvpjyGmOSIBePZsT
         cQwE9Eq2L5XRca1d+gZrz7lxbnyXMKvripGnhmvRsg6jtNYWGaa2tq8WN4TnAEns/A+Z
         +gLA==
X-Gm-Message-State: AOAM532+8vq0Exe9gbTm9d0HzKAmaiwW1nucAEzPeHU2WS+o2Ts/FBUS
        XKpO36Gwwmg9trSiLBlAtEc=
X-Google-Smtp-Source: ABdhPJwUoXpV1tL5kupZmldpBDDiMjYRs9uyOK8RVWTHCVhX3vAQ1TICsphNDjdq5xLN3NQrpqdFRA==
X-Received: by 2002:a17:902:e812:b029:de:5af2:3d09 with SMTP id u18-20020a170902e812b02900de5af23d09mr1748022plg.33.1612940378569;
        Tue, 09 Feb 2021 22:59:38 -0800 (PST)
Received: from localhost.localdomain ([154.48.252.67])
        by smtp.gmail.com with ESMTPSA id w128sm1071489pfb.12.2021.02.09.22.59.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 22:59:37 -0800 (PST)
From:   huangxuesen <hxseverything@gmail.com>
To:     willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, bpf@vger.kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huangxuesen <huangxuesen@kuaishou.com>,
        Willem de Bruijn <willemb@google.com>,
        chengzhiyong <chengzhiyong@kuaishou.com>,
        wangli <wangli09@kuaishou.com>
Subject: [PATCH/v2] bpf: add bpf_skb_adjust_room flag BPF_F_ADJ_ROOM_ENCAP_L2_ETH
Date:   Wed, 10 Feb 2021 14:59:25 +0800
Message-Id: <20210210065925.22614-1-hxseverything@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: huangxuesen <huangxuesen@kuaishou.com>

bpf_skb_adjust_room sets the inner_protocol as skb->protocol for packets
encapsulation. But that is not appropriate when pushing Ethernet header.

Add an option to further specify encap L2 type and set the inner_protocol
as ETH_P_TEB.

Suggested-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: huangxuesen <huangxuesen@kuaishou.com>
Signed-off-by: chengzhiyong <chengzhiyong@kuaishou.com>
Signed-off-by: wangli <wangli09@kuaishou.com>
---
 include/uapi/linux/bpf.h       |  5 +++++
 net/core/filter.c              | 11 ++++++++++-
 tools/include/uapi/linux/bpf.h |  5 +++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 77d7c1b..d791596 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1751,6 +1751,10 @@ struct bpf_stack_build_id {
  *		  Use with ENCAP_L3/L4 flags to further specify the tunnel
  *		  type; *len* is the length of the inner MAC header.
  *
+ *		* **BPF_F_ADJ_ROOM_ENCAP_L2_ETH**:
+ *		  Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
+ *		  L2 type as Ethernet.
+ *
  * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
@@ -4088,6 +4092,7 @@ enum {
 	BPF_F_ADJ_ROOM_ENCAP_L4_GRE	= (1ULL << 3),
 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
 	BPF_F_ADJ_ROOM_NO_CSUM_RESET	= (1ULL << 5),
+	BPF_F_ADJ_ROOM_ENCAP_L2_ETH	= (1ULL << 6),
 };
 
 enum {
diff --git a/net/core/filter.c b/net/core/filter.c
index 255aeee..8d1fb61 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3412,6 +3412,7 @@ static u32 bpf_skb_net_base_len(const struct sk_buff *skb)
 					 BPF_F_ADJ_ROOM_ENCAP_L3_MASK | \
 					 BPF_F_ADJ_ROOM_ENCAP_L4_GRE | \
 					 BPF_F_ADJ_ROOM_ENCAP_L4_UDP | \
+					 BPF_F_ADJ_ROOM_ENCAP_L2_ETH | \
 					 BPF_F_ADJ_ROOM_ENCAP_L2( \
 					  BPF_ADJ_ROOM_ENCAP_L2_MASK))
 
@@ -3448,6 +3449,10 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 		    flags & BPF_F_ADJ_ROOM_ENCAP_L4_UDP)
 			return -EINVAL;
 
+		if (flags & BPF_F_ADJ_ROOM_ENCAP_L2_ETH &&
+		    inner_mac_len < ETH_HLEN)
+			return -EINVAL;
+
 		if (skb->encapsulation)
 			return -EALREADY;
 
@@ -3466,7 +3471,11 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 		skb->inner_mac_header = inner_net - inner_mac_len;
 		skb->inner_network_header = inner_net;
 		skb->inner_transport_header = inner_trans;
-		skb_set_inner_protocol(skb, skb->protocol);
+
+		if (flags & BPF_F_ADJ_ROOM_ENCAP_L2_ETH)
+			skb_set_inner_protocol(skb, htons(ETH_P_TEB));
+		else
+			skb_set_inner_protocol(skb, skb->protocol);
 
 		skb->encapsulation = 1;
 		skb_set_network_header(skb, mac_len);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 77d7c1b..d791596 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1751,6 +1751,10 @@ struct bpf_stack_build_id {
  *		  Use with ENCAP_L3/L4 flags to further specify the tunnel
  *		  type; *len* is the length of the inner MAC header.
  *
+ *		* **BPF_F_ADJ_ROOM_ENCAP_L2_ETH**:
+ *		  Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further specify the
+ *		  L2 type as Ethernet.
+ *
  * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
  * 		previously done by the verifier are invalidated and must be
@@ -4088,6 +4092,7 @@ enum {
 	BPF_F_ADJ_ROOM_ENCAP_L4_GRE	= (1ULL << 3),
 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	= (1ULL << 4),
 	BPF_F_ADJ_ROOM_NO_CSUM_RESET	= (1ULL << 5),
+	BPF_F_ADJ_ROOM_ENCAP_L2_ETH	= (1ULL << 6),
 };
 
 enum {
-- 
1.8.3.1

