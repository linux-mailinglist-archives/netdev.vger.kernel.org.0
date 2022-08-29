Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCEC5A4DE1
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 15:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiH2NZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 09:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiH2NZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 09:25:10 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19A48B2FE
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 06:22:28 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id z25so11136679lfr.2
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 06:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=WbqTTi+e+7Hj0rSQkCxNBFKeJxrN+GTfxMviUuiCUmE=;
        b=DOhTY9AO5jlVT0FuMBXTn9GJjQUeCh7T/GmPlAWBEOHO8XMxmAgBopy9+3DgGBt+PX
         cf12J1kHJdi9UZPQSekzn1OYs/s/JLVgM36OfJ+J38HD3NaSRtPHuW4B49HDfhxBLE8g
         azRu7lqpsV4BFUGc1kmZ/o62ArC47WdabLltXgsNRH5/4Bdiawl7lIg8jXBAEkWnx/K7
         mwXYACO/mmgKKwqUQBlR8S5xCksKobJsd0VFfSM8muw52X11FjcSbzxHaYq1yGmT8yi4
         jK/1lqaTkA8EwaUvf2AhmYQ1EzO356BdEaOnVXoIsP9GqpMuWIr5dwAVSnVfRAeSFQL1
         FPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=WbqTTi+e+7Hj0rSQkCxNBFKeJxrN+GTfxMviUuiCUmE=;
        b=ByYsvJPAPKGZ/DSV/L6stfKIvGo+17KRi0bcwDEK3vMbhxoG4OnxBYkKIFXO+pw4UC
         3Zta+VgLS/sN5193oPpkY8WrqqokiYdI/zMUC1DucQ+IXCNa9yWoI80xrfQBEYbusdpo
         WhuMXyT/gj/1qWpD+gjAA2o2SrFBR7z6S52FD9pPRa+5OpK5Is+ANatOJpVsofQ5WzjE
         TO47gMirrB3QWSZeziL/d1W82TiX9YzrkDQh8QzMWzDqe1WnmYOSrxVgdOim2X43Eu5Z
         xT4C5WPbwk8Ck9wDWfmaUXcb9kuPnS2WHqoEhTdRlV1gFqr6ESrUgh0MJx93AIdCfqgA
         mKbw==
X-Gm-Message-State: ACgBeo1Zx4xuqGqurQb3N6eZSXU2DkuUnHFnVPf0xR5Lt0pVlZUuhw20
        QxySO6HS+KMA8VByMa3eJkVMaSz4ayFpiQ==
X-Google-Smtp-Source: AA6agR7aECBbQtdl4aQdCDY5EeJBzAkzc3TV6x1krVjO8ok9a8o9Uhao7oiQUcR0P1ZRSlSAnGDMKg==
X-Received: by 2002:a05:6512:10cb:b0:48c:e0a6:221b with SMTP id k11-20020a05651210cb00b0048ce0a6221bmr7253745lfg.218.1661779325361;
        Mon, 29 Aug 2022 06:22:05 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o21-20020a05651205d500b00492b7d7ee20sm1283006lfo.87.2022.08.29.06.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:22:04 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH net-next] net/rds: Pass a pointer to virt_to_page()
Date:   Mon, 29 Aug 2022 15:20:01 +0200
Message-Id: <20220829132001.114858-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
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

Functions that work on a pointer to virtual memory such as
virt_to_pfn() and users of that function such as
virt_to_page() are supposed to pass a pointer to virtual
memory, ideally a (void *) or other pointer. However since
many architectures implement virt_to_pfn() as a macro,
this function becomes polymorphic and accepts both a
(unsigned long) and a (void *).

If we instead implement a proper virt_to_pfn(void *addr)
function the following happens (occurred on arch/arm):

net/rds/message.c:357:56: warning: passing argument 1
  of 'virt_to_pfn' makes pointer from integer without a
  cast [-Wint-conversion]

Fix this with an explicit cast.

Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: linux-rdma@vger.kernel.org
Cc: rds-devel@oss.oracle.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 net/rds/message.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index d74be4e3f3fa..44dbc612ef54 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -354,7 +354,7 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 
 	for (i = 0; i < rm->data.op_nents; ++i) {
 		sg_set_page(&rm->data.op_sg[i],
-				virt_to_page(page_addrs[i]),
+				virt_to_page((void *)page_addrs[i]),
 				PAGE_SIZE, 0);
 	}
 
-- 
2.37.2

