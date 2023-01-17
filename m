Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD62366D9E3
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236602AbjAQJ2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236456AbjAQJ1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:27:39 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE4C20046;
        Tue, 17 Jan 2023 01:26:03 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id c10-20020a05600c0a4a00b003db0636ff84so1048762wmq.0;
        Tue, 17 Jan 2023 01:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvSs2sfx/PVbNBqoq0YVCcet27URCbN7ELh13cYBY48=;
        b=KvsjpNOJ6J5rx5VyuOe1FdOI3OYANDJfftWLYf8M8ij6cQh3xgZUbjijU3KQ242yAu
         32EfjcrUGStzZ4zHm/heXh99z+ZM4XaFDvfYGL1sIWf4TQWLCjf5kOpWBQrxociDkgXv
         5s+JMXkGat7ipO615mAZn9mJgBboFE3xRbn/rgRjoYuOpEQjIzq+4SEPfsCSrwtkifFc
         7jdMMtxiI+xzyL3gJb8iTfbRDges2914KJD8SBpbhZHCBJcTMU3bnqlqtRk//6uc2q0f
         g01S29xTwgcx+ySAGAxn41ymQeUViSLp95ptVnVsISMJRHoAa5oSoXHyO0Sz08RXWqQ5
         NYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DvSs2sfx/PVbNBqoq0YVCcet27URCbN7ELh13cYBY48=;
        b=pnxk+fOKNcOYHrbURvFDeScv7p2TBqd7M2wEG5ABZrVeuv1lc9vyFRq4GjInlm5GdJ
         Up8gf/7za16jdyVbQqnNl42C5zQya4zzX2hdfWPW2bV/Ttlt6Q3LGyh+qU2mLXrLVicE
         0RIfCorngTBBarsS2Uxpl+aYFUQzQ7uDg7wZlAKT8oXlrGvVwV7FbAOAKDRVFR5pQiig
         ioOAquNW0h1p9aph5nD1PvXIWgAPjINku2MC4osHaMdhvKoYde7QF3mjzb1x1C6jo5bx
         Q38PDiOpmDIFqzIRfWys9ccCxyEMzq4VcOKSymNRjsceY1ZBSUmm+3EkfIfB19IT+m8t
         0iRg==
X-Gm-Message-State: AFqh2kqjM3n66C+rl8IGSelt78B6VLDc0xqK7a9hdKRsg5F6QpqnykVY
        A5u20y7fsRNdzCzC2y/FR8I=
X-Google-Smtp-Source: AMrXdXukdK76oaSHmCtQtqtznspBQIe1WjApGWOcMfh1xZAt3e/p8Q75Uq8IX42KBw5FS6j8pKkdSw==
X-Received: by 2002:a05:600c:224a:b0:3da:fa15:8658 with SMTP id a10-20020a05600c224a00b003dafa158658mr6756704wmm.32.1673947563106;
        Tue, 17 Jan 2023 01:26:03 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id u21-20020a7bc055000000b003d9aa76dc6asm48008881wmc.0.2023.01.17.01.26.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Jan 2023 01:26:02 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, toke@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, aelior@marvell.com, manishc@marvell.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        mst@redhat.com, jasowang@redhat.com, ioana.ciornei@nxp.com,
        madalin.bucur@nxp.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH net 3/5] virtio-net: execute xdp_do_flush() before napi_complete_done()
Date:   Tue, 17 Jan 2023 10:25:31 +0100
Message-Id: <20230117092533.5804-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117092533.5804-1-magnus.karlsson@gmail.com>
References: <20230117092533.5804-1-magnus.karlsson@gmail.com>
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

Make sure that xdp_do_flush() is always executed before
napi_complete_done(). This is important for two reasons. First, a
redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
napi context X on CPU Y will be follwed by a xdp_do_flush() from the
same napi context and CPU. This is not guaranteed if the
napi_complete_done() is executed before xdp_do_flush(), as it tells
the napi logic that it is fine to schedule napi context X on another
CPU. Details from a production system triggering this bug using the
veth driver can be found following the first link below.

The second reason is that the XDP_REDIRECT logic in itself relies on
being inside a single NAPI instance through to the xdp_do_flush() call
for RCU protection of all in-kernel data structures. Details can be
found in the second link below.

Fixes: 186b3c998c50 ("virtio-net: support XDP_REDIRECT")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
---
 drivers/net/virtio_net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7723b2a49d8e..bc4d79fe3c83 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1677,13 +1677,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 
 	received = virtnet_receive(rq, budget, &xdp_xmit);
 
+	if (xdp_xmit & VIRTIO_XDP_REDIR)
+		xdp_do_flush();
+
 	/* Out of packets? */
 	if (received < budget)
 		virtqueue_napi_complete(napi, rq->vq, received);
 
-	if (xdp_xmit & VIRTIO_XDP_REDIR)
-		xdp_do_flush();
-
 	if (xdp_xmit & VIRTIO_XDP_TX) {
 		sq = virtnet_xdp_get_sq(vi);
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
-- 
2.34.1

