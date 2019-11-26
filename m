Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA6E109BC4
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfKZKIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:08:51 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34853 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbfKZKIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:08:50 -0500
Received: by mail-pj1-f65.google.com with SMTP id s8so8070834pji.2;
        Tue, 26 Nov 2019 02:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TORKveKiyyu6m2oHodE9IBcjkbwEar3Vt5jDpzgDylY=;
        b=olv12Gp3grnekpbckL4cgsuKfI3uibM/xyKgxKaXAgysBCG0gD1zfwzI4bdTig2QPa
         bYj2KhBwBQCyeYdYx2+f9ANR6ntDY1QlasYD6qxyDMTFGZj2uvm7ko8kE58GZXl1Gx83
         yxZQsAPqwNrJ0vcBYS7ybC0BFUlHVtzRy09jDp4McRhur9+hRM3WTEt+lbKHstbWmP9z
         At4RGyUZXvbnGh/bg5mBCIRT9jJzXZ/XyUpQTxrGKC9T6fcorgnyhMn8Hm9GLjMjBr2J
         pd/ik9nqYGr+vwPtpw0IYIaT05AfrD53fQBnlXT6YI9axZ6zErZc8n6ZW5g2ZslzHp5l
         2UEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TORKveKiyyu6m2oHodE9IBcjkbwEar3Vt5jDpzgDylY=;
        b=kURwev+ls/Jl6vD5eylZT2zdr/K0tnG0/15KNy/uaeiBX8J2BEDF8L5ybWo7T/cgDk
         8zEDWZFsbkpOR1DFgVVcPcb0O3ccCShYgCo57NeQCWqndp+sUbAsu/Qq8zdX/CmpbRWl
         7V3lDYlC0ugdDVZFRUZ2MPYPk6XNryrE7qdOzDoa9tAy2wTciZaapTGvO8bwNENis1vZ
         hn+5Th79MIoaVH7giT6asMI1mO8dZp/D3+KQgEDwXyeQggwOH1zYjOcc6V15VB1q2de0
         Ygrm1NA0P1kdZk0Lon4aPCfJ//i2kAdfmso8FA96FAWAHzPE8Y7QluYCfu7oawzmT4sf
         TeTw==
X-Gm-Message-State: APjAAAViS04I2IeK7zoccrYq9N72p/18Qtqiiz9yynvxUMYpqmBdqYi0
        YcstfjJyOwiV1LJnkwI/a10=
X-Google-Smtp-Source: APXvYqy7uBDP8l0aXZ/j5b2P/uoXgigesp5vSEQ3UrSFY/YqyNb+UCqonnG8Y2jEb1rpt6g0c9YHbg==
X-Received: by 2002:a17:90a:c789:: with SMTP id gn9mr5574668pjb.99.1574762929845;
        Tue, 26 Nov 2019 02:08:49 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:08:49 -0800 (PST)
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
Subject: [RFC net-next 02/18] net: core: rename netif_receive_generic_xdp() to do_generic_xdp_core()
Date:   Tue, 26 Nov 2019 19:07:28 +0900
Message-Id: <20191126100744.5083-3-prashantbhole.linux@gmail.com>
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

In skb generic path, we need a way to run XDP program on skb but
to have customized handling of XDP actions. netif_receive_generic_xdp
will be more helpful in such cases than do_xdp_generic.

This patch prepares netif_receive_generic_xdp() to be used as general
purpose function by renaming it.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c7fc902ccbdc..5ae647b9914f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4461,9 +4461,9 @@ static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
 	return rxqueue;
 }
 
-static u32 netif_receive_generic_xdp(struct sk_buff *skb,
-				     struct xdp_buff *xdp,
-				     struct bpf_prog *xdp_prog)
+static u32 do_xdp_generic_core(struct sk_buff *skb,
+			       struct xdp_buff *xdp,
+			       struct bpf_prog *xdp_prog)
 {
 	struct netdev_rx_queue *rxqueue;
 	void *orig_data, *orig_data_end;
@@ -4610,7 +4610,7 @@ int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 		u32 act;
 		int err;
 
-		act = netif_receive_generic_xdp(skb, &xdp, xdp_prog);
+		act = do_xdp_generic_core(skb, &xdp, xdp_prog);
 		if (act != XDP_PASS) {
 			switch (act) {
 			case XDP_REDIRECT:
-- 
2.20.1

