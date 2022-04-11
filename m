Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB24C4FC7B5
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 00:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343635AbiDKWfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 18:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiDKWfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 18:35:37 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255E62C65D;
        Mon, 11 Apr 2022 15:33:22 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id c199so10687232qkg.4;
        Mon, 11 Apr 2022 15:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=go1l0tqex0Qft61QYmHIHUcH+wHFMmQ9Fo+yUGTUQKI=;
        b=ClLF+INkGmffHtS2rHS1XziJTntk52Ng9ae07N9zDNHk6nz4zQZB15Gr4Gb592N+Sv
         5iAvYGvTf2GyrdJQ6hNWfwB9wSlVNh7M/siVVxQiJtaEKOyZVhEpmSzdGVSOvH4MSc1Z
         wv4KSyuQH1jJzIrO260fZxpTz2pV7IYdG7ZijfEWdw0nwZT+9WaOQQIkMs8i9mASoRqG
         eySm5++qBPhDZ9RBTlGW96ACp3UV93EkTLq+S69ru6TLFYWR9rsqb395ota/qk78AvnP
         ii4YJZ+48mQzWvUo/JAl7bWd4bbyKseoLu/ZRp5nF5vCRw3Hl/9E7oN+uGp07ajBzRA+
         wgEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=go1l0tqex0Qft61QYmHIHUcH+wHFMmQ9Fo+yUGTUQKI=;
        b=MQojQ8p3dd3QWwgzYWeBUfMAHSctI5A2Kp53zTE+ZP8wk2UTkO629tvTD09U+1hLpE
         4D817NPZ5QP7DtZQa9QeDkCZ5eXPZijaUBcF57rVQ5soCnBeOaz8rZiCbXNDLYw3mT3D
         2HCcbDhrv9v9fnD0XJI9MSTFd9MMYXk5EBuADdHZO0xYC36vENFmn6JeQkd384v3r2rW
         0yzvob9tandNlLbBwn/1tklhdLh7dYIWTzuQ63uUGsSXMNxV4UYhlU9KkbCNjvtwzI7p
         yE5fX+ZEVMUcJ5s5e09XJgz19HwbE3J3n5xiSmx4iRZvKWOyLAC4fs/pYzxPZQsE7RKf
         3ucQ==
X-Gm-Message-State: AOAM533aqPB70kvsHt9XNzubyhqf46qnjGKx8EKcqK4jYMvKDEeP6Zvf
        u5/AtiN7plHgeFhNwcpngg==
X-Google-Smtp-Source: ABdhPJw1bcvJYclIimih/psF7uDoIhUD9CfnLPSS/CEDcmU8fywZcQVExJ2xcivcD5/sWMDpzqU5Ng==
X-Received: by 2002:a37:9dc1:0:b0:69c:2932:503f with SMTP id g184-20020a379dc1000000b0069c2932503fmr1181476qke.49.1649716401289;
        Mon, 11 Apr 2022 15:33:21 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id u187-20020a3792c4000000b0067e679cfe5asm20013345qkd.59.2022.04.11.15.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 15:33:20 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Feng Zhou <zhoufeng.zf@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net 2/2] ip6_gre: Fix skb_under_panic in __gre6_xmit()
Date:   Mon, 11 Apr 2022 15:33:00 -0700
Message-Id: <9cd9ca4ac2c19be288cb8734a86eb30e4d9e2050.1649715555.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649715555.git.peilin.ye@bytedance.com>
References: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649715555.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Feng reported an skb_under_panic BUG triggered by running
test_ip6gretap() in tools/testing/selftests/bpf/test_tunnel.sh:

[   82.492551] skbuff: skb_under_panic: text:ffffffffb268bb8e len:403 put:12 head:ffff9997c5480000 data:ffff9997c547fff8 tail:0x18b end:0x2c0 dev:ip6gretap11
<...>
[   82.607380] Call Trace:
[   82.609389]  <TASK>
[   82.611136]  skb_push.cold.109+0x10/0x10
[   82.614289]  __gre6_xmit+0x41e/0x590
[   82.617169]  ip6gre_tunnel_xmit+0x344/0x3f0
[   82.620526]  dev_hard_start_xmit+0xf1/0x330
[   82.623882]  sch_direct_xmit+0xe4/0x250
[   82.626961]  __dev_queue_xmit+0x720/0xfe0
<...>
[   82.633431]  packet_sendmsg+0x96a/0x1cb0
[   82.636568]  sock_sendmsg+0x30/0x40
<...>

