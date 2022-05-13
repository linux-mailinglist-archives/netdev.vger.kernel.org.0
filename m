Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DF95259E1
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 05:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376647AbiEMDFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 23:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358809AbiEMDFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 23:05:04 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A351228ED02;
        Thu, 12 May 2022 20:04:59 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id v11so6524248pff.6;
        Thu, 12 May 2022 20:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i20mAFU7NrHSI3GzXENtfgmQUTPKqxrlvWBJ4mCwr9c=;
        b=joiLveGVf3AJvcPBN/LqMUAK0HIU3rBu0aMekWowF8XK+DwlD4XjYdYc7vGUYAB+ba
         GvU/tgViuBZYutmEgCuF2fN6UbDtPHcGXYEHTZJdA2nccLQDTbnvSOcG7Vs6x20xa37d
         OVtL0csbLTpmzXQfiLTW1ya/Nl4jA+1dpRu73J9zYN+8FB7++Pz7L09fdXQQtFrKppo8
         oLTZops//4KpZMuyaAg7T31FxYVQ6pvtM37pHZ868ibKlT1tpA/Be1kDMFxQmT8FLYKg
         yBfC4EE4Uy4f6vduQdvlFL0F0L1cCQWpFp1es8z9bHwmGtoY22gFQWdTHNdLgKax3W1h
         wd9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i20mAFU7NrHSI3GzXENtfgmQUTPKqxrlvWBJ4mCwr9c=;
        b=jBYEYSa9ZObT1OjaSc8q3RYtJ+lL2wp93eW2gaO0NA3pmnJrpnjpCrPOflsxrI3O4g
         edzZsYDYatGVuQYKlwNfKotPa8RQkVhIXiv/7lVexq3U0plVoPqHBYTwY008D1zWwa64
         3DRMw4Cuidpz2oKW1Wwp2ff/vdJNig2w4rLJk/jCL0RJ6+8z7YBw1WrAstMBYlvXjbXq
         u5mFdo0J4xXJJKQrPyl18I1B8gO2WKCU16EY9DRf+BFwUlm4i4KSLER1WGYErNHUjwKZ
         7nAA4ffUS7hFdN/CC6nojPguLC9tpMPWR75ewtPzMcfpJ8sgL//I+6e2eai26t9GK9Oh
         AV1g==
X-Gm-Message-State: AOAM532bNAnJpu24aSGFff1kpic7r5ZPeQ42QWGC+/Fv2kE/47PjHOtR
        C3s3zxs/XB24GF8EAcK/RIE=
X-Google-Smtp-Source: ABdhPJyJnmaidAHX0E8/Nd4wSwXKJOzOqNRl2z0ABpT0KruYsD2fC7cnf8jrVtFiwuezqjXXxF41zA==
X-Received: by 2002:a63:c112:0:b0:3c6:b835:2043 with SMTP id w18-20020a63c112000000b003c6b8352043mr2209742pgf.528.1652411099200;
        Thu, 12 May 2022 20:04:59 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.26])
        by smtp.gmail.com with ESMTPSA id b7-20020a170903228700b0015e8d4eb1f8sm638693plh.66.2022.05.12.20.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 20:04:58 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, asml.silence@gmail.com, willemb@google.com,
        vasily.averin@linux.dev, ilias.apalodimas@linaro.org,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH net-next v3 2/4] net: skb: check the boundrary of drop reason in kfree_skb_reason()
Date:   Fri, 13 May 2022 11:03:37 +0800
Message-Id: <20220513030339.336580-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513030339.336580-1-imagedong@tencent.com>
References: <20220513030339.336580-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Sometimes, we may forget to reset skb drop reason to NOT_SPECIFIED after
we make it the return value of the functions with return type of enum
skb_drop_reason, such as tcp_inbound_md5_hash. Therefore, its value can
be SKB_NOT_DROPPED_YET(0), which is invalid for kfree_skb_reason().

So we check the range of drop reason in kfree_skb_reason() with
DEBUG_NET_WARN_ON_ONCE().

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v3:
- don't reset the reason and print the debug warning only (Jakub Kicinski)
---
 net/core/skbuff.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 15f7b6f99a8f..fab791b0c59e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -771,6 +771,8 @@ void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 	if (!skb_unref(skb))
 		return;
 
+	DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
+
 	trace_kfree_skb(skb, __builtin_return_address(0), reason);
 	__kfree_skb(skb);
 }
-- 
2.36.1

