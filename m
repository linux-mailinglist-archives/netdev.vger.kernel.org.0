Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD7412A9CE
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfLZCdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:33:36 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39220 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfLZCdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:33:36 -0500
Received: by mail-pf1-f195.google.com with SMTP id q10so12544671pfs.6
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 18:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GeLqP+JN/CfwpmoyeyC4s+vSbp8+VEic0h5TcVpHVJA=;
        b=aKvru0flF+MBnG63H4cOrSD9FxftGpvNrn2g44C22QKg2UNFqMqpUFWOc1dGE1CP1D
         yPMWzIFiai4qa6UBvySDnmoljCrhBewhu6BW1z1L7C3JFUfyiGZhEERKpYXdf9XdPp9t
         77XOUto1lScRcTpLtsU1BG+GTwuEYdgruWfDKVfEFlNy/8qRXgYY9Ap5yMO1tE45eWND
         g1Hr+uNzBwcbcuGhkK6tXdZ1leOM+NecOuz6948BZPcbnttZjrFdzhSTmA7O4ADiVEga
         6ojcpX5iVipa+eAYjHhCkqjIhNt9p0xiHEa9hHJwq3Oals9lMRSoJemSP0exXuNJQNt2
         EuVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GeLqP+JN/CfwpmoyeyC4s+vSbp8+VEic0h5TcVpHVJA=;
        b=NdXtGpmNmbcHDgLe8x8z+yO3I17SOGT9CUKmywGmfGe38EUN5ZhRqru+7ukg1najD3
         qdXCfhJ1MbNGyxMV5/rBowu5Sn+mAIz89PoBmtS9AY9prRbeByP9GAVC3b348pJBIDVO
         jJyb8V+70+PkE3ro77bAEnFAHI4e27Var1TMkY2KUFJTmOzTiUr1kFLaFlmBNNDjVCXj
         eawE3p6J6yEzXBKSO5We81d/lIS+N0ndBJ28ni30hAtfMhyNTmXZ1OlzRl5UgjyGrXWJ
         nZWQ+vJ1wogorNvtwlYcQWQ7rRt7+rYEg2rRrt3Zb7uXrq8gxFcSrZT9h198K+qvJHah
         yJPw==
X-Gm-Message-State: APjAAAVHTUCzB6H9TOtkWn08wsOXonsMX2AWUyIeVZu3o7oVf+HCUiAY
        dwkPLgVM8dYqG/iT2DN2HQ0=
X-Google-Smtp-Source: APXvYqwup7hO8xNtCxYdc3LdWAHEkThNaEvepRllmJv78anCkfi/BQ/0+UT2Tw6m9wbj/5iB2cGSLQ==
X-Received: by 2002:a62:62c4:: with SMTP id w187mr18926848pfb.216.1577327615502;
        Wed, 25 Dec 2019 18:33:35 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id e6sm33865222pfh.32.2019.12.25.18.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:33:35 -0800 (PST)
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
Subject: [RFC v2 net-next 06/12] net: core: rename netif_receive_generic_xdp() to do_generic_xdp_core()
Date:   Thu, 26 Dec 2019 11:31:54 +0900
Message-Id: <20191226023200.21389-7-prashantbhole.linux@gmail.com>
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
index ae66fd791737..b05c2d639dcc 100644
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
2.21.0

