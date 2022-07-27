Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CD7581FAD
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 07:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiG0F7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 01:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiG0F7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 01:59:17 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5993DBD8
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 22:59:16 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id z23so29438476eju.8
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 22:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fTqLYZN2GXd6VPSaDwBAOjju+ToRG+StdzLB1bw7R2c=;
        b=o2WTRIyNiQ2g9gfFHx8Id/RYHna+CqTEk64RbIk3+0U83i7+uGlEPEAZHEs9oGQNQQ
         HOzYd84l1hUHXgymojXPd2XGjhaCV5bo5I0t4hFWkSwvnr+KaBJxFPbagEKJJoXsFlHM
         asbj+b78VisW24yDzmJ/p/8WjckKX5TSPrmKVEt9BBR7GQpwxL9KztjsodZupXneWAZc
         yX5fdJXZejOsgovPrshbyb0QCDHjWxSdsiWLbDM5SkU1Y1GlNAbe9jRDNa1+I7nQ0xAQ
         rtm5Hk0UmIZ967PNB2O1D694eaEoES2LpPvAeYcudbiFFbmm9yw6MZ7ggZjHV/AAcYcO
         h1Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fTqLYZN2GXd6VPSaDwBAOjju+ToRG+StdzLB1bw7R2c=;
        b=ruwpm3E15lOr50k3RcGybKcWm5N+NL3BPyR8rx9GtSuWgLpjzdR//AGbF9fbNFhJMQ
         Yf0Xh0pQsevXxRq34A+y6VtN6EM5+Cd4TfwcSGNq84L0tGlxmwUN0o+WXPrlWQ1gSusx
         GMMkfEevD9N4OUkcoHSqd7API1BrYJLsR5M8w61f/p4ALeBxtmrtoLNoP4x7GBP8YIxb
         ZrfYlo+lvfMwEpQ6sAPzH268Fy6mWZGa0yxqCOShEHxkjDbjMfoVWFnoHyfBEdQFdCk9
         Nal6y0wAsNKC2yDkRsHO7h9NUlC79ipZ/Q7yea98otjt+FruF0apv2t6owopocFH1oVG
         e9KQ==
X-Gm-Message-State: AJIora/Y2LrYb4DzwDE9z3ikCvDMUK1oAJLjgOX0Vpiwv1gohbWZ3fQz
        lV3X1y2xKaF3mauEWfc1RXcLNXZToWRBD40ZpMg=
X-Google-Smtp-Source: AGRyM1u8xfNIQPjK+UK7LJEdIe1bTrj5T/HeZFzo8PNGMSL1naH0z6MdXyk44N3vTXVZ7lr7YpGdZg==
X-Received: by 2002:a17:907:270b:b0:72b:1418:f3dc with SMTP id w11-20020a170907270b00b0072b1418f3dcmr16758548ejk.748.1658901554246;
        Tue, 26 Jul 2022 22:59:14 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id qc3-20020a170906d8a300b0072b36cbcdaasm7134326ejb.92.2022.07.26.22.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 22:59:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: [patch net-next] net: devlink: remove redundant net_eq() check from sb_pool_get_dumpit()
Date:   Wed, 27 Jul 2022 07:59:12 +0200
Message-Id: <20220727055912.568391-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The net_eq() check is already performed inside
devlinks_xa_for_each_registered_get() helper, so remove the redundant
appearance.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 698b2d6e0ec7..ca4c9939d569 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2642,8 +2642,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 
 	mutex_lock(&devlink_mutex);
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
-		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
-		    !devlink->ops->sb_pool_get)
+		if (!devlink->ops->sb_pool_get)
 			goto retry;
 
 		devl_lock(devlink);
-- 
2.35.3

