Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EA46E2A44
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 20:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjDNSyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 14:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDNSyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 14:54:01 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D6A9022
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 11:54:00 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-183f4efa98aso29156648fac.2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 11:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681498439; x=1684090439;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vzqj96vYGLMocPv/JejZYXZcCxCFycWEjQy0HzkJ6mg=;
        b=SfJHY5JcXjKbtfD2/4UBDQRFIDe9/DBA1OKQRnIOsxxnOhar7eTqVDqeTJMJsKrQnm
         gN0PCq+Olki2sr/7LY4704V4oJ7UzgRVHJo93J2RrHKQDJS7MpuhhlFUzjwE6LWsjEDQ
         VFoRSlhRJ8Xioc5Wtr6RfAcjWRvGLuQxiaVpiGaP9e8gEwkvSU+jecIhnl/RcoNle2qx
         sLgaCxIdjhGw0Xg+/FjWn9mYVnDWnE2syBrWicC//Jpmph7sClqjk9TFA4fg/rVSQDWj
         9RZtNXuQQ0qpEP6Fe9HagJlmxFXOr2RZazRJtSP+K+lz/m1nUvVJWavZL9i0Va/hw/8B
         4i6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681498439; x=1684090439;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vzqj96vYGLMocPv/JejZYXZcCxCFycWEjQy0HzkJ6mg=;
        b=IntUvnSBD8R4RwwsBtnxkc19zwSKGLLAnsLX3Ba0aQwzuZVaxW2BKNKAIxUYKsYKZN
         zDmyw4aHm9/5iRrNSFeS3FVQNTMhUkb118amA05nDBzoekomlzHk6+sDOaqNHHmYH48J
         dCI6UUEDVJGg3yfrlFPg84zGwrZBJj50CnEQv7JhDzHE/f92ZgHTK4uFHq5D3/G5Wx4e
         U1u4opZfu25Nb4NpyyHh2rHgn37oP4pEAN+4x7iqwg40w1W94p/uwyWw5ztKYm/KFpcK
         ZNubT2ei1kQwbpySVrG1EcMsTR713A15+GJtAOZ7INKfMrJVngdrqeYGmUiya7BsA2nh
         NnuA==
X-Gm-Message-State: AAQBX9e9koqOv62et+nZoCgXTRfJnKtBUvr/KiCTz/TV0JVzOOI6H7rx
        MiG70q67RIvIgcx0P7b9lv4H7v52F0o9PIuTIRo=
X-Google-Smtp-Source: AKy350Zld03WzUZBeRfAC810Ym2n/f+MlTqTHrnwrOK+xEDMtbiMBrLT/JiyCVjIJ//qJECCuwl1VA==
X-Received: by 2002:a05:6870:a44c:b0:184:ad6:761b with SMTP id n12-20020a056870a44c00b001840ad6761bmr5575287oal.26.1681498439243;
        Fri, 14 Apr 2023 11:53:59 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:bb6:61a2:bf8b:4710])
        by smtp.gmail.com with ESMTPSA id z21-20020a056870515500b0017f647294f5sm2096061oak.16.2023.04.14.11.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 11:53:58 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next 0/2] net/sched: cleanup parsing prints in htb and qfq
Date:   Fri, 14 Apr 2023 15:53:08 -0300
Message-Id: <20230414185309.220286-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
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

These two qdiscs are still using prints on dmesg to report parsing
errors. Since the parsing code has access to extack, convert these error
messages to extack.

Pedro Tammela (2):
  net/sched: sch_htb: use extack on errors messages
  net/sched: sch_qfq: use extack on errors messages

 net/sched/sch_htb.c | 19 +++++++++++--------
 net/sched/sch_qfq.c | 15 +++++++++------
 2 files changed, 20 insertions(+), 14 deletions(-)

-- 
2.34.1

