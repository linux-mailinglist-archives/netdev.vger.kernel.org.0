Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5432547F03A
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 17:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351828AbhLXQti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 11:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236414AbhLXQth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 11:49:37 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E27C061401
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 08:49:37 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so8860818pjp.0
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 08:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8mRd1ku7twUv5SDfFRwB7A2Plic9ZYHNq0WmF/ih/lA=;
        b=ZQNaUexQWeUnWzNleMGsPVFFcDOr2qrrAOyZUKMosn5k/mivg+TTHvdJRcpTP1l0+y
         4OIVzL1h4400Hl0VHOaOkQyN5GxaQUytYvezI0yaIzx8y7dIFO432O7vE/jy44IVGvxl
         xsG9lZdpAh+In9hHYQLLSmfh5SnyYk4r1o7gxIotBu1s6dy4yiyW6hv8fXNafP3slyI+
         JcmFUAHtdg9+q4g1oxrt3q5MvTKCk0/J3j8cbFi7TJVLH6FogvzzWIY2fjr5jfYtqFhc
         dOt9leeDfaTHGUxkdnDv3TIgimJDVoTE2+pqohIhKWyjiFOMhfrUzXK0+VeUvB0s/j3G
         7SnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8mRd1ku7twUv5SDfFRwB7A2Plic9ZYHNq0WmF/ih/lA=;
        b=jokjI/2IIhXn0n+iuSYPWsChMEtGA76WEU7lLd4hrmt+pY7QnP7RgJjFV3xOZyG3Dz
         XB2Hy+mO3YNujcv6SuFMj6UTVXLMpNOzYj/rmIM6v6FiISydLBkGcLSvHRs36AnEGVms
         5X/udsMaoNS3US4yprMOvqcehErXESERxf25fv7sX4TURPDIxUs8BjC1k9+w2gkXfXI+
         Gh9RPA1eYhei/S/OSyl2yiPFN80Be+Bue4vcbskwTsKhTxYKHSMFsy4FfMUZam/O9Vm/
         4i4FRgWqXPP/do+zCh7Ql7cN07ftn/HOhQ6kno/Ty6qLFAB8UJtPwOhfQ/Jnqg3yT0eC
         8HFw==
X-Gm-Message-State: AOAM530dvlPgbTMibpAqchPMYU5EPrWBBuMjCH0a1GkxAz5cH9IDjMmO
        QWTluDHOutsfhHUk0xaXJ3xmo2WULaHwbA==
X-Google-Smtp-Source: ABdhPJzhRC54bJ3jutyDf5ktTJHxr6uk3yBTHGRxRQXaw9oKVkvwnDfG2RRxmqmGS+VB11zUpYTvUQ==
X-Received: by 2002:a17:902:b942:b0:148:a2f7:9d72 with SMTP id h2-20020a170902b94200b00148a2f79d72mr7356515pls.145.1640364577000;
        Fri, 24 Dec 2021 08:49:37 -0800 (PST)
Received: from bogon.xiaojukeji.com ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id z14sm10122231pfh.60.2021.12.24.08.49.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Dec 2021 08:49:36 -0800 (PST)
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
Subject: [net-next v7 0/2] net: sched: allow user to select txqueue
Date:   Sat, 25 Dec 2021 00:49:24 +0800
Message-Id: <20211224164926.80733-1-xiangxia.m.yue@gmail.com>
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

