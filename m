Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7893263B8A0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 04:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbiK2DOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 22:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbiK2DOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 22:14:22 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6718D13DC0;
        Mon, 28 Nov 2022 19:14:21 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id w37so6644168pga.5;
        Mon, 28 Nov 2022 19:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=GqtbVqN1Ji/tLgIK2eSupvgjjaDXGh123VPhBwxrz28=;
        b=iBTQuMnBjqgW1gYfAZGBAKwfeHpqlSXOuWZzqQ9TUHQMXsiTZA0yCtj0RE4jW03+qQ
         3RoQ7qAKdz7uJanHoOj2vU4hbRkySOm1X//OakLvdJ+Imk51+zahmingN0ems59RoP8d
         Q6P5W2g64U5iScdNgHpRfKeBww59PJBjPJ2uH//OtSQMZNlewy7IqozDSzv4OtQw051j
         lEYTirvPUBAKi+0aFpg4uKwQli+2q5G9eH9k971O0BHf6gXruOrT+e6Lfd+hrwQDeJYQ
         vMsG2XQkzb4f9cJ0vcrxOgh9b/iXa3phImiSJhO8hPq8DVTEyVYQtEQPk+C7PPndwBkM
         a2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GqtbVqN1Ji/tLgIK2eSupvgjjaDXGh123VPhBwxrz28=;
        b=aSBgu4nKThLaianxuz6eHcELdJ78iEb5NwonfoCMebnv0vLHhCmM9EC5E95qUNIKWl
         N0tFMVRxiboWJ3NjnFKAYjU6b6GjbNdY4aAY92N8fjiJoL3uFpQuFYUduhVnUH6vScCr
         maMaIdku6vLBNpjWX/h4NV64LoPi5x0exKH799z1Ox6hsifSuXbnIsnsG+//lMW7pj0E
         dbE03c/A0pSL76NLiO+Jw/bKNXXLI5jQewG851CZxB85EoEyB7uJqI5y/LiLEWHRH94W
         OfGA1Rwpi0WId6ld84wyvSv89QOuz+1CpbS1zLhCkkosp/UZzsoLQKnroeusovZ7TwxD
         gZCQ==
X-Gm-Message-State: ANoB5plcESPwhXOwD+5oeqROUFstJ5QKTinBna75TsFFpZJprr9pqTxo
        stg4OOqAltqp95olPerBvVQ=
X-Google-Smtp-Source: AA0mqf6EtEcFT/KpY3uHhBAbL1OFo09nPg9NGqfF4ECioi/tztfx4q4YMe2VxLgxEntLn25fWfhKqA==
X-Received: by 2002:a63:1942:0:b0:46f:7b0d:3602 with SMTP id 2-20020a631942000000b0046f7b0d3602mr30386298pgz.143.1669691660708;
        Mon, 28 Nov 2022 19:14:20 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id c31-20020a17090a492200b00218b32f6a9esm210885pjh.18.2022.11.28.19.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 19:14:20 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH net-next v2] net: devlink: add DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
Date:   Tue, 29 Nov 2022 12:14:06 +0900
Message-Id: <20221129031406.3849872-1-mailhol.vincent@wanadoo.fr>
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

Add a new macro to devlink.h to formalize this new info attribute name
and update the documentation.

[1] https://lore.kernel.org/netdev/20221128142723.2f826d20@kernel.org/

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
* Changelog *

v1 -> v2:

  * update the documentation as well.
  Link: https://lore.kernel.org/netdev/20221129020151.3842613-1-mailhol.vincent@wanadoo.fr/
---
 Documentation/networking/devlink/devlink-info.rst | 5 +++++
 include/net/devlink.h                             | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
index 7572bf6de5c1..1242b0e6826b 100644
--- a/Documentation/networking/devlink/devlink-info.rst
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -198,6 +198,11 @@ fw.bundle_id
 
 Unique identifier of the entire firmware bundle.
 
+fw.bootloader
+-------------
+
+Version of the bootloader.
+
 Future work
 ===========
 
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

