Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D925F502DD7
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355877AbiDOQn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355882AbiDOQnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:43:25 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514DCC6F0C
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:40:57 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id k62so1606100pgd.2
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LYBno9lyd6r1F2/ynsVFHAxdkYAcEZvAmA6QRq3yP6Y=;
        b=dQbKW6R+02RgO99V3d6ra8hOI0TSRcecd21i8E5N8sOsHUOUNfTRenahp1S73I0gI6
         0ELxoR2JEyVdrxEBRAHKdmuKHBxZwdP3vs1sT84qdhSgD99BXUvg/cDGhgyTR6vTYY5b
         IGapNkRDnAS0rD9gj0Qfx969biUuCHs1wiErZ37kXPKVHmFX9XPeGGpDBtFteZblItTw
         P69OF+kA3g1nYUKabmu8/Wiy0Rl/76eUlqjMefgAajoWJ0DLSMsAFaROv15HKCZ9c+e2
         4USDvTAEuAtZHExSUt5SdixAfpin5Rs8c6G4S1v6cnGph5brDGsCjubHe8x/nSPDToZ8
         R88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LYBno9lyd6r1F2/ynsVFHAxdkYAcEZvAmA6QRq3yP6Y=;
        b=tFlYidc0HkXIi7Fn8bELr02Em9yHGDLlZuytFBui0YZs3iGqSnhXEGt3t+5vxeu5mi
         pQ5awK1X5Rx9i9IPkzIkxhR4eFnHK4FX5LJWsYgAaqHR/X7UrTiS+kNy7sMAw3h+HdBd
         BwwGs7DcFWYUixRfR02p7hLjPtDabZZ6kRxMFfeqwTIfjaV9uxAlgAxRbPxMuczNaqzX
         c3o/0+RpFgqjZtB25+ASCZ5axkdQLw3WTyWUP4eA1oas2vS4UOP40NyVOun1GaP8m/n/
         bzncKGvMGC+wZk11WshUUyYKOHb+4gT9FtnFHyhCsGeLY2cf6VTkdDQeSWLW8hGOWT2H
         rX3w==
X-Gm-Message-State: AOAM533MFqEGqiUSRWxyVw7vS5TDMbvIwK0QirDRkEnw16bWknW/HoDr
        cT6nX5xq/5uzXnnhaeI8TVz1/NaajiOKfY4g
X-Google-Smtp-Source: ABdhPJyFIUJPIIL5DteY80DiEM6EmN+11pHOKaaovpt1ocAiny7b9v/IXWxLtkpFjogfDW3Z0+0ZCQ==
X-Received: by 2002:a05:6a00:124f:b0:4fb:37ad:16d3 with SMTP id u15-20020a056a00124f00b004fb37ad16d3mr20727124pfi.14.1650040856519;
        Fri, 15 Apr 2022 09:40:56 -0700 (PDT)
Received: from localhost.localdomain ([111.201.148.136])
        by smtp.gmail.com with ESMTPSA id w123-20020a623081000000b005056a4d71e3sm3322171pfw.77.2022.04.15.09.40.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Apr 2022 09:40:56 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>
Subject: [net-next RESEND v11 0/2] net: sched: allow user to select txqueue
Date:   Sat, 16 Apr 2022 00:40:44 +0800
Message-Id: <20220415164046.26636-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
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

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Patch 1 allow user to select txqueue in clsact hook.
Patch 2 support skbhash to select txqueue.

Tonghao Zhang (2):
  net: sched: use queue_mapping to pick tx queue
  net: sched: support hash selecting tx queue

 include/linux/netdevice.h              |  3 ++
 include/linux/rtnetlink.h              |  1 +
 include/net/tc_act/tc_skbedit.h        |  1 +
 include/uapi/linux/tc_act/tc_skbedit.h |  2 +
 net/core/dev.c                         | 31 ++++++++++++++-
 net/sched/act_skbedit.c                | 55 ++++++++++++++++++++++++--
 6 files changed, 88 insertions(+), 5 deletions(-)

-- 
v11:
* 1/2 remove likely
v10:
* 2/2 remove cpuid/classid hash
v9:
* 2/2 add more commit message.
v8:
* 1/2 remove the inline keyword.
v7:
* 1/2 fix build warn, move pick tx queue into egress_needed_key for
  simplifing codes.
v6:
* 1/2 use static key and compiled when CONFIG_NET_EGRESS configured.
v5:
* 1/2 merge netdev_xmit_reset_txqueue(void),
  netdev_xmit_skip_txqueue(void), to netdev_xmit_skip_txqueue(bool skip). 
v4:
* 1/2 introduce netdev_xmit_reset_txqueue() and invoked in
  __dev_queue_xmit(), so ximt.skip_txqueue will not affect
  selecting tx queue in next netdev, or next packets.
  more details, see commit log.
* 2/2 fix the coding style, rename:
  SKBEDIT_F_QUEUE_MAPPING_HASH -> SKBEDIT_F_TXQ_SKBHASH
  SKBEDIT_F_QUEUE_MAPPING_CLASSID -> SKBEDIT_F_TXQ_CLASSID
  SKBEDIT_F_QUEUE_MAPPING_CPUID -> SKBEDIT_F_TXQ_CPUID
* 2/2 refactor tcf_skbedit_hash, if type of hash is not specified, use
  the queue_mapping, because hash % mapping_mod == 0 in "case 0:"
* 2/2 merge the check and add extack
v3:
* 2/2 fix the warning, add cpuid hash type.
v2:
* 1/2 change skb->tc_skip_txqueue to per-cpu var, add more commit message.
* 2/2 optmize the codes.

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Talal Ahmad <talalahmad@google.com>
Cc: Kevin Hao <haokexin@gmail.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Wei Wang <weiwan@google.com>
--
2.27.0

