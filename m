Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF31109BC5
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfKZKIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:08:55 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33157 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbfKZKIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:08:54 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay6so7955187plb.0;
        Tue, 26 Nov 2019 02:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2bAHX0FXOgqRwz29p5ya1CXvQIHb2CLin8kXdVB/0KE=;
        b=LIZgXrZnUx86XNNP0wmHAcrNw9/JIZ8Z/K+g4m7VRaHAmOxfSZCyPu0eA26cNr146y
         o7pf4ACxMyylsjo6uGEODbNQv8BRy46PhL70owQw/xwCKefsVPclpEamrqGo72ehYh+9
         v63wDQiT5CznqvW3e78uI6rd3/N+sk3gekTAk9Ai4rTTvwCGcYckKvWPtFjd9xcw1oOG
         8R1NnTguMJFxf9tZ09BhOA6+IrzVhQlaOh9GYKE9/yZf9zK1SwVLEIg5oFO2RFCUDefS
         13vpeM20b7IeXPytkqCO5Efyk0g/6IAoInedl5KOOFZshV6zSMntUF6MhlF1jpnMUsy2
         W+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2bAHX0FXOgqRwz29p5ya1CXvQIHb2CLin8kXdVB/0KE=;
        b=d6JOmqBcdUBiiHvSnCpFV6Bf+c2pPk1n120/c5higyNKPqXJDKPk9HuoJOB259SuVR
         AklUuIRgP95tEz7j+k9RbpBihlx+5jeDEOzuEz4arYQ+qTmYU4SjVXcLlhqc+JhIlBJG
         xtWHQVjUCXlWB3R7nS76fuMz9Z/hOnX8DM4Z5nvB5gFtsj3/hC7TJdK/IrpObrFNA4s2
         oyskWcXsqGIh9wlJpD1TeGzAjI5TFCwcY7LkV9rvkPfeqU9jwNEi29+htMaSNGDk31UU
         178ZNXC6+cCkTQN6ls+tQ76sricmUptjPtZ/s+johAyLqYQ3Tmg1fpiVjXBD/Dl0H60m
         iplw==
X-Gm-Message-State: APjAAAUIczKZ2gLSz5nMbvq/uBAcpcQVNQhf0RYP5INQeg/eOJ4P5hqr
        j/21TcwWqDzT2YUO4XD5FjE=
X-Google-Smtp-Source: APXvYqyvpP2N7hYAzxx2bd4M9VJ+Jp8Kjxs/E28fT/8KVvvGyoey0uyI2syTr1ITSFDcJg6CMebg+A==
X-Received: by 2002:a17:902:7290:: with SMTP id d16mr32584601pll.340.1574762933671;
        Tue, 26 Nov 2019 02:08:53 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:08:53 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Subject: [RFC net-next 03/18] net: core: export do_xdp_generic_core()
Date:   Tue, 26 Nov 2019 19:07:29 +0900
Message-Id: <20191126100744.5083-4-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
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
index 9e6fb8524d91..2b6317ac9795 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3648,6 +3648,8 @@ static inline void dev_consume_skb_any(struct sk_buff *skb)
 
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
 int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
+u32 do_xdp_generic_core(struct sk_buff *skb, struct xdp_buff *xdp,
+			struct bpf_prog *xdp_prog);
 int netif_rx(struct sk_buff *skb);
 int netif_rx_ni(struct sk_buff *skb);
 int netif_receive_skb(struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index 5ae647b9914f..d97c3f35e047 100644
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
2.20.1

