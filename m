Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022BF524CF9
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353835AbiELMeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353828AbiELMeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:34:18 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBE365419;
        Thu, 12 May 2022 05:34:05 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso4744753pjb.5;
        Thu, 12 May 2022 05:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y5dFPjnyVYyt7e0oJj6359izJi2BOR8deoMws+Pet9s=;
        b=NIh3uopiwf4V3MI0QnLFTh9xT0Nf7QLGBqNCxLhJiR0AfeSywsGdaEPBdxK8pXwEyl
         gc4ZS/T4DFa2NDU+H+Y5Ze/QeTbMV/vRS9AQrP7llYXbN8XPFkD8XaiRAxt8t1Q6Ak0n
         LDM61V07i+ZAblvWZNKiG40xwOn69PnoT0HaFr56R5FCAyOvZ4iHuu9C19oe2IDS+gGL
         V3Ffxg8Vv2QE4n4FGO6/tsIjkE1bXK5difTRdNaPSOauhvCF4NikOvOgzo1NfcYhHq2S
         W53ZduDvMpl4/gBAMzpl7+Kvag89GRQFjtwnAsf12Tu3FDVvHp202hPT5g1BPND4XkHx
         1log==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y5dFPjnyVYyt7e0oJj6359izJi2BOR8deoMws+Pet9s=;
        b=KVV0JcuBfacV3oTWcSo8tEWw0Fq1auy/t5LGCOEO5T36GAsGSh0y0psoSPvkQB6k0H
         3p/XAoOU656U3O7ljb4G1eebPX1UdQRE91AYbVFrBP07lE4yqp6guB7qg3nFphMtgAz0
         TlVjn7+00DiJYI5OhYnfLI2JkPP17wRQQh7Dgruy+iAOpn7DeoUYZ+z4W0jtehxoKaV0
         i7YS8aRI7xvmggS/VQVelQOnOTUVsFPb6KwOk/kmvIOprlnG6NW/WZ2FDQ2RqVaEeD+M
         mdiDejbBaAkRQgEglAxZfknN5+XQcM61KlZkOl7QwiWCsZLQF5sdjiQe0JCzhSpu1YfI
         QtWw==
X-Gm-Message-State: AOAM533b6Pv74th393h+DOFdHTJvYGNzba898NTX0KwsHczMfDtYSMTr
        uhXh80KHFmsSqv4WbHrBF4I=
X-Google-Smtp-Source: ABdhPJxO/W8GjBTSNxjCKoe0QKYbDlQw1BDaSodAE0by9rDf7QDxDsZU39X2GOS9GPUhC3/75KrKHw==
X-Received: by 2002:a17:902:e883:b0:15e:bfbc:1a53 with SMTP id w3-20020a170902e88300b0015ebfbc1a53mr30412111plg.62.1652358845456;
        Thu, 12 May 2022 05:34:05 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id y24-20020a63de58000000b003c14af50643sm1738130pgi.91.2022.05.12.05.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 05:34:04 -0700 (PDT)
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
Subject: [PATCH net-next v2 3/4] net: skb: change the definition SKB_DR_SET()
Date:   Thu, 12 May 2022 20:33:12 +0800
Message-Id: <20220512123313.218063-4-imagedong@tencent.com>
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

The SKB_DR_OR() is used to set the drop reason to a value when it is
not set or specified yet. SKB_NOT_DROPPED_YET should also be considered
as not set.

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

