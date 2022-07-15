Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332E5576608
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiGORaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiGORaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:30:13 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35635B075
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 10:30:12 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id h17so7696469wrx.0
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 10:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EAcx1njQwBghPgOSLJ20hXn1wwyIMm8g8klbF3NQvA4=;
        b=niGhtTjG+YF4Z4gFD+l2ajQOXAg0BQLn7ZaJ4yfmqSLFRXQg1OU7/uARkQsMVORFnf
         J/5t9mZHzl4pDaode4/AL827oDmBiIESBdYMlkFr2xX0qqBU09P2SW5CxKDJQjYCtZLG
         nztFNc1a2DDHleJfQwgrkOSZ8/j1jNtAQsQ5HMh8RSfAFCHsxZjrUlRcF72D0ky7fobj
         nyD2gHkEbVRPf/xeyTUkNJCiFBn7u+gW2yWf9SIM7jQSoi6f4CyBnM1WU4YwL4sHOUpA
         JMAGxauA/KeOH5J2IjqAAgcsoJ4tWJXiUApWxaxnS1w77RYxRE3tiJ+13xVjKfZ7i6WO
         vMGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EAcx1njQwBghPgOSLJ20hXn1wwyIMm8g8klbF3NQvA4=;
        b=8GtqWuMg2yP9xJ+5jJfI6zH/cMlkNnxyvRSebnyGJrqnFOTqB7ESkXZiGdLfVGEk77
         7c/wwQ482MdAznrYtSxjCNRnlb5HO8XIw46QlaJvlHVxk49rE5HkHYtSZFO6TykdO1td
         qNB/9Q2pFgcnZe/EwQhSLfh3Fak/Hb8jTpZdlCEyXnWoLepSmtc9JjE5lSz0GM0GtvZV
         XTuxJ/hXmisPF2wt8VrwjuuQiHa/qIiIrHCGFFicbrpb0NWXQAoukFqueAvO7qnA3hPV
         O/BzYZ+JYigXt2B38Hl/GYltk4DkUJOPLTd4IvmyduYBck3kxhVIHjZECMGs+rZPzRLv
         vuhg==
X-Gm-Message-State: AJIora+8G1V+UM5zJuijmPJkUUD60R4alg/r+SGedoV/ujgTfWaJ6WZg
        xi2r2nMDx2XR4lqhNP0w/W53ew==
X-Google-Smtp-Source: AGRyM1vmIhMojhicKpyLdQBXLalJ67mKLbI2oesntM5L1Qsv9SY4RQ7EP93+4M6ijZZ5E+SRMeBZpA==
X-Received: by 2002:adf:e786:0:b0:21d:6ec1:ee5c with SMTP id n6-20020adfe786000000b0021d6ec1ee5cmr13233245wrm.285.1657906211410;
        Fri, 15 Jul 2022 10:30:11 -0700 (PDT)
Received: from rainbowdash.office.codethink.co.uk ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id m65-20020a1ca344000000b0039c5a765388sm5930842wme.28.2022.07.15.10.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 10:30:10 -0700 (PDT)
From:   Ben Dooks <ben.dooks@sifive.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ben Dooks <ben.dooks@sifive.com>
Subject: [PATCH v2] net: macb: fixup sparse warnings on __be16 ports
Date:   Fri, 15 Jul 2022 18:30:09 +0100
Message-Id: <20220715173009.526126-1-ben.dooks@sifive.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port fields in the ethool flow structures are defined
to be __be16 types, so sparse is showing issues where these
are being passed to htons(). Fix these warnings by passing
them to be16_to_cpu() instead.

These are being used in netdev_dbg() so should only effect
anyone doing debug.

Fixes the following sparse warnings:

drivers/net/ethernet/cadence/macb_main.c:3366:9: warning: cast from restricted __be16
drivers/net/ethernet/cadence/macb_main.c:3366:9: warning: cast from restricted __be16
drivers/net/ethernet/cadence/macb_main.c:3366:9: warning: cast from restricted __be16
drivers/net/ethernet/cadence/macb_main.c:3419:25: warning: cast from restricted __be16
drivers/net/ethernet/cadence/macb_main.c:3419:25: warning: cast from restricted __be16
drivers/net/ethernet/cadence/macb_main.c:3419:25: warning: cast from restricted __be16
drivers/net/ethernet/cadence/macb_main.c:3419:25: warning: cast from restricted __be16

Signed-off-by: Ben Dooks <ben.dooks@sifive.com>

--
Note, given the IP is also being passed ot htons() should
this either be changed to be32_to_cpu() or better passed
as a pointre and the %pI4 be used to print it.
---
 drivers/net/ethernet/cadence/macb_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d89098f4ede8..ea5cbfe9ac88 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3482,7 +3482,8 @@ static int gem_add_flow_filter(struct net_device *netdev,
 			fs->flow_type, (int)fs->ring_cookie, fs->location,
 			htonl(fs->h_u.tcp_ip4_spec.ip4src),
 			htonl(fs->h_u.tcp_ip4_spec.ip4dst),
-			htons(fs->h_u.tcp_ip4_spec.psrc), htons(fs->h_u.tcp_ip4_spec.pdst));
+			be16_to_cpu(fs->h_u.tcp_ip4_spec.psrc),
+			be16_to_cpu(fs->h_u.tcp_ip4_spec.pdst));
 
 	spin_lock_irqsave(&bp->rx_fs_lock, flags);
 
@@ -3535,8 +3536,8 @@ static int gem_del_flow_filter(struct net_device *netdev,
 					fs->flow_type, (int)fs->ring_cookie, fs->location,
 					htonl(fs->h_u.tcp_ip4_spec.ip4src),
 					htonl(fs->h_u.tcp_ip4_spec.ip4dst),
-					htons(fs->h_u.tcp_ip4_spec.psrc),
-					htons(fs->h_u.tcp_ip4_spec.pdst));
+					be16_to_cpu(fs->h_u.tcp_ip4_spec.psrc),
+					be16_to_cpu(fs->h_u.tcp_ip4_spec.pdst));
 
 			gem_writel_n(bp, SCRT2, fs->location, 0);
 
-- 
2.35.1

