Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6116D50B101
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444622AbiDVHEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 03:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444623AbiDVHEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 03:04:44 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910A351307;
        Fri, 22 Apr 2022 00:01:52 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c23so8939416plo.0;
        Fri, 22 Apr 2022 00:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bT7aUnHeY5YfyEHkExxzQfXigU0gyQnOZB/axxwQXVQ=;
        b=OMWSawvjf5J/4BUg253mdu9NqgB9+P/t0IF2U58nyM9d9ezcejJOn1ZWAyQgJvNIY9
         fWaIBp3BHNBAcjPpn19E0eSwpSLzQyzFCvD86R7FOj0+fTV6s17Idl4Dwq2Sxy1eYISw
         9DAMOh+6Cir700P7Qtv7sQffgm0prAtdmAxKJ14YsBtd/WlzshE2dAOLeQ52GFVJsy5V
         sda+64WdvEPlcPMANt4ziJntm6CPS/5ToqVrhYPttRmomEity6SCYjwOkqRV5lAq12rG
         uumCb0pRB6+pfTZt4Yhoz0FgOxOlXHr3aaZpaNbLTRpWztXbH7qH4usfWTawSSFeoIBU
         eaVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bT7aUnHeY5YfyEHkExxzQfXigU0gyQnOZB/axxwQXVQ=;
        b=27e3KMtq0aOuT6tjbZSEkbjk6uGrwJrZ0nb+zB4i/JHQzZ2PzFCrZQxtNmKc1dGnKM
         JdyNNOMv1Gqt1gbxsvDjMz7+nfGZ51Fh+hXI0Z7TTK/nD6TAl1kCKnqVBkmRk+YsI2xa
         9a80HWVCZIIN0wZnRL1QwuWgrGXFHbDuFQhku4iGog/licNF+bWqa6JzS9sGCQgFu2Gt
         IGrtBKXocYLvXjFjaJqSrawOFwcGuf/jLCDAPQC+N1UMHabdYkSM2+mfoodR65xI4zak
         iqCJtxnd/zryjwDe61IkyljlXIHcWJXgbdrqBQvbFwq2Jot5zSEgVn902qMCBGIBpjnO
         /njw==
X-Gm-Message-State: AOAM530lSysFJskPZjhe7ofq5Pu05x3cBaOrWXRIVwZm1KyXzqQVx/kI
        M8XRLX1SxuKM9VA9zgOBJSu6D865fnB8rg==
X-Google-Smtp-Source: ABdhPJzM6cvVXpCyu6eggMeizULTu0yo5EgOqzxTgU4Gtomn2MLvl0/7Oxa6iTGW5nx3ndswltWWVA==
X-Received: by 2002:a17:90b:2790:b0:1cb:5cb5:f8ab with SMTP id pw16-20020a17090b279000b001cb5cb5f8abmr3834734pjb.190.1650610911772;
        Fri, 22 Apr 2022 00:01:51 -0700 (PDT)
Received: from localhost.localdomain ([111.204.182.100])
        by smtp.gmail.com with ESMTPSA id 10-20020a17090a1a0a00b001cd630f301fsm4873467pjk.36.2022.04.22.00.01.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Apr 2022 00:01:51 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: [net-next v4 0/3] use standard sysctl macro
Date:   Fri, 22 Apr 2022 15:01:38 +0800
Message-Id: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patchset introduce sysctl macro or replace var
with macro.

Tonghao Zhang (3):
  net: sysctl: use shared sysctl macro
  net: sysctl: introduce sysctl SYSCTL_THREE
  selftests/sysctl: add sysctl macro test

 fs/proc/proc_sysctl.c                    |  2 +-
 include/linux/sysctl.h                   |  9 ++---
 lib/test_sysctl.c                        | 21 ++++++++++++
 net/core/sysctl_net_core.c               | 13 +++----
 net/ipv4/sysctl_net_ipv4.c               | 16 ++++-----
 net/ipv6/sysctl_net_ipv6.c               |  6 ++--
 net/netfilter/ipvs/ip_vs_ctl.c           |  4 +--
 tools/testing/selftests/sysctl/sysctl.sh | 43 ++++++++++++++++++++++++
 8 files changed, 84 insertions(+), 30 deletions(-)

-- 
v4: add selftests/sysctl patch
v3: split patch to two.

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: Akhmat Karakotov <hmukos@yandex-team.ru>
--
2.27.0

