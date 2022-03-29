Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF7C4EB198
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 18:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239500AbiC2QOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 12:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239466AbiC2QOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 12:14:51 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634D918B276
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 09:13:08 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id dr20so36118153ejc.6
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 09:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3uD+vlYR8F1jkJv8h5hNxZi5Rycy0tLx53J7IX36Wsc=;
        b=paY0Sk1J1GIzi2NO19FHYxzhDfemYm5BBNwqgqwBAbB8UUxGCrjo8kY48w4EEU06Z3
         2wvSvsamT4opQTCetM1+oKh3PFkDbELYXgZ9N27SOdwJVZlQ7F8SxDFyv4jiE/qIQIDl
         sMwtkUxL+X2ypPNiC1gKlUEnA8RjznhlmkMxwZa9a+ouxdkEwPdVdePU/nojl+rCuz0D
         fqBMuET3nhMTCh6ktjJJ/7xnkaClGjUVoMYRdy8IkI3kN8CiEjXw/5vhnY0X6Bqbzp3B
         GWUdZ1SYW2mPfZp8ShK/wHi6xU24lH9yJMXlZzX66KIcxB4pIN6R8KdlFxCEg8oNvZiv
         vFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3uD+vlYR8F1jkJv8h5hNxZi5Rycy0tLx53J7IX36Wsc=;
        b=fMRR8w/eKXq9pP0zVnG+IPLbvl8p/mH5BKLoRP/1cspCVXAKSWlGEKPArITSBO/hd8
         oJ5nJ8dQzsXQbl24oemE4xn28kzn9hUatNGuZ4WZQmiUBTbfBWXpNxS/RM+A2sv0vCOH
         u10ffAHCfLgqk51aI2dpxGf9L/6Yb6LWD5N4JbtnPIGLtkePbJwfHN/m6L1IleQOv8L5
         DaIpF92WOm0lsayjOkV08yf5oDp6ybytNqw6geWNWLDy2Uf5YajRguEqaG3bQVWLSKEt
         sskYAdFw47lUwrE26RcanhgAXqFrkRMSLEASZE/bf3fbQA9EJK37/7nF/Daru35pujS9
         Bqmw==
X-Gm-Message-State: AOAM532cdVPH5Jv7b63hVTiAuiiBEu/xL7LLOpjc1mTwfoAJLSuWJQUK
        eKwXCMV98dHDNmYpnrbOirk=
X-Google-Smtp-Source: ABdhPJy0IgoiEYM0kU55tXEQllxE9AM3/iT0EAE5hr/u9wk/TenhVLwnd2cBrEIY5N3bvGzeDVdjAA==
X-Received: by 2002:a17:907:3f9a:b0:6e0:e2f5:aded with SMTP id hr26-20020a1709073f9a00b006e0e2f5adedmr18458818ejc.743.1648570386803;
        Tue, 29 Mar 2022 09:13:06 -0700 (PDT)
Received: from nlaptop.localdomain (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id d2-20020a1709067a0200b006df8c996b36sm7199458ejo.26.2022.03.29.09.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 09:13:06 -0700 (PDT)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     tipc-discussion@lists.sourceforge.net
Cc:     netdev@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH net] tipc: use a write lock for keepalive_intv instead of a read lock
Date:   Tue, 29 Mar 2022 18:12:14 +0200
Message-Id: <20220329161213.93576-1-dossche.niels@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, n->keepalive_intv is written to while n is locked by a read
lock instead of a write lock. This seems to me to break the atomicity
against other readers.
Change this to a write lock instead to solve the issue.

Note:
I am currently working on a static analyser to detect missing locks
using type-based static analysis as my master's thesis
in order to obtain my master's degree.
If you would like to have more details, please let me know.
This was a reported case. I manually verified the report by looking
at the code, so that I do not send wrong information or patches.
After concluding that this seems to be a true positive, I created
this patch. I have both compile-tested this patch and runtime-tested
this patch on x86_64. The effect on a running system could be a
potential race condition in exceptional cases.
This issue was found on Linux v5.17.

Fixes: f5d6c3e5a359 ("tipc: fix node keep alive interval calculation")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---
 net/tipc/node.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 6ef95ce565bd..da867ddb93f5 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -806,9 +806,9 @@ static void tipc_node_timeout(struct timer_list *t)
 	/* Initial node interval to value larger (10 seconds), then it will be
 	 * recalculated with link lowest tolerance
 	 */
-	tipc_node_read_lock(n);
+	tipc_node_write_lock(n);
 	n->keepalive_intv = 10000;
-	tipc_node_read_unlock(n);
+	tipc_node_write_unlock(n);
 	for (bearer_id = 0; remains && (bearer_id < MAX_BEARERS); bearer_id++) {
 		tipc_node_read_lock(n);
 		le = &n->links[bearer_id];
-- 
2.35.1

