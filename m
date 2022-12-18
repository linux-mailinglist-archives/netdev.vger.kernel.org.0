Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E701B64FDC0
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 06:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiLRFSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 00:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiLRFSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 00:18:07 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29C2DC0
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 21:18:05 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id ay40so4411802wmb.2
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 21:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OKPkOEQY7zOz0QOKMu3IK2pVB1gYNrcFW/XQicj/J2I=;
        b=mvVqW+ef0eI3J0Fc0iAQp6DV5ao5lZTHuLxRbfI/nYL2Ek2LSimLVU4j6WUtvyiXBg
         52YBBn7nP2yQ7NYmrgip+ETLepVEH2qyurmU3lG201ImN6bSwkDiBJi0HtAvSM9iTvYu
         uIdJchWd1q3WKTdJnHADVME5bw/1tcbrLNKcY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OKPkOEQY7zOz0QOKMu3IK2pVB1gYNrcFW/XQicj/J2I=;
        b=Iebw4mlcYT88HIfNEmMIEIHXHFAKLIxU8dUBALKmgkPkV32U08ztxJR4gBdmFWmfKx
         H2IlFqs9ttTxfvQ37Mnv3Ml/mO0CIyjjgt751T92AFNQNxhfflTnBr7LIrRtJUMW4D3S
         XrtNYrSgHsF/AsTKnkvLkx9Sz9MAFTNR9GwP1KETFh2Brm7KwnmdcLhWxgfo+be/FvfJ
         PIcpv1qrcF637xFE0c7IouFFzEF05tw4625v0BLALea2oZYUQ7MfDb512CPH0o6ar1rw
         af3TvNTw4tRM0AUeQRjkeliprtCvcu8IgEk1kaw9kQnY9yzuvuBztuEiT1cuZdQetd/w
         zdxQ==
X-Gm-Message-State: ANoB5pmnKFKYP0nZEXLnLgttodKCd4o2WyPhRMdvPlOrdnA+p8e+mjQ1
        9nlAVTkiSrBDwCcAWcdVmPdO0Q==
X-Google-Smtp-Source: AA0mqf6v18bTlqQgutS30SKz+1JZlO8lpiCkG+dsM9VHGr2wmKEtuqtpPnzb9O1dHWne/Z/ETVxScg==
X-Received: by 2002:a05:600c:4fc8:b0:3cf:614e:b587 with SMTP id o8-20020a05600c4fc800b003cf614eb587mr29465855wmq.26.1671340684350;
        Sat, 17 Dec 2022 21:18:04 -0800 (PST)
Received: from workstation.ehrig.io (tmo-122-74.customers.d1-online.com. [80.187.122.74])
        by smtp.gmail.com with ESMTPSA id k62-20020a1ca141000000b003cf894dbc4fsm7805231wme.25.2022.12.17.21.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 21:18:03 -0800 (PST)
From:   Christian Ehrig <cehrig@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     cehrig@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kui-Feng Lee <kuifeng@fb.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Shmulik Ladkani <shmulik@metanetworks.com>,
        Paul Chaignon <paul@isovalent.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 1/2] bpf: Add flag BPF_F_NO_TUNNEL_KEY to bpf_skb_set_tunnel_key()
Date:   Sun, 18 Dec 2022 06:17:31 +0100
Message-Id: <20221218051734.31411-1-cehrig@cloudflare.com>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows to remove TUNNEL_KEY from the tunnel flags bitmap
when using bpf_skb_set_tunnel_key by providing a BPF_F_NO_TUNNEL_KEY
flag. On egress, the resulting tunnel header will not contain a tunnel
key if the protocol and implementation supports it.

At the moment bpf_tunnel_key wants a user to specify a numeric tunnel
key. This will wrap the inner packet into a tunnel header with the key
bit and value set accordingly. This is problematic when using a tunnel
protocol that supports optional tunnel keys and a receiving tunnel
device that is not expecting packets with the key bit set. The receiver
won't decapsulate and drop the packet.

RFC 2890 and RFC 2784 GRE tunnels are examples where this flag is
useful. It allows for generating packets, that can be decapsulated by
a GRE tunnel device not operating in collect metadata mode or not
expecting the key bit set.

Signed-off-by: Christian Ehrig <cehrig@cloudflare.com>
---
 include/uapi/linux/bpf.h       | 4 ++++
 net/core/filter.c              | 5 ++++-
 tools/include/uapi/linux/bpf.h | 4 ++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 464ca3f01fe7..bc1a3d232ae4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2001,6 +2001,9 @@ union bpf_attr {
  * 			sending the packet. This flag was added for GRE
  * 			encapsulation, but might be used with other protocols
  * 			as well in the future.
+ * 		**BPF_F_NO_TUNNEL_KEY**
+ * 			Add a flag to tunnel metadata indicating that no tunnel
+ * 			key should be set in the resulting tunnel header.
  *
  * 		Here is a typical usage on the transmit path:
  *
@@ -5764,6 +5767,7 @@ enum {
 	BPF_F_ZERO_CSUM_TX		= (1ULL << 1),
 	BPF_F_DONT_FRAGMENT		= (1ULL << 2),
 	BPF_F_SEQ_NUMBER		= (1ULL << 3),
+	BPF_F_NO_TUNNEL_KEY		= (1ULL << 4),
 };
 
 /* BPF_FUNC_skb_get_tunnel_key flags. */
diff --git a/net/core/filter.c b/net/core/filter.c
index 929358677183..c746e4d77214 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4615,7 +4615,8 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff *, skb,
 	struct ip_tunnel_info *info;
 
 	if (unlikely(flags & ~(BPF_F_TUNINFO_IPV6 | BPF_F_ZERO_CSUM_TX |
-			       BPF_F_DONT_FRAGMENT | BPF_F_SEQ_NUMBER)))
+			       BPF_F_DONT_FRAGMENT | BPF_F_SEQ_NUMBER |
+			       BPF_F_NO_TUNNEL_KEY)))
 		return -EINVAL;
 	if (unlikely(size != sizeof(struct bpf_tunnel_key))) {
 		switch (size) {
@@ -4653,6 +4654,8 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff *, skb,
 		info->key.tun_flags &= ~TUNNEL_CSUM;
 	if (flags & BPF_F_SEQ_NUMBER)
 		info->key.tun_flags |= TUNNEL_SEQ;
+	if (flags & BPF_F_NO_TUNNEL_KEY)
+		info->key.tun_flags &= ~TUNNEL_KEY;
 
 	info->key.tun_id = cpu_to_be64(from->tunnel_id);
 	info->key.tos = from->tunnel_tos;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 464ca3f01fe7..bc1a3d232ae4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2001,6 +2001,9 @@ union bpf_attr {
  * 			sending the packet. This flag was added for GRE
  * 			encapsulation, but might be used with other protocols
  * 			as well in the future.
+ * 		**BPF_F_NO_TUNNEL_KEY**
+ * 			Add a flag to tunnel metadata indicating that no tunnel
+ * 			key should be set in the resulting tunnel header.
  *
  * 		Here is a typical usage on the transmit path:
  *
@@ -5764,6 +5767,7 @@ enum {
 	BPF_F_ZERO_CSUM_TX		= (1ULL << 1),
 	BPF_F_DONT_FRAGMENT		= (1ULL << 2),
 	BPF_F_SEQ_NUMBER		= (1ULL << 3),
+	BPF_F_NO_TUNNEL_KEY		= (1ULL << 4),
 };
 
 /* BPF_FUNC_skb_get_tunnel_key flags. */
-- 
2.37.4

