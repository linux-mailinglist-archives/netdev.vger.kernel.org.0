Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8C64D8687
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239542AbiCNORI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 10:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiCNORH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 10:17:07 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7605219C12
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:15:56 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so14708202pjl.4
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QHuV080a1M26G1DkAzwCuk0vosgeIuubIhEkCn3FFY8=;
        b=MvIfgX2ND/aUHxR8QyNofBViBb9fKyXpV0e9xU5o7YXzGkYo1ni3TZ9P8f6QxvMHIr
         hvsI458gUuge/2D0Jatjw/Hz5MDwP3nLpMyywgEfO0LIpfFs7bf09+1I33ncwMORhy2g
         ZUz78Jd5QKbWcUvfAYmdES9A9tTD8b6qmSYP8bF0+BgJJplX5N13O0WdhQnz88C2IU24
         DeVHwp5jJG/gqku1aFZ6MbZCK2UxJMIwWI8AQEENiTjTCV2qpx3MoGKuVyk8PbjX6ygp
         h8X39o2UCi5aAGgdDF/7rstKmoSQVNEQAlcu/y4oVy3lvbjFiU3aJJmbYShy7z8Jyuqi
         bNlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QHuV080a1M26G1DkAzwCuk0vosgeIuubIhEkCn3FFY8=;
        b=0UFFKbIq4NFUXYsC/+H3A0OP45aoyTwBwxqrhmBqxkgTEiRRtVpYjna2sH+TQbR+yN
         gOWdNAFT8ycMA/mgWxGVX7SxuteRuUK0BXcci1xGcWZFrq1RvxV2SntLV8rK1jCrG0yE
         51Mu/6pt3OXtOGISEhPWEy+ceVQKf3TrUmGPyGfVvY31eaqpuIQwk7p3Yg1s21jpOGfH
         ARMUjJyK6iwmikIkavBOqEPYM7B7TRbBollWVA1eZA38zve7jergOce/SGjRaawSjGSn
         EOQ775g3cgLHse/owDEugP/3bBjzbaikCk7wLfl8brk8soNMe/+KxwvkeRglCmS5BGO/
         TTwA==
X-Gm-Message-State: AOAM532sQ5BfrxVaWqYsNelmyxwO1Bi4JDthm6+nA/8P1gkqmw7eFalB
        zxyphyuYdzrgkjGsM6znPMiN1uzQ0UCIRA==
X-Google-Smtp-Source: ABdhPJyP2B0UuEuRBclDVcWbw+y3A+7JRQGhqyByR9DN3qT58avuA9irW7frnfWj/F+vjcHzChWBBw==
X-Received: by 2002:a17:90a:bb0d:b0:1bd:3baf:c8b4 with SMTP id u13-20020a17090abb0d00b001bd3bafc8b4mr25653425pjr.15.1647267355671;
        Mon, 14 Mar 2022 07:15:55 -0700 (PDT)
Received: from localhost.localdomain ([111.201.151.228])
        by smtp.gmail.com with ESMTPSA id oa12-20020a17090b1bcc00b001bf430c3909sm22540430pjb.32.2022.03.14.07.15.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Mar 2022 07:15:55 -0700 (PDT)
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
Subject: [net-next v10 0/2] net: sched: allow user to select txqueue
Date:   Mon, 14 Mar 2022 22:15:06 +0800
Message-Id: <20220314141508.39952-1-xiangxia.m.yue@gmail.com>
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

