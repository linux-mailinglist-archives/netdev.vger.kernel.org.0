Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEAC5B77DA
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 19:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiIMR0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbiIMR0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:26:10 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82AF7675B;
        Tue, 13 Sep 2022 09:13:39 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ge9so286216pjb.1;
        Tue, 13 Sep 2022 09:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=WIjnJzlalSckDp9pFCpxMQjOJBvL82/YyMrE8wcCUgY=;
        b=lTAJlyNFBwfjezsZ03CEWOEpeKJkjFnZWGydK8jAn/FaGf1a7kuedeLEJgp9WP9GHC
         d/SAvA34Vd/6U0+2v8xs1hvZVdgFzRBMslEHjPZgQj4zA6893+yIO+yVQHpgU81NPokY
         0qo43QILGPiut83fa8PSG+y6vUXLQe+8m1pKLaP3oJZQrgM+LC+M9GaxxBFr31zikndB
         RvDFe11FcY1X5LT7ID4+x3G5qxAklbpqPIDXlzJ98yILWRTPyyZcBLbsvob2bACmD/L4
         SicSEgGTPWoXS1NshMPQikRbaNfE0gcjMoj8TuGR1YeVB7pJJdBxwT2TC5yQfDhEy6m0
         CVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=WIjnJzlalSckDp9pFCpxMQjOJBvL82/YyMrE8wcCUgY=;
        b=yTKTJAxHDJ8U9vsh5U+qff9RGdt/mPPZOHMq8wEGbJRnH0xJAGdcKBf0KK/ZI6Ityw
         +BKuhx/rSgVC7hBfashQX8CALgRR8w70IbS7omqH0VcXDXF8A3ylQvT3X8R7mOFEYXxj
         izOakVkHH+bu25Q5SxThxpm13/mB2D0ODiqWiO7dPWw8StNISmAaxQoepHJxlsznv9Jp
         nxONn0SSJ5+70v5/13YXK8NPcoIpcyF/ynqKmH702BPEWt68m9TrOPA+N5XR6d8GxWqf
         7QjOF06198pK6DEsCNSP6LPseLPQLvi7QLH3FeqcFxJVfNfYvnnpIc0uig77Ygwt+iFR
         mqyg==
X-Gm-Message-State: ACgBeo2UHkDjIS6lSIgmXU/Iu3rtGZkWWUv6aF4AykIbXNgYkm96b49u
        iDMch0X+SzLy+X6X+P3AVVunhbV2Oqo=
X-Google-Smtp-Source: AA6agR6Nb11vn7vxLfz1Soi3h4XadGrMtG2mwC1+mLEcle1kVWQgRazJqQhq7dCeQ9vRtFSH82BHlQ==
X-Received: by 2002:a17:902:ea11:b0:176:b283:9596 with SMTP id s17-20020a170902ea1100b00176b2839596mr31861623plg.69.1663085619415;
        Tue, 13 Sep 2022 09:13:39 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id o188-20020a625ac5000000b005289a50e4c2sm8093794pfb.23.2022.09.13.09.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 09:13:38 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] net: sched: act_ct: remove redundant variable err
Date:   Tue, 13 Sep 2022 16:13:26 +0000
Message-Id: <20220913161326.21399-1-cui.jinpeng2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Return value directly from pskb_trim_rcsum() instead of
getting value from redundant variable err.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
---
 net/sched/act_ct.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 4dd3fac42504..9d19710835b0 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -696,7 +696,6 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
 static int tcf_ct_skb_network_trim(struct sk_buff *skb, int family)
 {
 	unsigned int len;
-	int err;
 
 	switch (family) {
 	case NFPROTO_IPV4:
@@ -710,9 +709,7 @@ static int tcf_ct_skb_network_trim(struct sk_buff *skb, int family)
 		len = skb->len;
 	}
 
-	err = pskb_trim_rcsum(skb, len);
-
-	return err;
+	return pskb_trim_rcsum(skb, len);
 }
 
 static u8 tcf_ct_skb_nf_family(struct sk_buff *skb)
-- 
2.25.1

