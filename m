Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458084785D1
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhLQIBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhLQIBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 03:01:20 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62683C061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 00:01:20 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id m17so1638109qvx.8
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 00:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JlrwUShgRc0x8npI+6jFpNiwhQX11weXPtq/xc2rE2w=;
        b=Sn6n9DHD4U2Mrgv+1CBA1VHmw06uIKrO/dz2UmbFyre+05FK0rfws4P1m5pv7C83S6
         oM3eM3tefKfyanl2ujlz7h1b5d4s5xD0hG8fXiqPR70m+ZsxklnKsCb2GX2l+QKdyvHC
         OhcGTOdvq0rWRu8KGrmyXwjv0oOgQaS1IF3MoC1BvkKv7OsDRnNZJL35LrSX5BMrA3nl
         x6fOkjKxwXGaOcC9tRglhJG7dTwJnaXpA9456YeGnH4FtDAdrSXe2yN7RSLyaqM6f6hp
         dGjRUw2BymaIXb1Z+hdYg6wWzyFUC41H4eFoJekzWIwp4db4gdMqZfMoBZkrGnnbdrqC
         3uqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JlrwUShgRc0x8npI+6jFpNiwhQX11weXPtq/xc2rE2w=;
        b=61hQrTS4htS8DxhdgDmpCP5WGX/E71mm2Xgwm4J4HBKYXb79a2+5fq5b+8pDwBZTf9
         bS75exb2M8D2arYEzSrY6/rdlu+dQfgYPCqJvbmtw+qT2qG60EeNtkNr0mo0kNvd2hPB
         6KtXzImRcqfEKojP7tVeDz/6TMv1DHymOEQ80MJ+YBQNQNU1PYo6SU1l9sLPrCLUprmI
         uFllX93AGnuosDxkBhIl99ywY9TsetM2FTXeg9oZLIjdewECMjn0u0Uvld8RDMiUGJdi
         /uqKeMOB3QNatJ7gTxbNx8SpXQXwlkCNij7gjN8/eYbesiPip6HchfOBsvZJeNO1Bj8W
         SZGg==
X-Gm-Message-State: AOAM5322anb6kw6OMZ9/kfBvToM9QWDXiwK96ujX9Y+PVGIU2zFulst5
        XbYCYNPfZ4WGIbw+Klm7TWxUqGx+uUShLA==
X-Google-Smtp-Source: ABdhPJzPvQX89xsvZNFc7SejuKPIcmmiiDWRZkH/BFNE/YmkE6URqhtz8H3tnkqGeLss9Y8s64uxxg==
X-Received: by 2002:a05:6214:c4f:: with SMTP id r15mr1297454qvj.22.1639728077882;
        Fri, 17 Dec 2021 00:01:17 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id bk25sm4239922qkb.13.2021.12.17.00.01.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Dec 2021 00:01:17 -0800 (PST)
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
Subject: [net-next v4 0/2] net: sched: allow user to select txqueue
Date:   Fri, 17 Dec 2021 16:01:01 +0800
Message-Id: <20211217080103.35454-1-xiangxia.m.yue@gmail.com>
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

 include/linux/netdevice.h              | 24 ++++++++
 include/net/tc_act/tc_skbedit.h        |  1 +
 include/uapi/linux/tc_act/tc_skbedit.h |  8 +++
 net/core/dev.c                         |  7 ++-
 net/sched/act_skbedit.c                | 83 ++++++++++++++++++++++++--
 5 files changed, 117 insertions(+), 6 deletions(-)

-- 
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

