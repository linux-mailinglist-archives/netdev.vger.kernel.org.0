Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10724AA104
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 21:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbiBDUPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 15:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbiBDUPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 15:15:51 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8122C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 12:15:50 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id m7so6651007pjk.0
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 12:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FFHiF/6N4G82cEcqiAN2d0pe129A+nJr0KUBr/GCoYQ=;
        b=BM19YwoxXHh+mYQKtTXtmOTWPaN3NrUgnow0xkY7+QW1zPcc3mnR0V955Bjd/cKyBq
         kyvzrP0Z8t8a9bGLJXwk1PRpAOl9pDxyZXfDOLt9je7ZOjjrC4NpVpOPDG4KfdQRs0eV
         ciPRcZMGtY/93Fws475n4nuHLFuXghg8FiG4RTgVl9/OQAyjYXy5PM4D4d/pNeMPhrzy
         rpLrvl6+ero40z5cvwc3t+Po4W/kXBsjZ3qSxX8OcI25tMa7qAJWZ1FAB7w7Yd8/qpaO
         Mp65pT8forwQLhSLDA1xgHFIJlIe/mfqfRTuZanS8E+rx/0Zmgt8934ChWKXIkOn19ea
         hpRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FFHiF/6N4G82cEcqiAN2d0pe129A+nJr0KUBr/GCoYQ=;
        b=uWrgK84xVxmKiJwOKpvQabgRv5p40rJ1VHYvKBnI/akJauis6xtLdwr5LuIOn8AeEt
         uC4Zq1VDDfFKSrqoekZVkbGWiBPwOeIlBB+plNY2AoigNjX6i2JMjaOpZ60xkRMnPQC6
         Ily817x9BeGd8wNuurWWeCMFHZOLKtWqP0ZHJBae1l4TBfP0QYvbPwVKCppcDxjQGbe3
         ILU7A5IhmdLqIhg+B7TYM+E0oFWbsprtGrOSksFCycmDeohpXgl1yFJ7BqT4smVr/BIA
         Gy3cvZ0wBBItMpM0vLTRFyH7YmGvgTjh0pjd442ot3IHV2sJsP6jIdqr9TBAdx/SYSNo
         HWtA==
X-Gm-Message-State: AOAM5334V9h8blvy4m2gPS8GzuweIaxgnYLYa8QcGEJSGflCCf+uMtd6
        OFkeGGvco0Fp8/+5LxTvun4=
X-Google-Smtp-Source: ABdhPJz38BKRoWLhsookizCS31e0kJvE8Mxhf11SM3ZED/e6Hxiq41hy5tD/NuvK5DldgV+036ebSw==
X-Received: by 2002:a17:902:eacc:: with SMTP id p12mr4793926pld.123.1644005750204;
        Fri, 04 Feb 2022 12:15:50 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id d9sm3571417pfl.69.2022.02.04.12.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 12:15:49 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] ipv6: mc_forwarding changes
Date:   Fri,  4 Feb 2022 12:15:44 -0800
Message-Id: <20220204201546.2703267-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

First patch removes minor data-races, as mc_forwarding can
be locklessly read in fast path.

Second patch adds a short cut in ip6mr_sk_done()

Eric Dumazet (2):
  ipv6: make mc_forwarding atomic
  ip6mr: ip6mr_sk_done() can exit early in common cases

 include/linux/ipv6.h       |  2 +-
 net/batman-adv/multicast.c |  2 +-
 net/ipv6/addrconf.c        |  4 ++--
 net/ipv6/ip6_input.c       |  2 +-
 net/ipv6/ip6mr.c           | 11 +++++++----
 5 files changed, 12 insertions(+), 9 deletions(-)

-- 
2.35.0.263.gb82422642f-goog

