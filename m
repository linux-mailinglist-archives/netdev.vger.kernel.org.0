Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B148A3F886E
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbhHZNNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:13:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229844AbhHZNNW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 09:13:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C33960F92;
        Thu, 26 Aug 2021 13:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629983555;
        bh=xW9KPebqdVosrT1wx8eeGiMg9ftcoa87dR+vRFZMzqQ=;
        h=From:To:Cc:Subject:Date:From;
        b=e9aHBfXfbqYMK4Qg9sK8wzEDcasa9bleJXJkr9XA4BwNSfAviv8Qsw8n3KzdZq4vU
         fOqRG7n1Q11UpIl14o9HxvmPPl/V11Sjr/42p865SiZgNT1kMPgRYvxTeTBwKr8ifj
         rynW+PvwH5CzYJpiA9ce4NRu9osPtwK//DI/lyEnVZnzPNfmHZSLzE6roeHN0YGQNj
         IZEKgxBWIf4OIE1NlZhTRZCiWuyysW1E91WxuCZUFVeuhoKPav+Xf7fDhXlreP4KgT
         qbItIEMVKQcbu5FvnxomtuAk2mMfIc5Ue49nMB/coY6zSBul6m0TaOr14l9T+VQAwA
         5NAEjn8CoxyWQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, olteanv@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 0/3] bnxt: add rx discards stats for oom and netpool
Date:   Thu, 26 Aug 2021 06:12:21 -0700
Message-Id: <20210826131224.2770403-1-kuba@kernel.org>
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
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  6 +++
 3 files changed, 50 insertions(+), 13 deletions(-)

-- 
2.31.1

