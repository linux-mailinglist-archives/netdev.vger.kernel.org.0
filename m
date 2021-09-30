Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C2141D0CC
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 03:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347553AbhI3BFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 21:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346422AbhI3BFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 21:05:19 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB70C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 18:03:37 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id n18so4504061pgm.12
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 18:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1hGq7vt7VRevMqO0uKUiYFyXj3GA36h2fkEW5YfidtQ=;
        b=A3B6QX7APL0CfErEDvqlv9mUxlygwIdnMC4Pr7ppUKwTJE4zgTThiTzhIoCA7OjheS
         BXS5/S4085a7vQA89tki+/D/2/Iwg19pagCvImyYT7cFIIYfAOgpbl64fWOTsLyLSKWw
         4JRUE/XKR/yHHUVAJJSbV4iQ1zkro5bTvFk1tW4aPKXksu7On7ljUcJkMhkzUOfeCVih
         SnRmFQJ2gGyyz1yu5fQJ1ikxVUwNnha9vSVv0tHM2vcX7M5xRw1ZUBy35qc1XonpGUqJ
         irWgtB3/WB3YgKs60POyCDJhwRrHkJ7Pa05nLvFBDyTi1atpj6o+qV/aEMNr0Y6qTYHt
         3n5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1hGq7vt7VRevMqO0uKUiYFyXj3GA36h2fkEW5YfidtQ=;
        b=gynuG19XGVyLnfRF2C6U8INknI7ZwDMQ3SfqeYyGamHZy/Gb9XjzfRoogKKCPWLm/x
         Ukzq5ZHsFbouNTqiY23fD5BJhBWYPoZqoWlhg1OjrIdeWkWjppo+RIVVTxCztUvtp9IO
         3+K12ujw2QGGPb0PfQDczCEq16kiAoOgfHuE+jbVi6ABnHMeuW5ZbMvLTxYiRMxSATst
         FDcPzH2OkmNZDUAjP7OQujRnAT+6Fji/9c4w5P/iPbamgVGJ4DdnBml78jwQEUiQmIVq
         SSOiP3z3KiLlRTMMP/FFNjnqz/kA+0mPNHxvsyFSBC5bfdZmf7MxLbvs2pWzKyjNO2Up
         rctQ==
X-Gm-Message-State: AOAM532dMtU75qhPMYoXM3R+MfyKvM11v0dkzZHGl7A8mreNmUpbxs3d
        P2plAhyI8MXjbJyDNiK92IE=
X-Google-Smtp-Source: ABdhPJyuLAyirSlR69giAnFTXa4Hbv8b9dxtTCk5mRHNyu1m5ErtuZYKhprK2fx11WTxTuzOIdg5jQ==
X-Received: by 2002:a63:d2:: with SMTP id 201mr2490034pga.400.1632963817196;
        Wed, 29 Sep 2021 18:03:37 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8858:a0b7:dcc9:9a3b])
        by smtp.gmail.com with ESMTPSA id p17sm711695pju.34.2021.09.29.18.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 18:03:36 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next 0/2] net: snmp: minor optimizations
Date:   Wed, 29 Sep 2021 18:03:31 -0700
Message-Id: <20210930010333.2625706-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Fetching many SNMP counters on hosts with large number of cpus
takes a lot of time. mptcp still uses the old non-batched
fashion which is not cache friendly.

Eric Dumazet (2):
  net: snmp: inline snmp_get_cpu_field()
  mptcp: use batch snmp operations in mptcp_seq_show()

 include/net/ip.h   |  6 +++++-
 net/ipv4/af_inet.c |  6 ------
 net/mptcp/mib.c    | 17 +++++++----------
 3 files changed, 12 insertions(+), 17 deletions(-)

-- 
2.33.0.800.g4c38ced690-goog

