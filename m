Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CBA5AB213
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 15:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbiIBNvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 09:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236685AbiIBNuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 09:50:52 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1125B3A485
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 06:25:26 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b16so2698000edd.4
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 06:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=eOCVSpcovIeMqXbz23yr4kauLull3qCCxzskid82zyw=;
        b=bGeHHd50wRim5EfNsvNAUEifH6GzrvEOQi42e5IQuP2jJdZTqLTcaBqfO4sMyQra/5
         UN3rEFPDNE/51JXK5XsmG8obiGs//ybgS/tDng8fNjCqXUpc0CaYVKDoy1ABAYPNg5bs
         P7x8EOycfePCXocE3NTuhqususSUjylB73IxofC7Tt1XWmQgPktosLzw4+V5W9VWUU9A
         2mBza70039HnudcFJG2Na/l7vvbMmyOmmG9AZfNLgBcbLNRBmyfuCACQYICxPC8+UxlB
         PfYuCcPazWgYJUy7gyGxk70WAeiQjpqtlroY46sjcwOVGUogjWiCpDaBEtdINDFl+spN
         485A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=eOCVSpcovIeMqXbz23yr4kauLull3qCCxzskid82zyw=;
        b=e6VlZYeaRpkWbi4N4tdWjs+OiscyynFAlHv1Gh32pyZtq9z8F1v9mXaKx6iBWHCBjM
         S9dT+RiNW+sGhFsvLGgOmIfkkgQ6genGLBKPpPSFi3mBI96ZwX0+Fd+ZIF32x1kIsrPT
         m9iAYEF9pugmy2BLDO0c04fX1oxcqT7HBpT6Q5dcbxjybmD8cbZpRchQJ+XYvP5nfk6u
         vrIo7tEZ0jCLJ0NHglSJJhZ5AjBXszbVAEtJI87pNPNHPNhEFZF2RUYcCERB0I9WCMC+
         oV/GKTF+0cE6OcWsqxn4C2cFZ2mGhmsZP4AM+lnvxBaBm6hpzkD2Q9iob/0roGFP25Ro
         ecAw==
X-Gm-Message-State: ACgBeo1P+mMatZwTcVB/SXC1LzDsWQriK5udY5PWmUIj9C64xyangevI
        bPeqyJ779vJmefuqXK34CVEvDY8oDmWcRvcp
X-Google-Smtp-Source: AA6agR6/rLGJQCIgnPOYrVBnQsbV79rBx0dafXPEv+eFDV5oTNCFekH2GNAuOeYJK/kP3wXvxhstag==
X-Received: by 2002:a2e:934f:0:b0:24f:ea1:6232 with SMTP id m15-20020a2e934f000000b0024f0ea16232mr11373668ljh.135.1662123043347;
        Fri, 02 Sep 2022 05:50:43 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:bdef:fb0c:46dd:15b5])
        by smtp.gmail.com with ESMTPSA id u14-20020a05651220ce00b004945e017901sm232487lfr.280.2022.09.02.05.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 05:50:42 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, Sergei Antonov <saproj@gmail.com>
Subject: [PATCH  net-next] net: moxa: fix endianness-related issues from 'sparse'
Date:   Fri,  2 Sep 2022 15:50:37 +0300
Message-Id: <20220902125037.1480268-1-saproj@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Sparse checker found two endianness-related issues:

.../moxart_ether.c:34:15: warning: incorrect type in assignment (different base types)
.../moxart_ether.c:34:15:    expected unsigned int [usertype]
.../moxart_ether.c:34:15:    got restricted __le32 [usertype]

.../moxart_ether.c:39:16: warning: cast to restricted __le32

Fix them by using __le32 type instead of u32.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 9e57d23e57bf..3da99b62797d 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -29,12 +29,12 @@
 
 #include "moxart_ether.h"
 
-static inline void moxart_desc_write(u32 data, u32 *desc)
+static inline void moxart_desc_write(u32 data, __le32 *desc)
 {
 	*desc = cpu_to_le32(data);
 }
 
-static inline u32 moxart_desc_read(u32 *desc)
+static inline u32 moxart_desc_read(__le32 *desc)
 {
 	return le32_to_cpu(*desc);
 }
-- 
2.34.1

