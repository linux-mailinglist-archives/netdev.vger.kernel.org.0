Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431EA2D7E4D
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 19:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731759AbgLKSpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 13:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389094AbgLKSpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 13:45:12 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2D1C0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 10:44:32 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id g18so7746509pgk.1
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 10:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PlHFehdQZ0gXO48oPP/DZo/HZdOVZABi+nBL9/N/2T4=;
        b=U/mqkYUBoPcejIzKGSlHxgEtT2kz6EklA7lsTbShX1FzIjMeEAx2ZbcmjYqJH5nwMe
         1UG5GkYSnmp7YJY99Z0OKgH7wChhtWJaRxXVhN8o9BUkj470a5jxuwU/MDpYK1Lff141
         1y7X12hTMgFyrEzQ1kP8+kbbOfBgM5eh/UaxzdFZl55DdHDaoo5vXIxPjHlc2gjAZ0I3
         5n6No+bbKxAwz8vfhXkcLmKP6EYzBLXmTy/ikjQWyKtNGIW3+V0dqEPz3uC8huz+gSF5
         Z1TA4dAOnQeYcHxgCcb351ol4+Qb64p4kTbak5o/tDgC6OZkUKa+wY8bYZGmRj89Oiqs
         mFEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PlHFehdQZ0gXO48oPP/DZo/HZdOVZABi+nBL9/N/2T4=;
        b=OVcHASdvMvViOe6FZJCsMpwEuaE9jFyb7Y0Ubk2NLmpcZi+UMGhPUB1S5ELA5BF90H
         N0QzbhN4XgGeZiIwxi4vwPHAoiUkVYk9vC7xWuIboFDPrsqwXi6sm3ZgcBMmPIBB3cdZ
         LWKTZxl3PJVWPtxfddc0X5iHaTFr5MLS79WiWw+vtKsS93vPczim/ewATk1AOlkD3DPJ
         aqWMn5rKB2Ao+SizHFnBWfqMPC+ePkBO2rkb3XQS1ltbIDM/QGsG5sFUKC3IXavW3VH3
         es7Yb5Efvn60g971x6d1pByajXMernw6u9osGrU8orgaRKbXv7LzYTOvxRxfGTM3k8I5
         e/3Q==
X-Gm-Message-State: AOAM530dKR2XSYmNt35tCMDqvBUkpNjUfstLewkOWVklNb52Vid0tPZZ
        dPekX3B0epZ8M/48ZZnkjzs=
X-Google-Smtp-Source: ABdhPJx480B81D6HtCpBZGMVULwrOX/8AA1ZON6oDxlkvT/JG9NtrSKDA+t5ryyaE/7YLMxirZyg4A==
X-Received: by 2002:a63:943:: with SMTP id 64mr13295477pgj.80.1607712272181;
        Fri, 11 Dec 2020 10:44:32 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id h4sm11783486pgp.8.2020.12.11.10.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 10:44:31 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next 0/2] Adds CMSG+rx timestamps to TCP rx. zerocopy
Date:   Fri, 11 Dec 2020 10:44:17 -0800
Message-Id: <20201211184419.1271335-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

This patch series provides CMSG and receive timestamp support to TCP
receive zerocopy. Patch 1 refactors CMSG pending state for
tcp_recvmsg() to avoid the use of magic numbers; patch 2 implements
receive timestamp via CMSG support for receive zerocopy, and uses the
constants added in patch 1.

Arjun Roy (2):
  tcp: Remove CMSG magic numbers for tcp_recvmsg().
  tcp: Add receive timestamp support for receive zerocopy.

 include/uapi/linux/tcp.h |   4 ++
 net/ipv4/tcp.c           | 114 ++++++++++++++++++++++++++++-----------
 2 files changed, 87 insertions(+), 31 deletions(-)

-- 
2.29.2.576.ga3fc446d84-goog

