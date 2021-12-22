Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD6E47D183
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 13:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240420AbhLVMJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 07:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbhLVMJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 07:09:25 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08E9C061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 04:09:25 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id jw3so2095993pjb.4
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 04:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H+kXtJN5JJLYKoRL+qD56ox9HqWFLkIJqJ3Ly2YFzJ4=;
        b=Id9RmZoeR1NZZI7Aglru7Sm3y5eZhT50jNTvBDNV0BoqzuxaGDlKbtEzqRdmWAgwu8
         UOay/f8jaaRTe8vnt1vucFBod/SYyyDWNBesi0Atam7fpCwO9kDMV23EMLrEoKeNpO6U
         Ld38uxU729yfikNKUUHxgIMfr5XQZhzFAqwCv/x9hcoDHzuZf+0IpKQDvyT8apbRl9kJ
         EnRN4KEZiU4uT89MbuUQI9T5OhMoBqnrNQHbrkQr2q7vqXZJven8IaeInJRuNxEWjtjZ
         e6BChK5Mnn8xrv+6DHY0unHB0QiHD6iT2KuNAVQdjunGeZC85BLCnxo77sGmjTXU4UTG
         P47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H+kXtJN5JJLYKoRL+qD56ox9HqWFLkIJqJ3Ly2YFzJ4=;
        b=bv3lM5zr4e8115oibivqpog3UjfcWVy4+rPVGdkF1EDbb3dfX3dGAy5+KPdUvOycqR
         zbAaXThujqFTpUqpRJThj+TLN7iq1x63TZhvkLw+VaHKq0XYUSI0Mp/Z/KlqJ3rZJR7w
         PRWlEHiTlLlnsbdZJycFO76yuuUgumD1bGxi3XR1IpOI3pYc0U0IraHsTqAIkLZSor7i
         so3R3A2ZReX22Ext+UksiqrTk+zQcRbC7EQbaBlcPtrTz8OIdT/r/FBIjYBXHDusex5N
         dNC2Z7qWuogXYqj6mrcVi0InBakgVPtbP5clFFEyRzs55b93DMltDe1RPJYtOqIBYVcl
         laWQ==
X-Gm-Message-State: AOAM533IAE2BCS92knVrvIMkTLE02CYdUyjKXmrONY1Q5NN7SbrmmufY
        ef6FRJ55Mgt3kaAwwWjHk901vuPb+THeXA==
X-Google-Smtp-Source: ABdhPJwgBQ0dRWQ0s6L6e5XyDe7g1wumCiTIBk0UXE/KL+bKsnte3hDVuZxFVF+/ZoC38RY65miPvw==
X-Received: by 2002:a17:90b:4ace:: with SMTP id mh14mr1004142pjb.164.1640174964962;
        Wed, 22 Dec 2021 04:09:24 -0800 (PST)
Received: from localhost.localdomain ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id y128sm2598517pfb.24.2021.12.22.04.09.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Dec 2021 04:09:24 -0800 (PST)
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
Subject: [net-next v6 0/2] net: sched: allow user to select txqueue
Date:   Wed, 22 Dec 2021 20:08:07 +0800
Message-Id: <20211222120809.2222-1-xiangxia.m.yue@gmail.com>
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
 include/linux/rtnetlink.h              |  3 +
 include/net/tc_act/tc_skbedit.h        |  1 +
 include/uapi/linux/tc_act/tc_skbedit.h |  8 +++
 net/core/dev.c                         | 44 +++++++++++-
 net/sched/act_skbedit.c                | 96 ++++++++++++++++++++++++--
 6 files changed, 149 insertions(+), 6 deletions(-)

-- 
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

