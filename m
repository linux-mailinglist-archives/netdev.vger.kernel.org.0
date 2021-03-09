Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E85332EF5
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 20:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhCITZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 14:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhCITY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 14:24:56 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70731C06174A;
        Tue,  9 Mar 2021 11:24:56 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id 130so14239629qkh.11;
        Tue, 09 Mar 2021 11:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NyaWuBryBSVxlyjGEB0sbhHJoxkv3j/n+f1C5IJfUoc=;
        b=OgmQKK5Gx1EXozVc2xW8ogHzbQcTybAtNIqF3/KGjhSpzecbNeauvBuKGRinIFBl1b
         Wk9wQmap2tUIC4+0tllVLKcjTLVgwPpdM++uDzjypUA5hpBHL0uUAHzeCuZe2CDj3hFl
         8xnnrL7U0f75rcRJnOLdPxKSAPA6tNFLEiIa+SKVXfUe6XtAoREPVZaozMlVkb1KYceS
         BCNKAc1ZDpd2EQbrr+ZmRwbciwbutFT4gZo/CMQ5c/0WhRAzplx1Pvyg1AbrHJZwKrdb
         Y3lfiJtvvwsx55GeeEK87v9BxISW7uLL3ei3XcdhxbiHv5zdXKwy/pX3W7bb3uCkHa2c
         Sshw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NyaWuBryBSVxlyjGEB0sbhHJoxkv3j/n+f1C5IJfUoc=;
        b=FfkeDBKjNnfTnhRivYfDAj6rt/hIk5W7QT3OPikJ0hVStEMrtZui1DR9u/i1A8SDmZ
         alRxS1WbmW7aXKG2WymbQwhS7oVgD/JR4hCTsc8/JWXnyVcyrR73KWAjy8TrQVopk0qZ
         cZIMo/Lywxr8Y8TnnT0WWiuQrWY/mKfg9m3yFhG8pK7qVg7k0FNcR+Yo17DHDeTVfWw3
         Vf17s3qLWlBU57ZQbhvVj4sVxmUS3uXgyGruzBSv1ToOqRxGXo8pznakR0LuvpFU4DWQ
         qidguTsLohEUl7s/s8qP/ZP8vFvBNJBeY1JzFB2KfulWJiHUCpCBtlHb7UWbW1FGSu3b
         GQOQ==
X-Gm-Message-State: AOAM532mkVvUiW46KSgBBmhaiJwxHr5bZ6sessYUQWYprP6zUZKRPzM+
        IXLT+EZCDhQFsIGo1hxBjhE=
X-Google-Smtp-Source: ABdhPJykpf18TQM0AcKNVz3s4ShZgiHKvlbMxVe56ixJN+Hu9e/RCNO3FrpvF5vZMfyVJkkrIiEmsQ==
X-Received: by 2002:a05:620a:214a:: with SMTP id m10mr28244272qkm.372.1615317895675;
        Tue, 09 Mar 2021 11:24:55 -0800 (PST)
Received: from manjaro.fibertel.com.ar ([186.138.5.158])
        by smtp.gmail.com with ESMTPSA id 90sm10599885qtc.86.2021.03.09.11.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 11:24:54 -0800 (PST)
From:   Lautaro Lecumberry <lautarolecumberry@gmail.com>
Cc:     lautarolecumberry@gmail.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: virtio_net: use min_t() instead of min()
Date:   Tue,  9 Mar 2021 16:24:15 -0300
Message-Id: <20210309192415.12386-1-lautarolecumberry@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the following checkpatch warning:

WARNING: min() should probably be min_t(unsigned int, budget, virtqueue_get_vring_size(rq->vq))
1357: FILE: virtio_net.c:1357:
+	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {

Signed-off-by: Lautaro Lecumberry <lautarolecumberry@gmail.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 82e520d2cb12..6b65f24c0130 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1354,7 +1354,7 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 		}
 	}
 
-	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
+	if (rq->vq->num_free > min_t(unsigned int, budget, virtqueue_get_vring_size(rq->vq)) / 2) {
 		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
 			schedule_delayed_work(&vi->refill, 0);
 	}
-- 
2.30.0

