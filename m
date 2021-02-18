Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1A131ED93
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbhBRRrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbhBRQkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 11:40:13 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8B1C061574;
        Thu, 18 Feb 2021 08:39:28 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id e9so1828768pjj.0;
        Thu, 18 Feb 2021 08:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XCS1qy8ob7XsXX9kc+oSLC6Sq4kYNTiKKYp1XNnNPYo=;
        b=tjcsSKlqihVsOaiJCi0Dm5mUG1XxbSeCOuVxJev77g+zYHXf7oeiG93b/J67bVMZa7
         hBT7A0zdYGkdiuHmE8rIZoRC9wFfFAAqz5tqBGY3KfnEx9r9Bk8+/3Ro5E727CwDQ310
         mq+6eu5ow3z9AWCz3AYU9MeEuiNZNIXmjzdQE28nX+TsI4bP55s7i+A/USexGPBIIa1O
         Sow3bx/n9b4/NNdeFUs09TJUwuyYx6jJ2ABMMDflV/jN6VwwdAToLtSvgb8VPWjhHPbQ
         EgJBC2qgJsg8ltY7Lp2MI6p50teIHF/RiuIumuI43Zdguo5USJyOny1hbria6JP4+qaJ
         erIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XCS1qy8ob7XsXX9kc+oSLC6Sq4kYNTiKKYp1XNnNPYo=;
        b=OBh8FfHI2I8sVdy9RobVoLgDDqaUWkCmJZK/+KyxW8svw+sDN1EGyHYGmkXPdIlZrp
         nfz2MK7v3aYAAuyqjhtXM5PCMX88Fx0QOfTWecim8rg1maozHOGdw7X3APPQwdyAHHTZ
         OO6yUlFlrLkbdhz6nmRxh/VwU7HsrN8jBnqX/J7d1qwh3JfBOFYrLasSt006dciKCurL
         bjbqF2DucBrcZJvtf7f2rCUToZpOSqnl04OLZOTPofrmia/y15xDGjrY9sXLXypoP788
         /lapXRCvgibHneCPz8sH1BePcfbu5BQ/i1MfrMVmeowvzFM6E+uFeaiTyks468JORJbr
         WSmw==
X-Gm-Message-State: AOAM531enpZC0DcfbsaA2GaA2DQGRxUCXhDrCbBQ0KVlkEbn8wTgi6bq
        PaivQ+zCjRQjLInM4E2C8xkirFJCfhy+oo85
X-Google-Smtp-Source: ABdhPJy3oyXwsGciCKxueasMwiTAkxzoT3YfWDqrGEQlgBcELCgh3GwtHyYZs20osF6Ai6kEql52Xw==
X-Received: by 2002:a17:90a:8b83:: with SMTP id z3mr4841731pjn.75.1613666367831;
        Thu, 18 Feb 2021 08:39:27 -0800 (PST)
Received: from localhost.localdomain ([122.10.101.135])
        by smtp.gmail.com with ESMTPSA id s1sm6282938pfe.151.2021.02.18.08.39.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Feb 2021 08:39:21 -0800 (PST)
From:   Xuesen Huang <hxseverything@gmail.com>
To:     willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, bpf@vger.kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuesen Huang <huangxuesen@kuaishou.com>,
        Willem de Bruijn <willemb@google.com>,
        Zhiyong Cheng <chengzhiyong@kuaishou.com>,
        Li Wang <wangli09@kuaishou.com>
Subject: [PATCH/v2] bpf: add bpf_skb_adjust_room flag BPF_F_ADJ_ROOM_ENCAP_L2_ETH
Date:   Fri, 19 Feb 2021 00:39:03 +0800
Message-Id: <20210218163903.60992-1-hxseverything@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xuesen Huang <huangxuesen@kuaishou.com>

bpf_skb_adjust_room sets the inner_protocol as skb->protocol for packets
encapsulation. But that is not appropriate when pushing Ethernet header.

Add an option to further specify encap L2 type and set the inner_protocol
as ETH_P_TEB.

Suggested-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Xuesen Huang <huangxuesen@kuaishou.com>
Signed-off-by: Zhiyong Cheng <chengzhiyong@kuaishou.com>
Signed-off-by: Li Wang <wangli09@kuaishou.com>
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

