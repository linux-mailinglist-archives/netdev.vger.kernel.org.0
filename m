Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C633B314B14
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhBIJBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhBII6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:58:46 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD98AC061788
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 00:57:56 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id f16so2281203wmq.5
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 00:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=xv6kZTW9YmYUbkT+aFJrSkdPmUaysAkCKC5Evv8SfHg=;
        b=TAnLmi9S6aHVsQe+nq7cb6x+mcAnd9J0F3PGcNoV+6w4OSdmjDLmpmuAMCmI9jGzXM
         8+eriN2L/qI6rB6jVzD7a7MU00EzWssY9H8wk+/DJKPNW6HYs1sDIPOT5CIILEFBbNff
         /g/4kYLKPHgf4hlnQFWjkaAXSZyqQVj8m+SZZJKEhMQSLCAPvJG21vCUzbbguOdvzx3F
         hJ9YT5cP6JQI2F6EzefDI/V7I2D/Q+/EH7SSUrKcsW79Fj/LM4++dfvVIwIjzoOUPhoe
         DLbVnBxkZSjWGmXIpDT9ZkMnLDS0aVlrS2K3sdwFlck/jYEYBHWU+QUPCns+jpbWMIEo
         xA7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xv6kZTW9YmYUbkT+aFJrSkdPmUaysAkCKC5Evv8SfHg=;
        b=rbLow+Heisz0UJBUNWLEaqSaZXniXCVc0EweOnz7NHMItUrHtEVzEDW67TAZU5BkGa
         B3O/x9yC9XJfRC316v/kk2D0zInW4I5rGUeI9/rWu5tC3IoC3DMGcIUglh+B8uSXiP3x
         lTr9pFvdRSOTwbMuLke4uUeDiG93IdOCB+2di1/cArZrR/RoU5OkvpKalFNVTELMmHZk
         /dc66qn2SyntOfwFPE8IBKiIIPHoIW1LeQL50xFo4CYmruHldaq7vY2KpR3G4jxhTgxO
         lE5Bu0XpRhpioz1A68iQRvTxebog84mm6KnOFQ2cjgNtGX3LP/gFhvMexo86E5oJiHcV
         PsDg==
X-Gm-Message-State: AOAM530xtPegh9tOsY6BgBx8dMIOROp6SWIxar537a/PVWxHpiglAMls
        K3SCDoFqNuLdy2NCuC2R3PUDkA==
X-Google-Smtp-Source: ABdhPJzxxQRAgJYBhWH+BXCegaiVdFXuMN7BlABcGveJ5pnwxWUP9eh7yJwsns0YOGeCAS1+FeHgWA==
X-Received: by 2002:a05:600c:d6:: with SMTP id u22mr2359822wmm.87.1612861075324;
        Tue, 09 Feb 2021 00:57:55 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id d3sm38348693wrp.79.2021.02.09.00.57.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 00:57:54 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, ivan.mikhanchuk@quectel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v5 0/5] Add MBIM over MHI support
Date:   Tue,  9 Feb 2021 10:05:53 +0100
Message-Id: <1612861558-14487-1-git-send-email-loic.poulain@linaro.org>
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
   - mbim: remove all unnecessary parenthesis
   - mbim: report errors and rx_length_errors
   - mbim: rate_limited errors in rx/tx path
   - mbim: create define for NDP signature mask
   - mbim: switch-case to if for signature check
   - mbim: skb_cow_head() to fix headroom if necessary

v4:
   - remove one extra useless parens pair

v5:
   - fix sparse issue reported by Jakub:
     proto_mbim.c:159:41: warning: restricted __le32 degrades to integer
     => use explicit endianess accessors for all values.


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

