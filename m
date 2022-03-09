Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7367E4D26F8
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbiCIDlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 22:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiCIDld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 22:41:33 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553AC15D3AF
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 19:40:36 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id t19so862560plr.5
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 19:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d8iYS1V3752EcivD5gS9Doq8Vci/f5Uceo1Z4TNLkj0=;
        b=e5hn3kdhhuGTBTbvKPt6cgGtLlfmjA50QDF5+uyYTXeSo+uyG+7kBaS5tLdaP7663N
         l9sZW8ERxJI7Uq220HSZhtF+g5lhVxDLZy144x3wun+RGElAkqSP5eZBNqnL89GrTsui
         8a0uHYsyt9z7okzIrSme3fBD0wT+KmDeQDBz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d8iYS1V3752EcivD5gS9Doq8Vci/f5Uceo1Z4TNLkj0=;
        b=rQwOFFqOZxcqfIFFX7q5tFj7DnW+IbL+qjEZAgPo4oVFA3DNuNuXgKFxmc1arhiN5p
         XDZsljIGkZQgzJwIHKqhxjJtbueVDUTVzP5lGPReW5+yUF2pdG7oM3v7DOwzTOIHrM7C
         Sr2LlYc3uhRPpXae2V/y/v8oxLSIE6F1x0AMFlT5fmbb+Q57RRp3AVrfe+Zg7dzaZB4b
         x9RxVVfyUblB9YZ58PB+5N9FR/uOZCFjB4RHX0aSbi5BlrNXBXyYvauSUDNc6AIW/DsC
         OwwMD9MQ+0jxiKEZIG2Lx+JwcCu+qr+qACE4avN8KKycURXpXPKPsYtmR7jZRFl+3XYX
         3uVw==
X-Gm-Message-State: AOAM532AaVAYzyQhI84Y19q8t3MmDDqs2TdHYa90Q3rB/JeNy9H3noAW
        bOfqWNVctyUdJs31S7G0FIAl8A==
X-Google-Smtp-Source: ABdhPJy0gO6JX3dXkNWMK+gXTsY8+sUJUQhWScsUh/AqNdCKDq2pY4l8wsIkoH6//AwJeiyqNXEzJQ==
X-Received: by 2002:a17:902:d2c3:b0:151:fa59:95ab with SMTP id n3-20020a170902d2c300b00151fa5995abmr8654051plc.154.1646797235858;
        Tue, 08 Mar 2022 19:40:35 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id l10-20020a056a00140a00b004c55d0dcbd1sm578631pfu.120.2022.03.08.19.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 19:40:35 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        d.michailidis@fungible.com, rdunlap@infradead.org
Cc:     kernel test robot <lkp@intel.com>
Subject: [PATCH net-next 1/2] net/tls: Provide {__,}tls_driver_ctx() unconditionally
Date:   Tue,  8 Mar 2022 19:40:31 -0800
Message-Id: <20220309034032.405212-2-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309034032.405212-1-dmichail@fungible.com>
References: <20220309034032.405212-1-dmichail@fungible.com>
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

Having the definitions of {__,}tls_driver_ctx() under an #if
guard means code referencing them also needs to rely on the
preprocessor. The protection doesn't appear needed so make the
definitions unconditional.

Fixes: db37bc177dae ("net/funeth: add the data path")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 include/net/tls.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 526cb2c3b724..b6968a5b5538 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -626,7 +626,6 @@ tls_offload_ctx_rx(const struct tls_context *tls_ctx)
 	return (struct tls_offload_context_rx *)tls_ctx->priv_ctx_rx;
 }
 
-#if IS_ENABLED(CONFIG_TLS_DEVICE)
 static inline void *__tls_driver_ctx(struct tls_context *tls_ctx,
 				     enum tls_offload_ctx_dir direction)
 {
@@ -641,7 +640,6 @@ tls_driver_ctx(const struct sock *sk, enum tls_offload_ctx_dir direction)
 {
 	return __tls_driver_ctx(tls_get_ctx(sk), direction);
 }
-#endif
 
 #define RESYNC_REQ BIT(0)
 #define RESYNC_REQ_ASYNC BIT(1)
-- 
2.25.1

