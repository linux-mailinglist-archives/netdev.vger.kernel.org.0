Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1206414BC
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 08:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiLCHbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 02:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiLCHbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 02:31:08 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF928AAD0;
        Fri,  2 Dec 2022 23:31:07 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id bj12so16333193ejb.13;
        Fri, 02 Dec 2022 23:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0A0l8Aq8F2C+mYk2zfzbUY+wD5in9yH+VedMvZeY0AI=;
        b=VMn+HBBH0h/zMONL8x2B95OKexBYmuuKWCrODcRlA1coHgLrk1p3PFi/KipbDWTNO3
         mTmJyDN1Oew090jsBANFgVheWLhckC9DKd2uxT7O0VMMdVpKdirrfISXq9ZXd/5CL/Io
         bDAx8/Y5vE5g1TRZ/zlqpLoCSLkMoFGrH2oTjofzasuAZugpMO0rY/SYd6whLBroS3Nw
         kVlKCjgO0pl02GCxVrmRt37b0KonghL+T0/5X6zRs5Yxykw8Geo8buvJ3LrO8bKZFbyX
         SW0l6xSZoYwaZZ44RRmY76zq8gYz0TQ10onVqMWGf3p0HVF2iwBcelYvrLI/9RHyhvKY
         iLUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0A0l8Aq8F2C+mYk2zfzbUY+wD5in9yH+VedMvZeY0AI=;
        b=otIQoqdV1Q5wWqZ9YovfXKCEmk1WHXmmlG34kG6rOIxMbshNjvnMrZEXM0CSWzOZd7
         yOjMLMVl9dh3h5cYFpD1bOvYFWC7iH5ki30ssGOl6DF0ql4gZ0R1Q3xZncUIs+teG8xe
         5IGLrmfUowhnBHQ7IK7m23dRz5+9B8tr0ByZW9vzzepcf3J3L0WCpzxbWrZEAWYqAYce
         +oNrxwzMd3EMBRqL3QJk5EeA83yTWFqufg17L7GzfBMSNlP0tdJRWi72xas2etv32vAd
         /oorRy0dAGo1v2ApyUUb5fMMbpGtEKFmm4A91109SWX+WOlFoXU90cESDIDz+lfl++CT
         bJQg==
X-Gm-Message-State: ANoB5pkQNU3aDTU1+uzKjsK/mmSpU72AXkMf7KpwP6XPL+jwEHtKfuYj
        x5bdG+hJY8i4d1PZhD0w/Mw=
X-Google-Smtp-Source: AA0mqf6ga3ArkEZqBWkrYKyfif5c0/W3lxKjbzY9rgvYY4jGLXi9Zl4LjGHchyZdtQMWOTZkWsoO6Q==
X-Received: by 2002:a17:906:8c4:b0:7ae:fbe6:e7ca with SMTP id o4-20020a17090608c400b007aefbe6e7camr63641815eje.408.1670052665450;
        Fri, 02 Dec 2022 23:31:05 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id p4-20020a056402074400b0046267f8150csm3772709edy.19.2022.12.02.23.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 23:31:05 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com, lixiaoyan@google.com, jtoppins@redhat.com,
        kuniyu@amazon.co.jp
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf-next,v5 3/4] tools: add IFLA_XFRM_COLLECT_METADATA to uapi/linux/if_link.h
Date:   Sat,  3 Dec 2022 09:30:34 +0200
Message-Id: <20221203073035.1798108-4-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221203073035.1798108-1-eyal.birger@gmail.com>
References: <20221203073035.1798108-1-eyal.birger@gmail.com>
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

Needed for XFRM metadata tests.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 tools/include/uapi/linux/if_link.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 0242f31e339c..901d98b865a1 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -673,6 +673,7 @@ enum {
 	IFLA_XFRM_UNSPEC,
 	IFLA_XFRM_LINK,
 	IFLA_XFRM_IF_ID,
+	IFLA_XFRM_COLLECT_METADATA,
 	__IFLA_XFRM_MAX
 };
 
-- 
2.34.1

