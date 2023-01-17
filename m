Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC95566DA38
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbjAQJpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236472AbjAQJo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:44:59 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D704EEE;
        Tue, 17 Jan 2023 01:43:29 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id o17-20020a05600c511100b003db021ef437so2582836wms.4;
        Tue, 17 Jan 2023 01:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bKxGt5FCRmTISxMbnLeGazs3ny42gILvdkA5wErJRaM=;
        b=mpNkbJakE3Gey5eVfxt8nvZg0Ik8hOh8l6z+aFgjXAxNiwEa+5ve5u0BAR06ezDqZE
         30p/svnGsfw7VzOmP2Ddl/L/nekF818kpbQ1B2SGayTL+x344+kzGeKpIEBpWnA9SIRO
         DW4tNTxtRT8BuTbWPEBzUZPXBn5IVBbg+XK1ZZ4GLAxKCsExCxLRplmSXJlexjwtpOod
         2dhW5P1m7VMixkHlOQFjoYCNWrUF5v6qx+MBY8t4Gi4k+Mbs8ZwQdWv4OMI+07itmBHO
         quvPghWidjbNJr9vmvOPMzX4am8PMIqG57m2eaQzlDeNvMGzU/hd+c1wgeE4LgfHm8/J
         7maA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bKxGt5FCRmTISxMbnLeGazs3ny42gILvdkA5wErJRaM=;
        b=hmMgNIPtpdEi8LJmeOuD6v0YOssbMGlftk9crQm8w/MzqD21Yhku6iEXe0I2SUkH/g
         uQpcbe/HoH59vzOBY1F+LSurFyn5ZB3lQ9GYC8mzMPIr0StW/aVPZgw/XSuBwGIWRP1i
         kpYEenf03/scKrFGYZ4u/uTDY3YiaZ2QKAGVtKo9nd9nU+DSoiVR37RIOK+9+M3JBgf+
         5qVBjOmxUpRVcg/RZ1A5EV/dPIWSzpNgOc8JIa+a5E1h1v7FkKoKARx3Fs+bT+mYXqFT
         tCJiYNGWNBrabHYgeIc9KoP9j0/Btuzss4AzlrR3ARMKxPUiBytfAuP5/rV7hHyqdcX8
         bfcA==
X-Gm-Message-State: AFqh2kovXX0nQkxUnC+WZUVSN/JSw28T+447eUT99DsHulF1ZUzYwd8L
        Mmy5fTEXxAQIoyR834RiKq3dIz7TnwU1ySh9AGg=
X-Google-Smtp-Source: AMrXdXslwEI+tTAzCxrD97WDzmNF9LnUOGWHTChgzESegXcmal5f9CKzxho+dOvTkNwZJdIIzeiPHw==
X-Received: by 2002:a05:600c:3d86:b0:3d2:3761:b717 with SMTP id bi6-20020a05600c3d8600b003d23761b717mr2302945wmb.37.1673948608103;
        Tue, 17 Jan 2023 01:43:28 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id 20-20020a05600c22d400b003db0659c454sm1860342wmg.32.2023.01.17.01.43.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Jan 2023 01:43:27 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, toke@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, brouer@redhat.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH net-next] xdp: document xdp_do_flush() before napi_complete_done()
Date:   Tue, 17 Jan 2023 10:43:05 +0100
Message-Id: <20230117094305.6141-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Document in the XDP_REDIRECT manual section that drivers must call
xdp_do_flush() before napi_complete_done(). The two reasons behind
this can be found following the links below.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
---
 net/core/filter.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index ab811293ae5d..7a2b67893afd 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4128,9 +4128,13 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
  *    bpf_redirect_info to actually enqueue the frame into a map type-specific
  *    bulk queue structure.
  *
- * 3. Before exiting its NAPI poll loop, the driver will call xdp_do_flush(),
- *    which will flush all the different bulk queues, thus completing the
- *    redirect.
+ * 3. Before exiting its NAPI poll loop, the driver will call
+ *    xdp_do_flush(), which will flush all the different bulk queues,
+ *    thus completing the redirect. Note that xdp_do_flush() must be
+ *    called before napi_complete_done() in the driver, as the
+ *    XDP_REDIRECT logic relies on being inside a single NAPI instance
+ *    through to the xdp_do_flush() call for RCU protection of all
+ *    in-kernel data structures.
  */
 /*
  * Pointers to the map entries will be kept around for this whole sequence of

base-commit: 501543b4fff0ff70bde28a829eb8835081ccef2f
-- 
2.34.1

