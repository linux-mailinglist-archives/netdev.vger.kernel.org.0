Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8451E4E4AC9
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 03:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241114AbiCWCQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 22:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiCWCQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 22:16:27 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955C970051
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 19:14:58 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c23so292377plo.0
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 19:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GJaag9cSgw7muUo3OixT7ynufbhcQjgiAaGWcgDKm88=;
        b=GjT8Nau/uLrUMuRYmt1yzBeAKvlzrwEaLCFVop6Ey8TEoru47ulLm/AcrsTyWOHy1A
         8uhwfg280uLfyMh6M5aOvzpta5YlD8D5FQF/d9xB4GWiOGHVYT0W/yPZBMT2ht1udBLU
         mpAH44iRCiKPexafXvWWHai8C39Fcg+nCakK6RxsvQWnP+GjcJNyCqo9iJ8KSWXI7svq
         4jk+0c6/0lOTxBiAOK3U4DqnyAdSJW3XQoiqTx7lvjl/++29SQ4oq1hafWnMDzMGzb+5
         GC3KNT0JMHLX4qRrQrjfBiFWUvTDGxDXJu86RD96gkgI/9XIp7e05c1+ri5k8uSwVRrK
         BzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GJaag9cSgw7muUo3OixT7ynufbhcQjgiAaGWcgDKm88=;
        b=fANmtdO0Gj7702Jf3yw6IjDoAe2VVLA/aQFXxcgHUTYl9QpSF2JdqsKgyzzsKAGCa8
         Eif3VRI+S+Qxrm6uVZTf6BPv2hMeiqgd3TdzCfhFbADhX6fOsVw3LHKtidmGxGD9rH0T
         y3o3s/IsuSf7uLGn+t4jkGWV8nfuRetccIDh/rQua96bdzFVi1yerFLyPt3BPBDJ71GA
         rJstpHwk0P9w13HklP3JgHEaA3x38wnzxueIovsosdHfBlrjzfESRGRy+eVvoRDo3EcP
         E09ZH4pFwX9rmSipCZ8DcLCTyMKDXdkCAbQ/3mQpj1gopFws2Zf1A08fivjZsoTEslLh
         ilRA==
X-Gm-Message-State: AOAM533bPP1HvZa2fZvVzyO8x5Pr7nduGTAjAlpIPE9ZLa1o/MUj7OGP
        rbUHSFUqhSjfcaE/o9OU9pBbdTIuYhWYpA==
X-Google-Smtp-Source: ABdhPJy6ooTu3eTIUfuNNKFqxoSDfeiXHiabKWjlqXtkm4GfuSfMJtDS66UzI7IWhj//mR+k5gJ/yg==
X-Received: by 2002:a17:90a:b008:b0:1c7:8810:a08d with SMTP id x8-20020a17090ab00800b001c78810a08dmr1300261pjq.181.1648001697772;
        Tue, 22 Mar 2022 19:14:57 -0700 (PDT)
Received: from localhost.xiaojukeji.com ([111.201.151.228])
        by smtp.gmail.com with ESMTPSA id t71-20020a63784a000000b00380a9f7367asm19332580pgc.77.2022.03.22.19.14.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Mar 2022 19:14:57 -0700 (PDT)
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
Subject: [net-next v11 0/2] net: sched: allow user to select txqueue
Date:   Wed, 23 Mar 2022 10:14:45 +0800
Message-Id: <20220323021447.34800-1-xiangxia.m.yue@gmail.com>
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
Cc: Arnd Bergmann <arnd@arndb.de>
--
2.27.0

