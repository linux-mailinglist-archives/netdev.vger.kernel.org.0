Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0AB49BE68
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 23:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbiAYWX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 17:23:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48758 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbiAYWX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 17:23:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB671B81AD3
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 22:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C15C340E0;
        Tue, 25 Jan 2022 22:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643149404;
        bh=galDCM+SkYZzEPCcYz93LdB/+zxzXg1dBitMBB4PzZo=;
        h=From:To:Cc:Subject:Date:From;
        b=bKCTCqNLaN4JPBzrdTWIyDryN5maO4Tj6N8LyGcP+om/lhgdDRG0GD7RpUlIPX+m6
         LTdXRwRVDlnU5M8HprcPNgx/vk7CgZmEDIiggHixI/KWgoXwKLqWFR1ctOhtN+XqGx
         mViEZ4dPLysTYTwJUwK5DnuEZzUsygak1CL3EEMNXWJXKtNTGF/s+38/27ONR+ifZ/
         gKXi5tK4BuNWqCqduaTEkBFcnYDK+2u5Te1QpSg9a9M3sAjznMPfZZLCX8p4irszSZ
         rcaWPq/RIMDCcjCMsEhbxd3zJmAuDS/nYs5BmO7bD6rlEK2WZ57mF7uJKYbrS+I8ri
         pcSi7/cspxxaQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dave@thedillows.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/3] ethernet: fix some esoteric drivers after netdev->dev_addr constification
Date:   Tue, 25 Jan 2022 14:23:14 -0800
Message-Id: <20220125222317.1307561-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looking at recent fixes for drivers which don't get included with
allmodconfig builds I thought it's worth grepping for more instances of:

  dev->dev_addr\[.*\] = 

This set contains the fixes.

Jakub Kicinski (3):
  ethernet: 3com/typhoon: don't write directly to netdev->dev_addr
  ethernet: tundra: don't write directly to netdev->dev_addr
  ethernet: broadcom/sb1250-mac: don't write directly to
    netdev->dev_addr

 drivers/net/ethernet/3com/typhoon.c        |  6 ++--
 drivers/net/ethernet/broadcom/sb1250-mac.c |  4 +--
 drivers/net/ethernet/tundra/tsi108_eth.c   | 35 +++++++++++-----------
 3 files changed, 23 insertions(+), 22 deletions(-)

-- 
2.34.1

