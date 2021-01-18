Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA40F2FA357
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 15:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405021AbhAROmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 09:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393044AbhAROkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 09:40:31 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB05AC061573;
        Mon, 18 Jan 2021 06:39:48 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id y12so9659039pji.1;
        Mon, 18 Jan 2021 06:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Znq43C1QiqjzcyuUOeStYnW92t2pIVByidIABbhc2m8=;
        b=g7ERcJiDiD4Q6E7bPqDW16AQo/KtsZykTHvj3exLi5DxhmnE64Dl1Frpag8IcHXqQ3
         8xdQMGPB8co4wGYqmQVJqH/piNkW0S48rIGDrjaAplq8ve4amzI4ZzboQWCveXdaSVpV
         smPDjMGC+8lGzAKWrYZX6i0fk6NlO/gQ81Y7vi2fGK8A7etChV17RFfkrvzfkR7bVqb2
         HZkjE/fllfGVCpXqmlpS8OOrN7uuksnQzkHaEhcyBrOyJlw9o+Fv7o8brSe32NuRaFA5
         0c0UksreB6ZXv42tbgi5y+PSOZaM7kME6VmRiquvElEbJ/D1sxA0SMTBzNRhC5RvJ7H4
         RxLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Znq43C1QiqjzcyuUOeStYnW92t2pIVByidIABbhc2m8=;
        b=m49Fu6wTE4ywneXCgeXnyrLJt/jyxYSg4CMwZoK5ob/0J5TkR2Zh50ETZi8ut++MFc
         /DscG0HKb1HzZlSCK5Bs3ChCpTtOviB/3GBsqMK/X+35vhTQUuF+p1Epg47JWDunY+Uu
         B3lDn6tq1gl8N4KXUAAyxGqvq4Q951zBp6mh2lzyCOOuUOl1CrmWtasrts5HVzUHPILW
         HS0Hf62NVMouJbnX+xfrRc9oaQeDHMEKo6iK+eIjARZiYDxWobbNKhayPqGTTLlTJXfW
         SbJltW+h0GfRCBkPojibeXkQR/3bx/JYOCbeFybXZJhVZdo/17/c7vMbvGSXg/i5oVGl
         zrIw==
X-Gm-Message-State: AOAM5304/2TW68TAq5eQFTvFZEhMS0g4MgseI3+3/POwX6+J2CYvKKE1
        3hO2aNbR0i1j/dKcsqjZ1jY=
X-Google-Smtp-Source: ABdhPJzSFHOoVdG2W58N9+KkZwqdIsdoVwMeuxEfevpBLeK8rai1JQnfUsvzuuD/pVJxz1YuLcFS8Q==
X-Received: by 2002:a17:902:758c:b029:da:a6e1:e06 with SMTP id j12-20020a170902758cb02900daa6e10e06mr26497879pll.67.1610980788215;
        Mon, 18 Jan 2021 06:39:48 -0800 (PST)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id gl6sm2756805pjb.3.2021.01.18.06.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 06:39:47 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org, christian.brauner@ubuntu.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dong.menglong@zte.com.cn, daniel@iogearbox.net, gnault@redhat.com,
        ast@kernel.org, nicolas.dichtel@6wind.com, ap420073@gmail.com,
        edumazet@google.com, pabeni@redhat.com, jakub@cloudflare.com,
        bjorn.topel@intel.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, rdna@fb.com, maheshb@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] Namespace-ify some sysctl in net/core
Date:   Mon, 18 Jan 2021 22:39:29 +0800
Message-Id: <20210118143932.56069-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

For now, most sysctl in 'net/core' are globally unified, such as
sysctl_wmem_default, sysctl_rmem_default, sysctl_wmem_default,
sysctl_rmem_default, etc.

It's not convenient in some case. For example, when we use docker
and try to control the default udp socket receive buffer for
each container by sysctl_rmem_default.

For that reason, I namespace-ify some sysctl in 'net/core', which
are sysctl_wmem_default, sysctl_rmem_default, sysctl_wmem_default
and sysctl_rmem_default.

In the first patch, I made some adjustments to the initialization
of netns_core_table.

The second patch make sysctl_wmem_default and sysctl_rmem_default
per-namespace, and the third patch make sysctl_wmem_max and
sysctl_rmem_max per-namespace.

After these patch, sysctl above are pre-namespace, for example:

$ cat /proc/sys/net/core/rmem_default
1024000
$ ip netns exec test cat /proc/sys/net/core/rmem_default
212992
$ ip netns exec test2 cat /proc/sys/net/core/rmem_default
2048000

Thanks for Christian's patient explaining to make these patches a
single series~

Menglong Dong (3):
  net: core: init every ctl_table in netns_core_table
  net: core: Namespace-ify sysctl_wmem_default and sysctl_rmem_default
  net: core: Namespace-ify sysctl_rmem_max and sysctl_wmem_max

 include/net/netns/core.h        |  4 ++
 include/net/sock.h              |  6 ---
 net/core/filter.c               |  4 +-
 net/core/net_namespace.c        |  4 ++
 net/core/sock.c                 | 18 +++-----
 net/core/sysctl_net_core.c      | 76 +++++++++++++++++----------------
 net/ipv4/ip_output.c            |  2 +-
 net/ipv4/tcp_output.c           |  2 +-
 net/netfilter/ipvs/ip_vs_sync.c |  4 +-
 9 files changed, 60 insertions(+), 60 deletions(-)


base-commit: 5ee88057889bbca5f5bb96031b62b3756b33e164
-- 
2.30.0

