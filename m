Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8873C502DD1
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347321AbiDOQmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351468AbiDOQmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:42:25 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB995A15C
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:39:56 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c23so7549567plo.0
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WLbvMdFUjeOsEVw2kQd/JFDkXOsqqWVeP/u+VlXoS7E=;
        b=CSYqK+kbErrShISrcVLb1WCuakgRD6dK/xZCGa+ns+eTa/lsQx1qm/++9HO8rt3ELn
         GrPKEQYDp7wq8V6mncQdkDPsxsYo66Quni2mTjULThAIgHuSoSknPkz80BP3I/ZtSJAY
         EdoIGydyQPz9eT2flzRfMRMcEqxrs/ypn/O6+lYIw9mhKOcnQ0w+vE9H5u+Xw1lxr+ST
         vN7JayZD9doeaUf74bb74Uo4VPtq1vpFa4yy/DRaBS6rfxb8vlsFhw2LOhJvgbvKQNkF
         eubBHhMls/b8arZwrUvpCx3kre5HPXCdDDC0A+X0/nte/8xIEhx2hHhxSgOdANo9YRa8
         2x1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WLbvMdFUjeOsEVw2kQd/JFDkXOsqqWVeP/u+VlXoS7E=;
        b=MKxxMfBsMbXLCWImfdJVJAtkMfg310ib8xK/BXLHkGG+1Ec025XTAt3BWNzWSeQ8rC
         GbT64/LxoqhNMnUWgRmyKGSI5HFJyYRvP4B9E/jBitVrYW8FfFGoy4sm6vfGT0WMTQE6
         eXcSvv2HmlnWFaPIrNW6UA7hb/ege6HShSw/gf3o3GAKXgZhjuWEzYZVWjSCWIVtb0Vo
         sP49qvH25IJcfZ5wMAk2rFEEIz5bCzng0IuuoRLFNIsHar7t5IhBL1JXd3fZPWfMaPyc
         bdJwW6iUTvo8JJMZsjkD9u2Qypbpc+C5Gl+WkpIBr8e3zQq367CZ9aoxY7YzGj20xKNT
         AeSw==
X-Gm-Message-State: AOAM533T3rZJGV38QxecnvPTCMLS7ksW/X1h/efzR9KGqJNlQwnIWGk+
        ZM161ebG5DWvbbenpwnvxpiliNYZEt7xOLpD
X-Google-Smtp-Source: ABdhPJykHqJlN/77ORftaOJmjXDniBCNmH12G5XFmcsGqSMMlg7bw5v5qHpFWU5GZNEVcxrBI3+MSA==
X-Received: by 2002:a17:90b:4d89:b0:1cb:b402:fadf with SMTP id oj9-20020a17090b4d8900b001cbb402fadfmr4956793pjb.29.1650040795719;
        Fri, 15 Apr 2022 09:39:55 -0700 (PDT)
Received: from localhost.localdomain ([111.201.148.136])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090a154d00b001cb5f0b55cfsm5598077pja.1.2022.04.15.09.39.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Apr 2022 09:39:55 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: [PATCH v3 0/2] use standard sysctl macro
Date:   Sat, 16 Apr 2022 00:39:10 +0800
Message-Id: <20220415163912.26530-1-xiangxia.m.yue@gmail.com>
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

This patchset introduce sysctl macro or replace var
with macro.

Tonghao Zhang (2):
  net: sysctl: use shared sysctl macro
  net: sysctl: introduce sysctl SYSCTL_THREE

 fs/proc/proc_sysctl.c          |  2 +-
 include/linux/sysctl.h         |  9 +++++----
 net/core/sysctl_net_core.c     | 13 +++++--------
 net/ipv4/sysctl_net_ipv4.c     | 16 ++++++----------
 net/ipv6/sysctl_net_ipv6.c     |  6 ++----
 net/netfilter/ipvs/ip_vs_ctl.c |  4 +---
 6 files changed, 20 insertions(+), 30 deletions(-)

--
v3: split v2 to 2 patches
https://patchwork.kernel.org/project/netdevbpf/patch/20220406124208.3485-1-xiangxia.m.yue@gmail.com/

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: Akhmat Karakotov <hmukos@yandex-team.ru>
--
2.27.0

