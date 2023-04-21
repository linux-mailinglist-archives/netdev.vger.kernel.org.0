Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B07C6EB39D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 23:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbjDUV0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 17:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbjDUV0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 17:26:01 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E372D78
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:25:55 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 5614622812f47-38e3228d120so1607797b6e.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682112354; x=1684704354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f72Xfsio3gARNcMunkdIGAkmBIJdgUtaGuBTP8E+oSw=;
        b=On6fC2I+j94PNaLbRU0QfNvPVg2YjU8LLJP8g9H160CyAO2d0BSobvVq9RIpnySnCM
         Oyi58zWjIHy3ZMyBcsn6xAnfLc5TZa0V3Fn3u5At/ALRHkhxp/3uCqNL/Aa60NQRIqJc
         vvEHGIjiRvFmkh4JimxVx05SiUGUANhF8mykI3Z15Arcq3oX3KhiUBxvdoO5Bo5TuH/H
         zMN8/fjW3tV7gMrxWTbSWLAaylkEe05kXjaKwVW4BNBnt1Bl1nrzSgoUUod9mu50VF5d
         /yqSQlnt0MRG7URkWRUsAJlf3xvVMHUzi539PbVDbaFBaIzozL5JYVFYGRjVAMGO8X5A
         7+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682112354; x=1684704354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f72Xfsio3gARNcMunkdIGAkmBIJdgUtaGuBTP8E+oSw=;
        b=IiK64d6airTaDMoxmJQeLamercTY32j2Dpq6NcwE9AbB4Ts5dJMulMkYUkqtPqlowq
         d7ifQ+4X3AhP1YbiUsFJlU2nBotU7ACqRV39oeWrDZMMW5ZoeTf5SZjC022tdA67db2w
         nisRws0tr/Sizp+KBJwkE6VR3zBjoJ+k5/DiQmBW6Jgf0Vn8ZTfWI16AXoeu6JeyWVEx
         4EXMAaqPsUcHzB5U+hE0xsOWrqAmrzm9hH6FYqI2cwDVPsi1I62RFcKu8Dkb9O/Wfaog
         fFcJS3G0S2ETbY24xYAC8oCeCpGhWTihPjOJdMuCw6txYOUK8s7MNUF+Q4al3M2Cg+Vh
         xQMA==
X-Gm-Message-State: AAQBX9ctpBJ595Ac/oQBRwsuebIe0foeXeHCXwr+gDSiDyYA9Z44xJ3m
        cx+AJbGHai4BSHaflnsnHMpJ1i4PUv1SKDnJTGg=
X-Google-Smtp-Source: AKy350ZI2Ok+bDidDQOrbEqfzAtu6OplHvLKcuvsvAOdjriGgmR7zIXjEHwKcCWX3pQaTn37C0WM3g==
X-Received: by 2002:a05:6808:1913:b0:38d:ef97:a2db with SMTP id bf19-20020a056808191300b0038def97a2dbmr3936746oib.5.1682112354328;
        Fri, 21 Apr 2023 14:25:54 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id j11-20020a4a888b000000b00524fe20aee5sm2147663ooa.34.2023.04.21.14.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 14:25:54 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 5/5] net/sched: act_pedit: rate limit datapath messages
Date:   Fri, 21 Apr 2023 18:25:17 -0300
Message-Id: <20230421212516.406726-6-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421212516.406726-1-pctammela@mojatatu.com>
References: <20230421212516.406726-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unbounded info messages in the pedit datapath can flood the printk
ring buffer quite easily depending on the action created.
As these messages are informational, usually printing some, not all,
is enough to bring attention to the real issue.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 2fec4473d800..fb93d4c1faca 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -396,8 +396,8 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 			u8 *d, _d;
 
 			if (!offset_valid(skb, hoffset + tkey->at)) {
-				pr_info("tc action pedit 'at' offset %d out of bounds\n",
-					hoffset + tkey->at);
+				pr_info_ratelimited("tc action pedit 'at' offset %d out of bounds\n",
+						    hoffset + tkey->at);
 				goto bad;
 			}
 			d = skb_header_pointer(skb, hoffset + tkey->at,
@@ -407,14 +407,13 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 
 			offset += (*d & tkey->offmask) >> tkey->shift;
 			if (offset % 4) {
-				pr_info("tc action pedit offset must be on 32 bit boundaries\n");
+				pr_info_ratelimited("tc action pedit offset must be on 32 bit boundaries\n");
 				goto bad;
 			}
 		}
 
 		if (!offset_valid(skb, hoffset + offset)) {
-			pr_info("tc action pedit offset %d out of bounds\n",
-				hoffset + offset);
+			pr_info_ratelimited("tc action pedit offset %d out of bounds\n", hoffset + offset);
 			goto bad;
 		}
 
@@ -431,8 +430,7 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 			val = (*ptr + tkey->val) & ~tkey->mask;
 			break;
 		default:
-			pr_info("tc action pedit bad command (%d)\n",
-				cmd);
+			pr_info_ratelimited("tc action pedit bad command (%d)\n", cmd);
 			goto bad;
 		}
 
-- 
2.34.1

