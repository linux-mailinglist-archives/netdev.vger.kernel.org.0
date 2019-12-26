Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE9912A9CF
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfLZCdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:33:40 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42175 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfLZCdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:33:39 -0500
Received: by mail-pf1-f193.google.com with SMTP id 4so12542368pfz.9
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 18:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=arZqXqJcRm6q4QRU9MgrGiwCPfGelfD8RjT2MbiGmYE=;
        b=pxF2oII6F03QFgcxqcFlTYgPju1UsbGgHvULARFfs6bVa9SdBH5CxKyXj/+O+ffjzf
         zZhBZ1A5aCWi6LZ/+rdPB/gDBWReHu4JvlZ7LabExqHYN+PxNVeeF2B0DJDeD0l+ugnB
         h15i4Ni21pZ+tpL0XTCKAATaE1JCWCFUxop+ghisrMZCKSorNdfu4mzb2d4xcLBjO0P1
         nwdwFSImF5224PQnArgifNxdOITQWCpta6ADOiqyFln9dWDiT+QFeE28wBpDiFjYTa35
         edDzELkdZlzRbJwwNoZJpgvYkmV1e9RRoughJOFXQXOVw2hxcYuHIXXjyrJjkDB84nmV
         nlUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=arZqXqJcRm6q4QRU9MgrGiwCPfGelfD8RjT2MbiGmYE=;
        b=SMbBkbTAZfdWnbExnrFIRW7Y6bHeKWn4NiyJODgLSBkW1hszZJ6a+EHESpQNSCcAdw
         8l7R5USDdsHOl4ZkMqDL9WUPpqcXqFFm69oUgdaiRRog2K8QDG7toInBIqLXGxlFDZHW
         fkHUjWnlW9+sL9VgME2EYTBSSfOptTZ/D+CoqNXhOcfvBucv/Uhkfr2g3uocJgqODgGj
         g/rlWahsUJ2bV0YkN+YQSBYY/Eg0jlFXmGSfsh007ZzF23gEEAqUZslm5bIjvwGdBLXs
         ZN6ayWoityd58ueCy8X6yFDTqhrb7H6exUEWwAooxqHg0Wp1y66hiDbzRPZ4OCW8D+Co
         ceLw==
X-Gm-Message-State: APjAAAXOgNnGhXvSlC/Mdqv2eWqQvMSqFFv68n5aZRjPVkqu81+fdh4S
        ZDIunlkulGaxPsp1IXi2jtQ=
X-Google-Smtp-Source: APXvYqyC/yPyibY//BU6Acv+QYrc5qxdyrkyAzC74OmgIWh6Xz33YwWL6M4owg9knQNDcDfRE9NZGA==
X-Received: by 2002:a05:6a00:5b:: with SMTP id i27mr47244956pfk.112.1577327619110;
        Wed, 25 Dec 2019 18:33:39 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id e6sm33865222pfh.32.2019.12.25.18.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:33:38 -0800 (PST)
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
Subject: [RFC v2 net-next 07/12] net: core: export do_xdp_generic_core()
Date:   Thu, 26 Dec 2019 11:31:55 +0900
Message-Id: <20191226023200.21389-8-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
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
index ac3e88d86581..51b58e47e521 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3661,6 +3661,8 @@ static inline void dev_consume_skb_any(struct sk_buff *skb)
 
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
 int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
+u32 do_xdp_generic_core(struct sk_buff *skb, struct xdp_buff *xdp,
+			struct bpf_prog *xdp_prog);
 int netif_rx(struct sk_buff *skb);
 int netif_rx_ni(struct sk_buff *skb);
 int netif_receive_skb(struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index b05c2d639dcc..db36dd288015 100644
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

