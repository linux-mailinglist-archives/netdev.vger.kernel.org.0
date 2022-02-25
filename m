Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2F74C4621
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 14:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241157AbiBYNWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 08:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235630AbiBYNW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 08:22:29 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3083B2AF;
        Fri, 25 Feb 2022 05:21:57 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id j22so4450257wrb.13;
        Fri, 25 Feb 2022 05:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=xxLQvH7l9/0cKevN7857HHaPU2QEO0vmmvdQp+hIn0M=;
        b=lxpFQr/yL6LhCuD1oWiTdQMRDrZCimHRh6Lz+Og91CzD8pbg8dvp5IZms56qzhY7rj
         WqpScDjLfH0St0tAGZLaWroGxSJuyRz6ltraESaNG7LNPTKz/nPdhbjgL5nS0UyJSH8s
         qNFcXZDL/FE8n6rYYqjJs8++mgTz13MmLLg97EeED/pmUZKLKpbN8BM306go2TWFp8kq
         THUCTz8DEMctZ+WiXZ22rVb1t7yVBnF+rTBq2S6S5xAGegJWsCuXtUICNvBorcuLrVZv
         DoBOj/F/8iQnmFVebMCFaFUIU4h/TNrJkCj0ZcE4rUePWqHaftbnlxx0Jy/MU7ftzs2c
         tzUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xxLQvH7l9/0cKevN7857HHaPU2QEO0vmmvdQp+hIn0M=;
        b=llyIc4QMXKkT/dyW0B2ohs6GRmI7mv23tqKCR6nEoUwC8eDod68Ugz5MKllgonfTEx
         g3V6yrfNOa9DGVjVt5IdAhDFlp9sGOgy5zz4Zypvu7+QYXY2rrzYJ88uZRIdYYijyJFq
         paLe21Vd21Yq08KiMsZAKbeD6E6gnHyWY5IqJ+rMlLMFrHLTITQo4l50YPmEGSL+IkPj
         qyXXLygS8cfe2S3+GBZ5TedxJGQjP5LtXbfZD8f4XhWiJCyepWspnVU6HFKthyxbJ0IE
         9yHk2tvJozBCvbUNyByKp9GNoHGHu4DLqx7lqyxoE920Icdr8NU061a6r7F57Aa1k22T
         ElAg==
X-Gm-Message-State: AOAM530YTOTtqlmg2/BqkbBizGofSMrZfcIy0vyK2md2A2p8qmMN7/T5
        DglCP73AkNYh+BKN1dwp71U=
X-Google-Smtp-Source: ABdhPJxuFRFEkt9oa8I0BpqmlhLWobFn8UrM+o3nK0tidXODXRPT9ZJy8lVFXW/vqXykToLpoXfvNg==
X-Received: by 2002:a05:6000:1547:b0:1ea:7d56:83e8 with SMTP id 7-20020a056000154700b001ea7d5683e8mr6343712wry.404.1645795316353;
        Fri, 25 Feb 2022 05:21:56 -0800 (PST)
Received: from localhost.localdomain ([64.64.123.58])
        by smtp.gmail.com with ESMTPSA id o15-20020adf8b8f000000b001ea9c18b793sm2272715wra.114.2022.02.25.05.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 05:21:55 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        shawn.guo@linaro.org, gustavoars@kernel.org, len.baker@gmx.com
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] brcmfmac: check the return value of devm_kzalloc() in brcmf_of_probe()
Date:   Fri, 25 Feb 2022 05:21:38 -0800
Message-Id: <20220225132138.27722-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function devm_kzalloc() in brcmf_of_probe() can fail, so its return
value should be checked.

Fixes: 29e354ebeeec ("brcmfmac: Transform compatible string for FW loading")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 513c7e6421b2..535e8ddeab8d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -80,6 +80,8 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 		/* get rid of '/' in the compatible string to be able to find the FW */
 		len = strlen(tmp) + 1;
 		board_type = devm_kzalloc(dev, len, GFP_KERNEL);
+		if (!board_type)
+			return;
 		strscpy(board_type, tmp, len);
 		for (i = 0; i < board_type[i]; i++) {
 			if (board_type[i] == '/')
-- 
2.17.1

