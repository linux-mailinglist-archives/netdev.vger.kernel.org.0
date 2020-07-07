Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862A2217A1A
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgGGVQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgGGVQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 17:16:21 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3514C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 14:16:20 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id r19so647890ljn.12
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 14:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yVM9y9INzp36vC+ISPo8ASS2DTBcajB2IABJ1uZNdJ0=;
        b=DXbe5b4ksc95KUxF8hv5LIgK5mToC+8rb79PhJH+lMMHJ+Y2E/9jiXl7ePbvuwq9Dx
         yagWUCAmkWOLG5XgRAgTbyoqGcSdXashYSpg3bkZCUZYpculVaHBdwWz21LlL2Q3Yumr
         08q9NdocXnhGW9CMyL2KU0gYLWW+uEqFtDR0mI0UYOy7YTrb4yNAq801Nbhy/SZdtpLE
         3OHh+AzK4DUttwy7hk6jvSRIULhbQTBTMMtEMzLqHMMkNhzv3QBezOrrF0A8KmJV3fqy
         SARGmh1hj+dUd0mbhibA8SBbgN268tEKWKbPh70jUPwajlUerIfJvSgsym++E5UA3sok
         BbFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yVM9y9INzp36vC+ISPo8ASS2DTBcajB2IABJ1uZNdJ0=;
        b=lL/58CgTsNXBp95+HyTd8xMEpB3pel6B/FPjHiW6n6et2MZm4zPqbW2xtIoylex2qh
         RxfN4MHh7cvjbrTzlhLsIvXXn3iyhyyX7eDcmvh3xEoJwg711VWodPhY3eVGpBHy7/+v
         p4TaAtOwYbOLZERELX0+ucYk8Aatk6DrVWAn9rb5GvJ3m8uAj2Ngsay0v5XDm5fAqv9z
         BqYGCcd9izHtnxqPy1JzvR1xNThvYXds7BEwb3Lm6DPbo4bqR9yYpZ4Hcs85wFiTx33o
         iNolaQU7GoyJ/PIdv/u5p79BpH49cHtLDFWZ1ec5sfFQ+D5flN2iI72Wiv9A4Isv7dzJ
         /1bA==
X-Gm-Message-State: AOAM530s8/TEk0O9nNNLy4jH4slAn7tJNKPv2L8PreCLc8Y5aAWYp7wQ
        T3D67Rus0n7wj1mmrXULTKyiig==
X-Google-Smtp-Source: ABdhPJzBbDP62jEPZo4/koK1lq3k+ZAZHG/DrbrYNhMekztH0Ev3MEHEhIhXtXhxT9NG9Hq+29qm3Q==
X-Received: by 2002:a2e:b4cd:: with SMTP id r13mr18866054ljm.249.1594156579179;
        Tue, 07 Jul 2020 14:16:19 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id u7sm12750493lfi.45.2020.07.07.14.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 14:16:18 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH 0/2 v5] RTL8366RB tagging support
Date:   Tue,  7 Jul 2020 23:16:12 +0200
Message-Id: <20200707211614.1217258-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is essentially the two first patches of the previous
patch set: we split off the tagging support and deal
with the VLAN set-up in a separate patch set since it
seems we need some more discussion around that.

Linus Walleij (2):
  net: dsa: tag_rtl4_a: Implement Realtek 4 byte A tag
  net: dsa: rtl8366rb: Support the CPU DSA tag

 drivers/net/dsa/Kconfig     |   1 +
 drivers/net/dsa/rtl8366rb.c |  31 +++------
 include/net/dsa.h           |   2 +
 net/dsa/Kconfig             |   7 ++
 net/dsa/Makefile            |   1 +
 net/dsa/tag_rtl4_a.c        | 130 ++++++++++++++++++++++++++++++++++++
 6 files changed, 149 insertions(+), 23 deletions(-)
 create mode 100644 net/dsa/tag_rtl4_a.c

-- 
2.26.2

