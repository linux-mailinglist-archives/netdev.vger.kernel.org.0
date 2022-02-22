Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDF64BF734
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 12:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiBVLYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 06:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiBVLYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 06:24:03 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C120113110D
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 03:23:37 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id p8so11667658pfh.8
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 03:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v8IFcg8qhU9FA82JToFhgHC5CwFm2PYXoKmNPfWSP7M=;
        b=SAY7L3ISf8GQbOMJBjTA9RTELEDMDM/81oFRFbOdDp1KKgZQqT6PziTfHD6hsN+VUf
         VGfhK08rtHg4AdT0BeCqFExe2Wq6s6YNDmMFQHK8cuTFHFI+ATXHQ5LQ/rQKe8BOdR+6
         OjiDZ6Ud1/jV2wKWsNwXORd6cqXieu0rVhc1wl2sFG9zdZttk08seA+7oAql0jX7J/Kx
         kO1H1r+nDqVyJscU7wzPp8+rL+L3IV+xIuuTPhrBDdZEVUUXyDsNluQBv6ic4RxdEChf
         9S0r4uDxDK3QHPGfJBsmx/C2iDcDi3l3gSUoRk+G9zDhw9J8rDpKP8i/vAm/Q6HgQlzd
         X+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v8IFcg8qhU9FA82JToFhgHC5CwFm2PYXoKmNPfWSP7M=;
        b=FFp3ZQHupx2QFKeFhF6sswU1qYYlH6+l0WtFNh+VGX//PcDFxR3k+1h80SGxPV/gZF
         WvSt3tcuGQBl7WMFEdzx6tvxIyxrTKg2LSxNCUvRie8xrUh1kgqGsNINOiGgfdpKV3um
         R57tQAhrtMm3eAJtrCBo4voGW95RydC+w4TJm0wNSlfL9z+U5kiIpYrfFDB3/lmu6ygn
         mxQ3yJuKTBc70TrCvMV+SFhHEmhic6mSlQhv8OTRoEOJstVm5EAszfN3xQ9Y9pK+4ghA
         kLuV8KUWKQiLcS8hwNZxjPIjHSNrJgvsi+MqWlWHbMeLboC+u/bv0ROY76PA0OVKmin1
         2fsQ==
X-Gm-Message-State: AOAM531CFlycpKmEoXu+YNFCP9AzM8wVWIeSNu37pnB5zUrCQCTzdDYs
        /J7qrfa8HxF9NtA2B9oTFeLPnSDNP301CQ==
X-Google-Smtp-Source: ABdhPJynTCHTrD1AEvdWJPgXnHqGELQxwQfJJbSXFnVUkKXU/GUmZRK/35bXB241aYLP1B9fGy6v2w==
X-Received: by 2002:a63:e005:0:b0:35d:7cbc:94ff with SMTP id e5-20020a63e005000000b0035d7cbc94ffmr19522821pgh.399.1645529016881;
        Tue, 22 Feb 2022 03:23:36 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id v10sm17331511pfu.38.2022.02.22.03.23.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Feb 2022 03:23:36 -0800 (PST)
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
Subject: [net-next v9 0/2] net: sched: allow user to select txqueue
Date:   Tue, 22 Feb 2022 19:23:24 +0800
Message-Id: <20220222112326.15070-1-xiangxia.m.yue@gmail.com>
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

