Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F9E63F9A8
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiLAVOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLAVOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:14:45 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751C3BF67D;
        Thu,  1 Dec 2022 13:14:44 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bx10so4925324wrb.0;
        Thu, 01 Dec 2022 13:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0A0l8Aq8F2C+mYk2zfzbUY+wD5in9yH+VedMvZeY0AI=;
        b=ILAkVT3UmRNLaJ0mP5NtVMfr14nERbE38JQeyUC1uRF40ROV49Mt98StJeKzGZByU5
         VWojym+KOmQbGfD7mTEgmJwA7KM7Drhi71MU8BvWOXa4tJ+nHJ98kcrO9fQiPRaHd7w8
         9XpSBHudA41tsnYa+gYDhgPAclfkzqGxKIL2uqB867LXUTPiAyFYNJRPC7++2+zWp08s
         LSHXXiSHgcMt6aZ3BbFp++V1DLyQqVr8mzo8TXf8Uw4e+zxhzzsnbFEydsjS8LFzpnsz
         L7xLzK/ZFGfBCiZ7bsGsK0FZCA2EumhWX/GSZewTkGJdvuWfUMTa+ladM6KVgIPhf6ww
         86OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0A0l8Aq8F2C+mYk2zfzbUY+wD5in9yH+VedMvZeY0AI=;
        b=qwM5ZTtRFGB7OneTrUVWWYC2ndVj0zdNO6EnhwHS/wBJArulOAELPNnWevoK2kb555
         U67Mq9VTOAGZizYohgu/PjP/g9q6SPCrVH2QClD9bFG5CXXcWxgf9FCljrvEA2Zusxof
         2X1418vQAnIAWl46JC0C+QV7pYAkZPwZ+YnjAPtY1MHSUUZ7n2qkiaHa4uaLbvBjhiEE
         T0oWvhxtOfOKsFNClkInGHUY0oiMVNa1LrxYf9hp4vnLnylPrnghak6GUKOT1MvDN4+h
         o3f7ab3e+9ZcTK4WAy9BN0BKDeGjcvE3GVSZ8DBzJ3SoSG1N7/nCFFaAEgu5wu67u2vz
         szQQ==
X-Gm-Message-State: ANoB5pngtEynd5BLwq+l6MmhXig68efBMmaCTqbbuU9kERUTYKbAFuXH
        d69TP6bYLPIA6alpHbKvy+Y=
X-Google-Smtp-Source: AA0mqf7WFAt4AviKPT7oH3cSB+S+szAKN3ouVHEPeCpiGLCRejEUOn6M4UZYlTDxNXiEGRsBTEK0ag==
X-Received: by 2002:adf:e8c6:0:b0:242:d3c:3746 with SMTP id k6-20020adfe8c6000000b002420d3c3746mr17505220wrn.397.1669929282877;
        Thu, 01 Dec 2022 13:14:42 -0800 (PST)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id m35-20020a05600c3b2300b003b50428cf66sm7508708wms.33.2022.12.01.13.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 13:14:42 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com, lixiaoyan@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf-next,v3 3/4] tools: add IFLA_XFRM_COLLECT_METADATA to uapi/linux/if_link.h
Date:   Thu,  1 Dec 2022 23:14:24 +0200
Message-Id: <20221201211425.1528197-4-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221201211425.1528197-1-eyal.birger@gmail.com>
References: <20221201211425.1528197-1-eyal.birger@gmail.com>
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

