Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CC55B9B3D
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 14:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiIOMoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 08:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiIOMoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 08:44:03 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D579D66B;
        Thu, 15 Sep 2022 05:43:30 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bj12so41782708ejb.13;
        Thu, 15 Sep 2022 05:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=TDMqV8jd9ZVkraZ743M/cYSftD7zrCBSdtq16DscRdA=;
        b=NjUHjKrnVE6z0qVMx9Lmpt5IWZ/JwwGBhgQAosJvm0wb5tArmQSMFyjhGEkY5gwQ9V
         Fedi7tG37Pn9txSLtaXt8G87KTRzIZ2KxIP11yXIoIShRc2AdudYXqB3mzI0c3ofYYm5
         TKOvRj3Uf3aRJIW4j54CyUDlXDs8aY2fIqV2uTKG4ObG3RzqWsHo7t1WaR/46dIRTz6w
         fWC90UXceAfXqliI3cG0iuYXQo5OJXjoY3ODnMhm++c9HsEWLPgbF3vS/3cZ8IaIGte5
         HAuWemK3A8X6loBeaikQYQhvivDPxmFQN+lY/MLfWAO08YAE3gu6Jypr4vxiGmkZArFs
         DzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=TDMqV8jd9ZVkraZ743M/cYSftD7zrCBSdtq16DscRdA=;
        b=09J/rQOPsekp5eaSofcOwp/+cdfRc1i3NrzhNKuK5uWyUfVpQ8pG1vXI7QvhqyNNlB
         A3flEfrPCgaw8VN5RDNBg3agPgcEYy5y/R+oetQLuabceIZArSYsful94c8zSUYp62ad
         xvQLRhJpaWMMiKSBazN2yGKxIvDZl0jogP1V9+Ecepm+0EUXzmGZRJxqmrzlZv2Ds2Q9
         SjbIRR0kq8hPZdAc2GxmKbxERUgnupFFVc1p+KRv1/rIws/QG8Gyonp2QqVV9R4ACvS6
         25XDAlAw4Y48WXn2fDW1qEHNTADqYWATzSRHQmVBpQHwfG/0LBp2ZHUhKFIr0HUVGlET
         5Y0g==
X-Gm-Message-State: ACgBeo0XdyWA90cCrVkBUzKQfvTw6amRhmgjus1LtrQz4ISMFwzGlzeR
        JXrls6o7grfnHRqcXBjKNz/dbmKl3Ao=
X-Google-Smtp-Source: AA6agR7cLXugsarc+YEMBqkl2NURgIat4trFJmOpyT0sAw0/AWyet1ViOlTua4opslXfXObUnLpptA==
X-Received: by 2002:a17:907:7205:b0:770:86f1:ae6e with SMTP id dr5-20020a170907720500b0077086f1ae6emr28480322ejc.396.1663245808641;
        Thu, 15 Sep 2022 05:43:28 -0700 (PDT)
Received: from felia.fritz.box (200116b826f3da0059c93176b530e0d5.dip.versatel-1u1.de. [2001:16b8:26f3:da00:59c9:3176:b530:e0d5])
        by smtp.gmail.com with ESMTPSA id u16-20020a170906069000b007414152ec4asm9046503ejb.163.2022.09.15.05.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 05:43:28 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net: make NET_(DEV|NS)_REFCNT_TRACKER depend on NET
Date:   Thu, 15 Sep 2022 14:42:56 +0200
Message-Id: <20220915124256.32512-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It makes little sense to ask if networking namespace or net device refcount
tracking shall be enabled for debug kernel builds without network support.

This is similar to the commit eb0b39efb7d9 ("net: CONFIG_DEBUG_NET depends
on CONFIG_NET").

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 net/Kconfig.debug | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/Kconfig.debug b/net/Kconfig.debug
index e6ae11cc2fb7..5e3fffe707dd 100644
--- a/net/Kconfig.debug
+++ b/net/Kconfig.debug
@@ -2,7 +2,7 @@
 
 config NET_DEV_REFCNT_TRACKER
 	bool "Enable net device refcount tracking"
-	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
+	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT && NET
 	select REF_TRACKER
 	default n
 	help
@@ -11,7 +11,7 @@ config NET_DEV_REFCNT_TRACKER
 
 config NET_NS_REFCNT_TRACKER
 	bool "Enable networking namespace refcount tracking"
-	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
+	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT && NET
 	select REF_TRACKER
 	default n
 	help
-- 
2.17.1

