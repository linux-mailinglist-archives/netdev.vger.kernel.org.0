Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2490124129
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfLRIMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:12:36 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42181 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfLRIMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:12:35 -0500
Received: by mail-pl1-f193.google.com with SMTP id p9so625080plk.9
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xBcku6+1IJl7K5w7NzGCYCIhgZWhoX9SNPaId051s38=;
        b=o94El1x3JQaK/T9f/7IqNQjTKrO5EJkwo1GflC31+gkMxIxuQWGBdhMkjjVqydCHHv
         TauRSQ5aiGbRrQBI8lKJfHVoOPgfZRw8SLdQzrqgeTlA4Gc8DN7h0Ib1jtbIOQOyfEPg
         lvqqYyLi7+MPfESp9nI+kTzCA7MyOjqtFRaeCUP7nlskla2EaSfLCYYum7Jjkl0Sq1UG
         65jtNlhp16ewdGYbr13+TQ+jE4pHMpEs8I8mtjp0J5f5HSXAoJEkqHCHzerFTz+JxXHx
         5M7Rq1uVBDfOCPZm9VPx1AcglxnAVyhys6DqEnw+1lprRDs2ghqj63WsxhKTvJRZi1zF
         ZeJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xBcku6+1IJl7K5w7NzGCYCIhgZWhoX9SNPaId051s38=;
        b=cwyO1NSogFBnrKen+b/o7Gieewa4PbT48UKLpDK+vIs2hdmxKgxeUCdSr2RcikI1Me
         WaJgZToHgxS/ApyMcD6QOgHVVE1Ebz+n/RJKRwUdtQJQ5ebZBLh4GHaShcpZoLRx8H76
         SqnCVGcCqo9tJvGMCMDRE2uy7cyHRcci7H40LgcmlG6WZ1FR7zfRH7eBGk4IT4Dc4G4m
         pE89i+gunFZ9YkVH0AtQx0tqY66PR4PpBBdcgv209KUCnmJP7kjuWrLlpVgYNhvpFdMX
         m20skcFC+amyqwy57vKzgNzwlLGT3Acvi524LB9ZuVfqALm4TvMODUC0HiupF3sHVngr
         PCEA==
X-Gm-Message-State: APjAAAXgt/9icwCas+QGus89TsIUHvBZgNYn271uIrn6jPX1riXmzphL
        FlJdo0Cx5V5Z79Cvzb6QSsI=
X-Google-Smtp-Source: APXvYqz+Ic8b4/OlxA6f3ZhGsFAixer9Bx/6RibqrRphyvKDNcG/KNQ0bh6wWD4dHxc/umhjU7VP7A==
X-Received: by 2002:a17:90a:d50:: with SMTP id 16mr1115282pju.117.1576656755346;
        Wed, 18 Dec 2019 00:12:35 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:12:34 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Subject: [RFC net-next 06/14] net: core: export do_xdp_generic_core()
Date:   Wed, 18 Dec 2019 17:10:42 +0900
Message-Id: <20191218081050.10170-7-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

Let's export do_xdp_generic as a general purpose function. It will
just run XDP program on skb but will not handle XDP actions.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 include/linux/netdevice.h | 2 ++
 net/core/dev.c            | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7b5256d374d2..c637754819d3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3660,6 +3660,8 @@ static inline void dev_consume_skb_any(struct sk_buff *skb)
 
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
 int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
+u32 do_xdp_generic_core(struct sk_buff *skb, struct xdp_buff *xdp,
+			struct bpf_prog *xdp_prog);
 int netif_rx(struct sk_buff *skb);
 int netif_rx_ni(struct sk_buff *skb);
 int netif_receive_skb(struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index 6bfe6fadea17..c45e8eaebf4f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4461,9 +4461,8 @@ static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
 	return rxqueue;
 }
 
-static u32 do_xdp_generic_core(struct sk_buff *skb,
-			       struct xdp_buff *xdp,
-			       struct bpf_prog *xdp_prog)
+u32 do_xdp_generic_core(struct sk_buff *skb, struct xdp_buff *xdp,
+			struct bpf_prog *xdp_prog)
 {
 	struct netdev_rx_queue *rxqueue;
 	void *orig_data, *orig_data_end;
@@ -4574,6 +4573,7 @@ static u32 do_xdp_generic_core(struct sk_buff *skb,
 
 	return act;
 }
+EXPORT_SYMBOL_GPL(do_xdp_generic_core);
 
 /* When doing generic XDP we have to bypass the qdisc layer and the
  * network taps in order to match in-driver-XDP behavior.
-- 
2.21.0

