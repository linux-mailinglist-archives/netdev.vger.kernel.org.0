Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7025867AB2E
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 08:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbjAYHtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 02:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbjAYHtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 02:49:16 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5F640BD0;
        Tue, 24 Jan 2023 23:49:14 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id f12-20020a7bc8cc000000b003daf6b2f9b9so617406wml.3;
        Tue, 24 Jan 2023 23:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s88uykPtdjaIE1LL1cMvTHnMWGpsOLKtW5AjDErmIYQ=;
        b=GXg9vUa/G4833/HQe9V59OIdzus4jtq+lK34Z48jEO++Os4bEdOQ5Cp0f13LYu2ywp
         4bgehdWfppA8TK7p02MAf71bAHJG2gJZpsGPLI3PNkHMKbOokRdiUQW+yuHMyPGdotd4
         zzi3PKnv6SeVQg1oS5IYB+YSNqKpkt62y1wvDGkCfU8BfYdImmCs5T8eKNTky9BgxLad
         46a+kO1IUUroOgNLAchbfE8dZYa1RiKQKqwOfndZsYwgUSi7hYhgJ7FClcK8nuktgrWs
         XEkH2O6ORPzUyQ5TcgSyXmTQ90HF8h3A1dl23UZ9U3fAt2n5M7wtJ6S0Krn/idNPYmQm
         NeOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s88uykPtdjaIE1LL1cMvTHnMWGpsOLKtW5AjDErmIYQ=;
        b=OdmrYIm5vz4HhlcvA/V5As6BKF2vUHi6BA8zA4STM27uLBRdW8yD1T+H5l8HXPxyB/
         k/dDZiG5xeJGti8+8mTgL4uT9SfU5sBhzcDyQ5/cO+xnOqD5EMm4FyFFMBfQYv5G8EAq
         WrztMUermIOV15TfVAt/QjviP+/dz2lSepZLh5171Le/YUHAXvtA3YGexM8rdsuD1i7+
         lCnF0DhRRes2HPxTT0FpCtZqmnHjz+Hc+eI/gwcVuixZHLe85HrWnmDgbiWSRRAQBprz
         T7bL/rQI5hyU73k6CoLqtc4qfukbLL7c6G3NRy/NHBFeoiG413hONv8S+I2pPvzK9ZMW
         6uEw==
X-Gm-Message-State: AFqh2kqdJaEcOHICxBRRKrt2HvrwHUYRRXpy/wD/2/u95BJ5F001KMBn
        u6Z1x1WmHI6bEWhPE3ynykoK2HtGknpWx9aG
X-Google-Smtp-Source: AMrXdXspaFhwq5oY32woUbOssYGHz5I4Lqg+KdU6YYYogLaMmZLfWv1Vbtl4OhqAePl45SgWL9uTTg==
X-Received: by 2002:a05:600c:304a:b0:3d9:8635:a916 with SMTP id n10-20020a05600c304a00b003d98635a916mr32126347wmh.9.1674632953196;
        Tue, 24 Jan 2023 23:49:13 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id n13-20020a05600c500d00b003db2b81660esm1032051wmr.21.2023.01.24.23.49.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Jan 2023 23:49:12 -0800 (PST)
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
Subject: [PATCH net v2 1/5] qede: execute xdp_do_flush() before napi_complete_done()
Date:   Wed, 25 Jan 2023 08:48:57 +0100
Message-Id: <20230125074901.2737-2-magnus.karlsson@gmail.com>
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

Fixes: d1b25b79e162b ("qede: add .ndo_xdp_xmit() and XDP_REDIRECT support")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 7c2af482192d..cb1746bc0e0c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1438,6 +1438,10 @@ int qede_poll(struct napi_struct *napi, int budget)
 	rx_work_done = (likely(fp->type & QEDE_FASTPATH_RX) &&
 			qede_has_rx_work(fp->rxq)) ?
 			qede_rx_int(fp, budget) : 0;
+
+	if (fp->xdp_xmit & QEDE_XDP_REDIRECT)
+		xdp_do_flush();
+
 	/* Handle case where we are called by netpoll with a budget of 0 */
 	if (rx_work_done < budget || !budget) {
 		if (!qede_poll_is_more_work(fp)) {
@@ -1457,9 +1461,6 @@ int qede_poll(struct napi_struct *napi, int budget)
 		qede_update_tx_producer(fp->xdp_tx);
 	}
 
-	if (fp->xdp_xmit & QEDE_XDP_REDIRECT)
-		xdp_do_flush_map();
-
 	return rx_work_done;
 }
 
-- 
2.34.1

