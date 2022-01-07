Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629D04876CF
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 12:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347218AbiAGLvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 06:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347204AbiAGLvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 06:51:43 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F737C061245
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 03:51:43 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id i8so5240440pgt.13
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 03:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8mRd1ku7twUv5SDfFRwB7A2Plic9ZYHNq0WmF/ih/lA=;
        b=S1HMIrs4aK64lZIGg0WYEJqsZcPChZcCDQc6QepMhn8izHhNjN7ldtXdJFa7cSB0+8
         IM9bq1Js3wwI91RraS/zEkXF8W1K/6ZAr+LHwq4kHs6XBV5FG0lGpli8TvbD2HItP+MU
         kiXalH6OM8e4/EhkoQnjU5EF026coZzXGLiHjAYZYO1V08UC3ourdW9/eg7E+gxSlRBm
         8vz5JN5Gt0oucW2cIA8fwVUnU9XK7lWeLluF8dxUUlw1VQp4C4P2J3g1+yqqmUxWXQmz
         U3sp22tv190gGvjB9LryloWtZqXwwDyiwAIRIMQKCBP26WAWiCIr71YCx6GexxZbfKZV
         QiJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8mRd1ku7twUv5SDfFRwB7A2Plic9ZYHNq0WmF/ih/lA=;
        b=GPw6ciG62Lfkfu2yrfw/Hlpy4GUTzmiThyOIeFwe1Fjo4rz+ROmtHrehH2PlHpUEJC
         y3/mzLJVUExcrZObYA6AEWv+qwBtTcvipUUGRmj3GZTTxjmWtA14DsYmC8g2LDdE95u7
         08YVAOWIrJ3dHpDBFcLAgxJOHUN9U1cPhVxB+GALENRBc1GxINTFSf4tl+1k9VxJS5WX
         cMvylWVMbuXkmdPBQPJZ5MDey8DWc3UOMRpwv5De8c6oneaPJ84CYroq7AZzlPwUOdQr
         KSkpMHnQErsKWz5HjRMiQZyk+XhSmKVIMBylA9rX5Vf0lVw8OitlhNBZKpVuUuB9hOD0
         6VjA==
X-Gm-Message-State: AOAM530CTRbbQSG/e3f5kMyWb9P4ndfawXBudywnXZAgy+sneUUFJnPf
        gUktvNOayB4LH1qJVDhH89ZD3k9D2uCE/+UP
X-Google-Smtp-Source: ABdhPJxHa00bJzWy0XtAefN+M9Jnm4py8BdDAOZWCjwVZ0Zc12c7jy8fwiJqd32YhLmihHk9cMsPXw==
X-Received: by 2002:aa7:8393:0:b0:4bc:b311:edec with SMTP id u19-20020aa78393000000b004bcb311edecmr21643797pfm.26.1641556302611;
        Fri, 07 Jan 2022 03:51:42 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id e20sm5744824pfv.219.2022.01.07.03.51.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jan 2022 03:51:41 -0800 (PST)
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
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [net-next RESEND v7 0/2] net: sched: allow user to select txqueue
Date:   Fri,  7 Jan 2022 19:51:28 +0800
Message-Id: <20220107115130.51073-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Patch 1 allow user to select txqueue in clsact hook.
Patch 2 support skbhash, classid, cpuid to select txqueue.

Tonghao Zhang (2):
  net: sched: use queue_mapping to pick tx queue
  net: sched: support hash/classid/cpuid selecting tx queue

 include/linux/netdevice.h              |  3 +
 include/linux/rtnetlink.h              |  1 +
 include/net/tc_act/tc_skbedit.h        |  1 +
 include/uapi/linux/tc_act/tc_skbedit.h |  8 +++
 net/core/dev.c                         | 31 +++++++++-
 net/sched/act_skbedit.c                | 84 ++++++++++++++++++++++++--
 6 files changed, 122 insertions(+), 6 deletions(-)

-- 
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
Cc: Arnd Bergmann <arnd@arndb.de>
--
2.27.0

