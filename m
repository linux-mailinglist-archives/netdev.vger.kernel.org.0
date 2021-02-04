Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0326830FAF8
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbhBDSMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237452AbhBDSKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:10:42 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36D7C061786
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 10:10:01 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id q7so4587908wre.13
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 10:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=E5m/B8JzbQabZ0E+FC+CVsjTkueAz156YauUf57QzNM=;
        b=tc5be0sLn2QXCP0F6XAOx2Qv+FzRPTQW7XnOOfIhM6YF/66RwYyMHkz5fJI1F6JB1n
         9fvxR86DGcdHgXgTCowOEMl/VttgLnY5PPXEGXxt1e/bDJChy4Z460ojgJHkbsYUzr8d
         qlAXUGikAq7rHWRdtO4RVw/ROKnTDtqbxKehHqoNgckZiOalEYzYiVKt2EcqZ1Pz4AGr
         xZ01a2SXKhpj7QeFAPaACEeD+kWOp0VOWkXNnYOiXNQZwLRwT6E3O8BQ3IWM00On/Cbs
         NGekQT6rSwg1KdMc0TEPjXSOC75MANsT25o5ghfpx6ZBWG8A8TxbQwrdBGcUUqGedKUt
         Ak4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=E5m/B8JzbQabZ0E+FC+CVsjTkueAz156YauUf57QzNM=;
        b=UL/EP/H+m7pTWAZUYTtdlMP4/Ne4auMjauWXpdwnciKWnAwHEcMqZNxKHJ8A7GaPDR
         Ma51/CgcNMGqr0HTfiINtw0MQxsCpNeDkG9bX2GkvHo0099gfKFJAJVil4bQ5gy6IziB
         yJESWzkeaZX1Rqh05HVWa8+f5pw41eJ8wSBvOI+0XpfLpHCtAJsC+wU6uYSjaM/KzVy3
         /h1DY13Gmxg9HOlWiLs24WGShie3IePHuTvaUuKqSk/xp7jdZ6bhpVRCrD3QZIPGW+bJ
         Vk0jaQkxs14jAqaMFN/cuZLD32ecJefF/o07KFjJYTGoxSmxJ4oryKBWdas1wBfbfXO1
         YOpQ==
X-Gm-Message-State: AOAM530aEpjEcQJTa963IDi0he3BAY7/TQkdfX0ExhzIFMMCmxjULXom
        nWA6xIvByMabKfuJfsA6IjBtJw==
X-Google-Smtp-Source: ABdhPJz8SeGvXi9Au8h45BgqPwEwE6d6ilAkTL7/rf4aa+v6+LoEhHTirevc4BdK2WFdr19cg61k/Q==
X-Received: by 2002:adf:df12:: with SMTP id y18mr623421wrl.141.1612462200453;
        Thu, 04 Feb 2021 10:10:00 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id m6sm6313746wmq.13.2021.02.04.10.09.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Feb 2021 10:09:59 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v3 0/5] Add MBIM over MHI support
Date:   Thu,  4 Feb 2021 19:17:36 +0100
Message-Id: <1612462661-23045-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
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
   - mbim: remove all unecessary parenthesis
   - mbim: report errors and rx_length_errors
   - mbim: rate_limited errors in rx/tx path 
   - mbim: create define for NDP signature mask
   - mbim: switch-case to if for signature check
   - mbim: skb_cow_head() to fix headroom if necessary

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
 drivers/net/mhi/proto_mbim.c | 294 +++++++++++++++++++++++++++++++
 drivers/net/mhi_net.c        | 384 ----------------------------------------
 6 files changed, 746 insertions(+), 385 deletions(-)
 create mode 100644 drivers/net/mhi/Makefile
 create mode 100644 drivers/net/mhi/mhi.h
 create mode 100644 drivers/net/mhi/net.c
 create mode 100644 drivers/net/mhi/proto_mbim.c
 delete mode 100644 drivers/net/mhi_net.c

-- 
2.7.4

