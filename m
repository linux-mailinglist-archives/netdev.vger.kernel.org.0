Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776245259E0
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 05:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376630AbiEMDE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 23:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358809AbiEMDEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 23:04:54 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9569028ED19;
        Thu, 12 May 2022 20:04:52 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c1-20020a17090a558100b001dca2694f23so6576006pji.3;
        Thu, 12 May 2022 20:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7iuYS+DTP82eQ8OK6un+T5VxnMX84G3Tig9oHmRFRKk=;
        b=evv1ZaG5LMKZCMQIuFTvXErFTbSpJxWI53hwRnIMD3Ry7NzuDyhr2UdnEOA2ARD58M
         bJ/1z6Ua5ytyY7htORu08sxLulzGCICuDFY2YhCIFgZqL/rlYWWfQJ47rt0/MDivAynw
         yeNZQRVHwWjibOFb+oRs4lm/xZJmGIF69rbpY97De8uDheskdLplJV5xeMgJGXx+uGVe
         0iajjUlp6quZvj/1Gc6cTDS+D/iIOBUPKDCrMu8m84CA+joWr6T6u7r7eQ3ZFzLifVXF
         37QNzysw6i9IchOzVbHFhWkJC+OM7YSqs3SenfP8xAckmCw5kXfNjEIInttyIoKLCvx5
         Lz5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7iuYS+DTP82eQ8OK6un+T5VxnMX84G3Tig9oHmRFRKk=;
        b=uGp06GkhvHdHSAYDjP8P8O/TsKfr+JlSY5hGzYmtnHtiqbeXjHtSthlmU4Ugh2ewts
         z45y2+g4C1EPsJP4GJn1fMQLk20FfXkOSyS4mWY0VT2m7HKFJYEcobpwuKVnC5CsVk4l
         eoJHDSV1mYwAvzsWzNAW7jGccuf4udwdVIWF02UYfRCT+cJQZXAhE6CbgWIqjy290af4
         01n+1J7AoK4ZdehWm4FsJG6reGe2TDrA1DmyJIjxin50G23J4GuV055Z5s4diHmN6bCA
         Yg0XuLuBn22pSudDxx2Wh01EcaTO5olVZdDG1E6jDE0hFzkLGMC9C/+l1uLf2LFMWM7P
         EjKQ==
X-Gm-Message-State: AOAM530/Z/iD/3OKk+MnP0aRVLGJnzvUyOYkGdBm0IPY26GEM0RAOh0L
        Kaw3KgcknbR+48yHvP0Pq9o=
X-Google-Smtp-Source: ABdhPJxRklea0fuQGLM4tboxMaCGdVeTGON3stKpT58ilxbUrHt17Ui+9ICoqRBsjze4p+BrlUkszQ==
X-Received: by 2002:a17:902:e543:b0:15e:fbaf:ba8c with SMTP id n3-20020a170902e54300b0015efbafba8cmr2700972plf.78.1652411091944;
        Thu, 12 May 2022 20:04:51 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.26])
        by smtp.gmail.com with ESMTPSA id b7-20020a170903228700b0015e8d4eb1f8sm638693plh.66.2022.05.12.20.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 20:04:51 -0700 (PDT)
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
Subject: [PATCH net-next v3 1/4] net: dm: check the boundary of skb drop reasons
Date:   Fri, 13 May 2022 11:03:36 +0800
Message-Id: <20220513030339.336580-2-imagedong@tencent.com>
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

The 'reason' will be set to 'SKB_DROP_REASON_NOT_SPECIFIED' if it not
small that SKB_DROP_REASON_MAX in net_dm_packet_trace_kfree_skb_hit(),
but it can't avoid it to be 0, which is invalid and can cause NULL
pointer in drop_reasons.

Therefore, reset it to SKB_DROP_REASON_NOT_SPECIFIED when 'reason <= 0'.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
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

