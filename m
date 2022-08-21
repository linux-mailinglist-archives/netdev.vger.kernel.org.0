Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB0059B3D5
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 15:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiHUNIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 09:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiHUNId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 09:08:33 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C165BDF0A
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 06:08:28 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id f21so8573735pjt.2
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 06:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=n40RLmCcm4YO06nHYuTL/t8Zat/kRcECAIm9wpSC+aE=;
        b=aPjx7MJt9nBG63sWVvC14p0FVF8bhBSMIYBrVz94WoG715/DTk4CBc2w6679qyIXQW
         3v2ZPWITyWnhHAVEdrmahIZ7M4AOSdXB7pRh8vh/mKvR0VomvKhkTX/sajotUXmbI97W
         9lCqe/Z6QHm/JYwtyrSB3InUjomT4V0gelQHAdxYL7w7ugdTLtwvhaotfzk2vExO9iuS
         gmC0Lclz84+pHsdivYK6JF7zVixXcEIw3van4+xlNyUUIICnGMdhPKU4DD9NuvHVUrWn
         pWY0qBytBsZveVZ5A5rcqY43QMpfUaOPA0nhwNKVYtZyeXKD7OsHlypWKS1W2KcOGjYQ
         VRyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=n40RLmCcm4YO06nHYuTL/t8Zat/kRcECAIm9wpSC+aE=;
        b=jT2dyDkblTLEQkR3K4D+NTTlULoPeEMXiVR6W6jRmBlvOZema4IA0CR/p72aQp7eat
         bnnl4TZBLLYR4T5ki/WKQze73jE17K8fPEulTk4TN+lnsw2ap2z6ANkNH+Iat16bHFcq
         SdU6NMMEQorv5p3sW2fyf+44/HNWci9Q7Ry+1a+c3Ng61F1BMl+CdxsXTsh3KtE4SXV2
         a9BUk0pHYnjuzpwQKDkfIzlKA7BPzvgo25sG5oFzELJtTuKGIgxTtFyzJWvazDIwOo7w
         ArZdyBAUmIE5HdxsjUd4CqidDWGcjDxh2HvqFXlw0JdujV2wpYG8IR9PIpevNtGE4/Ei
         pt+g==
X-Gm-Message-State: ACgBeo0e64osMEPy49odL4KKhPBhFmaq6TIrH/fxYWRt3/ovFnPJJSm4
        n/UvPkC/Ph32RNo/6YPyCuY=
X-Google-Smtp-Source: AA6agR7oaEqtWhYoZELu/6VXuJSEFNppM6G7ZFNaVVxl55TL7d39E45oCWiG/X14n9+l++pt5Atdqg==
X-Received: by 2002:a17:903:2d0:b0:172:b63b:3a1e with SMTP id s16-20020a17090302d000b00172b63b3a1emr14903634plk.76.1661087308104;
        Sun, 21 Aug 2022 06:08:28 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:6287:c054:b39c:dc2a])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902ce0600b00172951ddb12sm6436460plg.42.2022.08.21.06.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 06:08:26 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Sainath Grandhi <sainath.grandhi@intel.com>
Subject: [PATCH] net: ipvtap - add __init/__exit annotations to module init/exit funcs
Date:   Sun, 21 Aug 2022 06:08:08 -0700
Message-Id: <20220821130808.12143-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Maciej Żenczykowski <maze@google.com>

Looks to have been left out in an oversight.

Cc: Mahesh Bandewar <maheshb@google.com>
Cc: Sainath Grandhi <sainath.grandhi@intel.com>
Fixes: 235a9d89da97 ('ipvtap: IP-VLAN based tap driver')
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 drivers/net/ipvlan/ipvtap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipvlan/ipvtap.c b/drivers/net/ipvlan/ipvtap.c
index ef02f2cf5ce1..cbabca167a07 100644
--- a/drivers/net/ipvlan/ipvtap.c
+++ b/drivers/net/ipvlan/ipvtap.c
@@ -194,7 +194,7 @@ static struct notifier_block ipvtap_notifier_block __read_mostly = {
 	.notifier_call	= ipvtap_device_event,
 };
 
-static int ipvtap_init(void)
+static int __init ipvtap_init(void)
 {
 	int err;
 
@@ -228,7 +228,7 @@ static int ipvtap_init(void)
 }
 module_init(ipvtap_init);
 
-static void ipvtap_exit(void)
+static void __exit ipvtap_exit(void)
 {
 	rtnl_link_unregister(&ipvtap_link_ops);
 	unregister_netdevice_notifier(&ipvtap_notifier_block);
-- 
2.37.1.595.g718a3a8f04-goog