Reproducer:

  OBJ=$LINUX/tools/testing/selftests/bpf/test_tunnel_kern.o

  ip netns add at_ns0
  ip link add veth0 type veth peer name veth1
  ip link set veth0 netns at_ns0
  ip netns exec at_ns0 ip addr add 172.16.1.100/24 dev veth0
  ip netns exec at_ns0 ip link set dev veth0 up
  ip link set dev veth1 up mtu 1500
  ip addr add dev veth1 172.16.1.200/24

  ip netns exec at_ns0 ip addr add ::11/96 dev veth0
  ip netns exec at_ns0 ip link set dev veth0 up
  ip addr add dev veth1 ::22/96
  ip link set dev veth1 up

  ip netns exec at_ns0 \
  	ip link add dev ip6gretap00 type ip6gretap seq flowlabel 0xbcdef key 2 \
  	local ::11 remote ::22

  ip netns exec at_ns0 ip addr add dev ip6gretap00 10.1.1.100/24
  ip netns exec at_ns0 ip addr add dev ip6gretap00 fc80::100/96
  ip netns exec at_ns0 ip link set dev ip6gretap00 up

  ip link add dev ip6gretap11 type ip6gretap external
  ip addr add dev ip6gretap11 10.1.1.200/24
  ip addr add dev ip6gretap11 fc80::200/24
  ip link set dev ip6gretap11 up

  tc qdisc add dev ip6gretap11 clsact
  tc filter add dev ip6gretap11 egress bpf da obj $OBJ sec ip6gretap_set_tunnel
  tc filter add dev ip6gretap11 ingress bpf da obj $OBJ sec ip6gretap_get_tunnel

  ping6 -c 3 -w 10 -q ::11

The following sequence of events caused the BUG:

1. During ip6gretap device initialization, tunnel->tun_hlen (e.g. 4) is
   calculated based on old flags (see ip6gre_calc_hlen());
2. packet_snd() reserves header room for skb A, assuming
   tunnel->tun_hlen is 4;
3. Later (in clsact Qdisc), the eBPF program sets a new tunnel key for
   skb A using bpf_skb_set_tunnel_key() (see _ip6gretap_set_tunnel());
4. __gre6_xmit() detects the new tunnel key, and recalculates
   "tun_hlen" (e.g. 12) based on new flags (e.g. TUNNEL_KEY and
   TUNNEL_SEQ);
5. gre_build_header() calls skb_push() with insufficient reserved header
   room, triggering the BUG.

As sugguested by Cong, fix it by moving the call to skb_cow_head() after
the recalculation of tun_hlen.

Reported-by: Feng Zhou <zhoufeng.zf@bytedance.com>
Co-developed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
Hi all,

I couldn't find a proper Fixes: tag for this fix; please comment if you
have any sugguestions.  Thanks!

Peilin Ye

 net/ipv6/ip6_gre.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index b43a46449130..976236736146 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -733,9 +733,6 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 	else
 		fl6->daddr = tunnel->parms.raddr;
 
-	if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
-		return -ENOMEM;
-
 	/* Push GRE header. */
 	protocol = (dev->type == ARPHRD_ETHER) ? htons(ETH_P_TEB) : proto;
 
@@ -763,6 +760,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 			(TUNNEL_CSUM | TUNNEL_KEY | TUNNEL_SEQ);
 		tun_hlen = gre_calc_hlen(flags);
 
+		if (skb_cow_head(skb, dev->needed_headroom ?: tun_hlen + tunnel->encap_hlen))
+			return -ENOMEM;
+
 		gre_build_header(skb, tun_hlen,
 				 flags, protocol,
 				 tunnel_id_to_key32(tun_info->key.tun_id),
@@ -773,6 +773,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		if (tunnel->parms.o_flags & TUNNEL_SEQ)
 			tunnel->o_seqno++;
 
+		if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
+			return -ENOMEM;
+
 		gre_build_header(skb, tunnel->tun_hlen, tunnel->parms.o_flags,
 				 protocol, tunnel->parms.o_key,
 				 htonl(tunnel->o_seqno));
-- 
2.20.1

