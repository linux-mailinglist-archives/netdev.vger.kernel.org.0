Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EC95E800C
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiIWQke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiIWQka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:40:30 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7287820B;
        Fri, 23 Sep 2022 09:40:27 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n10so781732wrw.12;
        Fri, 23 Sep 2022 09:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=FG3Mj1csJ7FbeoY2zgdLrFVr7w1D2Zs//acRgBf+TRE=;
        b=eE5aVrZKg1v/P9UeaHNz1t9u6KrDObJzPuHWUbsNB0CGvL2ozT6QO6y8RV3J4TvApK
         gPGLloFmul/9NycdPQzEdBinJ0njxpLdx/5DMi9pkPqxHexWAitmYT7B+590/zvfROM9
         CIVg8YVhNarmc9WM95AOuXgoiDJPoZLmdOExh3cWbH26mGW6YjwixTE3hbClVdbEUOis
         9uTUExsQwAPYQ75waTv9Um9hLpemVfJuIj+0GaxnBaIvAP3G5baJmEnOoa51UmzPE0/V
         9wc+Ze+zqXKhGHGQroVMuqM6b/rlyf5FCzbF0pKQAhzaxGDoxQxA7E7iIWwRmyyPXktb
         EuHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=FG3Mj1csJ7FbeoY2zgdLrFVr7w1D2Zs//acRgBf+TRE=;
        b=abKyBZvWWlNWtB45NbW1inprVyd4dgftlqVnvLS/fFFEAewPo8c8LinU/LAIEclxNu
         GOQV1HamHjESoc2PDTCYv5B8Z5UsSrLCxJIVbgr+gVkjSPY9WOpwhp8vzQggpcpNUeUh
         gjtpFsUgwxQJKoONRg+1R9HywB+KnYeTBV4AB9P8uqDYSOp+sj7bnxQQHVe/v+cDhmS0
         /lyAunPnjvwrKI5C1RN3Bh8Oriv2Wv4/1Ibl4LJieothlKccdbsMqS33w3+cOwMLB9mG
         1ovi/27PCCaPm9Ld4h6vQuxSs9cVUcR1kXx4uW5r0+14te7RkSvY54X9DdKNSsBI31Fv
         exxA==
X-Gm-Message-State: ACrzQf3UGbEdJc6Zc3hv/vyLTEmgLDzEkCNzdSjULOuhRqU3IIPJ7WbI
        tDGFmncBITk6BC678Kp6ZnX8RFeC0Ks=
X-Google-Smtp-Source: AMsMyM7kN8lNHyV1w1d1RL8dD6evo1RUYO8Wx/UWQQUl5cn81n4HQTVjecLZI9rI0Uh/wzPOiMq83A==
X-Received: by 2002:a5d:5452:0:b0:228:d6f0:dbeb with SMTP id w18-20020a5d5452000000b00228d6f0dbebmr5883466wrv.84.1663951226140;
        Fri, 23 Sep 2022 09:40:26 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.201.74.threembb.co.uk. [188.28.201.74])
        by smtp.gmail.com with ESMTPSA id x13-20020a5d60cd000000b0022af6c93340sm7717399wrt.17.2022.09.23.09.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 09:40:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 3/4] vhost/net: use struct ubuf_info_msgzc
Date:   Fri, 23 Sep 2022 17:39:03 +0100
Message-Id: <126df081c74ecf06de383b4fdaad5080346f93dd.1663892211.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663892211.git.asml.silence@gmail.com>
References: <cover.1663892211.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ubuf_info will be changed, use ubuf_info_msgzc instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/vhost/net.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 68e4ecd1cc0e..d7a04d573988 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -118,7 +118,7 @@ struct vhost_net_virtqueue {
 	/* Number of XDP frames batched */
 	int batched_xdp;
 	/* an array of userspace buffers info */
-	struct ubuf_info *ubuf_info;
+	struct ubuf_info_msgzc *ubuf_info;
 	/* Reference counting for outstanding ubufs.
 	 * Protected by vq mutex. Writers must also take device mutex. */
 	struct vhost_net_ubuf_ref *ubufs;
@@ -382,8 +382,9 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
 }
 
 static void vhost_zerocopy_callback(struct sk_buff *skb,
-				    struct ubuf_info *ubuf, bool success)
+				    struct ubuf_info *ubuf_base, bool success)
 {
+	struct ubuf_info_msgzc *ubuf = uarg_to_msgzc(ubuf_base);
 	struct vhost_net_ubuf_ref *ubufs = ubuf->ctx;
 	struct vhost_virtqueue *vq = ubufs->vq;
 	int cnt;
@@ -871,7 +872,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 	size_t len, total_len = 0;
 	int err;
 	struct vhost_net_ubuf_ref *ubufs;
-	struct ubuf_info *ubuf;
+	struct ubuf_info_msgzc *ubuf;
 	bool zcopy_used;
 	int sent_pkts = 0;
 
@@ -907,14 +908,14 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			ubuf = nvq->ubuf_info + nvq->upend_idx;
 			vq->heads[nvq->upend_idx].id = cpu_to_vhost32(vq, head);
 			vq->heads[nvq->upend_idx].len = VHOST_DMA_IN_PROGRESS;
-			ubuf->callback = vhost_zerocopy_callback;
 			ubuf->ctx = nvq->ubufs;
 			ubuf->desc = nvq->upend_idx;
-			ubuf->flags = SKBFL_ZEROCOPY_FRAG;
-			refcount_set(&ubuf->refcnt, 1);
+			ubuf->ubuf.callback = vhost_zerocopy_callback;
+			ubuf->ubuf.flags = SKBFL_ZEROCOPY_FRAG;
+			refcount_set(&ubuf->ubuf.refcnt, 1);
 			msg.msg_control = &ctl;
 			ctl.type = TUN_MSG_UBUF;
-			ctl.ptr = ubuf;
+			ctl.ptr = &ubuf->ubuf;
 			msg.msg_controllen = sizeof(ctl);
 			ubufs = nvq->ubufs;
 			atomic_inc(&ubufs->refcount);
-- 
2.37.2

