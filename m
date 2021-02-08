Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F91312B42
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 08:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhBHHxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 02:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhBHHxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 02:53:16 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA8EC061788
        for <netdev@vger.kernel.org>; Sun,  7 Feb 2021 23:52:35 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id o24so4675300wmh.5
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 23:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=RQr+T4SVBrx9S1ZqYDDaf1hxz4RKqKhGp6XIC94lZQw=;
        b=o5M30jfP5aB09ulPzdTGs4CYoBXJyT4ygp5Y5lxtuFyzd1xFQyS+0XQxDTP509hA/2
         EGS+Nu2Wu5hrEtvymUw3GK2lgUc7SYt5Z0Y5kjE6KJTc0gH2dNMg6RXO3AZPsv59eCzN
         uXI6vdelKB4y6ggEjMO7Ck3Wr5tLOrR2cKrZAgkjVKBWRTdseYnfOtb3bM1P7bikNAal
         BWcKRsSB93jp0O58bh6OdLGtOem7H/tszPK9Vojf0iCcjH3YCFqThMZCVXEpFMIWRfpo
         DTfCTdM+Fag3uvGCQpCmqKm7PLYjqtINApWK5m3bJtn/3aACQYDSs4L4fDZZQUafdgEZ
         iq5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RQr+T4SVBrx9S1ZqYDDaf1hxz4RKqKhGp6XIC94lZQw=;
        b=Zivk/cTh8tzMmgzhPhwdZxtz/aZkns1B2sVNfN4YOnq1OR6PgRpETGDF4o6FRhiizY
         fqYKVCAZUhK+7p/36+jYjL7dGdNEKgNtO++9KAseUaiP/376PJxyC2CGcPrO6bZJdCtu
         TD5FRPlINBXyaaThzABjaQ7Rtb0Eitdq6MGbzqHCboETUTXWxCrK7vufERrTP78x/+xx
         NvJInyY16pEmM0sLqAeD3F2N0NumW1nfwdFhhCDsdEORP6/gRyNPKpmodFwRm0bWiz6A
         4iWgtkLhbY9n1p4uhPRG+BSAYTeQzuFeyWLccoRiSlpQmdopQntfcHx6D2+7ZfrmRMjM
         xw0A==
X-Gm-Message-State: AOAM532Dc8JspxXD6Ujunu51yRn4p7VhBpZ9fFpaYsmW7D/Phn7/fq8z
        5vJ8nUupY/9rEXdcIXWZdLj3crCm+9oS+A==
X-Google-Smtp-Source: ABdhPJwDm7JyIbwqGJ0WRrbC7KvagbXKFpFVBvOEYYVlP/uHwu6G9cOzB+8zhjHbpfLFHCkXWT9sPQ==
X-Received: by 2002:a1c:b684:: with SMTP id g126mr13252330wmf.94.1612770754471;
        Sun, 07 Feb 2021 23:52:34 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:490:8730:2c22:849b:ef6a:c4b9])
        by smtp.gmail.com with ESMTPSA id g16sm18784952wmi.30.2021.02.07.23.52.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Feb 2021 23:52:34 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, ivan.mikhanchuk@quectel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v4 0/5] Add MBIM over MHI support
Date:   Mon,  8 Feb 2021 09:00:32 +0100
Message-Id: <1612771237-3782-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds MBIM decoding/encoding support to mhi-net, using
mhi-net rx and tx_fixup 'proto' callbacks introduced in the series.

v2:
   - net.c: mhi_net_dev as rx/tx_fixup parameter
   - mbim: Check nth size/sequence in nth16_verify
   - mbim: Add netif_dbg message for verbose error
   - mbim: Add inline comment for MHI MBIM limitation (no DSS)
   - mbim: Fix copyright issue
   - mbim: Reword commit message

v3:
   - net: dedicated commit for mhi.h
   - net: add rx_length_errors stat change
   - net: rename rx_fixup to rx
   - net: proto rx returns void
   - mbim: remove all unnecessary parenthesis
   - mbim: report errors and rx_length_errors
   - mbim: rate_limited errors in rx/tx path
   - mbim: create define for NDP signature mask
   - mbim: switch-case to if for signature check
   - mbim: skb_cow_head() to fix headroom if necessary

v4:
   - remove one extra useless parens pair

*** BLURB HERE ***

Loic Poulain (5):
  net: mhi: Add protocol support
  net: mhi: Add dedicated folder
  net: mhi: Create mhi.h
  net: mhi: Add rx_length_errors stat
  net: mhi: Add mbim proto

 drivers/net/Makefile         |   2 +-
 drivers/net/mhi/Makefile     |   3 +
 drivers/net/mhi/mhi.h        |  40 +++++
 drivers/net/mhi/net.c        | 408 +++++++++++++++++++++++++++++++++++++++++++
 drivers/net/mhi/proto_mbim.c | 293 +++++++++++++++++++++++++++++++
 drivers/net/mhi_net.c        | 384 ----------------------------------------
 6 files changed, 745 insertions(+), 385 deletions(-)
 create mode 100644 drivers/net/mhi/Makefile
 create mode 100644 drivers/net/mhi/mhi.h
 create mode 100644 drivers/net/mhi/net.c
 create mode 100644 drivers/net/mhi/proto_mbim.c
 delete mode 100644 drivers/net/mhi_net.c

-- 
2.7.4

