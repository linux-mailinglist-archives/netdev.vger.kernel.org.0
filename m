Return-Path: <netdev+bounces-9712-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99CD972A50B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:58:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34D91281A85
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E2D1E50F;
	Fri,  9 Jun 2023 20:58:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7A6408CE
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:58:47 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E62C3580
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:58:44 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-977d6aa3758so388627766b.0
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 13:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1686344323; x=1688936323;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SUKe/UP7zV/rwVtB2kksqTJM4NgjI+Cu+z4nW1n1A5c=;
        b=H2tL83AW2wrV9l8hCzczLdthWLNl6ThA8QTKT5j3unHNsxu7xDhoTgvtmxmSnsF/6P
         PynzEfD3Qs/IHiasejywjunVPIuOOBVMDUMJE1QSqZzrGzXnnEPG4ERWVyjezSjQUwyI
         VA2W5Mo5wYreI+60aFwm2mqx+AzYQFpgP8PvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686344323; x=1688936323;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SUKe/UP7zV/rwVtB2kksqTJM4NgjI+Cu+z4nW1n1A5c=;
        b=eJmppccKtLIshlIr+mK6C+4zDWpMmdRWXhrQHuKD+PHUqxh1YaupSDcmCABRXHLdxo
         mUI0AgNe2X63/egjxHqXjAKEmP7OcNzizBI4+mkGF8OKC7bQ4nCHcpwRVtrVTXD1m6cH
         aZekrdrcqbNAEIdCbvUT9xqKqC04TZP7c679M5bO9KbRkBCnED7wqoRyPMSZt56AK4lQ
         zP4WhwDqCIs4aT7RUNYk7yQ2cd9Nf7hH/MEnhxAMfH0V8+l0D5KRayNpG9kMw7F7qj8M
         OA9JGRDSbmQ8gucqB8HafKeI5RiOTYkj7k2vymKBBYOTqfggJXKkYpGFvmLvZ4rxfobH
         GJcw==
X-Gm-Message-State: AC+VfDy+dOUrpf8l2xpV661gabdKJcdPi91kTLWNlfdD8M0k49xGnl8W
	cP0FE5h+2qVe5LnSTdxbsY8WxQ==
X-Google-Smtp-Source: ACHHUZ7zXZjlBMowDNO0ht8YDkO23m/gtqNgV++I7BD5yWIBxlt2brksyJ/S04E7OfUxKj32+82i+Q==
X-Received: by 2002:a17:907:6d04:b0:974:326b:f9b2 with SMTP id sa4-20020a1709076d0400b00974326bf9b2mr2888800ejc.66.1686344323011;
        Fri, 09 Jun 2023 13:58:43 -0700 (PDT)
Received: from localhost (2a02-a210-2543-4700-cdda-6311-64ee-c89f.cable.dynamic.v6.ziggo.nl. [2a02:a210:2543:4700:cdda:6311:64ee:c89f])
        by smtp.gmail.com with ESMTPSA id x15-20020a170906710f00b009745bac0567sm1687832ejj.126.2023.06.09.13.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 13:58:42 -0700 (PDT)
From: Terin Stock <terin@cloudflare.com>
To: horms@verge.net.au,
	ja@ssi.bg
Cc: netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	kernel-team@cloudflare.com,
	pablo@netfilter.org,
	hengqing.hu@gmail.com,
	kuba@kernel.org,
	netfilter-devel@vger.kernel.org,
	fw@strlen.de,
	coreteam@netfilter.org,
	davem@davemloft.net,
	kadlec@netfilter.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH v2] ipvs: align inner_mac_header for encapsulation
Date: Fri,  9 Jun 2023 22:58:42 +0200
Message-Id: <20230609205842.2333727-1-terin@cloudflare.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When using encapsulation the original packet's headers are copied to the
inner headers. This preserves the space for an inner mac header, which
is not used by the inner payloads for the encapsulation types supported
by IPVS. If a packet is using GUE or GRE encapsulation and needs to be
segmented, flow can be passed to __skb_udp_tunnel_segment() which
calculates a negative tunnel header length. A negative tunnel header
length causes pskb_may_pull() to fail, dropping the packet.

This can be observed by attaching probes to ip_vs_in_hook(),
__dev_queue_xmit(), and __skb_udp_tunnel_segment():

    perf probe --add '__dev_queue_xmit skb->inner_mac_header \
    skb->inner_network_header skb->mac_header skb->network_header'
    perf probe --add '__skb_udp_tunnel_segment:7 tnl_hlen'
    perf probe -m ip_vs --add 'ip_vs_in_hook skb->inner_mac_header \
    skb->inner_network_header skb->mac_header skb->network_header'

These probes the headers and tunnel header length for packets which
traverse the IPVS encapsulation path. A TCP packet can be forced into
the segmentation path by being smaller than a calculated clamped MSS,
but larger than the advertised MSS.

    probe:ip_vs_in_hook: inner_mac_header=0x0 inner_network_header=0x0 mac_header=0x44 network_header=0x52
    probe:ip_vs_in_hook: inner_mac_header=0x44 inner_network_header=0x52 mac_header=0x44 network_header=0x32
    probe:dev_queue_xmit: inner_mac_header=0x44 inner_network_header=0x52 mac_header=0x44 network_header=0x32
    probe:__skb_udp_tunnel_segment_L7: tnl_hlen=-2

When using veth-based encapsulation, the interfaces are set to be
mac-less, which does not preserve space for an inner mac header. This
prevents this issue from occurring.

In our real-world testing of sending a 32KB file we observed operation
time increasing from ~75ms for veth-based encapsulation to over 1.5s
using IPVS encapsulation due to retries from dropped packets.

This changeset modifies the packet on the encapsulation path in
ip_vs_tunnel_xmit() and ip_vs_tunnel_xmit_v6() to remove the inner mac
header offset. This fixes UDP segmentation for both encapsulation types,
and corrects the inner headers for any IPIP flows that may use it.

Fixes: 84c0d5e96f3a ("ipvs: allow tunneling with gue encapsulation")
Signed-off-by: Terin Stock <terin@cloudflare.com>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index c7652da78c88..9193e109e6b3 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -1207,6 +1207,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	skb->transport_header = skb->network_header;
 
 	skb_set_inner_ipproto(skb, next_protocol);
+	skb_set_inner_mac_header(skb, skb_inner_network_offset(skb));
 
 	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 		bool check = false;
@@ -1349,6 +1350,7 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	skb->transport_header = skb->network_header;
 
 	skb_set_inner_ipproto(skb, next_protocol);
+	skb_set_inner_mac_header(skb, skb_inner_network_offset(skb));
 
 	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 		bool check = false;
-- 
2.40.1


