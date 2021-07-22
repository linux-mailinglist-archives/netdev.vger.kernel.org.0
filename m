Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CAA3D1F63
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhGVHPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhGVHPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 03:15:01 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D54C061757
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 00:55:35 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id gb6so7085408ejc.5
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 00:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v+DfCmABxdysmYgQH/qoOzyhuZQqudm8VScowG9ifJY=;
        b=zSULqyvMBoWxhRvpRPECzDUBPNja+yrLfBvyVs1qMway9XnAPiq+eG6/Dxy8gLnkcK
         swa6CGMR4l17Ju33YLdunWJD6bdAe7ZQS39D0BrJOXwWWCwkJHTx47W5T4nfpuRTI+85
         eRxn7vAXwvaJ38BqX6kwKsOKmrSI8aEv1oP4yVv5WvuBE5B3uQQG/bC1KxsSkR/4YxN7
         a2y5PyzJQwk5uZNWB4MV1F5tJzPT4nFwxANDQYaQfsFKusbAqSYfH1OGUVmw8edQE9jU
         lLFHtR4y2iRo2pQzZNVNPNFnB6OvYDkF2m74BQOxS5h3/Gy5u64nO7qRGYzqDJuXLsGk
         T4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v+DfCmABxdysmYgQH/qoOzyhuZQqudm8VScowG9ifJY=;
        b=R4IA5TDvdNHX4ygJKsg+PTwAF7YpVhCYnl//A9NGO0l2D6CUnXDBy7vviL4kOIq2rJ
         +/5vz/Gwq6NNI9BBws7T4JKhjz8DQ0v+iAd0qb70ItpdzzpKg04t+9hpl1nlelEpOVoo
         glVmZ65qyv4W0Mj74Ar05dWE1DDcYdZ58mECpnH9NsmKSvjlDcscBCI5Umkw/p8xVgxO
         ZPHnUiJ26+Fb4hsdPubOyzCZiZpphw6dxsfDrtb7oqFn+/bwLc79sw4Sm908GAfk6ZCf
         JJUJkoXHHzLumQ9tbearV3sdSdFNlxGMrnxMS4KdobWep3DamQcVWTPLInAi+0H7u95p
         XSPQ==
X-Gm-Message-State: AOAM533Mo7pIhyC5BLbIPdMFo3XZNJWQQIaGufJmCEXEsPCwV/tDfW1F
        gZ2KN7Z517IQhrJeXp4C4DcAwA==
X-Google-Smtp-Source: ABdhPJzhf9hwE+529bKrGZHmKBc2sLUv6JjfAUMAad5Wm1SBJesaOtPDZseuT3IXsTfPmReJIA3ZRQ==
X-Received: by 2002:a17:906:a08d:: with SMTP id q13mr41518508ejy.465.1626940534015;
        Thu, 22 Jul 2021 00:55:34 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id a25sm11859212edr.21.2021.07.22.00.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 00:55:33 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Justin Iurman <justin.iurman@uliege.be>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] ipv6: fix "'ioam6_if_id_max' defined but not used" warn
Date:   Thu, 22 Jul 2021 09:55:04 +0200
Message-Id: <20210722075504.1793321-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compiling without CONFIG_SYSCTL, this warning appears:

  net/ipv6/addrconf.c:99:12: error: 'ioam6_if_id_max' defined but not used [-Werror=unused-variable]
     99 | static u32 ioam6_if_id_max = U16_MAX;
        |            ^~~~~~~~~~~~~~~
  cc1: all warnings being treated as errors

Simply moving the declaration of this variable under ...

  #ifdef CONFIG_SYSCTL

... with other similar variables fixes the issue.

Fixes: 9ee11f0fff20 ("ipv6: ioam: Data plane support for Pre-allocated Trace")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---

Notes:
    Please note that this 'ioam6_if_id_max' variable could certainly be
    declared as 'const' like some others used as limits for sysctl knobs.
    But here, this patch focuses on fixing the warning reported by GCC.

 net/ipv6/addrconf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 1802287977f1..db0a89810f28 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -96,8 +96,6 @@
 #define IPV6_MAX_STRLEN \
 	sizeof("ffff:ffff:ffff:ffff:ffff:ffff:255.255.255.255")
 
-static u32 ioam6_if_id_max = U16_MAX;
-
 static inline u32 cstamp_delta(unsigned long cstamp)
 {
 	return (cstamp - INITIAL_JIFFIES) * 100UL / HZ;
@@ -6550,6 +6548,7 @@ static int addrconf_sysctl_disable_policy(struct ctl_table *ctl, int write,
 
 static int minus_one = -1;
 static const int two_five_five = 255;
+static u32 ioam6_if_id_max = U16_MAX;
 
 static const struct ctl_table addrconf_sysctl[] = {
 	{
-- 
2.31.1

