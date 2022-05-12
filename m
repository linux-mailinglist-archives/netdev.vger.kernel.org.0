Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6301E5245BD
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 08:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350438AbiELG1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 02:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350362AbiELG1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 02:27:00 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7EB5C67B;
        Wed, 11 May 2022 23:26:59 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id fv2so4248764pjb.4;
        Wed, 11 May 2022 23:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AQyVf61Zw24XGBWdK94LwS39cWxpJFLHyqDT1duRJA8=;
        b=Hd1A0pZLbviVe+sZYYD9GXxR5xCoEbyEc8QK7Pf8cwynIK8Lt+oQw282zHddPoNvF7
         QGAuQmMyUFLnvkWKCXxSa5Sz33j1KEAOIyJrG6y610/7ABo50tmfcWO4ris6x660pPjS
         Bf7kBdY3vq2CpyGOdkXvmMXKnrV4Xn/T4zh3+SO5YGW013PvhPP4uLTyEi46s4ZWXY9M
         8cN8rRKLpqm9uFouG/v5x+TMAYjeLp/AoXL3j25xG768cBt1y4RbkOPBsIgQEs0FovlX
         oq8qeQ7Nure1tLh0K5+7ASz99RZMN+UxProvMaYmlH7jH9eB/Nw+w2SvTg8immEaPlIt
         uF3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AQyVf61Zw24XGBWdK94LwS39cWxpJFLHyqDT1duRJA8=;
        b=A46VwSo8Ox4+dLTz7sGTt91a2PiZPR+ZFOa75ZEzN8fhBOlDBZlpAmgK2NGnPDAf0z
         V9N53giMUSmI1wVYLM9qnB9bklbgDrAo5z8U/RK/TDYzb0SQsSR0L4znSshWqZNS7xA9
         ZIwZ9pRVbrzZccutrd6T2TkBHqsGUMrRtlsXPxHpukQDNN37BmXeJLslUh49gy6dewAO
         PA/D49GlseZvi5p+PFTxQ7BkyZ7Hw9+OQQ6kxn6umMMLC4SU4Y4B9TERnksJ/lYzjzAf
         qlWR+UMtPYojgJvhY8iyvZE+D0zI4OVgPnSsRYBEmgkWy02dhn8qND9HJPHpBdcBbpai
         5V0g==
X-Gm-Message-State: AOAM531PfX1g+YG2x2uUWQwPAe1utUcQT7ITPW0tYVPZIldOlj8QFs0C
        /ULD3pCdOPrPWZDJSdhQiig=
X-Google-Smtp-Source: ABdhPJwU+2+Np2VZNOV3fQHUSGSxPzVkWHf2VurRw7XdVaMLK2E+CRDo7IcrBP7+0z5uxrfl6H/Bog==
X-Received: by 2002:a17:90a:730b:b0:1d9:7fc0:47c5 with SMTP id m11-20020a17090a730b00b001d97fc047c5mr9254242pjk.60.1652336818424;
        Wed, 11 May 2022 23:26:58 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id gn21-20020a17090ac79500b001d903861194sm999748pjb.30.2022.05.11.23.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 23:26:57 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, asml.silence@gmail.com, willemb@google.com,
        vasily.averin@linux.dev, ilias.apalodimas@linaro.org,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] net: skb: change the definition SKB_DR_SET()
Date:   Thu, 12 May 2022 14:26:28 +0800
Message-Id: <20220512062629.10286-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512062629.10286-1-imagedong@tencent.com>
References: <20220512062629.10286-1-imagedong@tencent.com>
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

The SKB_DR_OR() is used to set the drop reason to a value when it is
not set or specified yet. SKB_NOT_DROPPED_YET should also be considered
as not set.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5c2599e3fe7d..818347b0180e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -480,7 +480,8 @@ enum skb_drop_reason {
 	(name = SKB_DROP_REASON_##reason)
 #define SKB_DR_OR(name, reason)					\
 	do {							\
-		if (name == SKB_DROP_REASON_NOT_SPECIFIED)	\
+		if (name == SKB_DROP_REASON_NOT_SPECIFIED ||	\
+		    name == SKB_NOT_DROPPED_YET)		\
 			SKB_DR_SET(name, reason);		\
 	} while (0)
 
-- 
2.36.1

