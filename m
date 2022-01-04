Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351B7483AEE
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbiADDVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiADDVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:21:51 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7C3C061761;
        Mon,  3 Jan 2022 19:21:51 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id t187so17455299pfb.11;
        Mon, 03 Jan 2022 19:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dFMUSAeb8vweEkmUduhhQnElU1qKO0TXP2kzNy28XUE=;
        b=d+BFkedJPmwRpztrKhgy5P6Y0C2EZtI8Cjpr/OpIuQYjsW6FLhMSnKP7k/k5irk0RL
         aTHDhg/sAJ83rtkO4HKrb8RiyqrBzdyTkXBw4qU/gYwY+l3/QCIVp6T6sxPXMFBadj/9
         fSb/SxEC59nyWizuxZr/KxaQPLPsE4eiB5RCxOBME4eHvPORNpXxSGfZPtOFfhsfyZMt
         qDjaoJSIdBmHL+XRKd6lrYvFXdy3lfolSJt4wXtOFiRMMqnNUcSvSxliIMKcwPTGA/I+
         jyJOQpF8SOEfgR9ZGh2UTZ44s8o4NR5lo3faUDWF/niNKJoW/ZAtraO/CZ2FVvulE4w6
         furQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dFMUSAeb8vweEkmUduhhQnElU1qKO0TXP2kzNy28XUE=;
        b=MyURpAcAbHU/OzOrwgRiPvXPTOfxxEgHez5Npa6PHsARcXtd03wxcApelkBatrnVz1
         XiVp6xaedYp5yJjFOXnD6uCMcl92nKT3BM1PICrXOXXZOUtwUaGbVvLeXVrR4kAYb3ou
         48orJ61deXA9DrWdDngryvdrBax66wl0e2iCNK9Mx/kwxloXe3zv9wu6Tr8NrjrQ+ErB
         yEVmrKGNs1p6FUfwdcuPZm0KIIrmyRQgF7AuxpMav+hp8M1X1HN6Ljy3oHkJDf8eTFYM
         PvtVGSqN4o5dEJI8Y6K526QZKtLS9gk37Mi0RSmnAt7A8z7/KDKnhYpaDcqt5rh4p4eE
         SMqg==
X-Gm-Message-State: AOAM5330cmcMRk/1dEEzXeRSBpyY/pH4W3PmywdtHpgE1h6hzqiJtwBX
        uZnBAlahnkySFAALcQRXsD72ST3ltaA=
X-Google-Smtp-Source: ABdhPJwpGicmgDle2bL4jX+nOVr8WP79DhempzYQZoZvGbgEyYxbSil5F53MNKONJ8mIkNnQty8L4g==
X-Received: by 2002:a05:6a00:ac6:b029:374:a33b:a74 with SMTP id c6-20020a056a000ac6b0290374a33b0a74mr48850448pfl.51.1641266510842;
        Mon, 03 Jan 2022 19:21:50 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id y3sm36029078pju.37.2022.01.03.19.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 19:21:50 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, kuba@kernel.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, nhorman@tuxdriver.com,
        edumazet@google.com, yoshfuji@linux-ipv6.org,
        jonathan.lemon@gmail.com, alobakin@pm.me, keescook@chromium.org,
        cong.wang@bytedance.com, talalahmad@google.com, haokexin@gmail.com,
        imagedong@tencent.com, atenart@kernel.org, bigeasy@linutronix.de,
        weiwan@google.com, arnd@arndb.de, pabeni@redhat.com,
        vvs@virtuozzo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, mengensun@tencent.com,
        mungerjiang@tencent.com
Subject: [PATCH v3 net-next 0/3] net: skb: introduce kfree_skb_with_reason()
Date:   Tue,  4 Jan 2022 11:21:31 +0800
Message-Id: <20220104032134.1239096-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

In this series patch, the interface kfree_skb_with_reason() is
introduced(), which is used to collect skb drop reason, and pass
it to 'kfree_skb' tracepoint. Therefor, 'drop_monitor' or eBPF is
able to monitor abnormal skb with detail reason.

In fact, this series patches are out of the intelligence of David
and Steve, I'm just a truck man :/

Previous discussion is here:

https://lore.kernel.org/netdev/20211118105752.1d46e990@gandalf.local.home/
https://lore.kernel.org/netdev/67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com/

In the first patch, kfree_skb_with_reason() is introduced and
the 'reason' field is added to 'kfree_skb' tracepoint. In the
second patch, 'kfree_skb()' in replaced with 'kfree_skb_with_reason()'
in tcp_v4_rcv(). In the third patch, 'kfree_skb_with_reason()' is
used in __udp4_lib_rcv().

Changes since v2:
- rename kfree_skb_with_reason() to kfree_skb_reason()
- make kfree_skb() static inline, as Jakub suggested

Changes since v1:
- rename some drop reason, as David suggested
- add the third patch


Menglong Dong (3):
  net: skb: introduce kfree_skb_reason()
  net: skb: use kfree_skb_reason() in tcp_v4_rcv()
  net: skb: use kfree_skb_reason() in __udp4_lib_rcv()

 include/linux/skbuff.h     | 28 +++++++++++++++++++++++++-
 include/trace/events/skb.h | 40 +++++++++++++++++++++++++++++++-------
 net/core/dev.c             |  3 ++-
 net/core/drop_monitor.c    | 10 +++++++---
 net/core/skbuff.c          | 12 +++++++-----
 net/ipv4/tcp_ipv4.c        | 14 ++++++++++---
 net/ipv4/udp.c             | 10 ++++++++--
 7 files changed, 95 insertions(+), 22 deletions(-)

-- 
2.27.0

