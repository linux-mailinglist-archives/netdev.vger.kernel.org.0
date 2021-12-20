Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643EF47A9C5
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 13:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhLTMiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 07:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbhLTMiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 07:38:51 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FBBC061574
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 04:38:51 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id x6so12892925iol.13
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 04:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8obVPbR//GE3PRaBiUmKdvsycP2YdO7/xUt40CvsJ04=;
        b=MgGBiYQJROz9YP7Gwlx61uoUj+gXSV3XpXAzKT5HN4M1EsWID5A2y0/UZaLSKBZMqL
         Go/0DEkyZ/NCkpAiOXHrEzO1ZKl4Kjg/gnoBMbOGWncXa5UNS4YERJ43NolJq2iJ2FZ8
         tmRnndUWS606GysFkZIO1hzH3i1YMjruJtuoVwyzpQniYBQZhwtRVauwwvwR50Ab6rbp
         p0axdSPAzMf8tgB5L2V/hkzYjuelDFFN0nRtfABKjByozKyBa0Nntan7QfkJ+Qv02fy7
         iAiFYR9SLAxgzFvIeZIUlLgZ34yl9uh2UhnMIZ21anvcSylnJXfCnpU30pLp5sRdHcyW
         c0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8obVPbR//GE3PRaBiUmKdvsycP2YdO7/xUt40CvsJ04=;
        b=hib/JyNbvmouvQ7S9I7tJfSg+EMOe8EoBqK8LvO8bPvl/4H7dpcmv+zA5O6D1o1BHT
         o75SUsOhVD0g6oyZClF7DcZZExFfqI2Rj4GA1KPn8Zp1IK7Pjrgk7holIyEMZOYig1B7
         eVZwWXStmxGgClFO+76UElK/1Y96jnlziTTW4Rxtyu6gI1DY/YVreadwl3xvoa/kIYrP
         LQdSSNE1umOUl26lMy/HskWapw4wo8FLcHkNf0FWdUXR0zomwRZOad9081jaKaH3Ccz9
         J0b5MrQqX3XU439nSXwxWJ+5J1qeWOjJefW/2A+O5JoXsA76mjLpcX5214Cb1PWzIKox
         UH0A==
X-Gm-Message-State: AOAM532OTXEU0g6d7oZ0RS74rzu7GkfIDhBrTX1gKRk4YDOESccgXxDi
        +byd4Icrhzw3Ux3o1Ox5Nx7vtErfHsB+aw==
X-Google-Smtp-Source: ABdhPJzI9lMkuzcLK8Fb5cnNz/tOm1zDNnaFo5P71BUKYZM/qwNfZWBSxmo6yPHwnjjuA9A15k84hg==
X-Received: by 2002:a05:6602:1549:: with SMTP id h9mr7865961iow.30.1640003930723;
        Mon, 20 Dec 2021 04:38:50 -0800 (PST)
Received: from bogon.xiaojukeji.com ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id h13sm7256414ilj.59.2021.12.20.04.38.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Dec 2021 04:38:50 -0800 (PST)
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
Subject: [net-next v5 0/2] net: sched: allow user to select txqueue
Date:   Mon, 20 Dec 2021 20:38:37 +0800
Message-Id: <20211220123839.54664-1-xiangxia.m.yue@gmail.com>
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

 include/linux/netdevice.h              | 19 ++++++
 include/net/tc_act/tc_skbedit.h        |  1 +
 include/uapi/linux/tc_act/tc_skbedit.h |  8 +++
 net/core/dev.c                         |  7 ++-
 net/sched/act_skbedit.c                | 83 ++++++++++++++++++++++++--
 5 files changed, 112 insertions(+), 6 deletions(-)

-- 
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

