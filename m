Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A551F501CD1
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 22:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343960AbiDNUiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 16:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239274AbiDNUiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 16:38:23 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E894E2F4B;
        Thu, 14 Apr 2022 13:35:57 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id s4so5158481qkh.0;
        Thu, 14 Apr 2022 13:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f17WoIbdYJpXhw2wSK913ngMAmGaCzMZ6BW2OuY2EBc=;
        b=nroHYi7HeWtWTBPtuhoSwQgBujB+UY1+C6EzNrXACumz3D11oVYQUh3I2IHANGEgov
         sKdPFnZWb5/u+FTcmTU3Pk0nFxjI3aLbpnytk1V+IH1r9/BMFzG+fhngxl6VcW/lOT3T
         9uuXN//iIlA9IAPhqTTck47Z1DFglK+718/iMuEPikvJlHzw5inLXKxwQZA7vUgAjA/e
         aRo1KshtYZIxJTTuRu8NSAXG2fCEDAzevUJwKAwos4Zre17uzI4USHGEBm1BaOKMdw9H
         CYgcBSh8VayGuOjjxeVuv2ETIoqL+Qjp5d/w3cYr+TYCiyiLD4J6fG4VpCVf1/e5wTi6
         HkDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f17WoIbdYJpXhw2wSK913ngMAmGaCzMZ6BW2OuY2EBc=;
        b=ntRaWjf7saaNKGWCLL6xvARLASRtbe7OkorgIzjOy8VKkpgQwk9UTCgFxXs4EOgrNw
         Lqk+lIsK9WcD4vob98mlNNGIZzHOVcZDKlkaj2CESdXuaS8XFYDyqV4gcwMuuRkGWOJ+
         eT/RNY6XmJr3wG0x22noWt2XJ2mK/fsUQ/11gy+7wn9HYhLNxLEg+sRWnOGj4citBsTh
         +0wqKVa7o0kX4me173w+jHEl5yIJ1n+wVBJwLP0u17DjrTC9bLsL79EkizAVhBwE8tZd
         r2sTcbQrWRedRntS05LpfpSjJ0iFGfGY7xS2SyRbRVeY0R1BtgbpN3V29NuRu469bles
         e0rQ==
X-Gm-Message-State: AOAM53161Mb1xyFXu3V7oqtF0+6DpO0b4/ty7ukzECl1NqwkYR4EjC6r
        iVf2Vi1Gh2KIgrgzL83zJQ==
X-Google-Smtp-Source: ABdhPJw8BlNqWF4P88Zj1O3N1/7Q1dGcpxKF429+pmg3/aZvOR9yGg/nznNKtf9TajXRhq00JVqizQ==
X-Received: by 2002:a37:990:0:b0:69a:976:be4e with SMTP id 138-20020a370990000000b0069a0976be4emr3278572qkj.321.1649968556441;
        Thu, 14 Apr 2022 13:35:56 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id s4-20020ae9de04000000b0069c3a577b0asm1453365qkf.51.2022.04.14.13.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 13:35:56 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        William Tu <u9012063@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Feng Zhou <zhoufeng.zf@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 2/2] ip6_gre: Fix skb_under_panic in __gre6_xmit()
Date:   Thu, 14 Apr 2022 13:35:40 -0700
Message-Id: <4a24d08cc5e1e2c356b5d2cfdb6931202a801703.1649967496.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649967496.git.peilin.ye@bytedance.com>
References: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649967496.git.peilin.ye@bytedance.com>
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

Fixes: 6712abc168eb ("ip6_gre: add ip6 gre and gretap collect_md mode")
Reported-by: Feng Zhou <zhoufeng.zf@bytedance.com>
Co-developed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
v1: https://lore.kernel.org/netdev/9cd9ca4ac2c19be288cb8734a86eb30e4d9e2050.1649715555.git.peilin.ye@bytedance.com/

changes since v1:
  - add a proper "Fixes:" tag (Jakub Kicinski)
  - restructure commit message

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

