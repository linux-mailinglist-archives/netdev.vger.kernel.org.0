Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332F8457080
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhKSOZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:25:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233854AbhKSOZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:25:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E682561502;
        Fri, 19 Nov 2021 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637331719;
        bh=mOoQknhKTxGPki/Yqn25zkbuK5DalVHC6k8AqjMCt0o=;
        h=From:To:Cc:Subject:Date:From;
        b=kzF4QN6K350lqeMr74AMI2DDk/Vm0I1vzsl+YYGipUcDgrs5KPdIo+6Z1i9lulM3M
         1X2aldFwU1LLIn8lSIcxic/xDUp61qGo0qQmVWQzZT8H+JpUg4v5C6X+5DhHNpTi5u
         I/gS1zBmSqwyGdSYBAovz6YlySxPpiAcbB0axFIkVK1fCp1JKitMBmVdmTfK2QZXk8
         vp912igXePXwoVTCPa0RQLvk5Lm4gOhNW7Bhilx31iAHYxML96i+nrKGEoH/91iNEZ
         TAghj23aHq4Gc4ACcSpZoG4sg1DPg5J5WZlwy4ivvu+buzQY7RPzqtOYIJAiORiFAJ
         /CfDfXKEevpNA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/7] net: constify netdev->dev_addr
Date:   Fri, 19 Nov 2021 06:21:48 -0800
Message-Id: <20211119142155.3779933-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take care of a few stragglers and make netdev->dev_addr const.

netdev->dev_addr can be held on the address tree like any other
address now.

Jakub Kicinski (7):
  82596: use eth_hw_addr_set()
  bnx2x: constify static inline stub for dev_addr
  net: constify netdev->dev_addr
  net: unexport dev_addr_init() & dev_addr_flush()
  dev_addr: add a modification check
  dev_addr_list: put the first addr on the tree
  net: kunit: add a test for dev_addr_lists

 .../net/ethernet/broadcom/bnx2x/bnx2x_sriov.h |   2 +-
 drivers/net/ethernet/i825xx/82596.c           |   3 +-
 include/linux/netdevice.h                     |  19 +-
 net/Kconfig                                   |   5 +
 net/core/Makefile                             |   2 +
 net/core/dev.c                                |   1 +
 net/core/dev_addr_lists.c                     |  93 ++++---
 net/core/dev_addr_lists_test.c                | 236 ++++++++++++++++++
 8 files changed, 320 insertions(+), 41 deletions(-)
 create mode 100644 net/core/dev_addr_lists_test.c

-- 
2.31.1

