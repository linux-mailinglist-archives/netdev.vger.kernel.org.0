Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0CF6403ED
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbiLBJ7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbiLBJ7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:59:44 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E98CB223;
        Fri,  2 Dec 2022 01:59:43 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id c65-20020a1c3544000000b003cfffd00fc0so6108792wma.1;
        Fri, 02 Dec 2022 01:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0A0l8Aq8F2C+mYk2zfzbUY+wD5in9yH+VedMvZeY0AI=;
        b=E0uHhrDgV/uWR5ElHFpPI44XXuUoVC+p/r9odSqsaeDWIUjPyFOgecl8Qgbe0ddEsf
         /AGYj9NoJOOn289BT6QLM6Qve+HykidixqRd+DDX3OWVSXl5IkcxIq1k6/Z043fL7cD1
         UJxfoq0BLDuRB0KI8W7K+0rzjTq7+Y79+aRZSZFyLVHE3ZlrWJfVjL4hWzvr9lzqL1PS
         F882YuJKmtuNQ02TpDCT0S6sSoAx3/YodKu1PejzuLQ+Ik+fx2Iry9i22fbJh0VMkOe8
         TG9F460+sV8FiQlAIbhUfBgnd/eDZJGGntZ7o/z639s+RVFOf4Pamr1AoOBEHkds5nU1
         pyyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0A0l8Aq8F2C+mYk2zfzbUY+wD5in9yH+VedMvZeY0AI=;
        b=TNn8u99c91IyJrNypsp6YXIP0KibEAStYTdop254vRC+ajWbNWpcrf0lHFsph9wfxU
         N5AutG39g5OLS4Qle4Ti/Y1qZ8FVfyvBF2i5Aze00Iwe9apLC1pK59z2pBz6i6eJMZvs
         inPbFS1LEXmCAX72K1PQNverVRtUuIVcYpbhmiR8GfMywsMdLnWAEZoXK0526TYfXK0m
         6agEZkheVc4LbYMcfOSs1TX9oMQOI1+pBUgBFMwpYrwdkPyrQbp6Uoj+/wK+KUSQeaKU
         d8dDJgmx0ptbpQUsWfyKboUTo7jDY+eJw4bBQQxw+prh+/4N0CnaO+k+f/lMyo2pcxs9
         Z9Rw==
X-Gm-Message-State: ANoB5pnSs7HnX/nl3lfClPPRTBtZs87JTemlUZ60cXMqvDcicDrPE+FA
        J8cUU8HpXwidS3ZoTWZZvug=
X-Google-Smtp-Source: AA0mqf7qd1gqgafWp7zUhESGfEjuw9LN2psQcKBKMe7C2glg/X1WfGyZB3ncPxJPjzbkAvRwfawP4w==
X-Received: by 2002:a05:600c:601f:b0:3c6:f1fa:d677 with SMTP id az31-20020a05600c601f00b003c6f1fad677mr30688950wmb.59.1669975182291;
        Fri, 02 Dec 2022 01:59:42 -0800 (PST)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id s1-20020adfdb01000000b002420a2cdc96sm6517851wri.70.2022.12.02.01.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 01:59:41 -0800 (PST)
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
Subject: [PATCH bpf-next,v4 3/4] tools: add IFLA_XFRM_COLLECT_METADATA to uapi/linux/if_link.h
Date:   Fri,  2 Dec 2022 11:59:19 +0200
Message-Id: <20221202095920.1659332-4-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221202095920.1659332-1-eyal.birger@gmail.com>
References: <20221202095920.1659332-1-eyal.birger@gmail.com>
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

