Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93F767AB32
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 08:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbjAYHtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 02:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbjAYHtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 02:49:19 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C302A49950;
        Tue, 24 Jan 2023 23:49:17 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id f12-20020a7bc8cc000000b003daf6b2f9b9so617487wml.3;
        Tue, 24 Jan 2023 23:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xmo4viDahGQArnmS4tCJdyEC7O2nKFQBmZiFDh4E4Aw=;
        b=bpwJVTZmhC3HFJ2BAi2Z7lUWA9H+1qcxkF4OysKlNTJVEJJIJwGI6yQHPh+9A41Faa
         HiggUDZ+A6QWCHWgjAcD3zKrlnjzE+RPMo7mcWWiiI/ToZfWKetQEDl0qRv/4Usb4rM4
         6HMlJazbq97JSnkHYlLUb9pUELEFTPSiXUEFBJO4YQ4DNt69+/6jfos4qmyvqApMyn9q
         YR4BZTICwHKhK9AE0dl3hro37jLr1U6e0dCpww46HKagsAvXjnnG4FeKwlzQ1oVI+ewh
         T4fYT8ssk7Hwzedx8HggtxSyiIsNhc0P9GDNyfdirJhgf57JGG3o8ZJaLnYhOP76W5L9
         Ckfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xmo4viDahGQArnmS4tCJdyEC7O2nKFQBmZiFDh4E4Aw=;
        b=sXK9KN9wNn3zKFXwkZAeo/tGuco5ZUi09SyiMMTxsUPj4GbImPsPRdeobXCzwmc0QN
         MT4xeaPNN6LqxcyfcI99k/f06vRSolAbj3aLSPoWgk9UMg9DpMk38kzZlTRT25ow/EYq
         ka1fuYqUgcjwEsaV1B1pycGUhK1hR+LxblCJMI+iCjzmB6hcAU+qvcFFFZv3hEjarQkW
         6k1n8zIwESWdqKisUGyooiIqjC2rjSt5u9vKrNRtx8RLaNQoqTwLl7xH4Zuz6GJB3NtZ
         +HxLxrGTfThaMZHal6nELufluWD4NHT58MvnbxDbbXNhez+WFr9hjdX0xVQKsWtDaem/
         R1iw==
X-Gm-Message-State: AFqh2kqPlTi5OSVlIVXaQmitOBXRwaFsmjRNuwG++dnpLj0vIHEMApJM
        gb9esUN5feGyEy0SEkNlUY8=
X-Google-Smtp-Source: AMrXdXuRiTTUXHzVJtIqPkU7yfp0FE6szlOO2ITdCnfKFBmI36bpubMiX1sgEnrrVyrpf6MRpG6T0w==
X-Received: by 2002:a05:600c:4928:b0:3d9:a5a2:65fa with SMTP id f40-20020a05600c492800b003d9a5a265famr30523857wmp.7.1674632957288;
        Tue, 24 Jan 2023 23:49:17 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id n13-20020a05600c500d00b003db2b81660esm1032051wmr.21.2023.01.24.23.49.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Jan 2023 23:49:16 -0800 (PST)
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
Subject: [PATCH net v2 3/5] virtio-net: execute xdp_do_flush() before napi_complete_done()
Date:   Wed, 25 Jan 2023 08:48:59 +0100
Message-Id: <20230125074901.2737-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230125074901.2737-1-magnus.karlsson@gmail.com>
References: <20230125074901.2737-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
napi context X on CPU Y will be followed by a xdp_do_flush() from the
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
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
---
 drivers/net/virtio_net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 18b3de854aeb..6df14dd5bf46 100644
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

