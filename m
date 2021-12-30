Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31D6481B22
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 10:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbhL3Jc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 04:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbhL3Jc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 04:32:57 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F47EC061574;
        Thu, 30 Dec 2021 01:32:57 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id jw3so20785761pjb.4;
        Thu, 30 Dec 2021 01:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gh5d05SuRzZuRCOolc1Dq6lmmNP2GLelZWrZbJUqQMw=;
        b=kdygz1UTLG9gzOM9BzHie5nttyrluZENp1QfnAkZbCfQi43i6Ep1bicjiC6O0zuMba
         3y80c7axdrAWHyIPEu7rJUB5QC49wWuHRa+G4gQEPqg+7sa18EXfRuHXzRkp1KObyebU
         vfMvGPUw+9lQoIcatyzlrGQb8wN9TyWQMajMt/3Y3VIGOuNrSKi8Dv6sXqa5XydRdmsd
         j57x+o1nrjf2FRba7TMLV2BSxOLtMrU2VxqGJhFa8MEOs20iFlnJVb+LwHQ7ZHSi6UcL
         JgonXhu91tg/fyfS20ghr8FRgty9RDAl1IqQx3pJAFDjR4afaUuzUJyW+8ff5XBa+c4h
         hFTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gh5d05SuRzZuRCOolc1Dq6lmmNP2GLelZWrZbJUqQMw=;
        b=erbO0OaiFzxAssuwI5MCXW0GLCcarAriBdC/I3Xg4kr7ZhnVuPWYSokdDY81QRQCZW
         H+LTfwuy7lpMmY3vnLsuCCprGpOsL2sJxowSsDe4tRnwCdbrHULiqRBGWRy46/r31rDj
         AYwlfOVR7lD2dYdzx2umn56hnL4emGW9tBTKNXeagyXTVlY/7cFcnYYXN+rjFOr5VglP
         XtlBlDChzO4XdDTM3I/kTRHEYQshhMHIzoG/JgmgnQAKWWce3HXeKzGK0IoHlcoeS/Su
         zOzyhpPowFUFQ97VpP+p5/d1plBZw0FOR4L/mXh+f3hlkDzWSjwYkI7vGMMVqcNVckB5
         UdLw==
X-Gm-Message-State: AOAM530olWhCNfd3aSwUzYBVgAlZFUcuCHq4VvBVQe2hqPICuiuuZSd3
        ZAyVMBfhzWtcJ+QSsK9CuMg=
X-Google-Smtp-Source: ABdhPJz3cA3QuWW57dyXgeF8demFUOsq3Wh0GFd3+pSWvhrteTyprRIcSICypuQDwZ/M81ihsl2fMQ==
X-Received: by 2002:a17:902:b287:b0:148:db51:7da1 with SMTP id u7-20020a170902b28700b00148db517da1mr28946844plr.31.1640856776782;
        Thu, 30 Dec 2021 01:32:56 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id f4sm23231052pfj.25.2021.12.30.01.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 01:32:56 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        nhorman@tuxdriver.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        keescook@chromium.org, pabeni@redhat.com, talalahmad@google.com,
        haokexin@gmail.com, imagedong@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, weiwan@google.com, arnd@arndb.de,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mengensun@tencent.com, mungerjiang@tencent.com
Subject: [PATCH v2 net-next 0/3] net: skb: introduce kfree_skb_with_reason() and use it for tcp and udp
Date:   Thu, 30 Dec 2021 17:32:37 +0800
Message-Id: <20211230093240.1125937-1-imagedong@tencent.com>
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

Changes since v1:
- rename some drop reason, as David suggested
- add the third patch


Menglong Dong (3):
  net: skb: introduce kfree_skb_with_reason()
  net: skb: use kfree_skb_with_reason() in tcp_v4_rcv()
  net: skb: use kfree_skb_with_reason() in __udp4_lib_rcv()

 include/linux/skbuff.h     | 18 +++++++++++++++++
 include/trace/events/skb.h | 41 +++++++++++++++++++++++++++++++-------
 net/core/dev.c             |  3 ++-
 net/core/drop_monitor.c    | 10 +++++++---
 net/core/skbuff.c          | 22 +++++++++++++++++++-
 net/ipv4/tcp_ipv4.c        | 14 ++++++++++---
 net/ipv4/udp.c             | 10 ++++++++--
 7 files changed, 101 insertions(+), 17 deletions(-)

-- 
2.27.0

