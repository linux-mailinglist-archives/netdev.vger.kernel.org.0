Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5D53AB02A
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 11:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhFQJvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 05:51:23 -0400
Received: from first.geanix.com ([116.203.34.67]:41886 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231845AbhFQJvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 05:51:22 -0400
Received: from localhost (unknown [185.17.218.86])
        by first.geanix.com (Postfix) with ESMTPSA id B082E4C3292;
        Thu, 17 Jun 2021 09:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1623923352; bh=Qt/hGAGteCalsT2PqO54g9ejMfLHzherHh3GubKQ++M=;
        h=From:To:Cc:Subject:Date;
        b=WtwvsWUyoq/BGKKDu+l/lKUBYwUqIFX9z70k6ufaC7TY9L2uP8pPJNh7G4dAW5VTC
         H/AqDJLxR+H02IzL8rY1R9IHoi4TCsKSNZkJ1JBYjQSEmjpF0PgXfkX0lZj+syh9Vl
         Ol24EVxSHbWugtT+NAxGYrRSl8Ur0iRdDs35m63oxPVYcYGHJPPwTXltmmxev9TQgo
         F22Lj62LYxW2ixR1VUk5M3sr7vbsYAe2uync3OTaiuzIiw/tTs9kH/DQ7fOfkoaEFf
         G3h4nLHX7wMW+LrM5WjOMMiInVwfW6FqQREUr2Y/MhobbXmsg3g3oOKSb2f0zQTqKe
         h7VlTMeMqDu0Q==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 0/6] net: gianfar: 64-bit statistics and rx_missed_errors counter
Date:   Thu, 17 Jun 2021 11:49:12 +0200
Message-Id: <cover.1623922686.git.esben@geanix.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series replaces the legacy 32-bit statistics to proper 64-bit ditto,
and implements rx_missed_errors counter on top of that.

The device supports a 16-bit RDRP counter, and a related carry bit and
interrupt, which allows implementation of a robust 64-bit counter.

Esben Haabendal (6):
  net: gianfar: Convert to ndo_get_stats64 interface
  net: gianfar: Extend statistics counters to 64-bit
  net: gianfar: Clear CAR registers
  net: gianfar: Avoid 16 bytes of memset
  net: gianfar: Add definitions for CAR1 and CAM1 register bits
  net: gianfar: Implement rx_missed_errors counter

 drivers/net/ethernet/freescale/gianfar.c | 76 +++++++++++++++++-------
 drivers/net/ethernet/freescale/gianfar.h | 74 +++++++++++++++++++++--
 2 files changed, 125 insertions(+), 25 deletions(-)

-- 
2.32.0

