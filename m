Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D74FEAA06
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 06:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfJaFIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 01:08:11 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37685 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfJaFIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 01:08:11 -0400
Received: by mail-pg1-f194.google.com with SMTP id p1so3163515pgi.4
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 22:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=LMPJsMbMXx3g6Ek2mwQgPW2pV3gdEwLdsElLZeHVL8Y=;
        b=R2RPaUmA/hbE7gsbQzyt/1EoJa6A5eVljeLe2dLydzFo77hQfaFjqnZmA7tf2QKxwX
         H6qGBuYvXjU5mToiOvio3Y8JgwQAoC0shXsx/4/gUkSXy9aME0QOz8PxAmJqLlNttWr1
         PiscatSmxyOGBenAxqfUMCxZEQD2i0h5BodZs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LMPJsMbMXx3g6Ek2mwQgPW2pV3gdEwLdsElLZeHVL8Y=;
        b=RhOT7B9uXcfhFGb1RRSeZ3cRjP78P0JiSrYeBKEE2aO2Z2aH1mmELsWgM4JxBcziUo
         yRGA4HHhlvQrPbhO1nzEVfR4rZCeSg+nxfqHW1My2JVHlPCTPZ/JDhCLKR7+NcqR5BxW
         qlN1juQMOV9V1E5ZKoqdqZKmCT/YBp16N09dnHA71UommnqCjjGYKaPnFHZbydiLGYi7
         /xQWpvNx7ufVsFDMgklr7xgcUR9TxNo0AWX/DIwAoPvE2AN8BpsiaOBGvdykZsKc2eY9
         GqU9zNWSfTiQ/28aQQz++cUCd6Q2ny3iG1+6i+3s9U9k0VsRaEgB9GtbpzrEWQR+54H+
         ihOA==
X-Gm-Message-State: APjAAAVN3kAwaXUsL5S+roDp/YSZUeeS9kxionCCD6aWhBh6tj4VIu4n
        vC/WG0oGqDckZ36GVjbdPs8CEIvXRgs=
X-Google-Smtp-Source: APXvYqwnbRSrBNGl8zbzGtoucW79w6nRJVkvwPI7LULdsmRAhefl9oWOQnaYYaguh99PsLjxpamtAQ==
X-Received: by 2002:a63:4556:: with SMTP id u22mr3852063pgk.2.1572498490550;
        Wed, 30 Oct 2019 22:08:10 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a8sm1690899pff.5.2019.10.30.22.08.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 22:08:10 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/7] bnxt_en: Updates for net-next.
Date:   Thu, 31 Oct 2019 01:07:44 -0400
Message-Id: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds TC Flower tunnel decap and rewrite actions in
the first 4 patches.  The next 3 patches integrates the recently
added error recovery with the RDMA driver by calling the proper
hooks to stop and start.

v2: Fix pointer alignment issue in patch #1.

Pavan Chebbi (1):
  bnxt_en: Call bnxt_ulp_stop()/bnxt_ulp_start() during suspend/resume.

Somnath Kotur (2):
  bnxt: Avoid logging an unnecessary message when a flow can't be
    offloaded
  bnxt_en: Add support for NAT(L3/L4 rewrite)

Sriharsha Basavapatna (1):
  bnxt_en: flow_offload: offload tunnel decap rules via indirect
    callbacks

Vasundhara Volam (2):
  bnxt_en: Improve bnxt_ulp_stop()/bnxt_ulp_start() call sequence.
  bnxt_en: Call bnxt_ulp_stop()/bnxt_ulp_start() during error recovery.

Venkat Duvvuru (1):
  bnxt_en: Add support for L2 rewrite

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  45 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  12 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  | 416 +++++++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h  |  20 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   3 +-
 6 files changed, 483 insertions(+), 23 deletions(-)

-- 
2.5.1

