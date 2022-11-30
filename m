Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A930063DC5F
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiK3Rrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiK3Rrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:47:36 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC6D578F8;
        Wed, 30 Nov 2022 09:47:24 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id w79so17513682pfc.2;
        Wed, 30 Nov 2022 09:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kpwlduiswno0GODc7vV+afSgYhDmAPourYDvbL9id5k=;
        b=konABwWSuQgbns2x2gFYV7aV7YXTZiNFUrzMBapHKFzorTx6vKkB1h2AO7olpBAJVW
         WzuEargfUwpfygc3VRPSNrAqnfITf9uGDAYyjeQk2oPy6dAy0tsYc2+uC2dr64U2+X6b
         Jxh/6JmfrSnKlnHWy2+9IcnIO3GFWOEcoQwU1024WMRezE8EvR9Ndd31AeA5paTbsfaM
         ZGearzpvjXMNGhgLDkNXmc2iw/HopPxH7VZ++55xYGOcW4cFVqcSfVqHm7HbH7deMDGS
         P1ZooGi5779Dja9dHzI00RKTrA3w3IsL3NI+M9qvNirSNNbUlB5DWZelF8rEfUlGePMP
         TpyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kpwlduiswno0GODc7vV+afSgYhDmAPourYDvbL9id5k=;
        b=PeHOe1qFRS7b7Q4jo+7DfGe7GkUHDVxA9jTmpd8KxXW2ZH1EKz3MSiHxgcDPhxHan2
         4zH1N0nlmILPXLEfisjQzZ/NOwWtwCn9DrRcka7KRan3g+Zl9ZI/nodiIzOBRtuE7+3P
         BQeAuQPY2YK41+yJkNSzohLW/89hnHpQ4EpgUl0KwUgzlTrcVq7z+M3M84XZs7RhMAAK
         /8jTgaber5UEkkywiVmTNG/3bODxAEGf4e3cDgPRhEOW9kUNhQ9W/65tyWmUBLwyoxN8
         OqD4oFPZqpycvRKX3RTNqv7lyOQG9gnJtxNCcH5KftCdtBd+Aminu/Cp4QjZKCOXRfyz
         l+jQ==
X-Gm-Message-State: ANoB5pn2ee/ZQGykI9V/WTB75F0GnpuHmpHsKdNduLMoT4Afncvv9iLy
        x6i6VFB+dBfaHV7Fc7VnAFLXVHTy4iYgMA==
X-Google-Smtp-Source: AA0mqf5PEYjhCpnLmS8aeWV9F8rYE+xSooQBFE++F/WfuW9IGmzoqtaNdI64P1DIkn0yJt+i5Ec4SA==
X-Received: by 2002:a05:6a00:338c:b0:56b:a319:7b52 with SMTP id cm12-20020a056a00338c00b0056ba3197b52mr43478099pfb.21.1669830443318;
        Wed, 30 Nov 2022 09:47:23 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id p3-20020aa79e83000000b00574cdb63f03sm1714505pfq.144.2022.11.30.09.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 09:47:23 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 4/7] net: devlink: add DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
Date:   Thu,  1 Dec 2022 02:46:55 +0900
Message-Id: <20221130174658.29282-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221130174658.29282-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221130174658.29282-1-mailhol.vincent@wanadoo.fr>
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
This was initially sent as a standalone patch here:

  https://lore.kernel.org/netdev/20221129031406.3849872-1-mailhol.vincent@wanadoo.fr/

Merging it to this series so that it is both added and used.
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
2.37.4

