Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1452C6BC4CA
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCPDiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCPDiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:38:21 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EF25FEAE
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:38:19 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id t83so178730pgb.11
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678937898;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0yVM11O88fXTEL4l650pNPO0SVFBuoWDpVul1fV4dMc=;
        b=QrRSRWnARqu/qpS9mRBZFQ1RVkVty/QJ01RB/xa8pNShPxdoxr+u9kDXC+FdVkWNrW
         BUIdsS1kUsIaGPJP0UT6opglXmIsT8Ei0RzAy6RH1VZIwhisMWVIYY6/65cnz4WtC2LG
         02DjO9+bPyWkOKR3P3wtewzL2HClI6Ch8oUb4jO1v2gGDwdxGTVz31doLEzf0IJAOgOr
         AUnysjYR0WorLYaT0IOcPXc/LSmw1x8Hc51eSqagpplBuhKXKtCeoLUxFnocOCvDYc0K
         L4Q07/YWQXNFyAGdJe6RvzL4vfsgevAHiYU1bRPSxJB2AozNRM0pYelosdO9nLSXoZKT
         rdGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678937898;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0yVM11O88fXTEL4l650pNPO0SVFBuoWDpVul1fV4dMc=;
        b=pun4VO1dR0d//wLAmMefM2UqZzgXwl6UCz5C6FMfnbQ9e1nsyEL91/IGKPnaVVEgEC
         1uq6reRFxDJ7/Xb1LMROkipbTVi9RwviPzjyEzBxL54mWF6nyMe1TqJ8C4KXRIbjEwYV
         /2j8d0bL3lmcNGg+hBtGTWQIa/RV042TKx6fgl/ldrb+8UGwqaggCvQEMjphO8jZORaG
         K8YSeYIGlL+5Lo6x70qr8XccHoVEa5vFkezYWPb3/i2JaN/dv06wjHcZz2gyXOzV04nR
         XiKfXWeD38Op4XnmvYSZHST7m2iEo9TvGkZeql0GtwOC4hrhjxNCw5bQ2Zp7EZvsThhZ
         7zBQ==
X-Gm-Message-State: AO0yUKVnWmwnaqzHYUN/130TpfvEEdouAIbEGYHask4F9LzZTx/7Vr9q
        TXUWXdNY/ya0+zQW34bBACogObr24C2S70La
X-Google-Smtp-Source: AK7set8LDBIf2ImdkesF3TPbXjB8fn6afcjjlcbnxhl0p8CvlgpDfzgsWjf3j69OvMK6DLZUGj2yIA==
X-Received: by 2002:a62:19d5:0:b0:625:b37d:875 with SMTP id 204-20020a6219d5000000b00625b37d0875mr1503055pfz.32.1678937898513;
        Wed, 15 Mar 2023 20:38:18 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u23-20020aa78497000000b005a8b4dcd213sm4250009pfn.78.2023.03.15.20.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:38:17 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 0/2] net/sched: fix parsing of TCA_EXT_WARN_MSG for tc action
Date:   Thu, 16 Mar 2023 11:37:51 +0800
Message-Id: <20230316033753.2320557-1-liuhangbin@gmail.com>
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

In my previous commit 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG
to report tc extact message") I didn't notice the tc action use different
enum with filter. So we can't use TCA_EXT_WARN_MSG directly for tc action.

Let's rever the previous fix 923b2e30dc9c ("net/sched: act_api: move
TCA_EXT_WARN_MSG to the correct hierarchy") and add a new
TCA_ROOT_EXT_WARN_MSG for tc action specifically.

Here is the tdc test result:

1..1119
ok 1 d959 - Add cBPF action with valid bytecode
ok 2 f84a - Add cBPF action with invalid bytecode
ok 3 e939 - Add eBPF action with valid object-file
ok 4 282d - Add eBPF action with invalid object-file
ok 5 d819 - Replace cBPF bytecode and action control
ok 6 6ae3 - Delete cBPF action
ok 7 3e0d - List cBPF actions
ok 8 55ce - Flush BPF actions
ok 9 ccc3 - Add cBPF action with duplicate index
ok 10 89c7 - Add cBPF action with invalid index
[...]
ok 1115 2348 - Show TBF class
ok 1116 84a0 - Create TEQL with default setting
ok 1117 7734 - Create TEQL with multiple device
ok 1118 34a9 - Delete TEQL with valid handle
ok 1119 6289 - Show TEQL stats

Hangbin Liu (2):
  Revert "net/sched: act_api: move TCA_EXT_WARN_MSG to the correct
    hierarchy"
  net/sched: act_api: add specific EXT_WARN_MSG for tc action

 include/uapi/linux/rtnetlink.h | 1 +
 net/sched/act_api.c            | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
2.38.1

