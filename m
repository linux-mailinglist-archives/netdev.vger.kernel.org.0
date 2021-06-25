Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC8B3B4480
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 15:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhFYNfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 09:35:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhFYNfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 09:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624627997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=07gaNdDU4jdLTbiLg4I5HGLFZA2UUTXHidiT8HumwPs=;
        b=AJhVdEtDtBi4gNlv0MLdaNpDtmDFnbW/R4d+X2FGgW0CoqKusLy3VdF7u1z2jZiL4UqcPN
        s7s8egG+HAvEeWJGA7emmKQK8uAS1ph7dK8dfHjQhGwjA3EYnZ7+fi62Xx/K+S0JfIbkCT
        +Na8O4NGyjoMfrpopFK3bGfvPS5raKo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-EIkJcjNIOHCBiQ5jxTl7Cw-1; Fri, 25 Jun 2021 09:33:12 -0400
X-MC-Unique: EIkJcjNIOHCBiQ5jxTl7Cw-1
Received: by mail-wm1-f71.google.com with SMTP id j38-20020a05600c1c26b02901dbf7d18ff8so4197327wms.8
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 06:33:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=07gaNdDU4jdLTbiLg4I5HGLFZA2UUTXHidiT8HumwPs=;
        b=Ew03tIch6OGImCQXmNqAeZKAliwB+7oOSWDXd8ScQ7F1aoklvI/UL3HgIY5sUNSGaK
         vgmGTIQjR4JLfQAUlgIZvC4H9FIbK2Sss4jAQ7F+qA6xDKYplRwOEQ2TzpN09HzQJJV9
         wOyGav2jOiW7ULni6px9JJ1RjPcr8wAFbBr2azlUkl+aGrRpOtwoqEo8um8g0j6aCSQA
         ilLlWdOxcXBQRXnaaYutoady6TxoaK7awbL/Uy33L9dWzvZIsQlSCG1wUpxJ6xEWrOMj
         51XtTxfJ/LTswsAArxaj/PaZIlINgJSOAdaFmXrTM+CemLwr3jUzOxVmRtD5i79kH5dV
         hBrg==
X-Gm-Message-State: AOAM532PRvEs2RnjIifLRkZ/xNr4V+lL9fP3W0V/DNuRrFpp4id/0I3S
        d99LlrQ/BhYjPBT9MHSd4Pq9LN0HkQ4TcQqXJ1GZZGuRqOZh/oIY/bUmi5ZCsYRUppbDZAh/gx5
        4OzHjqoevMbDy0mSm
X-Received: by 2002:a05:6000:188b:: with SMTP id a11mr10478231wri.274.1624627991118;
        Fri, 25 Jun 2021 06:33:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyE2dcs4be8AiIZkOa1cCLwPtVzHUUl+nen+50HMmf+fIx4jzwt3pwZiKkzjfqy91lKaRK8lQ==
X-Received: by 2002:a05:6000:188b:: with SMTP id a11mr10478218wri.274.1624627990948;
        Fri, 25 Jun 2021 06:33:10 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id r10sm5996504wrq.17.2021.06.25.06.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 06:33:10 -0700 (PDT)
Date:   Fri, 25 Jun 2021 15:33:08 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 3/6] sit: allow redirecting ip6ip, ipip and mplsip
 packets to eth devices
Message-ID: <741ee403015d9241d8005978fc71309930d921ce.1624572003.git.gnault@redhat.com>
References: <cover.1624572003.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1624572003.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even though sit transports L3 data (IPv6, IPv4 or MPLS) packets, it
needs to reset the mac_header pointer, so that other parts of the stack
don't mistakenly access the outer header after the packet has been
decapsulated. There are two rx handlers to modify: ipip6_rcv() for the
ip6ip mode and sit_tunnel_rcv() which is used to re-implement the ipip
and mplsip modes of ipip.ko.

This allows to push an Ethernet header to sit packets and redirect
them to an Ethernet device:

  $ tc filter add dev sit0 ingress matchall          \
      action vlan push_eth dst_mac 00:00:5e:00:53:01 \
                           src_mac 00:00:5e:00:53:00 \
      action mirred egress redirect dev eth0

Without this patch, push_eth refuses to add an ethernet header because
the skb appears to already have a MAC header.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv6/sit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index e0a39b0bb4c1..df5bea818410 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -710,6 +710,8 @@ static int ipip6_rcv(struct sk_buff *skb)
 		 * old iph is no longer valid
 		 */
 		iph = (const struct iphdr *)skb_mac_header(skb);
+		skb_reset_mac_header(skb);
+
 		err = IP_ECN_decapsulate(iph, skb);
 		if (unlikely(err)) {
 			if (log_ecn_error)
@@ -780,6 +782,8 @@ static int sit_tunnel_rcv(struct sk_buff *skb, u8 ipproto)
 			tpi = &ipip_tpi;
 		if (iptunnel_pull_header(skb, 0, tpi->proto, false))
 			goto drop;
+		skb_reset_mac_header(skb);
+
 		return ip_tunnel_rcv(tunnel, skb, tpi, NULL, log_ecn_error);
 	}
 
-- 
2.21.3

