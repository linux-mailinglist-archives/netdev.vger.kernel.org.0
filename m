Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F76127491A
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 21:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgIVT2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 15:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgIVT2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 15:28:11 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E55C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 12:28:10 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 34so12777596pgo.13
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 12:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GIgK9z+X1pPm15jVetA1DwVq80Sgpd9HT5Ovmarhdd0=;
        b=C808Y28VPZtrJeVxjIY8tZWk6Dg2JbGly9TmfrWOj47pHa7BEKP88iWp6SC//CpNhJ
         U3GklW4fMfTovGt9u/dQJsEm5jiRERdKhjUGDGZZzlfCrY3gPRvpjz0XFl9avocoFVG1
         4oeo4Wy+QjCHzOZxuF8Ojx/0Aygs1Zo9js/bJRCF/a/nqb9FRL+cS8fEOgk0JdrsHeYV
         usq2bVfh56vGGeIUPflwd7Oi8RYKUVVF3I+WUA6mR4+jwhOtYpsPq8gxIwPHoaY8WGoZ
         FmlPx8XUNqU6FXHS+5CBTXSkhiqdvhHmW6a2Hy3xXJ5kcFKn5qQXtlM1xfG91ka0Ccco
         GTOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GIgK9z+X1pPm15jVetA1DwVq80Sgpd9HT5Ovmarhdd0=;
        b=Opqkn65mrMZyql+NH74iwDDRHn8TgPL/PSdKP66FQK1iKRVOEXGqMyhgDQN4LW6LIR
         sXeZEZfE3HwVVES5TqH+zrhW+4YPXKVTVA2cpTZWy7QlZog1kzY8DR+NTtK24dWJmm1E
         XsE8DKDeLNgLx0wLrZJLZmejmUIeig68GdW+d0Ur5yckKn2e+JQEQCsav7I4wmG3An9R
         to6gvmtgl0zSHNEXkEIZ6Gi/69wWREQNvWzT62e6cXIPmQYjnlIKJoOaRTrkk3LbR13C
         0hTwdDDH+hd86WtPItfcXFa0OoXjMVMGsVlKeQ2ec5/VpJSzxPiEUxjOOQc/RFSb654f
         u+Ig==
X-Gm-Message-State: AOAM533SwflADHD9eIsqsIzv95zRvDifNXq0L6BxgNFlMFXTXLte1p4Y
        mt4Frs88w6At1XgHMmNRv8Rd+RLJT4WYo3i0
X-Google-Smtp-Source: ABdhPJwlqFuSHHjXN0GNjEEDeXO0qh3rBCUfdqoubBi0ypeujo8ePbyw9ovM1Wst+95N7B4tRuZyFg==
X-Received: by 2002:a62:3547:0:b029:142:2501:35d4 with SMTP id c68-20020a6235470000b0290142250135d4mr5577283pfa.52.1600802890332;
        Tue, 22 Sep 2020 12:28:10 -0700 (PDT)
Received: from priyarjha.svl.corp.google.com ([2620:15c:2c4:201:a28c:fdff:fee3:2bbe])
        by smtp.gmail.com with ESMTPSA id 126sm16108245pfg.192.2020.09.22.12.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 12:28:09 -0700 (PDT)
From:   Priyaranjan Jha <priyarjha.kernel@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        Priyaranjan Jha <priyarjha@google.com>
Subject: [PATCH linux-4.19.y 0/2] tcp_bbr: Improving TCP BBR performance for WiFi and cellular networks
Date:   Tue, 22 Sep 2020 12:27:33 -0700
Message-Id: <20200922192735.3976618-1-priyarjha.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Priyaranjan Jha <priyarjha@google.com>

Ack aggregation is quite prevalent with wifi, cellular and cable modem
link tchnologies, ACK decimation in middleboxes, and common offloading
techniques such as TSO and GRO, at end hosts. Previously, BBR was often
cwnd-limited in the presence of severe ACK aggregation, which resulted in
low throughput due to insufficient data in flight.

To achieve good throughput for wifi and other paths with aggregation, this
patch series implements an ACK aggregation estimator for BBR, which
estimates the maximum recent degree of ACK aggregation and adapts cwnd
based on it. The algorithm is further described by the following
presentation:
https://datatracker.ietf.org/meeting/101/materials/slides-101-iccrg-an-update-on-bbr-work-at-google-00

(1) A preparatory patch, which refactors bbr_target_cwnd for generic
    inflight provisioning.

(2) Implements BBR ack aggregation estimator and adapts cwnd based
    on measured degree of ACK aggregation.

Priyaranjan Jha (2):
  tcp_bbr: refactor bbr_target_cwnd() for general inflight provisioning
  tcp_bbr: adapt cwnd based on ack aggregation estimation

 include/net/inet_connection_sock.h |   4 +-
 net/ipv4/tcp_bbr.c                 | 180 +++++++++++++++++++++++++----
 2 files changed, 161 insertions(+), 23 deletions(-)

-- 
2.28.0.681.g6f77f65b4e-goog

