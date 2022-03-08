Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A3D4D11D0
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 09:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245607AbiCHINg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 03:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344827AbiCHINd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 03:13:33 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDA110C5
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 00:12:37 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id w4so5999823ply.13
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 00:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WTuMumC2RRy3yrvsKfYD9SViBVd0NcXUoV0g3pDb99U=;
        b=LtlM/g2aIbUKw9KXmoHTVvS/z5aFh1tsXLYfB3dz3JFF3BTlVWWdspLV1JhtcUsQQa
         stlfGJ0DSUZl9S5wIYGTT1Vc6OZjnYfmUC+O7/y9WEy68uF+EK0ZONDDi2xoMXr+TNoo
         IpB0cjtQq7xlpcFailIC/3w+xsiF6vE3rSCLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WTuMumC2RRy3yrvsKfYD9SViBVd0NcXUoV0g3pDb99U=;
        b=D0sDGiKu94AwYoYtJ7Pu/dGP9ayZSlb/feJxsv0EuuzvNjLYgrdzagZeIS9QVt+dyr
         dy/MlQMHRy7szR2a/ARj6LIoPmJSR3EZJh7GGRDmyYJdS15ugssJAnHNGNtqtE4HPqOH
         3oxUKgaw7EViEr18JyFVWwb/yujoVfKXT3bJUiS77aPhafBVgc9YAjDASJwEbgK0/rRe
         HoRF/9HLRlqqVcsFNoI6CetpUYa++TT+qza6R9kjty2PLrf7LzTFbUXqKoCmUpfEynI2
         0pP0WS5Ksqw1sED/NMjgVKOmRBqty3Gs0ogqB63wil5WR1ggRGfRHcBh971RTQIsMjur
         MY8Q==
X-Gm-Message-State: AOAM531hXwXL6PaLgCJZiOylxFNVlWJoOck6g+lNYvlrJS7QjhPNpGls
        mxn7i+ztFmpNDG/RKmq1tnI+SQ==
X-Google-Smtp-Source: ABdhPJxya0OxknMrhdfKpFGg8kny87F4OfqzPlszDrzaMJ6hWaEC8a7UKOsYDkWN7CkJSjbJe0P+Cg==
X-Received: by 2002:a17:90a:ab89:b0:1bc:71a7:f93a with SMTP id n9-20020a17090aab8900b001bc71a7f93amr3365348pjq.111.1646727156678;
        Tue, 08 Mar 2022 00:12:36 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id y19-20020a056a00181300b004f7203ad991sm3191784pfa.210.2022.03.08.00.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 00:12:36 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        d.michailidis@fungible.com
Cc:     Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net-next v2] net/fungible: CONFIG_FUN_CORE needs SBITMAP
Date:   Tue,  8 Mar 2022 00:12:34 -0800
Message-Id: <20220308081234.3517-1-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fun_core.ko uses sbitmaps and needs to select SBITMAP.
Fixes below errors:

ERROR: modpost: "__sbitmap_queue_get"
[drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_finish_wait"
[drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_queue_clear"
[drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_prepare_to_wait"
[drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_queue_init_node"
[drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
ERROR: modpost: "sbitmap_queue_wake_all"
[drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!

v2: correct "Fixes" SHA

Fixes: 749efb1e6d73 ("net/fungible: Kconfig, Makefiles, and MAINTAINERS")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 drivers/net/ethernet/fungible/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/fungible/Kconfig b/drivers/net/ethernet/fungible/Kconfig
index 2ff5138d0448..1ecedecc0f6c 100644
--- a/drivers/net/ethernet/fungible/Kconfig
+++ b/drivers/net/ethernet/fungible/Kconfig
@@ -18,6 +18,7 @@ if NET_VENDOR_FUNGIBLE
 
 config FUN_CORE
 	tristate
+	select SBITMAP
 	help
 	  A service module offering basic common services to Fungible
 	  device drivers.
-- 
2.25.1

