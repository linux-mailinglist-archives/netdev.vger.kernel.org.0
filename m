Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2558246F93F
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhLJCkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 21:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhLJCkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 21:40:21 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6A1C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 18:36:47 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z6so5319272plk.6
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 18:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=udWhqJD4/5aBhSu5Lz5ZQkSIV7edHIXSn0u47KzkKmg=;
        b=QPM8tHpw4+QB8na71lXi3+iOsnsQc64vGhttibs+8/pp6i2NVaB1hSssOcHl1Pk9vl
         x7cVtJhfmJ75QR709pA2/wciHk7/cYtpc9y/0VL2JYWe2bZWDc1+iDeWtlNFIuIT/Kds
         mhMxhbs/PCaivdPL2irQ5g2ErOjC+a9SnBoXfop0fcOMr/AAhCJZukGIsdelYZcRZpCo
         9p6RXq5tuWskr0EvgxPimvFbv3Xz4tjBwb8gXSwumyXUiUn+BtVMDLN91n65LKMkOiro
         sQLJCL0BVOdsymYguTejn1REIKtY0i3EQyE2tWmOWruLYmegNqU0homDJMrOeWSt/5j3
         hbWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=udWhqJD4/5aBhSu5Lz5ZQkSIV7edHIXSn0u47KzkKmg=;
        b=JKZ2qG07G+kzuEyvkcanEwGNx8Ly8HoPIowmmR1T33HOM0CJgWD8erLJ6N48W/zZpK
         pDZEKqRDv4EBtsBDZQR+SSXYfOqgD7OnWwXsIIu8nK3+Caqrpvm88LgxaCBLVdMr+F46
         E8hxjCAYYwXrZTgzTFETY4uYjPgcW7rh/OV0FePVFAf7di/i+XXzaSvnQc1NmxkRqeG6
         RUTTuX8Cgue2KAu16glz+NQwXJw7gp5dGPi6hhYm6c6dvbS2h3DjmmqWaMsmQjvfGQ90
         V5NVRxjnylI6Wqk6lebGvxuTH2QtH8mW6eY6dM8AFfro6gegdpWWBZrxdhRKXHNok8oQ
         wKGg==
X-Gm-Message-State: AOAM530FCQSI12MJNG9ar2uME0+q/0wkP49B8vu5ykzr6a/Q2QPideHh
        eMnPVk3PlTh0Yupuxp8rJBEUK27yzsLCZQ==
X-Google-Smtp-Source: ABdhPJwurBiU8zU5WZZOZD2avV0Jo71FxmVWNV2hM6lek/OkGmaghXemsLc/P31L2cjw0XtiPEdayA==
X-Received: by 2002:a17:902:b411:b0:143:6fe8:c60e with SMTP id x17-20020a170902b41100b001436fe8c60emr72299633plr.41.1639103806556;
        Thu, 09 Dec 2021 18:36:46 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.100])
        by smtp.gmail.com with ESMTPSA id g17sm861677pgh.46.2021.12.09.18.36.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Dec 2021 18:36:45 -0800 (PST)
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
Subject: [net-next v3 0/2] net: sched: allow user to select txqueue
Date:   Fri, 10 Dec 2021 10:36:24 +0800
Message-Id: <20211210023626.20905-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Patch 1 allow user to select txqueue in clsact hook.
Patch 2 support skb-hash and classid to select txqueue.

Tonghao Zhang (2):
  net: sched: use queue_mapping to pick tx queue
  net: sched: support hash/classid/cpuid selecting tx queue

 include/linux/netdevice.h              | 21 +++++++
 include/net/tc_act/tc_skbedit.h        |  1 +
 include/uapi/linux/tc_act/tc_skbedit.h |  8 +++
 net/core/dev.c                         |  6 +-
 net/sched/act_skbedit.c                | 76 ++++++++++++++++++++++++--
 5 files changed, 107 insertions(+), 5 deletions(-)

-- 
v2:
* 1/2 change skb->tc_skip_txqueue to per-cpu var, add more commit
* message.
* 2/2 optmize the codes.
v3:
* 2/2 fix the warning, add cpuid hash type.

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

