Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C2D32CD05
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 07:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbhCDGmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 01:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbhCDGlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 01:41:40 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB742C061574;
        Wed,  3 Mar 2021 22:40:59 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id a24so15551072plm.11;
        Wed, 03 Mar 2021 22:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XCS1qy8ob7XsXX9kc+oSLC6Sq4kYNTiKKYp1XNnNPYo=;
        b=MIrk1X/dYuDV1HYZaVsG13iy/qkH8SxReIQYTMCHRi1OKLtkdpmDvlkGFS0X2q9Amc
         Dh/2qGLzT6dQfNcgsXIpqjXT6HsR63zslvuuIYffZvrGPpB/JrT6jogbWC0iTKn4DYwe
         h5az6SUIo41VtDoUpgeKBewMX75G8EyZ6dZoXiooLMbiX8glHarLMHVxe1BqU/PftaMT
         1N0H3Bt4v6oCwY99zaJcZ0H5EfuCqE8Nnt36xeJo08/6YEXbCbhCSWQ/091BYod6sFsV
         n7Xjl0rmgwo2tbYIWka0N92+p8lmhQILasB4UB66csnoAVIM/mnNLcCa0x4lVBivFAZi
         DUrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XCS1qy8ob7XsXX9kc+oSLC6Sq4kYNTiKKYp1XNnNPYo=;
        b=gkyQKa1MCePL3ZgbJRCLAHD5QUF9BIXYJSuVdqrlX5gbjJj6Db0nWNQ/BeSLdL+qAJ
         yzFLqESW/q6ZnbZeQ/otfOnxA17E8wE9lHiSy6p7OQ6PsUqVhqrNK4nX0e35Jba4PYI+
         epbrFqKhlNuMVeWu3DgQ5e6RuEc5pTQoPYVCI8v5cjevUxcJ8fIwLHhpkNr2U4PIedaq
         47DJ4KITKWN0rajDEAAKGouWjPQjKEhe3V2TNNufQlVUZ1KOq8uuImT9ozL7OeUPO5a0
         JvoZiQxat2s1ZF1aE8X+HYc79Uig6xLJPLmoRWFa6M3VaNDE9hLCWtGe10j2lbugwil1
         9NRQ==
X-Gm-Message-State: AOAM531OwqJWCGZ8+fkUEjRkUFqD6mqBkAOGlJ5w3yrSmzLmH6qcHHSM
        rHtJ0LCC0OPG4CEbQFQv0iv2xxc6Ht8bakZy
X-Google-Smtp-Source: ABdhPJwkzlb6j0JpXmV/DZa0PWIzkaAwY9COyMFlQEVvWQdkBjkA5pMBdkeZatO9RORIuW/ZCn8YXw==
X-Received: by 2002:a17:902:344:b029:e4:a7ab:2e55 with SMTP id 62-20020a1709020344b02900e4a7ab2e55mr2781692pld.63.1614840059491;
        Wed, 03 Mar 2021 22:40:59 -0800 (PST)
Received: from localhost.localdomain ([103.112.79.202])
        by smtp.gmail.com with ESMTPSA id t10sm8712550pjf.30.2021.03.03.22.40.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Mar 2021 22:40:58 -0800 (PST)
From:   Xuesen Huang <hxseverything@gmail.com>
To:     daniel@iogearbox.net
Cc:     davem@davemloft.net, bpf@vger.kernel.org,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
        Xuesen Huang <huangxuesen@kuaishou.com>,
        Willem de Bruijn <willemb@google.com>,
        Zhiyong Cheng <chengzhiyong@kuaishou.com>,
        Li Wang <wangli09@kuaishou.com>
Subject: [PATCH/v5] bpf: add bpf_skb_adjust_room flag BPF_F_ADJ_ROOM_ENCAP_L2_ETH
Date:   Thu,  4 Mar 2021 14:40:46 +0800
Message-Id: <20210304064046.6232-1-hxseverything@gmail.com>
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

