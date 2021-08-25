Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC223F7EF3
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 01:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbhHYXTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 19:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233270AbhHYXTT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 19:19:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50F1160EBC;
        Wed, 25 Aug 2021 23:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629933513;
        bh=lZYNnbuuSCpqi66lSs37TnSniUrtO/nb2ftXFyTIyi0=;
        h=From:To:Cc:Subject:Date:From;
        b=sReAy1awL9A/8gSYcYX/1MZxpNFDYuFZaVUZUUZkZuTX5WZFuXs0dAk9ZkFp5GMMl
         UajbBrrAjMsmyh5mMhLDmEsXHA9kKi1XbFdP64sHkrpwcZoXj3xSnhzCvXjRbt06jr
         Q7y1r/mVEb3RGScILLc6ef9EFhdFht7NO3fHQcRYqjX56P4wpmTCghhGwr1QZc2FoK
         HnpSj/mLTqa6BrEw5wzU7a9Cf/v2hj5KHNmfIrcSLQ49q9SQXTcZ+TEWbLfSiO6GER
         PXFyI7w131oV4LBf0XqUake0p77Vi8qhZVzgMUipn8Z9bp1VMVYbDrqvqghLcwOM4O
         Cr9T6fooULRIw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] bnxt: add rx discards stats for oom and netpool
Date:   Wed, 25 Aug 2021 16:18:27 -0700
Message-Id: <20210825231830.2748915-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers should avoid silently dropping frames. This set adds two
stats for previously unaccounted events to bnxt - packets dropped
due to allocation failures and packets dropped during emergency
ring polling.

Jakub Kicinski (3):
  bnxt: reorder logic in bnxt_get_stats64()
  bnxt: count packets discarded because of netpoll
  bnxt: count discards due to memory allocation errors

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 54 ++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  3 ++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  7 +++
 3 files changed, 51 insertions(+), 13 deletions(-)

-- 
2.31.1

