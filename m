Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D826D5259E7
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 05:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376654AbiEMDFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 23:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376661AbiEMDFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 23:05:13 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161AC28ED02;
        Thu, 12 May 2022 20:05:06 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m12so6722741plb.4;
        Thu, 12 May 2022 20:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HDu0z3UNTUmPRRo575SlQWaiiOZEc5TgsbPLrsF6F5E=;
        b=XM05gpTuaLNiPbmcDzOGEpLg3H7KYY/vEcUvDQu5ZtfbQucAiN14eegoAUY7qAUDoj
         hgJ4/mX2nm6czn81tJ6Wa6qjGZJDXUBdvknkqaF/sxhMMXtefI7jNLT7MfEcVxoDVG7I
         XcDMgjjbQkBCEY1pzYzdOHHmCFIF/GJxlS5GxHzIM4eS4jYL8sr2KkQ5Jb55XPu4Xkid
         PnOodOG3iDzvS2F5WORd8Px8ne5YDsCJCCzKOiFldIDODIKrl90iYp5CXQibIpnNRFqV
         bmE7MUxp9gXvER2qnAgdMzNyzeoXVI8QxsFikYKbcf4JRwxperZxj2e499hoeyZYuxTI
         WkJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HDu0z3UNTUmPRRo575SlQWaiiOZEc5TgsbPLrsF6F5E=;
        b=g2BzpE8CmAvpPMFkefHw5bsAIHyRapZtR0lwk/CuzKmC9/wUEBpm+QX0SOnQ9mPujV
         DqQkQl4LB9BRSs7xoExa3R8zG+Yz+OMK6U5ktiF/+UxYmxmvmxIWUcuDJwlUHu4d0A5+
         vV3ZiytB3usnyQUD1dzlMxAw56yniM9ITACJuNWgtDipgwtWnBeX+ABU0hKbIxrgh0rI
         st2ZmCXKhkpDA29mCpkWCCJL3nAy8gDuilcYbtVnaqNB3yyhp85EFHZFIdIrhITdnQok
         sPkJJtnd0L4jPVb+laxBcWSyoHdhA+sgHAIpNDwJicMBQJNn4JapmfaTrq5A4R7LNjmA
         k0kQ==
X-Gm-Message-State: AOAM531mi33Rc79js6pSVkFJegxFbBOwxBtJz8Sey765QhXrV9cTdC7i
        tiojbKS1fZtP5DOtBxGAJRU=
X-Google-Smtp-Source: ABdhPJxvEagH5pqXuRunEPMlbOlkdX8lEFUheBpWfF12/LSGhjF739dwmFECeFlNij2SlrVWPs96wA==
X-Received: by 2002:a17:90b:1e53:b0:1dc:5cdf:565e with SMTP id pi19-20020a17090b1e5300b001dc5cdf565emr2692081pjb.78.1652411105651;
        Thu, 12 May 2022 20:05:05 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.26])
        by smtp.gmail.com with ESMTPSA id b7-20020a170903228700b0015e8d4eb1f8sm638693plh.66.2022.05.12.20.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 20:05:05 -0700 (PDT)
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
Subject: [PATCH net-next v3 3/4] net: skb: change the definition SKB_DR_SET()
Date:   Fri, 13 May 2022 11:03:38 +0800
Message-Id: <20220513030339.336580-4-imagedong@tencent.com>
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

The SKB_DR_OR() is used to set the drop reason to a value when it is
not set or specified yet. SKB_NOT_DROPPED_YET should also be considered
as not set.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b91d225fdc13..4db3f4a33580 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -510,7 +510,8 @@ enum skb_drop_reason {
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

