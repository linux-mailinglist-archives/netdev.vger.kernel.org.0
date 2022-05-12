Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0611524CF1
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353799AbiELMeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353797AbiELMd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:33:59 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C48D5A0B9;
        Thu, 12 May 2022 05:33:57 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q4so4710336plr.11;
        Thu, 12 May 2022 05:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lu6LLmf+mIxeAaUg73+GivA9lAoPCMxzQrmOZW/LzWA=;
        b=mw95GprIIc/lu6UHRgabNxbg/fwSnS6eFbpNvmjm3oQBhPPGC/PJsjUzzXDki9gJIt
         T9ShGoQYViA7HRexkaKEVv6HmJ2/SQ9n0cByrCBHMBw4NGFaHrLd9Vaz/dfgHLLXREQm
         OEgGQqlgnSgTc4VvJyHV+LKMfgaBOFR0lcVCo2pIdcHBmYEB/R5er+u+gjDiGE1BHzFf
         uhasXmC13rmr8HsSvgOddv6Qo7GpWzgB97OgYXfEZMhlrYYbRX6aD1ur88tEVsDOKIn0
         ige3I+lyYgOhD7CiQAxkFJLD/XG1d0SH/ABQJkMh1Z0UlgUDjvtuPp56oSYuKM7qsfz4
         I0Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lu6LLmf+mIxeAaUg73+GivA9lAoPCMxzQrmOZW/LzWA=;
        b=G8A6PV32HzqVWircY9ROlnzRmT1wH/TtMbpycTU08zak1GErh3JoqZ+qgooOOXZpYc
         adLZ6l9vKMr2kDrmq/IgmFbyUiQjCymL0b8Ar2GA6+KuA+4K7PHEJM5B7TZJ9jx1yWCk
         +ueWOZI16Q6okxFhnXf0/VE9T4oAPPy1KmZmARbyZ3KHUqMVzlE9c5xw4hDFBXLWJYqq
         ZQa5S5Rnz76RwM+lTrEqhyEMvXrcPaFIC+7wAlTnQ1NhmeQOcvDNUtb7fE2u8GMmov6H
         Qfih/b71PWrsiHgrqSgYM4cGp269+Toii4BlgmzEyF8xeqiyruGtvY34pVf4egvVYpT0
         HxMQ==
X-Gm-Message-State: AOAM531Z/52ShLMnbSzCUc7N+iTitkJvJyUE0IyjiyH27lTjE3G0NyFz
        LUhz7nh5uWLCYzPGldFkM0U=
X-Google-Smtp-Source: ABdhPJx20iJA02L5mSNF6Fhswk+orQRSVthqsiRRtSCPTOA97nBgU5+TrxbnUnyg0qK+Wmqg/uST8g==
X-Received: by 2002:a17:903:20f:b0:158:d86a:f473 with SMTP id r15-20020a170903020f00b00158d86af473mr30294897plh.92.1652358836786;
        Thu, 12 May 2022 05:33:56 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id y24-20020a63de58000000b003c14af50643sm1738130pgi.91.2022.05.12.05.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 05:33:56 -0700 (PDT)
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
Subject: [PATCH net-next v2 1/4] net: dm: check the boundary of skb drop reasons
Date:   Thu, 12 May 2022 20:33:10 +0800
Message-Id: <20220512123313.218063-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512123313.218063-1-imagedong@tencent.com>
References: <20220512123313.218063-1-imagedong@tencent.com>
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

The 'reason' will be set to 'SKB_DROP_REASON_NOT_SPECIFIED' if it not
small that SKB_DROP_REASON_MAX in net_dm_packet_trace_kfree_skb_hit(),
but it can't avoid it to be 0, which is invalid and can cause NULL
pointer in drop_reasons.

Therefore, reset it to SKB_DROP_REASON_NOT_SPECIFIED when 'reason <= 0'.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/core/drop_monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index b89e3e95bffc..41cac0e4834e 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -517,7 +517,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	if (!nskb)
 		return;
 
-	if ((unsigned int)reason >= SKB_DROP_REASON_MAX)
+	if (unlikely(reason >= SKB_DROP_REASON_MAX || reason <= 0))
 		reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	cb = NET_DM_SKB_CB(nskb);
 	cb->reason = reason;
-- 
2.36.1

