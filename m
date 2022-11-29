Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FAC63B79F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 03:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbiK2CCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 21:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbiK2CCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 21:02:06 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611CE45ED3;
        Mon, 28 Nov 2022 18:01:57 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id w129so12306398pfb.5;
        Mon, 28 Nov 2022 18:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=SEEyDFoR/rJt6W9E5UQ/hllazvv+kInvkgHiAjRYRuE=;
        b=F6TsHjRGgoT4/NKVF1+OfG9CN5wERvdQ5n37SPAlWowHPrq+AppORV6xD2I3gbBndM
         y/8JA2hq5NJRrofFbzGL6jnHDm2M3MPapAk2grjqqqFm08VCahL5pFSx1uxqga+bz/fO
         BdTUYuBJybPBhGql4b9iH53damkWd8HPCI9UuEzRv1CmkU3CRQr3mgMvjXrSHBukbIMG
         kMQlA7uRooYYTPJKaw8T4Ko+n0GtM+8XzbtRbxjxWg6K3n2H5TbW3q/y1P3nMdfiNWwW
         jR1urrn32BkMV+4kIIe6l7y81lQBtZhnSG/yzR084xptyyLMpMTUESs9NNMUjwX904dW
         djgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SEEyDFoR/rJt6W9E5UQ/hllazvv+kInvkgHiAjRYRuE=;
        b=6cD3joVX1FnM2XNOJGqJuEgPFudBGMyUOKA2lpJC0JYlLl64mJIEgIVUJlQf6zIHcL
         f0u/ww9n1XkpGwsnzcjhRnIngnceGpdVQFZnZmZ3/1+ytYPpfhu0mUSEFGJxgGRB5Pc3
         2fv1/Ds/UW4grf9rwpGLV+MIdAtPmsSmypsVIvin6FC9OefBFaqnxIPWBSlHXE/qA5vF
         kTTsv0Wi/nXYnVV2Apuuytwg/VxjsEUBK2eqZouAM6+rx/Y88LK39b70rPnOURPVvC5X
         XRCVU8ZBv0TjQpI86vajbNx/1XxvpVuF3O5ChtH/9spQBrWGcfykCqR6Jw+3esHQtHuL
         +JRw==
X-Gm-Message-State: ANoB5plRaiY9LS33I980u9k5KjkBIrU8ddpEUg0qi86Skwqzq2IeVVWe
        crHPmgpqdXk+c5GjlLTDoI8=
X-Google-Smtp-Source: AA0mqf4JcHhquyZThG35aXxIDmPsnKqkNpe8ZloTBYH7CvQ10CKCAbdTAYb6dPv4Q6RWkanW3t0zyQ==
X-Received: by 2002:a63:389:0:b0:477:7f68:bbbc with SMTP id 131-20020a630389000000b004777f68bbbcmr25979904pgd.279.1669687316944;
        Mon, 28 Nov 2022 18:01:56 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id i65-20020a626d44000000b0057458d1f939sm8602175pfc.152.2022.11.28.18.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 18:01:56 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH net-next] net: devlink: add DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
Date:   Tue, 29 Nov 2022 11:01:51 +0900
Message-Id: <20221129020151.3842613-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed in [1], abbreviating the bootloader to "bl" might not be
well understood. Instead, a bootloader technically being a firmware,
name it "fw.bootloader".

Add a new macro to devlink.h to formalize this new info attribute
name.

[1] https://lore.kernel.org/netdev/20221128142723.2f826d20@kernel.org/

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 include/net/devlink.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 074a79b8933f..2f552b90b5c6 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -621,6 +621,8 @@ enum devlink_param_generic_id {
 #define DEVLINK_INFO_VERSION_GENERIC_FW_ROCE	"fw.roce"
 /* Firmware bundle identifier */
 #define DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID	"fw.bundle_id"
+/* Bootloader */
+#define DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER	"fw.bootloader"
 
 /**
  * struct devlink_flash_update_params - Flash Update parameters
-- 
2.25.1

