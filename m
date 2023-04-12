Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB526DF972
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 17:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjDLPNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 11:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjDLPNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 11:13:13 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AF57EC2;
        Wed, 12 Apr 2023 08:13:09 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id cm23so3004868qtb.3;
        Wed, 12 Apr 2023 08:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681312388; x=1683904388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TRUU9F5E5yr8FveGS45SPrpQKyvNo/NCB1VPtXZgXDM=;
        b=W+dbEwEmMsoRZqA9pAub/lmBj/pmn/F9jleTu9mjRkEj2Zawak8nEXZOaxnTQZw7Qo
         3d6tJ+tayY8s7dhqQIyYH7RxjIsluDB1uEMDI1bSSgYd2UoJkReEqySKu1XyX6aSmcPx
         INCRgT22HtGPKnbowHvKf4HmI7mpWAlJAA2KD4cc5X1edgHrcOTPOeoNAFsGky3dK1To
         bKITPRCdY7QyW/6e6MyAZ1kUc8ai7GDI15g6xRlAjZoYrfkz+V+NL3fttNAtqCfhTiJY
         rrhVYOY3gLIaGO0mQRyUrBCUy1RjaEYR098QvinH4AgevnxVqMVgTejZjq5BrmF0AdgJ
         ntlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681312388; x=1683904388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TRUU9F5E5yr8FveGS45SPrpQKyvNo/NCB1VPtXZgXDM=;
        b=6TV/EEXLEUkoJqlW3NK0WgEIDhaeejC6R3248bdUFE9hsn4nY3A1ZjSmQftfTfGfVb
         EtXWqPS5NH5bq7PS9tjzx4sQAHI5fw2cIUUWQlqD0Ix4Cm0mD9Wgz54JgBU7SDA5g5X+
         V/lTfPPFickPyTBiHSqvFPCTca4UM1oZl7PpiO0saBB6pHztR+OxXzqciNXN6Akds2ub
         3ZbWHTQ2OuNsrFLdAjfpEauldKZbxoIHi6V8EQ6KiaHJKIN5024KprLu5mZszkjCChML
         wexeW/pzbEK74tXvqXreuJcHbDlw9rGxxn6qcdb97Ux/Zx9NAwk8ZSzBiyIDlhuG5V0M
         6o2Q==
X-Gm-Message-State: AAQBX9e93xGJJxl0smZfiK2JyrEb7U0Hk8QJJFOpUT1EqgbOWlugpo/s
        JEC0XC8PEPusRv05l10HZIMN3UwWQlE=
X-Google-Smtp-Source: AKy350YdpYxaJavVaEQVnqRet1CC7bbr/8oy89tk+yRw8QVGtcs2t4jbSwu2PdchCKD4dblcytcMxg==
X-Received: by 2002:a05:622a:143:b0:3e8:d461:fae3 with SMTP id v3-20020a05622a014300b003e8d461fae3mr2304639qtw.55.1681312387910;
        Wed, 12 Apr 2023 08:13:07 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bn8-20020a05620a2ac800b0073b8745fd39sm4722016qkb.110.2023.04.12.08.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 08:13:07 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH net] selftests: add the missing CONFIG_IP_SCTP in net config
Date:   Wed, 12 Apr 2023 11:13:06 -0400
Message-Id: <61dddebc4d2dd98fe7fb145e24d4b2430e42b572.1681312386.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
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

The selftest sctp_vrf needs CONFIG_IP_SCTP set in config
when building the kernel, so add it.

Fixes: a61bd7b9fef3 ("selftests: add a selftest for sctp vrf")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 tools/testing/selftests/net/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index cc9fd55ab869..2529226ce87c 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -48,3 +48,4 @@ CONFIG_BAREUDP=m
 CONFIG_IPV6_IOAM6_LWTUNNEL=y
 CONFIG_CRYPTO_SM4_GENERIC=y
 CONFIG_AMT=m
+CONFIG_IP_SCTP=m
-- 
2.39.1

