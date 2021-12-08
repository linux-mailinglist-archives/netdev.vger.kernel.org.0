Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D7346D5C9
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbhLHOiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbhLHOiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:38:05 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0496DC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 06:34:34 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so2218931pjb.5
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 06:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JiMxXfwFQVy058HhBl4ULd5pZfNVZIt/MP4aanz/XFc=;
        b=HF57WHN8P2w5064Kigm1VhfrZ9atfoKcmwRMGJE+HMxNkXpSbaCKTbJj7TNMgLqfmN
         OF9tg8tJWAgKjauWNjztoNPiHXZqT4jV4kbUe7d05fxZgA4ZrATVlklVZL3LA5wcbOpF
         j8nPNP00PaqrOq23fsPXtaYeq0SfRrHOHrU+iZT85WPd0tF0p9OKWhxrxxQhAf8VhSgH
         TDJs0pTuRxLRwr5e98uuAiPQ8ZOMQnXUIoJoG/XA1S7KN8lJjvtilez0KAM1o1QLVCsy
         VUaHzh4TPLqK4buw20+CVf4F0aW9AcfiFFUAevXOplZB2cWNb3CAFWPm80+C2c4HEL7f
         SU/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JiMxXfwFQVy058HhBl4ULd5pZfNVZIt/MP4aanz/XFc=;
        b=qFRL6uV1WctXS/9TxqCbALfGaOQqWdYsIIweW4lbYFoltvA8+nLbkHPCHll5GinOpw
         zfeVv+QroYwKOogVOLe2LMhx9tqwfLOJKjDBkR0zuFEuuQ0mqEZbT+3gQsBpqWszj64t
         1sq671yGbaCj9v9QglFMbBhdmqksw1RCFRmDVoxwyMch4k2colWFAWltvkmNYraXV8n2
         m2DrZoqwyZRt8Kv4eFaflk9ir9oLBonT5KX2eUFZTJWftCbccVBphEFkWzBzEPqQrX0L
         xLoyMYkJhs+RRjvFeNxPH+zhRlH/ci8e0aXPM6UpBDInECv/bVzxnoT9wA2u7/gdjYvZ
         gWnQ==
X-Gm-Message-State: AOAM530U3sVg3c+Azc2FirCm5K3LzgpPxT8BnsZqb6DHGb8o9M1R5bCc
        qElQXJP/DpYckPB4EkQBNfUwTJJfEYFegg==
X-Google-Smtp-Source: ABdhPJx/FqjbILOA8CHmE7UaiLvV3CL/9li11TnzeYLOksLfDOZiFR7tJkNodjCfkNwcogG6NgJzfw==
X-Received: by 2002:a17:90b:3758:: with SMTP id ne24mr7654507pjb.59.1638974073249;
        Wed, 08 Dec 2021 06:34:33 -0800 (PST)
Received: from bogon.localdomain ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id g18sm4160123pfj.142.2021.12.08.06.34.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Dec 2021 06:34:32 -0800 (PST)
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
Subject: [net-next v2 0/2] net: sched: allow user to select txqueue
Date:   Wed,  8 Dec 2021 22:34:06 +0800
Message-Id: <20211208143408.7047-1-xiangxia.m.yue@gmail.com>
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
  net: sched: support hash/classid selecting tx queue

 include/linux/netdevice.h              | 21 +++++++++
 include/net/tc_act/tc_skbedit.h        |  1 +
 include/uapi/linux/tc_act/tc_skbedit.h |  6 +++
 net/core/dev.c                         |  6 ++-
 net/sched/act_skbedit.c                | 60 ++++++++++++++++++++++++--
 5 files changed, 89 insertions(+), 5 deletions(-)

-- 
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

