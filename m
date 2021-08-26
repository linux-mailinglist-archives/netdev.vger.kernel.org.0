Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387C13F8003
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbhHZBsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhHZBsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 21:48:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95ED461075;
        Thu, 26 Aug 2021 01:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629942453;
        bh=xW9KPebqdVosrT1wx8eeGiMg9ftcoa87dR+vRFZMzqQ=;
        h=From:To:Cc:Subject:Date:From;
        b=fHEHK8BWAi5yACW7tmR8YG94dLxpXA0zUl1IbTbSu/sMKJxzM+sf4L1t/qmrJ6dwo
         4LniJf4PPqMWegQ6K45lAD65z5SL1xQ/dwHW6BDR1/OuTIr48M33SewO/V/trHEA5Z
         d1W9mEKjQkPXNVyWC04PG+craSg5QTjdbxilzT/b2I2+cV7AD6uQKJJ5WNjHZCjiTX
         9dMBS3kH+ACXsLuB4QmKGUvxO7WUAqSujkUOLljGQ4PZJoQ+7sBr0N1AY5C2mt6Zkk
         aqdZAanQjrUayG3Zdgl5jTG6Id7GHgUFhrrhLr6mJHrjfjwHdJkMKMcsTbuptKlOek
         U2AUVYhmFbS0w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, olteanv@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/3] bnxt: add rx discards stats for oom and netpool
Date:   Wed, 25 Aug 2021 18:47:28 -0700
Message-Id: <20210826014731.2764066-1-kuba@kernel.org>
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

