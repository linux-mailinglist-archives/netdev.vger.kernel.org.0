Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808ED516157
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 05:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239086AbiEAD7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 23:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiEAD7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 23:59:34 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24263CFF5;
        Sat, 30 Apr 2022 20:56:09 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x23so4684262pff.9;
        Sat, 30 Apr 2022 20:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8xUHRmTVDR1DjSk98YnskoOlve6Vu1EC5fiKCriOJkY=;
        b=HsS1wGI7kJK8Tinb3WsBdfe1Up3XWhikgB78MaiiEdRodDXKeVEGmg83WbmznDCeAH
         +8JjjI/AU5l21PLFeF7XOV2QQl/yQmXnNPAnuGDxorMl19xP/Thj2tkltjt/XZu7FZ7y
         0hq5Db2EZis9ZbuFiqNGdDkE1dlLT9j7ELC+vTDZjxOvrmt99iaqX3/X/e6kHhIwqJjR
         oHA2y3GYDADcNevYNIsLrhN3GetzoMMO94Aw67BqCeEbTMmkMsTMW2+LMP61IPKRWZkb
         UNRUUhYaosmCNQ5q+FWjfiBU7inriNkBVqKRGumd8u/81VT3aScOw8xPPQ0OnzfYeHtB
         Ao8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8xUHRmTVDR1DjSk98YnskoOlve6Vu1EC5fiKCriOJkY=;
        b=wpKXxTGvwdjwparWPitSgGNXAx9IyT259Tj2DvWzyQ1QqWesRhGDwF2UuCCVvJH3x/
         m6qbxSm2rivEm3Pmto7yDi5AYdoLDzr6NYlkG5uLQ3m/hZAGqKGHHF5dIss60yrSnDQG
         Zz5gMYoZ1WxumcevwHMaNbGdZA+MKdZHN8+z+vlG15gkmY6HJ9loDQeo12/oWOrTUtns
         Z8kyyCzx7X08bUdZZKOyLiyQn8E7ryHPYpPpiSa/k0qiYz/LcnGpuynh7XW4XfMyqEbv
         stuuU9vDpGZy2QJPfVPr93fBpeCEgdnuJ8B32E1SkXg7RKzubCzs3ffOuRwUPcSb2I7P
         U6Xw==
X-Gm-Message-State: AOAM532L+BSqu8Je8OQkqHBlzVnleWcUgnyQuExyRDv0yqts7g5QIu2a
        fj7HnrEhtji2D2rqzskQlL6Df3Vjs0Lhzg==
X-Google-Smtp-Source: ABdhPJxOX3jnJbkz8H0iRAgOZHCk/tOzYTLFg1C8TuiDthQ6IwRIYal8mBPVDIunZvBkX4VZBVZQfQ==
X-Received: by 2002:aa7:8757:0:b0:50d:48a9:f021 with SMTP id g23-20020aa78757000000b0050d48a9f021mr5723346pfo.24.1651377368802;
        Sat, 30 Apr 2022 20:56:08 -0700 (PDT)
Received: from bogon.xiaojukeji.com ([111.201.149.168])
        by smtp.gmail.com with ESMTPSA id q9-20020a654949000000b003c1d946af6csm1767863pgs.32.2022.04.30.20.56.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 Apr 2022 20:56:07 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
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
Subject: [PATCH v5 0/3] use standard sysctl macro
Date:   Sun,  1 May 2022 11:55:21 +0800
Message-Id: <20220501035524.91205-1-xiangxia.m.yue@gmail.com>
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
 include/linux/sysctl.h                   |  9 ++++---
 lib/test_sysctl.c                        | 32 ++++++++++++++++++++++++
 net/core/sysctl_net_core.c               | 13 ++++------
 net/ipv4/sysctl_net_ipv4.c               | 16 +++++-------
 net/ipv6/sysctl_net_ipv6.c               |  6 ++---
 net/netfilter/ipvs/ip_vs_ctl.c           |  4 +--
 tools/testing/selftests/sysctl/sysctl.sh | 23 +++++++++++++++++
 8 files changed, 75 insertions(+), 30 deletions(-)

--
v5: refactor test codes. 
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

