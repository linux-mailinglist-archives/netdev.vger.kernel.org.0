Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D5F67AB31
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 08:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbjAYHtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 02:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbjAYHtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 02:49:17 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1574943B;
        Tue, 24 Jan 2023 23:49:16 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id g10so13088162wmo.1;
        Tue, 24 Jan 2023 23:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6aa1jo3Gm6IQD13Q3su+lnnZXPzXg/tUFIWCE6r8QJU=;
        b=iSgK2/Pi9HJwCbrRBVMur6oVbbvyIHBYBsY+Itbzsm+nk2ohtDmfjbzkTQyPszr4v/
         QKHifA7gFr91fFiE0ypCeRngWzYhZzSptXo1Z8RXA27vsr2jcR7yaC96UKnO7NL7ZxfK
         68amlVNJAomthjAq+aB/CQAe14ga/9qNTqm59HQeKO1r+TM2z5zgPlTSNgmxkfdRql6/
         VM/HhXO5IEPXr0u3/a4Xnk9GuUMOAXqq5AjUf9ck3LtpxYi5s2Lw4hAjmwZi13xUcmY0
         db1yP0be3RoeomcU92fzXkhef5N6yOkMnmAEJ5mvDgexoBKrmWfR6tGtETrRII6NWW+N
         4uHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6aa1jo3Gm6IQD13Q3su+lnnZXPzXg/tUFIWCE6r8QJU=;
        b=dl97JX3456NbZychXH+yregooxNpE46P5bbi/BeT3rUbK8qIgCIbZ3JCBCXXOG52lM
         oJ92hP5jht8sxmyMsMxdMP2hz35PvUJEATwniAtHEdNZyHKI+yhw8IY/Jgmz0lvTqUOj
         XxvPvM/4znBEa+4VxOoPlNK4UGzlWxH5c9MnWxPil6UMzbNe9ymaWnhJJMzyG4IvCmD5
         x+5wBWEaXq9vGus6crek6b3Fit/+En1lnbfeWeBxlheELyI1W4Al3Owxj4GDN6KVruks
         kTAiZYvCk2TgKi0W+wsE/0PpAt7YLNw4LCACfm6N70sd6Wtc0Qlavdhe0179wkh8VN5Q
         ByHQ==
X-Gm-Message-State: AFqh2kp/Vz9NMHaAqEWRoLyu5MLWGuA8jK/tcp7rUlyP/Kme3xtVuocU
        MrFMojSPvBC9HhdWXcUvofY=
X-Google-Smtp-Source: AMrXdXt+oFJn5hWkI9BLdUFy9INfrqJo3BZQbOAvYIZSrp9vV9fGYOWE9iv9hwshiA3FYcnew163vQ==
X-Received: by 2002:a05:600c:920:b0:3da:22a6:7b6b with SMTP id m32-20020a05600c092000b003da22a67b6bmr30971526wmp.13.1674632955251;
        Tue, 24 Jan 2023 23:49:15 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id n13-20020a05600c500d00b003db2b81660esm1032051wmr.21.2023.01.24.23.49.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Jan 2023 23:49:14 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, toke@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, aelior@marvell.com, manishc@marvell.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        mst@redhat.com, jasowang@redhat.com, ioana.ciornei@nxp.com,
        madalin.bucur@nxp.com
Cc:     bpf@vger.kernel.org, Steen Hegelund <Steen.Hegelund@microchip.com>
Subject: [PATCH net v2 2/5] lan966x: execute xdp_do_flush() before napi_complete_done()
Date:   Wed, 25 Jan 2023 08:48:58 +0100
Message-Id: <20230125074901.2737-3-magnus.karlsson@gmail.com>
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

Fixes: a825b611c7c1 ("net: lan966x: Add support for XDP_REDIRECT")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Steen Hegelund <Steen.Hegelund@microchip.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 5314c064ceae..55b484b10562 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -608,12 +608,12 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 		lan966x_fdma_rx_reload(rx);
 	}
 
-	if (counter < weight && napi_complete_done(napi, counter))
-		lan_wr(0xff, lan966x, FDMA_INTR_DB_ENA);
-
 	if (redirect)
 		xdp_do_flush();
 
+	if (counter < weight && napi_complete_done(napi, counter))
+		lan_wr(0xff, lan966x, FDMA_INTR_DB_ENA);
+
 	return counter;
 }
 
-- 
2.34.1

