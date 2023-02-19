Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A0769BF30
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 09:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjBSIpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 03:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBSIpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 03:45:32 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F3EF762;
        Sun, 19 Feb 2023 00:45:30 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id x27so497828lfu.4;
        Sun, 19 Feb 2023 00:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y++BPIZOSO2h3LSMZrkgSiXiIFf+8mVPfmFtUJMsjaU=;
        b=lr5guBjEVuwBaCkvz8qX/+Fk52e6WMvjvXxB6BzWCZroOXuiUMybDyH9plmjhXxDFd
         IMew2SHKOYwLahL9/PYHKslfMO9XEzGqXzI/q9AyFjSxEFqyy3+zpfq8ydS6+Xo3BtG5
         mQpFAUDGIyNyt5Ko2pjRuChOALMlhBAk21CexOEFowH0S6sFJb4qGi5Fjo3Ib9nLEkYB
         W5OSf4epESkKLs/ef0u4cHOnBS93nsNz5/4rnSvdVri/6cC0yQHQfDnKtA3KLfho1SnB
         mK9FWAttc4cfQkSyvo6FxPU/vkrvAfpfflYKsuFTqKmM9PL0K+p+1g+5DilgsncyyvZt
         5j5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y++BPIZOSO2h3LSMZrkgSiXiIFf+8mVPfmFtUJMsjaU=;
        b=HxEDUGxmwKpDmwgbqOmdzNT4fHYOR5Jg/59lDkzcZ0rKZ1eDACCRbJd9ffcAYZ4nld
         91dBiP/qxeuPp/U0lPT0l9XkYyxmUldLHlVykXjCRFTqrWQ7uLMn4fdKAu3kz89edWeJ
         0SapyGty8NTiX5B9WD+w7RhUWbf6CFGxHu0oGR3Uma00pOyE0ZmjjjJk9yv5+YsESw7F
         To/MTjGdBZSeaM1UW0JpxpZGF0wkFTu1Bx0VmMcCeyZJZgFOLmzARWrpR3kxYS7oJPIr
         2VFF/iAI45Kk8cFEJ1ABomirwjRemTw1xLlMN+iPzUKAEK1cZA6tv9c2hv6jpu3KHkKt
         StkA==
X-Gm-Message-State: AO0yUKWwaJdVkORATT7ylZJEzO4LF42HnzxgLaSRNMBdeXYRF9pqioXR
        42n9J12i794wKjQ4Sp227ww=
X-Google-Smtp-Source: AK7set/dzm0lQHA5S/b7qD21HBvhpQzUE0MXFvOQe+uy5xwcJbmOzAfwEtjcd1hGd05Ls9jxtm/HeQ==
X-Received: by 2002:a05:6512:3a90:b0:4cd:7fe0:24 with SMTP id q16-20020a0565123a9000b004cd7fe00024mr201606lfu.27.1676796328745;
        Sun, 19 Feb 2023 00:45:28 -0800 (PST)
Received: from mkor.. (89-109-49-189.dynamic.mts-nn.ru. [89.109.49.189])
        by smtp.gmail.com with ESMTPSA id y15-20020ac255af000000b004db511ccae6sm1196442lfg.294.2023.02.19.00.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 00:45:28 -0800 (PST)
From:   Maxim Korotkov <korotkov.maxim.s@gmail.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: 
Date:   Sun, 19 Feb 2023 11:44:23 +0300
Message-Id: <20230219084423.17670-1-korotkov.maxim.s@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Date: Sat, 18 Feb 2023 11:46:20 +0300
Subject: [PATCH v2] bnxt: avoid overflow in bnxt_get_nvram_directory()

The value of an arithmetic expression is subject
of possible overflow due to a failure to cast operands to a larger data
type before performing arithmetic. Used macro for multiplication instead
operator for avoiding overflow.

Found by Security Code and Linux Verification
Center (linuxtesting.org) with SVACE.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
---
changelog:
- added "fixes" tag.
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index ec573127b707..696f32dfe41f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2862,7 +2862,7 @@ static int bnxt_get_nvram_directory(struct net_device *dev, u32 len, u8 *data)
 	if (rc)
 		return rc;
 
-	buflen = dir_entries * entry_length;
+	buflen = mul_u32_u32(dir_entries, entry_length);
 	buf = hwrm_req_dma_slice(bp, req, buflen, &dma_handle);
 	if (!buf) {
 		hwrm_req_drop(bp, req);
-- 
2.37.2

