Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B599249CC5F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 15:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242151AbiAZOcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 09:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbiAZOcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 09:32:18 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24739C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 06:32:18 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y17so12206743plg.7
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 06:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+dRVatdd+ECDpiF3H6iQs1VlZgrreErdrQJF4RNpUGE=;
        b=fbfVSEe+qynQWkDEKoGN9aUN6ixhzIPudY3YbvjFSko4EZrj3JzStteitfDtuMcOD4
         Y+WTxk10mJlrz4fyQNsLMLYsONtOBzWNSUPn8NX6N4KRoWF7bRm76tKW1DL0/ZjaGRdU
         lK72qO136Heo7LHNu5fv9VWwlxozNrp44waVZ0SLY9bhbQjQAJHmi/GJeqS6SBS4SUnR
         kwj4unEjmhL8fxLE/PiKe/d3NvKEc4wYNeBIeRui9FGR9qmr/QbU704VBECyjlsTEC19
         d/4aSN5Lhl+/Yi5ksLd9u1imxe7gb5jTgWF6tva+e4/Zi9/TLkJ105syreNmw4vONaKs
         ESTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+dRVatdd+ECDpiF3H6iQs1VlZgrreErdrQJF4RNpUGE=;
        b=0Cf/LJgzzMjy9x2Z5KUG1Dl7PmP58XmDyYVxFvJzTs+JUkzZ0Iukc4T5ywGwex1gM0
         dQRNuZsF8EsnPIP2i2i4T5Xp5PkUtVpQZ/TPoCpBh/teLqgjTB2d66yOBDM8m7mP9Iyp
         0HhjyrT2BIMNeX9zokQEfAWKnZj7NKL73EQ2T3F85sjZxvtpj41umYNWgCVB7VikfO4I
         F5jXbjZZCpgr0GwSWVsVCVx5mQOGo/ZPhl+Kpek5A6iwKFGlOfLHbnY1JJjbbA2cFQMy
         Xii1X4Jgf80zx1o0gASkDWVTF0ZPgpyaCVSzgo4di9DYGx+b7eVmrof4/7jYxgEjv0f8
         1M7A==
X-Gm-Message-State: AOAM532BVQxJU8JH8mNwEaQAEethRHkGEB3UMiWFz0R+mkpATzxy3rKV
        G//gkpkY8Psf+w/21vKaXRI4w1VmByLOIw==
X-Google-Smtp-Source: ABdhPJzTPSe5tm9L4+XKIF+TwMqEWnLcTeOKry+XKLE7o6Tcvd3iFC56G1Uua0rvPtYdxEPOna8aoA==
X-Received: by 2002:a17:902:9683:b0:14a:957a:87f9 with SMTP id n3-20020a170902968300b0014a957a87f9mr24142154plp.76.1643207537287;
        Wed, 26 Jan 2022 06:32:17 -0800 (PST)
Received: from bogon.xiaojukeji.com ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id n4sm5268501pjf.0.2022.01.26.06.32.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jan 2022 06:32:16 -0800 (PST)
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
Subject: [net-next v8 0/2] net: sched: allow user to select txqueue
Date:   Wed, 26 Jan 2022 22:32:04 +0800
Message-Id: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
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
Cc: Arnd Bergmann <arnd@arndb.de>
--
2.27.0

