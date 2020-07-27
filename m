Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8205522F501
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbgG0QZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729099AbgG0QZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:25:34 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AB5C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:25:34 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id x12so4133361qtp.1
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PPeEYgEOG843lwExn3vH3TdfbeyS+fTudAguCt5Ljfc=;
        b=PRO6u07orgnA1/PyIOa4/JoSSZOXWfKh8CRDRJlJVtzpWux8LRs9LNMq+pIsiBBPEm
         1kUINbREWkyETE2Khnx9BKpeM0orUO+B3X4TJja2aL/Zfq5lurVNWgb3uVlQRS+5YhBf
         7t6SkEOxA2vuNAstMRAnrUihFA3bLS7WtSVZ3g64UwBMwPaEbcbEn+VnW9P8kGC/1LdT
         JqeC0lmf6EfOayqr+16uXQFljd+aZk4AH/rH3Ki1yzB2YVPUw+Fa5oBwqbkgy+evCkFk
         eLkjeTV+MCGUadcnNrF5SW92k8VgTNMUXvZEJBiF/45mjNPH/u4BCxK0dzc2VfZckM4v
         pT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PPeEYgEOG843lwExn3vH3TdfbeyS+fTudAguCt5Ljfc=;
        b=M08AqhKoOV6zwTb4OpzzpUA5qw/ZBpVNLQY9wVpJ3eFx/k4R0iJFN51+ZZJvlNl4xZ
         13/xEew2A5ySpiViwuXU5sUMlDMgRb7Ve76rN/jKFeQmoj/uzHGitiFZRvoD5nR+ZPSN
         glGFTVfnBiYC8coyiq2w0+AqOeEFSmdc5m9KnsUQEABeVRNrDFf1jB3DS04Z//5aZGJ0
         QxKrWT2GXSbi6CY1r7qD/Cxw9fK6pUVLmlX1ZQXaR7iuheKCkBb761ekx6Ww4myTFllX
         tUc00/pDJqyz/sikqI0c6UlClgr3XBnpsokiNmemEeGU1a+KoubmLzDdaOV/3zBeHLwZ
         zRrA==
X-Gm-Message-State: AOAM531NaB69PhJYmdTyRIy1yPyUMjAP/leMmoyFpSZYl5FRwXrJEJHe
        WZvBzl7BBveDOrQ+Q2+N5IbK/PpY
X-Google-Smtp-Source: ABdhPJzzRmezdxVKSZTZaeIS84Z69q46EOT79BUfsm83rZj/pvfsDI6P/YqFVZRp7a4OHU6EjtUubw==
X-Received: by 2002:ac8:f73:: with SMTP id l48mr22659020qtk.296.1595867133308;
        Mon, 27 Jul 2020 09:25:33 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:f693:9fff:feea:df57])
        by smtp.gmail.com with ESMTPSA id o37sm16764529qte.9.2020.07.27.09.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 09:25:32 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>
Subject: [PATCH net 0/4] selftests/net: Fix clang warnings on powerpc
Date:   Mon, 27 Jul 2020 12:25:27 -0400
Message-Id: <20200727162531.4089654-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

This is essentially a v2 of http://patchwork.ozlabs.org/project/netdev/patch/20200724181757.2331172-1-tannerlove.kernel@gmail.com/, but it has been split up in order to have only one "Fixes" tag per patch.

Tanner Love (4):
  selftests/net: rxtimestamp: fix clang issues for target arch PowerPC
  selftests/net: psock_fanout: fix clang issues for target arch PowerPC
  selftests/net: so_txtime: fix clang issues for target arch PowerPC
  selftests/net: tcp_mmap: fix clang warning for target arch PowerPC

 tools/testing/selftests/net/psock_fanout.c | 3 ++-
 tools/testing/selftests/net/rxtimestamp.c  | 3 +--
 tools/testing/selftests/net/so_txtime.c    | 2 +-
 tools/testing/selftests/net/tcp_mmap.c     | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.28.0.rc0.142.g3c755180ce-goog

