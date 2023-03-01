Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CBA6A6E48
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 15:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjCAOWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 09:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjCAOWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 09:22:15 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CBD41B6A
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 06:21:49 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 132so7767769pgh.13
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 06:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677680467;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OcToE/2Ky4OE4lmTJMgOrchA0mqlqsf7rpylXLL+GrY=;
        b=SUx3imsawvC/d5K+jCdzdiyeVw4zfX8Pjkjm4lMge9qADiCwolI0jwNc5IHjEEQz18
         qgVQj3L3WVJ9GeI+dLvATAWnVavFbx5tty8IvyDn6LDA8YDQxIt10dBM5jxksBTa3TLj
         8QHm8LEOrxK3313WprGsMzApGip5yNKPFQq2hKgOVA0IaEUAK6IiJv0Eev5tvpRvYTDw
         +QZpSgCS0zvq+hNsNoAf9kJQT09aZxbVmjOyty/OIimCXk5T231p0Z2uYVax/HuHSrLf
         hpDHJl3jNs0yLM0QWPW0jyS6N//ddGkR/c2Dt8kcX840C68kHQyfZug9fK6MZcu+I2/3
         vjOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677680467;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OcToE/2Ky4OE4lmTJMgOrchA0mqlqsf7rpylXLL+GrY=;
        b=gWqMEHRh4Dud5V2SvOJGFn2QN/auHHB1x7/2NFR4ml6J2IA4DXMS5Tgu0GJAu/e/BP
         4TF70jre/CgD0rotBR++HkSaZcg6pX5Ky31B11bQuu4tPRTEAFSBlceNk2DsL4DUE9rM
         btbb6dsU22DOKOaAcP0z0Mqdzj/nydVfB5j3nc8Dt+s/ERtzItfpI9OwFfHBgM6kV10U
         TDfQ2KRmDLtzR75ZzzMTX3gqcTxPSyHymR3EN46iHUCMmfFLJD5RunoF7LuKqznWDaX7
         LYECbiTKx4DGNgyANOuKyso0rlNcZST/NR5l9fPgL2p9A/4HrvXl4DTqFkYhJ+1+NQu7
         EYJg==
X-Gm-Message-State: AO0yUKWpek5UjGE8/G5FrnpsV8QEhwDaYpyYE2DHxRZrn95sRMkiiJdL
        yeY+45/J9wbs5wbT582fXXe8MYBsM8XLHGzW
X-Google-Smtp-Source: AK7set+qMTYCFIaf+Zf8XovyhueFlPnSZaUE+sfMunhvnMKq+Sz7AX6hY/nikxTzrVvZsjL+0OifmQ==
X-Received: by 2002:a62:1950:0:b0:5a8:ac0f:e116 with SMTP id 77-20020a621950000000b005a8ac0fe116mr5532734pfz.24.1677680467200;
        Wed, 01 Mar 2023 06:21:07 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j23-20020aa783d7000000b005ac86f7b87fsm7971654pfn.77.2023.03.01.06.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 06:21:05 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 iproute2] u32: fix TC_U32_TERMINAL printing
Date:   Wed,  1 Mar 2023 22:21:00 +0800
Message-Id: <20230301142100.1533509-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
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

We previously printed an asterisk if there was no 'sel' or 'TC_U32_TERMINAL'
flag. However, commit 1ff22754 ("u32: fix json formatting of flowid")
changed the logic to print an asterisk only if there is a 'TC_U32_TERMINAL'
flag. Therefore, we need to fix this regression.

Before the fix, the tdc u32 test failed:

1..11
not ok 1 afa9 - Add u32 with source match
        Could not match regex pattern. Verify command output:
filter protocol ip pref 1 u32 chain 0
filter protocol ip pref 1 u32 chain 0 fh 800: ht divisor 1
filter protocol ip pref 1 u32 chain 0 fh 800::800 order 2048 key ht 800 bkt 0 *flowid 1:1 not_in_hw
  match 7f000001/ffffffff at 12
        action order 1: gact action pass
         random type none pass val 0
         index 1 ref 1 bind 1

After fix, the test passed:
1..11
ok 1 afa9 - Add u32 with source match

Fixes: 1ff227545ce1 ("u32: fix json formatting of flowid")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: add tdc test result in the commit description
---
 tc/f_u32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index bfe9e5f9..de2d0c9e 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -1273,7 +1273,7 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
 	if (tb[TCA_U32_CLASSID]) {
 		__u32 classid = rta_getattr_u32(tb[TCA_U32_CLASSID]);
 		SPRINT_BUF(b1);
-		if (sel && (sel->flags & TC_U32_TERMINAL))
+		if (!sel || !(sel->flags & TC_U32_TERMINAL))
 			print_string(PRINT_FP, NULL, "*", NULL);
 
 		print_string(PRINT_ANY, "flowid", "flowid %s ",
-- 
2.38.1

