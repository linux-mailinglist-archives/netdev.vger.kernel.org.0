Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEFD471566
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 19:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhLKSne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 13:43:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231754AbhLKSn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 13:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639248209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QjcRR7f+rn5uUWe2h52nnyd4QYkieJyXqD42mwjol5g=;
        b=Xb92E9mq54MWY1qya5jvDcJ4T+Y0UpEMYTaJJyV++LrYvVUzUEs58pObJUNQDK0cBXp17j
        CknwM0psaCg/mtxLcidJ2SIv1CND/G46ZYjxaabDdIhbIkS5X3cUD5H63lx+LZJHXlvmgK
        D+VedG/9j5JG8R2A5OMbyjz9ROePQPU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-OzJfB5lJNlq5oLMY6VjhXQ-1; Sat, 11 Dec 2021 13:43:28 -0500
X-MC-Unique: OzJfB5lJNlq5oLMY6VjhXQ-1
Received: by mail-ed1-f69.google.com with SMTP id l15-20020a056402124f00b003e57269ab87so10757248edw.6
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 10:43:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QjcRR7f+rn5uUWe2h52nnyd4QYkieJyXqD42mwjol5g=;
        b=6lALOTBVPoL38ICTnzZG0APOpL07jZVI5/5AHaX2U+wvR2t7ir5YMnL61vCq/BQdsC
         g0C6jM1TNTkz3GAIWeXtu4AaIq7H7Yn5/I8tpPkSSBRjND3vUBNyZe3HIf1OlY+8umQG
         aafz+BO+gnayjVsQrqlwCXIjGn5dO/QD7zTDayxeUlzA+1JoewHNQIsZRZzGzdKepT/2
         IZ7CaNxNFaRiEc3s+W5sfwrhOTLOqEIae7MD0/dP/ujiY+FMJm6TOQ+Xg9woMI/H/esx
         H6ztn1Nm/8p/Qal5ugpG56MEqpmlWGY7nOSPCnbwEqaUeohi6cw5yGB2hfxC3yfnNcwI
         z+Xw==
X-Gm-Message-State: AOAM5310w1405vEeHDu3BppG9Iy19d9aePbL87tN5rwxU05OQBeVak2r
        V6mo9QH4ZsAzROzwE7Ps5Zli9H7FB1tQhxgrSuE3rqi9+fd96zTa3LsHIvTkZF5REIMK8RQrY3M
        QJ8c6ysKLyd+wKJjv
X-Received: by 2002:a05:6402:4312:: with SMTP id m18mr47863918edc.273.1639248206594;
        Sat, 11 Dec 2021 10:43:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHzvcy8eKnwdYixJkMlG0TURRUjVVluIF20ruu7dNAh0k5ESkcu0mH4ODck8cui5f9PLxcpw==
X-Received: by 2002:a05:6402:4312:: with SMTP id m18mr47863891edc.273.1639248206284;
        Sat, 11 Dec 2021 10:43:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ch28sm3492673edb.72.2021.12.11.10.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 10:43:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0105D1804A2; Sat, 11 Dec 2021 19:43:24 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 5/8] xdp: add xdp_do_redirect_frame() for pre-computed xdp_frames
Date:   Sat, 11 Dec 2021 19:41:39 +0100
Message-Id: <20211211184143.142003-6-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211211184143.142003-1-toke@redhat.com>
References: <20211211184143.142003-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an xdp_do_redirect_frame() variant which supports pre-computed
xdp_frame structures. This will be used in bpf_prog_run() to avoid having
to write to the xdp_frame structure when the XDP program doesn't modify the
frame boundaries.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/filter.h |  4 +++
 net/core/filter.c      | 65 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 58 insertions(+), 11 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index b6a216eb217a..845452c83e0f 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1022,6 +1022,10 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 int xdp_do_redirect(struct net_device *dev,
 		    struct xdp_buff *xdp,
 		    struct bpf_prog *prog);
+int xdp_do_redirect_frame(struct net_device *dev,
+			  struct xdp_buff *xdp,
+			  struct xdp_frame *xdpf,
+			  struct bpf_prog *prog);
 void xdp_do_flush(void);
 
 /* The xdp_do_flush_map() helper has been renamed to drop the _map suffix, as
diff --git a/net/core/filter.c b/net/core/filter.c
index bfa4ffbced35..629188642b4e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3957,26 +3957,44 @@ u32 xdp_master_redirect(struct xdp_buff *xdp)
 }
 EXPORT_SYMBOL_GPL(xdp_master_redirect);
 
-int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
-		    struct bpf_prog *xdp_prog)
+static inline int __xdp_do_redirect_xsk(struct bpf_redirect_info *ri,
+					struct net_device *dev,
+					struct xdp_buff *xdp,
+					struct bpf_prog *xdp_prog)
 {
-	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	enum bpf_map_type map_type = ri->map_type;
 	void *fwd = ri->tgt_value;
 	u32 map_id = ri->map_id;
-	struct xdp_frame *xdpf;
-	struct bpf_map *map;
 	int err;
 
 	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
 	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
-	if (map_type == BPF_MAP_TYPE_XSKMAP) {
-		err = __xsk_map_redirect(fwd, xdp);
-		goto out;
-	}
+	err = __xsk_map_redirect(fwd, xdp);
+	if (unlikely(err))
+		goto err;
+
+	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
+	return 0;
+err:
+	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
+	return err;
+}
+
+static __always_inline int __xdp_do_redirect_frame(struct bpf_redirect_info *ri,
+						   struct net_device *dev,
+						   struct xdp_frame *xdpf,
+						   struct bpf_prog *xdp_prog)
+{
+	enum bpf_map_type map_type = ri->map_type;
+	void *fwd = ri->tgt_value;
+	u32 map_id = ri->map_id;
+	struct bpf_map *map;
+	int err;
+
+	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
+	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
-	xdpf = xdp_convert_buff_to_frame(xdp);
 	if (unlikely(!xdpf)) {
 		err = -EOVERFLOW;
 		goto err;
@@ -4013,7 +4031,6 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 		err = -EBADRQC;
 	}
 
-out:
 	if (unlikely(err))
 		goto err;
 
@@ -4023,8 +4040,34 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
 	return err;
 }
+
+int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
+		    struct bpf_prog *xdp_prog)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	enum bpf_map_type map_type = ri->map_type;
+
+	if (map_type == BPF_MAP_TYPE_XSKMAP)
+		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
+
+	return __xdp_do_redirect_frame(ri, dev, xdp_convert_buff_to_frame(xdp),
+				       xdp_prog);
+}
 EXPORT_SYMBOL_GPL(xdp_do_redirect);
 
+int xdp_do_redirect_frame(struct net_device *dev, struct xdp_buff *xdp,
+			  struct xdp_frame *xdpf, struct bpf_prog *xdp_prog)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	enum bpf_map_type map_type = ri->map_type;
+
+	if (map_type == BPF_MAP_TYPE_XSKMAP)
+		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
+
+	return __xdp_do_redirect_frame(ri, dev, xdpf, xdp_prog);
+}
+EXPORT_SYMBOL_GPL(xdp_do_redirect_frame);
+
 static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       struct sk_buff *skb,
 				       struct xdp_buff *xdp,
-- 
2.34.0

